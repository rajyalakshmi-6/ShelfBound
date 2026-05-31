<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.shelfbound.model.Book" %>

<%
    List<Book> wishlistBooks = (List<Book>) request.getAttribute("wishlistBooks");
    String username = (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Wishlist - ShelfBound</title>
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
        <%
            }
        %>
        <a href="<%= request.getContextPath() %>/admin">Admin</a>
    </div>

</div>

<!-- ================= PAGE CONTENT ================= -->
<div class="page-wrapper">

    <h2 class="page-title">My Wishlist</h2>

    <%
    if (wishlistBooks == null || wishlistBooks.isEmpty()) {
    %>

        <div class="empty-wishlist">
            <p>Your wishlist is empty.</p>
            <a href="<%= request.getContextPath() %>/books">Browse Books &rarr;</a>
        </div>

    <%
    } else {
    %>

        <div class="book-grid">

            <%
            for (Book b : wishlistBooks) {
            %>

            <div class="book-card">

                <!-- Book image links to detail page -->
                <a href="<%= request.getContextPath() %>/book?id=<%= b.getBookId() %>"
                   style="text-decoration: none; color: inherit;">

                   <img src="<%= request.getContextPath() %>/assets/<%= b.getImageUrl() %>" alt="<%= b.getTitle() %>">

                    <h3><%= b.getTitle() %></h3>

                    <p class="author"><%= b.getAuthor() %></p>

                    <p class="price">&#8377; <%= b.getPrice() %></p>

                </a>

                <div class="card-actions">

                    <!-- ADD TO CART -->
                    <form action="<%= request.getContextPath() %>/cart" method="post">
                        <input type="hidden" name="bookId" value="<%= b.getBookId() %>">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="quantity" value="1">
                        <button type="submit" class="btn-cart">Add to Cart</button>
                    </form>

                    <!-- REMOVE FROM WISHLIST -->
                    <form action="<%= request.getContextPath() %>/removeWishlist" method="post">
                        <input type="hidden" name="bookId" value="<%= b.getBookId() %>">
                        <button type="submit" class="btn-remove">Remove from Wishlist</button>
                    </form>

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

</body>
</html>
