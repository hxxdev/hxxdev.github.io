---
title: Understanding C++ Value Categories - lvalue, prvalue, and xvalue
date: 2025-08-09
categories: [dev]
tags: [cpp, lvalue, prvalue, xvalue, move-semantics]
---

# Understanding lvalue, prvalue, and xvalue in C++

In C++, understanding value categories is crucial for mastering modern features like move semantics and perfect forwarding. The three primary value categories are **lvalue**, **prvalue**, and **xvalue**.

This post breaks down these concepts with clear explanations and examples.

---

## What is an lvalue?

An **lvalue** (short for *locator value*) refers to an object that occupies a persistent memory location. You can think of it as an object that has a name.

Because it has a persistent address, you can take its address using the `&` operator.

**Key Characteristics:**
- It has a stable memory address.
- It can appear on the left-hand side of an assignment expression (`=`).
- It persists beyond the expression where it is used.

**Examples:**
Variables, function return values that are lvalue references (`T&`), and members of objects are all lvalues.

```cpp
int a = 10; // 'a' is an lvalue.
a = 20;     // You can assign to it.

int* p = &a; // You can take its address.

std::string s = "hello"; // 's' is an lvalue.
```

## What is a prvalue?

A **prvalue** (short for *pure rvalue*) is a temporary value that does not have a persistent memory location. It's an expression that initializes an object or computes a value.

Literals (like `42` or `true`) and the results of many expressions are prvalues.

**Key Characteristics:**
- It does not have a stable memory address (you can't take its address with `&`).
- It typically appears on the right-hand side of an assignment.
- It is a temporary value that exists only within the expression that creates it.

**Examples:**
```cpp
int x = 42;           // 42 is a prvalue.
int y = 10 + 20;      // The result of '10 + 20' is a prvalue.
std::string s = "temp"; // The string literal "temp" is used to create a temporary
                        // std::string, which is a prvalue used to initialize s.
```

```cpp
int test() {
    int x = 3;
    return x* (x+1);
}
```

For above code, we can observe that prvalue `x*(x+1)` is not stored in memory at all.

```asm
test():
        push    rbp
        mov     rbp, rsp
        mov     DWORD PTR [rbp-4], 3
        mov     eax, DWORD PTR [rbp-4]
        add     eax, 1
        imul    eax, DWORD PTR [rbp-4]
        pop     rbp
        ret
```

## What is an xvalue?

An **xvalue** (short for *eXpiring value*) is a special kind of rvalue. It refers to an object, usually near the end of its lifetime, whose resources can be "stolen" or moved.

This is the key concept that enables move semantics. An xvalue has an identity (a memory location) like an lvalue, but it is marked as movable. The most common way to create an xvalue is by using `std::move`.

**Key Characteristics:**
- It has a memory address, but it's treated as an rvalue.
- It represents an object whose resources can be reused (moved from).
- It is considered "expiring," meaning it won't be used again in its current state.

**Example:**
The result of `std::move` is an xvalue.

```cpp
std::string s1 = "Hello";
// std::move(s1) casts the lvalue 's1' to an rvalue reference (an xvalue).
// This allows the move constructor of s2 to steal the resources from s1.
std::string s2 = std::move(s1);

// After the move, s1 is in a valid but unspecified state.
// Its resources have been moved to s2.
```

## Summary Table

| Value Category | Description | Has an Identity (Addressable)? | Is Movable? | Example |
| :--- | :--- | :--- | :--- | :--- |
| **lvalue** | An object with a persistent name and address. | Yes | No (by default) | `int a;`, `a`, `obj.member` |
| **prvalue** | A temporary (unnamed) value. | No | Yes | `42`, `a + b`, `std::string("tmp")` |
| **xvalue** | An expiring object whose resources can be moved. | Yes | Yes | `std::move(a)`, a function returning `T&&` |

