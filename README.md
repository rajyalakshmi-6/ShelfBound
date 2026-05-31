# 📚 ShelfBound – Online Bookstore Web Application

A full-stack e-commerce bookstore platform built using Java Servlets, JSP, JDBC, MySQL, and Apache Tomcat version 10, featuring role-based authentication, persistent cart management, wishlist functionality, order tracking, customer support management, and a comprehensive admin dashboard for inventory, orders, and customer interactions.

---

## 🎥 Project Demo


---

## 📖 Project Overview

ShelfBound is a full-stack online bookstore web application designed to provide a real-world e-commerce experience for both customers and administrators.

The platform allows users to browse books, manage wishlists, add products to cart, place orders, track order status, and communicate with administrators through a dedicated contact system.

In addition to customer-facing features, the application includes a powerful Admin Dashboard that enables administrators to manage books, monitor orders, view platform statistics, and respond to customer messages.

The project follows the MVC (Model–View–Controller) architecture and DAO Design Pattern to ensure maintainability, scalability, and clean separation of concerns.

---

## 🚀 Features

### 👤 Customer Features

* User Registration System
* User Login & Logout
* Session-Based Authentication
* Browse Books Catalog
* Category-Based Book Filtering
* View Detailed Book Information
* Add Books to Shopping Cart
* Persistent Cart Management
* Wishlist Management
* Checkout Process
* Shipping Address Collection
* Order Placement
* Order Tracking
* View Order History
* Contact Admin Through Contact Page
* Responsive User Interface

---

### 🔐 Authentication & Authorization

* User credentials are validated against records stored in the MySQL database.
* New users must register before accessing protected features.
* Session management is implemented using Java Servlets and HttpSession.
* Unauthorized users attempting to access protected pages are automatically redirected to the Login page.

Protected Features Include:

* Wishlist
* Cart Operations
* Orders Page
* Checkout Process
* User-Specific Actions

---

### 🛒 Cart & Order Management

* Add Books to Cart
* Update Cart Quantities
* Remove Books from Cart
* Database-Persistent Cart Storage
* Checkout Workflow
* Shipping Address Management
* Order Placement Workflow
* Order History Tracking
* Real-Time Order Status Updates

Supported Order Statuses:

* Pending
* Shipped
* Delivered

---

## 🛠️ Admin Dashboard Features

A dedicated Admin Panel is available for administrative operations and store management.

### 📊 Dashboard Analytics

The Admin Dashboard provides a quick overview of:

* Total Registered Users
* Total Books Available
* Total Orders
* Total Pending Orders
* Overall Store Statistics

---

### 📚 Book Management

Administrators can:

* Add New Books
* Update Book Stock
* Delete Books
* Manage Complete Inventory

---

### 📦 Order Management

Administrators can:

* View Customer Orders
* View Customer Information
* View Ordered Books
* Update Order Status

Order Status Workflow:

Pending → Shipped → Delivered

---

### 💬 Customer Message Management

Messages submitted through the Contact Page are directly available in the Admin Panel.

Administrators can:

* View Customer Messages
* Reply to Customer Queries
* Delete Messages

This enables direct communication between customers and administrators within the application.

---

## 🏗️ Architecture & Design

ShelfBound follows the MVC (Model–View–Controller) architecture.

### MVC Flow

#### Model Layer

* Java Bean Classes
* Entity Models
* Data Transfer Objects

#### Controller Layer

* Java Servlets
* Request Processing
* Session Management
* Authentication Logic

#### View Layer

* JSP Pages
* HTML5
* CSS3
* JavaScript

---

## 🧩 DAO Design Pattern

The application implements the DAO (Data Access Object) Design Pattern.

Benefits:

* Separation of Business Logic and Database Logic
* Better Maintainability
* Improved Scalability
* Reusable Database Operations
* Cleaner Project Structure

---

## 🔐 Role-Based Access Control

ShelfBound implements role-based access management.

### Customer Role

Customers can:

* Register
* Login
* Browse Books
* Add Books to Cart
* Manage Wishlist
* Place Orders
* Track Orders
* Contact Admin

### Admin Role

Administrators can:

* Access Secure Dashboard
* Manage Books
* Manage Orders
* Update Order Status
* View Platform Statistics
* Manage Customer Messages
* Reply to Customer Queries

---

## 🎨 Branding & User Experience

ShelfBound is designed as a modern bookstore platform featuring:

* Custom ShelfBound Logo
* Custom Brand Identity
* Dynamic User Interface
* Responsive Design
* Professional Admin Dashboard
* Modern E-Commerce Layout
* User-Friendly Navigation
* Interactive Notifications and Popups

All branding assets are custom-created and integrated into the application.

---

## 🗄️ Database Integration

The application uses:

* MySQL Database
* JDBC Connectivity
* Relational Database Design
* Optimized CRUD Operations
* Session-Aware User Workflows

Key Database Modules:

* Users
* Books
* Categories
* Cart
* Wishlist
* Orders
* Order Items
* Contact Messages

---

## 🛠️ Technology Stack

### Backend

* Java
* JSP
* Servlets
* JDBC

### Frontend

* HTML5
* CSS3
* JavaScript(basic)

### Database

* MySQL

### Server

* Apache Tomcat

### Development Tools

* Eclipse IDE
* MySQL Workbench
* Git
* GitHub

---

## 🤖 AI-Assisted Development Workflow

Modern AI tools were leveraged to accelerate development, improve productivity, and enhance design quality.

Tools utilized include:

* Claude – UI/UX refinement and interface improvement suggestions.
* Canva AI– Custom logo design .
* DesignArena AI – Hero section visual design and creative asset generation.

All application architecture, database design, business logic implementation, integration, testing, debugging, and deployment workflows were independently developed and integrated by the project author.

---

## 📸 Application Screenshots

### Home Page

(Add Screenshot Here)

### Books Page

(Add Screenshot Here)

### Book Details Page

(Add Screenshot Here)

### Cart Page

(Add Screenshot Here)

### Wishlist Page

(Add Screenshot Here)

### Checkout Page

(Add Screenshot Here)

### Orders Page

(Add Screenshot Here)

### Admin Dashboard

(Add Screenshot Here)

### Manage Books

(Add Screenshot Here)

### Manage Orders

(Add Screenshot Here)

### Customer Messages

(Add Screenshot Here)

---

## 🔮 Future Enhancements

* Online Payment Gateway Integration
* AI-Based Book Recommendation System
* Email Notifications
* Review & Rating System
* Cloud Deployment
* Mobile Application Development
* Play Store Deployment
* Advanced Analytics Dashboard
* Personalized User Recommendations

---

## 👩‍💻 Developer

**Rajyalakshmi Devarala**

Final-Year B.Tech (Electronics and Communication Engineering)

Passionate about:

* Java Full Stack Development
* Web Application Development
* Database Management Systems
* Software Engineering
* Backend Development
* AI-Assisted Product Development

---

## ⭐ Repository Support

If you found this project useful, consider giving the repository a star.

It helps increase visibility and supports future development.

⭐ Star the repository if you like the project.
