#!/usr/bin/env bash
set -euo pipefail

# Packages to build
packages=(
  aeroshell-libplasma-git
  aeroshell-workspace-git
  aeroshell-kwin-components-git
  aeroshell-smod-git
  uac-polkit-agent-git
  aerothemeplasma-desktop-git
  aerothemeplasma-sounds-git
  aerothemeplasma-icons-git
)


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
