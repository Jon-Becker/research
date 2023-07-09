# Mastering Rust: Maximizing Rust Performance by Doing Less

##### 2023-06-27 By [Jonathan Becker](https://jbecker.dev)

![preview](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/on-writing-efficient-rust/preview.png?fw)

Since its release in 2010, Rust has gained popularity as a systems programming language known for its emphasis on performance, safety, and concurrency. Developed by Mozilla, Rust was designed to address the shortcomings of other systems programming languages such as C and C++.

In this article, we'll dive into the world of Rust by building a [chess minimax](https://www.chessprogramming.org/Minimax) engine, which aims to find the best possible move for a given position. Rust's performance is one of its key strengths, and by understanding some of its core principles, we can maximize the performance of our algorithm.

## Understanding Rust's Key Characteristics

Before we start building our chess engine, it's important to understand some of the key characteristics of Rust. Fully understanding these concepts will allow you to write efficient and performant code.

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

In short, the board's 64 squares are represented as a `u64`, with each bit being a `0` if it's empty, or `1` if it's occupied by a piece. Representing the board this way allows for the entire game state to consume a minimal amount of memory. In general, it's important to search for these kinds of memory-efficient data structures when building performance-critical applications. If you want to learn more about bitboards, check out [this article](https://www.chessprogramming.org/Bitboards).

While the `chess` crate provides a `Board` struct that represents the game state, we are going to be using our own `Board` struct that wraps the `chess` crate's `Board` struct, and provides additional functionality for our minimax algorithm. For now, let's just implement the `Display` trait so we can print the board to the console.

<details>
<summary>`Board::display`</summary>

```rust
impl Display for Board {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        // Remove the move, turn, and castling rights from the FEN string.
        // It is safe to unwrap here because we should panic if the FEN string is invalid.
        let fen: String = self.board.to_string().split(' ').next().unwrap().to_string();

        // Build the output string, with a rough estimate of the capacity needed.
        let mut output = String::with_capacity(300);

        // Iterate over each row of the board, starting with the 8th row.
        for (i, row) in fen.split('/').enumerate() {
            // Add the row number to the output string.
            output.push_str(&format!("{} ", 8 - i));

            // Iterate over each piece, adding it to the output string.
            for c in row.chars() {
                if let Some(spaces) = c.to_digit(10) {
                    output.extend(std::iter::repeat(". ").take(spaces as usize));
                } else {
                    output.push(c);
                    output.push(' ');
                }
            }

            // there are always 8 rows in a chess board, so we don't need a newline on the last row.
            if i != 7 {
                output.push('\n');
            }
        }

        // Add the column letters to the output string.
        output.push_str("\n  a b c d e f g h");

        f.write_str(&output)
    }
}
```

</details>

One thing to keep in mind when writing rust code is that string operations are **SLOW**. You should generally avoid strings wherever possible, and always allocate the exact amount of memory needed for the string. In this case, we are using `String::with_capacity` to allocate the exact amount of memory needed for the output string.

### Evaluating the Board

Now that we have a way to print the board, let's implement a function that evaluates the board and returns a score. This score will be used by the minimax algorithm to determine the best move.

#### Determining the Game Phase

Here's where we can start using the magic of bitboards. We are going to use the number of pieces remaining on the board to determine the current game phase. This will allow us to use different evaluation functions for each phase of the game, which should lead to better performance.

Let's add a function to our `Board` struct that returns the current game phase. We only want to count minor and major pieces (Knights, Bishops, Rooks, and Queens), so we'll exclude pawns and kings from the count. We can use bitwise operations to get a bitboard of all pieces, then another bitboard of all kings and pawns, and finally use the number of bits in the resulting bitboard to determine the game phase.

<details>
<summary>`Board::game_phase`</summary>

```rust
    #[inline(always)]
    pub fn game_phase(&self) -> GamePhase {

        // Get a color blind bitboard of all pieces. This will have a `1` in every square that has either a white or black piece.
        let all_pieces = self.board.combined();

        // The bitboard should look like this for a standard chess starting position:
        //
        // X X X X X X X X
        // X X X X X X X X
        // . . . . . . . .
        // . . . . . . . .
        // . . . . . . . .
        // . . . . . . . .
        // X X X X X X X X
        // X X X X . X X X


        // Now get a bitboard of all kings and pawns. This will have a `1` in every square that has either a white or black king or pawn.
        let invalid_pieces = self.board.pieces(Piece::King) | self.board.pieces(Piece::Pawn);

        // Now we can use bitwise operations to get a bitboard of all non-pawn, non-king pieces.
        let valid_pieces = all_pieces & !invalid_pieces;

        // The bitboard now looks like this for a standard chess starting position:
        //
        // X X X X . X X X
        // . . . . . . . .
        // . . . . . . . .
        // . . . . . . . .
        // . . . . . . . .
        // . . . . . . . .
        // . . . . . . . .
        // X X X X . X X X

        // Now we can count the number of bits in the bitboard, which will give us the number of non-pawn, non-king pieces.
        let num_pieces = valid_pieces.0.count_ones();

        // Now we can use the number of pieces to determine the game phase.
        // https://www.chess.com/forum/view/general/opening--middle-game--end-game#comment-6210629
        if num_pieces > 12 {
            GamePhase::Early
        } else if num_pieces > 6 {
            GamePhase::Middle
        } else {
            GamePhase::End
        }
    }
```

</details>

This implementation is very efficient, as it only uses bitwise operations and a single call to `count_ones`. This is a great example of how Rust's low-level control allows us to write efficient code without sacrificing safety. Benchmarking this function shows that it runs in around 600 nanoseconds, which means it can run around 1.6 million times per second. If that's not "blazingly fast", I don't know what is.

```rust
benchmark_game_phase:
    617ns ± 548ns per run ( with 100,000 runs ).
```

#### Evaluating the Board

Now that we have a way to determine the game phase, let's implement a function that evaluates the board and returns a score. We are going to use a different evaluation function for each phase of the game, which should lead to better performance. In chess, a negative score means black is winning, and a positive score means white is winning. As the score approaches zero, the game is closer to a draw.


##### Material Score

Let's start by implementing a simple function that returns the material score of the board.

<details>
<summary>`Board::evaluate_material`</summary>

```rust
/// The weights for each piece type.
struct PieceWeights {
    pawn: f32,
    knight: f32,
    bishop: f32,
    rook: f32,
    queen: f32,
}


/// Evaluate the material on the board. Simply counts the number of pieces of each type and multiplies it by the weight for that piece type.
fn evaluate_material(&self, piece_weights: PieceWeights) -> f32 {
    let mut score = 0.0;

    // Get a bitboard of all white and black pieces.
    let white_pieces = self.board.color_combined(Color::White);
    let black_pieces = self.board.color_combined(Color::Black);

    // Add the score for each white piece type.
    score += (self.board.pieces(chess::Piece::Pawn) & white_pieces).0.count_ones() as f32 *
        piece_weights.pawn;
    score += (self.board.pieces(chess::Piece::Knight) & white_pieces).0.count_ones() as f32 *
        piece_weights.knight;
    score += (self.board.pieces(chess::Piece::Bishop) & white_pieces).0.count_ones() as f32 *
        piece_weights.bishop;
    score += (self.board.pieces(chess::Piece::Rook) & white_pieces).0.count_ones() as f32 *
        piece_weights.rook;
    score += (self.board.pieces(chess::Piece::Queen) & white_pieces).0.count_ones() as f32 *
        piece_weights.queen;

    // Subtract the score for each black piece type.
    score -= (self.board.pieces(chess::Piece::Pawn) & black_pieces).0.count_ones() as f32 *
        piece_weights.pawn;
    score -= (self.board.pieces(chess::Piece::Knight) & black_pieces).0.count_ones() as f32 *
        piece_weights.knight;
    score -= (self.board.pieces(chess::Piece::Bishop) & black_pieces).0.count_ones() as f32 *
        piece_weights.bishop;
    score -= (self.board.pieces(chess::Piece::Rook) & black_pieces).0.count_ones() as f32 *
        piece_weights.rook;
    score -= (self.board.pieces(chess::Piece::Queen) & black_pieces).0.count_ones() as f32 *
        piece_weights.queen;

    score
}
```
</details>

Again, we take advantage of bitboards to efficiently count the number of pieces on the board. We also use a `PieceWeights` struct to allow us to easily tweak the weights for each piece type based on the game phase. For example, nights might be worth less than bishops in the endgame due to mobility. This function is very efficient, as it only uses bitwise operations and calls to `count_ones`. Nice.

Now that we can evaluate the material on the board, we can start on

##### Positional Score

Simply counting the number of pieces on the board is not enough to determine the best move. We also need to take into account the position of each piece. For example, a knight in the center of the board is more valuable than a knight on the edge of the board, because it has more places to jump to. Let's implement a function that evaluates the positional score of the board.

We can start by defining a sort of "heatmap" for each piece type. This heatmap will be used to determine the positional score of each piece. We can use a 2D array to represent the heatmap, with each element representing the score for a given square. We can then use the piece type and color to index into the heatmap and get the score for a given square.

Each phase of the game will have a different heatmap, as the value of each square changes based on the game phase. For example, the center of the board is more valuable in the early game, as it allows for more mobility. In the endgame, the center of the board is less valuable, as there are fewer pieces on the board and the king is more vulnerable.