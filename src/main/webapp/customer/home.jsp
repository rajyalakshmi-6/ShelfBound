<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="com.shelfbound.model.Book"%>

<%
    List<Book> newArrivals  = (List<Book>) request.getAttribute("newArrivals");
    List<Book> popularBooks = (List<Book>) request.getAttribute("popularBooks");
    List<Book> allBooks     = (List<Book>) request.getAttribute("allBooks");
    String     username     = (String)     session.getAttribute("username");

    Set<Integer> wishlistIds = (Set<Integer>) request.getAttribute("wishlistIds");
    if (wishlistIds == null) wishlistIds = new HashSet<>();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ShelfBound - Home</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/home.css">
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
        <a href="<%= request.getContextPath() %>/home" class="active">Home</a>
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
            <div class="profile-avatar profile-avatar-guest">&#128100;</div>
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

<!-- ================= HERO SECTION ================= -->
<div class="hero">
    <video autoplay loop muted playsinline class="hero-video">
        <source src="<%= request.getContextPath() %>/assets/videos/hero-bg.mp4" type="video/mp4">
    </video>
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <div class="hero-badge">&#10024; India's Favorite Bookstore</div>
        <h1>Discover <span class="highlight-books">Books</span> That <span>Shape Your Mind</span></h1>
        <p>Read. Learn. Grow. Welcome to ShelfBound - where every page turns into a new adventure.</p>

        <div class="hero-stats">
            <div class="hero-stat">
                <div class="hero-stat-number">50K+</div>
                <div class="hero-stat-label">Books</div>
            </div>
            <div class="hero-stat">
                <div class="hero-stat-number">1K+</div>
                <div class="hero-stat-label">Authors</div>
            </div>
            <div class="hero-stat">
                <div class="hero-stat-number">100K+</div>
                <div class="hero-stat-label">Readers</div>
            </div>
        </div>

        <form class="hero-search" action="<%=request.getContextPath()%>/books" method="get" onsubmit="return validateSearch();">
            <input type="text" id="searchBox" name="search" placeholder="Search books, authors, categories...">
            <button type="submit" class="search-btn">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="11" cy="11" r="8"></circle>
                    <path d="m21 21-4.35-4.35"></path>
                </svg>
            </button>
        </form>
    </div>

    <div class="scroll-indicator">
        <span></span>
    </div>
</div>

<!-- ================= CATEGORY PILLS ================= -->
<div class="category-strip">
    <div class="category-strip-inner">
        <a href="<%= request.getContextPath() %>/books?categoryId=1" class="category-pill">
            <span class="pill-icon">&#128218;</span> Fiction
        </a>
        <a href="<%= request.getContextPath() %>/books?categoryId=2" class="category-pill">
            <span class="pill-icon">&#128214;</span> Non-Fiction
        </a>
        <a href="<%= request.getContextPath() %>/books?categoryId=3" class="category-pill">
            <span class="pill-icon">&#128059;</span> Kids
        </a>
        <a href="<%= request.getContextPath() %>/books?categoryId=4" class="category-pill">
            <span class="pill-icon">&#127891;</span> Competitive Exams
        </a>
        <a href="<%= request.getContextPath() %>/books?categoryId=5" class="category-pill">
            <span class="pill-icon">&#128293;</span> Popular
        </a>
        <a href="<%= request.getContextPath() %>/books?categoryId=6" class="category-pill">
            <span class="pill-icon">&#10024;</span> New Arrivals
        </a>
        <a href="<%= request.getContextPath() %>/books?categoryId=7" class="category-pill">
            <span class="pill-icon">&#127891;</span> Adult Learning
        </a>
    </div>
</div>

<!-- ================= COUPON CARDS SCROLLING SECTION ================= -->
<div class="coupon-strip">
    <div class="coupon-track">
        <!-- Set 1 -->
        <div class="coupon-card">
            <div class="coupon-ribbon">20%<span>OFF</span></div>
            <div class="coupon-divider"></div>
            <div class="coupon-content">
                <p class="coupon-title">&#127881; FLAT 20% OFF on Your First Order!</p>
                <p class="coupon-sub">Applied automatically at checkout</p>
            </div>
        </div>

        <div class="coupon-card">
            <div class="coupon-ribbon">&#9889;<span>CODE</span></div>
            <div class="coupon-divider"></div>
            <div class="coupon-content">
                <p class="coupon-title">Use Code <span class="coupon-code">WELCOME20</span></p>
                <p class="coupon-sub">Copy and apply on cart page</p>
            </div>
        </div>

        <div class="coupon-card">
            <div class="coupon-ribbon">&#128293;<span>HOT</span></div>
            <div class="coupon-divider"></div>
            <div class="coupon-content">
                <p class="coupon-title">Limited Time Only!</p>
                <p class="coupon-sub">Offer ends soon, grab it now</p>
            </div>
        </div>

        <div class="coupon-card">
            <div class="coupon-ribbon">&#128666;<span>FREE</span></div>
            <div class="coupon-divider"></div>
            <div class="coupon-content">
                <p class="coupon-title">Free Delivery on All Orders</p>
                <p class="coupon-sub">No minimum order value</p>
            </div>
        </div>

        <!-- Set 2 - Duplicate for seamless loop -->
        <div class="coupon-card">
            <div class="coupon-ribbon">20%<span>OFF</span></div>
            <div class="coupon-divider"></div>
            <div class="coupon-content">
                <p class="coupon-title">&#127881; FLAT 20% OFF on Your First Order!</p>
                <p class="coupon-sub">Applied automatically at checkout</p>
            </div>
        </div>

        <div class="coupon-card">
            <div class="coupon-ribbon">&#9889;<span>CODE</span></div>
            <div class="coupon-divider"></div>
            <div class="coupon-content">
                <p class="coupon-title">Use Code <span class="coupon-code">WELCOME20</span></p>
                <p class="coupon-sub">Copy and apply on cart page</p>
            </div>
        </div>

        <div class="coupon-card">
            <div class="coupon-ribbon">&#128293;<span>HOT</span></div>
            <div class="coupon-divider"></div>
            <div class="coupon-content">
                <p class="coupon-title">Limited Time Only!</p>
                <p class="coupon-sub">Offer ends soon, grab it now</p>
            </div>
        </div>

        <div class="coupon-card">
            <div class="coupon-ribbon">&#128666;<span>FREE</span></div>
            <div class="coupon-divider"></div>
            <div class="coupon-content">
                <p class="coupon-title">Free Delivery on All Orders</p>
                <p class="coupon-sub">No minimum order value</p>
            </div>
        </div>
    </div>
</div>

<!-- ================= NEW ARRIVALS ================= -->
<div class="section">
    <div class="section-header">
        <h2><span class="section-icon">&#10024;</span> New Arrivals</h2>
        <a href="<%= request.getContextPath() %>/books" class="view-all-link">View All &rarr;</a>
    </div>

    <div class="book-row">
        <%
            if (newArrivals != null && !newArrivals.isEmpty()) {
                for (Book b : newArrivals) {
                    boolean isWishlisted = wishlistIds.contains(b.getBookId());
        %>
        <a class="book-link" href="<%= request.getContextPath() %>/book?id=<%= b.getBookId() %>">
            <div class="book-card">
                <span class="discount-tag">-20% OFF</span>
                <img src="<%= request.getContextPath() %>/assets/<%= b.getImageUrl() %>" alt="Book Image">
                <h3><%= b.getTitle() %></h3>
                <div class="author-row">
                    <span class="author-name"><%= b.getAuthor() %></span>
                    <button type="button"
                            class="wishlist-btn <%= isWishlisted ? "wishlisted" : "" %>"
                            data-book-id="<%= b.getBookId() %>"
                            title="<%= isWishlisted ? "Remove from Wishlist" : "Add to Wishlist" %>"
                            onclick="toggleWishlist(this, event)">
                        &#9829;
                    </button>
                </div>
                <div class="card-bottom-row">
                    <p class="price">
                        &#8377; <%= b.getPrice() %>
                        <span class="original">&#8377; <%= String.format("%.0f", b.getPrice() * 1.25) %></span>
                    </p>
                    <button type="button"
                            class="card-cart-btn"
                            data-book-id="<%= b.getBookId() %>"
                            title="Add to Cart"
                            onclick="quickAddToCart(this, event, <%= b.getBookId() %>, '<%= b.getTitle().replace("'", "\\'").replace("\"", "&quot;") %>')">
                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="9" cy="21" r="1"></circle>
                            <circle cx="20" cy="21" r="1"></circle>
                            <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                        </svg>
                    </button>
                </div>
            </div>
        </a>
        <%
                }
            } else {
        %>
        <p>No New Arrivals Available</p>
        <%
            }
        %>
    </div>
</div>

<!-- ================= POPULAR BOOKS ================= -->
<div class="section">
    <div class="section-header">
        <h2><span class="section-icon">&#128293;</span> Popular Books</h2>
        <a href="<%= request.getContextPath() %>/books" class="view-all-link">View All &rarr;</a>
    </div>

    <div class="book-row">
        <%
            if (popularBooks != null && !popularBooks.isEmpty()) {
                for (Book b : popularBooks) {
                    boolean isWishlisted = wishlistIds.contains(b.getBookId());
        %>
        <a class="book-link" href="<%= request.getContextPath() %>/book?id=<%= b.getBookId() %>">
            <div class="book-card">
                <span class="discount-tag">-20% OFF</span>
                <img src="<%= request.getContextPath() %>/assets/<%= b.getImageUrl() %>" alt="Book Image">
                <h3><%= b.getTitle() %></h3>
                <div class="author-row">
                    <span class="author-name"><%= b.getAuthor() %></span>
                    <button type="button"
                            class="wishlist-btn <%= isWishlisted ? "wishlisted" : "" %>"
                            data-book-id="<%= b.getBookId() %>"
                            title="<%= isWishlisted ? "Remove from Wishlist" : "Add to Wishlist" %>"
                            onclick="toggleWishlist(this, event)">
                        &#9829;
                    </button>
                </div>
                <div class="card-bottom-row">
                    <p class="price">
                        &#8377; <%= b.getPrice() %>
                        <span class="original">&#8377; <%= String.format("%.0f", b.getPrice() * 1.25) %></span>
                    </p>
                    <button type="button"
                            class="card-cart-btn"
                            data-book-id="<%= b.getBookId() %>"
                            title="Add to Cart"
                            onclick="quickAddToCart(this, event, <%= b.getBookId() %>, '<%= b.getTitle().replace("'", "\\'").replace("\"", "&quot;") %>')">
                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="9" cy="21" r="1"></circle>
                            <circle cx="20" cy="21" r="1"></circle>
                            <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                        </svg>
                    </button>
                </div>
            </div>
        </a>
        <%
                }
            } else {
        %>
        <p>No Popular Books Available</p>
        <%
            }
        %>
    </div>
</div>

<!-- ================= ALL BOOKS ================= -->
<div class="section">
    <div class="section-header">
        <h2><span class="section-icon">&#128218;</span> All Books</h2>
        <a href="<%= request.getContextPath() %>/books" class="view-all-link">View All &rarr;</a>
    </div>

    <div class="book-row">
        <%
            if (allBooks != null && !allBooks.isEmpty()) {
                for (Book b : allBooks) {
                    boolean isWishlisted = wishlistIds.contains(b.getBookId());
        %>
        <a class="book-link" href="<%= request.getContextPath() %>/book?id=<%= b.getBookId() %>">
            <div class="book-card">
                <span class="discount-tag">-20% OFF</span>
                <img src="<%= request.getContextPath() %>/assets/<%= b.getImageUrl() %>" alt="Book Image">
                <h3><%= b.getTitle() %></h3>
                <div class="author-row">
                    <span class="author-name"><%= b.getAuthor() %></span>
                    <button type="button"
                            class="wishlist-btn <%= isWishlisted ? "wishlisted" : "" %>"
                            data-book-id="<%= b.getBookId() %>"
                            title="<%= isWishlisted ? "Remove from Wishlist" : "Add to Wishlist" %>"
                            onclick="toggleWishlist(this, event)">
                        &#9829;
                    </button>
                </div>
                <div class="card-bottom-row">
                    <p class="price">
                        &#8377; <%= b.getPrice() %>
                        <span class="original">&#8377; <%= String.format("%.0f", b.getPrice() * 1.25) %></span>
                    </p>
                    <button type="button"
                            class="card-cart-btn"
                            data-book-id="<%= b.getBookId() %>"
                            title="Add to Cart"
                            onclick="quickAddToCart(this, event, <%= b.getBookId() %>, '<%= b.getTitle().replace("'", "\\'").replace("\"", "&quot;") %>')">
                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="9" cy="21" r="1"></circle>
                            <circle cx="20" cy="21" r="1"></circle>
                            <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                        </svg>
                    </button>
                </div>
            </div>
        </a>
        <%
                }
            } else {
        %>
        <p>No Books Available</p>
        <%
            }
        %>
    </div>
</div>

<!-- ================= FEATURE BANNER ================= -->
<div class="feature-banner">
    <div class="feature-item">
        <div class="feature-icon">&#128666;</div>
        <div class="feature-title">Free Delivery</div>
        <div class="feature-desc">On all orders above &#8377;499</div>
    </div>
    <div class="feature-item">
        <div class="feature-icon">&#128274;</div>
        <div class="feature-title">Secure Payment</div>
        <div class="feature-desc">100% secure checkout</div>
    </div>
    <div class="feature-item">
        <div class="feature-icon">&#8617;</div>
        <div class="feature-title">Easy Returns</div>
        <div class="feature-desc">7-day return policy</div>
    </div>
    <div class="feature-item">
        <div class="feature-icon">&#128222;</div>
        <div class="feature-title">24/7 Support</div>
        <div class="feature-desc">Always here to help</div>
    </div>
</div>

<!-- ================= NEWSLETTER ================= -->
<div class="newsletter">
    <div class="newsletter-box">
        <div class="newsletter-text">
            <h3>Stay in the Loop</h3>
            <p>Subscribe to get exclusive offers, new arrivals, and reading recommendations.</p>
        </div>
        <form class="newsletter-form" id="newsletterForm" onsubmit="handleSubscribe(event)">
    <input type="email" id="newsletterEmail" placeholder="Enter your email address" required>
    <button type="submit" id="subscribeBtn">Subscribe</button>
</form>
    </div>
</div>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <div class="footer-top">
        <div class="footer-brand">
            <div class="logo">
                <span class="logo-shelf">Shelf</span><span class="logo-bound">Bound</span>
                <img src="<%= request.getContextPath() %>/assets/images/logo.png" alt="ShelfBound Logo" class="footer-logo-img">
            </div>
            <p class="footer-tagline">
                Discover, read, and grow with ShelfBound - your one-stop shelf
                for books that shape minds, one page at a time.
            </p>
            <div class="footer-social">
                <a href="#" aria-label="Instagram" class="social-icon">
                    <svg viewBox="0 0 24 24" fill="#FF0069">
                        <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.012-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z"/>
                    </svg>
                </a>
                <a href="#" aria-label="YouTube" class="social-icon">
                    <svg viewBox="0 0 24 24" fill="#FF0000">
                        <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/>
                    </svg>
                </a>
                <a href="#" aria-label="Twitter" class="social-icon">
                    <svg viewBox="0 0 24 24" fill="#000000">
                        <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/>
                    </svg>
                </a>
            </div>
        </div>

        <div class="footer-col">
            <h4>Our Links</h4>
            <a href="<%= request.getContextPath() %>/about">About Us</a>
            <a href="<%= request.getContextPath() %>/contact">Contact Us</a>
            <a href="<%= request.getContextPath() %>/books">Browse Books</a>
            <a href="<%= request.getContextPath() %>/contact">Sell With Us</a>
        </div>

        <div class="footer-col">
            <h4>Quick Links</h4>
            <a href="<%= request.getContextPath() %>/orders">Track Order</a>
            <a href="javascript:void(0)" onclick="openModal('faqModal')">FAQs</a>
            <a href="javascript:void(0)" onclick="openModal('privacyModal')">Privacy Policy</a>
            <a href="javascript:void(0)" onclick="openModal('termsModal')">Terms &amp; Conditions</a>
        </div>

        <div class="footer-col">
            <h4>Support</h4>
            <p>&#128222; Call: +91 XXXXXXXXXX</p>
            <p>&#128172; WhatsApp: +91 XXXXXXXXXX</p>
            <p>&#9993; Email: support@shelfbound.com</p>
        </div>
    </div>

    <hr class="footer-divider">

    <div class="footer-bottom">
        <p>&copy; 2026 ShelfBound. All rights reserved.</p>
    </div>
</footer>

<!-- ================= FAQ MODAL ================= -->
<div id="faqModal" class="modal-overlay">
    <div class="modal-box">
        <button class="modal-close" onclick="closeModal('faqModal')">&times;</button>
        <h2>FAQs</h2>
        <div class="faq-item">
            <h4>How long does delivery take?</h4>
            <p>Orders are typically delivered within 3-5 business days depending on your location.</p>
        </div>
        <div class="faq-item">
            <h4>Can I return a book after purchase?</h4>
            <p>Yes, returns are accepted within 7 days of delivery, provided the book is unused and in original condition.</p>
        </div>
        <div class="faq-item">
            <h4>Do you offer Cash on Delivery?</h4>
            <p>Yes, COD is available for most pin codes across India.</p>
        </div>
        <div class="faq-item">
            <h4>How do I track my order?</h4>
            <p>Once shipped, you can track your order from the Orders page using your order ID.</p>
        </div>
        <div class="faq-item">
            <h4>Do you sell second-hand books?</h4>
            <p>Currently ShelfBound only sells new books, but second-hand listings are coming soon.</p>
        </div>
    </div>
</div>

<!-- ================= PRIVACY POLICY MODAL ================= -->
<div id="privacyModal" class="modal-overlay">
    <div class="modal-box">
        <button class="modal-close" onclick="closeModal('privacyModal')">&times;</button>
        <h2>Privacy Policy</h2>
        <p>This is placeholder text for ShelfBound's Privacy Policy.</p>
        <h4>1. Information We Collect</h4>
        <p>We collect your name, email, phone number, and address when you create an account or place an order.</p>
        <h4>2. How We Use Your Data</h4>
        <p>Your data is used solely to process orders, improve our services, and communicate order updates.</p>
        <h4>3. Data Sharing</h4>
        <p>We do not sell or share your personal information with third parties.</p>
        <h4>4. Cookies</h4>
        <p>ShelfBound uses cookies to enhance browsing experience.</p>
        <h4>5. Contact Us</h4>
        <p>For privacy-related concerns, reach out at support@shelfbound.com.</p>
    </div>
</div>

<!-- ================= TERMS & CONDITIONS MODAL ================= -->
<div id="termsModal" class="modal-overlay">
    <div class="modal-box">
        <button class="modal-close" onclick="closeModal('termsModal')">&times;</button>
        <h2>Terms &amp; Conditions</h2>
        <p>This is placeholder text for ShelfBound's Terms &amp; Conditions.</p>
        <h4>1. Use of Website</h4>
        <p>By using ShelfBound, you agree to browse and purchase books only for personal, non-commercial use.</p>
        <h4>2. Pricing &amp; Payments</h4>
        <p>All prices are listed in INR and are subject to change without prior notice.</p>
        <h4>3. Order Cancellation</h4>
        <p>Orders can be cancelled before they are shipped. Once shipped, cancellation is not possible.</p>
        <h4>4. Returns &amp; Refunds</h4>
        <p>Refunds are processed within 5-7 business days after the returned item is received and verified.</p>
        <h4>5. Account Responsibility</h4>
        <p>You are responsible for maintaining the confidentiality of your account credentials.</p>
    </div>
</div>

<!-- Toast Container -->
<div class="toast-container" id="toastContainer"></div>

<script>
function openModal(id){
    document.getElementById(id).classList.add("active");
    document.body.style.overflow = "hidden";
}

function closeModal(id){
    document.getElementById(id).classList.remove("active");
    document.body.style.overflow = "auto";
}

document.querySelectorAll(".modal-overlay").forEach(function(overlay) {
    overlay.addEventListener("click", function(e) {
        if(e.target === overlay){
            overlay.classList.remove("active");
            document.body.style.overflow = "auto";
        }
    });
});

function toggleWishlist(btn, event) {
    event.stopPropagation();
    event.preventDefault();

    var bookId = btn.getAttribute('data-book-id');
    var wasWishlisted = btn.classList.contains('wishlisted');

    btn.classList.toggle('wishlisted');
    btn.disabled = true;

    fetch('<%= request.getContextPath() %>/wishlist', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: 'bookId=' + encodeURIComponent(bookId)
    })
    .then(function(response) {
        if (!response.ok) throw new Error('Request failed');
        return response.text();
    })
    .then(function(status) {
        if (status === 'added') {
            btn.classList.add('wishlisted');
            btn.title = 'Remove from Wishlist';
            showToast('Added to Wishlist! &#10084;', 'success');
        } else if (status === 'removed') {
            btn.classList.remove('wishlisted');
            btn.title = 'Add to Wishlist';
            showToast('Removed from Wishlist', 'info');
        }
        btn.disabled = false;
    })
    .catch(function(err) {
        console.error('Wishlist toggle failed:', err);
        if (wasWishlisted) {
            btn.classList.add('wishlisted');
        } else {
            btn.classList.remove('wishlisted');
        }
        btn.disabled = false;
        showToast('Something went wrong. Please try again.', 'error');
    });
}

// ===== QUICK ADD TO CART =====
function quickAddToCart(btn, event, bookId, title) {
    event.stopPropagation();
    event.preventDefault();

    if (btn.disabled) return;
    btn.disabled = true;
    btn.style.opacity = '0.7';

    fetch('<%= request.getContextPath() %>/cart', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest',
            'Accept': 'application/json'
        },
        body: 'bookId=' + encodeURIComponent(bookId) + '&quantity=1'
    })
    .then(function(res) {
        if (res.status === 401) {
            return res.json().then(function(data) {
                showToast(data.message || 'Please login to add to cart.', 'info');
                setTimeout(function() {
                    window.location.href = '<%= request.getContextPath() %>/login';
                }, 1200);
            });
        }
        if (!res.ok) throw new Error('HTTP ' + res.status);
        return res.json();
    })
    .then(function(data) {
        if (!data) return;
        if (data.success) {
            btn.classList.add('added');
            btn.innerHTML = '<svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>';
            showToast('✔ Added "' + (title || 'Book') + '" to Cart! 🛒', 'success');

            setTimeout(function() {
                btn.classList.remove('added');
                btn.innerHTML = '<svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>';
                btn.disabled = false;
                btn.style.opacity = '1';
            }, 1200);
        } else {
            showToast(data.message || 'Could not add to cart.', 'error');
            btn.disabled = false;
            btn.style.opacity = '1';
        }
    })
    .catch(function(err) {
        console.error('Quick add to cart error:', err);
        btn.disabled = false;
        btn.style.opacity = '1';
        showToast('Please login to add books to cart.', 'info');
        setTimeout(function() {
            window.location.href = '<%= request.getContextPath() %>/login';
        }, 1200);
    });
}

// ===== TOAST NOTIFICATIONS =====
function showToast(message, type) {
    var container = document.getElementById('toastContainer');
    var toast = document.createElement('div');
    toast.className = 'toast ' + type;
    var icons = { success: '&#10004;', error: '&#10008;', info: '&#8505;' };
    toast.innerHTML = '<span>' + (icons[type] || '&#10004;') + '</span> ' + message;
    container.appendChild(toast);

    setTimeout(function() {
        toast.classList.add('toast-exit');
        setTimeout(function() { toast.remove(); }, 300);
    }, 3000);
}

function validateSearch() {
    var searchBox = document.getElementById("searchBox");
    if (searchBox.value.trim() === "") {
        searchBox.style.borderColor = "#ef4444";
        setTimeout(function() {
            searchBox.style.borderColor = "";
        }, 2000);
        return false;
    }
    return true;
}

function handleSubscribe(e) {
    e.preventDefault();
    var btn = document.getElementById('subscribeBtn');
    var input = document.getElementById('newsletterEmail');
    var emailVal = input.value.trim();

    if (!emailVal) return;

    btn.disabled = true;
    btn.textContent = 'Subscribing...';

    fetch('<%= request.getContextPath() %>/subscribe', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'email=' + encodeURIComponent(emailVal)
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        if (data.status === 'success') {
            btn.textContent = 'Subscribed! ✔';
            btn.classList.add('subscribed');
            input.value = '';
            showToast('Welcome email with 20% discount coupon sent! ✉️', 'success');
        } else {
            btn.textContent = 'Subscribe';
            showToast(data.message || 'Subscription failed.', 'error');
        }
    })
    .catch(function(err) {
        console.error('Subscription error:', err);
        btn.textContent = 'Subscribed! ✔';
        input.value = '';
        showToast('Subscribed! Check your inbox for updates.', 'success');
    })
    .finally(function() {
        setTimeout(function() {
            btn.disabled = false;
            btn.textContent = 'Subscribe';
            btn.classList.remove('subscribed');
        }, 4000);
    });
}

// Productivity shortcut: Press '/' or 'Ctrl+K' to quickly focus search
document.addEventListener('keydown', function(e) {
    if ((e.key === '/' || (e.ctrlKey && e.key.toLowerCase() === 'k')) && 
        document.activeElement.tagName !== 'INPUT' && 
        document.activeElement.tagName !== 'TEXTAREA') {
        e.preventDefault();
        var searchBox = document.getElementById("searchBox");
        if (searchBox) {
            searchBox.focus();
            searchBox.select();
        }
    }
});
</script>

</body>
</html>