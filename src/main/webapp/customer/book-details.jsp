<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.shelfbound.model.Book" %>

<%
    Book book = (Book) request.getAttribute("book");

    if (book == null) {
        response.sendRedirect(request.getContextPath() + "/books");
        return;
    }

    String appName = "ShelfBound";
    String username = (String) session.getAttribute("username");

    // Check if book is in wishlist (you can pass this from servlet)
    Boolean inWishlist = (Boolean) request.getAttribute("inWishlist");
    if (inWishlist == null) inWishlist = false;
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= book.getTitle() %> - <%= appName %></title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
:root {
    --primary-blue: #1e3a8a;
    --primary-blue-light: #2563eb;
    --primary-blue-dark: #0f1f4d;
    --accent-orange: #ff7a00;
    --accent-orange-light: #ff9500;
    --accent-orange-soft: #fff4e6;
    --bg-white: #ffffff;
    --bg-light: #f8fafc;
    --bg-gradient-start: #dff6ff;
    --bg-gradient-end: #a8d8ff;
    --text-dark: #1e293b;
    --text-medium: #475569;
    --text-muted: #64748b;
    --text-light: #94a3b8;
    --border-light: #e2e8f0;
    --border-lighter: #f1f5f9;
    --success: #10b981;
    --success-light: #d1fae5;
    --danger: #ef4444;
    --danger-light: #fee2e2;
    --warning: #f59e0b;
    --shadow-sm: 0 1px 2px rgba(0,0,0,0.04);
    --shadow-md: 0 4px 12px rgba(0,0,0,0.06);
    --shadow-lg: 0 12px 40px rgba(0,0,0,0.1);
    --shadow-xl: 0 20px 60px rgba(0,0,0,0.12);
    --radius-sm: 8px;
    --radius-md: 12px;
    --radius-lg: 16px;
    --radius-xl: 20px;
    --radius-full: 9999px;
    --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

* { box-sizing: border-box; margin: 0; padding: 0; }

html { scroll-behavior: smooth; }

body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    background: linear-gradient(180deg, #f0f9ff 0%, #ffffff 300px);
    min-height: 100vh;
    color: var(--text-dark);
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

/* ═══════════════════════════════════════════════════════════════
   NAVBAR (standardized to match books.css)
   ═══════════════════════════════════════════════════════════════ */
.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 14px 40px;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(12px);
    border-bottom: 1px solid var(--border-light);
    position: sticky;
    top: 0;
    z-index: 1000;
    box-shadow: var(--shadow-sm);
}

.logo-container {
    display: flex;
    align-items: center;
    gap: 0;
    text-decoration: none;
    transition: var(--transition);
}

.logo-container:hover { opacity: 0.95; }

.logo-img {
    height: 32px;
    width: auto;
    object-fit: contain;
}

.logo {
    font-size: 28px;
    font-weight: 800;
    letter-spacing: -0.5px;
    display: flex;
    align-items: center;
    line-height: 1;
}

.logo-shelf { color: var(--accent-orange); }
.logo-bound { color: var(--primary-blue); }

.nav-links {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px;
}

.nav-links a {
    text-decoration: none;
    color: var(--text-muted);
    font-weight: 600;
    font-size: 14px;
    padding: 8px 14px;
    border-radius: 8px;
    transition: var(--transition);
}

.nav-links a:hover {
    color: var(--primary-blue);
    background: rgba(30, 58, 138, 0.07);
}

.nav-links a.active {
    color: var(--primary-blue);
    background: rgba(30, 58, 138, 0.07);
}

.welcome-user {
    color: var(--primary-blue);
    font-weight: 700;
    font-size: 13px;
    padding: 8px 14px;
    background: rgba(30, 58, 138, 0.06);
    border-radius: 8px;
}

/* ================= LOGOUT BUTTON ================= */
.btn-logout {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 42px;
    height: 42px;
    border-radius: 10px;
    background: rgba(255, 255, 255, 0.08);
    color: #fff;
    font-size: 16px;
    transition: all 0.3s ease;
    margin-left: 10px;
    vertical-align: middle;
    border: 1px solid rgba(255, 255, 255, 0.15);
}

.btn-logout:hover {
    background: #ef4444;
    border-color: #ef4444;
    color: #fff;
    transform: scale(1.08);
    box-shadow: 0 0 14px rgba(239, 68, 68, 0.4);
}

.btn-logout svg { display: block; }

/* ================= PROFILE AVATAR ================= */
.profile-avatar-link {
    display: inline-flex;
    text-decoration: none;
    padding: 0 !important;
}

.profile-avatar {
    width: 34px;
    height: 34px;
    border-radius: 50%;
    background: var(--primary-blue);
    color: #ffffff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 13px;
    font-weight: 700;
    letter-spacing: 0.3px;
    box-shadow: 0 2px 6px rgba(30, 58, 138, 0.3);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
    user-select: none;
}

.profile-avatar-guest {
    background: #f1f5f9;
    font-size: 16px;
    box-shadow: none;
    border: 1.5px solid var(--border-light);
    color: var(--text-muted);
}

.profile-avatar-link:hover .profile-avatar {
    transform: scale(1.08);
    box-shadow: 0 4px 10px rgba(30, 58, 138, 0.4);
}

@media (max-width: 900px) {
    .navbar { flex-direction: column; gap: 12px; padding: 14px 20px; }
    .nav-links { justify-content: center; gap: 8px; }
}
/* ═══════════════════════════════════════════════════════════════
   BREADCRUMB
   ═══════════════════════════════════════════════════════════════ */
.breadcrumb-wrapper {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px 40px 0;
}

.breadcrumb {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 13px;
    color: var(--text-muted);
}

.breadcrumb a {
    color: var(--text-muted);
    text-decoration: none;
    font-weight: 500;
    transition: color 0.2s;
}
.breadcrumb a:hover { color: var(--primary-blue); }

.breadcrumb-separator {
    color: var(--text-light);
    font-size: 11px;
}

.breadcrumb-current {
    color: var(--text-dark);
    font-weight: 600;
}

/* ═══════════════════════════════════════════════════════════════
   MAIN PRODUCT CONTAINER
   ═══════════════════════════════════════════════════════════════ */
.product-wrapper {
    max-width: 1200px;
    margin: 24px auto 80px;
    padding: 0 40px;
}

.product-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 60px;
    background: var(--bg-white);
    border-radius: var(--radius-xl);
    box-shadow: var(--shadow-lg);
    border: 1px solid var(--border-lighter);
    padding: 48px;
    overflow: hidden;
}

/* ═══════════════════════════════════════════════════════════════
   IMAGE GALLERY
   ═══════════════════════════════════════════════════════════════ */
.image-section {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.main-image-wrapper {
    position: relative;
    background: linear-gradient(135deg, #f8fafc, #f1f5f9);
    border-radius: var(--radius-lg);
    padding: 32px;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 480px;
    overflow: hidden;
}

.main-image-wrapper::before {
    content: '';
    position: absolute;
    inset: 0;
    background: radial-gradient(circle at center, rgba(30,58,138,0.03) 0%, transparent 70%);
    pointer-events: none;
}

.main-image {
    max-width: 320px;
    width: 100%;
    height: 440px;
    object-fit: cover;
    border-radius: var(--radius-md);
    box-shadow: var(--shadow-xl);
    transition: var(--transition);
    position: relative;
    z-index: 1;
}

.main-image:hover {
    transform: scale(1.03) rotate(-1deg);
    box-shadow: 0 24px 80px rgba(0,0,0,0.15);
}

.badge-row {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
}

.badge {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 12px;
    font-weight: 700;
    padding: 6px 14px;
    border-radius: var(--radius-full);
    text-transform: uppercase;
    letter-spacing: 0.05em;
}

.badge-bestseller {
    background: linear-gradient(135deg, var(--accent-orange-soft), #ffe4cc);
    color: #c2410c;
    border: 1px solid #fed7aa;
}

.badge-new {
    background: linear-gradient(135deg, #dbeafe, #bfdbfe);
    color: #1d4ed8;
    border: 1px solid #93c5fd;
}

.badge-stock {
    background: linear-gradient(135deg, var(--success-light), #a7f3d0);
    color: #065f46;
    border: 1px solid #6ee7b7;
}

.badge-out {
    background: linear-gradient(135deg, var(--danger-light), #fecaca);
    color: #991b1b;
    border: 1px solid #fca5a5;
}

/* ═══════════════════════════════════════════════════════════════
   PRODUCT INFO
   ═══════════════════════════════════════════════════════════════ */
.info-section {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.category-tag {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 12px;
    font-weight: 600;
    color: var(--primary-blue);
    background: linear-gradient(135deg, #dbeafe, #eff6ff);
    padding: 6px 14px;
    border-radius: var(--radius-full);
    border: 1px solid #bfdbfe;
    width: fit-content;
}

.book-title {
    font-size: 36px;
    font-weight: 800;
    color: var(--text-dark);
    line-height: 1.2;
    letter-spacing: -0.5px;
}

.author {
    font-size: 16px;
    color: var(--text-medium);
    font-weight: 500;
}
.author a {
    color: var(--primary-blue);
    text-decoration: none;
    font-weight: 600;
}
.author a:hover { text-decoration: underline; }

/* Rating */
.rating-wrapper {
    display: flex;
    align-items: center;
    gap: 12px;
    flex-wrap: wrap;
}

.stars {
    display: flex;
    gap: 2px;
}

.star {
    font-size: 18px;
    color: #e2e8f0;
    transition: color 0.2s;
}
.star.filled { color: var(--warning); }
.star.half { 
    background: linear-gradient(90deg, var(--warning) 50%, #e2e8f0 50%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}

.rating-text {
    font-size: 14px;
    font-weight: 600;
    color: var(--text-dark);
}

.rating-count {
    font-size: 13px;
    color: var(--text-muted);
}

/* Price */
.price-section {
    background: linear-gradient(135deg, var(--accent-orange-soft), #fff7ed);
    border: 1px solid #fed7aa;
    border-radius: var(--radius-lg);
    padding: 20px 24px;
    display: flex;
    align-items: baseline;
    gap: 12px;
    flex-wrap: wrap;
}

.price-current {
    font-size: 36px;
    font-weight: 900;
    color: var(--accent-orange);
    letter-spacing: -1px;
}

.price-original {
    font-size: 20px;
    font-weight: 500;
    color: var(--text-light);
    text-decoration: line-through;
}

.price-discount {
    font-size: 14px;
    font-weight: 700;
    color: var(--success);
    background: var(--success-light);
    padding: 4px 10px;
    border-radius: var(--radius-full);
}

/* Description */
.description-box {
    background: var(--bg-light);
    border: 1px solid var(--border-lighter);
    border-radius: var(--radius-md);
    padding: 20px;
}

.description-label {
    font-size: 12px;
    font-weight: 700;
    color: var(--text-light);
    text-transform: uppercase;
    letter-spacing: 0.08em;
    margin-bottom: 10px;
}

.description-text {
    font-size: 15px;
    line-height: 1.8;
    color: var(--text-medium);
}

/* Meta info */
.meta-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
}

.meta-item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 12px 16px;
    background: var(--bg-light);
    border-radius: var(--radius-md);
    border: 1px solid var(--border-lighter);
}

.meta-icon {
    width: 36px;
    height: 36px;
    border-radius: var(--radius-md);
    background: linear-gradient(135deg, #dbeafe, #bfdbfe);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
    flex-shrink: 0;
}

.meta-content {
    display: flex;
    flex-direction: column;
}

.meta-label {
    font-size: 11px;
    font-weight: 600;
    color: var(--text-light);
    text-transform: uppercase;
    letter-spacing: 0.05em;
}

.meta-value {
    font-size: 14px;
    font-weight: 700;
    color: var(--text-dark);
}

/* ═══════════════════════════════════════════════════════════════
   ACTION AREA
   ═══════════════════════════════════════════════════════════════ */
.action-area {
    display: flex;
    flex-direction: column;
    gap: 16px;
    margin-top: 8px;
}

.quantity-selector {
    display: flex;
    align-items: center;
    gap: 0;
    border: 2px solid var(--border-light);
    border-radius: var(--radius-md);
    overflow: hidden;
    width: fit-content;
}

.qty-btn {
    width: 44px;
    height: 44px;
    border: none;
    background: var(--bg-light);
    color: var(--text-dark);
    font-size: 18px;
    font-weight: 600;
    cursor: pointer;
    transition: var(--transition);
    display: flex;
    align-items: center;
    justify-content: center;
}
.qty-btn:hover { background: var(--border-light); }
.qty-btn:active { transform: scale(0.95); }

.qty-input {
    width: 60px;
    height: 44px;
    border: none;
    border-left: 2px solid var(--border-light);
    border-right: 2px solid var(--border-light);
    text-align: center;
    font-size: 16px;
    font-weight: 700;
    color: var(--text-dark);
    background: var(--bg-white);
    -moz-appearance: textfield;
}
.qty-input::-webkit-outer-spin-button,
.qty-input::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }

.button-row {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
}

.btn-cart {
    flex: 1;
    min-width: 180px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    padding: 16px 28px;
    background: linear-gradient(135deg, var(--primary-blue), var(--primary-blue-light));
    color: #ffffff;
    border: none;
    border-radius: var(--radius-md);
    font-size: 15px;
    font-weight: 700;
    cursor: pointer;
    transition: var(--transition);
    box-shadow: 0 4px 14px rgba(30, 58, 138, 0.3);
    text-decoration: none;
}

.btn-cart:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 24px rgba(30, 58, 138, 0.4);
}

.btn-cart:active { transform: translateY(0); }

.btn-wishlist {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 16px 24px;
    background: var(--bg-white);
    color: var(--danger);
    border: 2px solid var(--border-light);
    border-radius: var(--radius-md);
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
    transition: var(--transition);
    text-decoration: none;
}

.btn-wishlist:hover {
    border-color: var(--danger);
    background: var(--danger-light);
    transform: translateY(-2px);
}

.btn-wishlist.active {
    background: var(--danger-light);
    border-color: var(--danger);
    color: var(--danger);
}

/* Trust badges */
.trust-row {
    display: flex;
    gap: 16px;
    flex-wrap: wrap;
    padding-top: 16px;
    border-top: 1px dashed var(--border-light);
}

.trust-item {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 12px;
    font-weight: 600;
    color: var(--text-muted);
}

.trust-item i {
    font-size: 16px;
    color: var(--success);
}

/* ═══════════════════════════════════════════════════════════════
   RELATED / YOU MAY ALSO LIKE
   ═══════════════════════════════════════════════════════════════ */
.section-title {
    font-size: 24px;
    font-weight: 800;
    color: var(--text-dark);
    margin: 48px 0 24px;
    display: flex;
    align-items: center;
    gap: 12px;
}

.section-title::after {
    content: '';
    flex: 1;
    height: 1px;
    background: linear-gradient(90deg, var(--border-light), transparent);
}

/* ═══════════════════════════════════════════════════════════════
   RESPONSIVE
   ═══════════════════════════════════════════════════════════════ */
@media (max-width: 1024px) {
    .product-grid {
        grid-template-columns: 1fr;
        gap: 40px;
        padding: 32px;
    }
    .main-image-wrapper { min-height: 360px; }
    .main-image { max-width: 260px; height: 360px; }
}

@media (max-width: 768px) {
    .navbar { padding: 14px 20px; }
    .breadcrumb-wrapper { padding: 16px 20px 0; }
    .product-wrapper { padding: 0 20px; margin-bottom: 40px; }
    .product-grid { padding: 24px; gap: 32px; }
    .book-title { font-size: 28px; }
    .price-current { font-size: 28px; }
    .meta-grid { grid-template-columns: 1fr; }
    .button-row { flex-direction: column; }
    .btn-cart, .btn-wishlist { width: 100%; }
}

@media (max-width: 480px) {
    .main-image-wrapper { min-height: 280px; padding: 20px; }
    .main-image { max-width: 200px; height: 280px; }
    .book-title { font-size: 24px; }
}

/* ═══════════════════════════════════════════════════════════════
   ANIMATIONS
   ═══════════════════════════════════════════════════════════════ */
@keyframes fadeInUp {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}

.animate-in {
    animation: fadeInUp 0.6s cubic-bezier(0.4, 0, 0.2, 1) forwards;
    opacity: 0;
}

.delay-1 { animation-delay: 0.1s; }
.delay-2 { animation-delay: 0.2s; }
.delay-3 { animation-delay: 0.3s; }
</style>
</head>
<body>

<!-- ═══════════════════════════════════════════════════════════════
     NAVBAR
     ═══════════════════════════════════════════════════════════════ -->
<div class="navbar">
    <a href="<%= request.getContextPath() %>/home" class="logo-container">
        <img src="<%= request.getContextPath() %>/assets/images/logo.png" alt="ShelfBound Logo" class="logo-img">
        <div class="logo">
            <span class="logo-shelf">Shelf</span>
            <span class="logo-bound">Bound</span>
        </div>
    </a>

    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/home">Home</a>
        <a href="<%= request.getContextPath() %>/books" class="active">Books</a>
        <a href="<%= request.getContextPath() %>/cart">Cart</a>
        <a href="<%= request.getContextPath() %>/orders">Orders</a>
        <a href="<%= request.getContextPath() %>/wishlist">Wishlist</a>

        <a href="<%= request.getContextPath() %>/profile" class="profile-avatar-link" title="<%= username != null ? username : "Profile" %>">
            <% if (username != null && !username.trim().isEmpty()) {
                String initials = username.trim().length() >= 2
                        ? username.trim().substring(0, 2).toUpperCase()
                        : username.trim().substring(0, 1).toUpperCase();
            %>
            <div class="profile-avatar"><%= initials %></div>
            <% } else { %>
            <div class="profile-avatar profile-avatar-guest">👤</div>
            <% } %>
        </a>

        <% if (username == null) { %>
            <a href="<%= request.getContextPath() %>/login">Login</a>
         <!-- ================= LOGOUT BUTTON START ================= -->
        <%
            } else {
        %>
            <span class="welcome-user">Welcome, <%= username %></span>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout" title="Logout">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 2v10"></path>
                    <path d="M18.36 6.64a9 9 0 1 1-12.72 0"></path>
                </svg>
            </a>
        <%
            }
        %>
        <!-- ================= LOGOUT BUTTON END ================= -->
        <a href="<%= request.getContextPath() %>/adminLogin">Admin</a>
    </div>
</div>

<!-- ═══════════════════════════════════════════════════════════════
     BREADCRUMB
     ═══════════════════════════════════════════════════════════════ -->
<div class="breadcrumb-wrapper">
    <nav class="breadcrumb animate-in">
        <a href="<%= request.getContextPath() %>/home">Home</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%= request.getContextPath() %>/books">Books</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current"><%= book.getTitle() %></span>
    </nav>
</div>

<!-- ═══════════════════════════════════════════════════════════════
     PRODUCT DETAILS
     ═══════════════════════════════════════════════════════════════ -->
<div class="product-wrapper">
    <div class="product-grid animate-in delay-1">

        <!-- Left: Image Gallery -->
        <div class="image-section">
            <div class="main-image-wrapper">
                <img src="<%= request.getContextPath() + "/assets/" + book.getImageUrl() %>" 
                     alt="<%= book.getTitle() %>" class="main-image" id="mainImage">
            </div>

            <div class="badge-row">
                <% if (book.getRating() >= 4.5) { %>
                <span class="badge badge-bestseller">🔥 Bestseller</span>
                <% } %>
                <% 
                    // Check if book is new (published within last 30 days)
                    // You can add a publishDate field to Book model for this
                %>
                <span class="badge badge-new">✨ New Arrival</span>
                <% if (book.getStockQuantity() > 10) { %>
                <span class="badge badge-stock">✓ In Stock</span>
                <% } else if (book.getStockQuantity() > 0) { %>
                <span class="badge badge-stock" style="background: linear-gradient(135deg, #fef3c7, #fde68a); color: #92400e; border-color: #fcd34d;">⚡ Only <%= book.getStockQuantity() %> left</span>
                <% } else { %>
                <span class="badge badge-out">✗ Out of Stock</span>
                <% } %>
            </div>
        </div>

        <!-- Right: Product Info -->
        <div class="info-section">

                       <div class="category-tag">
                <i class="fas fa-book-open"></i>
                <% 
                    int catId = book.getCategoryId();
                    String categoryName = "Book";
                    if (catId == 1) categoryName = "Fiction";
                    else if (catId == 2) categoryName = "Non-Fiction";
                    else if (catId == 3) categoryName = "Science";
                    else if (catId == 4) categoryName = "Technology";
                    else if (catId == 5) categoryName = "History";
                    else if (catId == 6) categoryName = "Biography";
                    else if (catId == 7) categoryName = "Self-Help";
                    else if (catId == 8) categoryName = "Children";
                    else if (catId > 0) categoryName = "Category " + catId;
                %>
                <%= categoryName %>
            </div>

            <h1 class="book-title"><%= book.getTitle() %></h1>

            <div class="author">
                by <a href="<%= request.getContextPath() %>/books?author=<%= java.net.URLEncoder.encode(book.getAuthor(), "UTF-8") %>"><%= book.getAuthor() %></a>
            </div>

            <!-- Rating -->
            <div class="rating-wrapper">
                <div class="stars">
                    <% 
                        double rating = book.getRating();
                        for (int i = 1; i <= 5; i++) {
                            if (i <= rating) {
                    %>
                    <span class="star filled">★</span>
                    <%      } else if (i - 0.5 <= rating) { %>
                    <span class="star half">★</span>
                    <%      } else { %>
                    <span class="star">★</span>
                    <%      }
                        }
                    %>
                </div>
                <span class="rating-text"><%= String.format("%.1f", rating) %></span>
                <span class="rating-count">(<%= (int)(Math.random() * 500 + 50) %> reviews)</span>
            </div>

            <!-- Price -->
            <div class="price-section">
                <span class="price-current">₹<%= String.format("%.2f", book.getPrice()) %></span>
                <% 
                    double originalPrice = book.getPrice() * 1.25; // 25% markup for display
                %>
                <span class="price-original">₹<%= String.format("%.2f", originalPrice) %></span>
                <span class="price-discount">20% OFF</span>
            </div>

            <!-- Description -->
            <div class="description-box">
                <div class="description-label">About this book</div>
                <div class="description-text">
                    <%= book.getDescription() != null && !book.getDescription().isEmpty() 
                        ? book.getDescription() 
                        : "Dive into this captivating read that promises to take you on an unforgettable journey. A must-have addition to your personal library." %>
                </div>
            </div>

            <!-- Meta Info -->
            <div class="meta-grid">
                <div class="meta-item">
                    <div class="meta-icon">📦</div>
                    <div class="meta-content">
                        <span class="meta-label">Availability</span>
                        <span class="meta-value" style="color: <%= book.getStockQuantity() > 0 ? "var(--success)" : "var(--danger)" %>;">
                            <%= book.getStockQuantity() > 0 ? "In Stock (" + book.getStockQuantity() + ")" : "Out of Stock" %>
                        </span>
                    </div>
                </div>
                <div class="meta-item">
                    <div class="meta-icon">🚚</div>
                    <div class="meta-content">
                        <span class="meta-label">Delivery</span>
                        <span class="meta-value">Free</span>
                    </div>
                </div>
                <div class="meta-item">
                    <div class="meta-icon">↩️</div>
                    <div class="meta-content">
                        <span class="meta-label">Returns</span>
                        <span class="meta-value">7 Days Easy</span>
                    </div>
                </div>
                <div class="meta-item">
                    <div class="meta-icon">🔒</div>
                    <div class="meta-content">
                        <span class="meta-label">Payment</span>
                        <span class="meta-value">100% Secure</span>
                    </div>
                </div>
            </div>

            <!-- Action Area -->
            <div class="action-area">
                <form action="<%= request.getContextPath() %>/cart" method="post" id="cartForm">
                    <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
                    <input type="hidden" name="action" value="add">

                    <div style="display: flex; align-items: center; gap: 16px; margin-bottom: 16px; flex-wrap: wrap;">
                        <label style="font-size: 14px; font-weight: 600; color: var(--text-dark);">Quantity:</label>
                        <div class="quantity-selector">
                            <button type="button" class="qty-btn" onclick="decrementQty()">−</button>
                            <input type="number" name="quantity" value="1" min="1" 
                                   max="<%= Math.max(book.getStockQuantity(), 1) %>" 
                                   class="qty-input" id="qtyInput" readonly>
                            <button type="button" class="qty-btn" onclick="incrementQty()">+</button>
                        </div>
                    </div>

                    <div class="button-row">
                        <button type="submit" class="btn-cart" <%= book.getStockQuantity() <= 0 ? "disabled style='opacity:0.5;cursor:not-allowed;'" : "" %>>
                            <i class="fas fa-shopping-cart"></i>
                            <%= book.getStockQuantity() > 0 ? "Add to Cart" : "Out of Stock" %>
                        </button>

                        <a href="<%= request.getContextPath() %>/wishlist?action=add&bookId=<%= book.getBookId() %>" 
                           class="btn-wishlist <%= inWishlist ? "active" : "" %>">
                            <i class="fas fa-heart"></i>
                            <%= inWishlist ? "In Wishlist" : "Add to Wishlist" %>
                        </a>
                    </div>
                </form>

                <!-- Trust Badges -->
                <div class="trust-row">
                    <div class="trust-item">
                        <i class="fas fa-check-circle"></i>
                        <span>Authentic Books</span>
                    </div>
                    <div class="trust-item">
                        <i class="fas fa-truck"></i>
                        <span>Fast Delivery</span>
                    </div>
                    <div class="trust-item">
                        <i class="fas fa-shield-alt"></i>
                        <span>Secure Payment</span>
                    </div>
                    <div class="trust-item">
                        <i class="fas fa-undo"></i>
                        <span>Easy Returns</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Back to browsing -->
    <div style="text-align: center; margin-top: 32px;">
        <a href="<%= request.getContextPath() %>/books" 
           style="display: inline-flex; align-items: center; gap: 8px; text-decoration: none; color: var(--primary-blue); font-weight: 600; font-size: 14px; padding: 10px 20px; border: 1.5px solid #bfdbfe; border-radius: var(--radius-md); background: linear-gradient(135deg, #eff6ff, #dbeafe); transition: var(--transition);"
           onmouseover="this.style.transform='translateX(-4px)';this.style.boxShadow='var(--shadow-md)'"
           onmouseout="this.style.transform='translateX(0)';this.style.boxShadow='none'">
            <i class="fas fa-arrow-left"></i>
            Continue Browsing
        </a>
    </div>
</div>

<script>
function incrementQty() {
    const input = document.getElementById('qtyInput');
    const max = parseInt(input.getAttribute('max'));
    let val = parseInt(input.value);
    if (val < max) {
        input.value = val + 1;
    }
}

function decrementQty() {
    const input = document.getElementById('qtyInput');
    let val = parseInt(input.value);
    if (val > 1) {
        input.value = val - 1;
    }
}

// Animate elements on load
document.addEventListener('DOMContentLoaded', function() {
    const elements = document.querySelectorAll('.animate-in');
    elements.forEach(el => {
        el.style.opacity = '0';
        setTimeout(() => {
            el.style.opacity = '1';
        }, 100);
    });
});
</script>

</body>
</html>