---
layout: cheatsheet
title: "Git Cheatsheet"
description: "Comprehensive Git Notes"
date: 2025-01-25
categories: [programming]
tags: [git, development, CICD, pipeline]
---

# Git Comprehensive Cheatsheet

## Table of Contents
1. [Git Basics](#git-basics)
2. [Configuration](#configuration)
3. [Repository Management](#repository-management)
4. [Basic Operations](#basic-operations)
5. [Branching and Merging](#branching-and-merging)
6. [Remote Repositories](#remote-repositories)
7. [Stashing Changes](#stashing-changes)
8. [Viewing History](#viewing-history)
9. [Undoing Changes](#undoing-changes)
10. [Tagging](#tagging)
11. [Cherry-Picking](#cherry-picking)
12. [Rebasing](#rebasing)
13. [Submodules](#submodules)
14. [Git Hooks](#git-hooks)
15. [Advanced Operations](#advanced-operations)
16. [Troubleshooting](#troubleshooting)
17. [Best Practices](#best-practices)
18. [Git Workflows](#git-workflows)
19. [Tips and Tricks](#tips-and-tricks)
20. [Dangerous Commands](#dangerous-commands)

## Git Basics

### What is Git?
Git is a distributed version control system that tracks changes in source code during software development. Think of it as a time machine for your code - it remembers every change, who made it, and why.

### Key Concepts
- **Repository (Repo)**: A directory where Git tracks changes
- **Commit**: A snapshot of your repository at a specific point in time
- **Branch**: An independent line of development
- **Remote**: A version of your repository hosted elsewhere
- **Clone**: A copy of a remote repository on your local machine
- **Fork**: Your own copy of someone else's repository

### The Three States
1. **Working Directory**: Where you modify files
2. **Staging Area (Index)**: Where you prepare changes for commit
3. **Repository**: Where Git stores committed changes

## Configuration

### Initial Setup
```bash
# Set your identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default editor
git config --global core.editor "vim"
# Or for VS Code:
git config --global core.editor "code --wait"

# Set default branch name
git config --global init.defaultBranch main

# Enable color output
git config --global color.ui auto

# Set line ending preferences
# Windows
git config --global core.autocrlf true
# Mac/Linux
git config --global core.autocrlf input

# Configure merge tool
git config --global merge.tool vimdiff
git config --global mergetool.prompt false

# Set up aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual '!gitk'
```

### View Configuration
```bash
# List all settings
git config --list

# View specific setting
git config user.name

# View config file locations
git config --list --show-origin

# Edit global config directly
git config --global --edit

# Config levels
git config --system  # System-wide
git config --global  # User-specific
git config --local   # Repository-specific
```

## Repository Management

### Creating Repositories
```bash
# Initialize new repository
git init
git init my-project

# Initialize with specific branch name
git init -b main

# Initialize bare repository (for servers)
git init --bare my-project.git

# Clone existing repository
git clone https://github.com/user/repo.git
git clone https://github.com/user/repo.git new-name

# Clone specific branch
git clone -b branch-name https://github.com/user/repo.git

# Shallow clone (only recent history)
git clone --depth 1 https://github.com/user/repo.git

# Clone with submodules
git clone --recurse-submodules https://github.com/user/repo.git
```

## Basic Operations

### Staging and Committing
```bash
# Check status
git status
git status -s  # Short format

# Add files to staging
git add file.txt
git add .                    # Add all files
git add -A                   # Add all (including deletions)
git add *.js                 # Add by pattern
git add -p                   # Interactive staging

# Remove from staging
git reset file.txt
git reset                    # Unstage all

# Commit changes
git commit -m "Commit message"
git commit                   # Opens editor for message
git commit -am "Message"     # Add and commit tracked files
git commit --amend          # Modify last commit
git commit --amend --no-edit # Amend without changing message

# Empty commit
git commit --allow-empty -m "Empty commit"

# Sign commits
git commit -S -m "Signed commit"
```

### File Operations
```bash
# Remove files
git rm file.txt             # Remove from working dir and stage
git rm --cached file.txt    # Remove from staging only
git rm -r directory/        # Remove directory

# Move/rename files
git mv old-name.txt new-name.txt
git mv file.txt directory/

# Ignore files
echo "*.log" >> .gitignore
git add .gitignore
git commit -m "Add .gitignore"

# Track empty directories
mkdir empty-dir
touch empty-dir/.gitkeep
git add empty-dir/.gitkeep

# Clean untracked files
git clean -n               # Dry run
git clean -f               # Force clean files
git clean -fd              # Include directories
git clean -fdx             # Include ignored files
```

## Branching and Merging

### Branch Management
```bash
# List branches
git branch                  # Local branches
git branch -r              # Remote branches
git branch -a              # All branches
git branch -v              # With last commit
git branch --merged        # Branches merged into current
git branch --no-merged     # Branches not merged

# Create branch
git branch feature-name
git branch feature-name commit-hash

# Switch branches
git checkout branch-name
git switch branch-name      # Newer command

# Create and switch
git checkout -b new-branch
git switch -c new-branch

# Rename branch
git branch -m old-name new-name
git branch -m new-name      # Rename current branch

# Delete branch
git branch -d branch-name   # Safe delete (merged)
git branch -D branch-name   # Force delete

# Delete remote branch
git push origin --delete branch-name
git push origin :branch-name  # Alternative
```

### Merging
```bash
# Merge branch into current
git merge feature-branch
git merge --no-ff feature   # No fast-forward
git merge --squash feature  # Squash commits
git merge --abort          # Cancel merge

# Merge strategies
git merge -s recursive feature  # Default
git merge -s ours feature      # Keep our version
git merge -s theirs feature    # Not available (use recursive -X)
git merge -X theirs feature    # Favor their changes

# View merge conflicts
git status
git diff --name-only --diff-filter=U

# Resolve conflicts
# Edit conflicted files, then:
git add resolved-file.txt
git commit
# Or abort:
git merge --abort
```

## Remote Repositories

### Managing Remotes
```bash
# View remotes
git remote
git remote -v              # With URLs
git remote show origin     # Detailed info

# Add remote
git remote add origin https://github.com/user/repo.git
git remote add upstream https://github.com/original/repo.git

# Change remote URL
git remote set-url origin https://new-url.git

# Rename remote
git remote rename origin old-origin

# Remove remote
git remote remove origin
git remote rm origin
```

### Syncing with Remotes
```bash
# Fetch changes
git fetch                  # All remotes
git fetch origin          # Specific remote
git fetch origin branch   # Specific branch
git fetch --all          # All remotes
git fetch --prune        # Remove deleted remote branches

# Pull changes
git pull                  # Fetch and merge
git pull --rebase        # Fetch and rebase
git pull origin main     # Specific branch
git pull --no-commit     # Fetch and merge without commit

# Push changes
git push                  # Current branch
git push origin main     # Specific branch
git push -u origin main  # Set upstream
git push --all           # All branches
git push --tags          # All tags
git push --force         # Force push (dangerous!)
git push --force-with-lease  # Safer force push

# Track remote branch
git checkout -b local-branch origin/remote-branch
git checkout --track origin/remote-branch
git branch -u origin/remote-branch
```

## Stashing Changes

### Basic Stash Operations
```bash
# Stash changes
git stash                    # Stash tracked files
git stash -u                 # Include untracked
git stash -a                 # Include ignored
git stash save "message"     # With description

# List stashes
git stash list

# Apply stash
git stash apply              # Most recent
git stash apply stash@{2}    # Specific stash
git stash pop                # Apply and remove

# View stash contents
git stash show               # Summary
git stash show -p            # Full diff
git stash show stash@{1}     # Specific stash

# Create branch from stash
git stash branch new-branch
git stash branch new-branch stash@{1}

# Remove stashes
git stash drop               # Most recent
git stash drop stash@{1}     # Specific
git stash clear              # All stashes
```

## Viewing History

### Log Commands
```bash
# Basic log
git log
git log --oneline           # Condensed view
git log --graph            # ASCII graph
git log --all              # All branches
git log --decorate         # Show references

# Limit output
git log -5                 # Last 5 commits
git log --since="2 weeks ago"
git log --until="2023-01-01"
git log --author="John"
git log --grep="bugfix"    # Search commit messages

# Format output
git log --pretty=oneline
git log --pretty=format:"%h - %an, %ar : %s"
git log --pretty=format:"%C(yellow)%h%Creset %s %C(red)(%an)%Creset"

# File history
git log -- file.txt
git log --follow file.txt   # Follow renames
git log -p file.txt        # Show patches
git log --stat             # Show statistics

# Advanced filters
git log --no-merges
git log --merges
git log branch1..branch2    # Commits in branch2 not in branch1
git log branch1...branch2   # Commits in either but not both

# Search content
git log -S"function_name"   # Commits that add/remove string
git log -G"regex"          # Commits with diff matching regex
```

### Other History Commands
```bash
# Show commit details
git show                    # Latest commit
git show commit-hash
git show branch:file.txt    # File at specific branch/commit

# Blame (who changed what)
git blame file.txt
git blame -L 10,20 file.txt # Lines 10-20
git blame -w file.txt       # Ignore whitespace

# Search repository
git grep "pattern"
git grep -n "pattern"       # With line numbers
git grep "pattern" branch

# List files
git ls-files                # Tracked files
git ls-files -o            # Untracked files
git ls-files -m            # Modified files
```

## Undoing Changes

### Reset Commands
```bash
# Soft reset (keep changes staged)
git reset --soft HEAD~1
git reset --soft commit-hash

# Mixed reset (keep changes unstaged) - default
git reset HEAD~1
git reset commit-hash

# Hard reset (discard changes) - DANGEROUS!
git reset --hard HEAD~1
git reset --hard commit-hash

# Reset specific file
git reset HEAD file.txt
git reset commit-hash -- file.txt
```

### Revert and Restore
```bash
# Revert commit (create new commit)
git revert HEAD
git revert commit-hash
git revert --no-commit HEAD  # Stage without committing
git revert -m 1 merge-commit # Revert merge

# Restore files (newer Git)
git restore file.txt          # Discard working changes
git restore --staged file.txt # Unstage
git restore --source=HEAD~1 file.txt

# Checkout (older method)
git checkout -- file.txt      # Discard changes
git checkout HEAD~1 -- file.txt  # From specific commit
```

### Recovering Lost Commits
```bash
# View reflog
git reflog
git reflog show branch-name

# Recover commit
git checkout -b recovery-branch commit-hash
git cherry-pick commit-hash
git reset --hard commit-hash
```

## Tagging

### Creating and Managing Tags
```bash
# List tags
git tag
git tag -l "v1.8*"         # Pattern matching

# Create lightweight tag
git tag v1.0
git tag v1.0 commit-hash

# Create annotated tag
git tag -a v1.0 -m "Version 1.0"
git tag -a v1.0 commit-hash -m "Message"

# Create signed tag
git tag -s v1.0 -m "Signed version 1.0"

# View tag details
git show v1.0

# Push tags
git push origin v1.0        # Specific tag
git push origin --tags      # All tags

# Delete tags
git tag -d v1.0            # Local
git push origin :refs/tags/v1.0  # Remote
git push --delete origin v1.0    # Remote (newer)

# Checkout tag
git checkout v1.0
git checkout -b branch-from-tag v1.0
```

## Cherry-Picking

### Applying Specific Commits
```bash
# Cherry-pick single commit
git cherry-pick commit-hash
git cherry-pick --no-commit commit-hash

# Cherry-pick multiple commits
git cherry-pick commit1 commit2
git cherry-pick commit1..commit3  # Range (excluding commit1)
git cherry-pick commit1^..commit3 # Range (including commit1)

# Cherry-pick merge commit
git cherry-pick -m 1 merge-commit

# Handle conflicts
git cherry-pick --continue
git cherry-pick --abort
git cherry-pick --quit     # Stop but keep changes
```

## Rebasing

### Interactive Rebase
```bash
# Rebase onto branch
git rebase main
git rebase --onto main feature old-feature

# Interactive rebase
git rebase -i HEAD~3
git rebase -i commit-hash

# Interactive commands:
# pick = use commit
# reword = use commit, edit message
# edit = use commit, stop for amending
# squash = use commit, meld into previous
# fixup = like squash, discard message
# exec = run command
# drop = remove commit

# Continue/abort rebase
git rebase --continue
git rebase --abort
git rebase --skip

# Rebase with autosquash
git commit --fixup=commit-hash
git rebase -i --autosquash HEAD~3

# Pull with rebase
git pull --rebase
git config pull.rebase true  # Make default
```

## Submodules

### Managing Submodules
```bash
# Add submodule
git submodule add https://github.com/user/repo.git path/to/submodule
git submodule add -b branch https://github.com/user/repo.git path

# Initialize submodules
git submodule init
git submodule update
git submodule update --init --recursive

# Clone with submodules
git clone --recurse-submodules https://github.com/user/repo.git

# Update submodules
git submodule update --remote
git submodule update --remote --merge
git submodule update --remote --rebase

# View submodule status
git submodule status
git submodule summary

# Remove submodule
git submodule deinit path/to/submodule
git rm path/to/submodule
rm -rf .git/modules/path/to/submodule

# Execute command in all submodules
git submodule foreach 'git pull origin main'
```

## Git Hooks

### Client-Side Hooks
```bash
# Location: .git/hooks/

# Pre-commit hook example
#!/bin/bash
# .git/hooks/pre-commit
# Check for debugging statements
if git diff --cached | grep -E "console\.log|debugger"; then
    echo "Error: Debugging statements found"
    exit 1
fi

# Common hooks:
# pre-commit     - Before commit is created
# commit-msg     - Validate commit message
# post-commit    - After commit is created
# pre-push       - Before push
# pre-rebase     - Before rebase
# post-checkout  - After checkout
# post-merge     - After merge

# Enable hook
chmod +x .git/hooks/pre-commit

# Skip hooks
git commit --no-verify
git push --no-verify
```

### Sharing Hooks
```bash
# Create hooks directory in repo
mkdir .githooks

# Configure Git to use directory
git config core.hooksPath .githooks

# Team members run:
git config core.hooksPath .githooks
```

## Advanced Operations

### Bisect (Find Bad Commits)
```bash
# Start bisect
git bisect start
git bisect bad                  # Current commit is bad
git bisect good commit-hash     # Known good commit

# Test and mark commits
git bisect good                 # Current commit is good
git bisect bad                  # Current commit is bad
git bisect skip                 # Can't test this commit

# Automated bisect
git bisect run npm test

# End bisect
git bisect reset
```

### Worktrees
```bash
# Add new worktree
git worktree add ../project-hotfix
git worktree add -b new-feature ../project-feature

# List worktrees
git worktree list

# Remove worktree
git worktree remove ../project-hotfix
git worktree prune
```

### Filter Branch (Rewrite History)
```bash
# Remove file from all history (DANGEROUS!)
git filter-branch --tree-filter 'rm -f passwords.txt' HEAD

# Change email in history
git filter-branch --env-filter '
if [ "$GIT_AUTHOR_EMAIL" = "old@email.com" ]; then
    export GIT_AUTHOR_EMAIL="new@email.com"
fi
' HEAD

# Use git-filter-repo instead (recommended)
# pip install git-filter-repo
git filter-repo --path file-to-keep --invert-paths
```

### Sparse Checkout
```bash
# Enable sparse checkout
git sparse-checkout init

# Define what to include
git sparse-checkout set folder1 folder2
echo "docs/" >> .git/info/sparse-checkout

# Disable sparse checkout
git sparse-checkout disable
```

## Troubleshooting

### Common Issues and Solutions
```bash
# Fix detached HEAD
git checkout main
git checkout -b new-branch  # Or create branch

# Undo accidental git add
git reset
git reset file.txt

# Fix wrong commit message
git commit --amend -m "New message"

# Remove large files from history
git filter-branch --index-filter \
    'git rm --cached --ignore-unmatch large-file.zip' HEAD

# Fix corrupted repository
git fsck --full
git gc --prune=now

# Recover deleted branch
git reflog
git checkout -b recovered-branch commit-hash

# Fix line endings
git rm --cached -r .
git reset --hard
git add .
git commit -m "Fix line endings"

# Remove sensitive data
# Use BFG Repo-Cleaner or git-filter-repo
```

### Debugging Git
```bash
# Debug Git commands
GIT_TRACE=1 git command
GIT_CURL_VERBOSE=1 git fetch
GIT_SSH_COMMAND="ssh -v" git fetch

# Check repository integrity
git fsck
git fsck --full --unreachable

# Garbage collection
git gc
git gc --aggressive --prune=now

# Verify connectivity
git remote -v
git ls-remote origin

# Check configuration
git config --list --show-origin
```

## Best Practices

### Commit Messages
```bash
# Good commit message format:
# <type>(<scope>): <subject>
#
# <body>
#
# <footer>

# Example:
# feat(auth): add OAuth2 integration
#
# Implemented Google OAuth2 for user authentication.
# Users can now sign in using their Google accounts.
#
# Closes #123

# Types:
# feat: New feature
# fix: Bug fix
# docs: Documentation changes
# style: Code style changes
# refactor: Code refactoring
# test: Test additions/changes
# chore: Build process changes
```

### Branching Strategy
```bash
# Git Flow branches:
main/master     # Production-ready code
develop         # Integration branch
feature/*       # Feature branches
release/*       # Release preparation
hotfix/*        # Emergency fixes

# GitHub Flow (simpler):
main            # Always deployable
feature-branches # Short-lived branches
```

### Safety Practices
```bash
# Always pull before push
git pull --rebase

# Use branches for features
git checkout -b feature/new-feature

# Review changes before committing
git diff --staged

# Use .gitignore
echo "node_modules/" >> .gitignore
echo ".env" >> .gitignore
echo "*.log" >> .gitignore

# Sign commits
git config commit.gpgsign true

# Protect main branch
# Configure on GitHub/GitLab
```

## Git Workflows

### Feature Branch Workflow
```bash
# 1. Create feature branch
git checkout -b feature/user-auth

# 2. Make changes and commit
git add .
git commit -m "Add user authentication"

# 3. Push to remote
git push -u origin feature/user-auth

# 4. Create pull request
# Done on GitHub/GitLab

# 5. After approval, merge
git checkout main
git merge --no-ff feature/user-auth
git push origin main

# 6. Clean up
git branch -d feature/user-auth
git push origin --delete feature/user-auth
```

### Forking Workflow
```bash
# 1. Fork repository on GitHub

# 2. Clone your fork
git clone https://github.com/yourusername/repo.git

# 3. Add upstream remote
git remote add upstream https://github.com/original/repo.git

# 4. Create feature branch
git checkout -b feature/improvement

# 5. Make changes and push to fork
git push origin feature/improvement

# 6. Create pull request to original

# 7. Keep fork updated
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

## Tips and Tricks

### Useful Aliases
```bash
# Add to ~/.gitconfig
[alias]
    # Shortcuts
    co = checkout
    br = branch
    ci = commit
    st = status
    
    # Useful commands
    unstage = reset HEAD --
    last = log -1 HEAD
    visual = !gitk
    
    # Pretty log
    lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
    
    # Show branches with last commit
    branches = for-each-ref --sort=-committerdate --format=\"%(color:blue)%(authordate:relative)\t%(color:red)%(authorname)\t%(color:white)%(color:bold)%(refname:short)\" refs/remotes
    
    # Undo last commit
    undo = reset --soft HEAD~1
    
    # Amend without editing message
    amend = commit --amend --no-edit
    
    # List aliases
    aliases = config --get-regexp alias
    
    # Find commits by message
    find = log --pretty=\"format:%Cgreen%H %Cblue%s\" --grep
    
    # Show changed files in last commit
    changed = show --pretty="" --name-only
    
    # Interactive rebase with autosquash
    ri = rebase -i --autosquash
```

### Productivity Tips
```bash
# Quick commit all changes
git add . && git commit -m "Update"

# See what changed
git diff HEAD^ HEAD

# Quick branch cleanup
git branch --merged | grep -v "main\|master\|develop" | xargs -n 1 git branch -d

# Find deleted file
git log --all --full-history -- "**/filename.*"

# Show commits by author
git shortlog -sn

# Export patch
git format-patch -1 HEAD

# Apply patch
git am < patch-file.patch

# Create archive
git archive --format=zip HEAD > archive.zip

# Count lines of code
git ls-files | xargs wc -l

# Show repository size
git count-objects -vH
```

### Git Attributes
```bash
# .gitattributes file
*.jpg binary
*.png binary
*.pdf binary

# Line ending normalization
* text=auto
*.sh text eol=lf
*.bat text eol=crlf

# Diff patterns
*.md diff=markdown
*.py diff=python

# Export ignore
.gitignore export-ignore
.gitattributes export-ignore
README.md export-ignore

# Large file storage (LFS)
*.psd filter=lfs diff=lfs merge=lfs -text
*.zip filter=lfs diff=lfs merge=lfs -text
```

## Dangerous Commands

### Use With Extreme Caution!
```bash
# Force push - overwrites remote history
git push --force
git push -f

# Hard reset - loses uncommitted changes
git reset --hard HEAD~1

# Clean - permanently deletes untracked files
git clean -fdx

# Filter branch - rewrites entire history
git filter-branch ...

# Remove all commits except initial
git update-ref -d HEAD

# Completely reset repository
rm -rf .git
git init

# Refuse to merge unrelated histories
git merge --allow-unrelated-histories

# Override safety checks
git -c safe.directory=* command
```

### Recovery Commands
```bash
# If you accidentally force pushed
# Find the old commit in reflog
git reflog
git push --force-with-lease origin commit-hash:branch-name

# If you lost commits
git fsck --lost-found
# Check .git/lost-found/

# If you deleted a branch
git reflog
git checkout -b recovered-branch commit-hash

# Emergency backup before dangerous operation
git branch backup-$(date +%Y%m%d-%H%M%S)
```

---

*Remember: Git is powerful but can be dangerous. Always make backups before performing destructive operations. When in doubt, create a new branch!*