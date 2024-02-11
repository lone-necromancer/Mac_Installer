#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

INSTALL_DIR="/Applications"

# Check if Homebrew is installed
if command -v brew &> /dev/null; then
    echo -e "${CYAN}Homebrew is already installed."
else
    # Install Homebrew if it doesn't exist
    echo -e "${GREEN}Homebrew is not installed. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install your desired program using Homebrew

# Check if Python is installed and its version is less than 3.x.x
if command -v python3 &> /dev/null && [[ $(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2) > 3.0 ]]; then
    echo -e "${CYAN}Python 3 or a higher version is already installed."
else
    # Install Python 3 using Homebrew
    echo -e "${GREEN}Installing Python 3..."
    brew install python3
fi

# Install mas
if command -v mas &> /dev/null; then
    echo -e "${CYAN}mas is already installed."
else
    # Install Python 3 using Homebrew
    echo -e "${GREEN}Installing mas..."
    brew install mas
fi

# install Warp
if [ -e "$INSTALL_DIR/Warp.app" ]; then
    echo -e "${CYAN} Warp is already installed"
else 
    echo -e "${GREEN} Warp is not installed, installing..."
    brew install --cask warp
fi

# Install VSCode

# Install Git

# Install Jira

#Install Fastlane

echo -e "${GREEN}Finished installation successfully"
exit 0