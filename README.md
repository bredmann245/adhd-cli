# ADHD CLI Tool

A simple CLI tool that connects to OpenAI to help keep you inspired and focused.

## Installation

### Windows (PowerShell)
```ps1
Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/bredmann245/adhd-cli/master/install.ps1 | Invoke-Expression
```

### Linux/Mac (Bash)
```bash
curl -fsSL https://raw.githubusercontent.com/bredmann245/adhd-cli/main/install.sh | sh
```

## Configuration

Before using the tool, you need to set up your OpenAI API key. Create a `.env` file in the same directory as the executable or set the environment variable:

```bash
# Create .env file with your API key
OPENAI_API_KEY=sk-your-api-key-here
```

## Usage

```bash
# Get inspiration
adhd --inspire

# Show help
adhd --help
```

## Getting an OpenAI API Key

1. Visit [platform.openai.com](https://platform.openai.com/)
2. Sign up or log in
3. Navigate to API keys section
4. Create a new API key
5. Copy it to your `.env` file

## Development 

This is still in its very early stages of development. Much more to come! 