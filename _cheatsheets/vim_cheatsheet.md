---
layout: cheatsheet
title: "VIM Cheatsheet"
description: "VIM Notes"
date: 2025-01-25
categories: [tools, productivity]  
tags: [linux, vim, vi, nano, text-editor]
---

# Vim Cheat Sheet

> A comprehensive reference for vim commands, organized by skill level and use case.

## Table of Contents
- [Getting Started](#getting-started)
- [Modes](#modes)
- [Basic Navigation](#basic-navigation)
- [Essential Editing](#essential-editing)
- [Advanced Movement](#advanced-movement)
- [Text Objects](#text-objects)
- [Visual Mode](#visual-mode)
- [Search & Replace](#search--replace)
- [File Operations](#file-operations)
- [Buffers & Windows](#buffers--windows)
- [Macros](#macros)
- [Marks & Jumps](#marks--jumps)
- [Command Line](#command-line)
- [Configuration](#configuration)
- [Tips & Tricks](#tips--tricks)

---

## Getting Started

### First Steps
```bash
vim filename    # Open file in vim
vimtutor       # Interactive vim tutorial
:help          # Built-in help system
:q             # Quit vim
```

### Emergency Exit
```vim
:q!            # Quit without saving (force quit)
<Esc>:q!       # From any mode: escape, then force quit
```

---

## Modes

Vim operates in different modes. Understanding modes is crucial to vim mastery.

| Mode        | Purpose               | How to Enter       | Indicator       |
| ----------- | --------------------- | ------------------ | --------------- |
| **Normal**  | Navigation & commands | `<Esc>`            | Default mode    |
| **Insert**  | Typing text           | `i`, `a`, `o`, `O` | `-- INSERT --`  |
| **Visual**  | Selecting text        | `v`, `V`, `<C-v>`  | `-- VISUAL --`  |
| **Command** | Execute commands      | `:`                | `:` at bottom   |
| **Replace** | Overwrite text        | `R`                | `-- REPLACE --` |

---

## Basic Navigation

### Character Movement
```vim
h              # Left
j              # Down  
k              # Up
l              # Right
```

### Word Movement
```vim
w              # Next word beginning
b              # Previous word beginning
e              # Next word end
ge             # Previous word end
W              # Next WORD (space-separated)
B              # Previous WORD
E              # Next WORD end
```

### Line Movement
```vim
0              # Beginning of line
^              # First non-blank character
$              # End of line
g_             # Last non-blank character
```

### Screen Movement
```vim
H              # Top of screen
M              # Middle of screen
L              # Bottom of screen
<C-f>          # Page down
<C-b>          # Page up
<C-d>          # Half page down
<C-u>          # Half page up
```

### File Movement
```vim
gg             # Top of file
G              # Bottom of file
:n             # Go to line n
nG             # Go to line n
```

---

## Essential Editing

### Entering Insert Mode
```vim
i              # Insert before cursor
a              # Insert after cursor
I              # Insert at beginning of line
A              # Insert at end of line
o              # Open new line below
O              # Open new line above
s              # Substitute character
S              # Substitute line
```

### Basic Editing
```vim
x              # Delete character under cursor
X              # Delete character before cursor
dd             # Delete line
D              # Delete from cursor to end of line
dw             # Delete word
cw             # Change word
cc             # Change line
C              # Change from cursor to end of line
r              # Replace single character
R              # Replace mode
```

### Copy & Paste
```vim
yy             # Copy line
yw             # Copy word
y$             # Copy from cursor to end of line
p              # Paste after cursor
P              # Paste before cursor
```

### Undo & Redo
```vim
u              # Undo
<C-r>          # Redo
U              # Undo all changes on line
```

---

## Advanced Movement

### Line Numbers
```vim
:set number    # Show line numbers
:set nonumber  # Hide line numbers
:set relativenumber  # Show relative line numbers
```

### Find Character
```vim
f{char}        # Find next occurrence of char
F{char}        # Find previous occurrence of char
t{char}        # Move to before next char
T{char}        # Move to before previous char
;              # Repeat last find
,              # Repeat last find (opposite direction)
```

### Matching
```vim
%              # Jump to matching bracket/parenthesis
*              # Search for word under cursor (forward)
#              # Search for word under cursor (backward)
```

### Sentence & Paragraph
```vim
(              # Previous sentence
)              # Next sentence
{              # Previous paragraph
}              # Next paragraph
```

---

## Text Objects

Text objects allow you to operate on logical text structures. Combine with operators like `d`, `c`, `y`.

### Syntax
```vim
[operator][a/i][object]
```
- `a` = "a" (includes surrounding)
- `i` = "inner" (excludes surrounding)

### Common Text Objects
```vim
iw / aw        # inner word / a word
is / as        # inner sentence / a sentence
ip / ap        # inner paragraph / a paragraph
i( / a(        # inner parentheses / a parentheses
i[ / a[        # inner brackets / a brackets
i{ / a{        # inner braces / a braces
i" / a"        # inner quotes / a quotes
i' / a'        # inner single quotes / a single quotes
it / at        # inner tag / a tag (HTML/XML)
```

### Examples
```vim
ciw            # Change inner word
di"            # Delete inside quotes
ya(            # Copy everything including parentheses
vit            # Visually select inside tag
```

---

## Visual Mode

### Visual Mode Types
```vim
v              # Character-wise visual mode
V              # Line-wise visual mode
<C-v>          # Block visual mode
gv             # Reselect last visual selection
```

### Visual Operations
```vim
d              # Delete selection
y              # Copy selection
c              # Change selection
>              # Indent selection
<              # Unindent selection
=              # Auto-indent selection
u              # Make lowercase
U              # Make uppercase
```

### Block Visual Tips
```vim
<C-v>          # Start block selection
I              # Insert at beginning of all selected lines
A              # Append at end of all selected lines
```

---

## Search & Replace

### Basic Search
```vim
/pattern       # Search forward
?pattern       # Search backward
n              # Next match
N              # Previous match
*              # Search word under cursor forward
#              # Search word under cursor backward
```

### Search Options
```vim
:set ignorecase    # Case insensitive search
:set smartcase     # Case sensitive if uppercase present
:set incsearch     # Incremental search
:set hlsearch      # Highlight search results
:nohlsearch        # Clear search highlighting
```

### Replace
```vim
:s/old/new/        # Replace first occurrence in line
:s/old/new/g       # Replace all occurrences in line
:%s/old/new/g      # Replace all in file
:%s/old/new/gc     # Replace all with confirmation
:5,12s/old/new/g   # Replace in lines 5-12
```

### Advanced Replace
```vim
:%s/\<word\>/new/g    # Replace whole word only
:%s/old/new/gi        # Case insensitive replace
:%s/^/new/g           # Add 'new' to beginning of each line
:%s/$/new/g           # Add 'new' to end of each line
```

---

## File Operations

### Basic File Commands
```vim
:w             # Save file
:w filename    # Save as filename
:q             # Quit
:wq            # Save and quit
:x             # Save and quit (only if modified)
:q!            # Quit without saving
```

### File Navigation
```vim
:e filename    # Edit file
:e!            # Reload current file
:e .           # Open file browser
:pwd           # Show current directory
:cd path       # Change directory
```

### File Information
```vim
<C-g>          # Show file info
:f             # Show filename and position
:ls            # List open buffers
```

---

## Buffers & Windows

### Buffers
```vim
:ls            # List buffers
:b n           # Switch to buffer n
:b filename    # Switch to buffer by name
:bp            # Previous buffer
:bn            # Next buffer
:bd            # Delete buffer
:b#            # Switch to alternate buffer
```

### Windows (Splits)
```vim
:split         # Horizontal split
:vsplit        # Vertical split
:sp filename   # Split and open file
:vsp filename  # Vertical split and open file
<C-w>s         # Horizontal split
<C-w>v         # Vertical split
```

### Window Navigation
```vim
<C-w>h         # Move to left window
<C-w>j         # Move to window below
<C-w>k         # Move to window above
<C-w>l         # Move to right window
<C-w>w         # Cycle through windows
<C-w>q         # Close current window
```

### Window Resizing
```vim
<C-w>=         # Make all windows equal size
<C-w>+         # Increase height
<C-w>-         # Decrease height
<C-w>>         # Increase width
<C-w><         # Decrease width
```

### Tabs
```vim
:tabnew        # New tab
:tabnext       # Next tab
:tabprev       # Previous tab
:tabclose      # Close tab
gt             # Next tab
gT             # Previous tab
```

---

## Macros

### Recording Macros
```vim
qa             # Start recording macro 'a'
q              # Stop recording
@a             # Execute macro 'a'
@@             # Repeat last executed macro
5@a            # Execute macro 'a' 5 times
```

### Macro Tips
```vim
:let @a='...'  # Edit macro 'a' directly
:reg a         # View contents of register 'a'
qA             # Append to existing macro 'a'
```

---

## Marks & Jumps

### Setting Marks
```vim
ma             # Set mark 'a' at current position
mA             # Set global mark 'A'
```

### Jumping to Marks
```vim
'a             # Jump to line with mark 'a'
`a             # Jump to exact position of mark 'a'
''             # Jump to previous position
``             # Jump to exact previous position
```

### Special Marks
```vim
'.             # Last edited position
'^             # Last insert position
'[             # Beginning of last change
']             # End of last change
```

### Jump List
```vim
<C-o>          # Jump to previous location
<C-i>          # Jump to next location
:jumps         # Show jump list
```

---

## Command Line

### Command History
```vim
:              # Enter command mode
<C-p>          # Previous command in history
<C-n>          # Next command in history
:history       # Show command history
q:             # Open command history window
```

### Command Completion
```vim
:e <Tab>       # File completion
:set <Tab>     # Option completion
:colorscheme <Tab>  # Colorscheme completion
```

### Useful Commands
```vim
:!command      # Execute shell command
:r !command    # Insert output of shell command
:w !sudo tee % # Save as root (if opened without sudo)
:source %      # Source current file
```

---

## Configuration

### Basic Settings
```vim
:set number         # Show line numbers
:set relativenumber # Show relative line numbers
:set ignorecase     # Case insensitive search
:set smartcase      # Override ignorecase if uppercase
:set incsearch      # Incremental search
:set hlsearch       # Highlight search results
:set autoindent     # Auto-indent new lines
:set expandtab      # Use spaces instead of tabs
:set tabstop=4      # Tab width
:set shiftwidth=4   # Indent width
:set wrap           # Wrap long lines
:set linebreak      # Break at word boundaries
```

### Color Schemes
```vim
:colorscheme desert     # Change color scheme
:colorscheme <Tab>      # Browse available schemes
:syntax on              # Enable syntax highlighting
:syntax off             # Disable syntax highlighting
```

### .vimrc Location
```bash
~/.vimrc          # Unix/Linux/macOS
$HOME/_vimrc      # Windows
```

---

## Tips & Tricks

### Efficiency Tips
- **Stay in Normal mode**: Don't live in Insert mode
- **Use counts**: `3dd`, `5j`, `2w` for repeated actions
- **Learn text objects**: `ciw`, `di"`, `va(` are game changers
- **Use `.` command**: Repeat last change
- **Master search**: `/` and `*` for quick navigation

### Common Patterns
```vim
3dd            # Delete 3 lines
5j             # Move down 5 lines
2w             # Move forward 2 words
d2w            # Delete 2 words
y5j            # Copy current line plus 5 below
>ip            # Indent paragraph
=ap            # Auto-indent paragraph
```

### Useful Combinations
```vim
<C-a>          # Increment number under cursor
<C-x>          # Decrement number under cursor
ggVG           # Select entire file
:%y            # Copy entire file
:%d            # Delete entire file content
:g/pattern/d   # Delete all lines matching pattern
:v/pattern/d   # Delete all lines NOT matching pattern
```

### Plugin Recommendations
- **vim-plug**: Plugin manager
- **fzf.vim**: Fuzzy file finder
- **vim-surround**: Manipulate surrounding characters
- **vim-commentary**: Easy commenting
- **vim-fugitive**: Git integration
- **nerdtree**: File explorer

### Learning Resources
- `:help` - Built-in help system
- `:help user-manual` - Complete user manual
- `vimtutor` - Interactive tutorial
- `:help quickref` - Quick reference
- [Vim Adventures](https://vim-adventures.com/) - Game-based learning
- [OpenVim](https://www.openvim.com/) - Interactive tutorial

---

## Quick Reference Card

### Most Important Commands
| Command  | Action                      |
| -------- | --------------------------- |
| `<Esc>`  | Return to Normal mode       |
| `i`      | Insert mode                 |
| `hjkl`   | Navigate left/down/up/right |
| `w` `b`  | Next/previous word          |
| `0` `$`  | Beginning/end of line       |
| `gg` `G` | Top/bottom of file          |
| `dd`     | Delete line                 |
| `yy`     | Copy line                   |
| `p`      | Paste                       |
| `u`      | Undo                        |
| `/text`  | Search for text             |
| `:w`     | Save                        |
| `:q`     | Quit                        |
| `:wq`    | Save and quit               |

### Remember
- **Everything in vim is composable**: operators + motions + text objects
- **When in doubt, press `<Esc>`** to return to Normal mode
- **Practice daily**: 15 minutes of focused practice beats hours of occasional use
- **Start simple**: Master the basics before moving to advanced features

---

*This cheat sheet covers the essential vim commands. For more detailed information, use `:help [command]` within vim.*