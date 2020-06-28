FROM debian:buster


# Get the repos we need for clang
# Pickup backports for compilier documentation
RUN echo deb http://deb.debian.org/debian buster-backports main contrib non-free | tee /etc/apt/sources.list.d/buster-backports.list

RUN set -ex && \
    apt-get upgrade && \
    apt-get update && \
    ln -s /lib /lib64 && \
    apt-get -y install bash tini && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd && \
    apt-get -y install apt-utils ca-certificates

# Setup Build Env
RUN apt-get -y install build-essential software-properties-common lsb-release wget git curl locales && \
    apt-get -y install libreadline-dev zlib1g-dev libbz2-dev liblzma-dev && \
    apt-get -y install libpcre3 libpcre3-dev libcurl4-openssl-dev libssl-dev openssl  && \
    apt-get -y install xz-utils libxml2-dev libpq-dev unzip  && \
    apt-get -y install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config gfortran man info && \
    rm -rf /var/cache/apt/*

# Get man and info pages
RUN apt-get -y install -t buster-backports gcc-doc gfortran-doc

# Install LLVM "CLANG" for ccls language service
RUN cat /etc/apt/sources.list
RUN apt-get -y install clang-format clang-tidy clang-tools clang 
RUN apt-get -y install libc++-dev libc++1 libc++abi-dev libc++abi1 libclang-dev 
RUN apt-get -y install libclang1 liblldb-dev libllvm-ocaml-dev libomp-dev libomp5 
RUN apt-get -y install lld lldb llvm-dev llvm-runtime llvm 

# Setup the System
USER root
ENV DEBIAN_FRONTEND noniteractive

# Setup Local to be UTF-8 requried by neovim
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Set Dev tools aka neovim, fortran-language-server and sympy
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN apt-get -y install python3-pip lua5.3
RUN pip3 install --upgrade clang
RUN pip3 install --upgrade ipython sympy
# Prep nodejs for neovim
RUN npm install -g neovim
RUN npm install -g yarn
# Prep python3 for neovim
RUN pip3 install --upgrade sympy nose jedi
RUN pip3 install --upgrade msgpack neovim fortran-language-server setuptools nodejs

# Get and install neovim editor
WORKDIR /tmp
RUN git clone https://github.com/neovim/neovim.git
WORKDIR $HOME/tmp/neovim
RUN git checkout stable
RUN make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/usr/local/
RUN make install
WORKDIR /tmp
RUN rm -rf neovim

# Install C/C++ Lanaguage Service
RUN git clone --depth=1 --recursive https://github.com/MaskRay/ccls && \
  cd ccls && \
  cmake -GNinja -H. -BRelease -DCMAKE_BUILD_TYPE=Release && \
  cmake --build Release --target install

# Enble Color Prompt in default bash
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc

# Create Fortran User
ARG FT_USER="baudekin"
ARG FT_UID="1000"
ARG FT_GID="100"

# Add the user baudekin to the system
RUN useradd -m -s /bin/bash -N -u $FT_UID $FT_USER && \
    usermod -aG sudo $FT_USER
RUN echo "$FT_USER:changeme1" | chpasswd

# Get Neovim init file
ENV HOME /home/$FT_USER
COPY ./config $HOME/.config

# Fix the Permissions
RUN chown -R $FT_USER:$FT_GID $HOME

USER $FT_UID
WORKDIR $HOME

# Setup vi usage
RUN echo "export EDITOR=/usr/local/bin/nvim" >> $HOME/.bashrc
RUN echo "export FCEDIT=${EDITOR}" >> $HOME/.bashrc
RUN echo "export VISUAL=${EDITOR}" >> $HOME/.bashrc
RUN echo "set -o vi" >> $HOME/.bashrc
RUN echo "alias vi=nvim" >> $HOME/.bashrc

# Setup fortran language server useage ingnore case
RUN echo "{" > $HOME/.fortls
RUN echo '  "excl_suffixes": ["_skip.f90"],' >> $HOME/.fortls
RUN echo '  "pp_suffixes": [".f03", ".F90"],' >> $HOME/.fortls
RUN echo '  "pp_defs": {"HAVE_PACKAGE": ""},' >> $HOME/.fortls
RUN echo '  "lowercase_intrinsics": true,' >> $HOME/.fortls
RUN echo '  "debug_log": false' >> $HOME/.fortls
RUN echo "}" >> $HOME/.fortls

# Setup ipython with default profile
RUN ipython profile create
## Use vi binding for ipython
RUN echo "c.TerminalInteractiveShell.editing_mode = 'vi'" >> $HOME/.ipython/profile_default/ipython_config.py


# Install neovim plugin manager
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# Install and update plugins. Note the spinning up of nvim
# Will cause errors but running the "PlugInstall" and "UpdateRemotePlugs" 
# Commands fixes the errors
RUN nvim --headless +PlugInstall +UpdateRemotePlugins +qa
# Install COC extentions
RUN mkdir $HOME/.config/coc
RUN mkdir $HOME/.config/coc/extensions
WORKDIR $HOME/.config/coc/extensions
RUN yarn add coc-json coc-tsserver coc-python
WORKDIR $HOME
CMD ["bash"]
