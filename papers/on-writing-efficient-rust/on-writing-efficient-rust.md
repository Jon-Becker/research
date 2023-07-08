# Mastering Rust: Maximizing Rust Performance by Doing Less

##### 2023-06-27 by Jonathan Becker

[preview](preview.png)

Since its release in 2010, Rust has gained popularity as a systems programming language known for its emphasis on performance, safety, and concurrency. Developed by Mozilla, Rust was designed to address the shortcomings of other systems programming languages such as C and C++.

In this article, we'll dive into the world of Rust by building a [chess minimax](https://www.chessprogramming.org/Minimax) engine, which aims to find the best possible move for a given position. Rust's performance is one of its key strengths, and by understanding some of its core principles, we can maximize the performance of our algorithm.

## Understanding Rust's Performance Characteristics

Before we start building our chess engine, it's important to understand some of the key performance characteristics of Rust. Fully understanding these concepts will allow you to write efficient and performant code.

### Zero-cost abstractions

One of the key features of Rust is its ability to utilize zero-cost abstractions. This simply means that using high-level abstractions in Rust doesn't add additional runtime overhead compared to the equivalent low-level code. Rust achieves this through a unique system of ownership and borrowing, facilitating efficient memory management without the need for a garbage collector.

Many other languages, such as C++ or Python, often introduce a certain degree of runtime cost with their high-level abstractions. For example, C++'s object-oriented programming features like virtual functions can incur a performance penalty due to dynamic dispatch. In Python, its dynamically-typed nature and the interpretation of code at runtime lead to slower execution compared to statically compiled languages such as Rust.

### Safety without Garbage Collection

Rust's ownership system ensures that memory is managed safely and efficiently by enforcing strict rules about how data can be accessed and modified. This eliminates the need for a garbage collector, which is commonly used in languages like Java or C# to automatically reclaim memory that is no longer in use. Garbage collection introduces overhead and can lead to unpredictable pauses in program execution.

In Rust, memory is managed through a combination of ownership, borrowing, and lifetimes. The ownership system ensures that each piece of data has a unique owner at any given time. When ownership is transferred or borrowed, the compiler enforces strict rules to prevent data races or dangling references.

By managing memory manually and statically enforcing these rules at compile-time, Rust achieves both safety and performance without relying on a garbage collector.

### Low-level control

Rust provides low-level control over hardware resources without sacrificing safety. This allows developers to write code that can be optimized for specific hardware architectures or take advantage of platform-specific features.

For example, Rust's language features like `unsafe` blocks allow developers to bypass certain safety checks when necessary. This can be useful when interacting with low-level libraries or writing performance-critical code where fine-grained control over memory layout and operations is required. This is generally discouraged unless necessary, as it can end up being a footgun.

### "Fearless Concurrency"

Rust provides powerful abstractions for writing concurrent and parallel code. The ownership and borrowing system ensures that the common issues concurrency introduces, such as data races or deadlocks, are prevented at compile-time.

Additionally, Rust provides low-level primitives like atomic operations and mutexes for fine-grained control over concurrency when necessary. These primitives allow developers to carefully manage shared mutable state without sacrificing performance.

## Building the Chess Minimax Engine

Now that we have a good understanding of Rust's performance characteristics, let's start building our chess minimax engine.

### The Chess Board

We are going to be using the [chess](https://crates.io/crates/chess) crate for handling our board representation, rule enforcement, and every other aspect of the game. Under the hood, this crate represents the board as a bitboard, which allows for efficient manipulation and evaluation of the game state with bitwise and mathematical operations.

In short, the board's 64 squares are represented as a `u64`, with each bit being a `0` if it's empty, or `1` if it's occupied by a piece. Representing the board this way allows for the entire game state to consume a minimal amount of memory.

### To get started, let's add the `chess` crate to our project by adding it as a dependency in our `Cargo.toml` file:

```toml
[dependencies]
chess = "0.8.3"
```

Next, let's create a new module called `engine` in our project's source code directory. Inside this module, we'll define a struct called `ChessEngine` that will represent our minimax engine.

```rust
use chess::{Board, Color};

struct ChessEngine {
    board: Board,
}
```

The `ChessEngine` struct has a single field called `board`, which is an instance of the `Board` struct from the `chess` crate. This field will hold the current state of the chess board.

Next, let's implement some methods for our engine:

```rust
impl ChessEngine {
    fn new() -> Self {
        Self {
            board: Board::default(),
        }
    }

    fn make_move(&mut self) {
        // TODO: Implement move generation and selection logic
    }

    fn evaluate_position(&self) -> i32 {
        // TODO: Implement position evaluation logic
        0
    }
}
```

The first
