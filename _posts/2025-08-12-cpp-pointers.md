---
title: C++ Pointers
date: 2025-08-12
categories: [dev, cpp]
tags: [cpp, pointers, smart pointers, stack, heap]
---

### C++ Pointers

Welcome to this guide on C++ pointers. Pointers are one of the most powerful and sometimes feared features of C++.
They allow for direct memory manipulation, dynamic memory allocation, and efficient handling of complex data structures.
A deep understanding of pointers, memory management, and modern C++ practices like smart pointers is crucial for any serious C++ developer.

This blog post will demystify pointers and cover the following topics:

*   Direct vs. Indirect Reference
*   Declaring and Initializing Pointers
*   Stack vs. Heap Memory
*   Dynamic Memory with `new` and `delete`
*   The Dangers of Raw Pointers
*   Modern Memory Management with Smart Pointers (`unique_ptr`, `shared_ptr`, `weak_ptr`)
*   Advanced Memory Layouts with Classes and Pointers
*   The `this` Pointer
*   `const` Correctness with Pointers
*   Pointer Variables vs. Pointer Constants (Array Names)
*   The Size of Pointer Variables

Let's get started!

#### Direct vs. Indirect Reference

In C++, you can access the value of a variable in two ways: directly or indirectly.

**Direct Reference:** This is the most common way. You simply use the variable's name.

```cpp
#include <iostream>

int main() {
    int direct_value = 100;
    std::cout << "Accessing value directly: " << direct_value << std::endl; // Outputs 100
    return 0;
}
```

**Indirect Reference:** This involves using a pointer. A pointer holds the memory address of another variable. You get this address using the address-of operator (`&`). To get the value stored at that address, you "dereference" the pointer using the indirection operator (`*`).

```cpp
#include <iostream>

int main() {
    int value = 200;
    int* pointer_to_value = &value; // Pointer holds the address of 'value'

    std::cout << "Memory address of value: " << pointer_to_value << std::endl;
    std::cout << "Accessing value indirectly: " << *pointer_to_value << std::endl; // Outputs 200

    // You can also modify the original variable's value through the pointer
    *pointer_to_value = 250;
    std::cout << "New value of 'value': " << value << std::endl; // Outputs 250
    return 0;
}
```

---

#### Declaring and Initializing Pointers

Declaring a pointer is similar to declaring a regular variable, but with an asterisk `*` between the data type and the variable name.

**Syntax:**
`dataType *pointerName;`

It is crucial that the pointer's data type matches the type of the variable it points to.

```cpp
int* p_int;         // A pointer to an integer
double* p_double;   // A pointer to a double
char* p_char;       // A pointer to a character

int i = 10;
double d = 3.14;

p_int = &i; // Correct
// p_int = &d; // ERROR: cannot assign a 'double*' to an 'int*'
```

An uninitialized pointer holds a garbage address and is dangerous. Pointing it to a known address or setting it to `nullptr` is essential before use. The `nullptr` keyword, introduced in C++11, provides a type-safe null pointer, preventing ambiguities that existed with the older `NULL` macro.

```cpp
int* p_safe_int = nullptr; // Good practice: always initialize pointers

if (p_safe_int) {
    // This code will not execute
    std::cout << *p_safe_int << std::endl;
}
```

---

#### Stack vs. Heap Memory

To understand dynamic memory allocation, you must know the two main memory regions: the stack and the heap.

##### The Stack

The stack stores local variables and function call information. It's fast, organized, and memory is managed automatically.

*   **Memory Allocation:** Automatic. The compiler manages allocation and deallocation.
*   **Lifecycle:** Memory is allocated when a variable comes into scope and deallocated when it goes out of scope (LIFO - Last-In, First-Out).
*   **Speed:** Very fast due to its simple, predictable structure.
*   **Size:** Relatively small and fixed. Exceeding it causes a "stack overflow."

```cpp
void myFunction() {
    int stack_variable = 50; // This variable is on the stack
} // stack_variable is automatically destroyed here
```

##### The Heap

The heap is a large pool of memory for dynamic allocation. You, the programmer, are in control.

*   **Memory Allocation:** Manual. You allocate memory using `new` and must deallocate it using `delete`.
*   **Lifecycle:** Memory persists until it is explicitly deallocated.
*   **Speed:** Slower than the stack due to more complex memory management.
*   **Size:** Much larger than the stack, limited by available system memory.

```plantuml
rectangle "Program Memory Layout" {
  rectangle "Code Area" as code_area
  rectangle "Data Area (Globals/Statics)" as data_area
  rectangle "Heap Area" as heap_area
  rectangle "Stack Area" as stack_area
  
  stack_area --[hidden]- heap_area
  heap_area --[hidden]- data_area
  data_area --[hidden]- code_area
  
  note right of data_area : Global variables, Static variables
  note right of heap_area : Grows upwards. For dynamic allocation
(new, malloc). Managed by the programmer.
  note right of stack_area : Grows downwards. For local variables,
function parameters. Managed by the compiler.
}
```

---

#### Dynamic Memory with `new` and `delete`

Dynamic memory allocation allows your program to request memory at runtime.

##### Single Objects
Use `new` to create an object on the heap and `delete` to destroy it.

```cpp
// Allocate an integer on the heap
int* p_heap_int = new int(150); 

std::cout << *p_heap_int << std::endl; // Outputs 150

// Deallocate the memory to prevent a memory leak
delete p_heap_int;
p_heap_int = nullptr; // Best practice
```

##### Arrays
For arrays, use `new type[size]` and `delete[]`. Mismatching `delete` and `delete[]` leads to undefined behavior.

```cpp
#include <iostream>
#include <cstdlib>
#include <ctime>

int main() {
    // Create a dynamic array of 10 integers
    int* p_array = new int[10];

    // Fill it with random numbers
    srand(time(0));
    for (int i = 0; i < 10; ++i) {
        p_array[i] = rand() % 100;
        std::cout << p_array[i] << " ";
    }
    std::cout << std::endl;

    // CRITICAL: Use delete[] for arrays
    delete[] p_array;
    p_array = nullptr;

    return 0;
}
```

Forgetting to `delete` allocated memory causes a **memory leak**. The program loses the pointer to the heap memory, making it impossible to free, and that memory remains unusable for the program's duration.

---

### Modern C++: Smart Pointers

Manual memory management with `new` and `delete` is error-prone. C++ provides **smart pointers** in the `<memory>` header to automate this process, ensuring that memory is deallocated correctly when the pointer goes out of scope. This principle is called RAII (Resource Acquisition Is Initialization).

#### `std::unique_ptr`
A `unique_ptr` provides exclusive ownership of a heap-allocated object. It's lightweight and has virtually no performance overhead compared to a raw pointer.

*   Only one `unique_ptr` can point to an object at any time.
*   You cannot copy a `unique_ptr`, but you can move it using `std::move()`.
*   The memory is automatically freed when the `unique_ptr` is destroyed.

#include <iostream>
#include <memory>

class Dog {
public:
    Dog() { std::cout << "Dog created\n"; } 
    ~Dog() { std::cout << "Dog destroyed\n"; } 
    void bark() { std::cout << "Woof!\n"; } 
};

int main() {
    // Create a Dog object on the heap owned by a unique_ptr
    std::unique_ptr<Dog> p_dog = std::make_unique<Dog>();
    p_dog->bark();

    // This design choice, where only one `unique_ptr` can own an object at a time,
    // simplifies memory management by preventing ambiguous ownership.
    // While you cannot copy a `unique_ptr` (which would imply shared ownership), 
    // its ownership can be transferred to another `unique_ptr` using `std::move()`.
    std::unique_ptr<Dog> p_dog_moved = std::move(p_dog); // Ownership transferred to p_dog_moved

    // p_dog is now null and no longer owns the Dog object.
    // p_dog->bark(); // This would cause a runtime error!

    p_dog_moved->bark(); // p_dog_moved now owns and can access the Dog object.

    // No need to call delete. The Dog is automatically destroyed when p_dog_moved goes out of scope.
    return 0; // "Dog destroyed" is printed here
}


#### `std::shared_ptr`
A `shared_ptr` allows multiple pointers to share ownership of a heap-allocated object. It maintains a reference count to track how many `shared_ptr`s are pointing to the object.

*   The object is destroyed only when the last `shared_ptr` owning it is destroyed.
*   Useful when an object's lifetime needs to be managed by multiple, non-hierarchical owners.

**`std::make_shared` vs. Direct `new`**

It is highly recommended to use `std::make_shared` to create `shared_ptr`s instead of directly using `new` and then passing the raw pointer to the `shared_ptr` constructor.

1.  **Efficiency (Single Allocation):** `std::make_shared` performs a single memory allocation for both the object and the `shared_ptr`'s control block (which holds the reference count). When you use `new` directly, it typically involves two separate allocations, leading to potential performance overhead and increased memory fragmentation.

2.  **Exception Safety:** Consider `function(std::shared_ptr<T>(new T()), some_other_function())`. If `some_other_function()` throws an exception after `new T()` but before the `std::shared_ptr` constructor is called, the memory allocated for `T` will leak because no `shared_ptr` ever took ownership. `std::make_shared` avoids this by ensuring the object and its control block are constructed atomically.

```cpp
#include <iostream>
#include <memory>

class Project {
public:
    ~Project() { std::cout << "Project finished.\n"; } // Note: Destructors in C++ should not print directly. This is for demonstration.
};

class Employee {
public:
    std::shared_ptr<Project> p_project;
    Employee(std::shared_ptr<Project> project) : p_project(project) {}
};

int main() {
    std::shared_ptr<Project> p_shared_project = std::make_shared<Project>();
    std::cout << "Reference count: " << p_shared_project.use_count() << std::endl; // 1

    {
        Employee e1(p_shared_project);
        Employee e2(p_shared_project);
        std::cout << "Reference count: " << p_shared_project.use_count() << std::endl; // 3
    } // e1 and e2 are destroyed, their shared_ptr copies are gone

    std::cout << "Reference count: " << p_shared_project.use_count() << std::endl; // 1

    return 0; // Last shared_ptr is destroyed, "Project finished." is printed
}
```


#### `std::weak_ptr`
A `std::weak_ptr` is a non-owning, "weak" reference to an object managed by a `std::shared_ptr`. It allows you to observe an object without affecting its lifetime.

*   It does not increase the reference count of the `shared_ptr`.
*   It is used to break circular dependency patterns that can occur with `std::shared_ptr`.
*   To access the underlying object, you must convert the `weak_ptr` to a `shared_ptr` using the `lock()` method. This is a safe way to check if the object still exists before trying to access it.

**Circular References: A Dangerous Problem**

A circular reference occurs when two or more objects hold `shared_ptr`s to each other. Because their reference counts will never drop to zero, they will never be deallocated, causing a memory leak.

Here's an example of the problem:

```cpp
#include <iostream>
#include <memory>

class Person; // Forward declaration

class Apartment {
public:
    std::shared_ptr<Person> tenant;
    ~Apartment() { std::cout << "Apartment destroyed.\n"; } // Note: Destructors in C++ should not print directly. This is for demonstration.
};

class Person {
public:
    std::shared_ptr<Apartment> apartment;
    ~Person() { std::cout << "Person destroyed.\n"; } // Note: Destructors in C++ should not print directly. This is for demonstration.
};

int main() {
    std::shared_ptr<Apartment> p_apt = std::make_shared<Apartment>();
    std::shared_ptr<Person> p_person = std::make_shared<Person>();

    // Create a circular reference
    p_apt->tenant = p_person;
    p_person->apartment = p_apt;

    // Both p_apt and p_person go out of scope here.
    // However, the objects they point to are not destroyed!
    // The Apartment holds a shared_ptr to the Person, and the Person holds one to the Apartment.
    // Their reference counts are both 1.
    return 0; // MEMORY LEAK: Neither destructor is called.
}
```

**Solving Circular References with `std::weak_ptr`**

To fix this, one of the objects should hold a `weak_ptr` instead of a `shared_ptr`. This breaks the cycle of ownership.

```cpp
#include <iostream>
#include <memory>

class Person; // Forward declaration

class Apartment {
public:
    // The tenant doesn't own the apartment, so a weak_ptr is appropriate.
    std::weak_ptr<Person> tenant;
    ~Apartment() { std::cout << "Apartment destroyed.\n"; } // Note: Destructors in C++ should not print directly. This is for demonstration.
};

class Person {
public:
    std::shared_ptr<Apartment> apartment;
    ~Person() { std::cout << "Person destroyed.\n"; } // Note: Destructors in C++ should not print directly. This is for demonstration.
};

int main() {
    std::shared_ptr<Apartment> p_apt = std::make_shared<Apartment>();
    std::shared_ptr<Person> p_person = std::make_shared<Person>();

    p_apt->tenant = p_person; // The weak_ptr does not increase the ref count
    p_person->apartment = p_apt;

    // Now, when main ends, the Person's ref count is not increased by p_apt->tenant.
    // The p_person shared_ptr is destroyed, Person's ref count becomes 0, and the Person object is destroyed.
    // This in turn destroys the Person's apartment member, which was the last shared_ptr to the Apartment.
    // The Apartment's ref count becomes 0, and it is destroyed.
    return 0; // "Person destroyed." and "Apartment destroyed." are printed. No leak.
}
```

---

### Advanced Memory Layout: Classes and Pointers
```

Understanding where objects and their data live is key.

#### Scenario 1: Stack-allocated object with a heap-allocated member

Consider a class where a member variable is a pointer to dynamically allocated memory.

```cpp
class DataHolder {
    int* p_data;
public:
    DataHolder() {
        p_data = new int[50]; // Allocate memory on the heap
        std::cout << "DataHolder created, member allocated on heap.\n";
    }
    ~DataHolder() {
        delete[] p_data; // CRUCIAL: free the heap memory
        std::cout << "DataHolder destroyed, member deallocated from heap.\n";
    }
};

int main() {
    DataHolder holder; // 'holder' object is created on the stack
    return 0;
}
```
**Memory Layout:**
*   The `DataHolder` object `holder` itself resides on the **stack**.
*   The member `holder.p_data` (a pointer) is part of the `holder` object, so it is also on the **stack**.
*   The large array of 50 integers allocated by `new int[50]` resides on the **heap**. The `p_data` pointer on the stack holds the address of this heap memory block.

#### Scenario 2: Heap-allocated object with a heap-allocated member

Now let's allocate the `DataHolder` object itself on the heap.

```cpp
int main() {
    // p_holder pointer is on the stack
    DataHolder* p_holder = new DataHolder(); // DataHolder object is on the heap
    
    delete p_holder; // Manually delete the heap object
    return 0;
}
```
**Memory Layout:**
*   The pointer `p_holder` is a local variable, so it lives on the **stack**.
*   The `DataHolder` object it points to is on the **heap** (created by `new DataHolder()`).
*   The member `p_data` (the pointer *inside* the `DataHolder` object) resides with its object on the **heap**.
*   The integer array that `p_data` points to is in a *separate* block of memory, also on the **heap**.

---

### The `this` Pointer

Every member function of a class has a hidden parameter: the `this` pointer.
`this` holds the **address of the object** on which the member function was called.
It's useful for distinguishing between member variables and parameters, and for returning a reference to the current object.

```cpp
class Box {
    double length;
public:
    Box(double length) {
        this->length = length; // 'this->length' is the member, 'length' is the parameter
    }

    Box& setLength(double new_length) {
        this->length = new_length;
        return *this; // Return a reference to the current object to chain calls
    }
};
```

---

### `const` Correctness with Pointers

The `const` keyword can be used with pointers in several ways, and its position matters.

1.  **Pointer to a Constant Value:** You cannot change the value through the pointer.
    ```cpp
    const int val = 10;
    const int* p1 = &val;
    // *p1 = 20; // ERROR: p1 points to a constant value
    int val2 = 30;
    p1 = &val2; // OK: The pointer itself can be changed
    ```

2.  **Constant Pointer:** The pointer itself cannot be changed to point to another address, but the value it points to can be modified.
    ```cpp
    int val = 10;
    int* const p2 = &val;
    *p2 = 20; // OK: The value can be changed
    int val2 = 30;
    // p2 = &val2; // ERROR: p2 is a constant pointer
    ```

3.  **Constant Pointer to a Constant Value:** Neither the pointer nor the value it points to can be changed.
    ```cpp
    int val = 10;
    const int* const p3 = &val;
    // *p3 = 20; // ERROR
    // p3 = &val2; // ERROR
    ```

---

#### Pointer Variables vs. Pointer Constants (Array Names)

A regular pointer is a **variable** that stores an address. You can reassign it.
An array's name acts as a **constant pointer** to its first element. You cannot reassign it.

```cpp
int my_array[3] = {5, 10, 15};
int another_var = 25;

// my_array points to the first element, &my_array[0]
std::cout << *my_array << std::endl; // Outputs 5

// The following line will cause a compilation error
// my_array = &another_var; // ILLEGAL!
```

---

#### The Size of Pointer Variables

The size of a pointer depends on the system's architecture, not the data type it points to. Its job is to hold a memory address, and the size of an address is fixed for a given architecture.

*   On a **32-bit system**, a pointer is 4 bytes.
*   On a **64-bit system**, a pointer is 8 bytes.

```cpp
#include <iostream>

int main() {
    std::cout << "Size of int pointer: " << sizeof(int*) << " bytes" << std::endl;
    std::cout << "Size of double pointer: " << sizeof(double*) << " bytes" << std::endl;
    std::cout << "Size of char pointer: " << sizeof(char*) << " bytes" << std::endl;
    return 0;
}
```
On a 64-bit system, this will output 8 for all lines.

---

#### Conclusion

Pointers are a fundamental concept in C++. They provide a way to work directly with memory, which is essential for high-performance applications, dynamic data structures, and low-level programming. While raw pointers require careful handling, modern C++ offers powerful tools like smart pointers (`unique_ptr`, `shared_ptr`, and `weak_ptr`) that eliminate most of the risks associated with manual memory management. By mastering both the underlying concepts and the modern tools, you will become a much more effective and confident C++ programmer.

```
