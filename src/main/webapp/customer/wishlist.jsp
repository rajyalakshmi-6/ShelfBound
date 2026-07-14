<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.shelfbound.model.Book" %>

<%
    List<Book> wishlistBooks = (List<Book>) request.getAttribute("wishlistBooks");
    String username = (String) session.getAttribute("username");
    int wishlistCount = wishlistBooks != null ? wishlistBooks.size() : 0;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist | ShelfBound</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/wishlist.css">
</head>

<body>

<!-- ================= NAVBAR ================= -->
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
        <a href="<%= request.getContextPath() %>/books">Books</a>
        <a href="<%= request.getContextPath() %>/cart">Cart</a>
        <a href="<%= request.getContextPath() %>/orders">Orders</a>
        <a href="<%= request.getContextPath() %>/wishlist">Wishlist</a>

        <a href="<%= request.getContextPath() %>/profile" class="profile-avatar-link" title="<%= username != null ? username : "Profile" %>">
            <%
                if (username != null && !username.trim().isEmpty()) {
                    String initials = username.trim().length() >= 2
                            ? username.trim().substring(0, 2).toUpperCase()
                            : username.trim().substring(0, 1).toUpperCase();
            %>
            <div class="profile-avatar"><%= initials %></div>
            <%
                } else {
            %>
            <div class="profile-avatar profile-avatar-guest">👤</div>
            <%
                }
            %>
        </a>

        <%
            if (username == null) {
        %>
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

<!-- ================= PAGE HEADER ================= -->
<div class="page-header">
    <div class="page-header-inner">
        <div>
            <h1 class="page-title">
                <span class="heart-icon">❤️</span>
                My Wishlist
            </h1>
            <p class="page-subtitle">Save your favorites and shop them anytime</p>
        </div>
        <span class="wishlist-count"><%= wishlistCount %> items</span>
    </div>
</div>

<!-- ================= MAIN CONTENT ================= -->
<div class="wishlist-layout">

    <%
    if (wishlistBooks == null || wishlistBooks.isEmpty()) {
    %>

    <!-- Empty State -->
    <div class="empty-state">
        <div class="empty-icon">💔</div>
        <div class="empty-title">Your wishlist is empty</div>
        <div class="empty-subtitle">Start adding books you love! Browse our collection and click the heart icon to save them here for later.</div>
        <a href="<%= request.getContextPath() %>/books" class="empty-btn">
            🛍️ Start Browsing
        </a>
    </div>

    <%
    } else {
    %>

    <!-- Wishlist Grid -->
    <div class="wishlist-grid">

        <%
        for (Book b : wishlistBooks) {
            // Calculate discount (example: 20% off for demo)
            double originalPrice = b.getPrice() * 1.25;
            int discountPercent = 20;
        %>

        <div class="wishlist-card">

            <!-- Heart Remove Button -->
            <form action="<%= request.getContextPath() %>/removeWishlist" method="post" style="margin:0;">
                <input type="hidden" name="bookId" value="<%= b.getBookId() %>">
                <button type="submit" class="heart-badge" title="Remove from Wishlist">❤️</button>
            </form>

            <!-- Discount Badge -->
            <span class="discount-badge">-<%= discountPercent %>% OFF</span>

            <!-- Image -->
            <div class="card-image">
                <a href="<%= request.getContextPath() %>/book?id=<%= b.getBookId() %>" style="display:block;height:100%;">
                    <img src="<%= request.getContextPath() %>/assets/<%= b.getImageUrl() %>" alt="<%= b.getTitle() %>">
                </a>
            </div>

            <!-- Content -->
            <div class="card-content">

                <a href="<%= request.getContextPath() %>/book?id=<%= b.getBookId() %>" style="text-decoration:none;color:inherit;">
                    <div class="book-title"><%= b.getTitle() %></div>
                    <div class="book-author">by <%= b.getAuthor() %></div>
                </a>

                <!-- Rating -->
                <div class="book-rating">
                    <span class="stars">★★★★☆</span>
                    <span class="rating-count">(<%= (b.getBookId() * 7 + 12) %> reviews)</span>
                </div>

                <!-- Price -->
                <div class="price-row">
                    <span class="current-price">₹<%= b.getPrice() %></span>
                    <span class="original-price">₹<%= String.format("%.0f", originalPrice) %></span>
                    <span class="discount-percent"><%= discountPercent %>% off</span>
                </div>

                <!-- Stock -->
                <div class="stock-status in-stock">
                    ✅ In Stock
                </div>

                <!-- Actions -->
                <div class="card-actions">

                    <!-- Add to Cart -->
                    <form action="<%= request.getContextPath() %>/cart" method="post" style="margin:0;">
                        <input type="hidden" name="bookId" value="<%= b.getBookId() %>">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="quantity" value="1">
                        <button type="submit" class="btn btn-cart">
                            🛒 Add to Cart
                        </button>
                    </form>

                    <!-- Remove -->
                    <form action="<%= request.getContextPath() %>/removeWishlist" method="post" style="margin:0;">
                        <input type="hidden" name="bookId" value="<%= b.getBookId() %>">
                        <button type="submit" class="btn btn-remove">
                            🗑️ Remove
                        </button>
                    </form>

                </div>

            </div>

        </div>

        <%
        }
        %>

    </div>

    <%
    }
    %>

</div>

<!-- ================= FOOTER ================= -->
<div class="wishlist-footer">
    <div class="footer-box">
        <div class="footer-text">✨ Discover More Books</div>
        <div class="footer-sub">Your next favorite read is just a click away.</div>
        <a href="<%= request.getContextPath() %>/books" class="shop-btn">
            📚 Browse Collection
        </a>
    </div>
</div>

</body>
</html>