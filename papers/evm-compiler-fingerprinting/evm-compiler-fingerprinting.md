#  t l d r

![preview](https://img.freepik.com/premium-vector/seamless-greek-key-luxury-background-pattern-texture_231786-8994.jpg?fw)

Despite what you might think, compilers are not black boxes. They are complex, deterministic systems that produce machine code from high-level programming languages through a series of well-defined steps. This means that the output of a compiler is not just a random sequence of bytes, but a structured and predictable representation of the original source code. In fact, the output of a compiler is just as much a reflection of the compiler itself as it is of the source code it was given.

In this highly theoretical paper, we'll dive into EVM bytecode and examine distinct patterns and markers left by different major EVM compilers. We'll also explore the potential for using these patterns to identify the compiler used to generate a given contract's bytecode.

## Brief: EVM Bytecode and Compilers

The compiler generates EVM bytecode by translating the high-level code into a series of instructions (opcodes) that represent the program's logic. Compilers are extremely complex systems that can be broken down into several stages:

1. **Lexical Analysis**: The compiler reads the source code and converts it into a stream of tokens. This may also be referred to as tokenization.
2. **Syntax Analysis**: The compiler parses the tokens and builds an abstract syntax tree (AST) that represents the structure of the program.
3. **Semantic Analysis**: The compiler checks the AST for semantic errors and performs type checking.
4. **IR Generation**: The compiler translates the AST into an intermediate representation (IR) that is closer to the target machine code. In the case of EVM, this intermediate representation is typically in the form of EVM assembly or an IR such as Yul.
5. **Optimization**: The compiler optimizes the IR to improve the efficiency of the generated code.
6. **Code Generation**: The compiler translates the optimized IR into machine code. In the case of EVM, this machine code is EVM bytecode.

Through this process, the compiler leaves distinct patterns and markers in the generated bytecode that can be used to identify the compiler which generated it.

### Existing Known Heuristics

One of the most well-known heuristics for identifying the compiler used to generate a given contract's bytecode is by examining the first few operations in the bytecode. 

#### Solidity

Solc typically uses the following sequences of opcodes as the first few instructions in the bytecode:

- `0x60 0x80 0x60 0x40 0x52` (indicates solc `0.4.22+`)
- `0x60 0x60 0x60 0x40 0x52` (indicates solc `0.4.11-0.4.21`)

The solidity compiler begins execution by initializing memory that the program will use. For those interested, the exact Solidity memory layout can be found [here](https://docs.soliditylang.org/en/latest/internals/layout_in_memory.html).

#### Vyper

Vyper typically uses the following sequences of opcodes as the first few instructions in the bytecode:

- `0x60 0x04 0x36 0x10 0x15` (indicates vyper `0.2.0-0.2.4,0.2.11-0.3.3`)
- `0x34 0x15 0x61 0x00 0x0a` (indicates vyper `0.2.5-0.2.8`)

The vyper compiler begins execution immediately in it's dispatcher, which is why the first few opcodes are different from Solidity.

### CBOR Encoding

When a contract is compiled, the compiler may include metadata in the bytecode that can be used to identify the exact compiler version used to generate the bytecode. This metadata is encoded in a partial CBOR format:

1. Encode `vyper` or `solc` as hex string: `0x7970657283` and `0x736f6c6343` respectively.
2. Append the version as a 3-byte hex string: `0x000817` for version `0.8.21`. For example, the metadata `0x736f6c6343000817` would be equivalent to `solc 0.8.21`.

However, this metadata is not always present in the bytecode as users can opt to exclude it from the deployed bytecode.

## Methodology

If we can already roughly identify the compiler used to generate a contract's bytecode by examining the *first few operations* in the bytecode, how accurate can we be if we examine the *entire bytecode*? The process we'll take to answer this question is as follows:

1. **Data Collection**: We collect a random sample of 5,000 verified contract bytecode for both Solidity and Vyper from Etherscan.
2. **Data Classification**: Using the known heuristics and patterns, we classify the contracts into three groups: Solidity, Vyper, and Unknown.
3. **Pattern Analysis**: We analyze the bytecode of the contracts in each group to identify distinct patterns and markers that can be used to fingerprint the compiler.
4. **Results**: Using the patterns and markers identified, we will re-classify the contracts and evaluate the accuracy of our fingerprinting method. The goal is to reduce the number of contracts classified as "Unknown" and increase the accuracy of the classification.

> _Note: I've opted not to take AI/ML approach to this problem as I would rather be able to reason about the patterns and markers left by the compilers rather than rely on a black-box model which simply outputs a prediction._

### 1. Data Collection

We collected a random sample of 5,000 verified contracts for both Solidity and Vyper from Etherscan, saving their exact compiler version in a CSC. 

Those interested can view the full raw data [here](https://gist.github.com/Jon-Becker/fc0869c1a1090f3b4211d0d888bdd95a), but here's a slice of the data:

```csv
address,compiler_version
0xef672bd94913cb6f1d2812a6e18c1ffded8eff5c,vyper:0.3.1
0x10ac65a9f710c3d607d213784e5b8632c77d5d4f,vyper:0.3.1
0x0199429171bce183048dccf1d5546ca519ea9717,vyper:0.3.1
0x1c3a367f8b2e921d2476870576fcf91670017897,vyper:0.3.9
...
0xa21a59cc2375368fceb08898403fa7331b6531ad,v0.5.10+commit.5a6ea5b1
0xeb08b206271350fcc9ae1cad1e27f348a2055600,v0.5.14+commit.1f1aaa4
0x118cd20b58b069a2df45531cae31d1121fa4c310,v0.4.17+commit.bdeb9e52
0xa6ead154167d2e712936b8ebc22b66903c46047c,v0.5.17+commit.d19bba13
```

We can then fetch the bytecode for each contract using JSON-RPC. We'll also prune pushed bytes from the bytecode since they would make pattern matching more difficult. For example, `0x60 0x80 0x60 0x40` (`PUSH1 0x80 PUSH1 0x40`) would become `0x60 0x60` (`PUSH1 PUSH1`).

### 2. Data Classification

Now that we have a list of contracts and their pruned bytecode, we'll use the known heuristics to classify the contracts, and save this mapping to [contracts.json](https://gist.github.com/Jon-Becker/9e5c9eb38236ac5d7baf8893527eb3d4). We used known heuristics rather than exact compiler versions from Etherscan to ensure that we have an accurate benchmark for where our classification accuracy is at now.

```json
{
    "Proxy": {
        "0x3fc90d031eecc364c620166ee7a791a151a16062": "0x3660603761603660735a...",
        ...
    },
    "Unknown": {
        "0xdf1b41413eafccfc6e98bb905feaeb271d307af3": "0x5f35601c60608216601b...",
        ...
    },
    "Solc": {
        "0x29109547921fb1978bbbe192f37e546de454dcdb": "0x60605236156157637c6...",
        ...
    },
    "Vyper": {
        "0x8d0f9c9fa4c1b265cd5032fe6ba4fefc9d94badb": "0x603611615761565b603...",
        ...
    }
}
```

Given this mapping, our current accuracy given known heuristics is roughly 62.2%, with our known heuristics covering 6216 contracts out of 10000.

We can do better.

### 3. Pattern Analysis




## Findings

TODO

## Potential Applications

The ability to fingerprint the compiler used to generate a contract's bytecode has several potential applications:

1. Vulnerability Scope Analysis: In July 2023, a critical vulnerability was discovered in the Vyper compiler which lead to [a series of exploits](https://hackmd.io/@vyperlang/HJUgNMhs2), affecting contracts compiled with Vyper versions `0.2.15`, `0.2.16`,  and `0.3.0`. A heuristic to identify contracts compiled with these versions may have helped to identify and mitigate the impact of the vulnerability sooner. 

    _Note: A bytecode-specific heuristic would be more effective than searching for all verified contracts as it would also be able to identify unverified contracts._

2. Smart-Contract Analysis: When working with unverified contract bytecode, it can be useful to know which compiler was used to generate the bytecode. Tools such as [heimdall](https://heimdall.rs)'s decompiler can use this information to provide more accurate decompilation results.

## Conclusion

TODO