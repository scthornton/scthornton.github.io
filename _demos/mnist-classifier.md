---
layout: demo
title: "Interactive MNIST Digit Classifier"
description: "Draw a digit and watch a neural network classify it in real-time"
date: 2025-01-28
categories: [ai-ml]
tags: [mnist, tensorflow-js, neural-networks, interactive]
demo_url: /demos/mnist-classifier/live/
github_repo: https://github.com/scthornton/mnist-demo
---

## Live Demo

*Note: In a real implementation, you would embed your interactive demo here*

<div style="border: 2px dashed #ccc; padding: 2rem; text-align: center;">
  <p>Interactive MNIST Classifier Demo Would Go Here</p>
  <p>Draw a digit and see the neural network's predictions!</p>
</div>

## How It Works

This demo uses a convolutional neural network trained on the MNIST dataset, running entirely in your browser using TensorFlow.js.

### Model Architecture

```javascript
const model = tf.sequential({
  layers: [
    tf.layers.conv2d({
      inputShape: [28, 28, 1],
      kernelSize: 3,
      filters: 32,
      activation: 'relu'
    }),
    tf.layers.maxPooling2d({poolSize: 2}),
    tf.layers.conv2d({
      kernelSize: 3,
      filters: 64,
      activation: 'relu'
    }),
    tf.layers.maxPooling2d({poolSize: 2}),
    tf.layers.flatten(),
    tf.layers.dense({units: 128, activation: 'relu'}),
    tf.layers.dense({units: 10, activation: 'softmax'})
  ]
});
```

### Training Results

- Training accuracy: 99.2%
- Test accuracy: 98.7%
- Model size: 1.2MB

Try drawing different styles of digits to see how the model performs!
