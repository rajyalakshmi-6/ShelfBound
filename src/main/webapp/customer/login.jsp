<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login - ShelfBound</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/login.css">

</head>

<body>

	<div class="login-container">

		<!-- ================= LEFT SECTION ================= -->

		<div class="login-left">

			<div class="overlay"></div>

			<div class="brand-content">

				<h1>
					<span class="shelf">Shelf</span><span class="bound">Bound</span>
				</h1>

				<p class="tagline">Discover thousands of books, expand your
					imagination, and build your knowledge journey with ShelfBound.</p>

			</div>

		</div>

		<!-- ================= RIGHT SECTION ================= -->

		<div class="login-right">

			<div class="login-card">

				<h2>Welcome Back</h2>

				<p class="subtitle">Login to continue your reading experience</p>

				<!-- ================= MESSAGES ================= -->

				<%
                String errorMessage = (String) request.getAttribute("errorMessage");
                String successParam = request.getParameter("success");

                if(errorMessage != null){
            %>
				<div class="error-message">
					<%= errorMessage %>
				</div>
				<%
                }

                if(successParam != null){
                    String successText = "Action completed successfully.";
                    if("verified".equals(successParam)) successText = "Account verified successfully! Please login.";
                    else if("passwordReset".equals(successParam)) successText = "Password reset successfully! Login with your new password.";
                    else if("registered".equals(successParam)) successText = "Registration successful! Please login.";
            %>
				<div class="success-message" style="background:#ecfdf5;color:#065f46;border-left:5px solid #10b981;padding:14px 16px;border-radius:12px;margin-bottom:22px;font-size:14px;font-weight:600;text-align:center;box-shadow:0 4px 12px rgba(16,185,129,0.1);">
					<%= successText %>
				</div>
				<%
                }
            %>

				<!-- ================= LOGIN FORM ================= -->

				<form action="${pageContext.request.contextPath}/login"
					method="post">

					<div class="form-group">

						<label>Email</label> 
						<input type="email" name="email"
							placeholder="Enter your email" required>

					</div>

					<div class="form-group">

						<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
							<label style="margin-bottom: 0;">Password</label>
							<a href="${pageContext.request.contextPath}/forgotPassword" class="forgot-link" style="color: #2563eb; font-size: 13px; font-weight: 600; text-decoration: none;">Forgot password?</a>
						</div>
						<input type="password" name="password"
							placeholder="Enter your password" required>

					</div>

					<button type="submit" class="login-btn">Login</button>

				</form>

				<!-- ================= EXTRA LINKS ================= -->

				<div class="extra-links">

					<p>
						Don't have an account? <a
							href="${pageContext.request.contextPath}/customer/register.jsp">
							Register </a>

					</p>

				</div>

			</div>

		</div>

	</div>

</body>
</html>