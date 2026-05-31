<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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

                <input type="password"
                       name="password"
                       placeholder="Enter password"
                       required>
            </div>
           
<div class="form-group">
    <label>Confirm Password</label>

    <input type="password"
           name="confirmPassword"
           placeholder="Confirm password"
           required>
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
                          placeholder="Enter address"></textarea>
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

</body>
</html>