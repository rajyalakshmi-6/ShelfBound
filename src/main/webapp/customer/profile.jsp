<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.shelfbound.model.User"%>

<%
    User user = (User) request.getAttribute("user");

    if(user == null){
        response.sendRedirect(request.getContextPath()+"/login");
        return;
    }

    Integer orderCount = (Integer)request.getAttribute("orderCount");
    Integer wishlistCount = (Integer)request.getAttribute("wishlistCount");
    Integer cartCount = (Integer)request.getAttribute("cartCount");

    if(orderCount == null) orderCount = 0;
    if(wishlistCount == null) wishlistCount = 0;
    if(cartCount == null) cartCount = 0;

    String username = (String)session.getAttribute("username");
%>

<%
String success = request.getParameter("success");
String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>My Profile | ShelfBound</title>

<link rel="stylesheet"
href="<%=request.getContextPath()%>/assets/css/profile.css">

</head>

<body>

<!-- ================= TOAST ================= -->

<div id="toast" class="toast"></div>

<!-- ================= NAVBAR ================= -->

<div class="navbar">

    <a href="<%=request.getContextPath()%>/home"
       class="logo-container">

        <img
        src="<%=request.getContextPath()%>/assets/images/logo.png"
        class="logo-img">

        <div class="logo">

            <span class="logo-shelf">Shelf</span><span class="logo-bound">Bound</span>

        </div>

    </a>

    <div class="nav-links">

        <a href="<%=request.getContextPath()%>/home">Home</a>

        <a href="<%=request.getContextPath()%>/books">Books</a>

        <a href="<%=request.getContextPath()%>/cart">Cart</a>

        <a href="<%=request.getContextPath()%>/orders">Orders</a>

        <a href="<%=request.getContextPath()%>/wishlist">Wishlist</a>

       				<!-- ================= PROFILE AVATAR (initials circle / guest icon) - START ================= -->
<!-- 📌 REUSABLE BLOCK: copy this <a class="profile-avatar-link">...</a> to any page's navbar -->
<a href="<%= request.getContextPath() %>/profile" class="profile-avatar-link" title="<%= username != null ? username : "Profile" %>">
    <%
        if (username != null && !username.trim().isEmpty()) {
            String initials = username.trim().length() >= 2
                    ? username.trim().substring(0, 2).toUpperCase()
                    : username.trim().substring(0, 1).toUpperCase();
    %>
    <div class="profile-avatar"><%= initials %></div>
    <%
        } else {
    %>
    <div class="profile-avatar profile-avatar-guest">👤</div>
    <%
        }
    %>
</a>
<!-- ================= PROFILE AVATAR (initials circle / guest icon) - END ================= -->

        <span class="welcome-user">Welcome, <%= username %></span>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout" title="Logout">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 2v10"></path>
                    <path d="M18.36 6.64a9 9 0 1 1-12.72 0"></path>
                </svg>
            </a>
            
            <a href="<%= request.getContextPath() %>/adminLogin">Admin</a>

    </div>

</div>

<!-- ================= MEMBERSHIP CARD ================= -->
<div class="card-stage">
    <div class="membership-card">
        <div class="card-monogram">
            <%= user.getUsername().substring(0, Math.min(2, user.getUsername().length())).toUpperCase() %>
        </div>
        <div class="card-details">
            <p class="card-eyebrow">ShelfBound Member</p>
            <h1 class="card-name"><%= user.getUsername() %></h1>
            <p class="card-sub"><%= user.getEmail() %></p>
        </div>
        <span class="card-badge">📖 Active Reader</span>
    </div>
</div>
<!-- ================= DASHBOARD ================= -->

<!-- ================= DASHBOARD ================= -->
<div class="dashboard">

    <div class="dashboard-card">
        <div class="dashboard-icon">📦</div>
        <div class="count"><%=orderCount%></div>
        <div class="label">Orders</div>
    </div>

    <div class="dashboard-card">
        <div class="dashboard-icon">❤️</div>
        <div class="count"><%=wishlistCount%></div>
        <div class="label">Wishlist</div>
    </div>

    <div class="dashboard-card">
        <div class="dashboard-icon">🛒</div>
        <div class="count"><%=cartCount%></div>
        <div class="label">Cart</div>
    </div>

</div>
<!-- ================= PROFILE CARD ================= -->

<div class="profile-card">

<h2>Personal Information</h2>
<p class="section-hint">Keep your delivery details up to date for a smoother checkout.</p>

<form
action="<%=request.getContextPath()%>/profile"
method="post">

<div class="form-group">

<label>

Username

</label>

<input
type="text"
name="username"
value="<%=user.getUsername()%>"
readonly>

</div>

<div class="form-group">

<label>

Email

</label>

<input
type="email"
name="email"
value="<%=user.getEmail()%>"
readonly>

</div>

<div class="form-group">

<label>

Phone

</label>

<input
type="text"
name="phone"
value="<%=user.getPhone()%>"
readonly>

</div>

<div class="form-group">

<label>

Address

</label>

<input
type="text"
name="address"
value="<%=user.getAddress()%>"
readonly>

</div>

<div class="row">

<div class="form-group">

<label>

City

</label>

<input
type="text"
name="city"
value="<%=user.getCity()%>"
readonly>

</div>

<div class="form-group">

<label>

State

</label>

<input
type="text"
name="state"
value="<%=user.getState()%>"
readonly>

</div>

</div>

<div class="form-group">

<label>

Pincode

</label>

<input
type="text"
name="pincode"
value="<%=user.getPincode()%>"
readonly>

</div>

<div class="buttons">

<button
type="button"
id="editBtn">

Edit Profile

</button>

<button
type="submit"
id="saveBtn"
style="display:none;">

Save Changes

</button>

</div>

</form>

</div>

<script>

const editBtn=document.getElementById("editBtn");

const saveBtn=document.getElementById("saveBtn");

const inputs=document.querySelectorAll("input");

editBtn.addEventListener("click",()=>{

inputs.forEach(input=>{

if(input.name!="email"){

input.removeAttribute("readonly");

}

});

editBtn.style.display="none";

saveBtn.style.display="inline-block";

});

function showToast(message, type){
    const toast = document.getElementById("toast");
    toast.textContent = message;
    toast.className = "toast show toast-" + type;

    setTimeout(() => {
        toast.classList.remove("show");
    }, 2000);
}

<%
if(success != null){
%>
showToast("✅ Profile updated successfully.", "success");
<%
} else if(error != null){
%>
showToast("❌ Unable to update profile.", "error");
<%
}
%>

</script>

</body>

</html>
