---
layout: cheatsheet
title: "Python Cheatsheet"
description: "Comprehensive Python Notes"
date: 2025-01-05
categories: [ai-ml, python]
tags: [scikit-learn, tensorflow, pytorch, pandas, numpy]
---

# Python Comprehensive Cheatsheet

## Table of Contents
- [Python Comprehensive Cheatsheet](#python-comprehensive-cheatsheet)
  - [Table of Contents](#table-of-contents)
  - [Basic Syntax](#basic-syntax)
  - [Data Types](#data-types)
  - [Variables and Type Conversion](#variables-and-type-conversion)
  - [Operators](#operators)
  - [Control Flow](#control-flow)
  - [Functions](#functions)
  - [Data Structures](#data-structures)
    - [Lists](#lists)
    - [Tuples](#tuples)
    - [Dictionaries](#dictionaries)
    - [Sets](#sets)
  - [String Operations](#string-operations)
  - [List Operations](#list-operations)
  - [Dictionary Operations](#dictionary-operations)
  - [Set Operations](#set-operations)
  - [File Operations](#file-operations)
  - [Exception Handling](#exception-handling)
  - [Classes and OOP](#classes-and-oop)
  - [Modules and Packages](#modules-and-packages)
  - [List Comprehensions](#list-comprehensions)
  - [Lambda Functions](#lambda-functions)
  - [Decorators](#decorators)
  - [Generators](#generators)
  - [Regular Expressions](#regular-expressions)
  - [Common Built-in Functions](#common-built-in-functions)
  - [Useful Standard Library Modules](#useful-standard-library-modules)
  - [Tips and Best Practices](#tips-and-best-practices)
  - [Common Gotchas](#common-gotchas)

## Basic Syntax

```python
# Single line comment

"""
Multi-line comment
or docstring
"""

# Print statement
print("Hello, World!")
print("Value:", 42)
print(f"Formatted string: {variable}")

# Input
name = input("Enter your name: ")
age = int(input("Enter your age: "))  # Convert to integer
```

## Data Types

```python
# Numeric Types
integer = 42
float_num = 3.14
complex_num = 3 + 4j

# Boolean
is_true = True
is_false = False

# String
single_quote = 'Hello'
double_quote = "World"
multi_line = """Multiple
lines"""

# None Type
empty_value = None

# Type checking
print(type(42))           # <class 'int'>
print(isinstance(42, int)) # True
```

## Variables and Type Conversion

```python
# Variable assignment
x = 5
y = "Hello"
x, y = 5, "Hello"  # Multiple assignment
a = b = c = 0      # Chain assignment

# Type conversion
str_to_int = int("42")
str_to_float = float("3.14")
int_to_str = str(42)
list_to_tuple = tuple([1, 2, 3])
tuple_to_list = list((1, 2, 3))
char_to_ascii = ord('A')  # 65
ascii_to_char = chr(65)   # 'A'
```

## Operators

```python
# Arithmetic
a + b   # Addition
a - b   # Subtraction
a * b   # Multiplication
a / b   # Division (float)
a // b  # Floor division
a % b   # Modulus
a ** b  # Exponentiation

# Comparison
a == b  # Equal
a != b  # Not equal
a > b   # Greater than
a < b   # Less than
a >= b  # Greater than or equal
a <= b  # Less than or equal

# Logical
a and b
a or b
not a

# Bitwise
a & b   # AND
a | b   # OR
a ^ b   # XOR
~a      # NOT
a << n  # Left shift
a >> n  # Right shift

# Assignment operators
a += b  # a = a + b
a -= b  # a = a - b
a *= b  # a = a * b
a /= b  # a = a / b
a //= b # a = a // b
a %= b  # a = a % b
a **= b # a = a ** b

# Identity operators
a is b
a is not b

# Membership operators
a in b
a not in b
```

## Control Flow

```python
# If-elif-else
if condition:
    # code block
elif another_condition:
    # code block
else:
    # code block

# Ternary operator
result = value_if_true if condition else value_if_false

# For loop
for i in range(5):
    print(i)  # 0, 1, 2, 3, 4

for i in range(2, 10, 2):
    print(i)  # 2, 4, 6, 8

for item in iterable:
    # process item
    pass

# While loop
while condition:
    # code block
    break     # Exit loop
    continue  # Skip to next iteration

# Loop with else
for i in range(5):
    if i == 10:
        break
else:
    print("Loop completed without break")
```

## Functions

```python
# Basic function
def greet(name):
    return f"Hello, {name}!"

# Default parameters
def greet(name="World"):
    return f"Hello, {name}!"

# Variable arguments
def sum_all(*args):
    return sum(args)

# Keyword arguments
def create_profile(**kwargs):
    return kwargs

# Mixed parameters
def complex_func(pos1, pos2, *args, kw1="default", **kwargs):
    pass

# Annotations
def add(x: int, y: int) -> int:
    return x + y

# Docstrings
def calculate_area(radius):
    """
    Calculate the area of a circle.
    
    Args:
        radius (float): The radius of the circle
        
    Returns:
        float: The area of the circle
    """
    return 3.14159 * radius ** 2
```

## Data Structures

### Lists
```python
# Creating lists
empty_list = []
numbers = [1, 2, 3, 4, 5]
mixed = [1, "hello", 3.14, True]

# Accessing elements
first = numbers[0]      # 1
last = numbers[-1]      # 5
slice = numbers[1:4]    # [2, 3, 4]
step = numbers[::2]     # [1, 3, 5]
reversed = numbers[::-1] # [5, 4, 3, 2, 1]
```

### Tuples
```python
# Creating tuples (immutable)
empty_tuple = ()
single = (1,)  # Note the comma
coordinates = (3, 4)
mixed = (1, "hello", 3.14)

# Unpacking
x, y = coordinates
first, *rest = (1, 2, 3, 4)  # first=1, rest=[2, 3, 4]
```

### Dictionaries
```python
# Creating dictionaries
empty_dict = {}
person = {"name": "Alice", "age": 30}
person = dict(name="Alice", age=30)

# Accessing values
name = person["name"]
age = person.get("age", 0)  # With default value

# Dictionary comprehension
squares = {x: x**2 for x in range(5)}
```

### Sets
```python
# Creating sets
empty_set = set()
numbers = {1, 2, 3, 4, 5}
from_list = set([1, 2, 3, 3, 4])  # {1, 2, 3, 4}

# Set comprehension
even_squares = {x**2 for x in range(10) if x % 2 == 0}
```

## String Operations

```python
# String methods
s = "Hello, World!"
s.lower()          # "hello, world!"
s.upper()          # "HELLO, WORLD!"
s.title()          # "Hello, World!"
s.strip()          # Remove whitespace
s.lstrip()         # Remove left whitespace
s.rstrip()         # Remove right whitespace
s.replace("o", "0") # "Hell0, W0rld!"
s.split(", ")      # ["Hello", "World!"]
", ".join(["a", "b"]) # "a, b"
s.startswith("Hello") # True
s.endswith("!")    # True
s.find("World")    # 7 (index)
s.count("l")       # 3

# String formatting
name, age = "Alice", 30
f"Name: {name}, Age: {age}"          # f-strings (3.6+)
"Name: {}, Age: {}".format(name, age) # format method
"Name: %s, Age: %d" % (name, age)    # % formatting (old)

# Multi-line strings
multi = """Line 1
Line 2
Line 3"""

# Raw strings (no escape sequences)
path = r"C:\Users\name\Documents"
```

## List Operations

```python
# List methods
lst = [1, 2, 3]
lst.append(4)           # [1, 2, 3, 4]
lst.extend([5, 6])      # [1, 2, 3, 4, 5, 6]
lst.insert(0, 0)        # [0, 1, 2, 3, 4, 5, 6]
lst.remove(3)           # Remove first occurrence
popped = lst.pop()      # Remove and return last
popped = lst.pop(0)     # Remove and return at index
lst.clear()             # Empty the list

# List operations
lst = [3, 1, 4, 1, 5]
lst.sort()              # Sort in place
sorted_lst = sorted(lst) # Return new sorted list
lst.reverse()           # Reverse in place
count = lst.count(1)    # Count occurrences
index = lst.index(4)    # Find index of value

# Copying lists
shallow_copy = lst.copy()
shallow_copy = lst[:]
import copy
deep_copy = copy.deepcopy(lst)
```

## Dictionary Operations

```python
# Dictionary methods
d = {"a": 1, "b": 2}
d["c"] = 3              # Add/update
d.update({"d": 4})      # Update from another dict
value = d.pop("a")      # Remove and return
d.popitem()             # Remove and return arbitrary pair
d.clear()               # Empty dictionary

# Dictionary methods
keys = d.keys()         # dict_keys view
values = d.values()     # dict_values view
items = d.items()       # dict_items view
d.setdefault("e", 5)    # Set if not exists

# Merging dictionaries (3.9+)
merged = dict1 | dict2
dict1 |= dict2          # Update dict1

# Dictionary from lists
keys = ["a", "b", "c"]
values = [1, 2, 3]
d = dict(zip(keys, values))
```

## Set Operations

```python
set1 = {1, 2, 3, 4}
set2 = {3, 4, 5, 6}

# Set operations
union = set1 | set2           # {1, 2, 3, 4, 5, 6}
intersection = set1 & set2    # {3, 4}
difference = set1 - set2      # {1, 2}
sym_diff = set1 ^ set2        # {1, 2, 5, 6}

# Set methods
set1.add(5)
set1.remove(1)      # Raises error if not found
set1.discard(1)     # No error if not found
set1.update([6, 7])
set1.clear()

# Set comparisons
set1.issubset(set2)
set1.issuperset(set2)
set1.isdisjoint(set2)
```

## File Operations

```python
# Reading files
with open("file.txt", "r") as f:
    content = f.read()         # Read entire file
    lines = f.readlines()      # Read all lines into list
    line = f.readline()        # Read one line

# Writing files
with open("file.txt", "w") as f:
    f.write("Hello, World!")
    f.writelines(["Line 1\n", "Line 2\n"])

# Append mode
with open("file.txt", "a") as f:
    f.write("Appended text")

# Binary mode
with open("file.bin", "rb") as f:
    data = f.read()

# File operations
import os
os.path.exists("file.txt")
os.path.isfile("file.txt")
os.path.isdir("folder")
os.remove("file.txt")
os.rename("old.txt", "new.txt")
```

## Exception Handling

```python
# Basic try-except
try:
    result = 10 / 0
except ZeroDivisionError:
    print("Cannot divide by zero")

# Multiple exceptions
try:
    # code
    pass
except (ValueError, TypeError) as e:
    print(f"Error: {e}")
except Exception as e:
    print(f"Unexpected error: {e}")

# Try-except-else-finally
try:
    file = open("file.txt")
except FileNotFoundError:
    print("File not found")
else:
    # Executes if no exception
    content = file.read()
finally:
    # Always executes
    file.close() if 'file' in locals() else None

# Raising exceptions
raise ValueError("Invalid value")
raise Exception("Custom error message")

# Custom exceptions
class CustomError(Exception):
    pass
```

## Classes and OOP

```python
# Basic class
class Dog:
    # Class variable
    species = "Canis familiaris"
    
    # Constructor
    def __init__(self, name, age):
        self.name = name  # Instance variable
        self.age = age
    
    # Instance method
    def bark(self):
        return f"{self.name} says Woof!"
    
    # String representation
    def __str__(self):
        return f"{self.name} is {self.age} years old"
    
    # Class method
    @classmethod
    def create_puppy(cls, name):
        return cls(name, 0)
    
    # Static method
    @staticmethod
    def is_adult(age):
        return age >= 2

# Inheritance
class GoldenRetriever(Dog):
    def __init__(self, name, age, color="golden"):
        super().__init__(name, age)
        self.color = color
    
    # Method overriding
    def bark(self):
        return f"{self.name} says Woof! (happily)"

# Multiple inheritance
class A:
    pass

class B:
    pass

class C(A, B):
    pass

# Property decorator
class Temperature:
    def __init__(self):
        self._celsius = 0
    
    @property
    def celsius(self):
        return self._celsius
    
    @celsius.setter
    def celsius(self, value):
        if value < -273.15:
            raise ValueError("Temperature below absolute zero")
        self._celsius = value
```

## Modules and Packages

```python
# Importing modules
import math
from math import pi, sqrt
from math import pi as PI
import numpy as np

# Import all (avoid in production)
from math import *

# Conditional imports
try:
    import numpy as np
    HAS_NUMPY = True
except ImportError:
    HAS_NUMPY = False

# Module attributes
print(__name__)  # Current module name
print(__file__)  # Current file path

# Creating modules
# In mymodule.py:
def my_function():
    return "Hello from mymodule"

# In main.py:
import mymodule
result = mymodule.my_function()
```

## List Comprehensions

```python
# Basic list comprehension
squares = [x**2 for x in range(10)]

# With condition
evens = [x for x in range(20) if x % 2 == 0]

# Nested comprehension
matrix = [[i*j for j in range(3)] for i in range(3)]

# Multiple conditions
filtered = [x for x in range(100) if x % 2 == 0 if x % 3 == 0]

# Dictionary comprehension
word_lengths = {word: len(word) for word in ["hello", "world"]}

# Set comprehension
unique_lengths = {len(word) for word in ["hello", "world", "hi"]}

# Generator expression
gen = (x**2 for x in range(10))
```

## Lambda Functions

```python
# Basic lambda
square = lambda x: x**2

# Multiple arguments
add = lambda x, y: x + y

# In higher-order functions
numbers = [1, 2, 3, 4, 5]
squared = list(map(lambda x: x**2, numbers))
evens = list(filter(lambda x: x % 2 == 0, numbers))

# Sorting with lambda
students = [("Alice", 85), ("Bob", 75), ("Charlie", 95)]
students.sort(key=lambda x: x[1])  # Sort by grade

# Immediately invoked lambda
result = (lambda x: x**2)(5)  # 25
```

## Decorators

```python
# Basic decorator
def uppercase_decorator(func):
    def wrapper(*args, **kwargs):
        result = func(*args, **kwargs)
        return result.upper()
    return wrapper

@uppercase_decorator
def greet(name):
    return f"hello, {name}"

# Decorator with arguments
def repeat(times):
    def decorator(func):
        def wrapper(*args, **kwargs):
            for _ in range(times):
                result = func(*args, **kwargs)
            return result
        return wrapper
    return decorator

@repeat(3)
def say_hello():
    print("Hello!")

# Class decorator
def add_repr(cls):
    def __repr__(self):
        return f"{cls.__name__}({self.__dict__})"
    cls.__repr__ = __repr__
    return cls

@add_repr
class Person:
    def __init__(self, name):
        self.name = name

# Property decorator
class Circle:
    def __init__(self, radius):
        self._radius = radius
    
    @property
    def area(self):
        return 3.14159 * self._radius ** 2
```

## Generators

```python
# Generator function
def countdown(n):
    while n > 0:
        yield n
        n -= 1

# Using generators
for num in countdown(5):
    print(num)

# Generator expression
squares_gen = (x**2 for x in range(10))

# Infinite generator
def fibonacci():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

# Generator with send()
def accumulator():
    total = 0
    while True:
        value = yield total
        if value is not None:
            total += value

# Using itertools
import itertools
counter = itertools.count(start=1, step=2)
cycler = itertools.cycle(['A', 'B', 'C'])
```

## Regular Expressions

```python
import re

# Basic patterns
pattern = r'\d+'  # One or more digits
text = "I have 123 apples and 456 oranges"

# Finding matches
match = re.search(pattern, text)  # First match
matches = re.findall(pattern, text)  # All matches
matches = re.finditer(pattern, text)  # Iterator of match objects

# Pattern matching
if re.match(r'^\d+$', "12345"):  # Start of string
    print("String contains only digits")

# Substitution
new_text = re.sub(r'\d+', 'X', text)  # Replace all numbers with X

# Groups
pattern = r'(\w+)@(\w+)\.(\w+)'
match = re.search(pattern, 'user@example.com')
if match:
    username = match.group(1)
    domain = match.group(2)
    tld = match.group(3)

# Named groups
pattern = r'(?P<username>\w+)@(?P<domain>\w+)\.(?P<tld>\w+)'

# Common patterns
patterns = {
    'email': r'^[\w\.-]+@[\w\.-]+\.\w+$',
    'url': r'https?://(?:www\.)?[\w\.-]+\.\w+',
    'phone': r'^\+?1?\d{9,15}$',
    'date': r'\d{4}-\d{2}-\d{2}',
}

# Flags
re.search(pattern, text, re.IGNORECASE)
re.search(pattern, text, re.MULTILINE)
```

## Common Built-in Functions

```python
# Type conversion
int(), float(), str(), bool(), list(), tuple(), set(), dict()

# Math functions
abs(-5)           # 5
round(3.7)        # 4
round(3.14159, 2) # 3.14
min([1, 2, 3])    # 1
max([1, 2, 3])    # 3
sum([1, 2, 3])    # 6
pow(2, 3)         # 8

# Sequence functions
len([1, 2, 3])    # 3
sorted([3, 1, 2]) # [1, 2, 3]
reversed([1, 2, 3]) # Iterator
list(range(5))    # [0, 1, 2, 3, 4]

# Functional programming
map(lambda x: x**2, [1, 2, 3])     # [1, 4, 9]
filter(lambda x: x > 0, [-1, 1, 2]) # [1, 2]
zip([1, 2], ['a', 'b'])             # [(1, 'a'), (2, 'b')]

# Object functions
dir(object)       # List attributes
vars(object)      # Object's __dict__
hasattr(obj, 'attr')
getattr(obj, 'attr', default)
setattr(obj, 'attr', value)

# Iteration
enumerate(['a', 'b', 'c'])  # [(0, 'a'), (1, 'b'), (2, 'c')]
all([True, True, False])    # False
any([False, False, True])   # True

# Others
print(*args, sep=' ', end='\n')
input(prompt)
open(file, mode='r')
eval('2 + 2')     # 4 (use carefully!)
exec('x = 5')     # Execute Python code
```

## Useful Standard Library Modules

```python
# datetime
from datetime import datetime, date, time, timedelta
now = datetime.now()
today = date.today()
tomorrow = today + timedelta(days=1)

# collections
from collections import Counter, defaultdict, namedtuple, deque
counter = Counter(['a', 'b', 'a', 'c', 'b', 'a'])
dd = defaultdict(list)
Point = namedtuple('Point', ['x', 'y'])
queue = deque([1, 2, 3])

# itertools
import itertools
combinations = itertools.combinations([1, 2, 3], 2)
permutations = itertools.permutations([1, 2, 3])
product = itertools.product([1, 2], ['a', 'b'])

# random
import random
random.randint(1, 10)
random.choice(['a', 'b', 'c'])
random.shuffle(lst)
random.sample(population, k=3)

# os and pathlib
import os
from pathlib import Path
current_dir = os.getcwd()
path = Path('/home/user/file.txt')
path.exists()
path.is_file()

# json
import json
json_string = json.dumps({'key': 'value'})
data = json.loads(json_string)

# math
import math
math.pi, math.e
math.sqrt(16)
math.factorial(5)
math.gcd(48, 18)

# sys
import sys
sys.argv      # Command line arguments
sys.exit()    # Exit program
sys.path      # Module search path
```

## Tips and Best Practices

1. **Use descriptive variable names**: `user_age` instead of `a`
2. **Follow PEP 8**: Python's style guide for consistent code
3. **Use type hints**: Help with code clarity and IDE support
4. **Prefer list comprehensions**: More Pythonic than traditional loops for simple operations
5. **Use context managers**: `with` statement for file operations
6. **Handle exceptions properly**: Don't use bare `except:` clauses
7. **Use f-strings**: Most readable string formatting (Python 3.6+)
8. **Virtual environments**: Keep project dependencies isolated
9. **Document your code**: Use docstrings and comments appropriately
10. **Test your code**: Write unit tests for important functions

## Common Gotchas

```python
# Mutable default arguments
def bad(lst=[]):  # Don't do this!
    lst.append(1)
    return lst

def good(lst=None):  # Do this instead
    if lst is None:
        lst = []
    lst.append(1)
    return lst

# Integer division changed in Python 3
5 / 2   # 2.5 in Python 3, 2 in Python 2
5 // 2  # 2 (floor division)

# List multiplication creates references
matrix = [[0] * 3] * 3  # Wrong! Creates references
matrix = [[0] * 3 for _ in range(3)]  # Correct

# Late binding in closures
funcs = []
for i in range(3):
    funcs.append(lambda: i)  # All return 2
# Fix:
funcs = []
for i in range(3):
    funcs.append(lambda i=i: i)  # Capture current value
```

---

*This cheatsheet covers Python 3.x syntax and features. Keep it handy as a quick reference!*
