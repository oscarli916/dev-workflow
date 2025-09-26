# dev-workflow

Lightweight developer workflow dotfiles and Docker helper.

Repository layout

- `Dockerfile` — a container definition (purpose: developer environment or tooling). Review the file before use.
- `neovim/` — Neovim configuration (contains `init.lua`).
- `tmux/` — tmux configuration files.

Quick start

1. Inspect the `Dockerfile` and adapt as needed. This repository does not pin a specific base image or versions — check the top of the file for details.

2. Build the Docker image (from repository root):

```bash
docker build -t dev-workflow .
```

3. Run a container interactively and mount your home directory (optional):

```bash
docker run -it -v /path/to/your/directory:/home/dev dev-workflow bash
```
