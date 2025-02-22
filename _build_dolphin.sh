#!/bin/bash

# Set a variable to track whether the ARK build failed
FAILED_ARK_BUILD=0

# Set the path to wit and arkhelper and check if the script is running on macOS
if [[ $(uname -s) == "Darwin" ]]; then
    echo "Running on macOS"
    # macOS-specific path to wit/arkhelper executable
    WIT_PATH="$(pwd)/dependencies/wit/wit_macos"
    ARKHELPER_PATH="$(pwd)/dependencies/macos/arkhelper"
else
    echo "Not running on macOS"
    # Assume Linux or other Unix-like systems
    WIT_PATH="$(pwd)/dependencies/wit/wit"
    ARKHELPER_PATH="$(pwd)/dependencies/linux/arkhelper"
fi

# Extract ISO using wit
"$WIT_PATH" extract "$PWD/iso" "$PWD/_build/wii"

# Remove unnecessary files
rm "$PWD/_build/wii/sys/main.dol"
rm "$PWD/_build/wii/setup.txt"

# Copy patched main.dol and setup.txt
cp "$PWD/dependencies/patch/main.dol" "$PWD/_build/wii/sys"
cp "$PWD/dependencies/patch/setup.txt" "$PWD/_build/wii"

# Copy main_wii.hdr to appropriate directory
cp "$PWD/_build/wii_rebuild_files/main_wii.hdr" "$PWD/_build/wii/files/gen"

# Remove previous main_wii_10.ark
rm "$PWD/_build/wii/files/gen/main_wii_10.ark" 2> /dev/null

# Create patched files using arkhelper
"$ARKHELPER_PATH" dir2ark "$PWD/_ark" "$PWD/_build/wii/files/gen" -n "patch_wii" -e -v 5 -s 4073741823 >/dev/null 2>&1
if [ $? -ne 0 ]; then
    FAILED_ARK_BUILD=1
fi

# Check if the ARK build failed and provide appropriate message
echo
if [ "$FAILED_ARK_BUILD" -ne 1 ]; then
    echo "GDRB ultimate should've successfully built. Make sure to add _build/wii as a game path in Dolphin and enable search subfolders so it will show up. Enjoy :)"
else
    echo "Error building ARK. Download the repo again or some dta file is bad p.s turn echo on to see what arkhelper says"
fi

# Pause to keep terminal open
read -p "Press Enter to continue..."
