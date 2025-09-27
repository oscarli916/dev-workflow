FROM ubuntu:24.04

# install neovim
RUN apt update && \
    apt install -y ninja-build gettext cmake curl build-essential git && \
    git clone https://github.com/neovim/neovim /tmp/neovim && \
    cd /tmp/neovim && \
    # specific neovim version here
    git checkout v0.11.4 && \
    make CMAKE_BUILD_TYPE=RelWithDebInfo && \
    make install && \
    rm -rf /tmp/neovim

# install dependencies for kickstart.nvim
RUN apt install -y fd-find ripgrep unzip xclip

# install tmux
RUN apt install -y automake pkg-config libevent-dev libncurses5-dev bison && \
    git clone https://github.com/tmux/tmux.git /tmp/tmux && \
    cd /tmp/tmux && \
    # specific tmux version here
    git checkout 3.5 && \
    sh autogen.sh && \
    ./configure && make && \
    make install && \
    rm -rf /tmp/tmux

# install locale
RUN apt install -y locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

# Create a dev user and group
RUN groupadd -r -g 1001 dev && \
    useradd -m -u 1001 -g dev -s /bin/bash dev

# Install sudo and allow passwordless sudo for the dev user
RUN apt install -y sudo && \
    echo "dev ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev && \
    chmod 0440 /etc/sudoers.d/dev

# Create neovim config directory for dev user
RUN mkdir -p /home/dev/.config/nvim
COPY neovim/init.lua /home/dev/.config/nvim/init.lua
# Create tmux config file for dev user
COPY tmux/.tmux.conf /home/dev/.tmux.conf

RUN chown -R dev:dev /home/dev

# Set environment variables
ENV TERM=xterm-256color
ENV LANG=en_US.UTF-8

# Switch to the non-root user
USER dev

WORKDIR /home/dev/project

# install fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /home/dev/.fzf && \
    /home/dev/.fzf/install --key-bindings --completion --update-rc

CMD ["sleep", "infinity"]