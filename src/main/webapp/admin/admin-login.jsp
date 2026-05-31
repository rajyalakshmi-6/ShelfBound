<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Admin Login - ShelfBound</title>

<link rel="stylesheet"
href="<%= request.getContextPath() %>/assets/css/admin-login.css">

</head>

<body>

<div class="login-container">

    <div class="login-card">

        <h1>Admin Login</h1>

        <p>Welcome to ShelfBound Admin Workspace</p>

        <%
        String errorMessage =
        (String) request.getAttribute("errorMessage");

        if(errorMessage != null){
        %>

        <div class="error-message">
            <%= errorMessage %>
        </div>

        <%
        }
        %>

        <form action="<%= request.getContextPath() %>/adminLogin"
              method="post"   autocomplete="off">

            <input
                type="text"
                name="username"
                placeholder="Enter Username"  autocomplete="off"
                required>

            <input
                type="password"
                name="password"
                placeholder="Enter Password"    autocomplete="off"
                required>

            <button type="submit">
                Login
            </button>

        </form>

    </div>

</div>

</body>
</html>