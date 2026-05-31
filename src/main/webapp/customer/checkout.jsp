<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.shelfbound.model.CartItem" %>

<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

    if (cart == null || cart.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/cart");
        return;
    }

    double total = 0;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Checkout - ShelfBound</title>

<style>

body {
    margin: 0;
    font-family: 'Segoe UI', sans-serif;
    background: linear-gradient(135deg, #dff6ff, #a8d8ff);
}

.container {
    max-width: 900px;
    margin: 40px auto;
    background: rgba(255,255,255,0.95);
    padding: 30px;
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.15);
}

/* TITLE */
h2 {
    text-align: center;
    color: #1e3a8a;
}

/* TABLE */
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

th {
    background: #1e3a8a;
    color: white;
    padding: 12px;
}

td {
    padding: 12px;
    text-align: center;
    border-bottom: 1px solid #eee;
}

/* USER FORM */
.form-group {
    margin-top: 15px;
}

input, textarea {
    width: 100%;
    padding: 10px;
    margin-top: 5px;
    border-radius: 8px;
    border: 1px solid #ccc;
}

/* TOTAL */
.summary {
    text-align: right;
    font-size: 22px;
    font-weight: bold;
    margin-top: 20px;
    color: #28a745;
}

/* BUTTON */
.btn {
    width: 100%;
    margin-top: 25px;
    padding: 14px;
    background: linear-gradient(135deg, #28a745, #1e7e34);
    color: white;
    border: none;
    border-radius: 10px;
    font-size: 16px;
    cursor: pointer;
    font-weight: bold;
    transition: 0.3s;
}

.btn:hover {
    transform: translateY(-2px);
}

/* BACK */
.back {
    display: block;
    margin-top: 15px;
    text-align: center;
    text-decoration: none;
    color: #1e3a8a;
    font-weight: bold;
}

</style>

</head>

<body>

<div class="container">

<h2>Checkout Details</h2>

<!-- CART TABLE -->
<table>

<tr>
    <th>Book</th>
    <th>Price</th>
    <th>Quantity</th>
    <th>Total</th>
</tr>

<%
for (CartItem item : cart) {

    double itemTotal = item.getBook().getPrice() * item.getQuantity();
    total += itemTotal;
%>

<tr>
    <td><%= item.getBook().getTitle() %></td>
    <td>₹ <%= item.getBook().getPrice() %></td>
    <td><%= item.getQuantity() %></td>
    <td>₹ <%= itemTotal %></td>
</tr>

<%
}
%>

</table>

<div class="summary">
    Grand Total: ₹ <%= total %>
</div>

<!-- USER DETAILS FORM (IMPORTANT FIX) -->
<form action="<%= request.getContextPath() %>/checkout" method="post">

    <h3 style="color:#1e3a8a;">Delivery Details</h3>

    <div class="form-group">
        <input type="text" name="address" placeholder="Full Address"  autocomplete="off" required>
    </div>

    <div class="form-group">
        <input type="text" name="city" placeholder="City"  autocomplete="off"  required>
    </div>

    <div class="form-group">
        <input type="text" name="pincode" placeholder="Pincode"  autocomplete="off"  required>
    </div>

    <div class="form-group">
        <select name="paymentMethod">
            <option value="COD">Cash on Delivery</option>
            <option value="UPI">UPI</option>
        </select>
    </div>

    <button type="submit" class="btn">
        Place Order
    </button>

</form>

<a class="back" href="<%= request.getContextPath() %>/cart">
    ← Back to Cart
</a>

</div>

</body>
</html>