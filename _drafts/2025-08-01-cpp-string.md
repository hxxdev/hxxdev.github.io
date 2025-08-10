---
title: cpp string class
date: 2025-08-09
categories: [dev]
tags: [cpp]
---

# Reference Variables vs Normal Variables in C++

## 1. Normal Variable
A normal variable **stores the value directly**.

```cpp
int a = 10;  // Store 10 in the memory location named 'a'
a → its own independent memory space.
```

Copying creates a new copy of the value.

```
int b = a; // b gets a copy of a's value (10)
b = 20;    // Only b changes, a remains the same
```

📌 Characteristics

Each variable has independent memory

Assignments create copies

Passing to a function is by value by default

2. Reference Variable
A reference variable is an alias for an existing variable.

```
int a = 10;
int& ref = a;  // ref is a reference to a
```

`ref` does not create new memory, it shares the same address as a.

Changing `ref` changes `a` as well.

```
ref = 20;   // a becomes 20
```

📌 Characteristics

- Must be initialized when declared (`int& r;` is invalid)
- Cannot be reseated to reference another variable
- Passing by reference avoids copies and can modify the original

3. Memory View Comparison
```
int a = 10;
int b = a;    // [a: 10] [b: 10] (different addresses)
int& r = a;   // r shares the address of a
```

| Variable Type | Address (example) | Value |
| a             | 0x100             | 10    |
| b             | 0x104             | 10    |
| r (reference) | 0x100             | 10    |

`r` shares the same address as `a`.


4. Difference in Functions

```cpp
void byValue(int x) { x = 20; }
void byRef(int& x)  { x = 20; }

int main() {
    int a = 10;
    byValue(a); // a is still 10 (copy)
    byRef(a);   // a becomes 20 (modified)
}
```

By value → protects the original, can be slower for large objects

By reference → modifies the original, avoids copy overhead


```cpp
std::string s1 = "Hello";
std::string s2 = s1; // Copy
```

Both `s1` and `s2` are normal objects.

The variable itself is not a reference.

Internally, it stores a reference (pointer)
`std::string` internally looks like:

```nginx
s1 (on stack)
 └─[pointer]──> "Hello\0" (on heap)
```

The object itself is stored on the stack

String data is dynamically allocated on the heap

Managed internally through a pointer (reference to memory)

3. Actual reference example

```cpp
std::string s1 = "Hello";
std::string& ref = s1; // reference variable
ref[0] = 'J';
std::cout << s1; // "Jello"
```
`ref` and `s1` refer to the same object

A true reference variable is declared with `&`.

4. Why people get confused
Unlike int, which stores its value directly, std::string stores a pointer to its actual data

This leads to casual statements like "string is a reference"

However, the variable itself is not a C++ reference.






### decltype

> C++ Standard
"The type denoted by decltype(e) is deﬁned as follows:
— if e is an unparenthesized id-expression or an unparenthesized class member access (5.2.5), decltype(e) is the type of the entity named by e.
If there is no such entity, or if e names a set of overloaded functions, the program is ill-formed;
— otherwise, if e is an xvalue, decltype(e) is T&&, where T is the type of e;
— otherwise, if e is an lvalue, decltype(e) is T&, where T is the type of e;
— otherwise, decltype(e) is the type of e."

#### Explanation of `decltype` Behavior Regarding Parentheses and Expressions

- `decltype` has **two main uses**:  
  1. Inspecting the declared type of an **identifier** (e.g., variable name).  
  2. Inspecting the type of a **general expression**, considering its value category (lvalue, rvalue, etc.).

- The C++ standard distinguishes between **unparenthesized id-expressions** and other expressions because:  
  - If you put parentheses around an id-expression (e.g., `(x)`), it is no longer treated as an **id-expression** but as a **primary-expression**.  
  - This changes how `decltype` deduces the type.

- There is **nothing inherently special about parentheses** except that they change the grammar category of the expression, which affects the rules `decltype` applies.

- The phrase **"unparenthesized"** is included in the spec to clarify this subtle but important difference in parsing and type deduction.

- An alternative design could have been to have **two separate keywords**: one for identifiers and one for general expressions, avoiding this confusion.  
  But the committee preferred to keep a single keyword (`decltype`) for both uses, despite the complexity.

- Technically, for general expressions, `decltype` returns the expression’s type with an appropriate **reference modifier** based on its value category (inverse of how expressions usually remove reference modifiers).

---

