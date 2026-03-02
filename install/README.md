# Installers

Public installer scripts for Artalytics developer tools. Each script downloads the latest release binary from a private GitHub repo — `GITHUB_TOKEN` must be set in your environment before running.

## CLI

| Script | Platform | Command |
|--------|----------|---------|
| [cli/art.sh](cli/art.sh) | macOS, Ubuntu, WSL | `curl -fsSL $ART_INSTALL/cli/art.sh \| bash` |
| [cli/art.ps1](cli/art.ps1) | Windows (PowerShell) | `irm $ART_INSTALL/cli/art.ps1 \| iex` |

### Prerequisites

- `GITHUB_TOKEN` — GitHub PAT with `repo` scope ([create one](https://github.com/settings/tokens))

### What gets installed

1. **art** binary at `~/.local/bin/art` (Unix) or `%USERPROFILE%\.local\bin\art.exe` (Windows)
2. **Claude Code** — installed automatically if not already present

### Post-install

```bash
art login    # Authenticate with Claude
art setup    # Install plugins and build profiles
```

### Environment variable shorthand

```bash
export ART_INSTALL="https://raw.githubusercontent.com/artalytics/.github/main/install"
curl -fsSL $ART_INSTALL/cli/art.sh | bash
```
