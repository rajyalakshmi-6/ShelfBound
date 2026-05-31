
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.shelfbound.model.Order" %>
<%@ page import="com.shelfbound.model.OrderItem" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>


<%
    List<Order> orders =
        (List<Order>) request.getAttribute("orders");

    NumberFormat currency = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Orders - ShelfBound</title>

<style>

/* ================= GLOBAL ================= */
body {
    margin: 0;
    font-family: 'Segoe UI', sans-serif;
    background: linear-gradient(135deg, #dff6ff, #a8d8ff);
}

/* ================= CONTAINER ================= */
.container {
    max-width: 1000px;
    margin: 40px auto;
}

/* ================= ORDER CARD ================= */
.order-card {
    background: white;
    padding: 20px;
    margin-bottom: 20px;
    border-radius: 15px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.1);
    transition: 0.3s;
}

.order-card:hover {
    transform: translateY(-3px);
}

/* ================= HEADER ================= */
.order-header {
    display: flex;
    justify-content: space-between;
    font-weight: bold;
    color: #1e3a8a;
    font-size: 16px;
}

/* ================= ITEMS ================= */
.item {
    display: flex;
    align-items: center;
    gap: 15px;
    margin-top: 10px;
    padding: 10px 0;
    border-bottom: 1px solid #eee;
}

.item img {
    width: 60px;
    height: 80px;
    object-fit: cover;
    border-radius: 8px;
}

/* ================= STATUS ================= */
.status.pending { color: orange; }
.status.completed { color: green; }
.status.cancelled { color: red; }

.status {
    font-weight: bold;
}

/* ================= TOTAL ================= */
.total {
    margin-top: 10px;
    font-weight: bold;
    font-size: 16px;
    color: #333;
}

/* ================= VIEW DETAILS BUTTON ================= */
.details-btn {
    display: inline-block;
    margin-top: 15px;
    padding: 10px 15px;
    background: #1e3a8a;
    color: white;
    text-decoration: none;
    border-radius: 8px;
    font-size: 14px;
    transition: 0.3s;
}

.details-btn:hover {
    background: #93c5fd;
    color: #1e3a8a;
    transform: translateY(-2px);
}

/* ================= EMPTY STATE ================= */
.empty {
    text-align: center;
    font-size: 18px;
    color: #555;
    margin-top: 80px;
}

/* ================= FOOTER ================= */
.footer-box {
    text-align: center;
    margin-top: 50px;
    padding: 30px;
    background: linear-gradient(135deg, #ffffff, #f3f7ff);
    border-radius: 15px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.08);
}

.footer-text {
    font-size: 18px;
    font-style: italic;
    color: #1e3a8a;
    opacity: 0.85;
    margin-bottom: 20px;
}

.footer-sub {
    font-size: 14px;
    color: #666;
    margin-bottom: 20px;
}

.shop-btn {
    display: inline-block;
    padding: 12px 25px;
    background: linear-gradient(135deg, #28a745, #1e7e34);
    color: white;
    text-decoration: none;
    border-radius: 10px;
    font-weight: bold;
    transition: 0.3s;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

.shop-btn:hover {
    transform: translateY(-2px);
}

</style>
</head>

<body>

<div class="container">

<h2 style="text-align:center; color:#1e3a8a;">My Orders</h2>

<%
if (orders == null || orders.isEmpty()) {
%>

<div class="empty">
    🛒 No orders found
</div>

<%
} else {

    for (Order o : orders) {
%>

<div class="order-card">

    <div class="order-header">
        <span>Order #<%= o.getOrderId() %></span>

        <span class="status <%= o.getStatus().toLowerCase() %>">
            <%= o.getStatus() %>
        </span>
    </div>

    <div class="total">
        Total: <%= currency.format(o.getTotalAmount()) %>
    </div>

    <%
        for (OrderItem item : o.getItems()) {
    %>

    <div class="item">

        <img src="<%= request.getContextPath() %>/assets/<%= item.getImageUrl() %>" alt="Book Image">
        <div>
            <b><%= item.getTitle() %></b><br>
            Qty: <%= item.getQuantity() %><br>
            Price: <%= currency.format(item.getPrice()) %>
        </div>

    </div>

    <%
        }
    %>

    <a class="details-btn"
       href="<%= request.getContextPath() %>/orderDetails?orderId=<%= o.getOrderId() %>">
        View Details
    </a>

</div>

<%
    }
}
%>

<!-- ================= FOOTER (OUTSIDE LOOP - FIXED) ================= -->
<div class="footer-box">

    <div class="footer-text">
        ✨ Go and Explore Moreeee ..
    </div>

    <div class="footer-sub">
        📚Discover new books, stories, and knowledge waiting for you.
    </div>

    <a class="shop-btn"
       href="<%= request.getContextPath() %>/books">
         🛒Continue Shopping
    </a>

</div>

</div>

</body>
</html>