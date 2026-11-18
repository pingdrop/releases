# pingdrop downloads

The `pingdrop` command for macOS and Linux.

## Windows

Windows comes in a later release: the latest release has neither the
command nor the desktop app for Windows. The Windows builds of older
releases no longer work with the servers. `install.ps1` says so and
installs nothing until a release has a Windows build again.

## Install or update the command

macOS and Linux:

```sh
curl -fsSL https://raw.githubusercontent.com/pingdrop/releases/main/install.sh | sh
```

The script picks the build for your system, checks it against the release's
checksum and puts `pingdrop` in `/usr/local/bin`.

| Setting | Effect |
|---|---|
| `PINGDROP_VERSION=v0.1.0` | Install that release instead of the latest |
| `PINGDROP_INSTALL_DIR=~/.local/bin` | Install there instead of `/usr/local/bin` |

## Use

```sh
pingdrop login you@example.com    # asks for the password
sudo pingdrop up                  # connect
pingdrop status
pingdrop down

pingdrop                          # the terminal app
```

On macOS, `sudo pingdrop install` once sets up a helper; after that
`pingdrop up` needs no password.

## Download by hand

Every release is on the [releases page](https://github.com/pingdrop/releases/releases).
The newest build of each kind is always at:

| System | File |
|---|---|
| macOS, Apple silicon | [`pingdrop-darwin-arm64`](https://github.com/pingdrop/releases/releases/latest/download/pingdrop-darwin-arm64) |
| macOS, Intel | [`pingdrop-darwin-amd64`](https://github.com/pingdrop/releases/releases/latest/download/pingdrop-darwin-amd64) |
| Linux, x86-64 | [`pingdrop-linux-amd64`](https://github.com/pingdrop/releases/releases/latest/download/pingdrop-linux-amd64) |
| Linux, ARM64 | [`pingdrop-linux-arm64`](https://github.com/pingdrop/releases/releases/latest/download/pingdrop-linux-arm64) |
| Checksums (SHA-256) | [`checksums.txt`](https://github.com/pingdrop/releases/releases/latest/download/checksums.txt) |

A file downloaded in a browser on macOS is blocked from running until you
clear its download flag:

```sh
chmod +x pingdrop-darwin-arm64
xattr -d com.apple.quarantine pingdrop-darwin-arm64
```

The install script does not need this.
