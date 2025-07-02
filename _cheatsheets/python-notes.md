---
layout: cheatsheet
title: "Python Notes"
description: "My notes from my Python learning"
date: 2024-10-05
categories: [ai-ml, python]
tags: [python, programming, ai, ml, genai, development]
---


# Python Notes from my learning

## Table of Contents
1. [Core Concepts & Characteristics](#core-concepts--characteristics)
2. [Basic Syntax & Data Types](#basic-syntax--data-types)
3. [Control Flow](#control-flow)
4. [Functions](#functions)
5. [Modules and Packages](#modules-and-packages)
6. [Classes and Objects (OOP)](#classes-and-objects-oop)
7. [File I/O](#file-io-inputoutput)
8. [Exception Handling](#exception-handling)
9. [List Comprehensions](#list-comprehensions)
10. [Common Libraries](#common-libraries)
11. [Best Practices](#best-practices)
12. [Additional Important Concepts](#additional-important-concepts)

## I. Core Concepts & Characteristics

### Everything is an Object
In Python, everything—including numbers, strings, and functions—is an object. Objects are instances of classes.

### Key Language Features
- **Classes**: Generalized definitions of abstract data types, including their associated methods and attributes
- **Interpreted Language**: Python code is executed line by line rather than being compiled into machine code
- **Dynamic Typing**: No need to explicitly declare variable types; Python infers the type at runtime
- **Indentation Matters**: Python uses indentation (typically 4 spaces) to define code blocks
- **High-Level Language**: No manual memory management required
- **CPython**: The default implementation of Python
- **Pythonic**: The idiomatic way of writing Python code

### Python Enhancement Proposals (PEPs)
- **PEP 8**: The style guide for Python code, emphasizing readability
  - Tools like `autopep8`, `black`, and `flake8` can help maintain PEP 8 compliance
- **PEP 20**: The Zen of Python, philosophical guidelines for writing good Python code
  - Access it by typing `import this` in Python

## II. Basic Syntax & Data Types

### A. Variables
Variables store data in a computer's memory.

```python
# Assignment
x = 10
name = "Alice"
is_student = True

# Multiple assignment
x, y, z = 1, 2, 3

# Augmented assignment
x += 3  # Equivalent to x = x + 3
```

**Naming Conventions:**
- **Case-sensitive**: `x` and `X` are different variables
- **Descriptive names**: `student_count` is better than `sc`
- **Snake_case**: Use underscores for multi-word variable names
- Cannot start with numbers or contain special characters (except `_`)

### B. Numbers

#### Types of Numbers
```python
# Integer (int) - Whole numbers
age = 25
temperature = -10

# Float - Decimal numbers
price = 19.99
pi = 3.14159

# Complex - Numbers with real and imaginary parts
complex_num = 3 + 4j
```

#### Arithmetic Operators
```python
# Basic operations
10 + 3   # Addition: 13
10 - 3   # Subtraction: 7
10 * 3   # Multiplication: 30
10 / 3   # Division (float): 3.333...
10 // 3  # Floor division: 3
10 % 3   # Modulus (remainder): 1
10 ** 3  # Exponentiation: 1000

# Built-in functions
round(3.7)    # 4
round(3.14159, 2)  # 3.14
abs(-10)      # 10
min(1, 2, 3)  # 1
max(1, 2, 3)  # 3
sum([1, 2, 3, 4])  # 10
```

#### Math and Cmath Modules
```python
import math
math.sqrt(16)     # 4.0
math.ceil(4.3)    # 5
math.floor(4.7)   # 4
math.pi           # 3.14159...

import cmath  # For complex numbers
cmath.sqrt(-1)    # 1j
```

### C. Strings (`str`)

Strings are immutable sequences of characters.

```python
# String creation
single = 'Hello'
double = "World"
triple = """Multi-line
string"""

# String operations
greeting = "Hello" + " " + "World"  # Concatenation
"Python" * 3  # "PythonPythonPython"

# Indexing and slicing
text = "Python"
text[0]     # 'P' (first character)
text[-1]    # 'n' (last character)
text[0:3]   # 'Pyt' (substring)
text[::2]   # 'Pto' (every 2nd character)
text[::-1]  # 'nohtyP' (reversed)

# String methods
text = "  Python Programming  "
text.strip()          # Remove whitespace
text.lower()          # "python programming"
text.upper()          # "PYTHON PROGRAMMING"
text.title()          # "Python Programming"
text.replace("Python", "Java")  # Replace substring
text.split()          # ['Python', 'Programming']
"-".join(['a', 'b', 'c'])  # 'a-b-c'

# String formatting
name = "Alice"
age = 30

# f-strings (Python 3.6+) - Recommended
f"My name is {name} and I am {age} years old"
f"{age * 12} months old"  # Can include expressions

# .format() method
"My name is {} and I am {} years old".format(name, age)

# % formatting (older style)
"My name is %s and I am %d years old" % (name, age)

# Escape characters
print("He said \"Hello\"")  # Quotes
print("Line 1\nLine 2")     # Newline
print("Tab\there")          # Tab
print("Backslash: \\")      # Backslash
```

### D. Booleans (`bool`)
```python
is_valid = True
is_empty = False

# Boolean operations
True and False   # False
True or False    # True
not True         # False

# Truthy and Falsy values
# Falsy: False, None, 0, 0.0, '', [], {}, set()
# Everything else is Truthy
```

### E. Lists (`list`)

Lists are mutable, ordered sequences.

```python
# Creating lists
numbers = [1, 2, 3, 4, 5]
mixed = [1, "hello", 3.14, True]
nested = [[1, 2], [3, 4]]

# List operations
numbers[0]        # Access first element: 1
numbers[-1]       # Access last element: 5
numbers[1:4]      # Slice: [2, 3, 4]
len(numbers)      # Length: 5

# List methods
numbers.append(6)          # Add to end
numbers.insert(0, 0)       # Insert at index
numbers.extend([7, 8, 9])  # Add multiple items
numbers.remove(3)          # Remove first occurrence
popped = numbers.pop()     # Remove and return last
numbers.pop(0)             # Remove at index
numbers.clear()            # Remove all items

# Other operations
numbers.sort()             # Sort in place
sorted_nums = sorted(numbers)  # Return sorted copy
numbers.reverse()          # Reverse in place
numbers.count(3)           # Count occurrences
numbers.index(3)           # Find index of value

# List comprehensions preview
squares = [x**2 for x in range(10)]
```

### F. Tuples (`tuple`)

Tuples are immutable, ordered sequences.

```python
# Creating tuples
coordinates = (3, 4)
single_item = (1,)  # Note the comma
empty = ()

# Tuple operations (similar to lists but immutable)
x, y = coordinates  # Tuple unpacking
first = coordinates[0]

# Use cases: Return multiple values, dictionary keys
def get_dimensions():
    return 10, 20  # Returns a tuple

width, height = get_dimensions()
```

### G. Dictionaries (`dict`)

Dictionaries are mutable, unordered collections of key-value pairs.

```python
# Creating dictionaries
person = {
    "name": "Alice",
    "age": 30,
    "city": "New York"
}

# Alternative creation
person = dict(name="Alice", age=30, city="New York")

# Dictionary operations
person["name"]              # Access value: "Alice"
person.get("name")          # Safe access
person.get("phone", "N/A")  # With default
person["email"] = "alice@example.com"  # Add/update
del person["city"]          # Delete key

# Dictionary methods
person.keys()      # dict_keys(['name', 'age', 'email'])
person.values()    # dict_values(['Alice', 30, 'alice@example.com'])
person.items()     # dict_items([('name', 'Alice'), ...])
person.pop("age")  # Remove and return value
person.update({"phone": "123-456-7890"})  # Update multiple

# Dictionary comprehension
squares = {x: x**2 for x in range(5)}
```

### H. Sets (`set`)

Sets are mutable collections of unique elements.

```python
# Creating sets
numbers = {1, 2, 3, 4, 5}
empty_set = set()  # Note: {} creates empty dict

# Set operations
numbers.add(6)
numbers.remove(3)    # Raises error if not found
numbers.discard(3)   # No error if not found

# Set operations
set1 = {1, 2, 3}
set2 = {3, 4, 5}

set1 | set2  # Union: {1, 2, 3, 4, 5}
set1 & set2  # Intersection: {3}
set1 - set2  # Difference: {1, 2}
set1 ^ set2  # Symmetric difference: {1, 2, 4, 5}

# Set comprehension
evens = {x for x in range(10) if x % 2 == 0}
```

### I. Type Conversion

```python
# Converting between types
int("123")      # String to integer: 123
float("3.14")   # String to float: 3.14
str(123)        # Number to string: "123"
list("abc")     # String to list: ['a', 'b', 'c']
tuple([1, 2])   # List to tuple: (1, 2)
set([1, 2, 2])  # List to set: {1, 2}
bool(1)         # To boolean: True
bool("")        # To boolean: False

# Type checking
type(123)           # <class 'int'>
isinstance(123, int)  # True
isinstance(123, (int, float))  # True (checks multiple types)
```

## III. Control Flow

### A. Conditional Statements

```python
# Basic if statement
if condition:
    # Code if condition is True
    pass

# if-else
if temperature > 30:
    print("It's hot!")
else:
    print("It's not hot.")

# if-elif-else
if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 70:
    grade = "C"
else:
    grade = "F"

# Ternary operator (conditional expression)
status = "Pass" if score >= 60 else "Fail"

# Nested conditions
if x > 0:
    if y > 0:
        print("Both positive")
```

### B. Loops

#### For Loops
```python
# Iterate over sequence
for item in [1, 2, 3]:
    print(item)

# Using range
for i in range(5):      # 0, 1, 2, 3, 4
    print(i)

for i in range(2, 10, 2):  # start, stop, step
    print(i)  # 2, 4, 6, 8

# Enumerate for index and value
fruits = ["apple", "banana", "orange"]
for index, fruit in enumerate(fruits):
    print(f"{index}: {fruit}")

# Zip for parallel iteration
names = ["Alice", "Bob", "Charlie"]
ages = [25, 30, 35]
for name, age in zip(names, ages):
    print(f"{name} is {age} years old")

# Dictionary iteration
person = {"name": "Alice", "age": 30}
for key in person:
    print(key, person[key])

for key, value in person.items():
    print(f"{key}: {value}")
```

#### While Loops
```python
# Basic while loop
count = 0
while count < 5:
    print(count)
    count += 1

# Infinite loop with break
while True:
    user_input = input("Enter 'quit' to exit: ")
    if user_input == 'quit':
        break

# While with else
count = 0
while count < 3:
    print(count)
    count += 1
else:
    print("Loop completed normally")
```

#### Loop Control Statements
```python
# break - Exit loop immediately
for i in range(10):
    if i == 5:
        break
    print(i)  # Prints 0-4

# continue - Skip current iteration
for i in range(5):
    if i == 2:
        continue
    print(i)  # Prints 0, 1, 3, 4

# pass - Placeholder (do nothing)
for i in range(3):
    pass  # TODO: implement later
```

## IV. Functions

### Basic Functions
```python
# Simple function
def greet():
    """This function prints a greeting."""
    print("Hello, World!")

# Function with parameters
def greet_person(name):
    """Greet a person by name."""
    print(f"Hello, {name}!")

# Function with return value
def add(a, b):
    """Return the sum of two numbers."""
    return a + b

# Multiple return values
def get_min_max(numbers):
    return min(numbers), max(numbers)

minimum, maximum = get_min_max([1, 2, 3, 4, 5])
```

### Function Parameters
```python
# Default parameters
def greet(name, greeting="Hello"):
    print(f"{greeting}, {name}!")

greet("Alice")              # Hello, Alice!
greet("Bob", "Hi")          # Hi, Bob!

# Keyword arguments
def create_profile(name, age, city):
    return {"name": name, "age": age, "city": city}

profile = create_profile(age=30, name="Alice", city="NYC")

# *args - Variable positional arguments
def sum_all(*numbers):
    return sum(numbers)

result = sum_all(1, 2, 3, 4, 5)  # 15

# **kwargs - Variable keyword arguments
def print_info(**info):
    for key, value in info.items():
        print(f"{key}: {value}")

print_info(name="Alice", age=30, city="NYC")

# Combining parameter types
def complex_function(pos1, pos2, *args, kw1="default", **kwargs):
    print(f"Positional: {pos1}, {pos2}")
    print(f"Args: {args}")
    print(f"Keyword: {kw1}")
    print(f"Kwargs: {kwargs}")
```

### Lambda Functions
```python
# Simple lambda
square = lambda x: x ** 2
print(square(5))  # 25

# Lambda with multiple arguments
add = lambda x, y: x + y

# Common use with built-in functions
numbers = [1, 2, 3, 4, 5]
squared = list(map(lambda x: x**2, numbers))
evens = list(filter(lambda x: x % 2 == 0, numbers))

# Sorting with lambda
students = [("Alice", 85), ("Bob", 75), ("Charlie", 95)]
students.sort(key=lambda x: x[1])  # Sort by grade
```

### Function Annotations (Type Hints)
```python
def greet(name: str) -> str:
    """Greet a person by name."""
    return f"Hello, {name}!"

def add(x: int, y: int) -> int:
    """Add two integers."""
    return x + y

# More complex type hints
from typing import List, Dict, Optional, Union

def process_data(items: List[int]) -> Dict[str, Union[int, float]]:
    return {
        "count": len(items),
        "sum": sum(items),
        "average": sum(items) / len(items) if items else 0
    }
```

## V. Modules and Packages

### Importing Modules
```python
# Basic import
import math
print(math.pi)

# Import specific items
from math import pi, sqrt
print(pi)

# Import with alias
import numpy as np
import pandas as pd

# Import all (use sparingly)
from math import *

# Conditional imports
try:
    import numpy as np
    HAS_NUMPY = True
except ImportError:
    HAS_NUMPY = False
```

### Creating Modules
```python
# mymodule.py
def greet(name):
    return f"Hello, {name}!"

PI = 3.14159

class Calculator:
    def add(self, a, b):
        return a + b

# main.py
import mymodule
print(mymodule.greet("Alice"))
print(mymodule.PI)

calc = mymodule.Calculator()
print(calc.add(5, 3))
```

### Packages
```
mypackage/
    __init__.py
    module1.py
    module2.py
    subpackage/
        __init__.py
        module3.py
```

```python
# Importing from packages
from mypackage import module1
from mypackage.subpackage import module3
```

## VI. Classes and Objects (OOP)

### Basic Class Definition
```python
class Person:
    """A simple Person class."""
    
    # Class variable (shared by all instances)
    species = "Homo sapiens"
    
    def __init__(self, name, age):
        """Constructor method."""
        # Instance variables
        self.name = name
        self.age = age
    
    def greet(self):
        """Instance method."""
        return f"Hello, I'm {self.name}"
    
    def have_birthday(self):
        """Method that modifies state."""
        self.age += 1
        print(f"Happy birthday! {self.name} is now {self.age}")
    
    @classmethod
    def create_baby(cls, name):
        """Class method - alternative constructor."""
        return cls(name, 0)
    
    @staticmethod
    def is_adult(age):
        """Static method - doesn't access instance or class."""
        return age >= 18

# Creating instances
person1 = Person("Alice", 30)
person2 = Person("Bob", 25)

# Using methods
print(person1.greet())
person1.have_birthday()
```

### Inheritance
```python
class Student(Person):
    """Student inherits from Person."""
    
    def __init__(self, name, age, student_id):
        # Call parent constructor
        super().__init__(name, age)
        self.student_id = student_id
        self.courses = []
    
    def enroll(self, course):
        """Add a course."""
        self.courses.append(course)
    
    def greet(self):
        """Override parent method."""
        return f"{super().greet()}, I'm a student"

# Multiple inheritance
class Employee:
    def __init__(self, employee_id, salary):
        self.employee_id = employee_id
        self.salary = salary

class WorkingStudent(Student, Employee):
    def __init__(self, name, age, student_id, employee_id, salary):
        Student.__init__(self, name, age, student_id)
        Employee.__init__(self, employee_id, salary)
```

### Special Methods (Dunder Methods)
```python
class Book:
    def __init__(self, title, author, pages):
        self.title = title
        self.author = author
        self.pages = pages
    
    def __str__(self):
        """String representation for users."""
        return f"{self.title} by {self.author}"
    
    def __repr__(self):
        """String representation for developers."""
        return f"Book('{self.title}', '{self.author}', {self.pages})"
    
    def __len__(self):
        """Allow len() to work."""
        return self.pages
    
    def __eq__(self, other):
        """Define equality comparison."""
        if not isinstance(other, Book):
            return False
        return self.title == other.title and self.author == other.author
    
    def __lt__(self, other):
        """Define less than comparison."""
        return self.pages < other.pages
```

### Properties and Encapsulation
```python
class Temperature:
    def __init__(self, celsius=0):
        self._celsius = celsius
    
    @property
    def celsius(self):
        """Getter for celsius."""
        return self._celsius
    
    @celsius.setter
    def celsius(self, value):
        """Setter with validation."""
        if value < -273.15:
            raise ValueError("Temperature below absolute zero is not possible")
        self._celsius = value
    
    @property
    def fahrenheit(self):
        """Computed property."""
        return self._celsius * 9/5 + 32
    
    @fahrenheit.setter
    def fahrenheit(self, value):
        self._celsius = (value - 32) * 5/9

# Usage
temp = Temperature()
temp.celsius = 25
print(temp.fahrenheit)  # 77.0
```

## VII. File I/O (Input/Output)

### Reading Files
```python
# Basic file reading
file = open("filename.txt", "r")
content = file.read()
file.close()

# Using with statement (recommended)
with open("filename.txt", "r") as file:
    content = file.read()
    # File automatically closed after this block

# Different read methods
with open("filename.txt", "r") as file:
    # Read entire file
    content = file.read()
    
    # Read line by line
    file.seek(0)  # Reset to beginning
    line = file.readline()
    
    # Read all lines into list
    file.seek(0)
    lines = file.readlines()
    
    # Iterate over lines
    file.seek(0)
    for line in file:
        print(line.strip())
```

### Writing Files
```python
# Write mode (overwrites existing)
with open("output.txt", "w") as file:
    file.write("Hello, World!\n")
    file.write("Second line\n")

# Append mode
with open("output.txt", "a") as file:
    file.write("Appended line\n")

# Writing multiple lines
lines = ["Line 1\n", "Line 2\n", "Line 3\n"]
with open("output.txt", "w") as file:
    file.writelines(lines)
```

### Working with Different File Types
```python
# CSV files
import csv

# Reading CSV
with open("data.csv", "r") as file:
    csv_reader = csv.reader(file)
    headers = next(csv_reader)
    for row in csv_reader:
        print(row)

# Writing CSV
with open("output.csv", "w", newline="") as file:
    csv_writer = csv.writer(file)
    csv_writer.writerow(["Name", "Age", "City"])
    csv_writer.writerow(["Alice", 30, "NYC"])

# JSON files
import json

# Reading JSON
with open("data.json", "r") as file:
    data = json.load(file)

# Writing JSON
data = {"name": "Alice", "age": 30}
with open("output.json", "w") as file:
    json.dump(data, file, indent=4)

# Binary files
with open("image.jpg", "rb") as source:
    with open("copy.jpg", "wb") as dest:
        dest.write(source.read())
```

## VIII. Exception Handling

### Basic Exception Handling
```python
try:
    # Code that might raise an exception
    result = 10 / 0
except ZeroDivisionError:
    print("Cannot divide by zero!")

# Catching multiple exceptions
try:
    value = int(input("Enter a number: "))
    result = 10 / value
except ValueError:
    print("Invalid input - not a number!")
except ZeroDivisionError:
    print("Cannot divide by zero!")

# Catching any exception
try:
    # Some risky code
    pass
except Exception as e:
    print(f"An error occurred: {e}")
```

### Advanced Exception Handling
```python
try:
    file = open("data.txt", "r")
    data = file.read()
    value = int(data)
except FileNotFoundError:
    print("File not found!")
except ValueError:
    print("File doesn't contain a valid integer!")
else:
    # Executes if no exception occurred
    print(f"Successfully read value: {value}")
finally:
    # Always executes, even if there's an exception
    if 'file' in locals() and not file.closed:
        file.close()
    print("Cleanup complete")

# Raising exceptions
def validate_age(age):
    if age < 0:
        raise ValueError("Age cannot be negative")
    if age > 150:
        raise ValueError("Age seems unrealistic")
    return age

# Custom exceptions
class CustomError(Exception):
    """Custom exception class."""
    def __init__(self, message, code=None):
        super().__init__(message)
        self.code = code

# Using custom exceptions
try:
    raise CustomError("Something went wrong", code=500)
except CustomError as e:
    print(f"Error: {e}, Code: {e.code}")
```

## IX. List Comprehensions

### Basic List Comprehensions
```python
# Basic syntax: [expression for item in iterable]
squares = [x**2 for x in range(10)]
# [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]

# With condition
evens = [x for x in range(20) if x % 2 == 0]
# [0, 2, 4, 6, 8, 10, 12, 14, 16, 18]

# Multiple conditions
numbers = [x for x in range(100) if x % 2 == 0 if x % 3 == 0]
# Numbers divisible by both 2 and 3

# Nested list comprehensions
matrix = [[i * j for j in range(3)] for i in range(3)]
# [[0, 0, 0], [0, 1, 2], [0, 2, 4]]

# Flattening a list
nested = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
flat = [item for sublist in nested for item in sublist]
# [1, 2, 3, 4, 5, 6, 7, 8, 9]
```

### Other Comprehensions
```python
# Dictionary comprehensions
squares_dict = {x: x**2 for x in range(5)}
# {0: 0, 1: 1, 2: 4, 3: 9, 4: 16}

# Set comprehensions
unique_squares = {x**2 for x in [-2, -1, 0, 1, 2]}
# {0, 1, 4}

# Generator expressions (memory efficient)
squares_gen = (x**2 for x in range(10))
# Creates a generator object, not a list

# Using generator expressions
sum_of_squares = sum(x**2 for x in range(10))
```

## X. Common Libraries

### Built-in Libraries

#### os - Operating System Interface
```python
import os

# Working with paths
current_dir = os.getcwd()
os.chdir("/path/to/directory")
os.makedirs("new/directory/path", exist_ok=True)

# List files
files = os.listdir(".")
for file in files:
    if os.path.isfile(file):
        print(f"File: {file}")
    elif os.path.isdir(file):
        print(f"Directory: {file}")

# Environment variables
home = os.environ.get("HOME")
os.environ["MY_VAR"] = "value"

# Path operations
path = os.path.join("folder", "subfolder", "file.txt")
dirname = os.path.dirname(path)
basename = os.path.basename(path)
exists = os.path.exists(path)
```

#### datetime - Date and Time
```python
from datetime import datetime, date, time, timedelta

# Current date and time
now = datetime.now()
today = date.today()
current_time = datetime.now().time()

# Creating specific dates
birthday = date(1990, 5, 15)
meeting = datetime(2024, 1, 15, 14, 30)

# Formatting dates
formatted = now.strftime("%Y-%m-%d %H:%M:%S")
formatted_date = today.strftime("%B %d, %Y")

# Parsing dates
parsed = datetime.strptime("2024-01-15", "%Y-%m-%d")

# Date arithmetic
tomorrow = today + timedelta(days=1)
next_week = today + timedelta(weeks=1)
diff = tomorrow - today  # timedelta object
```

#### random - Random Number Generation
```python
import random

# Random numbers
random.random()          # Float between 0 and 1
random.randint(1, 10)    # Integer between 1 and 10 (inclusive)
random.uniform(1.0, 10.0)  # Float between 1.0 and 10.0

# Random choice
items = ["apple", "banana", "orange"]
random.choice(items)     # Single random item
random.sample(items, 2)  # Multiple unique items
random.shuffle(items)    # Shuffle in place

# Random with seed (reproducible)
random.seed(42)
random.randint(1, 100)   # Will always return same value with same seed
```

#### re - Regular Expressions
```python
import re

# Basic pattern matching
pattern = r"\d+"  # One or more digits
text = "I have 123 apples and 456 oranges"

# Find all matches
matches = re.findall(pattern, text)  # ['123', '456']

# Search for first match
match = re.search(r"(\d+) apples", text)
if match:
    print(match.group(0))  # "123 apples"
    print(match.group(1))  # "123"

# Replace
new_text = re.sub(r"\d+", "X", text)  # "I have X apples and X oranges"

# Compile patterns for reuse
email_pattern = re.compile(r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}")
if email_pattern.match("user@example.com"):
    print("Valid email")
```

## XI. Best Practices

### Code Style and Organization
1. **Follow PEP 8**: Use tools like `pylint`, `flake8`, or `black` for automatic formatting
2. **Write clear, descriptive variable names**: `user_count` instead of `uc`
3. **Use docstrings**: Document functions, classes, and modules
4. **Keep functions small**: Each function should do one thing well
5. **Avoid magic numbers**: Use named constants instead

### Error Handling
```python
# Good practice
def divide(a, b):
    """Safely divide two numbers."""
    try:
        return a / b
    except ZeroDivisionError:
        logger.error(f"Attempted to divide {a} by zero")
        return None
    except TypeError:
        logger.error(f"Invalid types: {type(a)}, {type(b)}")
        raise

# Using context managers for cleanup
from contextlib import contextmanager

@contextmanager
def managed_resource():
    resource = acquire_resource()
    try:
        yield resource
    finally:
        release_resource(resource)
```

### Testing
```python
# Unit testing example
import unittest

class TestCalculator(unittest.TestCase):
    def setUp(self):
        self.calc = Calculator()
    
    def test_addition(self):
        self.assertEqual(self.calc.add(2, 3), 5)
    
    def test_division_by_zero(self):
        with self.assertRaises(ZeroDivisionError):
            self.calc.divide(10, 0)

if __name__ == "__main__":
    unittest.main()
```

### Virtual Environments
```bash
# Create virtual environment
python -m venv myenv

# Activate (Linux/Mac)
source myenv/bin/activate

# Activate (Windows)
myenv\Scripts\activate

# Install packages
pip install requests numpy pandas

# Save dependencies
pip freeze > requirements.txt

# Install from requirements
pip install -r requirements.txt
```

## XII. Additional Important Concepts

### Decorators
```python
# Function decorator
def timer(func):
    import time
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"{func.__name__} took {end - start:.4f} seconds")
        return result
    return wrapper

@timer
def slow_function():
    import time
    time.sleep(1)
    return "Done"

# Class decorator
def add_repr(cls):
    def __repr__(self):
        return f"{cls.__name__}({self.__dict__})"
    cls.__repr__ = __repr__
    return cls

@add_repr
class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y
```

### Generators and Iterators
```python
# Generator function
def fibonacci(n):
    a, b = 0, 1
    for _ in range(n):
        yield a
        a, b = b, a + b

# Using generator
for num in fibonacci(10):
    print(num)

# Generator expression
squares = (x**2 for x in range(10))

# Custom iterator
class Counter:
    def __init__(self, start, end):
        self.current = start
        self.end = end
    
    def __iter__(self):
        return self
    
    def __next__(self):
        if self.current < self.end:
            self.current += 1
            return self.current - 1
        raise StopIteration
```

### Context Managers
```python
# Using with statement
with open("file.txt") as f:
    content = f.read()

# Custom context manager
class DatabaseConnection:
    def __enter__(self):
        self.connection = create_connection()
        return self.connection
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        self.connection.close()

# Using contextlib
from contextlib import contextmanager

@contextmanager
def temporary_change(obj, attr, new_value):
    old_value = getattr(obj, attr)
    setattr(obj, attr, new_value)
    try:
        yield
    finally:
        setattr(obj, attr, old_value)
```

### Advanced Data Structures
```python
# collections module
from collections import defaultdict, Counter, deque, namedtuple

# defaultdict
word_count = defaultdict(int)
for word in words:
    word_count[word] += 1

# Counter
letter_count = Counter("hello world")
most_common = letter_count.most_common(3)

# deque (double-ended queue)
queue = deque([1, 2, 3])
queue.append(4)      # Add to right
queue.appendleft(0)  # Add to left
queue.pop()          # Remove from right
queue.popleft()      # Remove from left

# namedtuple
Point = namedtuple('Point', ['x', 'y'])
p = Point(11, y=22)
print(p.x, p.y)
```

### Useful Built-in Functions
```python
# all() and any()
numbers = [1, 2, 3, 4, 5]
all(x > 0 for x in numbers)  # True
any(x > 4 for x in numbers)  # True

# enumerate()
for index, value in enumerate(['a', 'b', 'c']):
    print(f"{index}: {value}")

# zip()
names = ['Alice', 'Bob', 'Charlie']
ages = [25, 30, 35]
for name, age in zip(names, ages):
    print(f"{name} is {age}")

# map() and filter()
squared = list(map(lambda x: x**2, numbers))
evens = list(filter(lambda x: x % 2 == 0, numbers))

# sorted() with key
students = [('Alice', 85), ('Bob', 75), ('Charlie', 95)]
sorted_students = sorted(students, key=lambda x: x[1], reverse=True)

# reversed()
for item in reversed([1, 2, 3, 4, 5]):
    print(item)
```

---

*These notes cover the essential concepts of Python programming. Remember that the best way to learn is by practicing - write code, make mistakes, and learn from them!*