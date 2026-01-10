# ClaudeCircle 🐳

[![Docker](https://img.shields.io/badge/Docker-Required-blue.svg)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![GitHub](https://img.shields.io/badge/GitHub-RchGrav%2Fclaudecircle-blue.svg)](https://github.com/RchGrav/claudecircle)

The Ultimate Claude Code Docker Development Environment - Run Claude AI's coding assistant in a fully containerized, reproducible environment with pre-configured development profiles and MCP servers.

```
 ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗
██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝
██║     ██║     ███████║██║   ██║██║  ██║█████╗
██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝
╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗
 ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝

 ██████╗██╗██████╗  ██████╗██╗     ███████╗
██╔════╝██║██╔══██╗██╔════╝██║     ██╔════╝
██║     ██║██████╔╝██║     ██║     █████╗
██║     ██║██╔══██╗██║     ██║     ██╔══╝
╚██████╗██║██║  ██║╚██████╗███████╔███████╗
 ╚═════╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═════╝
```

## 🚀 What's New in ClaudeCircle (v2.0.0)

ClaudeCircle is the next evolution of ClaudeBox, featuring:

- **Multi-Slot Container System**: Run multiple authenticated Claude instances per project simultaneously
  - `claudecircle create` - Create new container slots
  - `claudecircle slots` - View all slots with auth status
  - `claudecircle slot <n>` - Launch specific numbered slot
- **Project Slot Management**: Each slot maintains separate authentication and state
- **Enhanced Agent SDK**: New `/ccircle` commands for agent development workflows
- **Tutorial Documentation**: Comprehensive guides for single-agent and multi-agent setups
- **Improved CI/CD**: Robust Bash 3.2 compatibility tests and shellcheck validation
- **Renamed from ClaudeBox**: All references updated to ClaudeCircle
- **Enhanced UI/UX**: Improved menu alignment and comprehensive info display
- **New `profiles` Command**: Quick listing of all available profiles with descriptions
- **Firewall Management**: New `allowlist` command to view/edit network allowlists
- **Per-Project Isolation**: Separate Docker images, auth state, history, and configs
- **Improved Clean Menu**: Clear descriptions showing exact paths that will be removed
- **Profile Management Menu**: Interactive profile command with status and examples
- **Persistent Project Data**: Auth state, shell history, and tool configs preserved
- **Smart Profile Dependencies**: Automatic dependency resolution (e.g., C includes build-tools)

## ✨ Features

- **Containerized Environment**: Run Claude Code in an isolated Docker container
- **Development Profiles**: Pre-configured language stacks (C/C++, Python, Rust, Go, etc.)
- **Project Isolation**: Complete separation of images, settings, and data between projects
- **Persistent Configuration**: Settings and data persist between sessions
- **Multi-Instance Support**: Work on multiple projects simultaneously
- **Package Management**: Easy installation of additional development tools
- **Auto-Setup**: Handles Docker installation and configuration automatically
- **Security Features**: Network isolation with project-specific firewall allowlists
- **Developer Experience**: GitHub CLI, Delta, fzf, and zsh with oh-my-zsh powerline
- **Python Virtual Environments**: Automatic per-project venv creation with uv
- **Cross-Platform**: Works on Ubuntu, Debian, Fedora, Arch, and more
- **Shell Experience**: Powerline zsh with syntax highlighting and autosuggestions
- **Tmux Integration**: Seamless tmux socket mounting for multi-pane workflows

## 📋 Prerequisites

- Linux or macOS (WSL2 for Windows)
- Bash shell
- Docker (will be installed automatically if missing)

## 🛠️ Installation

ClaudeCircle v2.0.0 offers two installation methods:

### Method 1: Self-Extracting Installer (Recommended)

The self-extracting installer is ideal for automated setups and quick installation:

```bash
# Download the latest release
wget https://github.com/RchGrav/claudecircle/releases/latest/download/claudecircle.run
chmod +x claudecircle.run
./claudecircle.run
```

This will:
- Extract ClaudeCircle to `~/.claudecircle/source/`
- Create a symlink at `~/.local/bin/claudecircle` (you may need to add `~/.local/bin` to your PATH)
- Show setup instructions if PATH configuration is needed

### Method 2: Archive Installation

For manual installation or custom locations, use the archive:

```bash
# Download the archive
wget https://github.com/RchGrav/claudecircle/releases/latest/download/claudecircle-2.0.0.tar.gz

# Extract to your preferred location
mkdir -p ~/my-tools/claudecircle
tar -xzf claudecircle-2.0.0.tar.gz -C ~/my-tools/claudecircle

# Run main.sh to create symlink
cd ~/my-tools/claudecircle
./main.sh

# Or create your own symlink
ln -s ~/my-tools/claudecircle/main.sh ~/.local/bin/claudecircle
```

### Development Installation

For development or testing the latest changes:
```bash
# Clone the repository
git clone https://github.com/RchGrav/claudecircle.git
cd claudecircle

# Build the installer
bash .builder/build.sh

# Run the installer
./claudecircle.run
```

### PATH Configuration

If `claudecircle` command is not found after installation, add `~/.local/bin` to your PATH:

```bash
# For Bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# For Zsh (macOS default)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

The installer will:
- ✅ Extract ClaudeCircle to `~/.claudecircle/source/`
- ✅ Create symlink at `~/.local/bin/claudecircle`
- ✅ Check for Docker (install if needed on first run)
- ✅ Configure Docker for non-root usage (on first run)


## 📚 Usage

### Basic Usage

```bash
# Launch Claude Code CLI
claudecircle

# Pass arguments to Claude
claudecircle --model opus -c

# Save your arguments so you don't need to type them every time
claudecircle --model opus -c

# View the Claudecircle info screen
claudecircle info

# Get help
claudecircle --help        # Shows Claude help with ClaudeCircle additions
```

### Multi-Instance Support

ClaudeCircle supports running multiple instances in different projects simultaneously:

```bash
# Terminal 1 - Project A
cd ~/projects/website
claudecircle

# Terminal 2 - Project B
cd ~/projects/api
claudecircle shell

# Terminal 3 - Project C
cd ~/projects/ml-model
claudecircle profile python ml
```

Each project maintains its own:
- Docker image (`claudecircle-<project-name>`)
- Language profiles and installed packages
- Firewall allowlist
- Python virtual environment
- Memory and context (via MCP)
- Claude configuration (`.claude.json`)

### Development Profiles

ClaudeCircle includes 15+ pre-configured development environments:

```bash
# List all available profiles with descriptions
claudecircle profiles

# Interactive profile management menu
claudecircle profile

# Check current project's profiles
claudecircle profile status

# Install specific profiles (project-specific)
claudecircle profile python ml       # Python + Machine Learning
claudecircle profile c openwrt       # C/C++ + OpenWRT
claudecircle profile rust go         # Rust + Go
```

#### Available Profiles:

**Core Profiles:**
- **core** - Core Development Utilities (compilers, VCS, shell tools)
- **build-tools** - Build Tools (CMake, autotools, Ninja)
- **shell** - Optional Shell Tools (fzf, SSH, man, rsync, file)
- **networking** - Network Tools (IP stack, DNS, route tools)

**Language Profiles:**
- **c** - C/C++ Development (debuggers, analyzers, Boost, ncurses, cmocka)
- **rust** - Rust Development (installed via rustup)
- **python** - Python Development (managed via uv)
- **go** - Go Development (installed from upstream archive)
- **flutter** - Flutter Framework (installed using fvm, use FLUTTER_SDK_VERSION to set different version)
- **javascript** - JavaScript/TypeScript (Node installed via nvm)
- **java** - Java Development (Latest LTS via SDKMan, Maven, Gradle, Ant)
- **ruby** - Ruby Development (gems, native deps, XML/YAML)
- **php** - PHP Development (PHP + extensions + Composer)

**Specialized Profiles:**
- **openwrt** - OpenWRT Development (cross toolchain, QEMU, distro tools)
- **database** - Database Tools (clients for major databases)
- **devops** - DevOps Tools (Docker, Kubernetes, Terraform, etc.)
- **web** - Web Dev Tools (nginx, HTTP test clients)
- **embedded** - Embedded Dev (ARM toolchain, serial debuggers)
- **datascience** - Data Science (Python, Jupyter, R)
- **security** - Security Tools (scanners, crackers, packet tools)
- **ml** - Machine Learning (build layer only; Python via uv)

### Default Flags Management

Save your preferred security flags to avoid typing them every time:

```bash
# Save default flags
claudecircle save --enable-sudo --disable-firewall

# Clear saved flags
claudecircle save

# Now all claudecircle commands will use your saved flags automatically
claudecircle  # Will run with sudo and firewall disabled
```

### Project Information

View comprehensive information about your ClaudeCircle setup:

```bash
# Show detailed project and system information
claudecircle info
```

The info command displays:
- **Current Project**: Path, ID, and data directory
- **ClaudeCircle Installation**: Script location and symlink
- **Saved CLI Flags**: Your default flags configuration
- **Claude Commands**: Global and project-specific custom commands
- **Project Profiles**: Installed profiles, packages, and available options
- **Docker Status**: Image status, creation date, layers, running containers
- **All Projects Summary**: Total projects, images, and Docker system usage

### Package Management

```bash
# Install additional packages (project-specific)
claudecircle install htop vim tmux

# Open a powerline zsh shell in the container
claudecircle shell

# Update Claude CLI
claudecircle update

# View/edit firewall allowlist
claudecircle allowlist
```

### Tmux Integration

ClaudeCircle provides tmux support for multi-pane workflows:

```bash
# Launch ClaudeCircle with tmux support
claudecircle tmux

# If you're already in a tmux session, the socket will be automatically mounted
# Otherwise, tmux will be available inside the container

# Use tmux commands inside the container:
# - Create new panes: Ctrl+b % (vertical) or Ctrl+b " (horizontal)
# - Switch panes: Ctrl+b arrow-keys  
# - Create new windows: Ctrl+b c
# - Switch windows: Ctrl+b n/p or Ctrl+b 0-9
```

ClaudeCircle automatically detects and mounts existing tmux sockets from the host, or provides tmux functionality inside the container for powerful multi-context workflows.

### Task Engine

ClaudeCircle contains a compact task engine for reliable code generation tasks:

```bash
# In Claude, use the task command
/task

# This provides a systematic approach to:
# - Breaking down complex tasks
# - Implementing with quality checks
# - Iterating until specifications are met
```

### Security Options

```bash
# Run with sudo enabled (use with caution)
claudecircle --enable-sudo

# Disable network firewall (allows all network access)
claudecircle --disable-firewall

# Skip permission checks
claudecircle --dangerously-skip-permissions
```

### Maintenance

```bash
# Interactive clean menu
claudecircle clean

# Project-specific cleanup options
claudecircle clean --project          # Shows submenu with options:
  # profiles - Remove profile configuration (*.ini file)
  # data     - Remove project data (auth, history, configs, firewall)
  # docker   - Remove project Docker image
  # all      - Remove everything for this project

# Global cleanup options
claudecircle clean --containers       # Remove ClaudeCircle containers
claudecircle clean --image           # Remove containers and current project image
claudecircle clean --cache           # Remove Docker build cache
claudecircle clean --volumes         # Remove ClaudeCircle volumes
claudecircle clean --all             # Complete Docker cleanup

# Rebuild the image from scratch
claudecircle rebuild
```

## 🔧 Configuration

ClaudeCircle stores data in:
- `~/.claude/` - Global Claude configuration (mounted read-only)
- `~/.claudecircle/` - Global ClaudeCircle data
- `~/.claudecircle/profiles/` - Per-project profile configurations (*.ini files)
- `~/.claudecircle/<project-name>/` - Project-specific data:
  - `.claude/` - Project auth state
  - `.claude.json` - Project API configuration
  - `.zsh_history` - Shell history
  - `.config/` - Tool configurations
  - `firewall/allowlist` - Network allowlist
- Current directory mounted as `/workspace` in container

### Project-Specific Features

Each project automatically gets:
- **Docker Image**: `claudecircle-<project-name>` with installed profiles
- **Profile Configuration**: `~/.claudecircle/profiles/<project-name>.ini`
- **Python Virtual Environment**: `.venv` created with uv when Python profile is active
- **Firewall Allowlist**: Customizable per-project network access rules
- **Claude Configuration**: Project-specific `.claude.json` settings

### Environment Variables

- `ANTHROPIC_API_KEY` - Your Anthropic API key
- `NODE_ENV` - Node environment (default: production)

## 🏗️ Architecture

ClaudeCircle creates a per-project Debian-based Docker image with:
- Node.js (via NVM for version flexibility)
- Claude Code CLI (@anthropic-ai/claude-code)
- User account matching host UID/GID
- Network firewall (project-specific allowlists)
- Volume mounts for workspace and configuration
- GitHub CLI (gh) for repository operations
- Delta for enhanced git diffs (version 0.17.0)
- uv for fast Python package management
- Nala for improved apt package management
- fzf for fuzzy finding
- zsh with oh-my-zsh and powerline theme
- Profile-specific development tools with intelligent layer caching
- Persistent project state (auth, history, configs)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🐛 Troubleshooting

### Docker Permission Issues
ClaudeCircle automatically handles Docker setup, but if you encounter issues:
1. The script will add you to the docker group
2. You may need to log out/in or run `newgrp docker`
3. Run `claudecircle` again

### Profile Installation Failed
```bash
# Clean and rebuild for current project
claudecircle clean --project
claudecircle rebuild
claudecircle profile <name>
```

### Profile Changes Not Taking Effect
ClaudeCircle automatically detects profile changes and rebuilds when needed. If you're having issues:
```bash
# Force rebuild
claudecircle rebuild
```

### Python Virtual Environment Issues
ClaudeCircle automatically creates a venv when Python profile is active:
```bash
# The venv is created at ~/.claudecircle/<project>/.venv
# It's automatically activated in the container
claudecircle shell
which python  # Should show the venv python
```

### Can't Find Command
Ensure the symlink was created:
```bash
ls -la ~/.local/bin/claudecircle
# Or manually create it
ln -s /path/to/claudecircle ~/.local/bin/claudecircle
```

### Multiple Instance Conflicts
Each project has its own Docker image and is fully isolated. To check status:
```bash
# Check all ClaudeCircle images and containers
claudecircle info

# Clean project-specific data
claudecircle clean --project
```

### Build Cache Issues
If builds are slow or failing:
```bash
# Clear Docker build cache
claudecircle clean --cache

# Complete cleanup and rebuild
claudecircle clean --all
claudecircle
```

## 🎉 Acknowledgments

- [RchGrav](@RchGrav) for ClaudeBox
- [Anthropic](https://www.anthropic.com/) for Claude AI
- [Model Context Protocol](https://github.com/anthropics/model-context-protocol) for MCP servers
- Docker community for containerization tools
- All the open-source projects included in the profiles

---

Made with ❤️ for developers who love clean, reproducible environments

## Contact

**Author/Maintainer:** GDRS  
**GitHub:** [@GDRS](https://github.com/gburachas)
