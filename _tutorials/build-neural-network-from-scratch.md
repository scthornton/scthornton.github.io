---
layout: tutorial
title: "Building a Neural Network from Scratch in Python"
description: "Understand neural networks by implementing one using only NumPy"
date: 2025-01-20
categories: [ai-ml, python]
difficulty: intermediate
toc: true
prerequisites:
  - "Basic Python knowledge"
  - "Understanding of derivatives"
  - "Familiarity with NumPy"
tags: [neural-networks, numpy, backpropagation, deep-learning]
github_repo: https://github.com/scthornton/nn-from-scratch
featured: true
---

## Introduction

Building a neural network from scratch is the best way to truly understand how they work. We'll implement a simple feedforward network using only NumPy.

## Setting Up

First, let's import NumPy and set up our environment:

```python
import numpy as np
import matplotlib.pyplot as plt

# Set random seed for reproducibility
np.random.seed(42)
```

## The Neural Network Class

We'll create a flexible neural network class:

```python
class NeuralNetwork:
    def __init__(self, layers):
        self.layers = layers
        self.weights = []
        self.biases = []
        
        # Initialize weights and biases
        for i in range(len(layers) - 1):
            w = np.random.randn(layers[i], layers[i+1]) * 0.1
            b = np.zeros((1, layers[i+1]))
            self.weights.append(w)
            self.biases.append(b)
```

## Forward Propagation

The forward pass computes the network's output:

```python
def forward(self, X):
    self.activations = [X]
    
    for i in range(len(self.weights)):
        z = np.dot(self.activations[-1], self.weights[i]) + self.biases[i]
        a = self.sigmoid(z) if i < len(self.weights) - 1 else z
        self.activations.append(a)
    
    return self.activations[-1]
```

Continue building your understanding of neural networks!
