---
title: What is FUSE?
date: 2025-06-08
categories: [dev, os]
tags: [linux, fuse]
---

I was trying to run AppImage for [Heynote](https://heynote.com/).

But running heynote showed this error:

```text
AppImages require FUSE to run.
You might still be able to extract the contents of this AppImage
if you run it with the --appimage-extract option.
See https://github.com/AppImage/AppImageKit/wiki/FUSE
for more information
```

I started to wonder what is `FUSE` and why do AppImages require `FUSE` to run?

---

## What is AppImage?

AppImage packages an application and all its dependencies into a **single executable file** (like a `.exe` on Windows).  
To run this self-contained app without extracting it, AppImage mounts itself as a virtual filesystem, and this is where `FUSE` comes in.

---

## What FUSE Does for AppImage?

1. Mounting the AppImage internally:

AppImage is a **_SquashFS archive_** (a compressed read-only filesystem).

Instead of extracting the archive, AppImage uses FUSE to mount it on-the-fly when you run the .AppImage.

2. No root required:

Because `FUSE` works in userspace, AppImage can mount and run its contents without root permissions.

3. Transparent execution:

Once mounted, the internal files (like the real app binary, libraries, icons, etc.) are accessed as if they were in a normal folder.

> **_Typical Flow When You Run an AppImage_**
1. You execute the AppImage.
2. AppImage uses FUSE to mount itself (the SquashFS inside).
3. The actual application binary is launched from the mounted image.

> **_NOTE:_** 
In fact, some AppImages do not require `FUSE`.
- Type 1 AppImages: These extract themselves to /tmp and run from there — don’t require FUSE, but are slower and messier.
- Type 2 AppImages: These mount themselves using FUSE — preferred, faster, and cleaner. But they require FUSE to be installed.
Many modern AppImages are Type 2.
You can check their type by `./MyApp.AppImage --appimage-version`
//TODO: how to distinguish between Type 1 and Type 2?

---

## Workarounds

- Manually extracting the AppImage:
Extract the AppImage manually so that it does not require any mountings.

```bash
./Heynote_2.2.2_x86_64.AppImage --appimage-extract
cd squashfs-root
./AppRun
```

- Install FUSE

If you are on Ubuntu:

```bash
sudo apt install fuse
```

If you are on Arch:

```bash
sudo apt install fuse2 fuse3
```

Once installed, you can check if the `FUSE` kernel modules are loaded by:

> **_NOTE:_** 
Some old applications might require `fuse2` instead of `fuse3`.

---

## ✅ Summary

`FUSE` lets AppImage mount its own SquashFS archive in user space so that it can run without root permission and any extraction.
You can extract manually by `./your_appimage.AppImage --appimage-extract` if FUSE is not available.

--- 

## Reference

[1] [Heynote](https://heynote.com/)  
[2] [ArchLinux Wiki](https://wiki.archlinux.org/title/FUSE)  
