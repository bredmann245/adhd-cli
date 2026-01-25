extern crate dotenv;
mod services;
use crate::services::{openai::open_ai };
use clap::Parser;
use colored::Colorize;
use dotenv::dotenv;
use indicatif::{ProgressBar, ProgressDrawTarget};
use std::{
    io::{self, IsTerminal},
    time::Duration,
};

// Define what command-line arguments our program accepts
// The #[derive(Parser)] automatically creates argument parsing code for us
#[derive(Parser)]
#[command(name = "adhd")]
#[command(about = "A simple CLI tool that connects to OpenAI", long_about = None)]
struct Cli {
    #[arg(long = "inspire")]
    inspire: bool,
}

fn make_progress() -> Option<ProgressBar> {
    // Only animate when stderr is a real terminal.
    // Windows Virtual Terminal mode (enabled via enable_ansi_support) allows progress bars
    // to work properly in Git Bash and other terminals.
    let stderr_is_tty = io::stderr().is_terminal();
    if stderr_is_tty {
        let pb: ProgressBar = ProgressBar::new_spinner();
        pb.set_draw_target(ProgressDrawTarget::stderr());
        pb.enable_steady_tick(Duration::from_millis(80));
        pb.set_message("Adhding...");
        Some(pb)
    } else {
        None
    }
}
// This is the main function that runs when the program starts
// #[tokio::main] allows us to use async/await (needed for API calls)
#[tokio::main]
async fn main() {
    dotenv().ok();
    // Enable Windows Virtual Terminal mode for ANSI colors to work properly
    #[cfg(windows)]
    {
        let _ = enable_ansi_support::enable_ansi_support();
    }

    // Force colored crate to output colors
    colored::control::set_override(true);

    // Parse the command-line arguments into our Cli struct
    let cli = Cli::parse();
    let progress = make_progress();
    if progress.is_none() {
        eprintln!("Thinking..."); // clean fallback for Git Bash
    }

    if cli.inspire {
        let result: Option<String> = open_ai().await.unwrap();
        if let Some(pb) = progress {
            pb.finish_and_clear();
        }
        match result {
            Some(text) => {
                println!("{}", text.cyan());
            }
            None => println!("No response content"),
        }
    }
}

//   - Windows: %APPDATA%\adhd\ → C:\Users\YourName\AppData\Roaming\adhd\
//   - Linux: ~/.config/adhd/
//   - Mac:or ~/.config/adhd/