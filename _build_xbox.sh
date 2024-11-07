#!/bin/bash

# Set a variable to track whether the ARK build failed
FAILED_ARK_BUILD=0

# Set the path to arkhelper and check if the script is running on macOS
if [[ $(uname -s) == "Darwin" ]]; then
    echo "Running on macOS"
    # macOS-specific path to arkhelper executable
    ARKHELPER_PATH="$(pwd)/dependencies/macos/arkhelper"
else
    echo "Not running on macOS"
    # Assume Linux or other Unix-like systems
    ARKHELPER_PATH="$(pwd)/dependencies/linux/arkhelper"
fi

# Temporarily move Xbox and Wii files out of the ARK path to reduce final ARK size
#echo
#echo "Temporarily moving Xbox and Wii files out of the ark path to reduce final ARK size"
#find "$PWD/_temp/_ark" \( -name "*.bik" -o -name "*.milo_wii" -o -name "*.png_wii" -o -name "*.bmp_wii" \) -exec mv -t "$PWD/_ark" {} +
#find "$PWD/_ark" \( -name "*.milo_xbox" -o -name "*.png_xbox" -o -name "*.bmp_xbox" \) -exec mv -t "$PWD/_temp/_ark" {} +

# Building Xbox ARK
echo
echo "Building PS3 ARK"
"$ARKHELPER_PATH" dir2ark "$PWD/_ark" "$PWD/_build/xbox/gen" -n "patch_xbox" -e -v 5 -s 4073741823
if [ $? -ne 0 ]; then
    FAILED_ARK_BUILD=1
fi

# Moving back Xbox files
#echo
#echo "Moving back Xbox files"
#find "$PWD/_temp/_ark" \( -name "*.bik" -o -name "*.milo_wii" -o -name "*.png_wii" -o -name "*.bmp_wii" \) -exec mv -t "$PWD/_ark" {} +
#find "$PWD/_ark" \( -name "*.milo_xbox" -o -name "*.png_xbox" -o -name "*.bmp_xbox" \) -exec mv -t "$PWD/_temp/_ark" {} +

# Clean up temporary directory
rm -rf "$PWD/_temp"

# Check if the ARK build failed and provide appropriate message
echo
if [ "$FAILED_ARK_BUILD" -ne 1 ]; then
    echo "Successfully built Green Day Rock Band Ultimate ARK. You may find the files needed to place on your PS3 in /_build/xbox/"
else
    echo "Error building ARK. Check your modifications or run _git_reset.bat to rebase your repo."
fi

echo
read -p "Press Enter to continue..."
