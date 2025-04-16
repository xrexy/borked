#!/bin/sh

BACKGROUNDS_DIR="$HOME/.dotfiles/backgrounds"
SUPPORTED_EXTENSIONS=".jpg .jpeg .png .gif .webp"

# Check if the directory exists
if [ ! -d "$BACKGROUNDS_DIR" ]; then
    echo "Error: Backgrounds directory not found at $BACKGROUNDS_DIR"
    exit 1
fi

# Get a list of image files in the backgrounds directory
# Supported formats: jpg, jpeg, png
find_cmd="find $BACKGROUNDS_DIR -type f"
for ext in $extensions; do
    find_cmd="$find_cmd -o -iname \"*$ext\""
done
find_cmd="$find_cmd | grep -i -E '$(echo "$extensions" | sed 's/ /|/g' | sed 's/\./\\./g')'"

# Get list of images and count
image_list=$(eval "$find_cmd")
image_count=$(echo "$image_list" | wc -l)

# Check if any image files were found
if [ "$image_count" -eq 0 ]; then
    echo "Error: No image files found in $BACKGROUNDS_DIR"
    exit 1
fi


current_wallpaper=$(swww query | grep "currently displaying:" | head -1 | sed -E 's/.*image: ([^,]*).*/\1/')
echo "Current wallpaper: $current_wallpaper"

# Try up to 10 times to find a different wallpaper
attempts=0
max_attempts=10
found_new=0

while [ $attempts -lt $max_attempts ] && [ $found_new -eq 0 ]; do
    # Select a random image
    random_image=$(echo "$image_list" | shuf -n 1)

    # Check if it's different from the current one
    if [ "$random_image" != "$current_wallpaper" ]; then
        found_new=1
    else
        attempts=$((attempts + 1))
        echo "Same as current wallpaper, trying again... ($attempts/$max_attempts)"
    fi
done

if [ $found_new -eq 0 ]; then
    echo "Warning: Could not find a different wallpaper after $max_attempts attempts."
    echo "You may not have enough wallpapers in your collection."
fi

echo "Setting new wallpaper: $random_image"

# Set the wallpaper using swww
swww img "$random_image" --transition-type=random --transition-fps=120

echo "Wallpaper set successfully"
