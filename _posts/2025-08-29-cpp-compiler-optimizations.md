---
title: C++ Compiler Optimizations
date: 2025-08-29
categories: [dev, cpp]
tags: [cpp, compiler, optimization]
---

We explore the world of optimization techniques that modern C++ compilers adopt to use.

These optimization techniques are done on low-level not on source code but I will explain on the code level for clear explanation.

---

### As-if rule

The **"as-if" rule** is a fundamental principle in modern C++ compilers
that allows the compiler to optimize the source code in any way it wants,
as long as the observable behavior remains the same *as if* it followed your original code exactly.
The compiler can change, reorder, or eliminate code as if it's still executing your original program,
but the final result must be identical to what the programmer intended.

---

### Constant folding

```cpp
int x = 3 + 6;
std::cout << x << std::endl;
```
*Constant folding* is an optimization technique that replaces expressions with predictable (at compile-time) results.

`int x= 3 + 6;` will be replaced by `int x = 9;`

---

### Constant propagation

```cpp
int x = 3;
int y = 6;
std::cout << x + y << std::endl;
```

*Constant propogation* is an optimization technique that replaces variables with predictable values.

`std::cout << x + y << std::endl;` will be replaced by `std::cout << 9 << std::endl;`.

---

### Dead code elimination

```cpp
int x = 6;
std::cout << 6 << std::endl;
```

*Dead code elimination* is an optimization technique that removes redundant codes.

`int x = 6` will be removed by dead code elimination.


---

### Compile-time constants vs runtime contants

As we have seen, optimizations are all about **constants**.

There are two types of constants:
- compile-time constant
- runtime constant

```cpp
#include <iostream>

int five()
{
    return 5;
}

int pass(const int x) // x is a runtime constant
{
    return x;
}

int main()
{
    // The following are non-constants:
    [[maybe_unused]] int a { 5 };

    // The following are compile-time constants:
    [[maybe_unused]] const int b { 5 };
    [[maybe_unused]] const double c { 1.2 };
    [[maybe_unused]] const int d { b };       // b is a compile-time constant

    // The following are runtime constants:
    [[maybe_unused]] const int e { a };       // a is non-const
    [[maybe_unused]] const int f { e };       // e is a runtime constant [[maybe_unused]] const int g { five() };  // return value isn't known until runtime [[maybe_unused]] const int h { pass(5) }; // return value isn't known until runtime

    return 0;
}
```
The above code is from [learncpp.com](https://www.learncpp.com/cpp-tutorial/the-as-if-rule-and-compile-time-optimization/).

> WHAT IS `[[MAYBE_UNUSED]]`?  
`[[maybe_unused]]` is a C++17 attribute that tells the compiler:  
"this variable might not be used, and that's okay - don't warn me about it."

---

### Reference

[1] [LearnCpp](https://www.learncpp.com/cpp-tutorial/the-as-if-rule-and-compile-time-optimization/)
