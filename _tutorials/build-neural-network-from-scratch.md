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

# Building a Neural Network from Scratch in Python

*Understand neural networks by implementing one using only NumPy*

## Prerequisites
- Basic Python knowledge
- Understanding of derivatives and calculus
- Familiarity with NumPy
- Basic understanding of linear algebra (matrix multiplication)

## Introduction

Building a neural network from scratch is the best way to truly understand how they work. We'll implement a complete feedforward network using only NumPy, including forward propagation, backpropagation, and training on real data.

By the end of this tutorial, you'll have a working neural network that can:
- Learn from data through backpropagation
- Make predictions on new examples
- Classify data points with high accuracy

## Setting Up

First, let's import the necessary libraries and set up our environment:

```python
import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import make_classification, make_circles
from sklearn.model_selection import train_test_split
import seaborn as sns

# Set random seed for reproducibility
np.random.seed(42)
plt.style.use('seaborn-v0_8')
```

## The Complete Neural Network Class

We'll create a flexible neural network class that can handle multiple layers and different activation functions:

```python
class NeuralNetwork:
    def __init__(self, layers, learning_rate=0.01):
        """
        Initialize the neural network
        
        Args:
            layers: List of integers representing the number of neurons in each layer
            learning_rate: Learning rate for gradient descent
        """
        self.layers = layers
        self.learning_rate = learning_rate
        self.weights = []
        self.biases = []
        self.costs = []  # To track training progress
        
        # Initialize weights and biases using Xavier initialization
        for i in range(len(layers) - 1):
            # Xavier initialization for better convergence
            w = np.random.randn(layers[i], layers[i+1]) * np.sqrt(2.0 / layers[i])
            b = np.zeros((1, layers[i+1]))
            self.weights.append(w)
            self.biases.append(b)
    
    def sigmoid(self, z):
        """Sigmoid activation function"""
        # Clip z to prevent overflow
        z = np.clip(z, -500, 500)
        return 1 / (1 + np.exp(-z))
    
    def sigmoid_derivative(self, z):
        """Derivative of sigmoid function"""
        s = self.sigmoid(z)
        return s * (1 - s)
    
    def relu(self, z):
        """ReLU activation function"""
        return np.maximum(0, z)
    
    def relu_derivative(self, z):
        """Derivative of ReLU function"""
        return (z > 0).astype(float)
    
    def tanh(self, z):
        """Tanh activation function"""
        return np.tanh(z)
    
    def tanh_derivative(self, z):
        """Derivative of tanh function"""
        return 1 - np.tanh(z)**2
```

## Forward Propagation

The forward pass computes the network's output by propagating input through all layers:

```python
    def forward(self, X):
        """
        Forward propagation through the network
        
        Args:
            X: Input data of shape (m, n_features)
            
        Returns:
            Output of the network
        """
        self.z_values = []  # Store z values for backpropagation
        self.activations = [X]  # Store activations for backpropagation
        
        current_input = X
        
        for i in range(len(self.weights)):
            # Linear transformation: z = Wx + b
            z = np.dot(current_input, self.weights[i]) + self.biases[i]
            self.z_values.append(z)
            
            # Apply activation function
            if i < len(self.weights) - 1:  # Hidden layers use sigmoid
                a = self.sigmoid(z)
            else:  # Output layer (no activation for regression, sigmoid for binary classification)
                a = self.sigmoid(z)  # For binary classification
            
            self.activations.append(a)
            current_input = a
        
        return self.activations[-1]
```

## Backward Propagation (Backpropagation)

This is where the magic happens - the network learns by computing gradients and updating weights:

```python
    def backward(self, X, y, output):
        """
        Backward propagation to compute gradients
        
        Args:
            X: Input data
            y: True labels
            output: Network output from forward pass
        """
        m = X.shape[0]  # Number of training examples
        
        # Initialize gradients
        dW = [np.zeros_like(w) for w in self.weights]
        db = [np.zeros_like(b) for b in self.biases]
        
        # Start with output layer error
        # For binary classification with sigmoid output
        dz = output - y
        
        # Backpropagate through each layer
        for i in reversed(range(len(self.weights))):
            # Compute gradients for weights and biases
            dW[i] = (1/m) * np.dot(self.activations[i].T, dz)
            db[i] = (1/m) * np.sum(dz, axis=0, keepdims=True)
            
            # Compute error for previous layer (if not input layer)
            if i > 0:
                dz = np.dot(dz, self.weights[i].T) * self.sigmoid_derivative(self.z_values[i-1])
        
        return dW, db
    
    def update_parameters(self, dW, db):
        """
        Update weights and biases using computed gradients
        
        Args:
            dW: Gradients for weights
            db: Gradients for biases
        """
        for i in range(len(self.weights)):
            self.weights[i] -= self.learning_rate * dW[i]
            self.biases[i] -= self.learning_rate * db[i]
```

## Loss Functions and Training

Let's add methods to compute loss and train the network:

```python
    def compute_cost(self, y_true, y_pred):
        """
        Compute binary cross-entropy loss
        
        Args:
            y_true: True labels
            y_pred: Predicted probabilities
            
        Returns:
            Average loss
        """
        m = y_true.shape[0]
        # Prevent log(0) by adding small epsilon
        epsilon = 1e-15
        y_pred = np.clip(y_pred, epsilon, 1 - epsilon)
        
        cost = -(1/m) * np.sum(y_true * np.log(y_pred) + (1 - y_true) * np.log(1 - y_pred))
        return cost
    
    def train(self, X, y, epochs=1000, print_cost=True):
        """
        Train the neural network
        
        Args:
            X: Training data
            y: Training labels
            epochs: Number of training iterations
            print_cost: Whether to print cost during training
        """
        for epoch in range(epochs):
            # Forward propagation
            output = self.forward(X)
            
            # Compute cost
            cost = self.compute_cost(y, output)
            self.costs.append(cost)
            
            # Backward propagation
            dW, db = self.backward(X, y, output)
            
            # Update parameters
            self.update_parameters(dW, db)
            
            # Print progress
            if print_cost and epoch % 100 == 0:
                print(f"Cost after epoch {epoch}: {cost:.6f}")
    
    def predict(self, X):
        """
        Make predictions on new data
        
        Args:
            X: Input data
            
        Returns:
            Predictions (probabilities for binary classification)
        """
        return self.forward(X)
    
    def predict_classes(self, X, threshold=0.5):
        """
        Make class predictions
        
        Args:
            X: Input data
            threshold: Decision threshold
            
        Returns:
            Predicted classes (0 or 1)
        """
        probabilities = self.predict(X)
        return (probabilities > threshold).astype(int)
```

## Practical Example 1: Binary Classification

Let's test our neural network on a binary classification problem:

```python
# Generate synthetic dataset
X, y = make_classification(n_samples=1000, n_features=2, n_redundant=0, 
                         n_informative=2, random_state=42, n_clusters_per_class=1)
y = y.reshape(-1, 1)  # Reshape for our network

# Split the data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Create and train the network
nn = NeuralNetwork(layers=[2, 4, 3, 1], learning_rate=0.1)
nn.train(X_train, y_train, epochs=2000)

# Make predictions
train_predictions = nn.predict_classes(X_train)
test_predictions = nn.predict_classes(X_test)

# Calculate accuracy
train_accuracy = np.mean(train_predictions == y_train) * 100
test_accuracy = np.mean(test_predictions == y_test) * 100

print(f"Training Accuracy: {train_accuracy:.2f}%")
print(f"Test Accuracy: {test_accuracy:.2f}%")
```

## Practical Example 2: XOR Problem

The XOR problem is a classic test for neural networks because it's not linearly separable:

```python
# XOR dataset
X_xor = np.array([[0, 0], [0, 1], [1, 0], [1, 1]])
y_xor = np.array([[0], [1], [1], [0]])

print("Training on XOR problem...")
nn_xor = NeuralNetwork(layers=[2, 4, 1], learning_rate=1.0)
nn_xor.train(X_xor, y_xor, epochs=5000)

# Test XOR predictions
xor_predictions = nn_xor.predict(X_xor)
print("\nXOR Results:")
for i in range(len(X_xor)):
    print(f"Input: {X_xor[i]} -> Output: {xor_predictions[i][0]:.3f} -> Predicted: {int(xor_predictions[i][0] > 0.5)}")
```

## Visualization and Analysis

Let's add some helpful visualization functions:

```python
def plot_training_history(nn):
    """Plot the training cost over time"""
    plt.figure(figsize=(10, 6))
    plt.plot(nn.costs)
    plt.title('Training Cost Over Time')
    plt.xlabel('Epoch')
    plt.ylabel('Cost')
    plt.grid(True)
    plt.show()

def plot_decision_boundary(nn, X, y, title="Decision Boundary"):
    """Plot the decision boundary learned by the network"""
    plt.figure(figsize=(10, 8))
    
    # Create a mesh to plot the decision boundary
    h = 0.01
    x_min, x_max = X[:, 0].min() - 1, X[:, 0].max() + 1
    y_min, y_max = X[:, 1].min() - 1, X[:, 1].max() + 1
    xx, yy = np.meshgrid(np.arange(x_min, x_max, h),
                        np.arange(y_min, y_max, h))
    
    # Make predictions on the mesh
    mesh_points = np.c_[xx.ravel(), yy.ravel()]
    Z = nn.predict(mesh_points)
    Z = Z.reshape(xx.shape)
    
    # Plot the contour and training examples
    plt.contourf(xx, yy, Z, levels=50, alpha=0.8, cmap=plt.cm.RdYlBu)
    scatter = plt.scatter(X[:, 0], X[:, 1], c=y.ravel(), cmap=plt.cm.RdYlBu, edgecolors='black')
    plt.colorbar(scatter)
    plt.title(title)
    plt.xlabel('Feature 1')
    plt.ylabel('Feature 2')
    plt.show()

# Visualize results
plot_training_history(nn)
plot_decision_boundary(nn, X_test, y_test, "Neural Network Decision Boundary")
```

## Advanced Features

### Adding Different Activation Functions

You can experiment with different activation functions by modifying the forward method:

```python
def forward_with_relu(self, X):
    """Alternative forward pass using ReLU for hidden layers"""
    self.z_values = []
    self.activations = [X]
    
    current_input = X
    
    for i in range(len(self.weights)):
        z = np.dot(current_input, self.weights[i]) + self.biases[i]
        self.z_values.append(z)
        
        if i < len(self.weights) - 1:  # Hidden layers use ReLU
            a = self.relu(z)
        else:  # Output layer uses sigmoid
            a = self.sigmoid(z)
        
        self.activations.append(a)
        current_input = a
    
    return self.activations[-1]
```

### Adding Regularization

```python
def compute_cost_with_regularization(self, y_true, y_pred, lambda_reg=0.01):
    """Compute cost with L2 regularization"""
    m = y_true.shape[0]
    epsilon = 1e-15
    y_pred = np.clip(y_pred, epsilon, 1 - epsilon)
    
    # Cross-entropy cost
    cross_entropy_cost = -(1/m) * np.sum(y_true * np.log(y_pred) + (1 - y_true) * np.log(1 - y_pred))
    
    # L2 regularization cost
    l2_cost = 0
    for w in self.weights:
        l2_cost += np.sum(w**2)
    l2_cost = (lambda_reg / (2 * m)) * l2_cost
    
    return cross_entropy_cost + l2_cost
```

## Key Takeaways

1. **Forward Propagation**: Data flows through the network, applying weights, biases, and activation functions
2. **Backpropagation**: Gradients are computed using the chain rule of calculus
3. **Parameter Updates**: Weights and biases are adjusted using gradient descent
4. **Activation Functions**: Non-linear functions that allow networks to learn complex patterns
5. **Cost Functions**: Measure how well the network is performing and guide learning

## Common Issues and Solutions

1. **Vanishing Gradients**: Use ReLU activation or proper weight initialization
2. **Exploding Gradients**: Use gradient clipping or smaller learning rates
3. **Overfitting**: Add regularization or use dropout
4. **Slow Convergence**: Adjust learning rate or use better optimizers

## Next Steps

Now that you have a working neural network from scratch, you can:
- Experiment with different architectures
- Try different datasets
- Implement other optimizers (Adam, RMSprop)
- Add batch normalization
- Implement convolutional or recurrent layers

This foundation will help you understand more advanced deep learning frameworks like TensorFlow and PyTorch!
