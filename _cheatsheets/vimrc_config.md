---
layout: cheatsheet
title: "My Vim Configuration"
description: "A comprehensive vimrc setup for enhanced productivity"
date: 2025-04-25
categories: [tools, productivity]
tags: [vim, vimrc, editor, configuration, linux]
---

## Complete vimrc Configuration

This is my personal vim configuration that enhances visual appearance, improves workflow, and adds useful shortcuts.

### Visual Enhancements

```vim
" ===== VISUAL ENHANCEMENTS =====
" Line numbers and display
set number                    " Show line numbers
set cursorline               " Highlight the current line
set ruler                    " Show cursor position in status line
set showcmd                  " Show partial commands in status line
set showmatch                " Highlight matching brackets/parentheses

" Colors and syntax
syntax enable                " Enable syntax highlighting
set background=dark          " Use dark background for better contrast
colorscheme desert           " Bright, vibrant color scheme
" Alternative bright schemes to try:
" colorscheme ron
" colorscheme pablo
" colorscheme torte

" Status line configuration
set laststatus=2            " Always show status line
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}

" Visual guides
set colorcolumn=80          " Show column at 80 characters
set list                    " Show invisible characters
set listchars=tab:→\ ,trail:·,extends:>,precedes:<,nbsp:+
```

### Behavioral Enhancements

```vim
" ===== BEHAVIORAL ENHANCEMENTS =====
" Indentation and tabs
set autoindent              " Automatically indent new lines
set smartindent             " Smart auto-indenting
set expandtab               " Use spaces instead of tabs
set tabstop=4               " Tab width is 4 spaces
set shiftwidth=4            " Indent width is 4 spaces
set softtabstop=4           " Backspace deletes 4 spaces

" Search behavior
set ignorecase              " Case-insensitive search
set smartcase               " Case-sensitive if uppercase letters used
set incsearch               " Incremental search (highlight as you type)
set hlsearch                " Highlight all search matches

" File handling
set autoread                " Automatically reload files changed outside vim
set backup                  " Create backup files
set backupdir=~/.vim/backup " Store backups in specific directory
set directory=~/.vim/swap   " Store swap files in specific directory
set undofile                " Persistent undo across sessions
set undodir=~/.vim/undo     " Store undo files in specific directory

" Editor behavior
set backspace=indent,eol,start  " Allow backspace over everything
set scrolloff=5             " Keep 5 lines visible above/below cursor
set wrap                    " Wrap long lines
set linebreak               " Break lines at word boundaries
set mouse=a                 " Enable mouse support
```

### Workflow Enhancements

```vim
" ===== WORKFLOW ENHANCEMENTS =====
" Remember cursor position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Custom key mappings
" Clear search highlighting with Escape
nnoremap <Esc> :nohlsearch<CR>

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" Navigate between split windows easily
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Toggle line numbers
nnoremap <F2> :set number!<CR>

" Toggle relative line numbers
nnoremap <F3> :set relativenumber!<CR>

" Abbreviations for common typos and phrases
iabbrev teh the
iabbrev adn and
iabbrev recieve receive
iabbrev seperate separate
```

### File Type Specific Settings

```vim
" ===== FILE TYPE SPECIFIC =====
" Different settings for different file types
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType html setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType css setlocal tabstop=2 shiftwidth=2 expandtab
```

### Performance Optimizations

```vim
" ===== PERFORMANCE =====
set lazyredraw              " Don't redraw during macros
set ttyfast                 " Fast terminal connection
```

### Setup Script

```vim
" ===== SETUP DIRECTORIES =====
" Create necessary directories if they don't exist
if !isdirectory($HOME."/.vim/backup")
    call mkdir($HOME."/.vim/backup", "p")
endif
if !isdirectory($HOME."/.vim/swap")
    call mkdir($HOME."/.vim/swap", "p")
endif
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "p")
endif
```

## Quick Installation

1. **Backup your existing vimrc** (if you have one):
   ```bash
   cp ~/.vimrc ~/.vimrc.backup
   ```

2. **Create the new vimrc**:
   ```bash
   vim ~/.vimrc
   ```

3. **Copy the entire configuration** above and paste it into the file

4. **Create required directories**:
   ```bash
   mkdir -p ~/.vim/{backup,swap,undo}
   ```

5. **Restart vim** to see the changes

## Key Features

### Visual Improvements
- Line numbers with current line highlighting
- 80-character column guide
- Visible whitespace characters
- Enhanced status line with file info and time
- Dark background with vibrant syntax highlighting

### Smart Editing
- Auto-indentation with 4-space tabs
- Smart case-sensitive searching
- Persistent undo across sessions
- Mouse support enabled
- Auto-reload of externally changed files

### Custom Shortcuts
| Shortcut | Action |
|----------|--------|
| `<leader>w` | Quick save |
| `<leader>q` | Quick quit |
| `<leader>x` | Save and quit |
| `Ctrl+h/j/k/l` | Navigate splits |
| `F2` | Toggle line numbers |
| `F3` | Toggle relative numbers |
| `Esc` | Clear search highlighting |

### File Type Intelligence
- Python: 4-space indentation
- JavaScript/HTML/CSS: 2-space indentation
- Automatic formatting based on file type

## Customization Tips

1. **Change Color Scheme**: Try `ron`, `pablo`, or `torte` instead of `desert`
2. **Adjust Tab Width**: Change `tabstop`, `shiftwidth`, and `softtabstop` values
3. **Add More Abbreviations**: Add your common typos to the abbreviations section
4. **Modify Status Line**: Customize the `statusline` setting for different information

## Troubleshooting

- **Colors look wrong?** Make sure your terminal supports 256 colors
- **Backups not working?** Ensure the directories exist: `mkdir -p ~/.vim/{backup,swap,undo}`
- **Mouse not working?** Your terminal might not support mouse mode

---

*This configuration has been refined over years of daily vim usage and strikes a balance between functionality and simplicity.*
