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
