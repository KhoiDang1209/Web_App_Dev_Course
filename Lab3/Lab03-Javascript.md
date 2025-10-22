# Lab 04 JavaScript Fundamentals - In-Class Tasks
**Duration:** 2.5 hours | **Points:** 100

## Overview

Today you will complete 4 hands-on tasks building real-world web applications. Each task builds on the concepts from your pre-lab reading.

**Task Breakdown:**
- Task 1.1: Interactive Form Validator (15 points) - 30 minutes
- Task 1.2: Dynamic Shopping Cart (15 points) - 35 minutes
- Task 2.1: Weather Dashboard (15 points) - 35 minutes
- Task 2.2: GitHub Repository Finder (15 points) - 40 minutes

**Total:** 60 points in-class + 30 points homework + 10 points bonus

---

## ✏️ Task 1.1: Interactive Form Validator (15 points)

### 🎯 Real-World Application
Every time you sign up for Facebook, create a Gmail account, or register on Amazon, JavaScript form validation is working to ensure your data is correct before sending it to the server. This saves server resources and gives users instant feedback. Companies lose millions when forms are hard to use! In this task, you'll build a professional form validator like those used by major websites.

### Challenge
Create a real-time form validator with multiple validation rules.

### Requirements

**HTML Form Structure:**
- Username field (4-20 characters, alphanumeric)
- Email field (valid email format)
- Password field (min 8 characters, 1 uppercase, 1 number)
- Confirm Password field (must match)
- Submit button (disabled until all valid)

**Validation Functions:**
- `validateUsername(username)` - Returns true/false
- `validateEmail(email)` - Uses regex pattern
- `validatePassword(password)` - Checks complexity
- `validatePasswordMatch(pass1, pass2)` - Compares passwords
- `validateForm()` - Validates entire form

**Visual Feedback:**
- Green border for valid fields
- Red border for invalid fields
- Error messages below each field
- Enable submit button only when all valid

### Starter Code

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Form Validator</title>
    <style>
        .form-container {
            max-width: 400px;
            margin: 50px auto;
            padding: 30px;
            border: 1px solid #ddd;
            border-radius: 8px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        input {
            width: 100%;
            padding: 10px;
            border: 2px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        input.valid {
            border-color: #28a745;
        }
        
        input.invalid {
            border-color: #dc3545;
        }
        
        .error-message {
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
        
        .error-message.show {
            display: block;
        }
        
        button[type="submit"] {
            width: 100%;
            padding: 12px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
        }
        
        button[type="submit"]:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Sign Up Form</h2>
        <form id="signupForm">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" placeholder="Enter username">
                <div class="error-message" id="usernameError"></div>
            </div>
            
            <!-- TODO: Add email field -->
            
            <!-- TODO: Add password field -->
            
            <!-- TODO: Add confirm password field -->
            
            <button type="submit" id="submitBtn" disabled>Sign Up</button>
        </form>
    </div>

    <script>
        // TODO: Implement validation functions
        
        function validateUsername(username) {
            // TODO: Check length (4-20) and alphanumeric
        }
        
        function validateEmail(email) {
            // TODO: Use regex for email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        }
        
        function validatePassword(password) {
            // TODO: Check length >= 8, has uppercase, has number
        }
        
        function validatePasswordMatch(pass1, pass2) {
            // TODO: Compare passwords
        }
        
        function showError(fieldId, message) {
            // TODO: Display error message
        }
        
        function clearError(fieldId) {
            // TODO: Clear error message
        }
        
        function validateForm() {
            // TODO: Validate all fields and enable/disable submit
        }
        
        // TODO: Add event listeners for real-time validation
        
        document.getElementById('signupForm').addEventListener('submit', function(e) {
            e.preventDefault();
            // TODO: Handle form submission
        });
    </script>
</body>
</html>
```

### Hints
- Use `input.addEventListener('input', validateForm)` for real-time validation
- Password regex: `/^(?=.*[A-Z])(?=.*\d).{8,}$/`
- Use `classList.add()` and `classList.remove()` for styling
- Store validation state: `{ username: false, email: false, ... }`

### Expected Output

```
Sign Up Form
------------------------
Username: john_doe123 ✓
Email: john@example.com ✓
Password: ••••••••• ✓
Confirm Password: ••••••••• ✓

[Sign Up] (button enabled)

If invalid:
Username: ab ✗
Error: Username must be 4-20 characters and alphanumeric

[Sign Up] (button disabled)
```

### Grading Criteria (15 points)
- [ ] All validation functions work correctly (6 points)
- [ ] Real-time validation on input (3 points)
- [ ] Visual feedback (borders and messages) (3 points)
- [ ] Submit button enable/disable logic (2 points)
- [ ] Clean, readable code (1 point)

---

## ✏️ Task 1.2: Dynamic Shopping Cart (15 points)

### 🎯 Real-World Application
Every e-commerce site - Amazon, eBay, Shopify stores - needs a shopping cart. This isn't just about adding items; it's about calculating totals, managing quantities, and creating a seamless user experience. E-commerce generates $5 trillion annually, and the shopping cart is where the money is made or lost.

### Challenge
Build a shopping cart with add/remove items, quantity updates, and total calculation.

### Requirements

**Product Display:**
- Show at least 4 products with image (emoji), name, price
- "Add to Cart" button for each product

**Cart Features:**
- Display cart items with quantities
- Increase/decrease quantity buttons
- Remove item button
- Calculate subtotal for each item
- Calculate total price
- Show item count in cart icon

**Functions to Implement:**
- `addToCart(productId)` - Add product to cart
- `removeFromCart(itemId)` - Remove from cart
- `updateQuantity(itemId, quantity)` - Update item quantity
- `calculateTotal()` - Calculate total price
- `renderCart()` - Update cart display
- `renderProducts()` - Display product list

### Starter Code

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
        }
        
        .header {
            background: #333;
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .cart-icon {
            position: relative;
            cursor: pointer;
        }
        
        .cart-count {
            position: absolute;
            top: -10px;
            right: -10px;
            background: red;
            color: white;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .product-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .product-image {
            width: 100%;
            height: 200px;
            background: #ddd;
            border-radius: 4px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 80px;
        }
        
        .product-name {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .product-price {
            color: #28a745;
            font-size: 20px;
            margin-bottom: 15px;
        }
        
        .add-to-cart-btn {
            width: 100%;
            padding: 10px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        
        .add-to-cart-btn:hover {
            background: #0056b3;
        }
        
        .cart-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
        }
        
        .cart-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .quantity-controls {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .quantity-controls button {
            width: 30px;
            height: 30px;
            border: 1px solid #ddd;
            background: white;
            cursor: pointer;
            border-radius: 4px;
        }
        
        .cart-total {
            text-align: right;
            font-size: 24px;
            font-weight: bold;
            padding: 20px;
            border-top: 2px solid #333;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>My Shop</h1>
        <div class="cart-icon" onclick="toggleCart()">
            🛒 Cart
            <span class="cart-count" id="cartCount">0</span>
        </div>
    </div>

    <div class="container">
        <h2>Products</h2>
        <div class="products-grid" id="productsGrid"></div>
        
        <div class="cart-section" id="cartSection" style="display: none;">
            <h2>Shopping Cart</h2>
            <div id="cartItems"></div>
            <div class="cart-total">
                Total: $<span id="cartTotal">0.00</span>
            </div>
        </div>
    </div>

    <script>
        // Product data
        const products = [
            { id: 1, name: 'Laptop', price: 999.99, image: '💻' },
            { id: 2, name: 'Smartphone', price: 699.99, image: '📱' },
            { id: 3, name: 'Headphones', price: 199.99, image: '🎧' },
            { id: 4, name: 'Smartwatch', price: 299.99, image: '⌚' }
        ];

        // Cart array
        let cart = [];

        // TODO: Implement functions
        
        function addToCart(productId) {
            // TODO: Add product to cart or increase quantity
        }
        
        function removeFromCart(itemId) {
            // TODO: Remove item from cart
        }
        
        function updateQuantity(productId, change) {
            // TODO: Update item quantity (change is +1 or -1)
        }
        
        function calculateTotal() {
            // TODO: Calculate total price
        }
        
        function renderProducts() {
            // TODO: Display products
        }
        
        function renderCart() {
            // TODO: Display cart items
        }
        
        function toggleCart() {
            // TODO: Show/hide cart section
        }
        
        // Initialize
        renderProducts();
    </script>
</body>
</html>
```

### Hints
- Check if product already in cart before adding
- Use `find()` to search cart array
- Use `filter()` to remove items
- Format prices: `price.toFixed(2)`
- Update cart count badge on every change

### Expected Output

```
My Shop                                🛒 Cart (2)

Products
-----------------------------------------
[💻]              [📱]
Laptop            Smartphone
$999.99           $699.99
[Add to Cart]     [Add to Cart]

Shopping Cart
-----------------------------------------
💻 Laptop - $999.99
   [-] 1 [+]  [Remove]

📱 Smartphone - $699.99
   [-] 2 [+]  [Remove]

Total: $2,399.97
```

### Grading Criteria (15 points)
- [ ] Add to cart functionality (3 points)
- [ ] Quantity increase/decrease (3 points)
- [ ] Remove from cart (2 points)
- [ ] Total calculation (3 points)
- [ ] Cart count badge updates (2 points)
- [ ] Clean UI and code (2 points)

---

## ✏️ Task 2.1: Weather Dashboard (15 points)

### 🎯 Real-World Application
Weather apps on your phone, weather widgets on news sites, smart home displays - they all fetch real-time data from weather APIs. Companies like The Weather Channel and AccuWeather serve billions of API requests daily. In this task, you'll build a professional weather dashboard that fetches real data from a weather API.

### Challenge
Create a weather dashboard that fetches and displays real-time weather data.

### Requirements

**Features:**
- Search for city weather
- Display current temperature, conditions, humidity, wind speed
- Show 5-day forecast
- Display weather icons (use emojis)
- Handle loading and error states
- Save recent searches (localStorage)

**API Integration:**
- Use OpenWeatherMap API (free tier): https://openweathermap.org/api
- Get API key: Sign up for free account
- Current weather: `https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric`
- Forecast: `https://api.openweathermap.org/data/2.5/forecast?q={city}&appid={API_KEY}&units=metric`

**Functions to Implement:**
- `async fetchWeather(city)` - Fetch current weather
- `async fetchForecast(city)` - Fetch 5-day forecast
- `displayWeather(data)` - Display current weather
- `displayForecast(data)` - Display forecast
- `saveRecentSearch(city)` - Save to localStorage
- `loadRecentSearches()` - Load from localStorage

### Starter Code

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Weather Dashboard</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 900px;
            margin: 0 auto;
        }
        
        .search-box {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .search-box input {
            width: 70%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        
        .search-box button {
            width: 28%;
            padding: 12px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-left: 2%;
        }
        
        .weather-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            margin-bottom: 20px;
        }
        
        .current-weather {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .temp-display {
            font-size: 60px;
            font-weight: bold;
        }
        
        .forecast-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }
        
        .forecast-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
        }
        
        .loading {
            text-align: center;
            padding: 40px;
            font-size: 18px;
            color: white;
        }
        
        .error {
            background: #dc3545;
            color: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .recent-searches {
            display: flex;
            gap: 10px;
            margin-top: 10px;
            flex-wrap: wrap;
        }
        
        .recent-city {
            padding: 5px 15px;
            background: #e9ecef;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
        }
        
        .recent-city:hover {
            background: #dee2e6;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 style="color: white; text-align: center; margin-bottom: 30px;">
            Weather Dashboard
        </h1>
        
        <div class="search-box">
            <input type="text" id="cityInput" placeholder="Enter city name..." 
                   onkeypress="if(event.key==='Enter') searchWeather()">
            <button onclick="searchWeather()">Search</button>
            <div class="recent-searches" id="recentSearches"></div>
        </div>
        
        <div id="errorMessage"></div>
        <div id="weatherDisplay"></div>
        <div id="forecastDisplay"></div>
    </div>

    <script>
        const API_KEY = 'YOUR_API_KEY_HERE'; // Get from openweathermap.org
        
        // TODO: Implement functions
        
        async function fetchWeather(city) {
            // TODO: Fetch current weather from API
        }
        
        async function fetchForecast(city) {
            // TODO: Fetch 5-day forecast from API
        }
        
        function displayWeather(data) {
            // TODO: Display current weather
            // data.main.temp, data.weather[0].description
            // data.main.humidity, data.wind.speed
        }
        
        function displayForecast(data) {
            // TODO: Display forecast (filter for one per day)
        }
        
        async function searchWeather() {
            // TODO: Get city input and fetch weather
            // TODO: Handle loading state
            // TODO: Handle errors
            // TODO: Save to recent searches
        }
        
        function saveRecentSearch(city) {
            // TODO: Save to localStorage (max 5 cities)
        }
        
        function loadRecentSearches() {
            // TODO: Load and display recent searches
        }
        
        function showError(message) {
            // TODO: Display error message
        }
        
        function clearError() {
            // TODO: Clear error message
        }
        
        // Initialize
        loadRecentSearches();
    </script>
</body>
</html>
```

### Hints
- Get free API key: https://openweathermap.org/api
- Use `async/await` with `try...catch`
- Weather icons: Clear→☀️, Clouds→☁️, Rain→🌧️, Snow→❄️
- Forecast comes every 3 hours; filter for noon each day
- localStorage: `JSON.parse()` and `JSON.stringify()`
- Handle city not found (404 error)

### Expected Output

```
Weather Dashboard
-----------------------------------------
[London        ] [Search]

Recent: New York | Paris | Tokyo

London, GB
Partly Cloudy ☁️
18°C

Humidity: 65%    Wind: 12 km/h

5-Day Forecast
-----------------------------------------
Mon    Tue     Wed     Thu     Fri
☀️     ☁️      🌧️     ⛈️      ☀️
20°C   18°C    15°C    14°C    22°C
```

### Grading Criteria (15 points)
- [ ] API integration works (4 points)
- [ ] Current weather display (3 points)
- [ ] 5-day forecast display (3 points)
- [ ] Recent searches with localStorage (3 points)
- [ ] Error handling (1 point)
- [ ] Loading state (1 point)

---

## ✏️ Task 2.2: GitHub Repository Finder (15 points)

### 🎯 Real-World Application
Developer tools, code review platforms, and portfolio sites all integrate with GitHub's API to display repository information. Sites like GitExplorer, GitHub trending pages, and developer portfolios use the GitHub API to showcase projects.

### Challenge
Build a GitHub repository search and display tool.

### Requirements

**Features:**
- Search GitHub repositories by keyword
- Display repository details (name, description, stars, forks, language)
- Show repository owner information
- Link to GitHub repository
- Sort by stars/forks/updated
- Pagination (show more results)

**API Integration:**
- GitHub API: `https://api.github.com/search/repositories?q={query}&sort={sort}&page={page}`
- No API key needed for basic requests
- Rate limit: 60 requests per hour (unauthenticated)

**Functions to Implement:**
- `async searchRepositories(query, sort, page)` - Search repos
- `displayRepositories(repos)` - Display results
- `appendRepositories(repos)` - Add more results
- `getSortValue()` - Get selected sort option
- `loadMore()` - Load next page of results

### Starter Code

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>GitHub Repo Finder</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #0d1117;
            color: #c9d1d9;
            padding: 20px;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
        }
        
        .header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .header h1 {
            color: #58a6ff;
            margin-bottom: 10px;
        }
        
        .search-container {
            background: #161b22;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        
        .search-box {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }
        
        .search-box input {
            flex: 1;
            padding: 12px;
            background: #0d1117;
            border: 1px solid #30363d;
            border-radius: 6px;
            color: #c9d1d9;
            font-size: 16px;
        }
        
        .search-box button {
            padding: 12px 30px;
            background: #238636;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
        }
        
        .search-box button:hover {
            background: #2ea043;
        }
        
        .filters {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .filters label {
            color: #8b949e;
        }
        
        .filters select {
            padding: 8px 12px;
            background: #0d1117;
            border: 1px solid #30363d;
            border-radius: 6px;
            color: #c9d1d9;
        }
        
        .repo-card {
            background: #161b22;
            border: 1px solid #30363d;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            transition: transform 0.2s;
        }
        
        .repo-card:hover {
            transform: translateY(-2px);
            border-color: #58a6ff;
        }
        
        .repo-name {
            color: #58a6ff;
            font-size: 20px;
            font-weight: bold;
            text-decoration: none;
        }
        
        .repo-name:hover {
            text-decoration: underline;
        }
        
        .repo-description {
            color: #8b949e;
            margin: 10px 0;
        }
        
        .repo-meta {
            display: flex;
            gap: 20px;
            font-size: 14px;
            color: #8b949e;
        }
        
        .language-badge {
            display: inline-block;
            padding: 4px 10px;
            background: #1f6feb;
            border-radius: 12px;
            font-size: 12px;
        }
        
        .loading {
            text-align: center;
            padding: 40px;
            color: #8b949e;
        }
        
        .error {
            background: #da3633;
            color: white;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        
        .load-more {
            text-align: center;
            margin: 30px 0;
        }
        
        .load-more button {
            padding: 12px 40px;
            background: #21262d;
            border: 1px solid #30363d;
            color: #c9d1d9;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
        }
        
        .load-more button:hover {
            background: #30363d;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔍 GitHub Repository Finder</h1>
            <p style="color: #8b949e;">Search and explore GitHub repositories</p>
        </div>
        
        <div class="search-container">
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="Search repositories..." 
                       onkeypress="if(event.key==='Enter') performSearch()">
                <button onclick="performSearch()">Search</button>
            </div>
            
            <div class="filters">
                <label>Sort by:</label>
                <select id="sortSelect" onchange="performSearch()">
                    <option value="stars">⭐ Stars</option>
                    <option value="forks">🔱 Forks</option>
                    <option value="updated">🕒 Recently Updated</option>
                </select>
            </div>
        </div>
        
        <div id="errorMessage"></div>
        <div id="repoList"></div>
        <div id="loadMoreContainer"></div>
    </div>

    <script>
        let currentPage = 1;
        let currentQuery = '';
        let totalResults = 0;
        
        // TODO: Implement functions
        
        async function searchRepositories(query, sort = 'stars', page = 1) {
            // TODO: Fetch repositories from GitHub API
            // URL: `https://api.github.com/search/repositories?q=${query}&sort=${sort}&page=${page}&per_page=10`
        }
        
        function displayRepositories(repos, append = false) {
            // TODO: Display repository cards
            // If append is true, add to existing results
            // Otherwise, replace all results
        }
        
        function createRepoCard(repo) {
            // TODO: Create HTML for a single repository card
            // Include: name, description, stars, forks, language
            // repo.name, repo.description, repo.stargazers_count
            // repo.forks_count, repo.language, repo.html_url, repo.owner.login
        }
        
        async function performSearch() {
            // TODO: Get search query and sort option
            // TODO: Reset page to 1
            // TODO: Call searchRepositories
            // TODO: Display results
        }
        
        async function loadMore() {
            // TODO: Increment page
            // TODO: Fetch next page
            // TODO: Append results
        }
        
        function showError(message) {
            // TODO: Display error message
        }
        
        function clearError() {
            // TODO: Clear error message
        }
        
        function formatNumber(num) {
            // TODO: Format large numbers (e.g., 1500 -> 1.5k)
            if (num >= 1000) {
                return (num / 1000).toFixed(1) + 'k';
            }
            return num;
        }
    </script>
</body>
</html>
```

### Hints
- GitHub API response: `{ total_count, items: [] }`
- Each repo has: `name`, `description`, `stargazers_count`, `forks_count`, `language`, `html_url`, `owner.login`
- Use `per_page=10` to limit results
- Check `total_count` to show "Load More" button
- Handle rate limiting (status 403)

### Expected Output

```
🔍 GitHub Repository Finder
Search and explore GitHub repositories

[react                    ] [Search]
Sort by: [⭐ Stars ▼]

-----------------------------------------
facebook/react ⭐ 180k 🔱 36k
A declarative, efficient, and flexible JavaScript 
library for building user interfaces.
JavaScript
-----------------------------------------

vercel/next.js ⭐ 95k 🔱 20k
The React Framework for Production
JavaScript
-----------------------------------------

[Load More Results]
```

### Grading Criteria (15 points)
- [ ] Search functionality works (4 points)
- [ ] Repository cards display correctly (4 points)
- [ ] Sort functionality (2 points)
- [ ] Load more pagination (2 points)
- [ ] Error handling (2 points)
- [ ] Clean UI (1 point)

---

## Submission Guidelines

### What to Submit
1. All HTML files for completed tasks
2. Screenshots of working applications
3. Brief description of challenges faced (optional)

### File Naming
- `task1-1-form-validator.html`
- `task1-2-shopping-cart.html`
- `task2-1-weather-dashboard.html`
- `task2-2-github-finder.html`

### Submission Deadline
End of lab session or as announced by instructor

### Grading Summary
- Task 1.1: Form Validator (15 points)
- Task 1.2: Shopping Cart (15 points)
- Task 2.1: Weather Dashboard (15 points)
- Task 2.2: GitHub Finder (15 points)
- **In-Class Total: 60 points**

**Homework (30 points) + Bonus (10 points) will be announced at end of class**

---

## Time Management Guide

### Suggested Schedule (2.5 hours total)

**First Hour:**
- 0:00 - 0:05: Review requirements and setup (5 min)
- 0:05 - 0:35: Task 1.1 - Form Validator (30 min)
- 0:35 - 1:10: Task 1.2 - Shopping Cart (35 min)

**Break:** 10 minutes

**Second Hour:**
- 1:20 - 1:55: Task 2.1 - Weather Dashboard (35 min)
- 1:55 - 2:30: Task 2.2 - GitHub Finder (35 min)

**Buffer:** 10 minutes for testing and fixing issues

### Pacing Tips
- ⏰ Set a timer for each task
- ✅ Complete basic functionality first
- 🎨 Add polish if time permits
- 🆘 Ask for help if stuck >10 minutes
- 📝 Comment your code as you go

---

## Getting Help

### When to Ask for Help
- Stuck on the same error for >10 minutes
- Don't understand the requirement
- API not working as expected
- Need clarification on grading criteria

### How to Ask
1. **Show your code** - Don't just describe the problem
2. **Explain what you tried** - What debugging steps?
3. **Share the error message** - Check browser console
4. **Be specific** - "My form won't validate" vs "validateEmail() returns undefined"

### Resources Available
- 🙋 Instructor for clarification
- 👥 Classmates for discussion
- 📖 Pre-lab reading material
- 💻 Browser DevTools console
- 🤖 AI tools (cite if used)

---

## Testing Checklist

Before submitting each task, verify:

### Task 1.1 - Form Validator
- [ ] All fields validate on input
- [ ] Error messages appear/disappear correctly
- [ ] Border colors change (green/red)
- [ ] Submit button enables only when all valid
- [ ] Form submission works

### Task 1.2 - Shopping Cart
- [ ] Products display correctly
- [ ] "Add to Cart" adds items
- [ ] Cart count badge updates
- [ ] Quantity +/- buttons work
- [ ] Remove button works
- [ ] Total calculates correctly
- [ ] Toggle cart shows/hides

### Task 2.1 - Weather Dashboard
- [ ] Search finds cities
- [ ] Current weather displays
- [ ] Forecast shows 5 days
- [ ] Recent searches save and load
- [ ] Loading state appears
- [ ] Error messages show for invalid cities
- [ ] Enter key triggers search

### Task 2.2 - GitHub Finder
- [ ] Search returns results
- [ ] Repo cards display all info
- [ ] Links open GitHub pages
- [ ] Sort dropdown works
- [ ] Load More fetches next page
- [ ] Error handling works
- [ ] Empty search handled

---

## Common Issues & Solutions

### Issue 1: API Key Not Working
**Problem:** Weather API returns 401 error
**Solution:** 
- Double-check API key is correct
- Ensure API key is activated (may take a few minutes)
- Check if you're using the correct endpoint URL

### Issue 2: CORS Error
**Problem:** "Access blocked by CORS policy"
**Solution:** 
- For OpenWeather: Should work fine, check API key
- For GitHub: No CORS issues, check URL format
- Never experienced? Great! Continue coding.

### Issue 3: LocalStorage Not Saving
**Problem:** Data disappears on refresh
**Solution:**
```javascript
// Wrong
localStorage.setItem('cities', cities); // Won't work for arrays

// Correct
localStorage.setItem('cities', JSON.stringify(cities));
const saved = JSON.parse(localStorage.getItem('cities'));
```

### Issue 4: Event Listener Fires Multiple Times
**Problem:** Function called multiple times per click
**Solution:**
```javascript
// Wrong - adds listener every time
function setup() {
    button.addEventListener('click', handler);
}

// Correct - add once
button.addEventListener('click', handler);
```

### Issue 5: Cannot Read Property of Undefined
**Problem:** `Cannot read property 'textContent' of null`
**Solution:**
```javascript
// Check if element exists first
const element = document.getElementById('myId');
if (element) {
    element.textContent = 'Hello';
}
```

---

## Tips for Success

### Coding Best Practices
1. **Test frequently** - Run code after each function
2. **Use console.log()** - Debug step by step
3. **Read error messages** - They tell you exactly what's wrong
4. **Start simple** - Get basic version working first
5. **Comment your code** - Helps you and the grader

### Debugging Workflow
1. Open Browser DevTools (F12)
2. Check Console tab for errors
3. Use `console.log()` to track values
4. Set breakpoints in Sources tab
5. Test one function at a time

### Time Management
- ⏰ Stick to time limits per task
- ✅ Finish all tasks partially rather than one perfectly
- 🎯 Focus on core functionality first
- 🎨 Polish only if time permits
- 📝 Note issues to fix later if time runs out

### Working with APIs
- 📖 Read API documentation carefully
- 🔑 Keep API keys secure (don't share)
- 🧪 Test API calls in browser first
- ⏱️ Always handle loading states
- ❌ Always handle errors

---

## Quick Reference

### DOM Selection
```javascript
document.getElementById('id')
document.querySelector('.class')
document.querySelectorAll('div')
```

### Modifying Elements
```javascript
element.textContent = 'text'
element.innerHTML = '<strong>HTML</strong>'
element.value = 'input value'
element.classList.add('active')
element.classList.remove('hidden')
element.classList.toggle('visible')
```

### Event Listeners
```javascript
element.addEventListener('click', function(e) {
    console.log('Clicked!');
});

// Common events: 'click', 'input', 'change', 'submit', 'keypress'
```

### Array Methods
```javascript
// Find item
const item = array.find(x => x.id === 5);

// Filter items
const filtered = array.filter(x => x.active);

// Map/transform
const names = users.map(u => u.name);

// Check if exists
const exists = array.some(x => x.id === 5);
```

### Async/Await
```javascript
async function getData() {
    try {
        const response = await fetch(url);
        if (!response.ok) throw new Error('Failed');
        const data = await response.json();
        return data;
    } catch (error) {
        console.error(error);
    }
}
```

### LocalStorage
```javascript
// Save
localStorage.setItem('key', JSON.stringify(data));

// Load
const data = JSON.parse(localStorage.getItem('key'));

// Remove
localStorage.removeItem('key');
```

---

## After the Lab

### If You Finish Early
1. ✨ Add extra features (animations, styling)
2. 🐛 Test edge cases thoroughly
3. 📱 Make responsive for mobile
4. ♿ Add accessibility features
5. 🤝 Help classmates who are stuck

### If You Don't Finish
1. 📝 Note where you stopped
2. 💬 Ask questions before leaving
3. 🏠 Complete at home (still counts!)
4. 📧 Email instructor if major issues

### Next Steps
- Review your code and understand every line
- Try building similar projects on your own
- Explore additional API features
- Prepare for homework tasks (details at end of class)

---

## Homework Preview

These tasks will be completed after class. Full details provided at end of session:

### Task 3.1: Data Visualization Dashboard (15 points)
Build an interactive dashboard with charts showing sales data, revenue trends, and market share.

### Task 3.2: Memory Card Game (15 points)
Create a memory matching game with timer, scoring, and difficulty levels.

### Task 4.1: Note-Taking App (10 points - BONUS)
Build a feature-rich note app with tags, search, and persistent storage.

---

## Frequently Asked Questions

**Q: Can I use external libraries?**
A: No, use only vanilla JavaScript. This lab tests core JS skills.

**Q: What if my API key doesn't work?**
A: Raise your hand immediately. Instructor will help troubleshoot.

**Q: Can I work with a partner?**
A: You can discuss, but write your own code. Submit individual work.

**Q: How much time should I spend on styling?**
A: Basic styling is provided. Focus on functionality first.

**Q: What if I finish all tasks early?**
A: Add extra features, help others, or start homework tasks.

**Q: Can I use code from the pre-lab examples?**
A: Yes! The examples are meant to guide you.

**Q: Do I lose points for console errors?**
A: Only if they prevent functionality. Always check console!

**Q: Can I submit after the deadline?**
A: Ask instructor. Late submission policy varies.

---

## Final Checklist

Before submitting, verify:

- [ ] All 4 tasks attempted
- [ ] Code runs without critical errors
- [ ] Files named correctly
- [ ] API keys are NOT hardcoded (use instructor's or your own)
- [ ] Console is clear of errors
- [ ] Tested in Chrome/Firefox
- [ ] Screenshots taken (if required)
- [ ] Code is commented
- [ ] Ready to demo to instructor

---

**Good luck! Let's build something amazing! 🚀**

Remember: The goal is to learn, not to be perfect. Every error is a learning opportunity!

**Start Time: _______**
**End Time: _______**

---

*End of In-Class Tasks*