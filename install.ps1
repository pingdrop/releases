# Install or update the pingdrop command on Windows.
#
#   irm https://raw.githubusercontent.com/pingdrop/releases/main/install.ps1 | iex
#
# $env:PINGDROP_VERSION = "v0.2.0"   install that release instead of the latest
# $env:PINGDROP_INSTALL_DIR = "dir"  install there instead of %LOCALAPPDATA%\Programs\pingdrop

& {
  $ErrorActionPreference = "Stop"
  $ProgressPreference = "SilentlyContinue" # the progress bar makes downloads slow
  [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

  $repo = "pingdrop/releases"
  $dir = $env:PINGDROP_INSTALL_DIR
  if (-not $dir) { $dir = Join-Path $env:LOCALAPPDATA "Programs\pingdrop" }

  # a 32 bit PowerShell on 64 bit Windows names the machine in PROCESSOR_ARCHITEW6432
  $machine = $env:PROCESSOR_ARCHITEW6432
  if (-not $machine) { $machine = $env:PROCESSOR_ARCHITECTURE }
  switch ($machine) {
    "AMD64" { $arch = "amd64" }
    "ARM64" { $arch = "arm64" }
    default { throw "pingdrop: no build for $machine yet" }
  }
  $file = "pingdrop-windows-$arch.exe"

  if ($env:PINGDROP_VERSION) {
    $url = "https://github.com/$repo/releases/download/$($env:PINGDROP_VERSION)"
  } else {
    $url = "https://github.com/$repo/releases/latest/download"
  }

  $tmp = Join-Path ([IO.Path]::GetTempPath()) ("pingdrop-" + [Guid]::NewGuid())
  New-Item -ItemType Directory -Path $tmp | Out-Null
  try {
    Write-Host "downloading $file ..."
    Invoke-WebRequest -UseBasicParsing -Uri "$url/$file" -OutFile "$tmp\$file"
    Invoke-WebRequest -UseBasicParsing -Uri "$url/checksums.txt" -OutFile "$tmp\checksums.txt"

    # the file must be the one the release lists
    $want = ""
    foreach ($line in Get-Content "$tmp\checksums.txt") {
      $f = $line -split "\s+"
      if ($f.Count -ge 2 -and $f[1].TrimStart("*") -eq $file) { $want = $f[0].ToLower() }
    }
    $got = (Get-FileHash -Algorithm SHA256 "$tmp\$file").Hash.ToLower()
    if (-not $want -or $want -ne $got) {
      throw "pingdrop: the download does not match its checksum, not installing"
    }

    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    try {
      Move-Item -Force "$tmp\$file" "$dir\pingdrop.exe"
    } catch {
      throw "pingdrop: cannot replace $dir\pingdrop.exe; is it running? Run pingdrop down, then try again ($_)"
    }
  } finally {
    Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
  }

  Write-Host "installed: $(& "$dir\pingdrop.exe" version)"
  $parts = @(([string][Environment]::GetEnvironmentVariable("Path", "User")) -split ";" | Where-Object { $_ })
  if ($parts -notcontains $dir) {
    [Environment]::SetEnvironmentVariable("Path", (($parts + $dir) -join ";"), "User")
    Write-Host "added $dir to your PATH: open a new terminal to use pingdrop"
  }
  Write-Host "next: pingdrop login; then once, in a terminal opened as administrator, pingdrop install; then pingdrop up"
}
