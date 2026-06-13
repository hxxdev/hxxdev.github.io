---
title: A Comprehensive Guide to make and Makefiles
date: 2025-05-02
categories: [dev, cpp]
tags: [make]
layout: single
permalink: /notes/2025/05/windows_thread/
author_profile: true
read_time: true
comments: true
share: true
related: true
---

This post explains the **make command and Makefiles**
🔧 1. Windows DLL Lifecycle & Best Practices
Topics to learn:

What DllMain is and when it is called.

Loader lock and why certain APIs are unsafe in DllMain.

Alternatives: DisableThreadLibraryCalls, using exported functions, etc.

📚 Resources:

Microsoft Docs - DllMain

Raymond Chen’s blog (“The Old New Thing”) — excellent practical advice.

🧵 2. Multithreading in Win32
Topics:

Creating and managing threads with CreateThread, WaitForSingleObject.

Thread safety and synchronization primitives: mutexes, critical sections.

Thread memory management and parameter passing.

📚 Resources:

Charles Petzold’s Programming Windows (a bit dated but still relevant).

Windows Threads - MSDN

🧠 3. Memory Management: Heap vs Stack
Topics:

How memory is allocated (stack vs heap).

Lifetime of variables and safe passing between threads.

Proper deallocation patterns (avoid leaks and invalid access).

📚 Resources:

Any modern C++ book or tutorial that covers RAII and dynamic allocation.

🧬 4. Data Types in Windows Programming
Topics:

Understanding LPVOID, LPWSTR, DWORD64, etc.

Safe casting and why reinterpret_cast vs static_cast matters.

Working with UNICODE vs ANSI.

📚 Resources:

MSDN data type glossary.

Windows headers (Windows.h) to see definitions.

💬 5. Debugging Techniques
Topics:

How to use OutputDebugString instead of AllocConsole.

How to attach a debugger to a process and trace issues.

Understanding call stacks, access violations, and thread states.

📚 Resources:

WinDbg or Visual Studio debugging tutorials.

Your current project with logs, breakpoints, and watches.

🧰 Optional: Tools that help
Dependency Walker / Process Explorer – to see DLL behavior.

GFlags / Application Verifier – to test for loader lock issues.

Visual Studio debugger – breakpoints in threads and watch lpParam values.

Would you like me to make you a checklist or cheat sheet for these topics?

---

### Checklists
✅ Study Checklist & Roadmap
🔹 Phase 1: Understand the DLL Lifecycle
 Learn what DllMain does (DLL_PROCESS_ATTACH, etc.).

 Study why blocking operations and CreateThread are unsafe in DllMain.

 Use DisableThreadLibraryCalls to simplify behavior.

 Build a DLL that logs when it's loaded (use OutputDebugString).

🔹 Phase 2: Safely Creating and Using Threads
 Review CreateThread, WaitForSingleObject, and CloseHandle.

 Learn how to pass data to a thread via LPVOID.

 Implement a thread that receives a dynamically allocated message.

 Ensure correct memory management (thread frees it or main thread does).

🔹 Phase 3: Memory and Type Handling
 Learn difference between stack vs heap memory and lifetime.

 Practice converting int, DWORD64, etc. to LPWSTR using swprintf_s.

 Write template functions for type-to-string conversion.

 Understand and safely use LPVOID, LPWSTR, DWORD, etc.

🔹 Phase 4: Unicode and Output
 Understand UNICODE, LPWSTR, wprintf, and %ls.

 Practice writing messages with OutputDebugStringW.

 Avoid using AllocConsole for debugging unless necessary.

🔹 Phase 5: Debugging & Safe Exporting
 Learn to attach a debugger to a process and set breakpoints.

 Export a StartDebugThread() function from the DLL.

 Write a test .exe that loads your DLL and calls this function.

🔹 Bonus (Optional)
 Build a logging helper that logs current thread ID and time.

 Use std::thread instead of CreateThread (requires DLLMain workaround).

 Explore Detours or MinHook to hook a target API and log from thread.

### References
[1] [GNU Make Manual](https://www.gnu.org/software/make/manual/)

