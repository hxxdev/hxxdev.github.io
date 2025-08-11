---
title: C++ Interface
date: 2025-08-11
categories: [dev, cpp]
tags: [cpp, modern-cpp, interface]
---

### Separating Class Interface and Implementation

So far, we have defined our member functions directly inside the class definition.
This is fine for short functions, but what happens when a member function is complex and spans over 100 lines of code?
The class definition can become bloated and difficult to read, making it hard to see the class's public interface at a glance.

To solve this, C++ allows us to separate the *declaration* of a member function from its *definition*.
Inside the class, we only provide the function prototypes (the function's name, return type, and parameters).
This collection of public member function prototypes forms the class's **interface**. The actual implementation (the function body) is defined outside the class.

Let's see this with a `BankAccount` class.

**Before (Implementation inside the class):**
```cpp
#include <iostream>
#include <string>

class BankAccount {
public:
    void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
        }
    }
    void withdraw(double amount) {
        if (amount > 0 && balance >= amount) {
            balance -= amount;
        }
    }
    double getBalance() {
        return balance;
    }
private:
    std::string accountHolder;
    double balance = 0.0;
};
```

# 1. Separating Class Interface and Implementation (Continued)

Now, let's separate the interface from the implementation. The member functions are defined outside the class using the **scope resolution operator `::`**. This operator tells the compiler that the function belongs to a specific class. For example, `BankAccount::deposit` indicates that we are defining the `deposit` function that is a member of the `BankAccount` class.

If you omit `BankAccount::`, the compiler would treat it as a regular, non-member function, which would lead to a compilation error.

**After (Implementation outside the class):**
```cpp
#include <iostream>
#include <string>

// Class Interface
class BankAccount {
public:
    void deposit(double amount);
    void withdraw(double amount);
    double getBalance();
    void setAccountHolder(std::string name);
    std::string getAccountHolder();
private:
    std::string accountHolder;
    double balance = 0.0;
};

// Class Implementation
void BankAccount::deposit(double amount) {
    if (amount > 0) {
        balance += amount;
    }
}

void BankAccount::withdraw(double amount) {
    if (amount > 0 && balance >= amount) {
        balance -= amount;
    }
}

double BankAccount::getBalance() {
    return balance;
}

void BankAccount::setAccountHolder(std::string name) {
    accountHolder = name;
}

std::string BankAccount::getAccountHolder() {
    return accountHolder;
}
```

# 1. Separating Class Interface and Implementation (Full Example)

Here is the complete source code showing the separation and how to use the class in `main`.

```cpp
#include <iostream>
#include <string>

// --- Class Interface ---
class BankAccount {
public:
    void deposit(double amount);
    void withdraw(double amount);
    double getBalance() const; // const indicates this function doesn't modify the object
    void setAccountHolder(std::string name);
    std::string getAccountHolder() const;

private:
    std::string accountHolder;
    double balance = 0.0;
};

// --- Class Implementation ---
void BankAccount::deposit(double amount) {
    if (amount > 0) {
        balance += amount;
        std::cout << "Deposited: $" << amount << std::endl;
    }
}

void BankAccount::withdraw(double amount) {
    if (amount > 0 && balance >= amount) {
        balance -= amount;
        std::cout << "Withdrew: $" << amount << std::endl;
    } else {
        std::cout << "Withdrawal failed. Insufficient funds." << std::endl;
    }
}

double BankAccount::getBalance() const {
    return balance;
}

void BankAccount::setAccountHolder(std::string name) {
    accountHolder = name;
}

std::string BankAccount::getAccountHolder() const {
    return accountHolder;
}

// --- Using the class ---
int main() {
    BankAccount myAccount;
    myAccount.setAccountHolder("John Doe");
    std::cout << "Account Holder: " << myAccount.getAccountHolder() << std::endl;
    std::cout << "Initial Balance: $" << myAccount.getBalance() << std::endl;

    myAccount.deposit(500.00);
    myAccount.withdraw(200.00);
    myAccount.withdraw(400.00); // This will fail

    std::cout << "Final Balance: $" << myAccount.getBalance() << std::endl;

    return 0;
}
```

# 2. Namespaces

A **namespace** is a declarative region that provides a scope to the identifiers (the names of types, functions, variables, etc) inside it. Namespaces are used to organize code into logical groups and to prevent name collisions that can occur especially when your code includes multiple libraries.

The `using namespace std;` statement that we often write at the top of our programs specifies that we are using the `std` (standard) namespace. All the identifiers from the standard library, like `cout`, `cin`, and `string`, are defined in this namespace.

If we don't use that statement, we must qualify each identifier with the namespace name.

**Without `using namespace std;`**
```cpp
#include <iostream>
#include <string>

int main() {
    std::cout << "Enter your name: ";
    std::string name;
    std::cin >> name;
    std::cout << "Hello, " << name << "!" << std::endl;
    return 0;
}
```

# 2. Namespaces (Continued)

We can also define our own namespaces. This is extremely useful in large projects to avoid conflicts.
For example, two different parts of a system might both need a `Logger` class, but with different implementations.

```cpp
#include <iostream>

namespace Database {
    class Logger {
    public:
        void log(const char* message) {
            std::cout << "[Database] " << message << std::endl;
        }
    };
}

namespace Network {
    class Logger {
    public:
        void log(const char* message) {
            std::cout << "[Network] " << message << std::endl;
        }
    };
}

int main() {
    Database::Logger dbLogger;
    dbLogger.log("User connected.");

    Network::Logger netLogger;
    netLogger.log("Packet sent.");

    return 0;
}
```
**Best Practice:** Avoid putting `using namespace` directives in header files, as it can pollute the global namespace for every file that includes the header. It's better to explicitly qualify names (e.g., `std::string`) in headers.

# 3. Separating Class Declaration and Definition into Files

Defining member functions outside the class is a good first step. However, the most common and professional way to structure a C++ project is to separate the class into two files:

1.  **Header File (`.h` or `.hpp`):** Contains the class declaration (the interface). This file describes *what* the class can do.
2.  **Source File (`.cpp`):** Contains the member function definitions (the implementation). This file defines *how* the class does it.

This approach has several advantages:
*   **Modularity:** The interface is cleanly separated from the implementation.
*   **Reusability:** Other parts of your program can `#include` the header file to use your class without needing to know about the implementation details.
*   **Faster Compilation:** If you only change the implementation in the `.cpp` file, files that include the `.h` file do not need to be recompiled, saving significant time in large projects.

# 3. Separating Files (Example)

Let's take our `BankAccount` class and split it into `BankAccount.h` and `BankAccount.cpp`. A third file, `main.cpp`, will use the class.

**`BankAccount.h`**
This file contains the class definition. It also includes a **header guard** (`#pragma once` or `#ifndef...#define...#endif`) to prevent the header from being included multiple times in a single source file, which would cause a redefinition error.

```cpp
#ifndef BANK_ACCOUNT_H
#define BANK_ACCOUNT_H

#include <string>

class BankAccount {
public:
    void deposit(double amount);
    void withdraw(double amount);
    double getBalance() const;
    void setAccountHolder(std::string name);
    std::string getAccountHolder() const;

private:
    std::string accountHolder;
    double balance = 0.0;
};

#endif // BANK_ACCOUNT_H
```

# 3. Separating Files (Example Continued)

**`BankAccount.cpp`**
This file contains the implementation of the member functions. It must `#include "BankAccount.h"` to get the class declaration.

```cpp
#include "BankAccount.h" // Note the use of " " for local headers
#include <iostream>

void BankAccount::deposit(double amount) {
    if (amount > 0) {
        balance += amount;
        std::cout << "Deposited: $" << amount << std::endl;
    }
}

void BankAccount::withdraw(double amount) {
    if (amount > 0 && balance >= amount) {
        balance -= amount;
        std::cout << "Withdrew: $" << amount << std::endl;
    } else {
        std::cout << "Withdrawal failed. Insufficient funds." << std::endl;
    }
}

double BankAccount::getBalance() const {
    return balance;
}

void BankAccount::setAccountHolder(std::string name) {
    accountHolder = name;
}

std::string BankAccount::getAccountHolder() const {
    return accountHolder;
}
```

**`main.cpp`**
This file is the client of the class. It only needs to include the header to use it.

```cpp
#include "BankAccount.h"
#include <iostream>

int main() {
    BankAccount myAccount;
    myAccount.setAccountHolder("Jane Smith");
    std::cout << "Account Holder: " << myAccount.getAccountHolder() << std::endl;
    myAccount.deposit(1000.00);
    std::cout << "Final Balance: $" << myAccount.getBalance() << std::endl;
    return 0;
}
```

# 4. Interfaces

In C++, an **interface** is a way to define a "contract" for a class.
It specifies a set of public methods that a class must implement, without providing any of the implementation itself.
This is achieved by creating an **abstract class** that consists of only **pure virtual functions**.

*   A **virtual function** is a member function that you expect to be redefined in derived classes.
*   A **pure virtual function** is a virtual function that has no implementation in the base class. It is declared by adding `= 0` to the end of the function signature.

Any class that contains at least one pure virtual function is an abstract class, and you cannot create an instance of it. A class that inherits from an abstract class must implement all of its pure virtual functions, or it too becomes an abstract class.

Let's define an `IShape` interface that requires all shapes to be drawable and to be able to calculate their area.

```cpp
#include <iostream>

// Interface (Abstract Class)
class IShape {
public:
    virtual void draw() const = 0; // Pure virtual function
    virtual double getArea() const = 0; // Pure virtual function
    virtual ~IShape() {} // Virtual destructor is important for interfaces
};

// Concrete Implementation 1
class Circle : public IShape {
public:
    Circle(double radius) : r(radius) {}
    void draw() const override {
        std::cout << "Drawing a circle." << std::endl;
    }
    double getArea() const override {
        return 3.14159 * r * r;
    }
private:
    double r;
};

// Concrete Implementation 2
class Square : public IShape {
public:
    Square(double side) : s(side) {}
    void draw() const override {
        std::cout << "Drawing a square." << std::endl;
    }
    double getArea() const override {
        return s * s;
    }
private:
    double s;
};
```
Interfaces are the key to enabling **polymorphism**, which we will discuss shortly.

# 5. Concepts of Object-Oriented Programming (OOP)

Now that we have a better understanding of classes, let's formally introduce the core concepts of OOP.

### Encapsulation

**Encapsulation** is the bundling of data (attributes) and the methods (functions) that operate on that data into a single unit, called a class. The primary goal is to group related information and functionality together, making the code more organized and manageable.

Think of a car. The engine, wheels, and steering wheel are all encapsulated within the car's chassis. You don't interact with them individually; you interact with the car as a whole. In C++, the class is the mechanism for encapsulation.

![](https://i.imgur.com/V2LdG8p.png)

# 5. OOP Concepts: Encapsulation & Information Hiding

A direct result of encapsulation is **Information Hiding**.

**Information Hiding** is the principle of concealing the internal state and implementation details of an object from the outside world. Access to the object's data is restricted, and only a controlled public interface (a set of public methods) is provided. This is achieved in C++ using the `public` and `private` access specifiers.

**Why is this important?**
1.  **Protection:** It prevents external code from accidentally or maliciously corrupting the object's internal state. For example, a `BankAccount` balance should not be settable to a negative number directly.
2.  **Flexibility:** The internal implementation can be changed without affecting any code that uses the class. If we decide to change how a `Stopwatch` stores time internally (from seconds to milliseconds), we only need to update the class methods. The client code that calls `start()` and `stop()` remains unchanged.
3.  **Simplicity:** It makes the class easier to use. The user only needs to know about the public methods, not the complex internal workings.

# 5. OOP Concepts: Information Hiding Example

Consider a `Stopwatch` class. The user should only be able to `start()`, `stop()`, and `getElapsedTime()`. They should not be able to directly set the internal start or end times, as that would break the logic of the stopwatch.

```cpp
#include <iostream>
#include <chrono>

class Stopwatch {
public:
    void start() {
        if (!isRunning) {
            startTime = std::chrono::high_resolution_clock::now();
            isRunning = true;
        }
    }

    void stop() {
        if (isRunning) {
            endTime = std::chrono::high_resolution_clock::now();
            isRunning = false;
        }
    }

    double getElapsedTime() const {
        if (isRunning) {
            return 0.0; // Or calculate current elapsed time
        }
        return std::chrono::duration<double>(endTime - startTime).count();
    }

private:
    // These implementation details are hidden from the user.
    bool isRunning = false;
    std::chrono::time_point<std::chrono::high_resolution_clock> startTime;
    std::chrono::time_point<std::chrono::high_resolution_clock> endTime;
};

int main() {
    Stopwatch timer;
    // timer.isRunning = true; // ERROR: isRunning is private
    // timer.startTime = ...;  // ERROR: startTime is private

    timer.start();
    // ... do some work ...
    for(long i = 0; i < 1000000000; ++i); // Simulate work
    timer.stop();

    std::cout << "Elapsed time: " << timer.getElapsedTime() << " seconds" << std::endl;
    return 0;
}
```

# 5. OOP Concepts: Inheritance

**Inheritance** is a mechanism that allows a new class (the **derived** or **child** class) to be based on an existing class (the **base** or **parent** class). The derived class inherits the attributes and methods of the base class, and can add its own new functionality or override existing functionality.

Inheritance represents an **"is-a"** relationship. For example, a `Car` is a `Vehicle`. A `Dog` is an `Animal`. This allows for code reuse and the creation of logical hierarchies.

![](https://i.imgur.com/A5O8f3c.png)

# 5. OOP Concepts: Inheritance Example

Let's model a `Vehicle` hierarchy. The base class `Vehicle` will have common properties, and the derived classes `Car` and `Motorcycle` will inherit them and add their own specific features.

```cpp
#include <iostream>
#include <string>

// Base Class
class Vehicle {
public:
    Vehicle(const std::string& brand) : brandName(brand) {}

    void startEngine() { std::cout << "Engine started." << std::endl; }
    void stopEngine() { std::cout << "Engine stopped." << std::endl; }
    std::string getBrand() const { return brandName; }

protected: // Accessible by derived classes, but not by the public
    std::string brandName;
};

// Derived Class 1
class Car : public Vehicle {
public:
    Car(const std::string& brand, int seats) : Vehicle(brand), numSeats(seats) {}

    void openTrunk() { std::cout << "Trunk is open." << std::endl; }
    int getNumSeats() const { return numSeats; }

private:
    int numSeats;
};

// Derived Class 2
class Motorcycle : public Vehicle {
public:
    Motorcycle(const std::string& brand) : Vehicle(brand) {}

    void doWheelie() { std::cout << "Doing a wheelie!" << std::endl; }
};

int main() {
    Car myCar{"Toyota", 5};
    Motorcycle myBike{"Harley-Davidson"};

    std::cout << "My car is a " << myCar.getBrand() << std::endl;
    myCar.startEngine(); // Inherited from Vehicle
    myCar.openTrunk();   // Specific to Car

    std::cout << "
My bike is a " << myBike.getBrand() << std::endl;
    myBike.startEngine(); // Inherited from Vehicle
    myBike.doWheelie();   // Specific to Motorcycle

    return 0;
}
```

# 5. OOP Concepts: Polymorphism

**Polymorphism** (from Greek, meaning "many forms") is the ability of an object to take on many forms. In OOP, it means that a call to a member function will cause a different action depending on the runtime type of the object.

In C++, polymorphism is achieved through **inheritance** and **virtual functions**. When you have a pointer or reference to a base class, you can call a virtual function on it, and the C++ runtime will dynamically determine which derived class's version of the function to execute. This is called **dynamic dispatch** or **late binding**.

This allows us to write very flexible and generic code. For example, we can have a function that can draw any kind of `IShape` without knowing its specific type.

![](https://i.imgur.com/U3sZ3fE.png)

# 5. OOP Concepts: Polymorphism Example

Let's use our `IShape` interface to demonstrate polymorphism. We can create a collection of different shapes and treat them all uniformly as `IShape` pointers.

```cpp
#include <iostream>
#include <vector>
#include <memory> // For std::unique_ptr

// IShape, Circle, and Square class definitions from slide 10 go here...
class IShape {
public:
    virtual void draw() const = 0;
    virtual ~IShape() {}
};
class Circle : public IShape {
public:
    void draw() const override { std::cout << "Drawing a circle." << std::endl; }
};
class Square : public IShape {
public:
    void draw() const override { std::cout << "Drawing a square." << std::endl; }
};
class Triangle : public IShape {
public:
    void draw() const override { std::cout << "Drawing a triangle." << std::endl; }
};


// This function works with ANY class that implements the IShape interface.
void renderScene(const std::vector<std::unique_ptr<IShape>>& scene) {
    for (const auto& shape : scene) {
        shape->draw(); // The correct draw() is called for each object!
    }
}

int main() {
    std::vector<std::unique_ptr<IShape>> myScene;

    // Add different shapes to the scene
    myScene.push_back(std::make_unique<Circle>());
    myScene.push_back(std::make_unique<Square>());
    myScene.push_back(std::make_unique<Triangle>());
    myScene.push_back(std::make_unique<Circle>());

    // Render the entire scene with one function call
    renderScene(myScene);

    return 0;
}
```

# 6. UML Class Diagrams

**UML (Unified Modeling Language)** is a standardized graphical language used to visualize, specify, construct, and document the artifacts of a software system. It helps you design and review your system before writing code.

A **Class Diagram** is one of the most common UML diagrams. It shows the classes in a system, their attributes (member variables), operations (member functions), and the relationships between the classes.

A class is drawn as a rectangle divided into three parts:
1.  **Top:** Class Name
2.  **Middle:** Attributes. `+` denotes `public`, `-` denotes `private`, `#` denotes `protected`.
3.  **Bottom:** Operations.

![](https://i.imgur.com/yG5zI1B.png)

# 6. UML: Class Relationships

Arrows are used to show the relationships between classes. Here are the most important ones:

*   **Inheritance (or Generalization):** A solid line with a hollow arrowhead pointing from the child to the parent class. It represents an "is-a" relationship.
*   **Association:** A solid line indicating that two classes work together. (e.g., a `Player` and a `Team`).
*   **Aggregation:** A solid line with a hollow diamond. It's a "has-a" relationship where the part can exist independently of the whole (e.g., a `Department` has `Professors`).
*   **Composition:** A solid line with a filled diamond. It's a strong "owns-a" relationship where the part cannot exist without the whole (e.g., a `House` is composed of `Rooms`).
*   **Dependency:** A dashed line with an open arrow. It means one class uses another (e.g., a `ReportGenerator` depends on a `DatabaseConnection`).

![](https://i.imgur.com/jZJkZ1X.png)

# End of Chapter 3
