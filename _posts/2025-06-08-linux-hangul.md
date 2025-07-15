---
title: Setting up Hangul in Linux
date: 2025-06-08
categories: [dev, os]
tags: [linux, hangul, ibus]
---

### Setting up Hangul in Linux

This guide will walk you through the process of setting up Korean (Hangul) support on your Linux system.

---

#### Step 1: Enable Korean Locale

First, we need to enable the Korean locale in our system. This involves uncommenting the necessary entries in the /etc/locale.gen file.

```bash
sudo vim /etc/locale.gen
```

In this file, locate and uncomment the following lines:

Uncomment the following lines
```text
en_US.UTF-8 UTF-8
ko_KR.UTF-8 UTF-8
```

After making these changes, save the file and exit the editor.

---

#### Step 2: Generate Locales

Now that we've enabled the Korean locale, we need to generate it:

```bash
locale-gen
```

This command will create the necessary locale files based on the entries we uncommented earlier.

---

#### Step 3: Install ibus

Ibus is a keyboard layout framework for Linux systems. It allows users to switch between different keyboard layouts easily.

Ibus can be installed by:

```bash
sudo pacman -Syu ibus ibus-hangul
```

This command will install the IBus and the Hangul-specific input method.

---

#### Step 4: Configure IBus

Now that we have installed the required packages, let's configure IBus to use the Korean-Hangul input method:

```bash
ibus-setup
```

When the IBus configuration window opens:

- In the **Next input Method** tab, add "Korean - Hangul"
- In the **General** tab, set your preferred next input method (e.g., `<Shift> space` is commonly used)
- Click "Close" to exit the setup

---

#### Step 5: Start ibus at desktop session

If you are using KDE, go to:  
**Input Devices -> Virtual Keyword**.  
Select **_IBus Wayland_** and apply.

---

#### Using Hangul Input

With these steps completed, you should now be able to use Korean-Hangul input on your Linux system. To switch between languages, you can typically use the
key set as **Next input Method**.  

Remember to log out and back in to your session after making these changes for them to take full effect.

This setup allows you to type in Korean using the familiar Hangul alphabet, making it easier to communicate in Korean on your Linux machine.

