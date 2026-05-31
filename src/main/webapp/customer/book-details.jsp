<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.shelfbound.model.Book" %>

<%
    Book book = (Book) request.getAttribute("book");

    if (book == null) {
        response.sendRedirect(request.getContextPath() + "/books");
        return;
    }
%>

<%
    String appName = "ShelfBound";
    String username = (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title><%= book.getTitle() %> - <%= appName %></title>

<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/book-details.css?v=2">

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

<!-- ================= MAIN CONTAINER ================= -->
<div class="container">

    <!-- BOOK IMAGE -->
    <div class="book-image">
        <img src="<%= request.getContextPath() + "/assets/" + book.getImageUrl() %>" alt="book image">
    </div>

    <!-- BOOK DETAILS -->
    <div class="book-details">

        <div class="book-title">
            <%= book.getTitle() %>
        </div>

        <div class="author">
            by <%= book.getAuthor() %>
        </div>

        <div class="rating">
            ⭐
            <%= (book.getRating() == 0 ? "No Rating" : book.getRating() + " / 5") %>
        </div>

        <div class="price">
            ₹ <%= book.getPrice() %>
        </div>

        <div class="description">
            <%= book.getDescription() %>
        </div>

        <div class="stock">
            In Stock: <%= Math.max(book.getStockQuantity(), 0) %>
        </div>

        <!-- ================= ADD TO CART ================= -->
        <form action="<%= request.getContextPath() %>/cart" method="post">

            <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
            <input type="hidden" name="action" value="add">

            <div class="quantity-box">
                <label>Quantity</label>
                <input type="number"
                       name="quantity"
                       value="1"
                       min="1"
                       max="<%= Math.max(book.getStockQuantity(), 1) %>">
            </div>

            <button type="submit" class="btn">
                Add To Cart
            </button>

        </form>

        <a class="back" href="<%= request.getContextPath() %>/home">
            ← Back To Home
        </a>

    </div>

</div>

</body>
</html>
