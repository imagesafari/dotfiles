
About
-----

This repository contains my personal dotfiles, which I use on unix systems of
varying flavors. They are published here because I occasionally want to share
them or use them as examples, and this is an easy way to do so. Feel free to
use anything you find here.

Compatibility
-------------

I am a bash user; much of the shell environment may well work in other advanced
Bourne derivatives such as zsh, but some of it will break.

I regularly use this setup with Mac OS X, Solaris, Linux and FreeBSD systems.

Some parts of the Bash and Vim configs may assume you have 256 color support in
your terminal. If you are using Apple Terminal before OS X Lion, you don't.
Try iTerm2 instead.

<http://sites.google.com/site/iterm2home/>

I have written two blog posts on the subject of iTerm and iTerm2. Give them a
read; color support is only one of several good reasons to switch.

<http://tangledhelix.com/blog/2010/11/20/iterm-terminal/>

<http://tangledhelix.com/blog/2010/12/06/iterm2-iterm/>

Shell colors in bash
--------------------

The colors in the prompt ($PS1) are currently set up assuming the terminal
is using [Solarized][] as a color scheme. They may not look very good in
other terminal setups.

[solarized]: http://ethanschoonover.com/solarized

Installation
------------

    umask 0022
    git clone https://github.com/tangledhelix/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    git submodule init
    git submodule update

To install my dotfiles as *your* dotfiles, you can create symlinks with `rake`.
If you do *not* run the rake command, everything will be isolated inside of
the `.dotfiles` directory and will not interfere with your existing environment.

    rake install

Rake will ask you before overwriting any files that already exist.

Occasionally I run into a system where rake isn't installed and I can't
easily install it. For those cases, I have `install.sh`, which does the
job, but isn't as graceful.

Submodules
----------

Because there are submodules, and some will end up generating vim docs "tags"
files, you may end up seeing stuff like this, which gets annoying:

    dan@mercury{0}[0]$ git status
    # On branch master
    # Changed but not updated:
    #   (use "git add <file>..." to update what will be committed)
    #   (use "git checkout -- <file>..." to discard changes in working directory)
    #   (commit or discard the untracked or modified content in submodules)
    #
    #       modified:   vim/bundle/L9 (untracked content)
    #       modified:   vim/bundle/fuzzyfinder (untracked content)
    #       modified:   vim/bundle/nerd_commenter (untracked content)
    #       modified:   vim/bundle/snipmate (untracked content)
    #       modified:   vim/bundle/surround (untracked content)
    #       modified:   vim/bundle/unimpaired (untracked content)
    #       modified:   vim/bundle/yankring (untracked content)
    #
    no changes added to commit (use "git add" and/or "git commit -a")

My `~/.gitconfig` file sets up `~/.gitignore` for global ignoring of certain
files. `~/.gitignore` contains `doc/tags` and `doc/tags-ja` to prevent this
output from happening due to vim's tag files.

With recent versions of git, you can also use the `--ignore-submodule` flag
on `git` commands such as `status`.

