# My Technical Blog

A GitHub Pages blog focused on AI/ML, Security, Networking, and Python.

## Quick Start

1. Install Jekyll: `gem install jekyll bundler`
2. Install dependencies: `bundle install`
3. Run locally: `bundle exec jekyll serve`
4. Visit: `http://localhost:4000`

## Structure

- `_posts/` - Blog posts
- `_tutorials/` - In-depth tutorials
- `_cheatsheets/` - Quick reference guides
- `_demos/` - Interactive demonstrations

## Writing Content

### Blog Post
```markdown
---
layout: post
title: "Your Title"
date: YYYY-MM-DD
categories: [ai-ml, python]
tags: [tag1, tag2]
---
```

### Tutorial
```markdown
---
layout: tutorial
title: "Your Tutorial"
difficulty: intermediate
prerequisites:
  - "Prerequisite 1"
  - "Prerequisite 2"
---
```

## Deployment

Push to `main` branch and GitHub Pages will automatically build and deploy.
