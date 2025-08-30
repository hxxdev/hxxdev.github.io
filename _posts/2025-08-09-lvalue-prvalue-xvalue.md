---
title: C++ Expression Type and Value Categories - lvalue, rvalue
date: 2025-08-09
categories: [dev]
tags: [cpp, lvalue, prvalue, xvalue, move-semantics]
---

# Understanding C++ Expression

In C++, understanding expression is crucial for mastering modern features like move semantics and perfect forwarding.

This post breaks down these concepts with clear explanations and examples.

---

## Expression

In C, for compiler to determine whether a given expression is legal or not,
there are two properties of expression: a **type** and a **value category**.

---

### Type of Expression

Type of expression is the same as the type of the evaluated expression.

For example, 

```cpp
auto a1 = 18 / 3; // this expression is int type.
auto a2 = 18.0 / 3.0; // this expression is double type.
```

---

### Value Category of Expression

There are mainly two types of value categories: **lvalue** and **rvalue**.

#### What is an lvalue?

An **lvalue** (short for *locator value*) refers to an object that occupies a persistent memory location.

You can think of it as an *identifiable* object that has a name.

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

More specifically, lvalues are again composed of **modifiable lvalue** and **non-modifiable lvalue**.

Non-modifiable lvalues are restricted to be modified at compile-time because they are `const` or `constexpr`.

Example:

```cpp
int a;
a = 3; // a is a modifiable lvalue.
const int b = 9; // b is a non-modifiable lvalue.
```

> lvalue-type expressions are evaluated into an identifiable object that persist beyond the end of the expression.

---

#### What is an rvalue?

Simply said, all expressions that is not lvalue(that is not identifiable) is **rvalue**.

They are mostly literals like `3`, `3.0`.

Other examples include `x+1`, `foo()`.

Example:
```cpp
int a;
a = 3; // 3 is a rvalue.
```

> rvalue-type expressions are evaluated into a values which are temporary and do not persist beyond the end of the expression.

---

### Legal Operators

Now we can answer which operands are legal to an operator.

Example:

```cpp
int x;
std::cout << 3 + 6 << std::endl; // legal
x = 9; // legal
9 = x; // illegal
```

`+` operator expects both operands to be a rvalue.
While `=` operator expects left operand to be a **modifiable lvalue** and right operand to be an **rvalue**.

---

### lvalue to rvalue conversion

Example:

```cpp
int x;
int y = 3;
x = y; // legal even y is lvalue.
```
One might be wondering, even `=` operator expects right operand to be an **rvalue**, above example is still legal.

This is due to **lvalue to rvalue conversion**.

Example:

```cpp
int x = 3;
std::cout << x + 1 << std::endl;
```

Even `+` operator expects both operands to be a rvalue, the conversion is applied to `x`.

> Thanks to lvalue to rvalue conversion, lvalue can replace where rvalue is expected but not vice versa.

---

### Appendix

People who are still curious about rvalue can read this section.

There are two types or rvalues: **prvalue** and **xvalue**.

#### What is a prvalue?

A **prvalue** (short for *pure rvalue*) is a temporary value that does not have a persistent memory location.
It's an expression that initializes an object or computes a value.

**Key Characteristics:**
- It does not have a stable memory address (you can't take its address with `&`).
- It typically appears on the right-hand side of an assignment.
- It is a temporary value that exists only within the expression that creates it.

Example:

Literals (like `42` or `true`) are rvalues.

```cpp
int x = 42;           // 42 is a prvalue.
int y = 10 + 20;      // The result of '10 + 20' is a prvalue.
std::string s = "temp"; // The string literal "temp" is used to create a temporary
                        // std::string, which is a prvalue used to initialize s.
```

Expressions (like `x*(x+1)`) are rvalues. Note that `x*(x+1)` is not identifiable.

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

An **xvalue** (short for *eXpiring value*) is a special kind of rvalue.
It refers to an object, usually near the end of its lifetime, whose resources can be "stolen" or moved.

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

---

## Summary Table

| Value Category | Description | Has an Identity (Addressable)? | Is Movable? | Example |
| :--- | :--- | :--- | :--- | :--- |
| **lvalue** | An object with a persistent name and address. | Yes | No (by default) | `int a;`, `a`, `obj.member` |
| **prvalue** | A temporary (unnamed) value. | No | Yes | `42`, `a + b`, `std::string("tmp")` |
| **xvalue** | An expiring object whose resources can be moved. | Yes | Yes | `std::move(a)`, a function returning `T&&` |

---

### Reference
[1] [learncpp](https://www.learncpp.com/cpp-tutorial/value-categories-lvalues-and-rvalues)
[2] [cppreference](https://en.cppreference.com/w/cpp/language/value_category.html)
