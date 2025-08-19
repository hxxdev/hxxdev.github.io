---
title: C++ Polymorphism
date: 2025-08-20
categories: [dev, cpp]
tags: [cpp, class, polymorphism]
---

### The Concept of Polymorphism

In object-oriented programming, **polymorphism** (from Greek, meaning "many forms") is the ability to present the same interface for differing underlying data types. It allows a single symbol or function name to represent different operations in different contexts.

In C++, polymorphism can be categorized into:
1.  **Compile-time (Static) Polymorphism**: This is achieved through function overloading and operator overloading. The compiler determines which function to call at compile time based on the function's signature.
2.  **Run-time (Dynamic) Polymorphism**: This is achieved using **virtual functions**. It allows the program to decide at runtime which function to call based on the actual type of the object being referred to, not just the type of the pointer or reference. This chapter focuses on run-time polymorphism.

Run-time polymorphism means that even if you send the exact same message (i.e., call the same function) to different objects, they can respond in different ways. For instance, if you have a collection of different `Shape` objects (like `Circle`, `Square`, `Triangle`) and you call a `draw()` method on each, every shape will draw itself correctly. The calling code doesn't need to know the specific type of shape it's dealing with.

### Upcasting: The Foundation of Polymorphism

Dynamic polymorphism is primarily achieved through base class pointers or references. A key principle that enables this is **upcasting**: the ability to treat a derived class object as if it were a base class object.

This means you can use a base class pointer to point to a derived class object.

```cpp
class Animal { /* ... */ };
class Dog : public Animal { /* ... */ };
class Cat : public Animal { /* ... */ };

Dog myDog;
Animal* pAnimal = &myDog; // This is upcasting. It's perfectly valid.
```

**Why does this work?** Because a derived class object contains a complete base class sub-object within it. A `Dog` **is an** `Animal`. Therefore, a pointer to an `Animal` can safely point to the `Animal` part of a `Dog` object.

When you use a base class pointer to access members, you can only access the members that are defined in the base class. You cannot access members that are specific to the derived class, even if the pointer is currently pointing to a derived class object.

### Virtual Functions and Dynamic Binding

By default, C++ uses **static binding** (or early binding). This means that when you call a function through a base class pointer, the compiler binds the call to the base class's version of the function.

```cpp
#include <iostream>

class Character {
public:
    void attack() {
        std::cout << "A character attacks." << std::endl;
    }
};

class Knight : public Character {
public:
    void attack() {
        std::cout << "The knight swings a sword!" << std::endl;
    }
};

int main() {
    Knight arthur;
    Character* pCharacter = &arthur;

    pCharacter->attack(); // Outputs: "A character attacks."
    
    return 0;
}
```
This isn't true polymorphism. To achieve dynamic behavior, we need **dynamic binding** (or late binding). This is enabled by declaring the base class function with the `virtual` keyword.

A **virtual function** is a member function that you expect to be redefined in derived classes. When you refer to a derived class object using a pointer or a reference to the base class, you can call a virtual function for that object and execute the derived class's version of the function.

```cpp
#include <iostream>

class Character {
public:
    // Declare the function as virtual
    virtual void attack() {
        std::cout << "A character attacks." << std::endl;
    }
};

class Knight : public Character {
public:
    // This function is automatically virtual
    void attack() override { // 'override' is good practice
        std::cout << "The knight swings a sword!" << std::endl;
    }
};

int main() {
    Knight arthur;
    Character* pCharacter = &arthur;

    // Dynamic binding: The actual object type (Knight) is determined at runtime
    pCharacter->attack(); // Outputs: "The knight swings a sword!"
    
    return 0;
}
```
Now, the call `pCharacter->attack()` is resolved at runtime. The program checks the actual type of the object `pCharacter` points to and calls the appropriate `attack` method.

### Virtual Destructors

If you are using polymorphism, you must declare the destructor in the base class as `virtual`.

Consider this scenario:
```cpp
Character* pCharacter = new Knight();
delete pCharacter; // Problem here!
```
If the `Character` destructor is not virtual, `delete pCharacter` will only call the `Character` destructor. The `Knight` destructor will not be called, leading to a resource leak if the `Knight` class manages any resources.

By making the base class destructor virtual, you ensure that when you `delete` a derived object through a base pointer, the derived class's destructor is called first, followed by the base class's destructor, ensuring proper cleanup.

```cpp
class Character {
public:
    virtual ~Character() { // Virtual destructor
        std::cout << "Character destroyed." << std::endl;
    }
    // ...
};

class Knight : public Character {
public:
    ~Knight() override {
        std::cout << "Knight destroyed." << std::endl;
    }
    // ...
};
```

### Pure Virtual Functions and Abstract Classes

Sometimes, a base class cannot provide a meaningful implementation for a function. For example, what would a generic `Shape::draw()` method do? You can't draw a "shape" without knowing if it's a circle or a square.

In these cases, you can create a **pure virtual function** by assigning `= 0` to its declaration:

```cpp
class Shape {
public:
    // Pure virtual function
    virtual void draw() const = 0;
    
    virtual ~Shape() {} // Always provide a virtual destructor
};
```
A class that contains one or more pure virtual functions is called an **abstract class**. You cannot create an instance of an abstract class.

```cpp
Shape myShape; // ERROR: Cannot instantiate abstract class
```

The purpose of an abstract class is to serve as an interface. Any class that inherits from an abstract class **must** implement all of its pure virtual functions, or it too will become an abstract class.

```cpp
class Circle : public Shape {
private:
    double radius;
public:
    Circle(double r) : radius(r) {}

    // Provide implementation for the pure virtual function
    void draw() const override {
        std::cout << "Drawing a circle with radius " << radius << std::endl;
    }
};

int main() {
    // Shape* pShape = new Shape(); // Still an error
    Shape* pCircle = new Circle(5.0); // OK
    
    pCircle->draw(); // Calls Circle::draw()
    
    delete pCircle;
    return 0;
}
```
Abstract classes are a powerful tool for defining interfaces and enforcing a contract that all derived classes must follow.
