# jewellery_ordering_app

# Jewellery Ordering App

## Overview
This is a Flutter-based **Jewellery Ordering Application** that includes **user authentication**, **product listings**, **cart functionality**, **payment processing**, and **sales visualization through graphs**.

## Features
- **Google Sign-In Authentication**
- **Bottom Navigation** (Home & Profile Tabs)
- **Sales Graph** (Bar Chart for Product Sales)
- **Jewellery Listings** (Horizontal & Vertical Lists)
- **Jewellery Details Page** (With Quantity Selection & Add to Cart)
- **Cart Functionality** (Local Storage with SharedPreferences)
- **Payment Integration** (Stripe/PhonePe/Razorpay in Test Mode)
- **Profile Page** (Google User Details & Logout)

### 1. Clone the Repository
```sh
git clone https://github.com/bhupendraks30/Flutter_Jewellery_Ordering_Application 
cd jewellery-app
```
### 2. Install Dependencies
```sh
flutter pub get
```

### 3. Run the Application
```sh
flutter run
```

## API Integration
This app fetches jewellery items from the **Fake Store API**:
```sh
https://fakestoreapi.com/products/category/jewelery
```

## Features Breakdown

### 1. Authentication
- Google Sign-In via Firebase Authentication
- Fetch user's name and profile picture
- Logout functionality

### 2. Navigation
- Bottom Navigation Bar with Home & Profile Tabs

### 3. Home Page
#### Sales Graph
- A bar chart displaying the quantity of each product sold (max 4 products)
- Uses SharedPreferences to store and retrieve product sales data
- Labels: **X-axis: Product Name, Y-axis: Count**

#### Jewellery Listings
- Horizontal Scrollable List (2-3 items per row in a card view)
- Vertical Scrollable List (All available items in a card view)
- Card Details:**
    - Name
    - Image
    - Price
    - Short description
    - Rating badge (Top left corner)
    - "Add to Cart" button

### 4. Jewellery Details Page
- Shows product image (20-30% of screen height)
- Displays name, description, price
- Increment/Decrement button for quantity
- "Add to Cart" button

### 5. Cart Functionality (Local Storage, No API Calls)
- Cart icon with a badge showing item count
- Vertical list displaying selected cart items
- Users can:
    - Change quantity
    - View subtotal, taxes (dummy), and total
    - Proceed to checkout

### 6. Payment Integration
- Supports Razorpay in Test Mode
- Handles payment success & failure scenarios
- Displays an order confirmation popup on successful payment
- Redirects user to Home Page after checkout

### 7. Profile Page
- Displays Google account details (Name, Email, Profile Picture)
- Logout button

## State Management
The app uses Provider for state management.


## Technologies Used
- Flutter
- Firebase Authentication (Google Sign-In)
- SharedPreferences (Local Storage)
- Flutter Charts Library (Sales Graphs)
- Razorpay (Payment Gateway)
- Provider (State Management)
