<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
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

				<!-- ================= ERROR MESSAGE ================= -->

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

				<!-- ================= LOGIN FORM ================= -->

				<form action="${pageContext.request.contextPath}/login"
					method="post">

					<div class="form-group">

						<label>Email</label> 
						<input type="email" name="email"
							placeholder="Enter your email" required>

					</div>

					<div class="form-group">

						<label>Password</label> <input type="password" name="password"
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