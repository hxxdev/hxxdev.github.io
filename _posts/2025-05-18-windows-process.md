---
title: Deep Dive into Windows process
date: 2025-05-18
categories: [dev, windows]
tags: [process]
---

## 🖥️ Windows Process

A process in Windows is an instance of a running program. It contains the program code and its current activity, including:

- Memory: Code, data, and stack
- Handles: References to system resources (files, events, etc.)
- Threads: One or more threads of execution running in the process
- Security context: User permissions and privileges
- System resources: Loaded DLLs, heaps, environment variables, and more

Process Creation: When you launch an application, Windows creates a process to run that program, allocating resources and setting up its environment.

---

## 🔑 Handle and Object 📦

### Handle

A handle is a unique identifier (like a reference or pointer) used by Windows to access system resources.
Handles are opaque to the user; you don't see the actual resource but use the handle to manipulate it.
Examples of handles: file handles, process handles, thread handles, registry key handles.
Handles are created by the kernel and given to processes to safely access resources.

### Object

An object in Windows is a fundamental data structure managed by the Windows Object Manager.
Objects represent system resources like files, events, mutexes, processes, threads, devices, etc.
Each object has a type and attributes.
The handle is the access token that refers to an object, enabling interaction while maintaining security.

In short:
Object = actual resource/data structure
Handle = reference to access the object

{ %plantuml% }
class Object {
  +type
  +attributes
}
class Handle {
  +reference_to_Object
}

Handle --> Object : references
{ %endplantuml% }

---

## ⚙️ Service Process

A service process hosts a Windows service — background applications that start automatically or manually and run without user interaction. These services typically operate under system accounts like LocalSystem with elevated privileges. Examples include Windows Update and the Print Spooler. Service processes manage essential system functions such as networking, security, and hardware management behind the scenes.

---

## 📂 PE Format (Portable Executable)


The PE format is the standard file format for Windows executables, DLLs, and system files. It governs how Windows loads and runs binaries.

Key components include:

- DOS Header: legacy support
- PE Header: identifies the file type, architecture, and entry point
- Sections: code (.text), data (.data), resources (.rsrc), imports, exports

The Windows loader reads these headers, maps sections into memory, resolves imported functions, and transfers control to the program’s entry point.

---

## 🧵 Thread

A thread is the smallest unit of execution within a process.
Every process has at least one thread (main thread).
Threads share the process's resources (memory, handles) but have their own:

- Stack
- Registers (CPU context)
- Thread ID

Multithreading enables parallel execution inside a process.
Threads are scheduled independently by the OS.

{ %plantuml% }
class Process {
  +Memory
  +Handles
}
class Thread {
  +Stack
  +Registers
  +ThreadID
}

Process "1" *-- "multiple" Thread : contains
{ %endplantuml% }

---

## 🧠 Virtual Memory 💾

Virtual memory abstracts physical memory, allowing each process to have its own address space.
In 32-bit Windows processes:
A single process can typically use up to 2 GB of virtual address space.
The address space is split:

- User space: 0x00000000 to 0x7FFFFFFF (2 GB)
- Kernel space: 0x80000000 to 0xFFFFFFFF (2 GB)

In 64-bit Windows processes:
A process can theoretically use the entire available virtual memory (much larger than physical RAM).
Kernel space is reserved at high addresses, typically:
`0xFFFF800000000000` to `0xFFFFFFFFFFFFFFFF`

Kernel space is shared among all processes but protected so user-mode code cannot access it.
This separation provides security and stability.
PlantUML diagram for 32-bit virtual memory layout:

{ %plantuml% }
rectangle "User Space\n(0x00000000 - 0x7FFFFFFF)" as UserSpace
rectangle "Kernel Space\n(0x80000000 - 0xFFFFFFFF)" as KernelSpace

UserSpace -[hidden]-> KernelSpace
{ %endplantuml% }

{ %plantuml% }
rectangle "User Space\n(Low Addresses, up to ~8 TB)" as UserSpace64
rectangle "Kernel Space\n(High Addresses: 0xFFFF800000000000 - 0xFFFFFFFFFFFFFFFF)" as KernelSpace64

UserSpace64 -[hidden]-> KernelSpace64
{ %endplantuml% }

---

## 🔍 Process Explorer 🛠️

[Process Explorer](https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer) is a powerful system monitoring tool from Microsoft’s Sysinternals suite.

It gives detailed information about running processes, threads, handles, DLLs, memory usage, and more.
Features include:
Hierarchical view of processes and parent-child relationships
Detailed handles and DLLs opened by each process
CPU and memory usage graphs
Ability to suspend, kill, or inspect processes
Viewing process security tokens and privileges
It is widely used for debugging, malware analysis, and system performance monitoring.

---

## References

[1] [Microsoft Docs – Windows Processes and Threads](https://learn.microsoft.com/en-us/windows/win32/procthread/processes-and-threads)

[2] [Microsoft Docs – Windows Virtual Memory](https://learn.microsoft.com/en-us/windows/win32/memory/virtual-memory)

[3] [Microsoft Docs – Portable Executable File Format](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format)

[4] [Microsoft Docs – Windows Services](https://learn.microsoft.com/en-us/windows/win31/services/services)

[5] [Microsoft Sysinternals – Process Explorer Documentation](https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer)

