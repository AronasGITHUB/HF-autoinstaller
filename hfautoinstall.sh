#!/bin/bash

# BEFORE MODIFICATION, COPYING, SELLING, COMPILING, ETC., PLEASE CHECK THE LICENSE.
# THIS LICENSE DOES NOT CONSTITUTE LEGAL ADVICE.

# This is the MacOS/Linux version of this autoinstaller.
# Windows users should refer to the .bat file version.

# ---------------------------------------------------
#       Hardened Firefox Autoinstaller - 1.0
# ---------------------------------------------------
# Hardened Firefox is an autoinstaller that simplifies the process of installing hardened Firefox.
# It allows beginners to easily harden Firefox without manual configurations.
# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Making hardening Firefox easier ;)

function menu() {
    clear
    echo "=========================================="
    echo "|   Hardened Firefox Autoinstaller 1.0   |"
    echo "=========================================="
    echo "Hardened Firefox, easier"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "1) Start"
    echo "2) Help"
    echo "3) Quit"
    echo "---------------------------------------------"
    read -p "Select an option: " option
    case $option in 
        1) 
            clear
            echo "Please go to about:support, and fill in your profile directory here."
            echo "1. Type in about:support in the URL bar"
            echo "2. Check for a section named profile directory"
            echo "3. Fill in the file path to the profile directory."
            echo "The file path must be exactly from / to your profile directory."
            echo "You can copy in the terminal with CTRL-Shift-C"
            echo "You can paste in the terminal with CTRL-Shift-V"
            echo "--------------------------------------------------------------------"
            read -p "Enter profile directory: " fp
            
            # Validate directory
            if [[ ! -d "$fp" ]]; then
                echo "[!] Invalid directory! Please try again."
                sleep 2
                menu
            fi
            
            echo "The process will start now."
            sleep 2
            clear
            echo "Changing directories to $fp..."
            cd "$fp" || { echo "[!] Failed to change directory."; exit 1; }
            
            echo "Downloading hardened Firefox files..."
            files=("user.js" "updater.sh" "prefsCleaner.sh")
            for file in "${files[@]}"; do
                wget "https://raw.githubusercontent.com/arkenfox/user.js/refs/heads/master/$file" || { echo "[!] Failed to download $file."; exit 1; }
            done
            
            touch user-overrides.js
            echo "Done"
            echo "Closing all instances of Firefox..."
            pkill firefox || echo "[!] No Firefox instances to close."
            echo "Done"
            echo "Updating Firefox..."
            ./updater.sh || { echo "[!] Update script failed."; exit 1; }
            echo "Done"
            echo "Cleaning preferences..."
            ./prefsCleaner.sh -s || { echo "[!] Cleaning preferences failed."; exit 1; }
            echo "Done"
            echo "Finished! Hardened Firefox is ready to use."
            exit 0
            ;;
        2)
            clear
            echo "This is a hardened Firefox autoinstaller for beginners."
            echo "You must have Firefox installed to use this program."
            echo "This program makes installing hardened Firefox easier!"
            echo "More documentation will be on the GitHub page."
            echo "This is the MacOS/Linux version of this autoinstaller."
            echo
            read -n 1 -s -r -p "Press any key to continue..."
            menu
            ;;
        3)
            exit 0
            ;;
        *)
            echo "[!] Invalid option!"
            sleep 2
            menu
            ;;
    esac
}

menu
