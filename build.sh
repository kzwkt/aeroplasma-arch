#!/usr/bin/env bash
set -euo pipefail

# Packages to build
packages=(
  uac-polkit-agent
  aerothemeplasma-desktop
  aeroshell-libplasma
  aeroshell-workspace
  aeroshell-kwin-components
  aeroshell-smod
  aerothemeplasma-sounds
  aerothemeplasma-icons
)

# Ensure required tools exist
echo "==> Installing base dependencies"
pacman -Syu --noconfirm base-devel git

# Create output dir
mkdir -p output

# Build each package
for pkg in "${packages[@]}"; do
  echo "==> Building $pkg"
  
  rm -rf "$pkg"
  git clone "https://aur.archlinux.org/$pkg.git"
  
  pushd "$pkg" >/dev/null
  
  # Build package (auto install deps, no prompts)
  makepkg -s --noconfirm --needed
  
  # Move built package
  mv *.pkg.tar.* ../output/
  
  popd >/dev/null
done

echo "==> All packages built successfully"
