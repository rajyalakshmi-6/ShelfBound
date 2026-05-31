<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="com.shelfbound.model.Book" %>

<%
    List<Book> newArrivals  = (List<Book>) request.getAttribute("newArrivals");
    List<Book> popularBooks = (List<Book>) request.getAttribute("popularBooks");
    List<Book> allBooks     = (List<Book>) request.getAttribute("allBooks");
    String     username     = (String)     session.getAttribute("username");

    // Wishlist IDs sent by HomeServlet — used to pre-fill hearts pink on load
    Set<Integer> wishlistIds = (Set<Integer>) request.getAttribute("wishlistIds");
    if (wishlistIds == null) wishlistIds = new HashSet<>();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
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
        <a href="<%= request.getContextPath() %>/home">Home</a>
        <a href="<%= request.getContextPath() %>/books">Books</a>
        <a href="<%= request.getContextPath() %>/cart">Cart</a>
        <a href="<%= request.getContextPath() %>/orders">Orders</a>
        <a href="<%= request.getContextPath() %>/wishlist">Wishlist</a>
        <a href="<%= request.getContextPath() %>/about">About</a>
        <a href="<%= request.getContextPath() %>/contact">Contact</a>

        <%
            if (username == null) {
        %>
            <a href="<%= request.getContextPath() %>/login">Login</a>
        <%
            } else {
        %>
            <span class="welcome-user">Welcome, <%= username %></span>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Logout</a>
        <%
            }
        %>

        <a href="<%= request.getContextPath() %>/adminLogin">Admin</a>
    </div>

</div>

<!-- ================= VIDEO HERO SECTION ================= -->
<div class="hero">
    <video autoplay loop muted playsinline class="hero-video">
        <source src="<%= request.getContextPath() %>/assets/videos/hero-bg.mp4" type="video/mp4">
    </video>
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <h1>Discover Books That Shape Your Mind</h1>
        <p>Read. Learn. Grow. Welcome to ShelfBound.</p>
    </div>
</div>

<!-- ================= NEW ARRIVALS ================= -->
<div class="section">

    <div class="section-header">
        <h2>New Arrivals</h2>
        <a href="<%= request.getContextPath() %>/books" class="view-all-link">View All &rarr;</a>
    </div>

    <div class="book-row">
        <%
            if (newArrivals != null && !newArrivals.isEmpty()) {
                for (Book b : newArrivals) {
                    // Check if this book is already in wishlist
                    boolean isWishlisted = wishlistIds.contains(b.getBookId());
        %>

        <a class="book-link" href="<%= request.getContextPath() %>/book?id=<%= b.getBookId() %>">
            <div class="book-card">

               <img src="<%= request.getContextPath() %>/assets/<%= b.getImageUrl() %>" alt="Book Image">

                <h3><%= b.getTitle() %></h3>

                <%-- AUTHOR ROW: heart pre-filled pink if book is already wishlisted --%>
                <div class="author-row">
                    <span class="author-name"><%= b.getAuthor() %></span>
                    <form action="<%= request.getContextPath() %>/wishlist"
                          method="post"
                          class="wishlist-form"
                          onclick="event.stopPropagation()">
                        <input type="hidden" name="bookId" value="<%= b.getBookId() %>">
                        <button type="submit"
                                class="wishlist-btn <%= isWishlisted ? "wishlisted" : "" %>"
                                title="<%= isWishlisted ? "Remove from Wishlist" : "Add to Wishlist" %>"
                                onclick="this.classList.toggle('wishlisted'); event.stopPropagation();">
                            &#9829;
                        </button>
                    </form>
                </div>

                <p class="price">&#8377; <%= b.getPrice() %></p>

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
        <h2>Popular Books</h2>
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

                <img src="<%= request.getContextPath() %>/assets/<%= b.getImageUrl() %>" alt="Book Image">

                <h3><%= b.getTitle() %></h3>

                <%-- AUTHOR ROW: heart pre-filled pink if book is already wishlisted --%>
                <div class="author-row">
                    <span class="author-name"><%= b.getAuthor() %></span>
                    <form action="<%= request.getContextPath() %>/wishlist"
                          method="post"
                          class="wishlist-form"
                          onclick="event.stopPropagation()">
                        <input type="hidden" name="bookId" value="<%= b.getBookId() %>">
                        <button type="submit"
                                class="wishlist-btn <%= isWishlisted ? "wishlisted" : "" %>"
                                title="<%= isWishlisted ? "Remove from Wishlist" : "Add to Wishlist" %>"
                                onclick="this.classList.toggle('wishlisted'); event.stopPropagation();">
                            &#9829;
                        </button>
                    </form>
                </div>

                <p class="price">&#8377; <%= b.getPrice() %></p>

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
        <h2>All Books</h2>
    </div>

    <div class="book-row">
        <%
            if (allBooks != null && !allBooks.isEmpty()) {
                for (Book b : allBooks) {
                    boolean isWishlisted = wishlistIds.contains(b.getBookId());
        %>

        <a class="book-link" href="<%= request.getContextPath() %>/book?id=<%= b.getBookId() %>">
            <div class="book-card">

                <img src="<%= request.getContextPath() %>/assets/<%= b.getImageUrl() %>" alt="Book Image">

                <h3><%= b.getTitle() %></h3>

                <%-- AUTHOR ROW: heart pre-filled pink if book is already wishlisted --%>
                <div class="author-row">
                    <span class="author-name"><%= b.getAuthor() %></span>
                    <form action="<%= request.getContextPath() %>/wishlist"
                          method="post"
                          class="wishlist-form"
                          onclick="event.stopPropagation()">
                        <input type="hidden" name="bookId" value="<%= b.getBookId() %>">
                        <button type="submit"
                                class="wishlist-btn <%= isWishlisted ? "wishlisted" : "" %>"
                                title="<%= isWishlisted ? "Remove from Wishlist" : "Add to Wishlist" %>"
                                onclick="this.classList.toggle('wishlisted'); event.stopPropagation();">
                            &#9829;
                        </button>
                    </form>
                </div>

                <p class="price">&#8377; <%= b.getPrice() %></p>

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

</body>
</html>