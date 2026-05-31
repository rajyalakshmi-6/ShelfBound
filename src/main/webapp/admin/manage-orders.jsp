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
<title>Manage Orders</title>

<style>

/* ================= BASE ================= */
body{
    margin:0;
    font-family:Segoe UI;
    background:linear-gradient(135deg,#dbeafe,#eff6ff);
    padding:25px;
}

/* ================= CONTAINER ================= */
.container{
    max-width:1200px;
    margin:auto;
}

h1{
    color:#1e3a8a;
}

/* ================= ORDER CARD ================= */
.order-card{
    background:white;
    margin:15px 0;
    border-radius:12px;
    box-shadow:0 6px 15px rgba(0,0,0,0.08);
    overflow:hidden;
}

.order-header{
    display:flex;
    justify-content:space-between;
    padding:15px;
    cursor:pointer;
    background:#f8fafc;
}

.order-header:hover{
    background:#eef2ff;
}

.badge{
    padding:4px 10px;
    border-radius:20px;
    font-size:12px;
    font-weight:bold;
}

.pending{background:#fef3c7;color:#92400e;}
.shipped{background:#dbeafe;color:#1e40af;}
.delivered{background:#dcfce7;color:#166534;}

/* ================= DETAILS ================= */
.order-details{
    display:none;
    padding:15px;
    border-top:1px solid #eee;
}

/* ================= ITEMS ================= */
.item{
    display:flex;
    gap:10px;
    align-items:center;
    margin:8px 0;
}

.item img{
    width:50px;
    height:70px;
    object-fit:cover;
}

/* ================= BUTTON ================= */
.btn{
    background:#1e3a8a;
    color:white;
    padding:6px 10px;
    border:none;
    border-radius:6px;
    cursor:pointer;
}

/* ================= POPUP ================= */
.popup{
    position:fixed;
    top:20px;
    right:20px;
    background:#dcfce7;
    color:#166534;
    padding:12px 18px;
    border-radius:8px;
    animation:fade 2s forwards;
}

.back-btn{
    display:inline-block;
    margin:10px 0 20px 0;
    padding:10px 16px;
    background: linear-gradient(135deg, #22c55e, #16a34a);
    color:white;
    text-decoration:none;
    font-weight:600;
    border-radius:10px;
    box-shadow:0 4px 10px rgba(34,197,94,0.3);
    transition:0.3s;
}

.back-btn:hover{
    transform:translateY(-2px);
    box-shadow:0 6px 14px rgba(34,197,94,0.4);
}

@keyframes fade{
    0%{opacity:0;transform:translateY(-10px);}
    10%{opacity:1;}
    80%{opacity:1;}
    100%{opacity:0;}
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