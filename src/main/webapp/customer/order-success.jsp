<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String orderId = request.getParameter("orderId");

    if (orderId == null) {
        orderId = (request.getAttribute("orderId") != null)
                ? request.getAttribute("orderId").toString()
                : "N/A";
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Order Success - ShelfBound</title>

<style>

/* ================= GLOBAL ================= */
body {
    margin: 0;
    font-family: 'Segoe UI', sans-serif;
    background: linear-gradient(135deg, #dff6ff, #a8d8ff, #e3f2fd);
    min-height: 100vh;
}

/* ================= CENTER WRAPPER ================= */
.wrapper {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
}

/* ================= CARD ================= */
.container {
    width: 100%;
    max-width: 600px;
    background: rgba(255,255,255,0.97);
    padding: 45px;
    text-align: center;
    border-radius: 18px;
    box-shadow: 0 12px 35px rgba(0,0,0,0.15);
    animation: fadeIn 0.5s ease-in-out;
}

/* animation */
@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(15px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* ================= ICON ================= */
.icon {
    width: 85px;
    height: 85px;
    margin: 0 auto;
    background: linear-gradient(135deg, #28a745, #1e7e34);
    color: white;
    font-size: 42px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    font-weight: bold;
    box-shadow: 0 8px 20px rgba(0,0,0,0.25);
}

/* ================= TEXT ================= */
h1 {
    color: #1e3a8a;
    margin-top: 18px;
    font-size: 28px;
}

.subtext {
    color: #555;
    font-size: 15px;
    margin-top: 8px;
}

.order-id {
    margin-top: 12px;
    font-weight: bold;
    font-size: 16px;
    color: #222;
}

/* ================= BUTTONS ================= */
.actions {
    margin-top: 25px;
}

.btn {
    display: inline-block;
    margin: 10px 8px;
    padding: 12px 22px;
    text-decoration: none;
    border-radius: 10px;
    font-weight: bold;
    transition: 0.3s ease;
    font-size: 14px;
}

/* HOME */
.btn-home {
    background: #1e3a8a;
    color: white;
}

.btn-home:hover {
    background: #14285c;
    transform: translateY(-2px);
}

/* ORDERS */
.btn-orders {
    background: linear-gradient(135deg, #ff7a00, #ff5500);
    color: white;
}

.btn-orders:hover {
    transform: translateY(-2px);
}

/* ================= RESPONSIVE ================= */
@media (max-width: 600px) {
    .container {
        margin: 20px;
        padding: 30px;
    }
}

</style>

</head>

<body>

<div class="wrapper">

    <div class="container">

        <div class="icon">✓</div>

        <h1>Order Placed Successfully!</h1>

        <div class="subtext">
            Thank you for shopping with ShelfBound.
        </div>

        <div class="order-id">
            Order ID: #<%= orderId %>
        </div>

        <div class="subtext">
            Your order is now being processed.
        </div>

        <div class="actions">

            <a class="btn btn-home"
               href="<%= request.getContextPath() %>/home">
                Continue Shopping
            </a>

            <a class="btn btn-orders"
               href="<%= request.getContextPath() %>/orders">
                View My Orders
            </a>

        </div>

    </div>

</div>

</body>
</html>