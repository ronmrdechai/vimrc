# My Vim settings
Yes, I've also moved from Emacs to Vim. It's just so much faster, and besides, knowing how to use both tools comes in handy a lot. This configuration is something I put together over time, adding and tweaking things as I see fit.

## Installation
I use [Vim-Plug](https://github.com/junegunn/vim-plug) as my plugin manager. Just clone this repository into `~/.vim`, and open vim, plugin installation should happen automatically.

```
$ git clone https://github.com/ronmrdechai/vimrc ~/.vim
$ vim
```

## Features
There aren't many things in here that aren't standard in most peoples' `.vimrc`, but I do have a few things I really like:

1. Automatic plugin installation:<br>
   Vim will detect when VimPlug is missing and install it for you.
1. Making the background show up properly in `tmux`:<br>
   Setting `t_ut` to nothing seems to make your background color show up properly in `tmux`.
1. Changing the cursor shape in insert mode in iTerm2:<br>
   When in iTerm2, the cursor changes to a bar in the terminal.
1. Setting `paste` automatically:<br>
   Vim will set `paste` automatically when pasting in iTerm2.
1. Quitting _MacVim_ on exit:<br>
   The _MacVim_ app likes staying open after you close all of its windows, I added little function to quit it after no other windows are open.
1. Moving lines up and down:<br>
   This works kind of like in Eclipse or any JetBrains IDE. Pressing `C-j` or `C-k` will move a line or selection up or down.
1. CamelCase motions:<br>
   Typing `<leader>w` or `<leader>b` will skip forward and respect CamelCase words. This also works as an operator.
1. Executing the current line:<br>
   `<leader>ee` causes the current line or selection to be executed as VimScript. Useful if you're adding something to your `.vimrc` or writing a plugin.

I also use `airline` as my status line, and `Gruvbox` as my color scheme.
