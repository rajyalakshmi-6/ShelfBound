<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Forgot Password - ShelfBound</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    background: 
        linear-gradient(135deg, rgba(11, 17, 32, 0.82), rgba(30, 58, 138, 0.76)),
        radial-gradient(1200px circle at 20% 15%, rgba(255, 122, 0, 0.22), transparent 50%),
        url('<%= request.getContextPath() %>/assets/images/auth-bg.jpg') center/cover no-repeat fixed;
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 30px 15px;
    color: #0f172a;
    -webkit-font-smoothing: antialiased;
}

.forgot-card {
    width: 100%;
    max-width: 460px;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border-radius: 24px;
    padding: 44px 38px;
    border: 1px solid rgba(255, 255, 255, 0.5);
    box-shadow: 
        0 25px 60px -10px rgba(0, 0, 0, 0.4),
        0 0 40px rgba(255, 122, 0, 0.12);
    text-align: center;
    animation: fadeIn 0.4s ease-out;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(12px); }
    to { opacity: 1; transform: translateY(0); }
}

.brand-header {
    font-size: 30px;
    font-weight: 800;
    letter-spacing: -0.5px;
    margin-bottom: 20px;
}
.brand-header .shelf { color: #ff7a00; }
.brand-header .bound { color: #1e3a8a; }

.icon-badge {
    width: 68px;
    height: 68px;
    margin: 0 auto 20px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #eff6ff, #dbeafe);
    border: 2px solid #bfdbfe;
    color: #1d4ed8;
    box-shadow: 0 8px 20px rgba(37, 99, 235, 0.1);
}

h2 {
    font-size: 24px;
    font-weight: 800;
    color: #0f172a;
    letter-spacing: -0.4px;
    margin-bottom: 8px;
}

.subtitle {
    font-size: 14px;
    color: #64748b;
    line-height: 1.6;
    margin-bottom: 24px;
}

.alert-error {
    background: #fef2f2;
    color: #991b1b;
    border: 1px solid #fecaca;
    padding: 12px 16px;
    border-radius: 12px;
    font-size: 13.5px;
    font-weight: 600;
    margin-bottom: 20px;
    text-align: left;
    display: flex;
    align-items: center;
    gap: 10px;
}

.form-group {
    text-align: left;
    margin-bottom: 22px;
}

.form-group label {
    display: block;
    margin-bottom: 8px;
    font-size: 13.5px;
    font-weight: 600;
    color: #334155;
}

.form-group input {
    width: 100%;
    padding: 14px 18px;
    border: 1.5px solid #cbd5e1;
    border-radius: 12px;
    font-size: 15px;
    color: #0f172a;
    background: #ffffff;
    outline: none;
    transition: all 0.25s ease;
    font-family: inherit;
}

.form-group input:focus {
    border-color: #ff7a00;
    box-shadow: 
        0 0 0 4px rgba(255, 122, 0, 0.16),
        0 0 16px rgba(255, 122, 0, 0.1);
}

.btn-primary {
    width: 100%;
    padding: 14px;
    background: linear-gradient(135deg, #ff7a00, #ff9500);
    color: white;
    font-size: 15px;
    font-weight: 700;
    border: none;
    border-radius: 12px;
    cursor: pointer;
    box-shadow: 0 4px 16px rgba(255, 122, 0, 0.35);
    transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 22px rgba(255, 122, 0, 0.45);
}

.footer-links {
    margin-top: 24px;
    padding-top: 20px;
    border-top: 1px solid #e2e8f0;
}

.back-link {
    color: #2563eb;
    text-decoration: none;
    font-size: 13.5px;
    font-weight: 600;
    transition: color 0.2s;
}

.back-link:hover {
    color: #1d4ed8;
    text-decoration: underline;
}

@media (max-width: 480px) {
    body {
        padding: 20px 12px;
    }
    .forgot-card {
        padding: 30px 20px;
        border-radius: 18px;
    }
}
</style>
</head>
<body>

<div class="forgot-card">

    <div class="brand-header">
        <span class="shelf">Shelf</span><span class="bound">Bound</span>
    </div>

    <div class="icon-badge">
        <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
        </svg>
    </div>

    <h2>Reset Password</h2>
    <p class="subtitle">
        Enter your registered email address and we'll send you a 6-digit verification code to reset your password.
    </p>

    <% if (errorMessage != null) { %>
        <div class="alert-error">
            <span>⚠️</span>
            <span><%= errorMessage %></span>
        </div>
    <% } %>

    <form action="<%= request.getContextPath() %>/forgotPassword" method="post">
        <div class="form-group">
            <label>Registered Email</label>
            <input type="email"
                   name="email"
                   placeholder="Enter your email address"
                   required
                   autofocus>
        </div>

        <button type="submit" class="btn-primary">
            Send Verification Code →
        </button>
    </form>

    <div class="footer-links">
        <a href="<%= request.getContextPath() %>/login" class="back-link">
            ← Back to Login
        </a>
    </div>

</div>

</body>
</html>
