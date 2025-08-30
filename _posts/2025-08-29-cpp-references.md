---
title: C++ References
date: 2025-08-29
categories: [dev, cpp]
tags: [cpp, reference]
---

Hi all. Today, we will take a deep dive into references in C++.

This post is a natural continuation of the concepts discussed in [C++ Lvalues and Rvalues](https://hxxdev.github.io/posts/lvalue-prvalue-xvalue).

---

### What is a Reference?

In C++, a **reference** is an alias for an already existing object. It's another name for a variable. Once a reference is initialized to an object, it cannot be "reseated" to refer to a different object. The reference acts as a new name for the original object.

---

### Key Characteristics of References

1. References Must Be Initialized
2. A Reference Cannot Be Reseated
3. References Are Not Objects. They do not occupy any storage.
4. Reference and referents have independent lifetimes.

References have a few fundamental properties that you must understand.

#### 1. References Must Be Initialized
A reference must be initialized when it is declared. It cannot be null or uninitialized.

```cpp
#include <iostream>

int main() {
    int value = 10;
    int& ref = value; // OK: ref is initialized to value

    // int& uninitialized_ref; // Error: references must be initialized
    return 0;
}
```

#### 2. A Reference Cannot Be Reseated
Once a reference is bound to an object, it cannot be changed to refer to another object.

```cpp
#include <iostream>

int main() {
    int n1 = 3;
    int n2 = 6;

    int& ref = n1; // ref is now an alias for n1
    std::cout << "ref refers to n1: " << ref << std::endl; // Prints 3

    ref = n2; // This does NOT re-bind ref to n2.
              // It assigns the value of n2 to the object ref refers to (which is n1).

    std::cout << "n1's value is now: " << n1 << std::endl; // Prints 6
    std::cout << "ref's value is now: " << ref << std::endl; // Prints 6
    std::cout << "n2's value is still: " << n2 << std::endl; // Prints 6
    return 0;
}
```

#### 3. References Are Not Objects
A reference is not an object in its own right; it does not occupy any storage. It is simply an alias. Therefore, a reference has the same memory address as the object it refers to.

```cpp
#include <iostream>

int main() {
    int x = 42;
    int& ref = x;

    // The addresses will be identical.
    std::cout << "Address of x:   " << &x << std::endl;
    std::cout << "Address of ref: " << &ref << std::endl;
    return 0;
}
```

---

There are two primary types of references in modern C++:

-   **lvalue reference** (`&`)
-   **rvalue reference** (`&&`)

---

### Lvalue References

An lvalue reference is the most common type of reference.
It binds to an modifiable lvalue.

There are two kinds of lvalue references: **non-const** and **const**.

#### Non-const Lvalue Reference (`T&`)
A non-const lvalue reference can only bind to a *modifiable* lvalue. You cannot bind it to a `const` object (as that would violate const-correctness) or to an rvalue (a temporary value).

```cpp
int num = 10;
int& ref1 = num; // OK: binds to a modifiable lvalue
ref1 = 20;       // OK: we can modify num through ref1

const int const_num = 30;
// int& ref2 = const_num; // Error: cannot bind non-const reference to a const object

// int& ref3 = 5; // Error: cannot bind non-const reference to an rvalue (a literal)
```

#### Const Lvalue Reference (`const T&`)
A `const` lvalue reference is much more flexible. It can bind to almost anything: modifiable lvalues, non-modifiable lvalues, and rvalues.

**1. Binding to a non-modifiable lvalue:**
This is a common use case for ensuring that a referenced object is not changed.
```cpp
const int x = 5;
const int& ref = x; // OK
```

**2. Binding to a modifiable lvalue:**
The reference cannot be used to change the object, even if the original object is modifiable.
```cpp
#include <iostream>

int main() {
    int x = 5;
    const int& ref = x;

    std::cout << ref << std::endl; // Prints 5
    // ref++; // Error: ref is a const reference, cannot modify the object through it
    x++; // OK: The original object is still modifiable
    std::cout << ref << std::endl; // Prints 6
    return 0;
}
```

**3. Binding to an rvalue (and extending its lifetime):**
When a `const` lvalue reference binds to an rvalue (a temporary), the compiler creates a temporary object and the lifetime of that temporary is extended to match the lifetime of the reference. This is a powerful feature that makes `const` references very useful for function parameters.

```cpp
#include <iostream>

int main() {
    const int& ref = 3; // A temporary int object is created with the value 3.
                        // ref binds to this temporary.
                        // The temporary's lifetime is extended.
    std::cout << ref << std::endl; // Prints 3
    return 0;
} // The temporary object is destroyed here, along with ref.
```

**4. Binding to a different type:**
If the reference and the object have different types, a temporary object is created for the type conversion. The reference binds to this new temporary.

```cpp
#include <iostream>

int main() {
    short num = 3;
    const int& ref = num; // A temporary int is created and initialized with the value of num.
                         // ref is bound to this temporary, NOT to num itself.

    std::cout << "ref = " << ref << std::endl; // Prints 3
    num--;
    std::cout << "num = " << num << std::endl; // Prints 2
    std::cout << "ref = " << ref << std::endl; // Still prints 3, because it's bound to the temporary.
    return 0;
}
```

---

### Rvalue References (`T&&`)

Introduced in C++11, rvalue references bind only to rvalues (temporaries).
They are the key mechanism behind **move semantics** and **perfect forwarding**.
Their primary purpose is to identify objects that can be "stolen from" because they are about to be destroyed.

```cpp
#include <iostream>

int main() {
    int&& rref1 = 5; // OK: 5 is an rvalue
    rref1 = 10;      // We can modify the temporary object
    std::cout << rref1 << std::endl; // Prints 10

    int x = 10;
    // int&& rref2 = x; // Error: cannot bind an rvalue reference to an lvalue (x)

    // However, we can use std::move to cast an lvalue to an rvalue reference
    int&& rref3 = std::move(x);
    return 0;
}
```

---

### Use Case: Function Parameters

References are most frequently used as function parameters.

**1. Pass-by-reference (non-const):** Allows a function to modify the caller's variable.
```cpp
void increment(int& value) {
    value++;
}
```

**2. Pass-by-const-reference:**

The preferred way to pass large objects that you don't want to modify.
It avoids a potentially expensive copy while guaranteeing the object is not changed.

```cpp
#include <string>
#include <iostream>

void print(const std::string& str) {
    std::cout << str << std::endl;
    // str += "!"; // Error: cannot modify through a const reference
}
```

---

### Use Case: Function Return Values

Functions can also return references, but you must be extremely careful.

**Do:** Return a reference to an object that will exist *after* the function returns (e.g., an object passed in as an argument, or a static local variable).


Example:

```cpp
#include <iostream>

int& get_element(int* array, int index) {
    return array[index];
}

int main() {
    int arr[] = {10, 20, 30};
    get_element(arr, 1) = 99; // We get a reference to arr[1] and assign a new value.
    std::cout << arr[1] << std::endl; // Prints 99
    return 0;
}
```

**Don't (Dangling Reference):** Never return a reference to a local variable, because it will be destroyed when the function exits, leaving you with a dangling reference.

```cpp
int& create_value() {
    int local_value = 10;
    return local_value; // DANGER! Returning a reference to a local variable.
}

int main() {
    int& ref = create_value(); // ref is a dangling reference.
    // Accessing ref here is undefined behavior!
    return 0;
}
```

---

### Reference

[1] https://www.learncpp.com/cpp-tutorial