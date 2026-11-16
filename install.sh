#!/bin/sh
# Install or update the pingdrop command.
#
#   curl -fsSL https://raw.githubusercontent.com/pingdrop/releases/main/install.sh | sh
#
# PINGDROP_VERSION=v0.1.0   install that release instead of the latest
# PINGDROP_INSTALL_DIR=dir  install there instead of /usr/local/bin
set -eu

repo=pingdrop/releases
dir=${PINGDROP_INSTALL_DIR:-/usr/local/bin}

case $(uname -s) in
  Darwin) os=darwin ;;
  Linux)  os=linux ;;
  *) echo "pingdrop: no build for $(uname -s) yet" >&2; exit 1 ;;
esac
case $(uname -m) in
  arm64|aarch64) arch=arm64 ;;
  x86_64|amd64)  arch=amd64 ;;
  *) echo "pingdrop: no build for $(uname -m) yet" >&2; exit 1 ;;
esac
file=pingdrop-$os-$arch

if [ -n "${PINGDROP_VERSION:-}" ]; then
  url=https://github.com/$repo/releases/download/$PINGDROP_VERSION
else
  url=https://github.com/$repo/releases/latest/download
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
echo "downloading $file ..."
curl -fsSL -o "$tmp/$file" "$url/$file"
curl -fsSL -o "$tmp/checksums.txt" "$url/checksums.txt"

# the file must be the one the release lists
want=$(awk -v f="$file" '$2 == f {print $1}' "$tmp/checksums.txt")
if command -v sha256sum >/dev/null 2>&1; then
  got=$(sha256sum "$tmp/$file" | awk '{print $1}')
else
  got=$(shasum -a 256 "$tmp/$file" | awk '{print $1}')
fi
if [ -z "$want" ] || [ "$want" != "$got" ]; then
  echo "pingdrop: the download does not match its checksum, not installing" >&2
  exit 1
fi

chmod +x "$tmp/$file"
if [ -d "$dir" ] && [ -w "$dir" ]; then
  mv "$tmp/$file" "$dir/pingdrop"
else
  echo "installing to $dir needs your password (sudo)"
  sudo mkdir -p "$dir"
  sudo mv "$tmp/$file" "$dir/pingdrop"
fi

echo "installed: $("$dir/pingdrop" version)"
case ":$PATH:" in
  *":$dir:"*) ;;
  *) echo "note: $dir is not on your PATH" ;;
esac
echo "next: pingdrop login, then sudo pingdrop up"
