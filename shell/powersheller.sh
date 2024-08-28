#!/usr/bin/env bash
# Dev: Joshua Ross
# Reason: PowerShell Install and Update Script.

# Create TMP directory
TMP=$(mktemp -d)

# Fetch the latest PowerShell .deb package URL, excluding LTS versions
LATEST=$(curl -s "https://api.github.com/repos/PowerShell/PowerShell/releases/latest" | jq -r '
  .assets[] |
  select(.name | endswith("_amd64.deb")) |
  select(.browser_download_url | startswith("https://github.com/PowerShell/PowerShell/releases/download/") | not) |
  .browser_download_url' | head -n 1)

libcu_install() {
  # Download and install libicu72 package
  wget -O "$TMP/libicu72_72.1-3ubuntu3_amd64.deb" "https://mirror.it.ubc.ca/ubuntu/pool/main/i/icu/libicu72_72.1-3ubuntu3_amd64.deb"
  sudo dpkg -i "$TMP/libicu72_72.1-3ubuntu3_amd64.deb"
}

powersheller() {
  # Download PowerShell deb package to TMP
  wget -O "$TMP/powershell.deb" "$LATEST"
  if [ ! -f "$TMP/powershell.deb" ]; then
    echo "Could not download the latest .deb package!"
    exit 1
  fi

  # Install or update PowerShell deb package
  echo "Installing PowerShell..."
  sudo dpkg -i "$TMP/powershell.deb"
}

# Update the system package list
sudo apt-get update

# Handle script arguments
case "$1" in
  install)
    libcu_install
    powersheller
    ;;
  update)
    powersheller
    ;;
  *)
    echo "Usage: $0 {install|update}"
    exit 1
    ;;
esac

# Remove TMP directory
rm -rf "$TMP"
