# pingdrop downloads

The `pingdrop` command for macOS, Linux and Windows, and the desktop app for
Windows.

## Windows: the desktop app

Download [`pingdrop-desktop-windows-amd64-setup.exe`](https://github.com/pingdrop/releases/releases/latest/download/pingdrop-desktop-windows-amd64-setup.exe)
and run it. The installer is not signed yet, so Windows SmartScreen warns
first: choose "More info", then "Run anyway". The first time you connect,
Windows asks once for permission to install the helper that captures the
traffic.

## Install or update the command

macOS and Linux:

```sh
curl -fsSL https://raw.githubusercontent.com/pingdrop/releases/main/install.sh | sh
```

The script picks the build for your system, checks it against the release's
checksum and puts `pingdrop` in `/usr/local/bin`.

Windows, in PowerShell:

```powershell
irm https://raw.githubusercontent.com/pingdrop/releases/main/install.ps1 | iex
```

The script does the same, puts `pingdrop.exe` in
`%LOCALAPPDATA%\Programs\pingdrop` and adds that to your PATH.

| Setting | Effect |
|---|---|
| `PINGDROP_VERSION=v0.1.0` | Install that release instead of the latest |
| `PINGDROP_INSTALL_DIR=~/.local/bin` | Install there instead of `/usr/local/bin` (on Windows, `%LOCALAPPDATA%\Programs\pingdrop`) |

On Windows, set them before the command: `$env:PINGDROP_VERSION = "v0.2.0"`.

## Use

```sh
pingdrop login you@example.com    # asks for the password
sudo pingdrop up                  # connect
pingdrop status
pingdrop down

pingdrop                          # the terminal app
```

On Windows, instead of `sudo pingdrop up`: once, in a terminal opened as
administrator, `pingdrop install`; after that `pingdrop up` needs nothing.

## Download by hand

Every release is on the [releases page](https://github.com/pingdrop/releases/releases).
The newest build of each kind is always at:

| System | File |
|---|---|
| macOS, Apple silicon | [`pingdrop-darwin-arm64`](https://github.com/pingdrop/releases/releases/latest/download/pingdrop-darwin-arm64) |
| macOS, Intel | [`pingdrop-darwin-amd64`](https://github.com/pingdrop/releases/releases/latest/download/pingdrop-darwin-amd64) |
| Linux, x86-64 | [`pingdrop-linux-amd64`](https://github.com/pingdrop/releases/releases/latest/download/pingdrop-linux-amd64) |
| Linux, ARM64 | [`pingdrop-linux-arm64`](https://github.com/pingdrop/releases/releases/latest/download/pingdrop-linux-arm64) |
| Windows, x86-64 | [`pingdrop-windows-amd64.exe`](https://github.com/pingdrop/releases/releases/latest/download/pingdrop-windows-amd64.exe) |
| Windows, ARM64 | [`pingdrop-windows-arm64.exe`](https://github.com/pingdrop/releases/releases/latest/download/pingdrop-windows-arm64.exe) |
| Windows, the desktop app | [`pingdrop-desktop-windows-amd64-setup.exe`](https://github.com/pingdrop/releases/releases/latest/download/pingdrop-desktop-windows-amd64-setup.exe) |
| Checksums (SHA-256) | [`checksums.txt`](https://github.com/pingdrop/releases/releases/latest/download/checksums.txt) |

A file downloaded in a browser on macOS is blocked from running until you
clear its download flag:

```sh
chmod +x pingdrop-darwin-arm64
xattr -d com.apple.quarantine pingdrop-darwin-arm64
```

The install script does not need this.
