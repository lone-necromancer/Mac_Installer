#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if Homebrew is installed
if command -v brew &> /dev/null; then
    echo -e "${CYAN}Homebrew is already installed."
else
    # Install Homebrew if it doesn't exist
    echo "${GREEN}Homebrew is not installed. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install your desired program using Homebrew
