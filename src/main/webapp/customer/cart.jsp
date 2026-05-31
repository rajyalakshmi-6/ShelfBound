<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.shelfbound.model.CartItem" %>

<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    String username = (String) session.getAttribute("username");
    double grandTotal = 0;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Your Cart - ShelfBound</title>

<style>

/* ================= CSS VARIABLES & RESET ================= */
:root {
    --primary-blue: #1e3a8a;
    --accent-orange: #ff7a00;
    --bg-main: #fbfbfb;
    --bg-card: #ffffff;
    --text-primary: #1e293b;
    --text-muted: #64748b;
    --border-light: #e2e8f0;
    --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
    --shadow-md: 0 4px 12px rgba(15, 23, 42, 0.05);
    --shadow-hover: 0 10px 20px rgba(15, 23, 42, 0.08);
    --radius-lg: 16px;
    --radius-md: 12px;
    --transition: 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

body {
    margin: 0;
    padding: 0;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: var(--bg-main);
    color: var(--text-primary);
    -webkit-font-smoothing: antialiased;
}

/* ================= NAVBAR (exact match to home.css) ================= */
.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 14px 40px;
   background: linear-gradient(135deg, #dff6ff, #a8d8ff);
    backdrop-filter: blur(8px);
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

.logo-container:hover {
    opacity: 0.95;
}

.logo-img {
    height: 28px;
    width: auto;
    object-fit: contain;
    display: block;
    margin: 0;
    padding: 0;
}

.logo {
    font-size: 28px;
    font-weight: 700;
    letter-spacing: -0.5px;
    display: flex;
    align-items: center;
    line-height: 1;
    margin: 0;
    padding: 0;
}

.logo-shelf { color: #ff7a00; }
.logo-bound { color: #1e3a8a; }

.nav-links {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 16px;
}

.nav-links a {
    text-decoration: none;
    color: var(--text-muted);
    font-weight: 550;
    font-size: 14px;
    padding: 8px 12px;
    border-radius: 8px;
    transition: var(--transition);
}

.nav-links a:hover {
    color: var(--primary-blue);
    background-color: rgba(30, 58, 138, 0.05);
}

.welcome-user {
    color: var(--primary-blue);
    font-weight: 600;
    font-size: 14px;
    padding: 8px 12px;
    background-color: rgba(30, 58, 138, 0.06);
    border-radius: 8px;
}

/* ================= PAGE WRAPPER ================= */
.page-wrapper {
    max-width: 1100px;
    margin: 40px auto;
    padding: 0 40px 60px;
}

/* ================= PAGE TITLE ================= */
.page-title {
    font-size: 26px;
    font-weight: 700;
    color: var(--primary-blue);
    letter-spacing: -0.5px;
    margin: 0 0 28px;
}

/* ================= CART TABLE CARD ================= */
.cart-card {
    background: var(--bg-card);
    border: 1px solid var(--border-light);
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-md);
    overflow: hidden;
}

table {
    width: 100%;
    border-collapse: collapse;
}

thead tr {
    background-color: var(--primary-blue);
}

th {
    color: #ffffff;
    padding: 14px 16px;
    text-align: center;
    font-size: 13px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

td {
    padding: 16px;
    text-align: center;
    border-bottom: 1px solid var(--border-light);
    font-size: 14px;
    color: var(--text-primary);
    vertical-align: middle;
}

tbody tr:last-child td {
    border-bottom: none;
}

tbody tr:hover {
    background-color: rgba(30, 58, 138, 0.02);
}

/* ================= BOOK IMAGE ================= */
.book-img {
    width: 64px;
    height: 88px;
    object-fit: cover;
    border-radius: 8px;
    border: 1px solid var(--border-light);
}

/* ================= BOOK TITLE IN TABLE ================= */
.book-title {
    font-weight: 600;
    color: var(--text-primary);
}

/* ================= PRICE CELL ================= */
.price-cell {
    color: var(--primary-blue);
    font-weight: 700;
    font-size: 15px;
}

/* ================= REMOVE BUTTON ================= */
.btn-delete {
    padding: 7px 14px;
    border: none;
    cursor: pointer;
    border-radius: 8px;
    font-weight: 600;
    font-size: 13px;
    background-color: #fee2e2;
    color: #b91c1c;
    transition: var(--transition);
}

.btn-delete:hover {
    background-color: #fecaca;
    color: #991b1b;
}

/* ================= CART FOOTER ================= */
.cart-footer {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    gap: 24px;
    margin-top: 24px;
    flex-wrap: wrap;
}

.grand-total {
    font-size: 20px;
    font-weight: 700;
    color: var(--primary-blue);
}

.grand-total span {
    font-weight: 400;
    color: var(--text-muted);
    font-size: 16px;
    margin-right: 6px;
}

/* ================= CHECKOUT BUTTON ================= */
.btn-checkout {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 12px 28px;
    background-color: #16a34a;
    color: #ffffff;
    text-decoration: none;
    border-radius: 10px;
    font-weight: 600;
    font-size: 15px;
    letter-spacing: 0.2px;
    border: none;
    cursor: pointer;
    transition: var(--transition);
    box-shadow: 0 4px 12px rgba(22, 163, 74, 0.25);
}

.btn-checkout:hover {
    background-color: #15803d;
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(22, 163, 74, 0.35);
    color: #ffffff;
}

.btn-checkout:active {
    transform: translateY(0);
}

/* ================= EMPTY CART ================= */
.empty-cart {
    text-align: center;
    padding: 80px 40px;
    background: var(--bg-card);
    border: 1px solid var(--border-light);
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-md);
}

.empty-cart p {
    font-size: 18px;
    color: var(--text-muted);
    font-style: italic;
    margin: 0 0 20px;
}

.empty-cart a {
    display: inline-block;
    padding: 11px 26px;
    background-color: var(--primary-blue);
    color: #ffffff;
    text-decoration: none;
    border-radius: 10px;
    font-weight: 600;
    font-size: 14px;
    transition: var(--transition);
}

.empty-cart a:hover {
    background-color: #1e40af;
}

/* ================= RESPONSIVE ================= */
@media (max-width: 900px) {
    .navbar {
        flex-direction: column;
        gap: 16px;
        padding: 20px;
    }

    .nav-links {
        justify-content: center;
        gap: 8px;
    }

    .page-wrapper {
        padding: 0 20px 40px;
    }

    table {
        font-size: 12px;
    }

    th, td {
        padding: 10px 8px;
    }

    .book-img {
        width: 48px;
        height: 66px;
    }

    .cart-footer {
        flex-direction: column;
        align-items: flex-end;
        gap: 14px;
    }
}

</style>

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

<!-- ================= CART CONTENT ================= -->
<div class="page-wrapper">

    <h2 class="page-title">Your Shopping Cart</h2>

    <%
    if (cart == null || cart.isEmpty()) {
    %>

        <div class="empty-cart">
            <p>Your cart is empty.</p>
            <a href="<%= request.getContextPath() %>/books">Browse Books &rarr;</a>
        </div>

    <%
    } else {
    %>

        <div class="cart-card">
            <table>

                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Book</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Total</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                <%
                for (CartItem item : cart) {
                    double total = item.getBook().getPrice() * item.getQuantity();
                    grandTotal += total;
                %>
                    <tr>

                        <td>
                            <img class="book-img"
                                 src="<%= request.getContextPath() + "/assets/" + item.getBook().getImageUrl() %>"
                                 alt="<%= item.getBook().getTitle() %>">
                        </td>

                        <td class="book-title"><%= item.getBook().getTitle() %></td>

                        <td class="price-cell">₹ <%= item.getBook().getPrice() %></td>

                        <td><%= item.getQuantity() %></td>

                        <td class="price-cell">₹ <%= total %></td>

                        <td>
                            <form action="<%= request.getContextPath() %>/removeCart" method="post">
                                <input type="hidden" name="bookId" value="<%= item.getBook().getBookId() %>"/>
                                <button class="btn-delete">Remove</button>
                            </form>
                        </td>

                    </tr>
                <%
                }
                %>
                </tbody>

            </table>
        </div>

        <div class="cart-footer">
            <div class="grand-total">
                <span>Grand Total</span> ₹ <%= grandTotal %>
            </div>
            <a class="btn-checkout" href="<%= request.getContextPath() %>/checkout">
                Proceed to Checkout &rarr;
            </a>
        </div>

    <%
    }
    %>

</div>

</body>
</html>
