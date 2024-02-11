#!/bin/zsh

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

INSTALL_DIR="/Applications"

EXCLUDE_HEAVY_INSTALLATIONS='false'

while getopts ':e' 'OPTKEY'; do
    case ${OPTKEY} in
        'e')
            # Update the value of the option x flag we defined above
            EXCLUDE_HEAVY_INSTALLATIONS='true'
            ;;
        ':')
            echo "MISSING ARGUMENT for option -- ${OPTARG}" >&2
            exit 1
            ;;
        *)
            echo "UNIMPLEMENTED OPTION -- ${OPTKEY}" >&2
            exit 1
            ;;
    esac
done


# Check if Homebrew is installed
if command -v brew &> /dev/null; then
    echo -e "${CYAN}Homebrew is already installed."
else
    # Install Homebrew if it doesn't exist
    echo -e "${GREEN}Homebrew is not installed. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install mas
if command -v mas &> /dev/null; then
    echo -e "${CYAN}mas is already installed."
else
    # Install mas using Homebrew
    echo -e "${GREEN}Installing mas..."
    brew install mas
fi

# Install Xcode command line tools
if command -v xcode-select &> /dev/null; then
    echo -e "${CYAN}xcode-select is already installed."
else
    # Install xcode-select using Homebrew
    echo -e "${GREEN}Installing xcode-select..."
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
fi

# Install Xcode
if [ -d "${INSTALL_DIR}/Xcode.app" ]; then
    echo "${CYAN}Xcode is already installed."
elif [ EXCLUDE_HEAVY_INSTALLATIONS ]; then
    echo "${RED}Skipping Xcode installation."
else
    # Download and install Xcode from the App Store (you may need to sign in to the App Store)
    echo "${GREEN}Downloading and installing Xcode..."
    (mas install 497799835) &  # This is the App Store ID for Xcode
    XCODE_INSTALL_PID=$!
fi

# Check if Python is installed and its version is less than 3.x.x
if command -v python3 &> /dev/null && [[ $(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2) > 3.0 ]]; then
    echo -e "${CYAN}Python 3 or a higher version is already installed."
else
    # Install Python 3 using Homebrew
    echo -e "${GREEN}Installing Python 3..."
    brew install python3
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
elif [ EXCLUDE_HEAVY_INSTALLATIONS ]; then
    echo "${RED}Skipping Xcode installation."
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

#Install starship
if command -v starship &> /dev/null; then
    echo -e "${CYAN}starship is already installed."
else
    # Install Python 3 using Homebrew
    echo -e "${GREEN}Installing starship..."
    brew install starship
    # Initialize starship when zsh is executed.
    echo 'eval "$(starship init zsh)"' >> .zshrc
    # Set a new font for the starship.
    starship preset nerd-font-symbols -o ~/.config/starship.toml
fi

# Wait for processes to finish before finising the program
wait $XCODE_INSTALL_PID && $VSCODE_INSTALL_PID
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

echo ""
echo -e "${GREEN}Finished installation successfully"
exit 0