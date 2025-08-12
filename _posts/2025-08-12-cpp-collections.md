--- 
title: C++ STL(Standard Template Library)
date: 2025-08-12
categories: [dev, cpp]
tags: [cpp, stl, vector, array, collections]
---

### Collections of Objects

This section explores various ways to manage collections of objects in C++, from traditional C-style arrays to modern C++ Standard Library containers.

---

#### C-Style Object Arrays (The "Old Way")

Often, we need to create many objects of the same type. For example, a game might need hundreds of `Enemy` objects. Creating individual variables for each one is not feasible.

Like with basic types (e.g., `int`), we can create an array of objects. This is a fixed-size container where each element is an object of our class.

**Declaration:** `ClassName arrayName[size];`

```cpp
#include <iostream>
#include <string>

class Book {
public:
    // Default constructor is required for simple array declaration
    Book() : title{"Untitled"}, pages{0} {
        std::cout << "Default Book created.\n";
    }

    Book(std::string t, int p) : title{t}, pages{p} {
        std::cout << "Book '" << title << "' created.\n";
    }

    void print() const {
        std::cout << "Title: " << title << ", Pages: " << pages << std::endl;
    }

    // Added for sorting examples
    std::string getTitle() const { return title; }
    int getPages() const { return pages; }

private:
    std::string title;
    int pages;
};
```


---

#### Using C-Style Object Arrays

When you declare a simple object array like `Book library[3];`, the **default constructor** is called for each of the 3 elements.

To access a specific object in the array, you use the index operator `[]`. You can then call its member functions using the dot `.` operator.

```cpp
#include <iostream>
#include <string> // Required for Book class

// Assuming Book class is defined above

int main() {
    Book library[3] = {
        Book("The Hobbit", 295),
        Book("Dale", 333)
    }; // Calls the default constructor for library[2] and copy-constructs for others

    for (int i = 0; i < 3; ++i) { // Loop through all 3 elements
        library[i].print();
    }
    return 0;
}
```

While this works, it still suffers from the core limitations of C-style arrays.

**Limitations of C-style arrays:**
- **Fixed Size:** The size is set at compile time and cannot be changed.
- **No Size Information:** The array itself doesn't know its own size. You must track it manually.
- **No Helper Functions:** They lack useful container operations.

For these reasons, C-style arrays are largely replaced by modern C++ containers.

Let's move on to the modern solution.


---

#### `std::vector`: The Modern Dynamic Array

The `std::vector` is the most common and versatile container in the C++ Standard Template Library (STL). It represents a **dynamic array**, meaning it can grow and shrink in size at runtime as you add or remove elements.

- It automatically manages its own memory.
- It provides a rich set of member functions for manipulation.
- It works seamlessly with STL algorithms.

To use `std::vector`, you must include the `<vector>` header. Since it's a template, you must specify the type of data it will hold in angle brackets: `std::vector<DataType>`.

```cpp
#include <vector>
#include <string>

// Using our Book class from before

int main() {
    // Create an empty vector that can hold Book objects
    std::vector<Book> bookCollection;
}
```


---

#### `std::vector`: Adding and Accessing Elements

The most common way to add elements is with `push_back()`, which adds an element to the end of the vector.

A more efficient method is `emplace_back()`, which constructs the object directly in the vector's memory, avoiding a temporary copy.

To access elements, you can use `[]` or the `.at()` member function. `.at()` is safer because it checks if the index is valid and throws an exception if it's out of bounds.

#include <iostream>
#include <vector>
#include <string> // Required for Book class

// Assuming Book class is defined above

int main() {
    std::vector<Book> collection;
    std::cout << "Building collection...\n";

    // Add elements
    collection.push_back({"1984", 328}); // Creates a temporary Book, then copies it in
    collection.emplace_back("Brave New World", 311); // Constructs the Book in-place (more efficient)

    std::cout << "\nAccessing elements...\n";
    collection[0].print();
    collection.at(1).print();

    // collection.at(2).print(); // This would throw an exception and terminate
    return 0;
}



There are three primary ways to loop through the elements of a vector.

**1. Range-Based `for` Loop (Preferred for simplicity)**
This is the cleanest and most modern way to iterate through an entire container.
```cpp
std::cout << "--- Range-Based Loop ---\n";
for (const auto& book : collection) { // Use const& to avoid copying each book
    book.print();
}
```

**2. Index-Based `for` Loop**
This is useful if you need the index of the element.
```cpp
std::cout << "--- Index-Based Loop ---\n";
for (size_t i = 0; i < collection.size(); ++i) {
    collection[i].print();
}
```

**3. Iterator-Based `for` Loop**
This is the most powerful method and is required for many STL algorithms. An **iterator** is an object that acts like a pointer to an element.
```cpp
std::cout << "--- Iterator-Based Loop ---\n";
for (auto it = collection.begin(); it != collection.end(); ++it) {
    it->print();
}
```


---

#### `std::vector`: Size vs. Capacity

A vector has two different concepts of size:

-   **`size()`**: The number of elements currently stored in the vector.
-   **`capacity()`**: The number of elements the vector can hold *before it must reallocate a new, larger block of memory*. When a vector runs out of capacity, it finds a new, larger memory block (often double the size), copies all existing elements over, and then adds the new one. This can be inefficient.

You can use `reserve()` to pre-allocate capacity if you know roughly how many elements you'll need, avoiding reallocations.

```cpp
#include <iostream>
#include <vector>

int main() {
    std::vector<int> numbers;
    std::cout << "Size: " << numbers.size() << ", Capacity: " << numbers.capacity() << std::endl;

    numbers.reserve(10); // Pre-allocate space for 10 integers
    std::cout << "Size: " << numbers.size() << ", Capacity: " << numbers.capacity() << std::endl;

    for(int i=0; i<10; ++i) numbers.push_back(i);
    std::cout << "Size: " << numbers.size() << ", Capacity: " << numbers.capacity() << std::endl;

    numbers.push_back(10); // Exceeds capacity, triggers reallocation
    std::cout << "Size: " << numbers.size() << ", Capacity: " << numbers.capacity() << std::endl;
    return 0;
}
```


---

#### `std::vector`: Modifying and Using Algorithms

Vectors provide member functions like `erase()`, `insert()`, and `clear()` for modification.

A major advantage of using STL containers like `vector` is their compatibility with the powerful algorithms in the `<algorithm>` header.

Let's sort our book collection by title using `std::sort` and a lambda expression.

#include <iostream>
#include <vector>
#include <string>
#include <algorithm> // Required for std::sort

// Assuming Book class is defined above with getTitle()

int main() {
    std::vector<Book> collection;
    collection.emplace_back("The Lord of the Rings", 1178);
    collection.emplace_back("Dune", 412);
    collection.emplace_back("A Game of Thrones", 694);

    // Use a lambda function to define the sorting rule
    std::sort(collection.begin(), collection.end(), 
        [](const Book& a, const Book& b) {
            return a.getTitle() < b.getTitle(); // Sort alphabetically by title
        });

    std::cout << "\n--- Sorted Collection ---\n";
    for (const auto& book : collection) {
        book.print();
    }
    return 0;
}



---

#### `std::array`: The Modern Fixed-Size Array

What if you need a fixed-size array but want the benefits of a modern container? C++11 introduced `std::array` for this exact purpose.

`std::array` is a container that encapsulates a fixed-size C-style array.

-   **Performance:** It has the same minimal memory overhead and performance as a C-style array.
-   **Convenience:** It provides member functions like `.size()`, `.at()`, `.front()`, `.back()` and supports iterators, making it compatible with STL algorithms.
-   **Safety:** It knows its own size, preventing common errors.

To use it, include the `<array>` header. The size is part of the type definition: `std::array<DataType, Size>`.


---

#### Using `std::array`

`std::array` is ideal when you know the collection size at compile time and it will never change.

#include <array>
#include <algorithm>

// ... Book class ...

int main() {
    // The size (3) is part of the type
    std::array<Book, 3> bookshelf = {
        Book {"Fahrenheit 451", 249},
        Book {"The Martian", 369},
        Book {"Project Hail Mary", 496}
    };

    std::cout << "Bookshelf size: " << bookshelf.size() << std::endl;

    // We can still use algorithms like sort!
    std::sort(bookshelf.begin(), bookshelf.end(),
        [](const Book& a, const Book& b) {
            return a.getPages() > b.getPages(); // Sort by pages, descending
        });

    std::cout << "\n--- Sorted Bookshelf ---
";
    for (const auto& book : bookshelf) {
        book.print();
    }
}



---

#### TL;DR

Choosing the right container is a key skill in C++.

-   **`std::vector`**: **This should be your default choice.** Its ability to grow dynamically is suitable for the vast majority of use cases where the number of elements is not known at compile time.

-   **`std::array`**: Use this when you know the size of the collection at compile time, the size will **never** change, and you need the absolute best performance (e.g., for small, performance-critical data structures).

-   **C-Style Array (`T[]`)**: **Avoid in modern C++.** There is almost no reason to prefer a C-style array over `std::array` or `std::vector`. The modern containers are safer, more convenient, and just as performant in the case of `std::array`.
