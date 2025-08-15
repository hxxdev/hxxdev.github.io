---
title: C++ Copy Constructor and Static Variable
date: 2025-08-15
categories: [dev, cpp]
tags: [cpp, class, constructor, static]
---

### Call-by-Value vs Call-by-Pointer vs Call-by-Reference

In object-oriented programming, passing objects to functions is a fundamental operation. To write robust C++ code, it's essential to understand what happens when an object is passed as an argument. C++ provides two primary methods for this: "call-by-value" and "call-by-reference."

**Call-by-Value**

By default, C++ uses call-by-value, which means a copy of the argument is created and passed to the function's parameter. When an object is passed this way, a special constructor called the **copy constructor** is invoked to create this duplicate. Any modifications made to the object within the function affect the copy, not the original.

Consider a `Book` class. If we pass a `Book` object to a function to add a bookmark, the change won't be reflected in the original object.

```cpp
#include <iostream>
#include <string>

class Book {
public:
    std::string title;
    int currentPage;

    Book(std::string title) : title(title), currentPage(1) {}

    void readToPage(int page) {
        currentPage = page;
    }
};

// This function receives a COPY of the book
void addBookmark(Book book) {
    book.readToPage(100); // This modifies the copy, not the original
    std::cout << "Bookmark added to '" << book.title << "' at page " << book.currentPage << " (inside function)." << std::endl;
}

int main() {
    Book myBook("The Lord of the Rings");
    std::cout << "Original page: " << myBook.currentPage << std::endl;
    addBookmark(myBook);
    std::cout << "Page after function call: " << myBook.currentPage << std::endl; // Will still be 1
    return 0;
}
```

**Call-by-Reference and Call-by-Pointer**

To modify the original object, we must pass it by reference or by pointer. This avoids creating a copy, which also improves performance by eliminating the overhead of object duplication.

Using a pointer involves passing the object's memory address.

```cpp
void addBookmarkByPointer(Book* bookPtr) {
    bookPtr->readToPage(150); // Modifies the original object
}
```

Using a reference is often safer and syntactically cleaner. A reference acts as an alias for the original object.

```cpp
void addBookmarkByReference(Book& bookRef) {
    bookRef.readToPage(200); // Modifies the original object
}
```

---

### How Functions Return Objects

Functions can also create and return objects. When a function returns an object by value, a temporary copy of the object is created and returned to the caller. Here, too, the copy constructor is typically involved in creating this temporary object.

```cpp
Book createDefaultBook() {
    Book defaultBook("A Brief History of Time");
    return defaultBook; // A copy of defaultBook is returned
}

int main() {
    Book scienceBook = createDefaultBook();
    std::cout << "Created book: " << scienceBook.title << std::endl;
}
```

---

### The Copy Constructor

A copy constructor is a special constructor used to create a new object as a copy of an existing object of the same class. If you don't define one, the C++ compiler provides a default version that performs a member-wise copy of all the object's variables.

The copy constructor is called in three main situations:
1.  When initializing an object with another object of the same class (`Book b2 = b1;`).
2.  When passing an object to a function by value.
3.  When returning an object from a function by value.

The syntax for a copy constructor is `ClassName(const ClassName& other)`. The parameter **must** be a reference (`&`). If it weren't, passing the argument `other` would require making a copy, which would call the copy constructor, leading to an infinite recursive loop.

### The Pitfall of Shallow Copy

For simple classes, the default copy constructor works fine. However, it becomes problematic when a class manages dynamic memory (e.g., using pointers and `new`). The default behavior results in a **shallow copy**, where only the pointer's address is copied, not the underlying data it points to.

This leads to two objects sharing the same block of dynamic memory. When one object's destructor is called, it frees the memory. When the second object's destructor is later called, it attempts to free the *same memory again*, causing a runtime error (a "double free").

Let's illustrate this with a `Notebook` class that dynamically allocates memory for its contents.

```cpp
// Problematic class with shallow copy
class Notebook {
public:
    char* content;
    Notebook(const char* text) {
        content = new char[strlen(text) + 1];
        strcpy(content, text);
    }
    ~Notebook() {
        delete[] content; // Destructor frees memory
    }
};

int main() {
    Notebook original("My secret notes.");
    {
        Notebook copy = original; // Default copy constructor (shallow copy)
    } // 'copy' goes out of scope, its destructor is called, and 'content' is deleted.
    
    // Now 'original' points to deallocated memory, which is a critical bug.
    // The program will crash when 'original' is destroyed at the end of main.
    return 0;
}
```

### Achieving a Deep Copy

The solution is to implement a custom copy constructor that performs a **deep copy**. This involves allocating new memory for the copy and then copying the actual data from the original object.

```cpp
class SafeNotebook {
public:
    char* content;
    SafeNotebook(const char* text) {
        content = new char[strlen(text) + 1];
        strcpy(content, text);
    }

    // Custom copy constructor for deep copy
    SafeNotebook(const SafeNotebook& other) {
        content = new char[strlen(other.content) + 1]; // 1. Allocate new memory
        strcpy(content, other.content);               // 2. Copy the data
    }

    ~SafeNotebook() {
        delete[] content;
    }
};

int main() {
    SafeNotebook original("My secret notes.");
    {
        SafeNotebook copy = original; // Deep copy is performed
    } // 'copy' is safely destroyed. 'original' is unaffected.
    
    return 0; // No crash!
}
```

### Copy Constructor vs. Assignment Operator

It's crucial to distinguish between initialization and assignment.
-   **Initialization** (`Notebook n2 = n1;`) creates a new object and calls the copy constructor.
-   **Assignment** (`n2 = n1;` where `n2` already exists) uses the assignment operator and does not call the constructor.

Like the copy constructor, the default assignment operator also performs a shallow copy, so you may need to overload it as well for classes that manage dynamic memory.

---

### Building Complex Objects with Composition

Object-oriented programming provides two primary ways to reuse code:
1.  **Is-a Relationship (Inheritance):** Where one class is a specialized type of another (e.g., a `Car` is a `Vehicle`).
2.  **Has-a Relationship (Composition):** Where one class contains an object of another class as a member.

Composition allows you to build complex objects from simpler ones. For example, a `Car` class can have an `Engine` object as a member.

```cpp
class Engine {
public:
    int horsepower;
    Engine(int hp = 200) : horsepower(hp) {}
};

class Car {
public:
    std::string model;
    Engine engine; // Car "has-a" Engine

    Car(std::string m) : model(m) {} // Engine's default constructor is called here
};

int main() {
    Car myCar("Mustang");
    std::cout << "My " << myCar.model << " has " << myCar.engine.horsepower << " HP." << std::endl;
}
```

### Sharing Data with Static Members

Sometimes, you need a variable that is shared among all instances of a class. An instance variable (a regular member variable) belongs to a specific object. In contrast, a **static variable** (or class variable) belongs to the class itself, and only one copy exists, regardless of how many objects are created.

This is perfect for tasks like counting the number of objects created.

```cpp
class Spaceship {
public:
    static int totalShipsLaunched; // Declaration of the static variable

    Spaceship() {
        totalShipsLaunched++; // Increment the shared counter
    }
};

// Definition and initialization of the static variable outside the class
int Spaceship::totalShipsLaunched = 0;

int main() {
    std::cout << "Ships launched: " << Spaceship::totalShipsLaunched << std::endl;
    Spaceship s1;
    Spaceship s2;
    std::cout << "Ships launched: " << Spaceship::totalShipsLaunched << std::endl; // Output is 2
}
```

A **static member function** also belongs to the class rather than an object. It can be called directly using the class name (`ClassName::functionName()`) and can only access static member variables. It does not have a `this` pointer because it isn't associated with a specific object instance.

### The Singleton Design Pattern

The **Singleton** is a design pattern that ensures a class has only one instance and provides a global point of access to it. This is useful for managing shared resources like a database connection, a logger, or hardware like a printer.

The pattern is implemented using static members:
1.  Make the constructor `private` to prevent direct instantiation.
2.  Create a `private static` member to hold the single instance.
3.  Provide a `public static` function (often named `getInstance()`) that creates the instance if it doesn't exist yet and returns a reference to it.

```cpp
#include <iostream>
#include <string>

class Logger {
private:
    static Logger* instance;
    Logger() {} // Private constructor

public:
    // Deleted copy constructor and assignment operator to prevent cloning
    Logger(const Logger&) = delete;
    void operator=(const Logger&) = delete;

    static Logger& getInstance() {
        if (instance == nullptr) {
            instance = new Logger();
        }
        return *instance;
    }

    void log(const std::string& message) {
        std::cout << "[LOG]: " << message << std::endl;
    }
};

Logger* Logger::instance = nullptr;

int main() {
    Logger::getInstance().log("Application started.");
    Logger::getInstance().log("An event occurred.");
    
    // Logger& logger1 = Logger::getInstance();
    // Logger& logger2 = Logger::getInstance();
    // They are the same instance.
}
```
