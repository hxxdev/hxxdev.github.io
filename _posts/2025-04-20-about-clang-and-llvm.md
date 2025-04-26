---
title: Assembly Language Tutorial
date: 2025-04-19
categories: [dev, assembly]
tags: [asm]
---

This post explains Application Binary Interface(ABI), hardware, and how to write assemblies.  
This post is rewritten based on [sonictk's artice](https://sonictk.github.io/asm_tutorial/)

-----------------------------------

## Application Binary Interface(ABI)

Application Binary Interface(ABI) refers to set of conventions, rules, and guidelines that govern how programs interact with the operating system. Therefore, it is defined by OS designer.

 ABI includes:

- how functions are called and returned(calling convention).
- how data types are represented in memory(e.g. alignment, padding).
- The format of the binary object code(e.g. `.obj`, `.exe`).
- How dynamic linking works and how shared libraries are used.
- How memory management, exception handling and system calls are structured.

There are two types of ABI commonly used in Windows and LInux respectively:

- Microsoft X64
- System V ABI

 They differ in how they organize registers, calling conventions, and other details.

|| Microsoft X64 | System V ABI |
|-|:-------------|:--------|
|Registers| 16 general-purpose registers and 16 XMM/YMM registers | Registers RDI, RSI, RDX, RCX, R8, R9, and XMM0–XMM7 |
|Calling convention|Four-register fast-call(`rcx`, `rdx`, `r8`, `r9`)|Follows the AMD64 ABI calling convention|
|Use|Used in Windows|Used in Linux, FreeBSD, macOS, and Solaris|
|Features|Includes a shadow store for callees|Includes the Executable and Linkable Format (ELF)|

-----------------------------------

### General-purpose registers  

There are 16 GPRs on the x64 instruction set; they are 64-bit wide; they are referred to as
`rax, rbx, rcx, rdx, rbp, rsi, rdi, rsp, r8, r9, r10, r11 r12, r13, r14 and r15`.  
The prefix “general-purpose” is a little misleading; while they are technically general-purpose in the sense that the CPU itself doesn't govern how they should be used, some of these registers have specific purposes and need to treated in specific ways according to ABI.
```
General-purpose register Field
--------------------------------------------------------------------
<-------><-------><----------------><------------------------------>  
|   al   |   ah   |                                                |
|        ax       |                                                |
|                eax                |                              |
|                                  rax                             |
```
```
--------------------------------------------------------------------
<-------><-------><----------------><------------------------------>  
|   r8b  |                                                         |
|        r8w      |                                                |
|                r8d                |                              |
|                                  r8                              |
```
-----------------------------------

### SIMD registers

There are 16 FPRs on the x64 instruction set; they are 128-bit wide; they are referred to as `xmm0` .. `xmm15`.

- 128-bit `xmm` registers were introduced by Intel in 1999 as SSE(Streaming SIMD Extensions). When you execute an SSE instruction, it operates on the lower 128 bits of the register (`xmm`).
- 256-bit `ymm` registers were introduced as AVX(Advanced Vector Extensions). When you execute an AVX instruction, it uses the lower 256 bits of the register (`ymm`).  
- `AVX2` was later introduced in 2013, expanding usage of `ymm` into integer operations while `AVX` focused only on floating-point operations.  
- 512-bit `zmm` registers were introduced as AVX-512.  
- When you execute an AVX-512 instruction, it operates on the full 512-bit register (ZMM).

|Register Name|Size|Introduced In|
|:-:|:-:|:-:|
|XMM|128-bit|SSE|
|YMM|256-bit|AVX|
|ZMM|512-bit|AVX-512|

```
SIMD Register Field
--------------------------------------------------------------------
<-------><-------><----------------><------------------------------>  
|       xmm       |                                                |
|               ymm                 |                              |
|                                 zmm                              |
```
-----------------------------------

### Special purpose registers

|Register Name|Size|Description|
|:-:|:-:|:-|
|`rip`| 64-bit | Points where the next instruction to be executed is at in the assembly code. |
|`rsp`| 64-bit | Points to the bottom of the stack. Calling convention shall be met.|
|`rbp`| 64-bit | Points to the original value of `rsp`. Allows us to unwind the stack when we leaven the current scope.|
|`rfl`| 16-bit | Status register. Set after certain instructions have been executed.|

```
about rfl(flag register)

| CF | PF | AF | ZF | SF | TF | IF | DF | OF | IOPL | NT | N/A |

- CF : Carry flag     | PF : Parity flag  | AF : Adjust flag      | ZF : Zero flag
- SF : Sign flag      | TF : Trp flag     | IF : Interrupt flag   | DF : Direction flag
- OF : Overflow flag  
- IOPL : I/O privilege lvel flag(legacy)
- NT : Nested task flag(legacy)
- N/A : reserved for future use
```

| Flag | Description |
|:-:|:-|
|`DF(Description flag)`|Determines left/right direction for moving when comparing string.|
|`SF(Sign flag)`|Shows the sign of the result of an arithmetic operation. `1` means positive.|
|`ZF(Zero flag)`|Shows whether the result of operation is zero or not. `1` means zero.|
|`OF(Overflow flag)`|Set to `1` when the result did not fit in the number of bits used for the operation by the Arithmetic Logic Unit (ALU).|
|`PF(Parity flag)`|Indicates the total number of bits that are set in the result. `1` means even number of bits have been set.|

-----------------------------------

### Memory Segement


<svg width="600" height="600" xmlns="http://www.w3.org/2000/svg">
  <!-- Draw the outer rectangle -->
  <rect x="30" y="50" width="500" height="540" stroke="black" fill="none" stroke-width="6"/>
    <!-- Horizontal dividers -->
    <line x1="30" y1="85" x2="530" y2="85" stroke="black" stroke-width="6"/>
    <line x1="30" y1="150" x2="530" y2="150" stroke="black" stroke-width="6"/>
    <line x1="30" y1="205" x2="530" y2="205" stroke="black" stroke-width="6"/>
    <line x1="30" y1="300" x2="530" y2="300" stroke="black" stroke-width="6" stroke-dasharray="10,10"/>
    <line x1="30" y1="435" x2="530" y2="435" stroke="black" stroke-width="6" stroke-dasharray="10,10"/>
    <!-- Texts -->
    <text x="50" y="75" font-size="25" fill="black">text(.code)</text>
    <text x="50" y="125" font-size="25" fill="black">data(.data)</text>
    <text x="50" y="185" font-size="25" fill="black">bss(uninitialized data)</text>
    <text x="50" y="260" font-size="25" fill="black">heap</text>
    <text x="50" y="510" font-size="25" fill="black">stack</text>
    <text x="0" y="20" font-size="25" fill="black">Address</text>
    <text x="0" y="50" font-size="25" fill="black">0</text>
    <text x="80" y="350" font-size="25" fill="black">call() malloc()</text>
    <text x="350" y="400" font-size="25" fill="black">rsp--</text>
    <!-- Upward Arrow -->
    <line x1="320" y1="435" x2="320" y2="380" stroke="black" stroke-width="6" marker-end="url(#arrowhead)"/> 
    <line x1="260" y1="300" x2="260" y2="355" stroke="black" stroke-width="6" marker-end="url(#arrowhead)"/> 
    <!-- Arrowhead Definition -->
    <defs>
        <marker id="arrowhead" markerWidth="3" markerHeight="3" refX="1.5" refY="1.5" orient="auto">
            <polygon points="0,3  3,1.5 0,0" fill="black"/>
        </marker>
    </defs>
</svg>
<div class="imagecaption"><b style="font-style:normal;">Figure.</b> PE, ELF executable file format</div>

| Memory Segment | Description |
|:-|-|
| Text Segment | Contains the actual assembly instructions |
| Data Segment | constants or initialized data (e.g. int a = 5; or const int a = 5;) |
| BSS Segment | variables that are uninitialzed (e.g. int a;) |

-----------------------------------

### Virtual Memory Address System

- The program asks the OS for memory, and the OS provides virtual addresses.
- The MMU translates these virtual addresses to physical addresses in RAM.
- If the data isn’t in RAM, the OS will fetch it from storage (paging).
- The TLB helps speed up the address translation process by caching recent translations.
- This process makes the program think it has access to a large amount of memory (virtual memory).

-----------------------------------

### Datatypes

|DataType|Description|C/C++|
|:-: | - | :-: |
|Bit| 0 or 1. The smallest addressable form of memory.| - |
|Nibble| 4 bits.| - |
|Byte| 8 bits.|`char`|
|WORD| On the x64 architecture, the word size is 16 bits.| `short`|
|DWORD| Short for “double word”, this means 2 × 16 bit words, which means 32 bits. | `int`, `float`|
|QWORD| Short for “quadra word”, this means 2 × 16 bit words, which means 32 bits. | `long`, `double`|
|OWORD| Short for “octa-word” this means 8 × 16 bit words, which totals 128 bits. This term is used in NASM syntax.| - |
|YWORD| Also used only in NASM syntax, this refers to 256 bits in terms of size (i.e. the size of ymm register.)| - |
| Pointers| On the x64 ISA, pointers are all 64-bit addresses.||

-----------------------------------

### Microsoft x64 ABI

#### What is calling convention?

- Strict guidelines that our assembly code must adhere to when function is used, in order for the OS to be able to run our code.  

For x64 calling convention document, refer to [Microsoft Guide](https://learn.microsoft.com/en-us/cpp/build/x64-calling-convention).

#### Function parameters and return values

There are some rules that dictates how functions should be called and how they sould return their results.

#### Integer arugments

The first four integer arguments are passed in registers. Integer values are passed in left-to-right order in `rcx`, `rdx`, `r8` and `r9`. Arugments five or higher are passed on the stack.

#### Alignment requirements

Most data structures must be aligned to a specific boundary.
For example, stack pointer `rsp` must be aligend to a 16-byte boundary.

For example, let's assume we are calling the function `foo` defined below.
```C
void foo(int a, int b, int c, int d, int e)
{
    /// Some stuff happens here with the inputs passed in...
    return;
}
```
Before calling `foo()`, we must pass `a`, `b`, `c`, and `d` to registers `rcx`, `rdx`, `r8`, and `r9` and `e` to stack.

| argument | register |
| :-: | :-: |
| a | rcx |
| b | rdx |
| c | r8 |
| d | r9 |
| e | stack |

#### Floating-point arguments

Floating-point arguments are passed to `xmm0`, `xmm1`, `xmm2` and `xmm3`.
```C
void foo_fp(float a, float b, float c, float d, float e)
{
    // Do something
    return;
}
```

| argument | register |
| :-: | :-: |
| a | xmm0 |
| b | xmm1 |
| c | xmm2 |
| d | xmm3 |
| e | stack |

#### Mixing arugment types

```C
void foo_fp(float a, float b, float c, float d, float e)
{
    // Do something
    return;
}
```

| argument | register |
| :-: | :-: |
| a | rcx |
| b | rdx |
| c | xmm2 |
| d | r9 |
| e | stack |

#### Other argument types

- Intrinsic types, arrays, and strings are never passed into a register. A point to their memory locations is passed to a register.
- Structs/unions 8/16/32/64 bits in size may be passed as if they were integers of the same size. Those of other sizes are passed as a pointer as well.
- For variadic arguments (i.e. `foo_var(int a, ...)`), the aforementioned conventions apply depending on the type of the arguments that are passed in. However, for floating-point values, both the integer and floating-point registers must have the same argument's value, in case the callee expects the value in the integer registers.
- For unprototyped functions (e.g. forward-declarations), the caller passes integer values as integers and floating-point values as double-precision. The same rule about floating-point values needing to be in both the integer and floating-point registers applies as well.
- Example

```C
struct Foo
{
    int a, b, c; // Total of 96 bits. Too big to fit in one of the GPRs.
}

Foo foo_struct(int a, float b, int c)
{
    // Stuff happens...
    return result; // This is a `Foo` struct.
}

Foo myStruct = foo_struct(1, 2.0f, 3);
```

| argument | register |
| :-: | :-: |
| *myStruct | rcx|
| 1 | rdx |
| 2.0f |  xmm2 |
| 3 | r9 |

##### Return values

- Any scalar return value less than 64-bit is passed to `rax`.
- Any floating return value is passed to `xmm0`.
- Any user-defined type return value with a size of 1/2/4/8/16/32/64-bit is passed to `rax`. Otherwise, a pointer to its memory shall be passed to `rcx` before function call.

##### Volatile and non-volatile

Registers are either volatile or non-volatile.  

- Volatile  
Volatile registers are subject to change and are not guaranteed to be preserved between function calls and scope changes. `rax`, `rcx`, `rdx`, `r8`, `r9`, `r10`, and `r11` registers are considered volatile.
- Non-volatile
Non-volatile registers shall be guaranteed to *preserve* valid values. Therefore, we are responsible for *preserving* the state of the registers. `rbx`, `rbp`, `rdi`, `rsi`, `rsp`, and `r12~15` registers are considered non-volatile.

##### The shadow space(home space)

Under the Microsoft x64 calling convention, there is an unique concept of what's known as a *shadow space*, also referred to as a home space. This is a space that is reserved every time you enter a function and is equal to at least 32 bytes (which is enough space to hold 4 arguments). This space must be reserved whenever you're *making use of the stack*, since it's what is reserved for things leaving the register values on the stack for debuggers to inspect later on. While the calling convention does not explicitly require the callee to use the shadow space, you should allocate it regardless *when you are utilizing the stack*, especially in a *non-leaf* function.

Also, as a reminder, no matter how much space you allocate for the shadow space and your own function's variables, you still need to ensure that the stack pointer is aligned on a 16-byte boundary after all is said and done.

-----------------------------------

### Hello, World

```C
bits 64
default rel

segment .data
    msg db "Hello world!", 0xd, 0xa, 0

segment .text
global main
extern ExitProcess
extern _CRT_INIT

extern printf

main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32

    call    _CRT_INIT

    lea     rcx, [msg]
    call    printf

    xor     rax, rax
    call    ExitProcess
```
-----------------------------------

### Addressing mode

There are three types of addressing modes:

- immediate addressing `mov rax, 0`
- register addressing `mov rax, rbx`
- indirect register addressing `mov rax, [rbx]`
- rip-relative addressing
Before rip-relative addressing was available, the loader had to *fix up* all the codes to relocate any instances of memory addresses that were specified in an absolute manner and add displacement according the program's base address. This *fix up* process was saved in format of instructions in `.reloc` section of PE file format. To tell our assembler(NASM) to compile our program with rip-relative addressing, the directive `default rel`  is used.

-----------------------------------

### Data Segment

```asm
segment .data
    msg db "Hello world!", 0xd, 0xa, 0
```

- define a variable named `msg` of type byte.
- `db` is mmemonic for "define byte"
- 0xd : CR(carriage return)
- 0xf : LF(line feed)
- In Linux, only `LF` is used for line-ending.

-----------------------------------

### Importing and exporting symbols

- `extern` keyword : used for *importing* symbols
- `global` keyword : used for *exporting* symbols
- `_CRT_INIT` refers to Microsoft Visual C++ standard run-time library(MSVCRT) which is Microsoft's implementation of the C99 ISO standard. `libc/libc++` are the equivalents on Linux.

-----------------------------------

### `WinMain` and `main`

#### What is C Runtime (CRT)?

**The C Runtime Library (CRT)** is a collection of functions, macros, and other resources that provide essential functionality required by C programs. It includes:

- Memory management (malloc, free)
- String manipulation (strcpy, strlen, etc.)
- File I/O (fopen, fread, etc.)
- Standard input/output (printf, scanf, etc.)
- Mathematical functions (sin, cos, etc.)
- Process and environment management (exit, getenv, etc.)

#### How CRT Works

1. Initialization Phase
Before main() is called, the CRT sets up the environment.
It initializes global variables, static variables, and handles command-line arguments. If necessary, it sets up thread-local storage and floating-point settings.
2. Execution Phase
The actual user-defined main() function runs.
3. Termination Phase
CRT cleans up resources like open file handles and allocated memory.
Calls functions registered with atexit().
Exits using exit() or _exit().

#### Program Entry Point

The entry point of a C program is where execution begins. Although most programmers consider main() as the starting point, the actual entry point is determined by the runtime environment and the operating system.

#### Common Entry Points

- Standard C Program:
  - The true entry point in most systems is _start (not main()).
  - _start is typically provided by the CRT or system startup code.
  - _start calls the CRT initialization routine and then calls main().
- Windows:
  - Windows programs use mainCRTStartup() (for console apps) or WinMainCRTStartup() (for GUI apps).
  - These functions initialize the CRT before calling main() or WinMain().
- Custom Entry Points:
  - In embedded systems or specialized environments, the entry point can be defined explicitly (e.g., using linker scripts).

#### How Execution Flows

1. OS loads the executable → Calls _start
2. CRT initializes → Sets up stack, heap, static/global variables
3. CRT calls main()
4. Program runs
5. CRT handles termination → Calls cleanup functions, exits

> ##### from Microsoft Developer Network(MSDN)
>
> If your project is built using /ENTRY, and if /ENTRY is passed a function other than `_DllMainCRTStartup`, the function must call `_CRT_INIT` to initialize the CRT. This call alone is not sufficient if your DLL uses /GS, requires static initializers, or is called in the context of MFC or ATL code. See DLLs and Visual C++ run-time library behavior for more information.

-----------------------------------

### Making a shadow space

``` asm
push rbp
mov rbp, rsp
sub rsp, 32
```

- `push rbp` : saves the base pointer of stack used by previous scope.
- `mov rbp, rsp` : pass the start point of stack used by current scope.
- `sub rsp, 32` : allocate 32-byte of stack to be used by current scope.
- This snippet of code(or some variations) will be there at the beginning of every function writen in assembly!

-----------------------------------

### Shutting down the program

- The return value for a function goes into `rax` register.
- Example

``` asm
xor rax, rax
call ExitProcess
```

- It sets the return value of function `main` as `0` by xor-ing them out.
- It calls Win32 ExitProcess function.

-----------------------------------
