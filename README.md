# ADHD CLI Tool

A simple, beginner-friendly Rust CLI tool that connects to OpenAI.

## Prerequisites

You need to install Rust first. Visit [rustup.rs](https://rustup.rs/) and follow the installation instructions.

## Building the Project

```bash
# Build the project
cargo build

# Build for release (optimized, faster)
cargo build --release
```

## Running the Tool

```bash
# Show help
cargo run -- --help

# Connect to OpenAI with your API key
cargo run -- --open-ai-key sk-your-api-key-here
```

## Project Structure

```
adhd/
├── Cargo.toml       # Project configuration and dependencies
├── src/
│   └── main.rs      # Main source code
└── README.md        # This file
```

## Understanding the Code

### Cargo.toml
This file defines your project and its dependencies:
- `clap`: For parsing command-line arguments
- `reqwest`: For making HTTP requests to OpenAI
- `tokio`: For async/await support
- `serde`: For working with JSON data

### main.rs
The main source file contains:
- **CLI struct**: Defines what arguments the program accepts
- **main()**: The entry point that parses arguments and handles logic
- **connect_to_openai()**: Tests the API connection by listing available models

## Key Rust Concepts Used

1. **Structs**: `Cli` is a struct that holds our command-line arguments
2. **Enums**: `Option<String>` can be either `Some(value)` or `None`
3. **Pattern Matching**: The `match` keyword handles different cases
4. **Async/Await**: Used for non-blocking API calls
5. **Error Handling**: `Result<T, E>` for operations that can fail

## Next Steps

- Add more OpenAI API functionality (chat completions, etc.)
- Save API key to a config file instead of passing it each time
- Add more CLI commands and options

# Installing via cURL and Invoke-WebRequest (iwr)
```ps1
Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/bredmann245/adhd-cli/master/install.ps1 | Invoke-Expression
```

```bash
curl -fsSL https://raw.githubusercontent.com/bredmann245/adhd-cli/main/install.sh | sh
```