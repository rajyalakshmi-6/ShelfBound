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
                    <div class="input-wrapper password-input-wrapper">
                        <span class="input-icon">🔑</span>
                        <input type="password" id="adminPassword" name="password" placeholder="Enter your password" autocomplete="off" required>
                        <button type="button" class="password-toggle-btn" onclick="togglePasswordVisibility('adminPassword', this)" aria-label="Toggle password visibility">
                            <svg class="eye-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                <circle cx="12" cy="12" r="3"></circle>
                            </svg>
                            <svg class="eye-off-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:none;">
                                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                                <line x1="1" y1="1" x2="23" y2="23"></line>
                            </svg>
                        </button>
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

    <script>
        function togglePasswordVisibility(inputId, btn) {
            var input = document.getElementById(inputId);
            if (!input) return;
            var isPassword = input.type === 'password';
            input.type = isPassword ? 'text' : 'password';
            var eyeIcon = btn.querySelector('.eye-icon');
            var eyeOffIcon = btn.querySelector('.eye-off-icon');
            if (eyeIcon && eyeOffIcon) {
                eyeIcon.style.display = isPassword ? 'none' : 'block';
                eyeOffIcon.style.display = isPassword ? 'block' : 'none';
            }
        }
    </script>

</body>
</html>