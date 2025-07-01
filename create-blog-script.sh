#!/bin/bash

# GitHub Pages Blog Setup Script
# This script creates a complete blog structure for AI/ML, Security, Networking, and Python content

echo "🚀 Setting up GitHub Pages Blog Structure..."

# Check if we're in the right directory
if [ -d ".git" ]; then
    echo "✅ Git repository detected"
else
    echo "⚠️  Warning: No git repository detected in current directory"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Backup existing files if they exist
if [ -f "_config.yml" ] || [ -d "_posts" ] || [ -d "_layouts" ]; then
    echo "📦 Backing up existing files..."
    backup_dir="backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Move existing files to backup
    [ -f "_config.yml" ] && mv _config.yml "$backup_dir/"
    [ -d "_posts" ] && mv _posts "$backup_dir/"
    [ -d "_layouts" ] && mv _layouts "$backup_dir/"
    [ -d "_includes" ] && mv _includes "$backup_dir/"
    [ -f "index.md" ] && mv index.md "$backup_dir/"
    [ -f "about.md" ] && mv about.md "$backup_dir/"
    [ -d "assets" ] && mv assets "$backup_dir/"
    
    echo "✅ Existing files backed up to $backup_dir/"
fi

# Create main directories
echo "📁 Creating directory structure..."
mkdir -p _posts _tutorials _cheatsheets _demos _layouts _includes assets/{css,js,images} category

# Create category directories
mkdir -p category/{ai-ml,security,networking,python}

# Create collection index directories
mkdir -p tutorials cheatsheets demos

# Create _config.yml
echo "⚙️  Creating _config.yml..."
cat > _config.yml << 'EOF'
# Site settings
title: SC Thornton's Tech Blog
email: your-email@example.com
description: >-
  Deep dives into AI/ML, Security, Networking, and Python. 
  Tutorials, demos, and practical insights from hands-on experience.
baseurl: ""
url: "https://scthornton.github.io"
author: SC Thornton
twitter_username: scthornton
github_username: scthornton
linkedin_username: scthornton

# Build settings
markdown: kramdown
highlighter: rouge
theme: minima
plugins:
  - jekyll-feed
  - jekyll-sitemap
  - jekyll-seo-tag
  - jekyll-paginate

# Pagination
paginate: 10
paginate_path: "/blog/page:num/"

# Collections
collections:
  tutorials:
    output: true
    permalink: /tutorials/:title/
    sort_by: date
    order: descending
  cheatsheets:
    output: true
    permalink: /cheatsheets/:title/
  demos:
    output: true
    permalink: /demos/:title/

# Category descriptions
category_descriptions:
  ai-ml:
    name: "AI & Machine Learning"
    description: "Deep learning, neural networks, LLMs, and ML engineering"
    icon: "🤖"
  security:
    name: "Security"
    description: "Application security, penetration testing, and cybersecurity"
    icon: "🔒"
  networking:
    name: "Networking"
    description: "Network protocols, architecture, and infrastructure"
    icon: "🌐"
  python:
    name: "Python"
    description: "Python programming, libraries, and best practices"
    icon: "🐍"

# Defaults
defaults:
  - scope:
      path: ""
      type: "posts"
    values:
      layout: "post"
      comments: true
  - scope:
      path: ""
      type: "tutorials"
    values:
      layout: "tutorial"
      toc: true
  - scope:
      path: ""
      type: "cheatsheets"
    values:
      layout: "cheatsheet"
  - scope:
      path: ""
      type: "demos"
    values:
      layout: "demo"

# Exclude from build
exclude:
  - Gemfile
  - Gemfile.lock
  - README.md
  - .gitignore
  - setup-blog.sh
EOF

# Create index.html
echo "🏠 Creating home page..."
cat > index.html << 'EOF'
---
layout: default
---

<div class="home">
  <section class="hero">
    <h1>Welcome to My Tech Blog</h1>
    <p class="lead">{{ site.description }}</p>
  </section>

  <!-- Quick Links -->
  <section class="quick-links">
    <div class="grid">
      <a href="/tutorials/" class="card">
        <h3>📚 Tutorials</h3>
        <p>Step-by-step guides and in-depth explanations</p>
      </a>
      <a href="/cheatsheets/" class="card">
        <h3>📋 Cheatsheets</h3>
        <p>Quick reference guides and commands</p>
      </a>
      <a href="/demos/" class="card">
        <h3>🚀 Demos</h3>
        <p>Live examples and interactive projects</p>
      </a>
    </div>
  </section>

  <!-- Recent Posts -->
  <section class="recent-posts">
    <h2>Recent Posts</h2>
    {% for post in site.posts limit:5 %}
      <article class="post-preview">
        <h3><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h3>
        <div class="post-meta">
          <time>{{ post.date | date: "%B %d, %Y" }}</time>
          {% for cat in post.categories %}
            <a href="/category/{{ cat }}" class="category-tag">{{ site.category_descriptions[cat].icon }} {{ cat }}</a>
          {% endfor %}
        </div>
        <p>{{ post.excerpt | strip_html | truncate: 200 }}</p>
      </article>
    {% endfor %}
    <a href="/archive/" class="view-all">View all posts →</a>
  </section>

  <!-- Featured Tutorials -->
  <section class="featured-tutorials">
    <h2>Popular Tutorials</h2>
    <div class="tutorial-grid">
      {% assign featured_tutorials = site.tutorials | where: "featured", true | limit: 3 %}
      {% for tutorial in featured_tutorials %}
        <div class="tutorial-card">
          <h3><a href="{{ tutorial.url }}">{{ tutorial.title }}</a></h3>
          <p>{{ tutorial.description }}</p>
          <span class="difficulty difficulty-{{ tutorial.difficulty }}">{{ tutorial.difficulty }}</span>
        </div>
      {% endfor %}
    </div>
  </section>
</div>
EOF

# Create about.md
echo "👤 Creating about page..."
cat > about.md << 'EOF'
---
layout: default
title: About
permalink: /about/
---

# About Me

Welcome to my technical blog! I'm passionate about AI/ML, cybersecurity, networking, and Python development.

## What I Write About

- **AI & Machine Learning**: From neural network fundamentals to cutting-edge LLM applications
- **Security**: Application security, penetration testing, and security best practices
- **Networking**: Network protocols, infrastructure design, and troubleshooting
- **Python**: Clean code, useful libraries, and practical applications

## Connect With Me

- GitHub: [@scthornton](https://github.com/scthornton)
- Twitter: [@scthornton](https://twitter.com/scthornton)
- LinkedIn: [scthornton](https://linkedin.com/in/scthornton)

Feel free to reach out if you have questions or want to collaborate on a project!
EOF

# Create archive.html
echo "📚 Creating archive page..."
cat > archive.html << 'EOF'
---
layout: default
title: Blog Archive
permalink: /archive/
---

<h1>Blog Archive</h1>

<div class="archive">
  {% assign postsByYear = site.posts | group_by_exp: "post", "post.date | date: '%Y'" %}
  {% for year in postsByYear %}
    <h2>{{ year.name }}</h2>
    <ul class="archive-list">
      {% for post in year.items %}
        <li>
          <span class="date">{{ post.date | date: "%b %d" }}</span>
          <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
        </li>
      {% endfor %}
    </ul>
  {% endfor %}
</div>
EOF

# Create topics.html
echo "🏷️  Creating topics page..."
cat > topics.html << 'EOF'
---
layout: default
title: Topics
permalink: /topics/
---

<h1>Topics I Write About</h1>

<div class="topic-grid">
  {% assign categories = "ai-ml,security,networking,python" | split: "," %}
  {% for cat in categories %}
    <div class="topic-card">
      <h2>{{ site.category_descriptions[cat].icon }} {{ site.category_descriptions[cat].name }}</h2>
      <p>{{ site.category_descriptions[cat].description }}</p>
      <p class="post-count">{{ site.categories[cat] | size }} posts</p>
      <a href="/category/{{ cat }}/" class="btn">View all →</a>
    </div>
  {% endfor %}
</div>

<h2>Popular Tags</h2>
<div class="tag-cloud">
  {% assign tags = site.tags | sort %}
  {% for tag in tags %}
    <a href="/tag/{{ tag[0] }}" 
       class="tag-cloud-item"
       style="font-size: {{ tag[1].size | times: 4 | plus: 80 }}%">
      {{ tag[0] }}
    </a>
  {% endfor %}
</div>
EOF

# Create search.html
echo "🔍 Creating search page..."
cat > search.html << 'EOF'
---
layout: default
title: Search
permalink: /search/
---

<h1>Search</h1>

<div class="search-container">
  <input type="text" id="search-input" placeholder="Search posts, tutorials, and more..." class="search-input">
  <div id="search-results" class="search-results"></div>
</div>

<script src="{{ '/assets/js/search.js' | relative_url }}"></script>
EOF

# Create 404.html
echo "❌ Creating 404 page..."
cat > 404.html << 'EOF'
---
layout: default
title: Page Not Found
permalink: /404.html
---

<div class="error-page">
  <h1>404</h1>
  <h2>Page Not Found</h2>
  <p>Sorry, the page you're looking for doesn't exist.</p>
  <a href="/" class="btn">Go Home</a>
</div>
EOF

# Create layouts
echo "📐 Creating layouts..."

# Default layout
cat > _layouts/default.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{% if page.title %}{{ page.title }} | {% endif %}{{ site.title }}</title>
    <meta name="description" content="{{ page.description | default: site.description }}">
    
    <link rel="stylesheet" href="{{ '/assets/css/style.css' | relative_url }}">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-tomorrow.min.css">
    
    {% feed_meta %}
    {% seo %}
</head>
<body>
    {% include navigation.html %}
    
    <main class="main-content">
        {{ content }}
    </main>
    
    {% include footer.html %}
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-python.min.js"></script>
    <script src="{{ '/assets/js/search.js' | relative_url }}"></script>
</body>
</html>
EOF

# Post layout
cat > _layouts/post.html << 'EOF'
---
layout: default
---
<article class="post">
    <header class="post-header">
        <h1 class="post-title">{{ page.title }}</h1>
        <p class="post-meta">
            Published on {{ page.date | date: "%B %d, %Y" }}
            {% if page.author %} by {{ page.author }}{% endif %}
            {% if page.categories %} in 
                {% for category in page.categories %}
                    <a href="/category/{{ category }}">{{ site.category_descriptions[category].icon }} {{ category }}</a>{% unless forloop.last %}, {% endunless %}
                {% endfor %}
            {% endif %}
        </p>
    </header>

    <div class="post-content">
        {{ content }}
    </div>

    <footer class="post-footer">
        {% if page.tags %}
        <div class="post-tags">
            Tags: 
            {% for tag in page.tags %}
                <a href="/tag/{{ tag }}" class="tag">#{{ tag }}</a>{% unless forloop.last %}, {% endunless %}
            {% endfor %}
        </div>
        {% endif %}
        
        {% include related-posts.html %}
    </footer>
</article>
EOF

# Tutorial layout
cat > _layouts/tutorial.html << 'EOF'
---
layout: default
---
<article class="tutorial">
  <header class="tutorial-header">
    <h1>{{ page.title }}</h1>
    <div class="tutorial-meta">
      <span class="difficulty difficulty-{{ page.difficulty }}">{{ page.difficulty | capitalize }}</span>
      <span class="reading-time">{{ page.content | number_of_words | divided_by: 200 }} min read</span>
      {% if page.updated %}
        <span>Updated: {{ page.updated | date: "%B %d, %Y" }}</span>
      {% endif %}
    </div>
    
    {% if page.prerequisites %}
    <div class="prerequisites">
      <h3>Prerequisites</h3>
      <ul>
        {% for prereq in page.prerequisites %}
          <li>{{ prereq }}</li>
        {% endfor %}
      </ul>
    </div>
    {% endif %}
  </header>

  {% if page.toc %}
  <nav class="toc">
    <h3>Table of Contents</h3>
    <div class="toc-content"></div>
  </nav>
  {% endif %}

  <div class="tutorial-content">
    {{ content }}
  </div>

  <footer class="tutorial-footer">
    {% if page.github_repo %}
      <a href="{{ page.github_repo }}" class="github-link">View Code on GitHub</a>
    {% endif %}
    
    {% if page.tags %}
    <div class="tags">
      {% for tag in page.tags %}
        <a href="/tag/{{ tag }}" class="tag">#{{ tag }}</a>
      {% endfor %}
    </div>
    {% endif %}
  </footer>
</article>
EOF

# Cheatsheet layout
cat > _layouts/cheatsheet.html << 'EOF'
---
layout: default
---
<article class="cheatsheet">
  <header class="cheatsheet-header">
    <h1>{{ page.title }}</h1>
    <p class="cheatsheet-description">{{ page.description }}</p>
  </header>

  <div class="cheatsheet-content">
    {{ content }}
  </div>

  <footer class="cheatsheet-footer">
    {% if page.tags %}
    <div class="tags">
      {% for tag in page.tags %}
        <a href="/tag/{{ tag }}" class="tag">#{{ tag }}</a>
      {% endfor %}
    </div>
    {% endif %}
  </footer>
</article>
EOF

# Demo layout
cat > _layouts/demo.html << 'EOF'
---
layout: default
---
<article class="demo">
  <header class="demo-header">
    <h1>{{ page.title }}</h1>
    <p class="demo-description">{{ page.description }}</p>
  </header>

  <div class="demo-content">
    {{ content }}
  </div>

  <footer class="demo-footer">
    {% if page.github_repo %}
      <a href="{{ page.github_repo }}" class="github-link">View Source on GitHub</a>
    {% endif %}
    
    {% if page.tags %}
    <div class="tags">
      {% for tag in page.tags %}
        <a href="/tag/{{ tag }}" class="tag">#{{ tag }}</a>
      {% endfor %}
    </div>
    {% endif %}
  </footer>
</article>
EOF

# Create includes
echo "🧩 Creating includes..."

# Navigation
cat > _includes/navigation.html << 'EOF'
<nav class="site-nav">
  <div class="nav-wrapper">
    <a href="/" class="site-title">{{ site.title }}</a>
    
    <div class="nav-links">
      <a href="/archive/">Blog</a>
      
      <div class="dropdown">
        <a href="/topics/" class="dropdown-trigger">Topics ▼</a>
        <div class="dropdown-content">
          <a href="/category/ai-ml/">🤖 AI & ML</a>
          <a href="/category/security/">🔒 Security</a>
          <a href="/category/networking/">🌐 Networking</a>
          <a href="/category/python/">🐍 Python</a>
        </div>
      </div>
      
      <div class="dropdown">
        <a href="#" class="dropdown-trigger">Resources ▼</a>
        <div class="dropdown-content">
          <a href="/tutorials/">📚 Tutorials</a>
          <a href="/cheatsheets/">📋 Cheatsheets</a>
          <a href="/demos/">🚀 Demos</a>
        </div>
      </div>
      
      <a href="/about/">About</a>
      <a href="/search/">🔍</a>
    </div>
  </div>
</nav>
EOF

# Footer
cat > _includes/footer.html << 'EOF'
<footer class="site-footer">
  <div class="footer-content">
    <p>&copy; {{ 'now' | date: "%Y" }} {{ site.title }}. All rights reserved.</p>
    <div class="footer-links">
      <a href="{{ site.url }}/feed.xml">RSS</a>
      <a href="https://github.com/{{ site.github_username }}">GitHub</a>
      <a href="https://twitter.com/{{ site.twitter_username }}">Twitter</a>
    </div>
  </div>
</footer>
EOF

# Post meta
cat > _includes/post-meta.html << 'EOF'
<div class="post-meta">
  <time datetime="{{ include.date | date_to_xmlschema }}">
    {{ include.date | date: "%B %d, %Y" }}
  </time>
  {% if include.categories %}
    {% for category in include.categories %}
      <a href="/category/{{ category }}" class="category-tag">
        {{ site.category_descriptions[category].icon }} {{ category }}
      </a>
    {% endfor %}
  {% endif %}
</div>
EOF

# Related posts
cat > _includes/related-posts.html << 'EOF'
{% assign maxRelated = 3 %}
{% assign minCommonTags = 2 %}
{% assign relatedCount = 0 %}

<div class="related-posts">
  <h3>Related Posts</h3>
  <ul>
    {% for post in site.posts %}
      {% if post.url != page.url %}
        {% assign sameTagCount = 0 %}
        {% for tag in post.tags %}
          {% if page.tags contains tag %}
            {% assign sameTagCount = sameTagCount | plus: 1 %}
          {% endif %}
        {% endfor %}
        
        {% if sameTagCount >= minCommonTags %}
          <li>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
            <span class="post-date">({{ post.date | date: "%B %Y" }})</span>
          </li>
          {% assign relatedCount = relatedCount | plus: 1 %}
          {% if relatedCount >= maxRelated %}
            {% break %}
          {% endif %}
        {% endif %}
      {% endif %}
    {% endfor %}
  </ul>
</div>
EOF

# Create CSS
echo "🎨 Creating styles..."
cat > assets/css/style.css << 'EOF'
/* Base styles */
:root {
  --primary-color: #2563eb;
  --secondary-color: #7c3aed;
  --success-color: #10b981;
  --warning-color: #f59e0b;
  --danger-color: #ef4444;
  --text-primary: #1f2937;
  --text-secondary: #6b7280;
  --bg-primary: #ffffff;
  --bg-secondary: #f3f4f6;
  --border-color: #e5e7eb;
}

* {
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  line-height: 1.6;
  color: var(--text-primary);
  margin: 0;
  padding: 0;
  background-color: var(--bg-primary);
}

.main-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

/* Navigation */
.site-nav {
  background-color: var(--bg-primary);
  border-bottom: 1px solid var(--border-color);
  position: sticky;
  top: 0;
  z-index: 100;
}

.nav-wrapper {
  max-width: 1200px;
  margin: 0 auto;
  padding: 1rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.site-title {
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--text-primary);
  text-decoration: none;
}

.nav-links {
  display: flex;
  gap: 2rem;
  align-items: center;
}

.nav-links a {
  color: var(--text-secondary);
  text-decoration: none;
  transition: color 0.2s;
}

.nav-links a:hover {
  color: var(--primary-color);
}

/* Dropdown */
.dropdown {
  position: relative;
}

.dropdown-content {
  position: absolute;
  top: 100%;
  left: 0;
  background-color: var(--bg-primary);
  border: 1px solid var(--border-color);
  border-radius: 0.5rem;
  min-width: 200px;
  display: none;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.dropdown:hover .dropdown-content {
  display: block;
}

.dropdown-content a {
  display: block;
  padding: 0.5rem 1rem;
}

.dropdown-content a:hover {
  background-color: var(--bg-secondary);
}

/* Home page */
.hero {
  text-align: center;
  padding: 3rem 0;
}

.hero h1 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
}

.lead {
  font-size: 1.25rem;
  color: var(--text-secondary);
}

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.card {
  background-color: var(--bg-secondary);
  padding: 1.5rem;
  border-radius: 0.5rem;
  text-decoration: none;
  color: inherit;
  transition: transform 0.2s, box-shadow 0.2s;
}

.card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

/* Posts */
.post-preview {
  margin-bottom: 2rem;
  padding-bottom: 2rem;
  border-bottom: 1px solid var(--border-color);
}

.post-meta {
  display: flex;
  gap: 1rem;
  align-items: center;
  color: var(--text-secondary);
  font-size: 0.875rem;
  margin: 0.5rem 0;
}

.category-tag {
  background-color: var(--bg-secondary);
  padding: 0.25rem 0.75rem;
  border-radius: 0.25rem;
  text-decoration: none;
  color: var(--text-secondary);
  font-size: 0.875rem;
}

.category-tag:hover {
  background-color: var(--primary-color);
  color: white;
}

/* Difficulty badges */
.difficulty {
  padding: 0.25rem 0.75rem;
  border-radius: 0.25rem;
  font-size: 0.875rem;
  font-weight: 500;
}

.difficulty-beginner {
  background-color: #d1fae5;
  color: #065f46;
}

.difficulty-intermediate {
  background-color: #dbeafe;
  color: #1e40af;
}

.difficulty-advanced {
  background-color: #fce7f3;
  color: #9d174d;
}

/* Code blocks */
pre {
  background-color: #1e293b;
  color: #e2e8f0;
  padding: 1rem;
  border-radius: 0.5rem;
  overflow-x: auto;
}

code {
  background-color: var(--bg-secondary);
  padding: 0.125rem 0.25rem;
  border-radius: 0.25rem;
  font-size: 0.875em;
}

pre code {
  background-color: transparent;
  padding: 0;
}

/* Tutorial TOC */
.toc {
  background-color: var(--bg-secondary);
  padding: 1.5rem;
  border-radius: 0.5rem;
  margin-bottom: 2rem;
}

.toc h3 {
  margin-top: 0;
}

/* Tags */
.tag {
  display: inline-block;
  background-color: var(--bg-secondary);
  color: var(--text-secondary);
  padding: 0.25rem 0.5rem;
  border-radius: 0.25rem;
  font-size: 0.875rem;
  text-decoration: none;
  margin-right: 0.5rem;
}

.tag:hover {
  background-color: var(--primary-color);
  color: white;
}

/* Footer */
.site-footer {
  background-color: var(--bg-secondary);
  padding: 2rem 0;
  margin-top: 4rem;
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  text-align: center;
}

.footer-links {
  margin-top: 1rem;
}

.footer-links a {
  margin: 0 1rem;
  color: var(--text-secondary);
  text-decoration: none;
}

/* Search */
.search-input {
  width: 100%;
  padding: 0.75rem;
  font-size: 1rem;
  border: 1px solid var(--border-color);
  border-radius: 0.5rem;
  margin-bottom: 1rem;
}

.search-results {
  max-height: 500px;
  overflow-y: auto;
}

.search-result {
  padding: 1rem;
  border-bottom: 1px solid var(--border-color);
}

.search-result:last-child {
  border-bottom: none;
}

/* Responsive */
@media (max-width: 768px) {
  .nav-links {
    gap: 1rem;
  }
  
  .grid {
    grid-template-columns: 1fr;
  }
  
  .main-content {
    padding: 1rem;
  }
  
  .dropdown-content {
    position: static;
    display: none;
  }
}
EOF

# Create JavaScript files
echo "⚡ Creating JavaScript files..."
cat > assets/js/search.js << 'EOF'
// Simple search functionality
document.addEventListener('DOMContentLoaded', function() {
  const searchInput = document.getElementById('search-input');
  const searchResults = document.getElementById('search-results');
  
  if (!searchInput) return;
  
  // Fetch all posts, tutorials, etc. via JSON
  fetch('/search.json')
    .then(response => response.json())
    .then(data => {
      searchInput.addEventListener('input', function() {
        const query = this.value.toLowerCase();
        if (query.length < 2) {
          searchResults.innerHTML = '';
          return;
        }
        
        const results = data.filter(item => 
          item.title.toLowerCase().includes(query) ||
          item.content.toLowerCase().includes(query) ||
          item.tags.some(tag => tag.toLowerCase().includes(query))
        );
        
        displayResults(results.slice(0, 10));
      });
    });
  
  function displayResults(results) {
    if (results.length === 0) {
      searchResults.innerHTML = '<p>No results found</p>';
      return;
    }
    
    const html = results.map(result => `
      <div class="search-result">
        <h3><a href="${result.url}">${result.title}</a></h3>
        <p>${result.excerpt}</p>
      </div>
    `).join('');
    
    searchResults.innerHTML = html;
  }
});
EOF

# Create search.json
echo "🔎 Creating search.json..."
cat > search.json << 'EOF'
---
layout: null
---
[
  {% for post in site.posts %}
    {
      "title": {{ post.title | jsonify }},
      "url": {{ post.url | jsonify }},
      "date": {{ post.date | date: "%B %d, %Y" | jsonify }},
      "categories": {{ post.categories | jsonify }},
      "tags": {{ post.tags | jsonify }},
      "excerpt": {{ post.excerpt | strip_html | truncate: 200 | jsonify }},
      "content": {{ post.content | strip_html | truncate: 500 | jsonify }}
    }{% unless forloop.last %},{% endunless %}
  {% endfor %}
  {% for tutorial in site.tutorials %}
    ,{
      "title": {{ tutorial.title | jsonify }},
      "url": {{ tutorial.url | jsonify }},
      "date": {{ tutorial.date | date: "%B %d, %Y" | jsonify }},
      "categories": {{ tutorial.categories | jsonify }},
      "tags": {{ tutorial.tags | jsonify }},
      "excerpt": {{ tutorial.description | jsonify }},
      "content": {{ tutorial.content | strip_html | truncate: 500 | jsonify }}
    }
  {% endfor %}
]
EOF

# Create category pages
echo "📁 Creating category pages..."

# AI/ML category
cat > category/ai-ml.html << 'EOF'
---
layout: default
title: "AI & Machine Learning"
permalink: /category/ai-ml/
---

<div class="category-page">
  <header class="category-header">
    <h1>{{ site.category_descriptions.ai-ml.icon }} {{ site.category_descriptions.ai-ml.name }}</h1>
    <p class="category-description">{{ site.category_descriptions.ai-ml.description }}</p>
  </header>

  <div class="content-sections">
    <!-- Blog Posts -->
    <section>
      <h2>Blog Posts</h2>
      <div class="posts-list">
        {% for post in site.categories.ai-ml %}
          <article class="post-item">
            <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
            <time>{{ post.date | date: "%B %d, %Y" }}</time>
            <p>{{ post.excerpt | strip_html | truncate: 150 }}</p>
          </article>
        {% endfor %}
      </div>
    </section>

    <!-- Tutorials -->
    {% assign ml_tutorials = site.tutorials | where_exp: "item", "item.categories contains 'ai-ml'" %}
    {% if ml_tutorials.size > 0 %}
    <section>
      <h2>Tutorials</h2>
      <div class="tutorial-list">
        {% for tutorial in ml_tutorials %}
          <div class="tutorial-item">
            <h3><a href="{{ tutorial.url }}">{{ tutorial.title }}</a></h3>
            <span class="difficulty difficulty-{{ tutorial.difficulty }}">{{ tutorial.difficulty }}</span>
            <p>{{ tutorial.description }}</p>
          </div>
        {% endfor %}
      </div>
    </section>
    {% endif %}
  </div>
</div>
EOF

# Security category
cat > category/security.html << 'EOF'
---
layout: default
title: "Security"
permalink: /category/security/
---

<div class="category-page">
  <header class="category-header">
    <h1>{{ site.category_descriptions.security.icon }} {{ site.category_descriptions.security.name }}</h1>
    <p class="category-description">{{ site.category_descriptions.security.description }}</p>
  </header>

  <div class="content-sections">
    <section>
      <h2>Blog Posts</h2>
      <div class="posts-list">
        {% for post in site.categories.security %}
          <article class="post-item">
            <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
            <time>{{ post.date | date: "%B %d, %Y" }}</time>
            <p>{{ post.excerpt | strip_html | truncate: 150 }}</p>
          </article>
        {% endfor %}
      </div>
    </section>
  </div>
</div>
EOF

# Networking category
cat > category/networking.html << 'EOF'
---
layout: default
title: "Networking"
permalink: /category/networking/
---

<div class="category-page">
  <header class="category-header">
    <h1>{{ site.category_descriptions.networking.icon }} {{ site.category_descriptions.networking.name }}</h1>
    <p class="category-description">{{ site.category_descriptions.networking.description }}</p>
  </header>

  <div class="content-sections">
    <section>
      <h2>Blog Posts</h2>
      <div class="posts-list">
        {% for post in site.categories.networking %}
          <article class="post-item">
            <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
            <time>{{ post.date | date: "%B %d, %Y" }}</time>
            <p>{{ post.excerpt | strip_html | truncate: 150 }}</p>
          </article>
        {% endfor %}
      </div>
    </section>
  </div>
</div>
EOF

# Python category
cat > category/python.html << 'EOF'
---
layout: default
title: "Python"
permalink: /category/python/
---

<div class="category-page">
  <header class="category-header">
    <h1>{{ site.category_descriptions.python.icon }} {{ site.category_descriptions.python.name }}</h1>
    <p class="category-description">{{ site.category_descriptions.python.description }}</p>
  </header>

  <div class="content-sections">
    <section>
      <h2>Blog Posts</h2>
      <div class="posts-list">
        {% for post in site.categories.python %}
          <article class="post-item">
            <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
            <time>{{ post.date | date: "%B %d, %Y" }}</time>
            <p>{{ post.excerpt | strip_html | truncate: 150 }}</p>
          </article>
        {% endfor %}
      </div>
    </section>
  </div>
</div>
EOF

# Create collection index pages
echo "📖 Creating collection index pages..."

# Tutorials index
cat > tutorials/index.html << 'EOF'
---
layout: default
title: Tutorials
permalink: /tutorials/
---

<h1>Tutorials</h1>
<p>In-depth guides and step-by-step tutorials on AI/ML, Security, Networking, and Python.</p>

<div class="tutorials-grid">
  {% for tutorial in site.tutorials %}
    <div class="tutorial-card">
      <h2><a href="{{ tutorial.url }}">{{ tutorial.title }}</a></h2>
      <div class="tutorial-meta">
        <span class="difficulty difficulty-{{ tutorial.difficulty }}">{{ tutorial.difficulty }}</span>
        <span class="date">{{ tutorial.date | date: "%B %Y" }}</span>
      </div>
      <p>{{ tutorial.description }}</p>
      <div class="tutorial-categories">
        {% for cat in tutorial.categories %}
          <a href="/category/{{ cat }}" class="category-tag">{{ site.category_descriptions[cat].icon }} {{ cat }}</a>
        {% endfor %}
      </div>
    </div>
  {% endfor %}
</div>
EOF

# Cheatsheets index
cat > cheatsheets/index.html << 'EOF'
---
layout: default
title: Cheatsheets
permalink: /cheatsheets/
---

<h1>Cheatsheets</h1>
<p>Quick reference guides and command collections for various technologies.</p>

<div class="cheatsheets-grid">
  {% for sheet in site.cheatsheets %}
    <a href="{{ sheet.url }}" class="cheatsheet-card">
      <h3>{{ sheet.title }}</h3>
      <p>{{ sheet.description }}</p>
    </a>
  {% endfor %}
</div>
EOF

# Demos index
cat > demos/index.html << 'EOF'
---
layout: default
title: Demos
permalink: /demos/
---

<h1>Interactive Demos</h1>
<p>Live examples and interactive demonstrations of various concepts and projects.</p>

<div class="demos-grid">
  {% for demo in site.demos %}
    <div class="demo-card">
      <h2><a href="{{ demo.url }}">{{ demo.title }}</a></h2>
      <p>{{ demo.description }}</p>
      <div class="demo-links">
        <a href="{{ demo.url }}" class="btn">View Demo</a>
        {% if demo.github_repo %}
          <a href="{{ demo.github_repo }}" class="btn-secondary">Source Code</a>
        {% endif %}
      </div>
    </div>
  {% endfor %}
</div>
EOF

# Create sample content
echo "📝 Creating sample content..."

# Sample blog post
cat > _posts/2025-01-29-getting-started-with-transformers.md << 'EOF'
---
layout: post
title: "Getting Started with Transformers for NLP"
date: 2025-01-29
categories: [ai-ml, python]
tags: [transformers, nlp, hugging-face, bert, deep-learning]
description: "A practical introduction to using transformer models for natural language processing tasks"
excerpt: "Learn how to use pre-trained transformer models like BERT for text classification, named entity recognition, and more."
---

Transformers have revolutionized NLP. Let's explore how to get started with Hugging Face's transformers library.

## Why Transformers?

Before transformers, we relied on RNNs and LSTMs for sequence tasks. Transformers brought:
- Parallel processing capabilities
- Better long-range dependencies
- Transfer learning revolution

## Quick Start

```python
from transformers import pipeline

# Sentiment analysis in 3 lines
classifier = pipeline("sentiment-analysis")
result = classifier("I love writing technical blogs!")
print(result)  # [{'label': 'POSITIVE', 'score': 0.999}]
```

## Loading a Pre-trained Model

```python
from transformers import AutoTokenizer, AutoModelForSequenceClassification
import torch

# Load model and tokenizer
model_name = "bert-base-uncased"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForSequenceClassification.from_pretrained(model_name)

# Tokenize input
inputs = tokenizer("Hello, transformers!", return_tensors="pt")

# Get predictions
with torch.no_grad():
    outputs = model(**inputs)
    predictions = torch.nn.functional.softmax(outputs.logits, dim=-1)
```

Stay tuned for more advanced transformer tutorials!
EOF

# Sample tutorial
cat > _tutorials/build-neural-network-from-scratch.md << 'EOF'
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
EOF

# Sample cheatsheet
cat > _cheatsheets/python-ml-libraries.md << 'EOF'
---
layout: cheatsheet
title: "Python ML Libraries Quick Reference"
description: "Essential commands and snippets for popular ML libraries"
date: 2025-01-25
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
EOF

# Sample demo
cat > _demos/mnist-classifier.md << 'EOF'
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
EOF

# Create Gemfile
echo "💎 Creating Gemfile..."
cat > Gemfile << 'EOF'
source "https://rubygems.org"

gem "jekyll", "~> 4.3"
gem "minima", "~> 2.5"

group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.12"
  gem "jekyll-sitemap"
  gem "jekyll-seo-tag"
  gem "jekyll-paginate"
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1", :platforms => [:mingw, :x64_mingw, :mswin]
EOF

# Create .gitignore
echo "🚫 Creating .gitignore..."
cat > .gitignore << 'EOF'
_site/
.sass-cache/
.jekyll-cache/
.jekyll-metadata
.DS_Store
Gemfile.lock
*.gem
*.swp
*~
EOF

# Create README
echo "📖 Creating README..."
cat > README.md << 'EOF'
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
EOF

echo "✅ Blog structure created successfully!"
echo ""
echo "Next steps:"
echo "1. Navigate to your blog directory: cd scthornton.github.io"
echo "2. Initialize git: git init"
echo "3. Add GitHub remote: git remote add origin https://github.com/scthornton/scthornton.github.io.git"
echo "4. Add all files: git add ."
echo "5. Commit: git commit -m 'Initial blog setup'"
echo "6. Push to GitHub: git push -u origin main"
echo ""
echo "Your blog will be live at https://scthornton.github.io in a few minutes!"
