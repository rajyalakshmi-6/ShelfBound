<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.shelfbound.model.Order" %>
<%@ page import="com.shelfbound.model.OrderItem" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    Order order = (Order) request.getAttribute("order");
    String username = (String) session.getAttribute("username");
    NumberFormat currency = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Order #<%= order.getOrderId() %> — ShelfBound</title>

<style>

* { box-sizing: border-box; margin: 0; padding: 0; }

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: white;
    min-height: 100vh;
    color: #1e293b;
    -webkit-font-smoothing: antialiased;
}

/* ── Navbar ── */
.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 14px 40px;
    background: linear-gradient(135deg, #dff6ff, #a8d8ff);
    border-bottom: 1px solid #bae6fd;
    position: sticky;
    top: 0;
    z-index: 1000;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}

.logo-container {
    display: flex;
    align-items: center;
    gap: 0;
    text-decoration: none;
}

.logo-img {
    height: 28px;
    width: auto;
    object-fit: contain;
}

.logo {
    font-size: 28px;
    font-weight: 700;
    letter-spacing: -0.5px;
    display: flex;
    align-items: center;
    line-height: 1;
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
    color: #64748b;
    font-weight: 500;
    font-size: 14px;
    padding: 8px 12px;
    border-radius: 8px;
    transition: 0.25s;
}

.nav-links a:hover {
    color: #1e3a8a;
    background: rgba(30, 58, 138, 0.07);
}

.welcome-user {
    color: #1e3a8a;
    font-weight: 600;
    font-size: 14px;
    padding: 8px 12px;
    background: rgba(30, 58, 138, 0.06);
    border-radius: 8px;
}

/* ── Page wrapper ── */
.page-wrapper {
    max-width: 860px;
    margin: 36px auto;
    padding: 0 20px 60px;
}

/* ── Back button ── */
.back-btn {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    text-decoration: none;
    color: #1e3a8a;
    font-size: 14px;
    font-weight: 600;
    padding: 10px 20px;
    border: 1px solid #bfdbfe;
    border-radius: 9px;
    background: #eff6ff;
    margin-bottom: 28px;
    transition: background 0.25s, border-color 0.25s, transform 0.25s;
}

.back-btn:hover {
    background: #dbeafe;
    border-color: #93c5fd;
    transform: translateX(-4px);
}

/* ── Detail card ── */
.detail-card {
    background: #ffffff;
    border-radius: 18px;
    box-shadow: 0 6px 24px rgba(0,0,0,0.08);
    overflow: hidden;
}

/* ── Card top band ── */
.card-top {
    background: linear-gradient(135deg, #1e3a8a, #2563eb);
    padding: 26px 32px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px;
}

.card-top h2 {
    color: #ffffff;
    font-size: 22px;
    font-weight: 700;
    margin: 0 0 4px;
}

.card-top .order-date-sub {
    color: rgba(255,255,255,0.72);
    font-size: 13px;
}

/* ── Status badge ── */
.status-badge {
    font-size: 13px;
    font-weight: 700;
    padding: 7px 20px;
    border-radius: 20px;
    text-transform: capitalize;
}

.status-badge.pending   { background: #fef9c3; color: #b45309; }
.status-badge.delivered { background: #dcfce7; color: #15803d; }
.status-badge.completed { background: #dcfce7; color: #15803d; }
.status-badge.cancelled { background: #fee2e2; color: #b91c1c; }

/* ── Two column info ── */
.two-col {
    display: grid;
    grid-template-columns: 1fr 1fr;
    border-bottom: 1px solid #f1f5f9;
}

.info-block {
    padding: 24px 32px;
}

.info-block:first-child {
    border-right: 1px solid #f1f5f9;
}

.block-title {
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 0.09em;
    text-transform: uppercase;
    color: #94a3b8;
    margin-bottom: 16px;
}

.info-row {
    margin-bottom: 12px;
}

.info-row:last-child { margin-bottom: 0; }

.info-label {
    font-size: 11px;
    font-weight: 600;
    color: #94a3b8;
    text-transform: uppercase;
    letter-spacing: 0.06em;
    margin-bottom: 3px;
}

.info-value {
    font-size: 14px;
    font-weight: 500;
    color: #1e293b;
    line-height: 1.5;
}

/* ── Address box ── */
.address-box {
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 10px;
    padding: 14px 16px;
    font-size: 14px;
    color: #334155;
    line-height: 1.8;
}

/* ── Items section ── */
.items-section {
    padding: 24px 32px;
    border-bottom: 1px solid #f1f5f9;
}

.order-item {
    display: flex;
    align-items: center;
    gap: 18px;
    padding: 16px 0;
    border-bottom: 1px solid #f8fafc;
}

.order-item:last-child { border-bottom: none; }

.order-item img {
    width: 68px;
    height: 90px;
    object-fit: cover;
    border-radius: 8px;
    background: #f1f5f9;
    flex-shrink: 0;
    border: 1px solid #e2e8f0;
}

.item-info { flex: 1; }

.item-title {
    font-size: 15px;
    font-weight: 600;
    color: #1e293b;
    margin-bottom: 5px;
}

.item-meta {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
    margin-top: 6px;
}

.meta-chip {
    font-size: 12px;
    font-weight: 500;
    background: #f1f5f9;
    color: #475569;
    padding: 3px 10px;
    border-radius: 20px;
}

.item-subtotal {
    font-size: 16px;
    font-weight: 700;
    color: #1e3a8a;
    white-space: nowrap;
}

/* ── Total row ── */
.total-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 32px;
    background: #f8fafc;
}

.total-label {
    font-size: 15px;
    color: #64748b;
    font-weight: 600;
}

.total-items-count {
    font-size: 13px;
    color: #94a3b8;
    margin-top: 3px;
}

.total-amount {
    font-size: 24px;
    font-weight: 800;
    color: #1e3a8a;
}

/* ── Responsive ── */
@media (max-width: 700px) {

    .navbar {
        flex-direction: column;
        gap: 16px;
        padding: 20px;
    }

    .nav-links {
        justify-content: center;
        gap: 8px;
    }

    .two-col {
        grid-template-columns: 1fr;
    }

    .info-block:first-child {
        border-right: none;
        border-bottom: 1px solid #f1f5f9;
    }

    .card-top {
        flex-direction: column;
        align-items: flex-start;
    }

    .items-section,
    .info-block,
    .total-row {
        padding-left: 20px;
        padding-right: 20px;
    }
}

</style>
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
        <a href="<%= request.getContextPath() %>/contact">Contact</a>

        <%
            if (username == null) {
        %>
            <a href="<%= request.getContextPath() %>/login">Login</a>
        <%
            } else {
        %>
            <span class="welcome-user">Welcome, <%= username %></span>
            <a href="<%= request.getContextPath() %>/logout">Logout</a>
        <%
            }
        %>
        <a href="<%= request.getContextPath() %>/adminLogin">Admin</a>
    </div>

</div>

<!-- ================= PAGE CONTENT ================= -->
<div class="page-wrapper">

    <!-- Back button -->
    <a href="<%= request.getContextPath() %>/orders" class="back-btn">
        &#8592; Back to My Orders
    </a>

    <div class="detail-card">

        <!-- Top band -->
        <div class="card-top">
            <div>
                <h2>Order #<%= order.getOrderId() %></h2>
                <div class="order-date-sub">Placed on <%= order.getOrderDate() %></div>
            </div>
            <span class="status-badge <%= order.getStatus().toLowerCase() %>">
                <%= order.getStatus() %>
            </span>
        </div>

        <!-- Customer + Shipping -->
        <div class="two-col">

            <div class="info-block">
                <div class="block-title">Customer details</div>

                <div class="info-row">
                    <div class="info-label">Name</div>
                    <div class="info-value"><%= username != null ? username : "N/A" %></div>
                </div>

                <div class="info-row">
                    <div class="info-label">Order ID</div>
                    <div class="info-value">#<%= order.getOrderId() %></div>
                </div>

                <div class="info-row">
                    <div class="info-label">Order date</div>
                    <div class="info-value"><%= order.getOrderDate() %></div>
                </div>

                <div class="info-row">
                    <div class="info-label">Status</div>
                    <div class="info-value"><%= order.getStatus() %></div>
                </div>
            </div>

            <div class="info-block">
                <div class="block-title">Shipping address</div>
                <div class="address-box">
                    <%
                        String addr = order.getShippingAddress();
                        if (addr != null && !addr.trim().isEmpty()) {
                            out.print(addr.replace(",", "<br>"));
                        } else {
                    %>
                        <span style="color:#94a3b8;">No address on record</span>
                    <%
                        }
                    %>
                </div>
            </div>

        </div>

        <!-- Items -->
        <div class="items-section">
            <div class="block-title">Items ordered</div>

            <%
                int itemCount = 0;
                for (OrderItem item : order.getItems()) {
                    itemCount++;
            %>
            <div class="order-item">
<img src="<%= request.getContextPath() %>/assets/<%= item.getImageUrl() %>" alt="<%= item.getTitle() %>">
     

                <div class="item-info">
                    <div class="item-title"><%= item.getTitle() %></div>
                    <div class="item-meta">
                        <span class="meta-chip">Qty: <%= item.getQuantity() %></span>
                        <span class="meta-chip">Unit price: <%= currency.format(item.getPrice()) %></span>
                    </div>
                </div>

                <div class="item-subtotal">
                    <%= currency.format(item.getPrice() * item.getQuantity()) %>
                </div>

            </div>
            <%
                }
            %>
        </div>

        <!-- Total -->
        <div class="total-row">
            <div>
                <div class="total-label">Order total</div>
                <div class="total-items-count">
                    <%= itemCount %> item<%= itemCount > 1 ? "s" : "" %>
                </div>
            </div>
            <div class="total-amount">
                <%= currency.format(order.getTotalAmount()) %>
            </div>
        </div>

    </div>

</div>

</body>
</html>