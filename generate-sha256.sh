#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <PKGBUILD_directory>"
    exit 1
fi

cd "$1"

# Check if PKGBUILD exists
if [ ! -f "PKGBUILD" ]; then
    echo "PKGBUILD not found in $1"
    exit 1
fi

# Download source files first
makepkg --nobuild --noprepare --nocheck

# Generate SHA256 sum
sha256=$(makepkg --geninteg | grep 'sha256sums=' | sed "s/sha256sums=('//" | sed "s/')//" )

if [ -z "$sha256" ]; then
    echo "Failed to generate SHA256 sum"
    exit 1
fi

# Update PKGBUILD
sed -i "s/sha256sums=('[^']*')/sha256sums=('$sha256')/" PKGBUILD

echo "SHA256 sum updated in PKGBUILD: $sha256"

# Clean up source files
rm -f *.tar.gz