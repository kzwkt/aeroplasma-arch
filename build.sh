#!/usr/bin/env bash
set -euo pipefail

# Packages ordered correctly by dependency hierarchy
packages=(
  uac-polkit-agent-git
  aerothemeplasma-sounds-git
  aerothemeplasma-icons-git
  aeroshell-libplasma-git
  aeroshell-kwin-components-git
  aeroshell-smod-git
  aeroshell-workspace-git
  aerothemeplasma-desktop-git
)

# Define absolute or clear output directory path
OUTPUT_DIR="$PWD/output"
mkdir -p "$OUTPUT_DIR"

# Build each package
for pkg in "${packages[@]}"; do
  echo "==> Building $pkg"
  
  rm -rf "$pkg"
  git clone "https://aur.archlinux.org/$pkg.git"
  
  pushd "$pkg" >/dev/null
  
  # Build package (auto install deps, no prompts)
  makepkg -s --noconfirm --needed --skippgpcheck || {
    echo "==> ERROR: Failed to build $pkg"
    exit 1
  }
  
  # Move built package to output directory first
  mv *.pkg.tar.* "$OUTPUT_DIR/"
  
  # Find the newly built package in OUTPUT_DIR and install it locally with sudo
  built_package=$(find "$OUTPUT_DIR" -maxdepth 1 -name "$pkg-*.pkg.tar.*" -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" ")
  
  echo "==> Installing local package: $(basename "$built_package")"
  sudo pacman -U --noconfirm "$built_package"
  
  popd >/dev/null
done

echo "==> All packages built successfully!"
