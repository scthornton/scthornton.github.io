---
layout: cheatsheet
title: "Linux Cheatsheet"
description: "Must know Linux concepts and commands"
date: 2024-11-25
categories: [tools, productivity]
tags: [os, linux]
---

# Linux Comprehensive Cheatsheet

## Table of Contents
1. [Linux Basics](#linux-basics)
2. [File System Navigation](#file-system-navigation)
3. [File and Directory Management](#file-and-directory-management)
4. [File Permissions](#file-permissions)
5. [Text Processing](#text-processing)
6. [Process Management](#process-management)
7. [User and Group Management](#user-and-group-management)
8. [Package Management](#package-management)
9. [Network Commands](#network-commands)
10. [System Information](#system-information)
11. [Disk and File System](#disk-and-file-system)
12. [Shell Scripting](#shell-scripting)
13. [Environment Variables](#environment-variables)
14. [SSH and Remote Access](#ssh-and-remote-access)
15. [System Services](#system-services)
16. [Log Management](#log-management)
17. [Security](#security)
18. [Performance Monitoring](#performance-monitoring)
19. [Advanced Commands](#advanced-commands)
20. [Tips and Tricks](#tips-and-tricks)

## Linux Basics

### What is Linux?
Linux is an open-source operating system kernel. Think of it as the engine of your car - it manages hardware resources and provides a platform for applications to run. Different distributions (distros) like Ubuntu, CentOS, and Arch are like different car models using the same engine.

### Key Concepts
- **Kernel**: Core of the OS that manages hardware
- **Shell**: Command interpreter (bash, zsh, fish)
- **Terminal**: Interface to interact with the shell
- **Root**: Superuser with full system privileges
- **Home Directory**: Personal directory for each user (~)
- **File System**: Everything is a file in Linux

### Basic Commands
```bash
# Get help
man command          # Manual page
command --help       # Brief help
info command         # Detailed info
type command         # Show command type
which command        # Show command location
whereis command      # Show binary, source, manual

# Command history
history              # Show command history
!n                   # Execute command n from history
!!                   # Execute last command
!string              # Execute last command starting with string
ctrl+r               # Search command history

# Clear and exit
clear                # Clear screen (or ctrl+l)
exit                 # Exit shell
logout               # Logout from system
```

## File System Navigation

### Directory Structure
```
/                    # Root directory
├── bin/            # Essential user binaries
├── boot/           # Boot loader files
├── dev/            # Device files
├── etc/            # System configuration
├── home/           # User home directories
├── lib/            # Shared libraries
├── media/          # Removable media mount points
├── mnt/            # Temporary mount points
├── opt/            # Optional software
├── proc/           # Process information (virtual)
├── root/           # Root user home
├── sbin/           # System binaries
├── srv/            # Service data
├── sys/            # System information (virtual)
├── tmp/            # Temporary files
├── usr/            # User programs
└── var/            # Variable data
```

### Navigation Commands
```bash
# Print working directory
pwd

# Change directory
cd /path/to/directory
cd ..                # Parent directory
cd ~                 # Home directory
cd -                 # Previous directory
cd                   # Also home directory

# List files
ls                   # Basic listing
ls -l                # Long format
ls -la               # Include hidden files
ls -lh               # Human-readable sizes
ls -lt               # Sort by modification time
ls -lS               # Sort by size
ls -R                # Recursive listing
ls -d */             # List directories only

# Tree view (install tree package)
tree
tree -L 2            # Limit depth to 2
tree -d              # Directories only
tree -a              # Include hidden
```

## File and Directory Management

### Creating Files and Directories
```bash
# Create files
touch file.txt
touch file{1..5}.txt    # Create file1.txt to file5.txt
echo "content" > file.txt
cat > file.txt          # Type content, ctrl+d to finish

# Create directories
mkdir directory
mkdir -p path/to/directory  # Create parent directories
mkdir -m 755 directory     # With permissions
mkdir {dir1,dir2,dir3}     # Multiple directories

# Create links
ln source_file hard_link
ln -s source_file soft_link
ln -s /full/path/to/file link  # Absolute path recommended
```

### Copying, Moving, and Removing
```bash
# Copy files
cp source dest
cp -r source_dir dest_dir   # Recursive
cp -p source dest          # Preserve attributes
cp -i source dest          # Interactive (prompt)
cp -u source dest          # Update only
cp -a source dest          # Archive mode

# Move/rename
mv old_name new_name
mv file directory/
mv -i source dest          # Interactive
mv -n source dest          # No overwrite

# Remove files
rm file
rm -r directory            # Recursive
rm -f file                # Force
rm -rf directory          # Force recursive (DANGEROUS!)
rm -i file                # Interactive

# Safe remove with trash-cli
trash file                 # Move to trash
trash-empty               # Empty trash
trash-list                # List trash
trash-restore             # Restore from trash
```

### File Operations
```bash
# View file content
cat file.txt              # Display entire file
less file.txt             # Page through file
more file.txt             # Simpler pager
head file.txt             # First 10 lines
head -n 20 file.txt       # First 20 lines
tail file.txt             # Last 10 lines
tail -n 20 file.txt       # Last 20 lines
tail -f file.txt          # Follow file updates

# Compare files
diff file1 file2
diff -u file1 file2       # Unified format
diff -r dir1 dir2         # Compare directories
cmp file1 file2           # Byte-by-byte comparison

# Find files
find /path -name "*.txt"
find . -type f -size +10M  # Files larger than 10MB
find . -mtime -7           # Modified in last 7 days
find . -perm 644           # With specific permissions
find . -user username      # Owned by user
find . -exec command {} \; # Execute command on results

# Locate (faster, uses database)
locate filename
updatedb                   # Update locate database

# File type
file filename              # Determine file type
stat filename              # Detailed file statistics
```

## File Permissions

### Understanding Permissions
```
-rwxr-xr--  1 user group 1234 Jan 1 12:00 file.txt
│├─┼─┼─┼─┘
││ │ │ └── Other (r--) = 4
││ │ └──── Group (r-x) = 5  
││ └────── User  (rwx) = 7
│└──────── File type (- = file, d = directory)

Permission values:
r (read)    = 4
w (write)   = 2
x (execute) = 1
```

### Managing Permissions
```bash
# Change permissions
chmod 755 file             # rwxr-xr-x
chmod u+x file             # Add execute for user
chmod g-w file             # Remove write for group
chmod o=r file             # Set other to read only
chmod a+x file             # Add execute for all
chmod -R 755 directory     # Recursive

# Change ownership
chown user file
chown user:group file
chown -R user:group directory

# Change group
chgrp group file
chgrp -R group directory

# Default permissions
umask                      # Show current umask
umask 022                  # Set umask (755 for dirs, 644 for files)

# Special permissions
chmod u+s file             # Setuid
chmod g+s directory        # Setgid
chmod +t directory         # Sticky bit

# Access Control Lists (ACL)
getfacl file               # Get ACL
setfacl -m u:user:rwx file # Set ACL for user
setfacl -x u:user file     # Remove ACL
setfacl -b file            # Remove all ACLs
```

## Text Processing

### Text Manipulation
```bash
# grep - Search text
grep "pattern" file
grep -i "pattern" file     # Case insensitive
grep -v "pattern" file     # Invert match
grep -n "pattern" file     # Show line numbers
grep -r "pattern" dir/     # Recursive
grep -E "regex" file       # Extended regex
grep -P "perl-regex" file  # Perl regex
grep -A 3 "pattern" file   # Show 3 lines after
grep -B 3 "pattern" file   # Show 3 lines before
grep -C 3 "pattern" file   # Show 3 lines around

# sed - Stream editor
sed 's/old/new/' file      # Replace first occurrence
sed 's/old/new/g' file     # Replace all occurrences
sed -i 's/old/new/g' file  # In-place edit
sed -n '10,20p' file       # Print lines 10-20
sed '5d' file              # Delete line 5
sed '/pattern/d' file      # Delete matching lines

# awk - Pattern processing
awk '{print $1}' file      # Print first column
awk '{print $1, $3}' file  # Print columns 1 and 3
awk -F: '{print $1}' file  # Use : as delimiter
awk '$3 > 100' file        # Print if column 3 > 100
awk '{sum+=$1} END {print sum}' file  # Sum column 1

# cut - Extract columns
cut -d' ' -f1 file         # First field, space delimited
cut -d':' -f1,3 file       # Fields 1 and 3
cut -c1-10 file            # Characters 1-10

# sort - Sort lines
sort file
sort -n file               # Numeric sort
sort -r file               # Reverse sort
sort -k2 file              # Sort by 2nd field
sort -u file               # Unique sort

# uniq - Remove duplicates
uniq file                  # Remove adjacent duplicates
uniq -c file               # Count occurrences
uniq -d file               # Show only duplicates
sort file | uniq           # Remove all duplicates

# tr - Translate characters
tr 'a-z' 'A-Z' < file      # Convert to uppercase
tr -d '0-9' < file         # Delete digits
tr -s ' ' < file           # Squeeze spaces
```

### Advanced Text Processing
```bash
# Join files
join file1 file2           # Join on first field
join -t: -1 2 -2 1 f1 f2  # Custom delimiter and fields

# Paste files
paste file1 file2          # Side by side
paste -d: file1 file2      # Custom delimiter

# Split files
split -l 100 file          # Split every 100 lines
split -b 10M file          # Split every 10MB

# Column formatting
column -t file             # Align columns
column -s: -t file         # Use : as delimiter

# Word count
wc file                    # Lines, words, characters
wc -l file                 # Line count only
wc -w file                 # Word count only
wc -c file                 # Byte count
wc -m file                 # Character count
```

## Process Management

### Process Commands
```bash
# View processes
ps                         # Current shell processes
ps aux                     # All processes
ps aux | grep process      # Find specific process
ps -ef                     # Full format listing
ps -u username             # Processes by user
pstree                     # Process tree
pgrep process_name         # Get PID by name

# Real-time monitoring
top                        # Interactive process viewer
htop                       # Better process viewer
atop                       # Advanced system monitor

# Kill processes
kill PID                   # Send SIGTERM
kill -9 PID               # Send SIGKILL (force)
kill -l                    # List signals
killall process_name       # Kill by name
pkill pattern              # Kill by pattern
pkill -u username          # Kill user processes

# Background jobs
command &                  # Run in background
jobs                       # List jobs
fg %n                      # Bring job n to foreground
bg %n                      # Send job n to background
nohup command &            # Run immune to hangups
disown %n                  # Detach job from shell

# Process priority
nice -n 10 command         # Run with lower priority
renice -n 5 -p PID        # Change priority
```

### Process Control
```bash
# Signals
ctrl+c                     # SIGINT (interrupt)
ctrl+z                     # SIGTSTP (suspend)
ctrl+d                     # EOF
ctrl+\                     # SIGQUIT

# System calls
strace command             # Trace system calls
strace -p PID             # Attach to process
ltrace command             # Trace library calls

# Resource limits
ulimit -a                  # Show all limits
ulimit -n 1024            # Set open files limit
ulimit -u 100             # Set process limit
```

## User and Group Management

### User Management
```bash
# User information
whoami                     # Current username
id                         # User and group IDs
id username                # IDs for specific user
finger username            # User information
who                        # Logged in users
w                          # Who and what they're doing
last                       # Login history
lastlog                    # Last login times

# User management (root required)
useradd username           # Add user
useradd -m -s /bin/bash username  # With home and shell
usermod -aG group username # Add user to group
usermod -l newname oldname # Rename user
usermod -L username        # Lock account
usermod -U username        # Unlock account
userdel username           # Delete user
userdel -r username        # Delete with home directory

# Password management
passwd                     # Change your password
passwd username            # Change user password (root)
chage -l username          # Password aging info
chage -E 2024-12-31 username  # Set expiry date
```

### Group Management
```bash
# Group information
groups                     # Your groups
groups username            # User's groups
getent group              # List all groups

# Group management (root required)
groupadd groupname         # Add group
groupmod -n newname oldname # Rename group
groupdel groupname         # Delete group
gpasswd -a user group      # Add user to group
gpasswd -d user group      # Remove user from group

# Switch user/group
su                         # Switch to root
su - username              # Switch user with environment
sudo command               # Execute as root
sudo -u username command   # Execute as user
newgrp groupname          # Switch primary group
```

## Package Management

### Debian/Ubuntu (APT)
```bash
# Update package list
sudo apt update

# Upgrade packages
sudo apt upgrade           # Upgrade installed
sudo apt full-upgrade      # Upgrade with removals
sudo apt dist-upgrade      # Distribution upgrade

# Install packages
sudo apt install package
sudo apt install -y package # Auto yes
sudo apt install package1 package2

# Remove packages
sudo apt remove package    # Keep config files
sudo apt purge package     # Remove everything
sudo apt autoremove        # Remove unused dependencies

# Search packages
apt search keyword
apt show package           # Package details
apt list --installed       # List installed

# Package information
dpkg -l                    # List installed packages
dpkg -L package           # List package files
dpkg -S /path/to/file     # Find package owning file
```

### Red Hat/CentOS (YUM/DNF)
```bash
# Update packages
sudo yum update            # Or dnf update
sudo yum upgrade           # Or dnf upgrade

# Install packages
sudo yum install package
sudo yum groupinstall "Group Name"

# Remove packages
sudo yum remove package
sudo yum autoremove

# Search packages
yum search keyword
yum info package
yum list installed

# Package information
rpm -qa                    # List all packages
rpm -ql package           # List package files
rpm -qf /path/to/file     # Find package owning file
```

### Arch Linux (Pacman)
```bash
# Update system
sudo pacman -Syu           # Sync and upgrade

# Install packages
sudo pacman -S package
sudo pacman -U package.pkg.tar.xz  # Local package

# Remove packages
sudo pacman -R package     # Remove only
sudo pacman -Rs package    # Remove with dependencies
sudo pacman -Rns package   # Remove with config files

# Search packages
pacman -Ss keyword         # Search in repos
pacman -Qs keyword         # Search installed
pacman -Si package         # Package info
pacman -Qi package         # Installed package info
```

### Universal Package Managers
```bash
# Snap
snap list                  # List installed
snap find keyword          # Search
snap install package
snap remove package

# Flatpak
flatpak list
flatpak search keyword
flatpak install package
flatpak uninstall package

# AppImage
chmod +x app.AppImage
./app.AppImage
```

## Network Commands

### Network Configuration
```bash
# IP configuration
ip addr show               # Show all interfaces
ip addr add 192.168.1.100/24 dev eth0
ip addr del 192.168.1.100/24 dev eth0
ip link set eth0 up        # Enable interface
ip link set eth0 down      # Disable interface

# Legacy commands
ifconfig                   # Show interfaces
ifconfig eth0 up/down      # Enable/disable

# DNS configuration
cat /etc/resolv.conf       # DNS servers
nslookup domain.com        # DNS lookup
dig domain.com             # Detailed DNS query
host domain.com            # DNS lookup

# Hostname
hostname                   # Show hostname
hostname -f                # Fully qualified
hostnamectl set-hostname name  # Set hostname
```

### Network Testing
```bash
# Connectivity
ping host                  # Test connectivity
ping -c 4 host            # Send 4 packets
ping6 ipv6-host           # IPv6 ping

# Trace route
traceroute host           # Trace packet route
tracepath host            # Similar to traceroute
mtr host                  # Combined ping/traceroute

# Port testing
telnet host port          # Test TCP port
nc -zv host port          # Netcat port scan
nc -l -p 1234             # Listen on port
nmap host                 # Port scanning

# Network statistics
netstat -tuln             # Listening ports
netstat -an               # All connections
ss -tuln                  # Modern netstat
lsof -i :80               # Process on port 80

# Bandwidth
iftop                     # Real-time bandwidth
nethogs                   # Bandwidth by process
vnstat                    # Network statistics
```

### File Transfer
```bash
# wget - Download files
wget URL
wget -c URL               # Continue download
wget -r URL               # Recursive download
wget -O filename URL      # Save as

# curl - Transfer data
curl URL
curl -o filename URL      # Save to file
curl -O URL               # Save with remote name
curl -I URL               # Headers only
curl -X POST -d "data" URL # POST request

# scp - Secure copy
scp file user@host:/path
scp user@host:/file .
scp -r dir user@host:/path # Recursive
scp -P 2222 file user@host:/path # Custom port

# rsync - Sync files
rsync -av source/ dest/    # Archive mode
rsync -avz source/ user@host:/dest/ # With compression
rsync --delete source/ dest/ # Mirror directories
rsync --exclude='*.tmp' source/ dest/
```

## System Information

### System Details
```bash
# System information
uname -a                   # All system info
uname -r                   # Kernel version
lsb_release -a            # Distribution info
cat /etc/os-release       # OS information
hostnamectl               # System details

# Hardware information
lscpu                     # CPU information
lsmem                     # Memory information
lsblk                     # Block devices
lspci                     # PCI devices
lsusb                     # USB devices
dmidecode                 # DMI/SMBIOS info

# Resource usage
free -h                   # Memory usage
df -h                     # Disk usage
du -sh directory          # Directory size
du -h --max-depth=1      # Subdirectory sizes
iostat                    # I/O statistics
vmstat                    # Virtual memory stats
```

### System Monitoring
```bash
# Real-time monitoring
top                       # Process monitor
htop                      # Better top
iotop                     # I/O monitor
iftop                     # Network monitor
glances                   # System monitor

# System load
uptime                    # Uptime and load
cat /proc/loadavg         # Load average
w                         # Who and load

# Memory
free -h                   # Human readable
cat /proc/meminfo         # Detailed memory info
vmstat 1                  # Update every second

# CPU
mpstat                    # CPU statistics
sar -u 1                  # CPU usage history
```

## Disk and File System

### Disk Management
```bash
# Disk information
fdisk -l                  # List disks
lsblk                     # Block devices tree
blkid                     # Block device IDs
df -h                     # File system usage
df -i                     # Inode usage

# Partition management
fdisk /dev/sda            # Partition disk (MBR)
gdisk /dev/sda            # Partition disk (GPT)
parted /dev/sda           # Advanced partitioning

# File system
mkfs.ext4 /dev/sda1       # Create ext4 filesystem
mkfs.xfs /dev/sda1        # Create XFS filesystem
fsck /dev/sda1            # Check filesystem
e2fsck -f /dev/sda1       # Force check ext filesystem
resize2fs /dev/sda1       # Resize ext filesystem

# Mount/unmount
mount /dev/sda1 /mnt      # Mount device
mount -t ext4 /dev/sda1 /mnt
mount -o ro /dev/sda1 /mnt # Read-only
umount /mnt               # Unmount
umount -l /mnt            # Lazy unmount

# Swap
mkswap /dev/sda2          # Create swap
swapon /dev/sda2          # Enable swap
swapoff /dev/sda2         # Disable swap
swapon -s                 # Show swap usage
```

### File System Management
```bash
# Disk usage
du -sh *                  # Size of files/dirs
du -h --max-depth=1       # One level deep
ncdu                      # NCurses disk usage

# Find large files
find / -size +100M        # Files over 100MB
find / -size +1G          # Files over 1GB

# File system table
cat /etc/fstab            # Filesystem mounts
mount -a                  # Mount all from fstab

# Quotas
quota -u username         # User quota
repquota -a               # Report quotas

# LVM (Logical Volume Manager)
pvcreate /dev/sdb         # Create physical volume
vgcreate vg0 /dev/sdb     # Create volume group
lvcreate -L 10G -n lv0 vg0 # Create logical volume
lvextend -L +5G /dev/vg0/lv0 # Extend volume
```

## Shell Scripting

### Basic Script Structure
```bash
#!/bin/bash
# Shebang - specifies interpreter

# Variables
NAME="John"
AGE=25
echo "Hello, $NAME. You are $AGE years old."

# Command substitution
DATE=$(date)
FILES=`ls`

# Arrays
FRUITS=("apple" "banana" "orange")
echo ${FRUITS[0]}         # First element
echo ${FRUITS[@]}         # All elements
echo ${#FRUITS[@]}        # Array length

# Input
read -p "Enter your name: " USERNAME
read -s -p "Password: " PASSWORD  # Silent

# Arithmetic
NUM1=10
NUM2=5
SUM=$((NUM1 + NUM2))
let "RESULT = NUM1 * NUM2"
RESULT=$(expr $NUM1 + $NUM2)
```

### Control Structures
```bash
# If statements
if [ "$VAR" = "value" ]; then
    echo "Match"
elif [ "$VAR" = "other" ]; then
    echo "Other match"
else
    echo "No match"
fi

# Test operators
# -eq, -ne, -lt, -le, -gt, -ge  # Numeric
# =, !=, <, >                    # String
# -z (empty), -n (not empty)     # String tests
# -f (file), -d (directory)      # File tests
# -r (readable), -w (writable), -x (executable)

# Case statement
case $VAR in
    pattern1)
        echo "Pattern 1"
        ;;
    pattern2|pattern3)
        echo "Pattern 2 or 3"
        ;;
    *)
        echo "Default"
        ;;
esac

# For loops
for i in 1 2 3 4 5; do
    echo $i
done

for i in {1..10}; do
    echo $i
done

for file in *.txt; do
    echo "Processing $file"
done

for ((i=0; i<10; i++)); do
    echo $i
done

# While loops
COUNT=0
while [ $COUNT -lt 10 ]; do
    echo $COUNT
    COUNT=$((COUNT + 1))
done

# Until loops
until [ $COUNT -eq 10 ]; do
    echo $COUNT
    COUNT=$((COUNT + 1))
done
```

### Functions
```bash
# Function definition
function greet() {
    echo "Hello, $1!"
}

# Alternative syntax
greet() {
    local name=$1
    echo "Hello, $name!"
    return 0
}

# Call function
greet "World"

# Function with return value
add() {
    local result=$(( $1 + $2 ))
    echo $result
}

SUM=$(add 5 3)
echo "Sum: $SUM"
```

### Script Best Practices
```bash
#!/bin/bash
set -euo pipefail         # Exit on error, undefined vars, pipe failures

# Error handling
trap 'echo "Error on line $LINENO"' ERR

# Logging
LOG_FILE="/var/log/script.log"
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Check root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Parse arguments
while getopts "hf:v" opt; do
    case $opt in
        h) show_help; exit 0 ;;
        f) FILE="$OPTARG" ;;
        v) VERBOSE=true ;;
        *) echo "Invalid option"; exit 1 ;;
    esac
done

# Default values
: ${VAR:="default"}       # Set if unset
: ${VAR:?"Error: VAR not set"}  # Exit if unset
```

## Environment Variables

### Working with Variables
```bash
# Set variables
export VAR="value"
VAR="value" command       # For single command

# View variables
env                       # All environment variables
printenv                  # Same as env
echo $VAR                 # Specific variable
set                       # All variables (including shell)

# Common variables
echo $HOME                # Home directory
echo $USER                # Current user
echo $PATH                # Executable search path
echo $PWD                 # Current directory
echo $SHELL               # Current shell
echo $TERM                # Terminal type
echo $LANG                # Language settings

# Modify PATH
export PATH=$PATH:/new/path
export PATH=/new/path:$PATH  # Prepend

# Make permanent
# Add to ~/.bashrc or ~/.profile
echo 'export VAR="value"' >> ~/.bashrc
source ~/.bashrc          # Reload
```

## SSH and Remote Access

### SSH Basics
```bash
# Connect
ssh user@host
ssh -p 2222 user@host     # Custom port
ssh -i key.pem user@host  # With key file

# SSH config (~/.ssh/config)
Host myserver
    HostName 192.168.1.100
    User myuser
    Port 2222
    IdentityFile ~/.ssh/mykey

# Then connect with:
ssh myserver

# Key generation
ssh-keygen -t rsa -b 4096
ssh-keygen -t ed25519     # Modern, secure
ssh-keygen -t rsa -b 4096 -C "email@example.com"

# Copy key to server
ssh-copy-id user@host
ssh-copy-id -i ~/.ssh/key.pub user@host

# SSH agent
eval $(ssh-agent)
ssh-add ~/.ssh/id_rsa
ssh-add -l                # List keys
ssh-add -D                # Delete all keys
```

### Advanced SSH
```bash
# Port forwarding
ssh -L 8080:localhost:80 user@host  # Local forward
ssh -R 8080:localhost:80 user@host  # Remote forward
ssh -D 1080 user@host              # SOCKS proxy

# File transfer
scp file user@host:/path
scp -r dir user@host:/path
scp user@host:/file .

# SSH tunneling
ssh -N -L 3306:localhost:3306 user@host  # MySQL tunnel
ssh -N -L 5432:localhost:5432 user@host  # PostgreSQL tunnel

# Execute remote commands
ssh user@host 'command'
ssh user@host 'ls -la'
ssh user@host < script.sh

# SSH multiplexing
# In ~/.ssh/config:
Host *
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h-%p
    ControlPersist 600

# SSHFS - Mount remote filesystem
sshfs user@host:/path /local/mount
fusermount -u /local/mount  # Unmount
```

## System Services

### Systemd (Modern Systems)
```bash
# Service management
systemctl start service
systemctl stop service
systemctl restart service
systemctl reload service
systemctl status service
systemctl enable service   # Start at boot
systemctl disable service
systemctl is-enabled service
systemctl is-active service

# List services
systemctl list-units --type=service
systemctl list-unit-files --type=service
systemctl --failed        # Failed services

# Logs
journalctl -u service     # Service logs
journalctl -f             # Follow logs
journalctl --since "1 hour ago"
journalctl -b             # Boot logs

# Targets (runlevels)
systemctl get-default
systemctl set-default multi-user.target
systemctl isolate graphical.target

# Create service
# /etc/systemd/system/myservice.service
[Unit]
Description=My Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/myprogram
Restart=always
User=myuser

[Install]
WantedBy=multi-user.target
```

### Init.d (Legacy Systems)
```bash
# Service management
service service_name start
service service_name stop
service service_name restart
service service_name status

# Or directly:
/etc/init.d/service_name start

# Enable at boot
chkconfig service_name on  # Red Hat
update-rc.d service_name enable  # Debian

# Runlevels
runlevel                  # Current runlevel
init 3                    # Change to runlevel 3
```

## Log Management

### System Logs
```bash
# Common log files
/var/log/syslog           # System log (Debian)
/var/log/messages         # System log (Red Hat)
/var/log/auth.log         # Authentication
/var/log/kern.log         # Kernel logs
/var/log/boot.log         # Boot logs
/var/log/dmesg            # Driver messages
/var/log/cron             # Cron logs
/var/log/mail.log         # Mail logs

# View logs
tail -f /var/log/syslog   # Follow log
tail -n 100 /var/log/syslog # Last 100 lines
less +F /var/log/syslog   # Follow in less
grep ERROR /var/log/syslog
zcat /var/log/syslog.1.gz # View compressed

# Kernel messages
dmesg                     # Kernel ring buffer
dmesg -T                  # Human readable time
dmesg -w                  # Follow

# Log rotation
cat /etc/logrotate.conf   # Config
logrotate -f /etc/logrotate.conf  # Force rotation
```

### Journalctl (Systemd)
```bash
# View logs
journalctl                # All logs
journalctl -f             # Follow
journalctl -r             # Reverse (newest first)
journalctl -e             # Jump to end
journalctl -n 50          # Last 50 entries

# Filter logs
journalctl -u nginx       # By service
journalctl -p err         # By priority
journalctl --since "1 hour ago"
journalctl --since "2023-01-01" --until "2023-01-02"
journalctl _PID=1234      # By PID
journalctl _UID=1000      # By user ID

# Output formats
journalctl -o json        # JSON format
journalctl -o json-pretty
journalctl -o cat         # Message only

# Disk usage
journalctl --disk-usage
journalctl --vacuum-time=2w  # Keep 2 weeks
journalctl --vacuum-size=500M  # Keep 500MB
```

## Security

### File Security
```bash
# File permissions
chmod 600 private_key     # Owner read/write only
chmod 644 public_file     # Owner write, others read
chmod 755 script.sh       # Owner all, others read/execute

# Find insecure files
find / -perm -002 -type f # World-writable files
find / -nouser            # Files with no owner
find / -perm -4000        # SUID files

# File integrity
md5sum file               # MD5 checksum
sha256sum file            # SHA-256 checksum
sha256sum -c file.sha256  # Verify checksum

# Encryption
gpg -c file               # Encrypt with password
gpg file.gpg              # Decrypt
openssl enc -aes-256-cbc -in file -out file.enc
```

### User Security
```bash
# Password policies
chage -l username         # Password aging info
passwd -l username        # Lock account
passwd -u username        # Unlock account
passwd -S username        # Password status

# Sudo configuration
visudo                    # Edit sudoers safely
# Allow user to run specific command:
# username ALL=(ALL) NOPASSWD: /path/to/command

# Login history
last                      # Login history
lastb                     # Failed logins
who                       # Current logins
w                         # Detailed who

# Account auditing
cat /etc/passwd           # User accounts
cat /etc/shadow           # Password hashes (root)
cat /etc/group            # Groups
```

### Firewall
```bash
# iptables (legacy)
iptables -L               # List rules
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -s 192.168.1.0/24 -j ACCEPT
iptables-save > /etc/iptables/rules.v4

# firewalld (Red Hat)
firewall-cmd --state
firewall-cmd --get-zones
firewall-cmd --get-default-zone
firewall-cmd --add-service=http --permanent
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --reload

# ufw (Ubuntu)
ufw status
ufw enable
ufw allow 22/tcp
ufw allow from 192.168.1.0/24
ufw deny 3306/tcp
ufw delete allow 80/tcp
```

### SELinux
```bash
# Status
getenforce                # Current mode
sestatus                  # Detailed status

# Set mode
setenforce 0              # Permissive (temporary)
setenforce 1              # Enforcing (temporary)

# File contexts
ls -Z file                # Show context
chcon -t httpd_sys_content_t /var/www/html
restorecon -R /var/www    # Restore contexts

# Troubleshooting
ausearch -m avc -ts recent # Recent denials
sealert -a /var/log/audit/audit.log
```

## Performance Monitoring

### Resource Monitoring
```bash
# CPU
top                       # Interactive monitor
htop                      # Better top
mpstat 1                  # CPU stats per second
sar -u 1 10              # CPU usage (1s x 10)

# Memory
free -h                   # Memory usage
vmstat 1                  # Virtual memory stats
sar -r 1 10              # Memory usage history

# Disk I/O
iostat -x 1               # Extended I/O stats
iotop                     # I/O by process
dstat                     # Combined stats

# Network
iftop                     # Network bandwidth
nethogs                   # Bandwidth by process
ss -s                     # Socket statistics
sar -n DEV 1             # Network device stats

# Process tracing
strace -p PID            # System calls
ltrace -p PID            # Library calls
perf top                 # Performance analysis
```

### System Tuning
```bash
# Kernel parameters
sysctl -a                 # All parameters
sysctl net.ipv4.ip_forward  # Specific parameter
sysctl -w net.ipv4.ip_forward=1  # Set temporarily
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf  # Permanent

# Process limits
ulimit -a                 # All limits
ulimit -n 65536          # Open files limit
ulimit -u 4096           # Process limit

# CPU governor
cpupower frequency-info
cpupower frequency-set -g performance

# I/O scheduler
cat /sys/block/sda/queue/scheduler
echo noop > /sys/block/sda/queue/scheduler
```

## Advanced Commands

### Text Processing Power Tools
```bash
# xargs - Build command lines
find . -name "*.txt" | xargs grep "pattern"
find . -name "*.log" -print0 | xargs -0 rm
echo "file1 file2 file3" | xargs -n 1 command
cat urls.txt | xargs -n 1 -P 10 wget  # Parallel

# parallel - GNU parallel
parallel -j 4 gzip ::: *.log
find . -name "*.jpg" | parallel -j 8 convert {} {.}.png
parallel echo ::: A B C ::: 1 2 3

# jq - JSON processor
curl api.example.com | jq '.'
cat file.json | jq '.items[]'
jq '.name' file.json
jq -r '.users[] | .name' file.json  # Raw output
```

### Archive and Compression
```bash
# tar
tar -cvf archive.tar files/   # Create
tar -xvf archive.tar          # Extract
tar -tvf archive.tar          # List
tar -czf archive.tar.gz files/ # Gzip compression
tar -cjf archive.tar.bz2 files/ # Bzip2
tar -cJf archive.tar.xz files/  # XZ
tar -xzf archive.tar.gz -C /dest # Extract to directory

# zip/unzip
zip archive.zip file1 file2
zip -r archive.zip directory/
unzip archive.zip
unzip -l archive.zip          # List contents
unzip archive.zip -d /dest    # Extract to directory

# Compression tools
gzip file                     # Compress (replaces file)
gzip -d file.gz              # Decompress
gzip -k file                 # Keep original
bzip2 file                   # Better compression
xz file                      # Best compression
7z a archive.7z files/       # 7-zip
```

### System Rescue
```bash
# Recovery mode
# Boot with init=/bin/bash
mount -o remount,rw /
passwd                        # Reset root password

# File recovery
extundelete /dev/sda1 --restore-all
photorec                      # Recover various files
testdisk                      # Partition recovery

# System repair
fsck -f /dev/sda1            # Force filesystem check
dpkg --configure -a          # Fix broken packages (Debian)
yum-complete-transaction     # Fix broken transactions (Red Hat)

# Boot repair
grub-install /dev/sda        # Reinstall GRUB
update-grub                  # Update GRUB config
```

## Tips and Tricks

### Command Line Productivity
```bash
# Shortcuts
ctrl+a                   # Beginning of line
ctrl+e                   # End of line
ctrl+k                   # Cut to end of line
ctrl+u                   # Cut to beginning
ctrl+w                   # Cut previous word
ctrl+y                   # Paste (yank)
ctrl+l                   # Clear screen
ctrl+r                   # Search history
ctrl+d                   # Exit/EOF
alt+.                    # Last argument
alt+b                    # Back one word
alt+f                    # Forward one word

# History expansion
!!                       # Last command
!$                       # Last argument
!*                       # All arguments
!:2                      # Second argument
^old^new                 # Replace in last command

# Brace expansion
mkdir -p project/{src,bin,doc}
touch file{1..10}.txt
echo {A..Z}
cp file.txt{,.bak}       # Quick backup

# Command substitution
echo "Today is $(date)"
files=`ls *.txt`

# Process substitution
diff <(sort file1) <(sort file2)
```

### Useful One-Liners
```bash
# Find and replace in files
find . -type f -exec sed -i 's/old/new/g' {} +

# Delete empty directories
find . -type d -empty -delete

# Show top 10 largest files
find . -type f -exec du -h {} + | sort -rh | head -10

# Monitor log file and highlight
tail -f /var/log/syslog | grep --color=auto ERROR

# Batch rename files
for f in *.jpeg; do mv "$f" "${f%.jpeg}.jpg"; done

# Create backup with timestamp
tar czf backup-$(date +%Y%m%d-%H%M%S).tar.gz directory/

# Find files modified in last day
find . -type f -mtime -1

# Show listening ports with process
sudo netstat -tlnp

# Quick HTTP server
python3 -m http.server 8080

# Watch command output
watch -n 1 'ps aux | grep process'

# Generate random password
openssl rand -base64 32
tr -dc 'A-Za-z0-9!@#$%' < /dev/urandom | head -c 20

# System backup
rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*"} / /backup/

# Find duplicate files
find . -type f -exec md5sum {} + | sort | uniq -d -w 32
```

### Shell Customization
```bash
# ~/.bashrc additions
# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias vi='vim'

# Functions
mkcd() { mkdir -p "$1" && cd "$1"; }
backup() { cp "$1"{,.bak-$(date +%Y%m%d-%H%M%S)}; }
extract() {
    case "$1" in
        *.tar.gz|*.tgz) tar xzf "$1" ;;
        *.tar.bz2) tar xjf "$1" ;;
        *.zip) unzip "$1" ;;
        *.gz) gunzip "$1" ;;
        *) echo "Unknown archive format" ;;
    esac
}

# Prompt customization
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# History settings
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:ignorespace
shopt -s histappend

# Better tab completion
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
```

### System Administration Tips
```bash
# Quick system health check
echo "=== System Health Check ==="
echo "Uptime: $(uptime)"
echo "Memory: $(free -h | grep Mem | awk '{print $3 "/" $2}')"
echo "Disk: $(df -h / | tail -1 | awk '{print $3 "/" $2 " (" $5 ")"}')"
echo "Load: $(cat /proc/loadavg | cut -d' ' -f1-3)"
echo "Processes: $(ps aux | wc -l)"

# Monitor multiple log files
multitail /var/log/syslog /var/log/auth.log

# Secure file deletion
shred -vfz -n 3 sensitive_file

# Create encrypted archive
tar czf - directory/ | openssl enc -aes-256-cbc -out archive.tar.gz.enc

# Check all running services
systemctl list-units --type=service --state=running

# Find recently modified config files
find /etc -type f -mtime -7 -name "*.conf"

# Quick performance check
echo "CPU:" && top -bn1 | grep "Cpu(s)" && \
echo "Memory:" && free -h | grep Mem && \
echo "Disk I/O:" && iostat -x 1 1 | grep -A1 avg-cpu
```

---

*Linux is incredibly powerful - the more you learn, the more efficient you become. Practice these commands regularly, and always be careful with destructive operations!*