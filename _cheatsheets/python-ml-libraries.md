---
layout: cheatsheet
title: "Python ML Libraries Quick Reference"
description: "Essential commands and snippets for popular ML libraries"
date: 2025-04-20
categories: [ai-ml, python]
tags: [scikit-learn, tensorflow, pytorch, pandas, numpy]
---

## NumPy Essentials

```python
# Array creation
np.array([1, 2, 3])
np.zeros((3, 4))
np.ones((2, 3))
np.random.randn(3, 3)

# Array operations
a.reshape(2, -1)
a.T  # transpose
np.dot(a, b)
a @ b  # matrix multiplication
```

## Pandas Quick Commands

```python
# Reading data
df = pd.read_csv('file.csv')
df = pd.read_excel('file.xlsx')

# Basic exploration
df.head()
df.info()
df.describe()
df.shape

# Data manipulation
df.groupby('column').mean()
df.pivot_table(values='val', index='idx', columns='col')
df.merge(df2, on='key')
```

## Scikit-learn Workflow

```python
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression

# Split data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# Scale features
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Train model
model = LogisticRegression()
model.fit(X_train_scaled, y_train)

# Evaluate
score = model.score(X_test_scaled, y_test)
```
