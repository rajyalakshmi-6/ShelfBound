<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.shelfbound.model.Order"%>

<%
List<Order> orders = (List<Order>) request.getAttribute("orders");
String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Orders</title>

<style>

/* ================= BASE ================= */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Inter', "Segoe UI", -apple-system, sans-serif;
}

body {
    margin: 0;
    background: 
        radial-gradient(1100px circle at 15% 10%, rgba(30, 58, 138, 0.08), transparent 45%),
        radial-gradient(900px circle at 85% 25%, rgba(255, 122, 0, 0.06), transparent 50%),
        radial-gradient(1200px circle at 50% 80%, rgba(30, 58, 138, 0.05), transparent 60%),
        #f8fafc;
    padding: 30px 20px;
    min-height: 100vh;
    color: #0f172a;
    -webkit-font-smoothing: antialiased;
}

/* ================= CONTAINER ================= */
.container {
    max-width: 1200px;
    margin: auto;
}

h1 {
    font-size: 26px;
    font-weight: 800;
    color: #0f172a;
    letter-spacing: -0.5px;
    margin-bottom: 12px;
}

.back-btn {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    margin: 8px 0 24px 0;
    padding: 10px 18px;
    background: rgba(15, 23, 42, 0.88);
    color: #ffffff;
    text-decoration: none;
    font-size: 13px;
    font-weight: 600;
    letter-spacing: 0.2px;
    border-radius: 10px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
    backdrop-filter: blur(8px);
    transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
}

.back-btn:hover {
    background: #0f172a;
    transform: translateY(-2px);
    box-shadow: 0 8px 18px rgba(0, 0, 0, 0.18);
    color: #ff7a00;
}

/* ================= ORDER CARD ================= */
.order-card {
    background: rgba(255, 255, 255, 0.92);
    backdrop-filter: blur(14px);
    -webkit-backdrop-filter: blur(14px);
    border: 1px solid rgba(226, 232, 240, 0.85);
    margin: 16px 0;
    border-radius: 14px;
    box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
    overflow: hidden;
    transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
}

.order-card:hover {
    border-color: rgba(255, 122, 0, 0.35);
    box-shadow: 0 12px 28px rgba(15, 23, 42, 0.08);
}

.order-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 18px 22px;
    cursor: pointer;
    background: #ffffff;
    transition: background 0.2s ease;
    font-size: 14.5px;
    font-weight: 500;
    color: #1e293b;
}

.order-header:hover {
    background: rgba(248, 250, 252, 0.9);
}

.badge {
    padding: 5px 12px;
    border-radius: 999px;
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 0.3px;
    text-transform: uppercase;
    display: inline-block;
}

.pending {
    background: rgba(245, 158, 11, 0.12);
    color: #b45309;
    border: 1px solid rgba(245, 158, 11, 0.3);
}

.shipped {
    background: rgba(59, 130, 246, 0.12);
    color: #1d4ed8;
    border: 1px solid rgba(59, 130, 246, 0.3);
}

.delivered {
    background: rgba(16, 185, 129, 0.12);
    color: #047857;
    border: 1px solid rgba(16, 185, 129, 0.3);
}

/* ================= DETAILS ================= */
.order-details {
    display: none;
    padding: 22px;
    border-top: 1px solid rgba(226, 232, 240, 0.8);
    background: rgba(248, 250, 252, 0.6);
}

/* ================= ITEMS ================= */
.item {
    display: flex;
    gap: 14px;
    align-items: center;
    margin: 12px 0;
    padding: 8px 12px;
    background: #ffffff;
    border-radius: 10px;
    border: 1px solid #f1f5f9;
}

.item img {
    width: 48px;
    height: 68px;
    object-fit: cover;
    border-radius: 6px;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

select {
    padding: 8px 12px;
    border-radius: 8px;
    border: 1px solid #cbd5e1;
    font-size: 13.5px;
    color: #0f172a;
    background: #ffffff;
    outline: none;
    transition: all 0.2s ease;
}

select:focus {
    border-color: #ff7a00;
    box-shadow: 0 0 0 3px rgba(255, 122, 0, 0.18);
}

/* ================= BUTTON ================= */
.btn {
    background: #2563eb;
    color: white;
    padding: 8px 16px;
    border: none;
    border-radius: 8px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    box-shadow: 0 2px 6px rgba(37, 99, 235, 0.25);
    transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
}

.btn:hover {
    background: #1d4ed8;
    transform: translateY(-1px);
    box-shadow: 0 4px 10px rgba(37, 99, 235, 0.35);
}

/* ================= POPUP ================= */
.popup {
    position: fixed;
    top: 24px;
    right: 24px;
    background: rgba(16, 185, 129, 0.14);
    color: #065f46;
    padding: 14px 20px;
    border-radius: 12px;
    font-weight: 700;
    font-size: 13.5px;
    border: 1px solid rgba(16, 185, 129, 0.35);
    box-shadow: 0 12px 28px rgba(0, 0, 0, 0.1);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    animation: fade 2.5s forwards;
    z-index: 1000;
}

@keyframes fade {
    0% { opacity: 0; transform: translateY(-10px); }
    15% { opacity: 1; transform: translateY(0); }
    80% { opacity: 1; transform: translateY(0); }
    100% { opacity: 0; transform: translateY(-10px); }
}

@media (max-width: 650px) {
    body {
        padding: 20px 14px;
    }
    .order-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 12px;
        padding: 16px;
    }
    .order-details {
        padding: 16px;
    }
    .item {
        flex-direction: column;
        align-items: flex-start;
        gap: 8px;
    }
    form {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }
    select, .btn {
        width: 100%;
    }
}
</style>

<script>
function toggleDetails(id){
    var el = document.getElementById("d"+id);
    el.style.display = (el.style.display==="block")?"none":"block";
}
</script>

</head>

<body>

<div class="container">

<h1>🛍️ Manage Orders</h1>
<a class="back-btn"
   href="<%=request.getContextPath()%>/adminDashboard">
   ← Back to Dashboard
</a>

<% if(success!=null){ %>
<div class="popup">Order Updated Successfully</div>
<% } %>

<%
if(orders!=null){
for(Order o : orders){
%>

<div class="order-card">

    <!-- HEADER -->
    <div class="order-header" onclick="toggleDetails(<%=o.getOrderId()%>)">

        <div>
            <b>Order #<%=o.getOrderId()%></b><br>
            User ID: <%=o.getUserId()%>
        </div>

        <div>
            ₹ <%=o.getTotalAmount()%><br>

            <span class="badge <%=o.getStatus().toLowerCase()%>">
                <%=o.getStatus()%>
            </span>
        </div>

        <div>
            <%=o.getOrderDate()%>
        </div>

    </div>

    <!-- DETAILS -->
    <div class="order-details" id="d<%=o.getOrderId()%>">

        <p><b>Shipping Address:</b> <%=o.getShippingAddress()%></p>

        <h4>Items</h4>

        <%
        for(com.shelfbound.model.OrderItem item : o.getItems()){
        %>

        <div class="item">
            <img 
     src="<%= request.getContextPath() %>/assets/<%= item.getImageUrl() %>"
     alt="Book Image">
            <div>
                <b><%=item.getTitle()%></b><br>
                Qty: <%=item.getQuantity()%> |
                ₹<%=item.getPrice()%>
            </div>
        </div>

        <% } %>

        <!-- STATUS UPDATE -->
        <form method="post" action="<%=request.getContextPath()%>/adminOrder">

            <input type="hidden" name="action" value="updateStatus">
            <input type="hidden" name="orderId" value="<%=o.getOrderId()%>">

            <select name="status">
                <option>Pending</option>
                <option>Shipped</option>
                <option>Delivered</option>
            </select>

            <button class="btn">Update</button>

        </form>

    </div>

</div>

<% }} %>

</div>

</body>
</html>