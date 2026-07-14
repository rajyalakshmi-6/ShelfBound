<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login | ShelfBound</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin-login.css">
</head>

<body>

    <div class="login-container">

        <div class="login-card">

            <div class="admin-badge">🔒 Secure Workspace</div>

            <div class="login-logo">
                <img src="<%= request.getContextPath() %>/assets/images/logo.png" alt="ShelfBound">
                <div class="login-logo-text">
                    <span class="login-logo-shelf">Shelf</span>
                    <span class="login-logo-bound">Bound</span>
                </div>
            </div>

            <h1>Admin Login</h1>
            <p class="login-subtitle">Enter your credentials to access the admin dashboard</p>

            <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if(errorMessage != null){
            %>
            <div class="error-message"><%= errorMessage %></div>
            <%
            }
            %>

            <form action="<%= request.getContextPath() %>/adminLogin" method="post" autocomplete="off">

                <div class="form-group">
                    <label class="form-label">Username</label>
                    <div class="input-wrapper">
                        <span class="input-icon">👤</span>
                        <input type="text" name="username" placeholder="Enter your username" autocomplete="off" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Password</label>
                    <div class="input-wrapper">
                        <span class="input-icon">🔑</span>
                        <input type="password" name="password" placeholder="Enter your password" autocomplete="off" required>
                    </div>
                </div>

              

                <button type="submit">Sign In to Dashboard</button>

            </form>

            <div class="security-footer">
                <span class="lock-icon">🔐</span>
                <span>SSL Secured Connection</span>
            </div>

        </div>

        <div class="back-link">
            ← <a href="<%= request.getContextPath() %>/home">Back to Store</a>
        </div>

    </div>

</body>
</html>