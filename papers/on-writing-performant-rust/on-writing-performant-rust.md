# On Maximizing Your Rust Code's Performance

![preview](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/on-writing-performant-rust/preview.png?fw)

While following the rules of Rust will get you a long way, it's still very possible to write bad, inefficient programs in Rust. In order to maximize the performance of your Rust applications, you'll need to understand the underlying hardware architecture that powers your code, how to optimize your algorithms and data structures, and how to profile and benchmark your code. In this article, we'll briefly cover these topics and more, hopefully giving you a better understanding of how to write performant Rust code.

This article assumes that you have basic knowledge of Rust, including its syntax, intricacies, and rules. If you're new to Rust, I recommend starting with the [official Rust documentation](https://doc.rust-lang.org/book/) and [tutorials](https://github.com/rust-lang/rustlings) before diving into performance optimization. Remember, you never want to optimize prematurely!

## Understanding Hardware Architecture

In order to start writing more efficient Rust code, you should first have a basic understanding of a machines underlying hardware architecture, including the CPU, memory hierarchy, and the cache. Understanding these concepts can help you make more informed decisions about how you structure your code and data to take advantage of the hardware's capabilities.

### The CPU

The CPU is basically the computer's processing powerhouse. It executes instructions and carries out calculations, making it one of the most important components when it comes to performance.

The CPU consists of multiple cores, each capable of executing instructions independently. In order to fully utilize the CPU's capabilities, it's important to write code that takes advantage of parallelism and concurrency where possible.

Let's say we have a large collection of images that need to be resized. If we do so sequentially, it'll take a long time since each iteration has to wait for the previous one to finish. For example, this function handles image resizing sequentially in a `for` loop:

```rust
fn resize_images_sequentially() {
    // Load a collection of images
    let images = vec![
        "image1.png",
        "image2.png",
        "image3.png",
		...
    ];

    for image_path in images {
        // Load the image from disk
        let img = image::open(image_path).expect("Failed to open the image");

        // Resize the image
        let resized_img = resize_image(img);

        // Save the resized image to disk
        let output_path = format!("resized_{}", image_path);
        resized_img.save(output_path).expect("Failed to save the resized image");
    }
}
```

Using parallelism, we can distribute the resizing task across many CPUs cores, allowing us to process multiple images simultaneously. Lucky for us, Rust's standard library comes packed with [helpful multithreading features](https://doc.rust-lang.org/book/ch16-00-concurrency.html), so we can start easily implement multithreading in a memory-safe way. Here's the same function as before, but this time it uses threads to resize the images in parallel:

```rust
fn resize_images_in_parallel() {
    // Load a collection of images
    let images = vec![
        "image1.png",
        "image2.png",
        "image3.png",
        ...
    ];

    let mut handles = vec![];

    for image_path in images {
        // Spawn a new thread for each image processing task
        handles.push(thread::spawn(move || {
            // Load the image from disk
            let img = image::open(image_path).expect("Failed to open the image");

            // Resize the image
            let resized_img = resize_image(img);

            // Save the resized image to disk
            let output_path = format!("resized_{}", image_path);
            resized_img.save(output_path).expect("Failed to save the resized image");
        }));
    }

    // Wait for all threads to finish
    for handle in handles {
        handle.join().unwrap();
    }
}
```

Parallelism and concurrency can significantly speed up your code, and you should try to use it wherever it proves effective. As you can see, the parallel function finished over twice as fast as the sequential one:

<details>
<summary>benchmark</summary>

```text
benchmark_resize_images_concurrently:
    104.509ms ± 25.90ms per run ( with 100_000 runs ).
benchmark_resize_images_in_parallel:
    219.319ms ± 71.21ms per run ( with 100_000 runs ).
```

</details>

### Memory Hierarchy

Memory hierarchy refers to the different levels of memory in a computer system, ranging from fast but small caches to slower but larger main memory.

![memory heirarchy](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/on-writing-performant-rust/1.png?fw)

When writing efficient Rust code, it's important to minimize cache misses by optimizing the data structures and algorithms that you use in your program. This involves organizing your data in a way that maximizes spatial locality (accessing nearby memory locations) and temporal locality (reusing recently accessed data).

A simple example of this is using structs to group related data together, which can improve spatial locality because struct elements are more likely to reside close to eachother, reducing cache misses. Rather than doing something like:

```rust
let x = 1;
let y = 2;
let z = 3;

// do something with x, y, and z
```

You can group the variables in a struct:

```rust
struct XYZ {
    x: i32,
    y: i32,
    z: i32,
}

let xyz = XYZ { x: 1, y: 2, z: 3 };

// do something with xyz.x, xyz.y, and xyz.z
```

This allows you to access the variables in a more cache-friendly manner, improving spatial locality and reducing cache misses. Keep in mind that you should only use this technique when it makes sense for your program. If you don't need to access the variables together, then there's no point in grouping them into a struct.

Another technique is to use try using slices instead of linked lists or other dynamic data structures wherever possible. Slices provide better spatial locality because the elements are stored next to each other in memory, so accessing them is faster than accessing elements scattered throughout memory.

For example, consider a program that needs to iterate over a collection of integers. Instead of using a linked list:

```rust
let mut list = LinkedList::new();
list.push_back(1);
list.push_back(2);
list.push_back(3);

for item in list {
    // do something with item
}
```

You can use a statically sized slice instead:

```rust
let array = [1, 2, 3];

for item in &array {
    // do something with item
}
```

By using a slice here, you are accessing adjacent elements in memory, which improves spatial locality and reduces cache misses If you had used a linked list, the elements could be scattered throughout memory, potentially resulting in more cache misses and slower processing time.

Overall, understanding the memory hierarchy and optimizing your code accordingly can lead to significant performance improvements. By paying attention to how you use and access data in memory, you can effortlessly improve your code.

### The Cache

The cache is a small but extremely fast type of memory that stores frequently accessed data. It acts as a buffer between the CPU and main memory, allowing for faster access to data stored in its registers.

One way to optimize cache behavior is by using data structures that have good cache locality. As mentioned earlier, slices are a great choice because they store elements next to each other in memory. This means that accessing elements in an array is more likely to result in cache hits, which can improve performance.

Another technique is to use data structures that are designed for cache efficiency, such as the [packed_simd](https://github.com/rust-lang/packed_simd) crate. Packed SIMD (Single Instruction, Multiple Data) allows you to perform computations on multiple values simultaneously, which can greatly improve performance. By utilizing packed SIMD instructions, you can process large amounts of data with fewer instructions and reduce memory accesses.

By understanding what the cache is and how it works, you can make more informed decisions about how you structure your code and data to take advantage of its capabilities, which can lead to significant performance improvements.

## Profiling and Benchmarking

Profiling and benchmarking your code is an essential step in optimizing its performance. Profiling allows you to identify bottlenecks and areas of improvement in your code, while benchmarking helps you measure the impact of optimizations and compare different implementations.

### Profiling

Profiling involves analyzing the runtime behavior of your code to identify areas that consume a significant amount of time or resources. There are several profiling tools available for Rust, such as [perf](https://perf.wiki.kernel.org/index.php/Main_Page), [Valgrind](http://valgrind.org/), and [flamegraph](https://github.com/flamegraph-rs/flamegraph). We'll talk more about Valgrind when we discuss [inlining](#inlining). For now, let's talk about flamegraph.

Flamegraph is a popular profiling tool for Rust which generates a visual graph of your program's runtime stack trace. These graphs, called flame graphs, provide a visual representation of where time is spent in your code, making it easier to pinpoint performance bottlenecks.

To get started with flamegraph, first install it via:

```bash
cargo install flamegraph
```

Then, you can use the `cargo flamegraph` command to test your compiled binaries:

```bash
cargo flamegraph --deterministic --bin=heimdall -- decompile 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2 -d -vvv --include-sol --skip-resolving
```

Which produces the following `flamegraph.svg`:

![flamegraph.svg](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/on-writing-performant-rust/2.png?fw)

As you can see, the flame graph provides a visual representation of the time spent in different parts of your code. Within a flame graph:

-   Each box represents a stack frame, or a function call.
-   The height represents the stack depth, with the most recent stack frames on the top and older ones towards the bottom. Children reside above the function that called them. For example, `heimdall_common::ether::evm::disassemble::disassemble` was called by `heimdall::decompile::decompile`, so it appears above the decompile frame on the flame graph.
-   The width of a frame represents the total time a function, or one of its children, is being processed. You can hover over a frame for more details, and click on a frame to expand it for a more granular view.
-   The color of each frame doesn't matter and is randomized, unless you use the `--deterministic` flag which will keep function/color consistency across runs.

In this example, you can see that most of the processing time is spent within `heimdall::decompile::decompile`, with a suspiciously large box for `regex::compile::Compiler::compile`, which indicates that there might be room for some improvement here.

### Benchmarking

Benchmarking involves measuring the performance of your code to compare different implementations or optimizations. Rust provides a built-in benchmarking framework called [Criterion](https://bheisler.github.io/criterion.rs/book/index.html).

To use Criterion, add it as a dependency in your `Cargo.toml`:

```toml
[dev-dependencies]
criterion = { version = "0.5.3", features = ["html_reports"] }

[[bench]]
name = "my_benchmark"
```

Then, you can write your benchmark in `./benches/my_benchmark`:

```rust
use criterion::{black_box, criterion_group, criterion_main, Criterion};

fn fibonacci(n: u64) -> u64 {
    match n {
        0 => 1,
        1 => 1,
        n => fibonacci(n-1) + fibonacci(n-2),
    }
}

fn criterion_benchmark(c: &mut Criterion) {
    c.bench_function("fib 20", |b| b.iter(|| fibonacci(black_box(20))));
}

criterion_group!(benches, criterion_benchmark);
criterion_main!(benches);
```

Finally, run this benchmark with:

```bash
cargo bench
```

Always remember to benchmark your code when making optimizations to ensure that the changes you make actually improve your program's performance. If the benchmarks don't show a speed improvement significant enough to warrant the optimization, it's probably not worth including.

## Optimizing Algorithms and Data Structures

Another key aspect of writing efficient Rust code is optimizing the algorithms and data structures that you use within your programs. By choosing the right algorithms and data structures for your problem, you can significantly improve the efficiency of your code.

### Choosing the Right Data Structure

The choice of algorithm can have a huge impact on the performance of your code. Some algorithms are inherently more efficient than others for certain types of problems. It's important to choose an algorithm that is well-suited to your problem domain.

For example, the standard `HashMap` data structure in Rust is implemented as a hash table, which provides constant-time average case lookup, insertion, and deletion operations. However, for special use cases, other data structures with similar functionality might work better here. If you need to maintain a sorted collection of elements and frequently perform range queries or insertions/deletions at arbitrary positions, a balanced binary search tree like `BTreeSet` or `BTreeMap` may be more appropriate. These data structures provide logarithmic-time operations for these types of operations, which can be more efficient than hash tables in some cases.

Make sure to carefully consider which data structure is best suited for your problem, as choosing the right data structure can have a huge impact on the performance of your code.

### Optimizing Algorithms and Functions

In addition to choosing the right data structure, optimizing the algorithms and functions you use can also greatly improve the efficiency of your programs.

#### Caching Results

One common optimization technique is caching function results. If a function may be called multiple times with the same input, you can cache the result and return it instead of recomputing it every time. This can be especially useful for reducing the amount of expensive computations that need to be performed.

Let's say you have an expensive function that performs a database query and returns it's result. If you call this function multiple times with the same input, you can simply save the result and return it instead of expensively recomputing the result every time. This can significantly improve the performance and efficiency of your code. _It's important to keep in mind that if the data changes, you'll need to invalidate the cache and recompute the result._

```rust
use std::collections::HashMap;

fn get_data_from_database(id: u32, cache: &mut HashMap<u32, String>) -> String {
    if let Some(data) = cache.get(&id) {
        return data.clone();
    }

    let data = perform_expensive_database_query(id);
    cache.insert(id, data.clone());
    data
}

fn perform_expensive_database_query(id: u32) -> String {
    // Simulating an expensive database query
    println!("Performing database query for ID {}", id);
    // ... actual database access and retrieval of data ...
    let data = format!("Data for ID {}", id);
    data
}

fn main() {
    let mut cache: HashMap<u32, String> = HashMap::new();

    // Query data from the database multiple times
    for _ in 0..5 {
        let id = 42;
        let data = get_data_from_database(id, &mut cache);
        println!("Data: {}", data);
    }
}
```

Running the above code, we can see that the database query is only performed once, even though we called the `get_data_from_database` function multiple times with the same input. This is because we cache the result and return it instead of recomputing it every time, saving us from performing the expensive lookup multiple times.

```text
Performing database query for ID 42
Data: Data for ID 42
Data: Data for ID 42
Data: Data for ID 42
Data: Data for ID 42
Data: Data for ID 42
```

#### Understanding Time & Space complexity

Understanding the time complexity of your algorithms is crucial for writing efficient code. Time complexity describes how the runtime of an algorithm grows as the size of the input increases. By choosing algorithms with better time complexity, you can significantly improve the performance of your code.

For example, let's say you wanted to sort a list of $10,000$ items. If you use a simple bubble sort algorithm, which has a time complexity of $O(n^2)$, it would take an average of $100,000,000$ operations to sort the list. However, if you use a more efficient sorting algorithm like quicksort, which has an average time complexity of $O(n\ log\ n)$, it would take roughly $130,000$ operations, which is significantly faster.

Understanding the time complexity of different algorithms allows you to choose the most efficient one for your specific problem. It's important to consider factors like the size of your input and any constraints or requirements you have when selecting an algorithm. For more on time and space complexity, check out [this article](https://levelup.gitconnected.com/a-beginners-guide-to-analysing-time-and-space-complexity-31e1677f5f5b).

### Memory Optimization

In addition to optimizing algorithms and data structures, memory optimization is another important aspect of writing efficient Rust code. By minimizing memory usage and maximizing cache locality, you can drastically improve the performance of your programs.

#### Specify Capacity When Known

In Rust, you can use the `Vec` type for dynamic arrays. When adding elements to a `Vec`, it automatically manages the underlying buffer and reallocates it when necessary. However, this reallocation process involves allocating new memory, copying existing elements over, and deallocating the old buffer.

To avoid unnecessary reallocations, you can preallocate a `Vec` with an initial capacity using the `with_capacity` method:

```rust
let mut vec = Vec::with_capacity(100);
```

By providing an initial capacity that matches or exceeds your expected number of elements, you can reduce or eliminate reallocations during runtime. This type of optimization also works with data structures that reallocate memory, such as `String` and `HashMap`.

For example, if you know that you will be adding 100 elements to a `Vec`, you can use the `with_capacity` method to preallocate the necessary memory:

```rust
let mut vec = Vec::with_capacity(100);

for i in 0..100 {
    vec.push(i);
}
```

In this case, the `Vec` is initialized with a capacity of 100, so it does not need to reallocate memory during the loop. This can improve performance by avoiding unnecessary memory allocations and copying.

<details>
<summary>benchmark</summary>

```text
benchmark_vec_with_capacity:
    348μs 233ns ± 181μs 355ns per run ( with 100000 runs ).
benchmark_vec_many_reallocations:
    361μs 826ns ± 151μs 918ns per run ( with 100000 runs ).
```

</details>

#### Use Buffers When Possible

Additionally, consider reusing existing buffers instead of creating new ones whenever possible. This also avoids unnecessary memory management operations and can improve your program's performance.

```rust
fn iterate_with_buffer() {
    let mut buffer = Vec::new();

    for i in 0..1000 {
        buffer.clear();
        buffer.push(i);
    }
}

fn iterate_with_new_vec() {
    for i in 0..1000 {
        let mut buffer = Vec::new();
        buffer.push(i);
    }
}
```

In this example, the `iterate_with_buffer()` function uses the same vector for each loop, clearing it before each iteration, while `iterate_with_new_vec()` creates a new vector for each loop. Using the existing vector allows you to reuse already allocated memory, avoiding any unnecessary memory operations.

<details>
<summary>benchmark</summary>

```text
benchmark_iterate_with_buffer:
    1μs 37ns ± 958ns per run ( with 100000 runs ).
benchmark_iterate_with_new_vec:
    42μs 615ns ± 6μs 992ns per run ( with 100000 runs ).
```

</details>

#### Avoid Unnecessary Cloning

In Rust, cloning an object creates a deep copy of the object, which can be expensive in terms of memory and performance. Therefore, it is important to avoid unnecessary cloning whenever possible.

One way to avoid unnecessary cloning is by using references instead of owned values. References allow you to borrow a value without taking ownership of it, which means you can access a read-only version of the value without needing to clone it:

```rust
fn do_something_inefficiently() {
    fn process_vec(vec: Vec<i32>) -> i32 {
        vec.iter().sum()
    }

    let vec = (0..1000).collect::<Vec<u128>>()

    for _ in 0..10_000 {
        process_vec(vec.clone());
    }
}

fn do_something_with_speed() {
    fn process_vec(vec: &Vec<i32>) -> i32 {
        vec.iter().sum()
    }

    let vec = (0..1000).collect::<Vec<u128>>()

    for _ in 0..10_000 {
        process_vec(&vec);
    }
}
```

By passing a reference to `vec`, you avoid cloning it and instead allow the function to borrow it's value temporarily. This eliminates unnecessary memory allocations and copying, improving performance. Don't worry about messing up this borrowing stuff, the compiler will tell you if you're doing something wrong.

A great tool for finding unnecessary clones is [clippy](https://github.com/rust-lang/rust-clippy), which is a general purpose linting tool for Rust. It can detect and warn you about unnecessary clones, among other things. Keep in mind that clippy won't catch everything, so it's important to keep an eye out for these types of optimizations yourself.

<details>
<summary>benchmark</summary>

```text
benchmark_do_something_inefficiently:
    35ns ± 77ns per run ( with 100000 runs ).
  benchmark_do_something_with_speed:
    30ns ± 105ns per run ( with 100000 runs ).
```

</details>

#### Use Enum Variants for Different Data Types

If you have a collection that can contain different types of elements, consider using an enum to represent the different variants. This allows you to store elements with different types in the same collection without wasting memory on padding or alignment requirements:

```rust
enum Element {
    Integer(i32),
    Float(f32),
}

fn main() {
    let mut elements: Vec<Element> = Vec::new();
    elements.push(Element::Integer(5));
    elements.push(Element::Float(3.14));

    for element in elements {
        match element {
            Element::Integer(i) => println!("Integer: {}", i),
            Element::Float(f) => println!("Float: {}", f),
        }
    }
}
```

In this example, the `Element` enum has two variants: `Integer` and `Float`, which can each hold a different type. Here, we create a vector of `Element`s and push different variants into it, which we can then iterate over and operate on seamlessly.

Using an enum with variants allows us to have a collection that can store different types of values without wasting memory. This is especially useful when dealing with heterogeneous data structures or when you want to represent multiple possibilities in a single variable.

#### Use Bitflags

If you have a collection of boolean values, consider using a bitflag instead of a vector of booleans. This can significantly reduce memory usage and improve performance. A bitflag is a data structure that stores boolean values as bits instead of bytes, which allows you to store multiple boolean values in a single byte.

For example, let's take a look at chess bitboards. A chess bitboard is a 64-bit integer that represents the state of a chessboard. Each bit in the integer represents a square on the board, with a value of 1 indicating that the square is occupied and a value of 0 indicating that it is empty. The starting position in chess can be represented as follows:

```text
1111111111111111000000000000000000000000000000001111111111111111
```

This bitboard represents the starting position in chess, with the first 8 bits representing the first row, the next 8 bits representing the second row, and so on. Each bit is set to 1 if the square is occupied and 0 if it is empty.

By combining bitboards, you can represent the state of the entire chessboard in just a few 64-bit integers. Allowing you to perform operations on the entire board at once, which can significantly improve performance. For more on bitboards, check out [this article](https://www.chessprogramming.org/Bitboards).

#### Use Cows

Another way to optimize memory usage in Rust is to use the `Cow`, or "clone on write" type. The `Cow` type allows you to have a value that can be either borrowed or owned, depending on whether it needs to be modified. When you have a value that may or may not need modification, using `Cow` can help avoid unnecessary cloning and memory allocations.

The `Cow` type provides two variants: `Borrowed`, which holds a reference to the original value, and `Owned`, which holds an owned copy of the value. For example:

```rust
use std::borrow::Cow;

fn process_string(s: Cow<&str>) {
    if s.len() > 10 {
        println!("Long string: {}", s);
    } else {
        println!("Short string: {}", s);
    }
}

fn main() {
    let short_string = "hello";
    let long_string = "this is a very long string";

    process_string(Cow::Borrowed(short_string));
    process_string(Cow::Borrowed(long_string));

    let cloned_long_string = long_string.to_owned();

    process_string(Cow::Owned(cloned_long_string));
}
```

In this example, the `process_string` function takes a `Cow<&str>` as its parameter, checks the length of the string and prints either "Long string" or "Short string" depending on its length.

In the `main` function, we create two string variables: `short_string` and `long_string`, which we then pass to the `process_string` function using `Cow::Borrowed`. Since these strings do not need modification, they are borrowed rather than cloned. Next, we create a new variable called `cloned_long_string`, which is an owned copy of the original long string. We pass this cloned string to the `process_string` function using the `Cow::Owned` variant, since we needed a mutable copy of the string.

By using the appropriate variant of `Cow`, we avoid unnecessary cloning and memory allocations. If a value does not need modification, it can be borrowed instead of being owned. Only when a value needs to be modified do we create an owned copy. For more information on `Cow`s, check out this [article](https://deterministic.space/secret-life-of-cows.html).

#### Avoid Collecting for Another Iteration

When working with collections in Rust, it's important to consider using iterators instead of collecting into another data structure just to iterate over it again. This can help optimize memory usage and improve performance.

For example, let's say we have a `Vec` of numbers and we want to find the sum of all even numbers:

```rust
fn sum_of_even_numbers(numbers: Vec<i32>) -> i32 {
    let even_numbers: Vec<i32> = numbers.into_iter().filter(|&x| x % 2 == 0).collect();
    even_numbers.iter().sum()
}
```

In this code, we first create a new `Vec` called `even_numbers` by filtering out all odd numbers from the original `numbers` vector. We then use the `iter()` method to create an iterator over the `even_numbers` vector and calculate their sum using the `sum()` method.

However, this approach is not memory-efficient because it requires creating a new vector just for iteration purposes. Instead, we can directly iterate over the filtered elements without collecting them into another data structure:

```rust
fn sum_of_even_numbers(numbers: Vec<i32>) -> i32 {
    numbers.into_iter().filter(|&x| x % 2 == 0).sum()
}
```

In this updated code, we directly iterate over the filtered elements using the `into_iter()` method and calculate their sum using the `sum()` method. This avoids creating a new vector and improves memory efficiency.

#### Use .get(i) over \[i]

When accessing elements in an array or vector, it is generally more memory-efficient to use the `.get(i)` method instead of the `[i]` indexing syntax. The `.get(i)` method returns an `Option` type that represents either a reference to the element at index `i`, or `None` if the index is out of bounds.

Using `.get(i)` allows you to handle cases where the index is out of bounds without causing a panic. This can be useful when working with user input or dynamically changing data. For example:

```rust
fn main() {
    let vec = vec![1, 2, 3];

    // Using indexing syntax
    let element = vec[1];
    println!("Element: {}", element);

    // Using .get(i)
    if let Some(element) = vec.get(1) {
        println!("Element: {}", element);
    } else {
        println!("Index out of bounds");
    }
}
```

In this example, both methods will print the value at index 1. However, if you were to use an invalid index like `vec[10]`, it would cause a panic and crash your program. On the other hand, using `.get(10)` would return `None` and allow you to handle the error gracefully.

### Inlining

Inlining is a compiler optimization technique that replaces a function call with the actual body of the function, which can improve performance by reducing the overhead of function calls and enabling further optimizations.

In Rust, you can use the `#[inline]` attribute to suggest to the compiler that a function should be inlined. The compiler may choose to honor this suggestion or not, depending on various factors such as code size and performance impact. For example:

```rust
#[inline]
fn add(a: i32, b: i32) -> i32 {
    a + b
}

fn main() {
    let result = add(1, 2);
    println!("Result: {}", result);
}
```

In this code, we define a simple `add` function that takes two integers and returns their sum. We annotate it with `#[inline]` to suggest inlining. When calling this function in the `main` function, the compiler may choose to inline it instead of generating a separate call instruction.

Inlining can improve performance by eliminating the overhead of function calls, since it allows for better optimization opportunities such as constant propagation and loop unrolling. However, it can also increase code size if used excessively and should be used sparingly.

#### Cachegrind

Cachegrind is a profiling tool that is part of the Valgrind suite which simulates a CPU cache hierarchy and provides detailed information about cache misses, cache hits, and other cache-related performance metrics.

To use Cachegrind with Rust programs, you can first compile your program with debug symbols using the `--debug` flag:

```
cargo rustc -- --emit=asm -C opt-level=3 --debug
```

This will generate assembly code for your Rust program, which you can then run through Cachegrind using the following command:

```
valgrind --tool=cachegrind ./target/debug/my_program
```

After execution completes, cachegrind will generate a report that includes information such as the total total number of instructions executed, the number of cache misses at each level, and the average cost per instruction. By analyzing this report, you can identify areas in your code where there are a high number of cache misses, indicating potential performance bottlenecks. You can then optimize these areas to improve cache utilization and overall program performance.

## Rust Build Configuration

Rust provides many build configuration options which allow you to control how the Rust compiler generates machine code and optimizes various aspects of your program.

### Release Mode

When compiling your Rust code, it's important to use the `--release` flag to enable optimizations. By default, Rust builds in debug mode, which includes additional checks and information for debugging purposes, sacrificing performance. To build your code with the release profile, use the following command:

```bash
cargo build --release
```

The `--release` flag tells Cargo to enable optimizations like inlining function calls, removing unnecessary checks, and optimizing data structures. This can result in significant performance improvements. Under the hood, this is the same as using the `RUSTFLAGS` `-C opt-level=3`.

### Link-Time Optimization

Link-time optimization is a technique that allows the compiler to perform optimizations across multiple translation units during the linking phase which can result in more aggressive optimizations and better runtime performance.

To enable LTO in your Rust code, you can use the `lto` option in your Cargo.toml file under the `[profile.release]` section:

```toml
[profile.release]
lto = fat
```

This will enable link-time optimization across all codegen units in your project, which can result in better performance but may increase the size of your binary. Keep in mind that enabling LTO may increase build times and memory usage, so it's important to consider the trade-offs for your specific project.

### Codegen Units

Codegen units are a compilation unit used by the Rust compiler to parallelize code generation. By default, the Rust compiler uses one codegen unit per CPU core, which allows for faster compilation times. However, using multiple codegen units can also improve runtime performance by allowing the compiler to optimize each unit independently.

You can control the number of codegen units used by the Rust compiler by setting the `codegen-units` option in your Cargo.toml file under the `[profile.release]` section:

```toml
[profile.release]
codegen-units = 1
```

This will instruct Cargo to use 1 codegen unit during release builds, which can help the compiler find more optimizations across crates in your project.

### Using an Alternative Allocator

By default, Rust uses the system's allocator for managing memory. However, in certain cases, you may want to use an alternative allocator that provides better performance or specific features.

To use an alternative allocator in your Rust code, you can specify it in your Cargo.toml file under the `[dependencies]` section:

```toml
[dependencies]
jemallocator = "0.3"
```

_Note that using an alternative allocator might not always result in better performance. It's important to benchmark your code to determine if it's worth using an alternative allocator._

### Compiler Flags

Rust provides several compiler flags that allow you to control various aspects of code generation and optimization. These flags can be set using the `RUSTFLAGS` environment variable or directly in your `Cargo.toml` file.

Here are some commonly used compiler flags:

-   `-C target-cpu`: Specifies the target CPU architecture. This allows the compiler to generate machine code optimized for a specific CPU. For example, setting `target-cpu` to `native` will tell the compiler to look for optimizations for this machines CPU.
-   `-C debuginfo`: Controls whether debug information is included in the generated binary. Disabling debug info can reduce binary size but makes debugging more difficult.
-   `-C panic=abort`: Changes how panics are handled by aborting instead of unwinding, which can improve performance at the cost of not being

## Conclusion

Writing efficient code in Rust goes beyond merely adhering to the language's rules. It requires a deep understanding of the underlying hardware architecture, careful optimization of algorithms and data structures, minimizing memory allocations, leveraging parallelism, and proficiently profiling your code to pinpoint bottlenecks. In this article, we explored a range of techniques and best practices that can significantly enhance the performance of your Rust programs.

Hopefully, this article has helped you become a better (and more performant) rustacean. If you have any questions or suggestions, feel free to reach out to me on [Twitter](https://twitter.com/BeckerrJon). Thank you!

---

### Resources & Citations

-   Pascal Hertleif, "The Secret Life of Cows", Deterministic Space, Jun 2018. Available: https://deterministic.space/secret-life-of-cows.html
-   Unknown, "Bitboards", Chess Programming Wiki, Mar 2022. Available: https://www.chessprogramming.org/Bitboards
-   Rust Team, Clippy, GitHub, Jul 2021. Available: https://github.com/rust-lang/rust-clipp
-   Tara Dwyer, "A Beginner’s Guide to Analysing Time and Space Complexity", Medium, Jun 2023. Available: https://levelup.gitconnected.com/a-beginners-guide-to-analysing-time-and-space-complexity-31e1677f5f5b
-   Brook Heisler, Criterion, GitHub, Jan 2021. Available: https://bheisler.github.io/criterion.rs/book/index.html
-   flamegraph-rs, Flamegraph, GitHub, Jun 2023. Available: https://github.com/flamegraph-rs/flamegraph
-   Valgrind Developers, Valgrind, Valgrind, Jul 2023. Available: http://valgrind.org/
-   Unknown, Perf, Perf Wiki, Feb 2023. Available: https://perf.wiki.kernel.org/index.php/Main_Page
-   Rust Team, Packed_SIMD, GitHub, Jul 2021. Available: https://github.com/rust-lang/packed_simd
-   Rust Team, Concurrency, Rust Book, Jul 2023. Available: https://doc.rust-lang.org/book/ch16-00-concurrency.html
-   Rust Team, Rust Book, Rust Book, July 2023. Available: https://doc.rust-lang.org/book/
-   Rust Team, Rustlings, GitHub, July 2023. Available: https://github.com/rust-lang/rustlings
