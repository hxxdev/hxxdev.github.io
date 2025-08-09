---
title: A Deep Dive into the Linux Filesystem
date: 2025-08-09
categories: [dev, linux]
tags: [linux, filesystem, fhs, cli]
---

### Linux

The term "Linux" refers to the combination of the **Linux kernel** (which manages the system's resources) and the **GNU core utilities** (which provide most of the command-line tools).
Together, they form a complete and powerful operating system.

---

### Core Concepts: The Disk and the Filesystem

At the most fundamental level, a storage device like a hard drive or SSD is simply a **disk**—a vast, unstructured block of raw bytes. To make it useful, we need a **filesystem**.

A filesystem is a logical layer that organizes those bytes into the files and directories we interact with daily. It's the rulebook for how data is stored, accessed, modified, and deleted. Without it, there would be no concept of a "file" or a "folder," just a massive, unusable sea of data.

Linux supports a wide variety of filesystems, each with different strengths:
- **ext4**: The default for most Linux distributions, known for its stability and robustness.
- **XFS**: A high-performance filesystem that excels at handling large files and parallel I/O.
- **Btrfs**: A modern filesystem offering advanced features like copy-on-write, snapshots, and integrated volume management.
- **FAT32/NTFS**: Filesystems from the Windows world. Linux can read and write to them, which is crucial for dual-booting and data exchange.
- **SWAP**: Not a filesystem for user data, but a special format for a disk partition used as "swap space" (virtual memory) when the physical RAM is full.

---

### The Filesystem Hierarchy Standard (FHS)

To ensure consistency across different distributions, most Linux systems adhere to the **Filesystem Hierarchy Standard (FHS)**. This standard defines the main directories and their purpose. Let's explore the most important ones you'll find at the root (`/`) of the filesystem.

- **`/` (Root)**
  The top-level directory. Every single path on the system starts from here.
  ```bash
  # Listing the contents of the root directory
  ls /
  ```

- **/bin** (Essential User Binaries)
  Contains essential command-line programs (binaries) needed for the system to function, even in single-user mode.
  *Examples*: `ls`, `cp`, `mv`, `cat`, `echo`, `bash`.

- **/sbin** (Essential System Binaries)
  Similar to `/bin`, but contains programs essential for system administration and recovery.
  *Examples*: `reboot`, `fdisk`, `ip`, `mkfs`.

- **/lib** (Essential Libraries)
  Holds the shared library files that the binaries in `/bin` and `/sbin` depend on.
  *Examples*: The C library (`libc.so.6`), the dynamic linker (`ld-linux-x86-64.so.2`).

- **/boot** (Boot Loader Files)
  Contains the files needed to boot the system, including the Linux kernel, the initial RAM disk (`initramfs`), and the bootloader configuration (GRUB).
  ```bash
  # You'll typically find your kernel images here
  ls /boot
  ```

- **/efi** (EFI System Partition)
  On modern computers that use UEFI (Unified Extensible Firmware Interface), this directory is the standard mount point for the EFI System Partition (ESP). The ESP is a special partition that stores the boot loaders, kernel images, and drivers that the firmware needs to start the operating system. It is typically formatted with a FAT32 (`vfat`) filesystem for compatibility.

- **/dev** (Device Files)
  In Linux, everything is a file. This directory contains special files that represent hardware devices.
  *Examples*: `/dev/sda1` (first partition on the first hard disk), `/dev/tty1` (a terminal), `/dev/null` (a black hole that discards all input), `/dev/random` (a source of random numbers).

- **/etc** (System Configuration Files)
  Contains system-wide configuration files for installed programs. The name is a historical remnant of "et cetera."
  *Examples*: `/etc/fstab` (defines disk partitions), `/etc/passwd` (user account info), `/etc/ssh/sshd_config` (SSH server configuration).

- **/home** (User Home Directories)
  This is where personal directories for each user are stored.
  *Example*: For a user named `alex`, their files would be in `/home/alex`.

- **/root** (Root User's Home)
  The home directory for the system administrator, or "root" user. It's kept separate from `/home` for security and recovery purposes.

- **/tmp** (Temporary Files)
  A directory for storing temporary files. The contents of this directory are often cleared upon reboot. A related directory, `/var/tmp`, is for temporary files that should be preserved between reboots.

- **/usr** (User Programs and Data)
  One of the largest directories, containing shareable, read-only data. This includes user-installable programs, libraries, and documentation.
  - **/usr/bin**: Non-essential command binaries for all users (most day-to-day commands are here).
  - **/usr/sbin**: Non-essential system administration binaries.
  - **/usr/lib**: Libraries for programs in `/usr/bin` and `/usr/sbin`.
  - **/usr/local**: For software installed locally by the administrator that isn't part of the official distribution.

- **/var** (Variable Files)
  For files whose content is expected to grow or change, i.e., variable data.
  *Examples*: `/var/log` (system log files), `/var/cache` (application cache data), `/var/spool/mail` (email spools).
  ```bash
  # View the main system log (on many systems)
  tail -f /var/log/syslog
  ```

- **/opt** (Optional Packages)
  Reserved for add-on software packages from third-party vendors.
  *Examples*: Google Chrome (`/opt/google/chrome`), LibreOffice.

- **/mnt** & **/media** (Mount Points)
  Used as temporary attachment points for other filesystems.
  - **/mnt**: For manually mounting a filesystem (e.g., a network share).
  - **/media**: For automatically mounting removable media (e.g., `/media/user/USB_DRIVE`).

- **/lost+found** (Recovered Files)
  On `ext` filesystems, this directory stores corrupted or orphaned files recovered by the filesystem check tool (`fsck`).

---

### Virtual Filesystems

Linux uses several "virtual" filesystems that are created in memory by the kernel and do not exist on the disk. They provide a powerful interface for interacting with the system.

- **/proc** (Process Information)
  Provides detailed information about kernel status and running processes.
  ```bash
  # View CPU information
  cat /proc/cpuinfo
  # View memory information
  cat /proc/meminfo
  ```
- **/sys** (System Information)
  A structured view of the system's hardware and kernel modules. It's a more modern and organized alternative to parts of `/proc`.

- **/run** (Runtime Data)
  Stores transient data for running processes, such as process IDs (PIDs) and sockets. Its contents are cleared on boot.

---

### Practical Filesystem Commands

Here are a few commands to explore the filesystems and partitions on your own machine.

#### How to Check Your Filesystem Types with `df`

The `df -T` command is the easiest way to see all currently mounted filesystems and their types.

```bash
df -T
```
The output will look something like this:
```text
Filesystem     Type     1K-blocks      Used Available Use% Mounted on
/dev/sdb3      ext4     474435632 102141388 348120728  23% /
dev            devtmpfs  32846848         0  32846848   0% /dev
tmpfs          tmpfs     32871032      1848  32869184   1% /run
/dev/sdb1      vfat       1046512       168   1046344   1% /efi
tmpfs          tmpfs     32871036      1968  32869068   1% /tmp
```
From this, you can see the filesystem `Type` (e.g., `ext4`, `vfat`, `tmpfs`) for each `Mounted on` point (e.g., `/`, `/efi`).

#### Inspecting the Partition Table with `fdisk`

To see the raw partition scheme of your disks, you can use `fdisk -l`. This shows how the physical disks are divided. *Note: `fdisk` usually requires root privileges.*

```bash
sudo fdisk -l
```

```text
Disk /dev/sda: 2 TiB, 2000398934016 bytes, 3907029168 sectors
Disk model: Generic SSD
Disklabel type: gpt
Disk identifier: 0x1234abcd-1234-abcd-1234-abcdef123456

Device         Start        End    Sectors  Size Type
/dev/sda1       2048     206847     204800  100M EFI System
/dev/sda2     206848     239615      32768   16M Microsoft reserved
/dev/sda3     239616 2881656831 2881417216  1.3T Microsoft basic data


Disk /dev/sdb: 465.76 GiB, 500107862016 bytes, 976773168 sectors
Disk model: Generic SSD
Disklabel type: gpt
Disk identifier: 0xabcd1234-abcd-1234-abcd-123456abcdef

Device        Start       End   Sectors   Size Type
/dev/sdb1      2048   2099199   2097152     1G EFI System
/dev/sdb2   2099200  10487807   8388608     4G Linux swap
/dev/sdb3  10487808 976773119 966285312 460.8G Linux root (x86-64)
```

