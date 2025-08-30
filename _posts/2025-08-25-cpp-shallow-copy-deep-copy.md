---
title: C++ Shallow Copy vs Deep Copy
date: 2025-08-25
categories: [dev, cpp]
tags: [cpp, shallow-copy, deep-copy]
---

Let's dive deep into **shallow copy** and **deep copy**.

### What is Copying in C++?

In C++, copying occurs when you create a new object from an existing one. This happens in several scenarios:

- **Copy construction**: `MyClass obj2 = obj1;` or `MyClass obj2(obj1);`
- **Assignment**: `obj2 = obj1;` (where `obj2` already exists)
- **Passing objects by value** to functions
- **Returning objects by value** from functions

By default, C++ provides compiler-generated copy constructor and assignment operator that perform member-wise copying.
However, this default behavior can be *problematic* when your class manages resources like dynamic memory.

---

### Shallow Copy: The Default Behavior

A shallow copy duplicates only the immediate members of an object.
For primitive types (int, float, char), this works perfectly.
However, for pointer members, *only the pointer value (memory address) is copied*, not the data it points to.

#### Example of Shallow Copy Problem

```cpp
#include <iostream>
using namespace std;

class ShallowExample {
private:
    int* data;
    int size;

public:
    // Constructor
    ShallowExample(int s) : size(s) {
        data = new int[size];
        for(int i = 0; i < size; i++) {
            data[i] = i * 10;
        }
        cout << "Constructor: Allocated memory at " << data << endl;
    }
    
    // Destructor
    ~ShallowExample() {
        cout << "Destructor: Deleting memory at " << data << endl;
        delete[] data;
    }
    
    // Function to display data
    void display() const {
        cout << "Data at " << data << ": ";
        for(int i = 0; i < size; i++) {
            cout << data[i] << " ";
        }
        cout << endl;
    }
    
    // Function to modify data
    void modify(int index, int value) {
        if(index < size) {
            data[index] = value;
        }
    }
};

int main() {
    cout << "=== Shallow Copy Demonstration ===" << endl;
    
    ShallowExample obj1(3);
    obj1.display();
    
    // This uses compiler-generated shallow copy constructor
    ShallowExample obj2 = obj1;
    obj2.display();
    
    cout << "\nModifying obj1..." << endl;
    obj1.modify(0, 999);
    
    cout << "obj1: ";
    obj1.display();
    cout << "obj2: ";
    obj2.display();  // obj2 is also affected!
    
    cout << "\nProgram ending - destructors will be called..." << endl;
    // CRASH! Double delete will occur
    return 0;
}
```

---

#### Problems with Shallow Copy

1. **Memory Sharing**: Both objects point to the same memory location
2. **Unintended Side Effects**: Modifying one object affects the other
3. **Double Deletion**: Both destructors try to delete the same memory, causing undefined behavior
4. **Dangling Pointers**: If one object is destroyed, the other points to freed memory

---

### Deep Copy: The Safe Solution

A deep copy creates a completely independent copy of an object, including separate copies of any dynamically allocated memory.
This ensures that each object manages its own resources.

#### Implementing Deep Copy

```cpp
#include <iostream>
using namespace std;

class DeepExample {
private:
    int* data;
    int size;

public:
    // Constructor
    DeepExample(int s) : size(s) {
        data = new int[size];
        for(int i = 0; i < size; i++) {
            data[i] = i * 10;
        }
        cout << "Constructor: Allocated memory at " << data << endl;
    }
    
    // Deep Copy Constructor
    DeepExample(const DeepExample& other) : size(other.size) {
        data = new int[size];  // Allocate NEW memory
        for(int i = 0; i < size; i++) {
            data[i] = other.data[i];  // Copy the VALUES
        }
        cout << "Copy Constructor: Allocated new memory at " << data << endl;
    }
    
    // Deep Copy Assignment Operator
    DeepExample& operator=(const DeepExample& other) {
        cout << "Assignment Operator called" << endl;
        
        // Self-assignment check
        if(this == &other) {
            return *this;
        }
        
        // Clean up existing memory
        delete[] data;
        
        // Allocate new memory and copy data
        size = other.size;
        data = new int[size];
        for(int i = 0; i < size; i++) {
            data[i] = other.data[i];
        }
        
        cout << "Assignment: Allocated new memory at " << data << endl;
        return *this;
    }
    
    // Destructor
    ~DeepExample() {
        cout << "Destructor: Deleting memory at " << data << endl;
        delete[] data;
    }
    
    // Function to display data
    void display() const {
        cout << "Data at " << data << ": ";
        for(int i = 0; i < size; i++) {
            cout << data[i] << " ";
        }
        cout << endl;
    }
    
    // Function to modify data
    void modify(int index, int value) {
        if(index < size) {
            data[index] = value;
        }
    }
};

int main() {
    cout << "=== Deep Copy Demonstration ===" << endl;
    
    DeepExample obj1(3);
    obj1.display();
    
    // This uses our custom deep copy constructor
    DeepExample obj2 = obj1;
    obj2.display();
    
    cout << "\nModifying obj1..." << endl;
    obj1.modify(0, 999);
    
    cout << "obj1: ";
    obj1.display();
    cout << "obj2: ";
    obj2.display();  // obj2 is unaffected!
    
    cout << "\nTesting assignment operator..." << endl;
    DeepExample obj3(2);
    obj3 = obj1;  // Uses assignment operator
    obj3.display();
    
    cout << "\nProgram ending safely..." << endl;
    return 0;
}
```

### Memory Layout Comparison

#### Shallow Copy Memory Layout
```
Original Object:
obj1.data → [0x1000] → [0, 10, 20]
obj1.size = 3

After Shallow Copy:
obj1.data → [0x1000] → [0, 10, 20]
obj2.data → [0x1000] → [0, 10, 20]  (Same memory!)
```

#### Deep Copy Memory Layout
```
Original Object:
obj1.data → [0x1000] → [0, 10, 20]
obj1.size = 3

After Deep Copy:
obj1.data → [0x1000] → [0, 10, 20]
obj2.data → [0x2000] → [0, 10, 20]  (Different memory!)
```

---

### The Rule of Three/Five

When your class manages resources (like dynamic memory), you typically need to implement:

**Rule of Three (C++98/03):**
1. **Destructor** - to clean up resources
2. **Copy Constructor** - for proper copying
3. **Copy Assignment Operator** - for proper assignment

**Rule of Five (C++11 and later):**
Adds move semantics:
4. **Move Constructor**
5. **Move Assignment Operator**

---

#### Example with Rule of Five

```cpp
class ModernExample {
private:
    int* data;
    int size;

public:
    // Constructor
    ModernExample(int s) : size(s), data(new int[size]) {
        for(int i = 0; i < size; i++) {
            data[i] = i;
        }
    }
    
    // Destructor
    ~ModernExample() {
        delete[] data;
    }
    
    // Copy Constructor (Deep Copy)
    ModernExample(const ModernExample& other) 
        : size(other.size), data(new int[size]) {
        for(int i = 0; i < size; i++) {
            data[i] = other.data[i];
        }
    }
    
    // Copy Assignment Operator (Deep Copy)
    ModernExample& operator=(const ModernExample& other) {
        if(this != &other) {
            delete[] data;
            size = other.size;
            data = new int[size];
            for(int i = 0; i < size; i++) {
                data[i] = other.data[i];
            }
        }
        return *this;
    }
    
    // Move Constructor (C++11)
    ModernExample(ModernExample&& other) noexcept
        : size(other.size), data(other.data) {
        other.data = nullptr;
        other.size = 0;
    }
    
    // Move Assignment Operator (C++11)
    ModernExample& operator=(ModernExample&& other) noexcept {
        if(this != &other) {
            delete[] data;
            data = other.data;
            size = other.size;
            other.data = nullptr;
            other.size = 0;
        }
        return *this;
    }
};
```

---

### Modern C++ Alternatives

While understanding shallow vs deep copy is important, modern C++ provides better alternatives:

#### Using Smart Pointers

```cpp
#include <memory>
#include <vector>

class SmartExample {
private:
    std::unique_ptr<int[]> data;
    int size;

public:
    SmartExample(int s) : size(s), data(std::make_unique<int[]>(s)) {
        for(int i = 0; i < size; i++) {
            data[i] = i;
        }
    }
    
    // Custom copy constructor still needed for deep copy behavior
    SmartExample(const SmartExample& other) 
        : size(other.size), data(std::make_unique<int[]>(size)) {
        for(int i = 0; i < size; i++) {
            data[i] = other.data[i];
        }
    }
    
    // Assignment operator
    SmartExample& operator=(const SmartExample& other) {
        if(this != &other) {
            size = other.size;
            data = std::make_unique<int[]>(size);
            for(int i = 0; i < size; i++) {
                data[i] = other.data[i];
            }
        }
        return *this;
    }
    
    // No explicit destructor needed - unique_ptr handles cleanup
};
```

---

#### Using Standard Containers

```cpp
#include <vector>

class VectorExample {
private:
    std::vector<int> data;

public:
    VectorExample(int size) : data(size) {
        for(int i = 0; i < size; i++) {
            data[i] = i;
        }
    }
    
    // No need to implement copy constructor, assignment, or destructor
    // std::vector handles deep copying automatically!
    
    void modify(int index, int value) {
        if(index < data.size()) {
            data[index] = value;
        }
    }
    
    void display() const {
        for(int value : data) {
            std::cout << value << " ";
        }
        std::cout << std::endl;
    }
};
```

---

### When to Disable Copying

Sometimes you don't want objects to be copyable at all. You can explicitly disable copying:

```cpp
class NonCopyable {
private:
    int* data;

public:
    NonCopyable(int size) : data(new int[size]) {}
    ~NonCopyable() { delete[] data; }
    
    // Disable copy constructor and assignment
    NonCopyable(const NonCopyable&) = delete;
    NonCopyable& operator=(const NonCopyable&) = delete;
    
    // Allow move operations
    NonCopyable(NonCopyable&&) noexcept = default;
    NonCopyable& operator=(NonCopyable&&) noexcept = default;
};
```

---

### Summary

1. **Understand the difference**: Shallow copy shares memory, deep copy creates independent copies
2. **Follow the Rule of Three/Five**: If you need custom destructor, you probably need custom copy operations
3. **Prefer modern alternatives**: Use `std::vector`, `std::unique_ptr`, or `std::shared_ptr` instead of raw pointers
4. **Be explicit**: If copying should be disabled, use `= delete`
5. **Consider move semantics**: For performance, implement move operations in C++11 and later
6. **Test your copy operations**: Always test that copies work independently

