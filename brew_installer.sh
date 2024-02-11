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
if [ -d "${INSTALL_DIR}/Visual Studio Code.app" ]; then
    echo "${CYAN}VSCode is already installed."
else
    # Install VSCode using Homebrew
    echo "${GREEN}Installing Visual Studio Code..."
    brew install --cask visual-studio-code & 
    VSCODE_INSTALL_PID=$!
fi

# Install Git
if command -v git &> /dev/null; then
    echo -e "${CYAN}git is already installed."
else
    # Install Python 3 using Homebrew
    echo -e "${GREEN}Installing git..."
    brew install git
fi

#Install Fastlane
if command -v fastlane &> /dev/null; then
    echo -e "${CYAN}fastlane is already installed."
else
    # Install Python 3 using Homebrew
    echo -e "${GREEN}Installing fastlane..."
    brew install fastlane
fi

# Install Xcode
if [ -d "${INSTALL_DIR}/Xcode.app" ]; then
    echo "$Xcode is already installed."
else
    # Install Xcode command line tools
        touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    PROD=$(softwareupdate -l |
            grep "\*.*Command Line" |
            head -n 1 | awk -F"*" '{print $2}' |
            sed -e 's/^ *//' |
            tr -d '\n')
    softwareupdate -i "$PROD" --verbose


    # Wait for Xcode command line tools installation to complete
    echo "${CYAN}Waiting for Xcode command line tools installation to complete..."
    until xcode-select -p &>/dev/null; do
        sleep 5
    done

    # Download and install Xcode from the App Store (you may need to sign in to the App Store)
    echo "${CYAN}Downloading and installing Xcode..."
    (mas install 497799835) &  # This is the App Store ID for Xcode
    XCODE_INSTALL_PID=$!
fi

# Wait for processes to finish before finising the program
wait XCODE_INSTALL_PID && VSCODE_INSTALL_PID
# Check if Xcode is now installed
if [ -d "${INSTALL_DIR}/Xcode.app" ]; then
    echo "${GREEN}Xcode has been installed successfully."
else
    echo "${RED}Xcode installation may not have completed successfully. Please install manually."
fi

# Check if VSCode is now installed
if [ -d "${INSTALL_DIR}/Visual Studio Code.app" ]; then
    echo "${GREEN}VSCode has been installed successfully."
else
    echo "${RED}VSCode installation may not have completed successfully. Please install manually."
fi

echo -e "${GREEN}Finished installation successfully"
exit 0