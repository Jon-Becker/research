
Given a word, we first check if this word may be a valid pointer to an ABI-encoded dynamic type. Let's take a look at how this check works behind the scenes.

1. Initialize a `HashSet<usize>` called `word_coverages` (not to be confused with `covered_words`) with `parameter_index`. We'll use this `HashSet` to keep track of which words we've covered while attempting to ABI-decode the current word.
2. Then, we'll validate that the current word at `parameter_index` could be an ABI-encoded dynamic type.
    1. First, we'll parse `calldata_words[parameter_index]` into a `U256`, and call this `offset`.
    2. Next, we check if this may be a valid offset pointer by asserting that assumption (3) holds. If it does not, we return `Err(Error::BoundsError)`.
    3. Now we check if `offset / 32` is a valid pointer to a word in `calldata_words`. If it is not, we return `Err(Error::BoundsError)`. Assign `offset / 32` to `word_offset`, as it is the offset of the word in `calldata_words` rather than the offset of the byte in `calldata`.

Let's perform this check on our example calldata. The first word

```text
0000000000000000000000000000000000000000000000000000000000000123
```

does not satisfy our pointer validation check, since `U256::from(0x123) = 291` does not pass assumption (3). We now know this is a static type. Let's move on to the next word:

```text
0000000000000000000000000000000000000000000000000000000000000080
```

This word is more promising. `U256::from(0x80) = 128` passes assumption (3), and `calldata_words[4]` is the beginning of a valid word. We now know this may be an ABI-encoded dynamic type, so we'll continue with the decoding process for this word. For now let's repeat these steps for the remaining words in `calldata_words`:

```text
3132333435363738393000000000000000000000000000000000000000000000 - assumption (3) does not hold
00000000000000000000000000000000000000000000000000000000000000e0 - this is a valid pointer to `calldata_words[7]`
0000000000000000000000000000000000000000000000000000000000000002 - assumption (3) does not hold
0000000000000000000000000000000000000000000000000000000000000456 - assumption (3) does not hold
0000000000000000000000000000000000000000000000000000000000000789 - assumption (3) does not hold
000000000000000000000000000000000000000000000000000000000000000d - assumption (3) does not hold
48656c6c6f2c20776f726c642100000000000000000000000000000000000000 - assumption (3) does not hold
```

Great! We've identified potential ABI-encoded types at parameters 1 and 3. Now we'll attempt to determine which dynamic types these parameters represent. Here's how this process works:

1. Add `word_offset` to `word_coverages`. Now this word is considered covered, since it is the start of a potential ABI-encoded dynamic type. `word_coverages` now contains `parameter_index` and `word_offset`. (i.e. parameter 1 has `word_offset = 4`, so `word_coverages = {1, 4}`).
2. If you recall from earlier, the offset of a dynamic type points to the `size` or `length` of the dynamic data. So, we'll parse `calldata_words[word_offset]` into a `U256`, and call this `size`.
3. Next, we'll check if $(\text{word\_offset} + \text{size} + 1) \gt \text{calldata\_words.len()}$
    - If this is true, then this type can't possibly be an array, since there aren't enough words remaining in `calldata_words` to store the array elements!
    - If this is false, then this type may be an array, so we'll continue with the decoding process for this word.

Going back to our example, we'll perform this check on parameter 1:

```text
word_offset = 4
calldata_words[4] = 0000000000000000000000000000000000000000000000000000000000000002
size = 2
word_offset + size + 1 = 7
calldata_words.len() = 9
7 <= 9, so this dynamic type may be an array!
```

And for parameter 3:

```text
word_offset = 7
calldata_words[7] = 000000000000000000000000000000000000000000000000000000000000000d
size = 13
word_offset + size + 1 = 21
calldata_words.len() = 9
21 > 9, so this dynamic type cannot be an array. (But it can still be `bytes` or `string`!)
```

#### Handling Arrays

We still need to validate that this parameter is indeed an array. Here's how we do that:

1. First, slice `calldata_words` from `word_offset + 1` to `word_offset + size + 1`. We'll call this `data_words`.

    - For our example (parameter 1), `data_words` is:

        ```text
        0000000000000000000000000000000000000000000000000000000000000456
        0000000000000000000000000000000000000000000000000000000000000789
        ```

#### Handling Bytes

The `size` of this dynamic type suggests that it may be `bytes`, but we still need to validate this. Here's how we do that:

1. First, slice `calldata_words` from `word_offset + 1` onwards. We'll call this `data_words`.

2. Check $size \le 32$:

    - If this is true, then the entire `bytes` is contained within a single word, so we only need to perform a padding check on `data_words[0]`.

        1. Call `get_padding_size(data_words[0])`. If $\text{padding\_size} \gt 32 - \text{size}$, then this is not a valid `bytes` type, since `size` bytes cannot be encoded in a word of length `32 - padding_size`. Return `Ok(None)`.

    - If this is false, then the `bytes` spans multiple words, so we need to perform a few extra steps:
        1. Figure out how many words are needed to store the `bytes` with size `size`. This can be done with the following formula: $\text{words\_needed} = \lceil \frac{\text{size}}{32} \rceil$.
        2. If there are not enough words remaining in `calldata_words` to store the `bytes`, return `Err(Error::BoundsError)`.
        3. Otherwise, perform the same bounds check as above on the `last_word`, which we define as `data_words[words_needed - 1]`.

3. Great! We've validated that this parameter is indeed a valid `bytes` type. Now, we just need to update word coverages to include all validated word indices, and return `Ok(Some(ParamType::Bytes))`.

For our example (parameter 3), `data_words` is:

```text
48656c6c6f2c20776f726c642100000000000000000000000000000000000000
```

which has `size = 13`. Since $13 \le 32$, we only need to perform a padding check on `data_words[0]`:

```text
padding_size = get_padding_size(48656c6c6f2c20776f726c642100000000000000000000000000000000000000) = 14.
14 < 32 - 13, so this is a valid `bytes` type!
word_coverages = {3, 7, 8}
```

