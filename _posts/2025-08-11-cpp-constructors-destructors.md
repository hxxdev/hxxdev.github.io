---
title: C++ Constructurs, Destructors, and Object Interaction
date: 2025-08-11
categories: [dev, cpp]
tags: [cpp, modern-cpp, constructors, destructors, object, class]
---


## Constructors

Just like a simple variable holds a garbage value if left uninitialized, an object's member variables are also uninitialized when the object is created.
It is crucial to initialize an object's state before using it.
This initialization can involve setting member variables to default values, allocating memory, or acquiring other system resources.

In C++, this initialization is handled by a special member function called a **constructor**. The constructor is called automatically whenever a new instance of a class is created.

**Key characteristics of a constructor:**
- It has the exact same name as the class.
- It does not have a return type (not even `void`).
- Its primary job is to initialize the object.


#### Why Do We Need Constructors?

Let's define a simple `Player` class. Without a constructor, we would have to initialize its members manually after creation.

```cpp
#include <iostream>
#include <string>

class Player {
public:
    std::string username;
    int health;
    int score;

    void print() {
        std::cout << "Username: " << username 
                  << ", Health: " << health 
                  << ", Score: " << score << std::endl;
    }
};

int main() {
    Player p1;
    // Manual initialization is required
    p1.username = "Knight";
    p1.health = 100;
    p1.score = 0;

    p1.print();
}
```

#### The Problem with Manual Initialization

Manual initialization is tedious and error-prone. A developer might:
1.  Forget to initialize a member, leaving it with a garbage value.
2.  Provide an invalid value that violates the class's rules (e.g., a negative health value).

```cpp
int main() {
    Player p2;
    p2.username = "Rogue";
    p2.health = -50; // Invalid state!
    // Forgot to initialize p2.score!

    p2.print(); // Prints an invalid health and a garbage score.
}
```

We could write a separate `init()` function, but there's no guarantee that a developer will remember to call it.

#### The Constructor Solution

By defining a constructor, we guarantee that every object is properly initialized upon creation. The compiler will automatically call the constructor, making initialization seamless and mandatory.

```cpp
#include <iostream>
#include <string>

class Player {
public:
    // This is the constructor
    Player(std::string name, int startHealth) {
        std::cout << "Player object created!" << std::endl;
        username = name;
        health = startHealth;
        score = 0; // Always start with a score of 0
    }

    std::string username;
    int health;
    int score;

    void print() {
        std::cout << "Username: " << username 
                  << ", Health: " << health 
                  << ", Score: " << score << std::endl;
    }
};
```

#### Calling a Constructor

With a constructor defined, we now provide the initial values when we declare the object. Forgetting to provide them will result in a compile-time error, which is exactly what we want.

```cpp
int main() {
    // Player p1; // COMPILE ERROR! No arguments provided.

    // C++98 style (still works, but less common now)
    Player p2("Wizard", 80);
    p2.print();

    // Modern C++ (Uniform Initialization - Preferred)
    Player p3{"Archer", 90};
    p3.print();

    // Also valid, but the braces are generally preferred
    Player p4 = {"Thief", 75};
    p4.print();
}
```

Using curly braces `{}` is known as **uniform initialization** and is the recommended modern C++ approach as it's more consistent and can prevent certain types of errors.

#### Constructor Overloading

Like regular functions, constructors can be **overloaded**. This means you can have multiple constructors with different sets of parameters. The compiler chooses the correct one to call based on the arguments you provide during object creation.

A constructor with no parameters is called the **default constructor**. It's used when you create an object without any arguments.

```cpp
class Player {
public:
    // Default constructor
    Player() {
        username = "Guest";
        health = 100;
        score = 0;
    }

    // Parameterized constructor
    Player(std::string name) {
        username = name;
        health = 100;
        score = 0;
    }
    // ... members and methods
};

int main() {
    Player guest;         // Calls the default constructor
    Player proGamer("Pro"); // Calls the parameterized constructor
}
```

#### Constructors with Default Arguments

Instead of overloading, you can often use **default arguments** in a single constructor to achieve the same result more concisely.

```cpp
#include <iostream>
#include <string>

class Player {
public:
    // A single constructor with default arguments
    Player(std::string name = "Guest", int startHealth = 100) {
        username = name;
        health = startHealth;
        score = 0;
    }
    // ... members and methods
    void print() { /* ... */ }
};

int main() {
    Player p1;                  // Calls Player("Guest", 100)
    Player p2{"Hero"};          // Calls Player("Hero", 100)
    Player p3{"Boss", 500};     // Calls Player("Boss", 500)
}
```

#### Member Initializer Lists

C++ provides a more efficient and idiomatic way to initialize member variables: the **member initializer list**. This list appears after the constructor's parameter list and is separated by a colon (`:`).

**Syntax:** `Constructor(args) : member1(arg1), member2(arg2) {}`

This is preferred over assigning values inside the constructor body because it performs **initialization** directly, rather than default construction followed by **assignment**. For `const` members or class-type members, using an initializer list is mandatory.

```cpp
class Player {
public:
    // Using a member initializer list
    Player(std::string name = "Guest", int startHealth = 100)
        : username(name), health(startHealth), score(0) // This is the initializer list
    {
        // Constructor body can be empty or used for other setup tasks
        std::cout << "Player " << username << " initialized." << std::endl;
    }

private:
    std::string username;
    int health;
    int score;
};
```
This is the most common and professional way to write constructors in C++.

## Destructors

Just as a constructor is called when an object is created, a **destructor** is a special member function that is called automatically when an object is destroyed. An object is destroyed when it goes out of scope (e.g., a local variable when a function ends) or when it is explicitly deleted.

The primary purpose of a destructor is to **release any resources** the object acquired during its lifetime. This is crucial for preventing resource leaks, such as memory leaks.

**Key characteristics of a destructor:**
- It has the same name as the class, prefixed with a tilde (`~`).
- It takes no arguments and has no return type.
- A class can only have one destructor.

```cpp
#include <iostream>

class ResourceHolder {
public:
    ResourceHolder() {
        std::cout << "Resource acquired." << std::endl;
        // Imagine allocating memory here with `new`
    }

    // This is the destructor
    ~ResourceHolder() {
        std::cout << "Resource released. Object is being destroyed." << std::endl;
        // The memory allocated with `new` would be freed here with `delete`
    }
};

int main() {
    std::cout << "Entering main function." << std::endl;
    {
        ResourceHolder r; // Constructor called here
        std::cout << "Inside inner scope." << std::endl;
    } // `r` goes out of scope here, destructor is called automatically
    std::cout << "Exited inner scope." << std::endl;
    return 0;
}
```

#### Access Control: `public` vs. `private`

**Access control** determines which parts of your class can be accessed from outside the class. C++ provides access specifiers to enforce this, with the two most common being `public` and `private`.

-   **`public`**: Members declared as `public` form the class's interface. They can be accessed from anywhere the object is visible.
-   **`private`**: Members declared as `private` are encapsulated. They can only be accessed by other member functions of the same class. This is the key to **information hiding**.

By default, if you don't specify, members of a `class` are `private`.


#### Why is Access Control Necessary?

Let's revisit our `Player` class. If its members are `public`, anyone can change them to invalid values, breaking the object's state.

```cpp
class Player {
public:
    std::string username;
    int health;
};

int main() {
    Player p;
    p.username = ""; // An empty username might be invalid
    p.health = -999; // Health should not be negative!
}
```

To prevent this, we make the data members `private`. This forces the user of the class to interact with the data through `public` methods, where we can enforce rules and validation.

```cpp
class Player {
public:
    // Public methods to control access
    void takeDamage(int amount) {
        if (amount > 0) {
            health -= amount;
            if (health < 0) health = 0;
        }
    }

private:
    // Data is now protected
    std::string username;
    int health;
};

int main() {
    Player p;
    // p.health = -999; // COMPILE ERROR! health is private
    p.takeDamage(50);
}
```

#### Accessors (Getters) and Mutators (Setters)

To provide controlled access to `private` data, we use special public methods:

-   **Accessor (Getter):** A method that returns the value of a private member. It provides read-only access. By convention, these are named `getSomething()`.
-   **Mutator (Setter):** A method that modifies the value of a private member. It provides write access and is the perfect place to put validation logic. By convention, these are named `setSomething()`.

```cpp
#include <string>
#include <iostream>

class Player {
public:
    Player(std::string name) : username(name), health(100) {}

    // Setter for health (with validation)
    void setHealth(int newHealth) {
        if (newHealth >= 0 && newHealth <= 100) {
            health = newHealth;
        }
    }

    // Getter for health
    int getHealth() const { // `const` means this function doesn't modify the object
        return health;
    }

    // Getter for username (read-only property)
    std::string getUsername() const {
        return username;
    }

private:
    std::string username; // Cannot be changed after construction
    int health;
};

int main() {
    Player p{"Hero"};
    p.setHealth(150); // Ignored, value is invalid
    p.setHealth(80);
    std::cout << p.getUsername() << "'s health: " << p.getHealth() << std::endl;
}
```

#### Objects and Functions

Let's explore the three main ways objects interact with functions.

##### Pass-by-Value

When you pass an object to a function by value, a **complete copy** of the object is created. The function operates on the copy.

-   **Pro:** The original object is safe and cannot be modified by the function.
-   **Con:** Copying can be very expensive for large objects, impacting performance.

```cpp
#include <iostream>

class Pizza {
public:
    int size = 12;
};

// `p` is a COPY of the original pizza
void attemptToEnlarge(Pizza p) {
    p.size = 16; // Modifies the copy, not the original
    std::cout << "Inside function, pizza size is " << p.size << std::endl;
}

int main() {
    Pizza myPizza;
    std::cout << "Before function, pizza size is " << myPizza.size << std::endl;
    attemptToEnlarge(myPizza);
    std::cout << "After function, pizza size is " << myPizza.size << std::endl; // Still 12!
}
```


##### Pass-by-Reference

When you pass an object by reference (`&`), you are not passing a copy. Instead, you are giving the function a direct alias to the original object. Any modifications made inside the function **will affect the original object**.

-   **Pro:** Very efficient. No copy is made.
-   **Pro:** Allows the function to modify the original object.

```cpp
// `p` is a REFERENCE to the original pizza
void enlarge(Pizza& p) {
    p.size = 16; // Modifies the original object
    std::cout << "Inside function, pizza size is " << p.size << std::endl;
}

int main() {
    Pizza myPizza;
    std::cout << "Before function, pizza size is " << myPizza.size << std::endl;
    enlarge(myPizza);
    std::cout << "After function, pizza size is " << myPizza.size << std::endl; // Now 16!
}
```


##### Pass-by-`const` Reference

This is the most common and preferred way to pass objects that the function only needs to read from. It combines the efficiency of pass-by-reference with the safety of pass-by-value.

-   **`const`**: Guarantees the function cannot modify the object (enforced by the compiler).
-   **`&`**: Avoids the expensive copy.

```cpp
// `p` is a reference, but it cannot be modified
void printSize(const Pizza& p) {
    // p.size = 20; // COMPILE ERROR! Cannot modify a const reference.
    std::cout << "The pizza size is " << p.size << std::endl;
}
```

##### Returning Objects from a Function

Functions can also create and return objects. Conceptually, a copy of the object is returned to the caller. 

```cpp
Burger createBurger(int size) {
    Burger burger;
    burger.size = size;
    return burger; // Returns a copy of burger
}

int main() {
    Burger partyBurger = createBurger(24);
    std::cout << "Party pizza size: " << partyBurger.size << std::endl;
}
```

In this example, `createBurger` returns a copy of instance `burger` meaning `return` statements passes-by-`value`.

**Note:** Modern C++ compilers use an optimization called **Return Value Optimization (RVO)**, which often eliminates the need for this copy, making it very efficient in practice.

