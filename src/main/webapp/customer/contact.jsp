<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String username    = (String) session.getAttribute("username");
    String successMsg  = (String) request.getAttribute("successMsg");
    String errorMsg    = (String) request.getAttribute("errorMsg");
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Contact Us — ShelfBound</title>

<link rel="stylesheet"
    href="<%= request.getContextPath() %>/assets/css/contact.css">

</head>
<body>

<!-- ================= NAVBAR ================= -->
<div class="navbar">

    <a href="<%= request.getContextPath() %>/home" class="logo-container">
        <img src="<%= request.getContextPath() %>/assets/images/logo.png"
             alt="ShelfBound Logo" class="logo-img">
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

<!-- ================= CONTACT FORM ================= -->
<div class="contact-container">
    <div class="contact-card">

        <div class="card-eyebrow">Contact us</div>
        <h2>We'd love to hear from you</h2>
        <p class="subtitle">
            Have a question about an order, a suggestion, or just want to share
            what you're reading? Drop us a message and we'll get back to you
            within 24 hours.
        </p>

        <div class="card-divider"></div>

        <%
            if (successMsg != null) {
        %>
            <div class="success-msg">&#10003; &nbsp;<%= successMsg %></div>
        <%
            }
            if (errorMsg != null) {
        %>
            <div class="error-msg">&#9888; &nbsp;<%= errorMsg %></div>
        <%
            }
        %>

        <form class="contact-form"
              action="<%= request.getContextPath() %>/contact"
              method="post">

            <div class="form-row">
                <div class="form-group">
                    <label for="name">Full name</label>
                    <input type="text" id="name" name="name"
                           placeholder="your name" required>
                </div>
                <div class="form-group">
                    <label for="email">Email address</label>
                    <input type="email" id="email" name="email"
                           placeholder="you@email.com" required>
                </div>
            </div>

            <div class="form-group">
                <label for="messageType">Type of message</label>
                <select id="messageType" name="messageType">
                    <option value="">Select a category</option>
                    <option value="Order issue">Order issue</option>
                    <option value="Book recommendation">Book recommendation</option>
                    <option value="Review / feedback">Review / feedback</option>
                    <option value="General query">General query</option>
                    <option value="Partnership / wholesale">Partnership / wholesale</option>
                </select>
            </div>

           
            <div class="form-group">
                <label for="message">Your message</label>
                <textarea id="message" name="message"
                          placeholder="Tell us about your experience, issue, or suggestion..."
                          required></textarea>
            </div>

            <button type="submit" class="btn-submit">Send message &rarr;</button>

        </form>