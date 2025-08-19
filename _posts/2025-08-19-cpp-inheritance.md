---
title: C++ Inheritance
date: 2025-08-19
categories: [dev, cpp]
tags: [cpp, class, inheritance]
---

### Introduction to Inheritance in C++

Inheritance is a fundamental concept in Object-Oriented Programming (OOP) that allows a new class to be based on an existing class. The new class, known as the **derived class** (or child class), inherits the attributes and behaviors (members) of the existing class, referred to as the **base class** (or parent class). This mechanism promotes code reusability, reduces redundancy, and establishes a logical hierarchy between classes.

The core idea is to build upon existing, tested code, which simplifies development and maintenance. By inheriting from a base class, a derived class can extend its functionality by adding new members or modifying existing ones.

### The "is-a" Relationship

Inheritance models an "is-a" relationship. This means the derived class is a specialized version of the base class. For example:
- A `Manager` **is an** `Employee`.
- A `Car` **is a** `Vehicle`.
- A `Circle` **is a** `Shape`.

This is distinct from a "has-a" relationship (composition), where one class contains an object of another class. For example, a `Car` **has a** `Engine`. Understanding this distinction is crucial for correct object-oriented design.

### Defining a Derived Class

In C++, you use the colon (`:`) symbol to establish an inheritance relationship. The syntax is as follows:

```cpp
class BaseClassName {
    // ... members ...
};

class DerivedClassName : public BaseClassName {
    // ... additional members ...
};
```

The `public` keyword before the base class name specifies the type of inheritance. We will explore this in more detail later.

Let's consider an example with an `Employee` base class and a `Manager` derived class.

```cpp
#include <iostream>
#include <string>

// Base Class
class Employee {
private:
    std::string name;
    int employeeID;

public:
    Employee(const std::string& name, int id) : name(name), employeeID(id) {}

    void displayProfile() {
        std::cout << "ID: " << employeeID << ", Name: " << name << std::endl;
    }

    std::string getName() const {
        return name;
    }
};

// Derived Class
class Manager : public Employee {
private:
    std::string department;

public:
    // The Manager constructor calls the Employee constructor
    Manager(const std::string& name, int id, const std::string& dept)
        : Employee(name, id), department(dept) {}

    void manageTeam() {
        std::cout << getName() << " is managing the " << department << " department." << std::endl;
    }
};

int main() {
    Employee emp("Alice", 101);
    Manager mgr("Bob", 202, "Engineering");

    std::cout << "Employee Profile:" << std::endl;
    emp.displayProfile();

    std::cout << "\nManager Profile:" << std::endl;
    mgr.displayProfile(); // Inherited from Employee
    mgr.manageTeam();     // Specific to Manager

    return 0;
}
```
In this example, the `Manager` class inherits `displayProfile()` and `getName()` from `Employee`. It can use these methods as if they were its own. The `Manager` class also adds its own specific functionality, `manageTeam()`.

### Constructors and Destructors in Inheritance

When a derived class object is created, the base class's constructor is called first, followed by the derived class's constructor. This ensures that the base part of the object is properly initialized before the derived part.

Destructors are called in the reverse order: the derived class's destructor is called first, followed by the base class's destructor.

**Constructor Chaining:**
If you don't explicitly call a specific base class constructor, the compiler will automatically call the base class's default (parameterless) constructor. To call a specific base constructor, you use the member initializer list in the derived class's constructor, as shown in the `Manager` example above.

```cpp
// Syntax for calling a specific base constructor
DerivedClassName(args...) : BaseClassName(base_args...), member1(val1) {
    // Derived constructor body
}
```

### Access Control and Inheritance

Access specifiers (`public`, `protected`, `private`) determine how members of a base class can be accessed by derived classes.

- **`public`**: Public members are accessible from anywhere, including derived classes.
- **`protected`**: Protected members are accessible within the class itself and by its derived classes. They are not accessible from outside the class hierarchy. This is useful for members that are part of the class's implementation but need to be available for specialization in derived classes.
- **`private`**: Private members are only accessible within the class that defines them. They are **not** accessible by derived classes.

Here's a summary:

| Specifier   | Accessible within Class | Accessible in Derived Class | Accessible Externally |
|-------------|-------------------------|-----------------------------|-----------------------|
| `public`    | Yes                     | Yes                         | Yes                   |
| `protected` | Yes                     | Yes                         | No                    |
| `private`   | Yes                     | No                          | No                    |

### Method Overriding

A derived class can provide a specific implementation for a member function that is already defined in its base class. This is called **method overriding**. The function in the derived class must have the exact same signature (name, parameters, and const-ness) as the function in the base class.

When the method is called on a derived class object, the overridden version in the derived class is executed.

```cpp
#include <iostream>

class Instrument {
public:
    void playSound() {
        std::cout << "An instrument makes a sound." << std::endl;
    }
};

class Guitar : public Instrument {
public:
    // Overriding the playSound method
    void playSound() {
        std::cout << "A guitar strums." << std::endl;
    }
};

int main() {
    Instrument generic;
    Guitar acoustic;

    generic.playSound();  // Calls Instrument::playSound
    acoustic.playSound(); // Calls the overridden Guitar::playSound
    
    // To call the base version from the derived object:
    acoustic.Instrument::playSound();

    return 0;
}
```

**Overriding vs. Overloading:**
- **Overriding**: A derived class redefines a method from its base class with an identical signature. It's about changing behavior.
- **Overloading**: Defining multiple functions in the same scope with the same name but different parameters. It's about providing different ways to call a function.

### Multiple Inheritance

C++ allows a class to inherit from more than one base class, a feature known as **multiple inheritance**.

```cpp
class BaseA { /* ... */ };
class BaseB { /* ... */ };

class Derived : public BaseA, public BaseB {
    // Inherits members from both BaseA and BaseB
};
```

While powerful, multiple inheritance can introduce complexity, most notably the **Diamond Problem**. This occurs when a class inherits from two classes that both inherit from the same single base class. This can lead to ambiguity if the derived class tries to access a member of the ultimate base class.

```cpp
class Device {
public:
    void powerOn() { /* ... */ }
};

class Scanner : public Device { /* ... */ };
class Printer : public Device { /* ... */ };

// Diamond Problem: Copier inherits powerOn() from both Scanner and Printer
class Copier : public Scanner, public Printer {
    // Which powerOn() does it use?
};

int main() {
    Copier c;
    // c.powerOn(); // AMBIGUITY ERROR!
    
    // To resolve, specify the path:
    c.Scanner::powerOn();
    c.Printer::powerOn();
}
```
This ambiguity can be resolved using scope resolution (`::`) or by using `virtual` inheritance, which is an advanced topic. Due to these complexities, many developers prefer to avoid multiple inheritance in favor of alternative designs.

