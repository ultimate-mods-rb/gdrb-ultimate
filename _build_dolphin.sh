#!/bin/bash
set -euo pipefail

# ---------- Config ----------
PWD_ROOT="$(pwd)"
ARKHELPER_PATH=""
FAILED_ARK_BUILD=0

EXCLUDES=( "*.*_xbox" "*.xbv" "*.*_ps3" "*_out*" "*_dbg.milo*" "*_rt.milo*" "*.bak" "*.png" "*.jpg" "*.dds" "*.sh" "*.py")

TEMP_ARK="$PWD_ROOT/_temp_ark_wii"

SOURCES=( "$PWD_ROOT/_ark::." "$PWD_ROOT/_songs/songs_wii::songs" )

# Build output location
OUT_DIR="$PWD_ROOT/_build/wii/files/gen"

# ---------- Platform / arkhelper selection ----------
case "$(uname -s)" in
    Darwin)
        echo "Running for macOS"
        WIT_PATH="$(pwd)/dependencies/wit/wit_macos"
        ARKHELPER_PATH="$PWD_ROOT/dependencies/macos/arkhelper"
        ;;
    MINGW*|MSYS*|CYGWIN*)
        echo "Running for Windows"
        WIT_PATH="$(pwd)/dependencies/wit/wit"
        ARKHELPER_PATH="$PWD_ROOT/dependencies/arkhelper"
        ;;
    *)
        echo "Running for Linux"
        WIT_PATH="$(pwd)/dependencies/wit/wit"
        ARKHELPER_PATH="$PWD_ROOT/dependencies/linux/arkhelper"
        ;;
esac

if [[ ! -d "$PWD/_build/wii" ]]; then
    # Extract ISO using wit
    "$WIT_PATH" extract "$PWD/iso" "$PWD/_build/wii"
fi

# Copy patched main.dol and setup.txt
cp -rf "$PWD/dependencies/patch/main.dol" "$PWD/_build/wii/sys"
cp -rf "$PWD/dependencies/patch/setup.txt" "$PWD/_build/wii"

# ---------- Helpers ----------
should_exclude() {
    local rel="$1" name="$2"
    for pat in "${EXCLUDES[@]}"; do
        if [[ "$name" == $pat ]] || [[ "$rel" == $pat ]]; then
            return 0
        fi
    done
    return 1
}

cleanup() {
    if [[ -d "$TEMP_ARK" ]]; then
        rm -rf "$TEMP_ARK"
    fi
}
trap cleanup EXIT

# ---------- Create temp copy ----------
echo "Creating temporary copy at: $TEMP_ARK"
rm -rf "$TEMP_ARK"
mkdir -p "$TEMP_ARK"

for mapping in "${SOURCES[@]}"; do
    src_root="${mapping%%::*}"
    dest_sub="${mapping##*::}"

    if [[ "$dest_sub" == "." ]]; then
        dest_root="$TEMP_ARK"
    else
        dest_root="$TEMP_ARK/$dest_sub"
    fi
    mkdir -p "$dest_root"

    while IFS= read -r -d '' src; do
        rel="${src#$src_root/}"
        name="$(basename "$src")"
        dest_path="$dest_root/$rel"

        if should_exclude "$rel" "$name"; then
            continue
        fi

        if [[ -d "$src" ]]; then
            mkdir -p "$dest_path"
        else
            mkdir -p "$(dirname "$dest_path")"
            cp -a "$src" "$dest_path"
        fi
    done < <(find "$src_root" -mindepth 1 -print0)
done

# ---------- Run arkhelper ----------
echo
echo "Building Wii ARK from $TEMP_ARK -> $OUT_DIR"
if ! "$ARKHELPER_PATH" dir2ark "$TEMP_ARK" "$OUT_DIR" -n "patch_wii" -e -v 5 -s 4073741823; then
    FAILED_ARK_BUILD=1
fi

# (cleanup will run via trap)

# ---------- Result message ----------
echo
if [[ "$FAILED_ARK_BUILD" -ne 1 ]]; then
    echo "Successfully built Green Day Rock Band Ultimate ARK files."
else
    echo "Error building ARK."
fi
