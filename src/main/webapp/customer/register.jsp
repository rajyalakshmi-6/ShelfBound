<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register - ShelfBound</title>

<link rel="preconnect" href="https://fonts.googleapis.com">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/register.css">

</head>

<body>

<div class="register-container">

    <!-- ================= LEFT SECTION ================= -->

    <div class="left-section">

        <div class="logo">
            <span class="shelf">Shelf</span><span class="bound">Bound</span>
        </div>

        <h2>Join The Reading Revolution</h2>

        <p>
            Create your ShelfBound account and explore thousands
            of books across fiction, academics, competitive exams,
            self-growth and much more.
        </p>

    </div>

    <!-- ================= RIGHT SECTION ================= -->

    <div class="right-section">

        <h1 class="form-title">Create Account</h1>

        <p class="subtitle">
            Register to start your reading journey
        </p>

        <!-- ERROR MESSAGE -->

        <%
            String error =
                (String) request.getAttribute("errorMessage");

            if(error != null && !error.trim().isEmpty()){
        %>

            <div class="error-message">
                <%= error %>
            </div>

        <%
            }
        %>

        <!-- FORM -->

        <form action="<%= request.getContextPath() %>/register"
              method="post">

            <div class="form-group">
                <label>Username</label>

                <input type="text"
                       name="username"
                       placeholder="Enter username"
                       required>
            </div>

            <div class="form-group">
                <label>Email</label>

                <input type="email"
                       name="email"
                       placeholder="Enter email"
                       required>
            </div>

            <div class="form-group">
                <label>Password</label>

                <div class="password-field-wrapper">
                    <input type="password"
                           id="registerPassword"
                           name="password"
                           placeholder="Enter password"
                           required>
                    <button type="button" class="password-toggle-btn" onclick="togglePasswordVisibility('registerPassword', this)" aria-label="Toggle password visibility">
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
           
            <div class="form-group">
                <label>Confirm Password</label>

                <div class="password-field-wrapper">
                    <input type="password"
                           id="registerConfirmPassword"
                           name="confirmPassword"
                           placeholder="Confirm password"
                           required>
                    <button type="button" class="password-toggle-btn" onclick="togglePasswordVisibility('registerConfirmPassword', this)" aria-label="Toggle password visibility">
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
            

            <div class="row">

                <div class="form-group">
                    <label>Phone</label>

                    <input type="text"
                           name="phone"
                           placeholder="Phone number">
                </div>

                <div class="form-group">
                    <label>Pincode</label>

                    <input type="text"
                           name="pincode"
                           placeholder="Pincode">
                </div>

            </div>

            <div class="form-group">
                <label>Address</label>

                <textarea name="address"
                          placeholder="Street address"></textarea>
            </div>

            <div class="row">

                <div class="form-group">
                    <label>City</label>

                    <input type="text"
                           name="city"
                           placeholder="City">
                </div>

                <div class="form-group">
                    <label>State</label>

                    <input type="text"
                           name="state"
                           placeholder="State">
                </div>

            </div>

            <button type="submit"
                    class="register-btn">

                Create Account

            </button>

        </form>

        <div class="login-link">

            Already have an account?

            <a href="<%= request.getContextPath() %>/login">
                Login
            </a>

        </div>

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