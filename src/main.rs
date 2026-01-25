extern crate dotenv;
mod services;
use crate::services::openai::open_ai;
use dotenv::dotenv;

use clap::Parser;

// Define what command-line arguments our program accepts
// The #[derive(Parser)] automatically creates argument parsing code for us
#[derive(Parser)]
#[command(name = "adhd")]
#[command(about = "A simple CLI tool that connects to OpenAI", long_about = None)]
struct Cli {
    /// Your OpenAI API key
    // #[arg(long = "open-ai-key")]
    // api_key: Option<String>,

    #[arg(long = "help-me")]
    help_me: bool,
}

// This is the main function that runs when the program starts
// #[tokio::main] allows us to use async/await (needed for API calls)
#[tokio::main]
async fn main() {
    dotenv().ok();

    // Parse the command-line arguments into our Cli struct
    let cli = Cli::parse();

    if cli.help_me {
        let result: Option<String> = open_ai().await.unwrap();
        match result {
            Some(text) => println!("{}", text),
            None => println!("No response content"),
        }
    }
}
