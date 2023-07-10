# Maximizing Your Rust Code's Performance

![preview](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/on-writing-performant-rust/preview.png?fw)

Writing efficient code in Rust requires much more than just following the language's rules. It also involves understanding the underlying hardware architecture, optimizing algorithms and data structures, minimizing memory allocations and copying, leveraging parallelism when possible, and profiling your code to identify bottlenecks. In this article, we'll dive into the world of writing efficient Rust code by explore techniques and best practices that can help dramatically improve the performance of your Rust programs.

This article assumes that you have basic knowledge of Rust, including its syntax, intricacies, and rules. If you're new to Rust, I recommend starting with the [official Rust documentation](https://doc.rust-lang.org/book/) and [tutorials](https://github.com/rust-lang/rustlings) before diving into performance optimization.

## Understanding the Hardware Architecture

In order to start writing efficient Rust code, you should first have a basic understanding of the underlying hardware architecture. This includes things like the CPU, memory hierarchy, and cache. Understanding these concepts can help you make informed decisions about how to structure your code and data to take advantage of the hardware's capabilities.

### The CPU

The CPU is the like computers processing powerhouse. It executes instructions and carries out calculations, making it one of the most important components when it comes to performance.

The CPU consists of multiple cores, each capable of executing instructions independently. In order to fully utilize the CPU's capabilities, it's important to write code that can take advantage of parallelism.

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

By leveraging parallelism, we can distribute the resizing task across multiple CPU cores, allowing us to process multiple images simultaneously and significantly reducing the overall processing time. Luckily, Rust's standard library comes packed with [parallelism and concurrency](https://doc.rust-lang.org/book/ch16-00-concurrency.html) features, so we can start multi-threading out of the box:

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

In this code, we take advantage of being able to use multiple CPU cores by handling the resize task at the same time for all the images. This can significantly speed up your code, and you should try to use it wherever it proves effective. Benchmarking the above functions, we can see that the parallel version is much faster than the sequential one:

```text
benchmark_resize_images_concurrently:
    104.509ms ± 25.90ms per run ( with 100_000 runs ).
  benchmark_resize_images_in_parallel:
    219.319ms ± 71.21ms per run ( with 100_000 runs ).
```

### Memory Hierarchy

The memory hierarchy refers to the different levels of memory in a computer system, ranging from fast but small caches to slower but larger main memory. Accessing data from higher levels of the hierarchy is faster than accessing data from lower levels.

![memory heirarchy](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/on-writing-performant-rust/1.png?fw)

When writing efficient Rust code, it's important to minimize cache misses by optimizing your data structures and algorithms. This involves organizing your data in a way that maximizes spatial locality (accessing nearby memory locations) and temporal locality (reusing recently accessed data).

A simple example of this is using structs to group related data together, which can improve spatial locality. By accessing the fields of a struct together, you are more likely to access nearby memory locations, reducing cache misses. Rather than doing something like:

```rust
let x = 1;
let y = 2;
let z = 3;

// do something with x, y, and z
```

You can group the variables together in a struct:

```rust
struct XYZ {
    x: i32,
    y: i32,
    z: i32,
}

let xyz = XYZ { x: 1, y: 2, z: 3 };

// do something with xyz.x, xyz.y, and xyz.z
```

This way, accessing `xyz.x`, `xyz.y`, and `xyz.z` is more likely to access nearby memory locations. You should only do this where grouping those variables makes sense, however.

Another optimization technique is to use try using arrays instead of linked lists or other dynamic data structures wherever possible. Arrays provide better spatial locality because the elements are stored next to each other in memory, so accessing them is faster than accessing elements scattered throughout memory.

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

You can use an array:

```rust
let array = [1, 2, 3];

for item in &array {
    // do something with item
}
```

By using an array, you are accessing adjacent elements in memory, which improves spatial locality and reduces cache misses.

In addition to optimizing data structures and algorithms, it's also important to be aware of the memory hierarchy when designing your code. For example, if you have a computationally intensive loop that operates on a large dataset, you may want to break up the loop into smaller chunks to improve temporal locality. This allows the CPU to keep more data in its cache for faster access.

Overall, understanding the memory hierarchy and optimizing your code accordingly can lead to significant performance improvements. By paying attention to how you use and access data structures, you can effortlessly improve your code.

### Cache

The CPU cache is a small but extremely fast type of memory that stores frequently accessed data. It acts as a buffer between the CPU and main memory, allowing for faster access to data.

When writing efficient Rust code, it's important to be aware of cache behavior and optimize your code accordingly. This includes minimizing cache misses by organizing your data in a cache-friendly manner and avoiding unnecessary memory allocations and copying.

One way to optimize cache behavior is by using data structures that have good cache locality. As mentioned earlier, arrays are a good choice because they store elements contiguously in memory. This means that accessing elements in an array is more likely to result in cache hits.

Another technique is to use data structures that are designed for cache efficiency, such as the [packed_simd](https://github.com/rust-lang/packed_simd) crate. Packed SIMD (Single Instruction, Multiple Data) allows you to perform computations on multiple values simultaneously, which can greatly improve performance. By utilizing packed SIMD instructions, you can process large amounts of data with fewer instructions and reduce memory accesses.

Avoiding unnecessary memory allocations and copying can also help improve cache performance. Rust's ownership system and borrowing rules make it easy to manage memory efficiently. For example, instead of creating a new vector every time you need to filter or transform a collection, you can use iterators and closures:

```rust
let numbers = vec![1, 2, 3, 4];
let filtered_numbers: Vec<_> = numbers.iter().filter(|&x| x % 2 == 0).collect();
```

In this code snippet, we use the `iter()` method to create an iterator over the elements of the `numbers` vector. Then, we use the `filter()` method on the iterator to only keep the elements that satisfy a certain condition (in this case, being even). Finally, we collect the filtered elements into a new vector.

By using iterators and closures instead of creating intermediate vectors, we avoid unnecessary memory allocations and copying. This can help improve cache performance by reducing memory accesses.

Optimizing cache behavior is an important aspect of writing efficient Rust code. By organizing your data in a cache-friendly manner, using data structures designed for cache efficiency like packed SIMD, and avoiding unnecessary memory allocations and copying, your code will literally be "blazingly fast".

## Optimizing Algorithms and Data Structures

In addition to understanding the hardware architecture and optimizing cache and memory behavior, another key aspect of writing efficient Rust code is optimizing your algorithms and data structures. By choosing the right algorithms and data structures for your problem, you can significantly improve the performance of your code.

### Choosing the Right Data Structure

The choice of algorithm can have a huge impact on the performance of your code. Some algorithms are inherently more efficient than others for certain types of problems. It's important to choose an algorithm that is well-suited to your problem domain.

For example, the standard `HashMap` data structure in Rust is implemented as a hash table, which provides constant-time average case lookup, insertion, and deletion operations. However, for special use cases, other data structures with similar functionality might work better here. If you need to maintain a sorted collection of elements and frequently perform range queries or insertions/deletions at arbitrary positions, a balanced binary search tree like `BTreeSet` or `BTreeMap` may be more appropriate. These data structures provide logarithmic-time operations for these types of operations, which can be more efficient than hash tables in some cases.

```rust
use std::collections::{HashMap, BTreeSet};

fn main() {
    // Using HashMap
    let mut hashmap: HashMap<String, i32> = HashMap::new();

    hashmap.insert("Alice".to_string(), 25);
    hashmap.insert("Bob".to_string(), 30);

    println!("{:?}", hashmap.get("Alice")); // Some(25)

    // Using BTreeSet
    let mut btree_set: BTreeSet<i32> = BTreeSet::new();

    btree_set.insert(5);
    btree_set.insert(10);

    println!("{:?}", btree_set.range(..=7).collect::<Vec<_>>()); // [5]
}
```

In this example, we use a `HashMap` to store key-value pairs where the keys are strings and the values are integers. We can easily insert elements into the map and retrieve them using their keys.

On the other hand, we use a `BTreeSet` to store a sorted collection of integers. We can insert elements into the set and perform range queries using the `range` method.

Make sure to carefully consider which data structure is best suited for your problem. Choosing the right data structure can have a huge impact on the performance of your code.

### Optimizing Algorithms and Functions

In addition to choosing the right data structure, optimizing the algorithms and functions you use can also greatly improve the performance of your code.

#### Caching Results

One common optimization technique is caching results. If a function is called multiple times with the same input, you can cache the result and return it instead of recomputing it every time. This can be especially useful for expensive computations or functions that are called frequently.

Let's say you have an expensive function that performs a database query and returns the result. If you call this function multiple times with the same input, you can cache the result and return it instead of recomputing it every time. This can significantly improve the performance and efficiency of your code.

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

Running the above code, we can see that the database query is only performed once, even though we call the `get_data_from_database` function multiple times with the same input. This is because we cache the result and return it instead of recomputing it every time, saving us time and resources:

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

For example, let's say you wanted to sort a list of $10,000$ items. If you use a simple bubble sort algorithm, which has a time complexity of $O(n^2)$, it would take an average of $100,000,000$ operations to sort the list. However, if you use a more efficient sorting algorithm like quicksort, which has an average time complexity of $O(n\ log\ n)$, it would only take $130,000$ operations on average.

Understanding the time complexity of different algorithms allows you to choose the most efficient one for your specific problem. It's important to consider factors like the size of your input and any constraints or requirements you have when selecting an algorithm. For more on time and space complexity, check out [this article](https://levelup.gitconnected.com/a-beginners-guide-to-analysing-time-and-space-complexity-31e1677f5f5b).

## Profiling and Benchmarking

Profiling and benchmarking your code is an essential step in optimizing its performance. Profiling allows you to identify bottlenecks and areas of improvement in your code, while benchmarking helps you measure the impact of optimizations and compare different implementations.

### Profiling

Profiling involves analyzing the runtime behavior of your code to identify hotspots or areas that consume a significant amount of time or resources. There are several profiling tools available for Rust, such as [perf](https://perf.wiki.kernel.org/index.php/Main_Page), [Valgrind](http://valgrind.org/), and [flamegraph](https://github.com/flamegraph-rs/flamegraph).

One popular profiling tool for Rust is `cargo flamegraph`, which generates flame graphs based on CPU profiler data. Flame graphs provide a visual representation of where time is spent in your code, making it easier to pinpoint performance bottlenecks.

To use `cargo flamegraph`, first install it via

```bash
cargo install flamegraph
```

Then, you can use flamegraph to test your rust binaries:

```bash
cargo flamegraph --deterministic --bin=heimdall -- decompile 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2 -d -vvv --include-sol --skip-resolving
```

Which produces the following `flamegraph.svg`:

![flamegraph.svg](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/on-writing-performant-rust/2.png?fw)

As you can see, the flame graph provides a visual representation of the time spent in different parts of your code. The width of each box represents the amount of time spent in that function, while the height represents the call stack depth. Likewise, the color of each box can indicate different metrics such as CPU usage or memory allocation.

In this example, you can see that most of the time is spent within `heimdall::decompile::decompile`, with a suspiciously large box for `regex::compile::Compiler::compile`, which indicates that there is room for improvement here, possibly by using [lazy_static](https://docs.rs/lazy_static/latest/lazy_static/) or some other optimization.

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

Finally, run this benchmark with `cargo bench`.

Always remember to benchmark your code when making optimizations to ensure that the changes you make actually improve performance. If the benchmarks don't show a speed improvement significant enough to warrant the optimization, it's probably not worth including.

## Rust Build Configuration

Rust provides several build configuration options that can help optimize the performance of your code. These options allow you to control how the Rust compiler generates machine code and optimize various aspects of your program.

### Release Mode

When building your Rust code, it's important to use the `--release` flag to enable optimizations. By default, Rust builds in debug mode, which includes additional checks and information for debugging purposes but sacrifices performance.

To build your code in release mode, use the following command:

```bash
cargo build --release
```

The `--release` flag tells Cargo to enable optimizations like inlining function calls, removing unnecessary checks, and optimizing data structures. This can result in significant performance improvements. Under the hood, this is the same as as using the `RUSTFLAGS` `-C opt-level=3`, which enables aggressive optimizations.

### Link-Time Optimization

Link-time optimization (LTO) is a technique that allows the compiler to perform optimizations across multiple translation units (source files) during the linking phase. This can result in more aggressive optimizations and better performance.

To enable LTO in your Rust code, you can use the `lto` option in your Cargo.toml file under the `[profile.release]` section:

```toml
[profile.release]
lto = fat
```

This will enable link-time optimization across all codegen units in your project, which can result in better performance but may increase the size of your binary.

Keep in mind that enabling LTO may increase build times and memory usage, so it's important to consider the trade-offs for your specific project.

### Codegen Units

Codegen units are a compilation unit used by the Rust compiler to parallelize code generation. By default, the Rust compiler uses one codegen unit per CPU core, which allows for faster compilation times. However, using multiple codegen units can also improve runtime performance by allowing the compiler to optimize each unit independently.

You can control the number of codegen units used by the Rust compiler by setting the `codegen-units` option in your Cargo.toml file under the `[profile.release]` section:

```toml
[profile.release]
codegen-units = 1
```

This will instruct Cargo to use 1 codegen unit during release builds, which can help the compiler find more optimizations across crates in your project.

### Using an Alternative Allocator

By default, Rust uses the system allocator for managing memory. However, in certain cases, you may want to use an alternative allocator that provides better performance or specific features.

To use an alternative allocator in your Rust code, you can specify it in your Cargo.toml file under the `[dependencies]` section:

```toml
[dependencies]
jemallocator = "0.3"
```

### Compiler Flags

Rust provides several compiler flags that allow you to control various aspects of code generation and optimization. These flags can be set using the `RUSTFLAGS` environment variable or directly in your Cargo.toml file.

Here are some commonly used compiler flags:

-   `-C opt-level`: Specifies the optimization level. Higher levels (e.g., 2 or 3) enable more aggressive optimizations but may increase build times.
-   `-C target-cpu`: Specifies the target CPU architecture. This allows the compiler to generate machine code optimized for a specific CPU. For example, setting `target-cpu` to `native` will tell the compiler to look for optimizations for this machines CPU.
-   `-C debuginfo`: Controls whether debug information is included in the generated binary. Disabling debug info (`-C debuginfo=0`) can reduce binary size but makes debugging more difficult.
-   `-C panic=abort`: Changes how panics are handled by aborting instead of unwinding, which can improve performance at the cost of not being
