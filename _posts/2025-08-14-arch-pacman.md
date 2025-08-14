---
title: Arch Linux package manager pacman
date: 2025-08-14
categories: [dev, linux]
tags: [linux, arch, pacman]
---

### A Practical Guide to Pacman & Yay

This guide provides a practical overview of `pacman`, the default package manager for Arch Linux, and `yay`, a popular AUR (Arch User Repository) helper.

#### `pacman`: The Arch Linux Package Manager

`pacman` is a powerful command-line utility that is one of the major distinguishing features of Arch Linux. It handles installing, upgrading, querying, and removing packages from the official repositories.

##### Core Operations

Package management can be thought of in a lifecycle: finding, installing, querying, and removing.

###### 1. Synchronizing and Installing (`-S`)

These commands download packages from remote repositories.

- `pacman -S <package>`: Installs a specific package.
- `pacman -Ss <search_term>`: Searches the repositories for a package.
- `pacman -Si <package>`: Displays detailed information about a remote package.
- `pacman -Syu`: **The most important command.** Synchronizes the local package database (`y`) and then upgrades all out-of-date packages (`u`). This is the standard command to keep your system fully updated.
- `pacman -Sc`: Cleans the package cache. Use `pacman -Scc` to clear all cached files.

###### 2. Querying Installed Packages (`-Q`)

These commands look at packages already installed on your local system. This is where the `local/` repository name comes from, as seen in `pacman -Qs`. It means the package is on your local machine.

- `pacman -Q`: Lists all packages installed on your system.
- `pacman -Qe`: Lists only explicitly installed packages (not dependencies).
- `pacman -Qd`: Lists "orphans" (packages installed as a dependency that are no longer required).
- `pacman -Qs <search_term>`: Searches for an already-installed package.
- `pacman -Qi <package>`: Displays detailed information about an installed package.
- `pacman -Ql <package>`: Lists all files owned by a specific package.
- `pacman -Qo <file_path>`: Shows which package owns a specific file.

###### 3. Removing Packages (`-R`)

These commands uninstall packages from your system.

- `pacman -R <package>`: Removes a package.
- `pacman -Rs <package>`: **Recommended.** Removes the target package and its dependencies that aren't required by any other package.
- `pacman -Rns <package>`: A thorough removal command. It removes the package (`R`), its unneeded dependencies (`s`), and discards any backup configuration files(`.pacsave`) (`n`).

> **WARNING: Use the `-c` flag with extreme caution.**
> The command `pacman -Rcns <package>` is very powerful and can be destructive. The `c` flag stands for **cascade**, and it removes the target package *and everything else on the system that depends on it*. This can easily lead to removing critical parts of your system by accident. For most use cases, `pacman -Rns` is the safer choice.

###### 4. Installing from a Local File (`-U`)

- `pacman -U <path/to/package.pkg.tar.zst>`: Installs a package from a local file, such as one built from the AUR.

---

#### `pactree`: Visualizing Dependencies

`pactree` is a utility (included in `pacman-contrib`) that provides a clear tree view of dependencies.

- `pactree <package>`: Shows the **forward dependency tree**. It displays the package and everything it needs to function.
- `pactree -r <package>`: Shows the **reverse dependency tree**. It displays the package and everything that depends on it. This is perfect for figuring out why a certain package was installed.

---

#### `yay`: An AUR Helper

###### What is the AUR?

The Arch User Repository (AUR) is a vast, community-driven repository for Arch users.
It contains package build scripts (PKGBUILDs) that allow you to compile and install software not available in the official repositories.

###### What is `yay`?

Since `pacman` cannot interact with the AUR directly, you need an **AUR helper**.
`yay` is one of the most popular helpers.
It acts as a wrapper around `pacman`, seamlessly integrating AUR packages with packages from the official repositories.

##### Common `yay` Commands

`yay` uses `pacman`'s syntax for most operations, making it very intuitive.

- `yay`: With no arguments, this is the equivalent of `pacman -Syu` but **it also checks for and installs updates for AUR packages**. This is the all-in-one command to keep your entire system updated.
- `yay <package>`: Searches for and installs a package from both the official repositories and the AUR.
- `yay -Rns <package>`: Uninstalls a package, using the same syntax as `pacman`.
- `yay -Sua`: Upgrades only AUR packages.
- `yay -Ps`: Prints system statistics, like uptime and package versions.
- `yay -Yc`: Cleans unneeded dependencies (orphans) from both official and AUR packages.

---

### Reference

[1] https://wiki.archlinux.org/title/Pacman
