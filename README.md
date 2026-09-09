# 📚 ShelfBound — Online Bookstore Web Application

**A full-stack e-commerce bookstore, built from scratch — not from a template brief.**

![Java](https://img.shields.io/badge/Java-Jakarta%20Servlets%20%7C%20JSP-ED8B00?logo=openjdk&logoColor=white)
![Aiven MySQL](https://img.shields.io/badge/Aiven%20Cloud-MySQL%208.4%20SSL-4479A1?logo=mysql&logoColor=white)
![Tomcat](https://img.shields.io/badge/Server-Apache%20Tomcat%2010-F8DC75?logo=apachetomcat&logoColor=black)
![Docker](https://img.shields.io/badge/Docker-Multi--Stage-2496ED?logo=docker&logoColor=white)
![Deployment](https://img.shields.io/badge/Deployment-Render%20Live-46E3B7?logo=render&logoColor=white)
![Brevo API](https://img.shields.io/badge/Email-Brevo%20REST%20API-0B99FF?logo=sendinblue&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-MVC%20%2B%20DAO-blue)

### 🌐 [Explore Live Application](https://shelfbound-bookstore.onrender.com) · 📘 [Production Architecture & Cloud Guide](PRODUCTION_ARCHITECTURE_GUIDE.md) · 🎥 [Watch Demo](https://drive.google.com/file/d/1vZL-sO3S1cf9jhZlN2j7xfH868dBIF3k/view?usp=drivesdk) · 📊 [Presentation](presentation/ShelfBound.pptx)

---

## 📖 Project Overview

ShelfBound is a dynamic, responsive online bookstore that simulates a real e-commerce platform end-to-end — not a CRUD demo. It supports full **customer-side shopping workflows** and a **role-secured admin dashboard** for running the store.

Shoppers can browse books by category, manage a wishlist, apply a coupon at checkout, place orders, and track order status. Admins manage inventory, monitor orders, view live platform statistics, and respond to customer messages — all from a dedicated dashboard.

The application is built on the **MVC (Model–View–Controller)** architecture with the **DAO Design Pattern**, keeping business logic, data access, and presentation cleanly separated for maintainability and scale.

> **Why this project is different:** most learners in this batch built a food-delivery clone from a shared brief. ShelfBound was designed and built independently as a bookstore platform — including its own database schema, coupon engine, admin workflows, and branding.

---

## 🚀 Key Features

### 👤 Customer Features

- **User Registration with Email OTP Verification** — 6-digit numeric verification code sent to registered inbox with a live 5-minute countdown timer and resend capability.
- **Secure Password Reset Flow** — self-serve password recovery via email verification code and database password update.
- User Login & Logout with Session-Based Authentication
- **Automated Lifecycle Email Notifications**:
  - **Newsletter Welcome** — instant welcome email with `WELCOME20` 20% discount coupon upon subscribing on the home page.
  - **Order Confirmation Receipt** — itemized email receipt with book titles, quantities, prices, and shipping address on checkout.
  - **Order Status Updates** — automated email alerts when admin updates status (`Confirmed`, `Shipped`, `Delivered`, `Cancelled`).
  - **Support Inquiry Answers** — customer receives admin's reply directly in their inbox.
- Browse Books Catalog with Category-Based Filtering
- **Quick "Add to Cart" Micro-Button** — sleek blue-gradient cart action on all book cards across Home & Catalog with AJAX shopping, instant toast notifications, and zero page reloads.
- Detailed Book Information Pages
- Persistent, Database-Backed Shopping Cart
- **Dynamic Coupon Engine & Cart "All Offers" Popup**:
  - Centered modal popup on the Cart page displaying all active promotional deals.
  - Live eligibility analysis based on cart subtotal with real-time deficit alerts (e.g. *"Add ₹125 more to avail offer"*).
  - Single-click apply, dynamic totals recalculation, and instant coupon removal/switching.
- Wishlist Management with animated micro-interactions
- **Customer Profile & Membership Hub** — smoky glassmorphism membership card with clickable live metrics for Orders, Wishlist, and Cart, plus inline profile updating.
- Checkout with Shipping Address Collection & Persistence
- Order Placement & Order History
- Real-Time Order Status Tracking (Pending → Confirmed → Shipped → Delivered)
- Contact Admin via a Dedicated Contact Page
- **Smoky Glassmorphism UI** — atmospheric radial lighting gradients, frosted glass cards, and productivity shortcuts (`/` or `Ctrl+K` to search)

### 🔐 Authentication & Security

- **BCrypt Password Hashing (`$2a$12$...`)** — salted cryptographic one-way hashing with 12 salt rounds; includes smart zero-downtime auto-migration from legacy plain-text passwords upon login.
- **Email-Verified Identity** — user records saved to database only upon successful OTP entry.
- **Admin-Controlled Account Access** — admins can block compromised or suspicious users with immediate login denial.
- Credentials validated against MySQL-backed user records.
- Session management via Java Servlets and `HttpSession`.
- Unauthorized access to protected pages auto-redirects to Login.
- Role-based access control separating **Customer** and **Admin** capabilities.

### 🛒 Cart & Order Management

- Add / update / remove items with database-persistent cart storage
- Coupon discount recalculated live from the current subtotal — never a stale, hardcoded value
- Full checkout → order placement → order tracking workflow

---

## 🛠️ Admin Dashboard

A dedicated, secured Admin Panel for running the store day-to-day.

**📊 Dashboard Analytics** — total users, total books, total orders, and pending-order counts at a glance.

**👥 Customer Account Control & User Blocking** — monitor all registered customers, inspect account information, and block or unblock users with instant login restriction.

**🏷️ Promotional Offers & Dynamic Coupon Engine** — create, edit, toggle, or delete discount coupons with custom codes, discount percentages (1–100%), minimum order values, and descriptions; pre-populated modal for seamless in-place editing with duplicate code protection; real-time customer cart and checkout synchronization.

**📚 Book Management** — add, update, and delete books; manage stock and full inventory.

**📦 Order Management & Status Notifications** — view customer orders, order details, and update order status through Pending → Confirmed → Shipped → Delivered with automated customer emails.

**💬 Customer Message Management & Direct Email Replies** — view customer contact submissions, delete or reply to inquiries, with responses dispatched directly to customer email inboxes.

---

## 🏗️ Architecture & Design

**MVC Flow**

 Layers:- 

 **Model** -> Java Beans, entity models.
 
 **Controller** -> Java Servlets — request handling, session management, auth logic 
 
 **View** -> JSP, HTML5, CSS3, JavaScript (AJAX for dynamic updates) 

**DAO Design Pattern** separates business logic from database logic — cleaner code, easier testing, and reusable data-access methods across the app.

**Project Structure**

```
com.shelfbound.*
 ├── connection/      → DB connection handling
 ├── dao/ , daoimpl/  → Data access contracts + JDBC implementations
 ├── model/           → Entity / bean classes
 ├── servlet/         → Customer-facing controllers (Cart, Wishlist, Order, ...)
 └── servlet.admin/   → Admin-facing controllers

webapp/
 ├── css/ , js/ , images/ , videos/   → per-page CSS to isolate styling bugs
 ├── customer/        → customer-facing JSP views
 └── WEB-INF/         → web.xml, lib/
```

One servlet per feature (Cart, Wishlist, Order, Admin operations), and per-page CSS instead of one shared stylesheet — a deliberate choice to keep styling bugs isolated to a single page rather than cascading across the app.

---

## 🗄️ Database Design

Hosted on **Aiven Cloud Managed MySQL 8.4** over encrypted TLS/SSL (`sslmode=REQUIRED`), accessed via JDBC with a fully relational, foreign-key-constrained schema across **9 normalized tables**.

---

### Schema Overview

- **users** — `user_id` (PK), username, email, password, phone, address, city, state, pincode, created_at, `status` (`ACTIVE` / `BLOCKED`)  
  → Referenced by: cart, wishlist, orders

- **admin** — `admin_id` (PK), username, password  
  → Standalone

- **categories** — `category_id` (PK), category_name  
  → Referenced by: books

- **books** — `book_id` (PK), `category_id` (FK), title, author, price, stock_qty , image_url, rating , category_id, is_new_arrival, is_popular, created_at
  → Referenced by: cart, wishlist, order_items

- **cart** — `cart_id` (PK), `user_id` (FK), `book_id` (FK), quantity  
  → Links users ↔ books

- **wishlist** — `wishlist_id` (PK), `user_id` (FK), `book_id` (FK), added_at  
  → Links users ↔ books

- **orders** — `order_id` (PK), `user_id` (FK), total_amount, order_status, payment_method, shipping_address, order_date  
  → Parent of order_items

- **order_items** — `order_item_id` (PK), `order_id` (FK), `book_id` (FK), quantity, price  
  → Line items per order

- **contact_messages** — `message_id` (PK), name, email, message, submitted_at, status, admin_reply, replied_at 
  → Standalone — feeds Admin message panel


**Design choices** optimized CRUD operations, `PreparedStatement` usage throughout to prevent SQL injection, and session-aware workflows so cart/wishlist state persists correctly per logged-in user.

---

## 🔍 Engineering Deep-Dive: A Real Bug, Traced and Fixed

**The problem:** when an admin updated an order's status from the Manage Orders panel, the change didn't reliably show up on the customer's My Orders page — the status the customer saw lagged behind what the admin had just set.

**The fix:** traced the bug to the order list being served from a stale query result within the same request cycle as the update. The flow was split so `AdminOrderServlet` handles the status **update**, then issues a **redirect** (not a forward) back to the orders view. The redirect forces a fresh `GET` + fresh `SELECT`, so both the admin and customer views always read the current row from the database — a textbook **Post/Redirect/Get** fix for a stale-read bug.

---

## ✨ Under-the-Hood Highlight: Coupon Discount Logic

Applying `WELCOME20` recalculates subtotal, discount, and grand total in a single pass, kept in sync across the cart and checkout pages:

```java
// CartServlet — applyCoupon()
double subtotal = cartDao.getSubtotal(userId);
String coupon = request.getParameter("coupon");
double discount = 0.0;

if ("WELCOME20".equalsIgnoreCase(coupon)) {
    discount = subtotal * 0.20;
} else {
    session.setAttribute("couponError", "Invalid or expired code");
}

double shipping = 0.0; // free shipping, always
double grandTotal = subtotal - discount + shipping;

session.setAttribute("discount", discount);
session.setAttribute("grandTotal", grandTotal);
response.sendRedirect("cart");
```

- **Single source of truth** — the discount is recomputed from the *live* subtotal, not stored as a fixed value, so it stays correct even if the cart quantity changes after the coupon is applied.
- **Session-scoped** — discount and grand total live in session, so cart and checkout always render identical numbers without recalculating twice.
- **Verified against the UI** — ₹1198 subtotal × 20% = ₹239.60 discount, matching exactly what renders on the cart and checkout screens.

---

## 🛠️ Technology Stack

- 🎨 **Frontend:** HTML5, CSS3 (Smoky Glassmorphism), JavaScript (ES6+, Fetch API)
- ☕ **Backend:** Java 21 (LTS), Jakarta Servlets 6.0, JSP 3.1, Apache Tomcat 10.1
- 🏛️ **Architecture:** MVC (Model-View-Controller) Pattern, DAO (Data Access Object) Pattern
- ☁️ **Cloud Database:** Aiven Cloud Managed MySQL 8.4 (9 Normalized Tables, TLS/SSL `sslmode=REQUIRED`)
- 🐳 **DevOps & Cloud:** Docker (Multi-Stage Build), Render Cloud Platform (Automated CI/CD)
- 📧 **Email Service:** Brevo HTTPS REST API v3 (Native `HttpClient`, Port 443 Direct Dispatch)
- 🔐 **Security & Auth:** BCrypt Password Hashing (`jbcrypt`), 6-Digit Email OTP Verification, Role-Based Access Control (RBAC)
- 🧰 **Build & Tools:** Apache Maven 3.9, Git, Eclipse IDE, Postman


---

## 🎨 Branding & User Experience

- Custom ShelfBound logo and brand identity
- Dynamic, responsive UI with interactive notifications and popups
- Professional, analytics-driven admin dashboard
- User-friendly navigation across a modern e-commerce layout

All branding assets are custom-created and integrated into the application.

---

## 🤖 AI-Assisted Development Workflow

Modern AI tools were used to accelerate development and improve design quality:

- **Claude** — UI/UX refinement and interface improvement suggestions
- **Canva AI** — custom logo design
- **DesignArena AI** — hero section visual design and creative asset generation

All application architecture, database design, business logic, integration, testing, debugging, and deployment were independently designed and implemented by the project author.

---

## 📸 Project Screenshots & Visual Tour

### 🏠 Home & Discovery
![Home Page](screenshots/home-page-1.png)
![Home Page Featured & Categories](screenshots/home-page-2.png)
![Home Page Newsletter & Footer](screenshots/home-page-3.png)

---

## 👤 Customer Experience & Security

### 🔐 Customer Login (Smoky Glassmorphism & Forgot Password)
![Customer Login](screenshots/customer_login.png)

### 📝 Customer Registration
![Customer Register](screenshots/customer_register.png)

### 🔑 Email OTP Verification (Live 5-Minute Countdown)
![OTP Verification](screenshots/otp-verification-page.png)

### 🔄 Password Recovery (Reset Password)
![Reset Password](screenshots/reset-password-page.png)

### 📧 Automated Real-Time Email Proof (Live Inbox Delivery)

ShelfBound dispatches HTML emails directly to user inboxes over Brevo's HTTPS API. Here is the visual proof from a real Gmail inbox:

#### 1. Account Registration OTP Verification Code
![Registration OTP Email](screenshots/email-otp-verification.png)

#### 2. Newsletter Welcome Gift with `WELCOME20` Coupon
![Newsletter Welcome Email](screenshots/email-newsletter-welcome.png)

#### 3. Itemized Order Confirmation & Receipt
![Order Confirmation Receipt Email](screenshots/email-order-confirmation.png)

#### 4. Live Order Status Updates (Shipped / Delivered)
![Order Status Update Email](screenshots/email-order-status-update.png)

#### 5. Self-Serve Password Reset Verification
![Password Reset Email](screenshots/email-password-reset.png)

#### 6. Customer Support Admin Direct Reply
![Support Inquiry Response Email](screenshots/email-support-reply.png)

### 📚 Books Catalog & Filtering
![Books Page](screenshots/books-page.png)

### 📖 Book Details & Stock Status
![Book Details](screenshots/book-details-page.png)

### ❤️ Wishlist Management
![Wishlist Page](screenshots/wishlist-page.png)

### 🛒 Shopping Cart & Dynamic Coupon Engine
![Cart Page 1](screenshots/cart-page-1.png)
![Cart Page 2](screenshots/cart-page-2.png)

### 💳 Checkout & Shipping Address
![Checkout Page 1](screenshots/checkout-page-1.png)
![Checkout Page 2](screenshots/checkout-page-2.png)

### 📦 Order Placement & Success
![Order Success](screenshots/ordersuccess-page.png)

### 📦 Customer Orders & Status Tracking
![Orders Page](screenshots/orders-page.png)
![Order Details 1](screenshots/orderdetails-page-1.png)
![Order Details 2](screenshots/orderdetails-page-2.png)

### 📩 Contact Admin Support
![Contact Page](screenshots/contact_us-page.png)

### 👤 Customer Profile
![Profile Page 1](screenshots/profile-page-1.png)
![Profile Page 2](screenshots/profile-page-2.png)

---

## 🛠️ Admin Control Console

### 🔐 Admin Authentication
![Admin Login](screenshots/admin-login.png)

### 📊 Admin Analytics Dashboard
![Admin Dashboard](screenshots/admin-dashboard.png)

### 👥 Customer Account Control & User Blocking (Manage Users)
![Manage Users](screenshots/manage-users-page.png)

### 🏷️ Promotional Offers & Coupon Management
![Manage Offers](screenshots/manage-offers-page.png)
![Add New Offer](screenshots/add-offer-page.png)

### 📚 Inventory & Book Management
![Manage Books](screenshots/manage-books.png)
![Add New Book](screenshots/add-book-page.png)

### 📦 Order Fulfillment & Status Updates
![Manage Orders](screenshots/manage-orders.png)

### 🧾 Inquiries & Email Response Console
![Manage Messages](screenshots/manage-messages.png)

---

## 📱 Cross-Device & Mobile Responsiveness

ShelfBound was engineered with fluid responsiveness to ensure a seamless shopping experience across all device formats:

- **Desktop (1200px+)**: Expansive multi-column layouts, sticky filter sidebars, 3D card tilts, and ambient glow effects.
- **Tablets & Laptops (768px – 1024px)**: Adaptive 2-column book catalogs, collapsible navigation links, and auto-reflowing dashboard KPI cards.
- **Mobile Phones (≤ 480px / 360px – 414px)**:
  - Responsive single/two-column grids with touch-optimized target sizes.
  - Horizontally swipeable data tables (`overflow-x: auto` with smooth iOS/Android momentum scrolling).
  - Stackable checkout cards and mobile-friendly OTP verification containers.
  - Viewport-calibrated fonts preventing unwanted mobile browser zooming.

---

## ℹ️ About ShelfBound
![About Page](screenshots/about-page.png)

---

## 🔮 Future Enhancements

### 1. 💳 Online Payment Gateway
Integrated card, UPI, and NetBanking payments alongside the current Cash-on-Delivery flow.

### 2. 🗺️ Live Order Tracking Map
Real-time delivery progress shown on an interactive map from dispatch to doorstep.

### 3. 🌐 Internationalization & Multi-Currency (i18n / l10n)
Support for regional languages and multi-currency pricing for global shoppers.

### 4. 🤖 AI-Powered Customer Support Chatbot
Integration of an intelligent conversational chatbot for instant user interaction, automated query resolution, real-time order status tracking, and 24/7 customer assistance.

### 5. ⭐ AI-Based Book Recommendations
Personalized book suggestions based on browsing history and previous purchases.

### 6. 📝 Customer Review & Star Rating System
Customer reviews, photo uploads, and 5-star ratings on book detail pages.

### 7. 📱 Mobile App + Play Store Deployment
Native companion app for mobile shopping and push notifications.

### 8. 📈 Advanced Sales Analytics
Interactive revenue charts, monthly inventory forecasting, and customer retention metrics for store administrators.

---

## 👩‍💻 Developer Info

- **Project Type:** Individual Project
- **Domain:** Full Stack Java Web Development
- **Focus:** E-commerce + Backend Architecture

**Rajyalakshmi Devarala**
   
  B.Tech, Electronics and Communication Engineering

**Passionate about:**
- Java Full Stack Development
- Web Application Development
- Database Management Systems
- Software Engineering & Backend Development
- AI-Assisted Product Development

---

## ⭐ Repository Support

If you found this project useful, consider giving the repository a star — it helps increase visibility and supports future development.

⭐ **Star the repository if you like the project.**
