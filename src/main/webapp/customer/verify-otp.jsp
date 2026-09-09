<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.shelfbound.model.User" %>

<%
    User pendingUser = (User) session.getAttribute("pendingUser");
    String email = pendingUser != null ? pendingUser.getEmail() : "";
    String maskedEmail = "";
    if (email != null && email.contains("@")) {
        int atIdx = email.indexOf("@");
        if (atIdx > 2) {
            maskedEmail = email.substring(0, 2) + "***" + email.substring(atIdx);
        } else {
            maskedEmail = email.substring(0, 1) + "***" + email.substring(atIdx);
        }
    }

    Boolean isVerified = (Boolean) request.getAttribute("isVerified");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String infoMessage = (String) request.getAttribute("infoMessage");
    Boolean resendAllowed = (Boolean) request.getAttribute("resendAllowed");

    Long regOtpExpiry = (Long) session.getAttribute("regOtpExpiry");
    long remainingSeconds = 0;
    if (regOtpExpiry != null) {
        remainingSeconds = Math.max(0, (regOtpExpiry - System.currentTimeMillis()) / 1000);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Verify OTP - ShelfBound</title>
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

.otp-card {
    width: 100%;
    max-width: 480px;
    background: rgba(255, 255, 255, 0.94);
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
    width: 70px;
    height: 70px;
    margin: 0 auto 20px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
}

.icon-badge.pending {
    background: linear-gradient(135deg, #fff7ed, #ffedd5);
    border: 2px solid #fed7aa;
    color: #ea580c;
}

.icon-badge.success {
    background: linear-gradient(135deg, #ecfdf5, #d1fae5);
    border: 2px solid #a7f3d0;
    color: #059669;
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

.email-pill {
    display: inline-block;
    background: #f1f5f9;
    color: #1e293b;
    font-weight: 700;
    padding: 3px 10px;
    border-radius: 6px;
    margin-top: 4px;
}

.alert-box {
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

.alert-error {
    background: #fef2f2;
    color: #991b1b;
    border: 1px solid #fecaca;
}

.alert-info {
    background: #ecfdf5;
    color: #065f46;
    border: 1px solid #a7f3d0;
}

.otp-input-group {
    margin-bottom: 24px;
}

.otp-input {
    width: 100%;
    padding: 16px 20px;
    font-size: 28px;
    font-weight: 800;
    letter-spacing: 12px;
    text-align: center;
    border: 2px solid #cbd5e1;
    border-radius: 14px;
    background: #ffffff;
    color: #0f172a;
    outline: none;
    transition: all 0.25s ease;
    font-family: monospace, sans-serif;
}

.otp-input:focus {
    border-color: #ff7a00;
    box-shadow: 
        0 0 0 4px rgba(255, 122, 0, 0.16),
        0 0 16px rgba(255, 122, 0, 0.1);
}

.timer-box {
    font-size: 13px;
    color: #64748b;
    margin-bottom: 24px;
    font-weight: 500;
}

.timer-box span {
    font-weight: 700;
    color: #0f172a;
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
    text-decoration: none;
    display: inline-block;
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 22px rgba(255, 122, 0, 0.45);
}

.btn-success {
    background: linear-gradient(135deg, #10b981, #059669);
    box-shadow: 0 4px 16px rgba(16, 185, 129, 0.35);
}

.btn-success:hover {
    box-shadow: 0 8px 22px rgba(16, 185, 129, 0.45);
}

.resend-section {
    margin-top: 22px;
    padding-top: 18px;
    border-top: 1px solid #e2e8f0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 13px;
}

.resend-btn {
    background: none;
    border: none;
    color: #2563eb;
    font-weight: 700;
    font-size: 13px;
    cursor: pointer;
    transition: color 0.2s;
    text-decoration: underline;
}

.resend-btn:hover {
    color: #1d4ed8;
}

.back-link {
    color: #64748b;
    text-decoration: none;
    font-size: 13px;
    font-weight: 500;
    transition: color 0.2s;
}

.back-link:hover {
    color: #0f172a;
}

@media (max-width: 480px) {
    body {
        padding: 20px 12px;
    }
    .otp-card {
        padding: 30px 20px;
        border-radius: 18px;
    }
    .otp-input {
        font-size: 22px;
        letter-spacing: 6px;
        padding: 12px 14px;
    }
}
</style>
</head>
<body>

<div class="otp-card">

    <div class="brand-header">
        <span class="shelf">Shelf</span><span class="bound">Bound</span>
    </div>

    <% if (Boolean.TRUE.equals(isVerified)) { %>
        <!-- SUCCESS STATE -->
        <div class="icon-badge success">
            <svg width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="20 6 9 17 4 12"></polyline>
            </svg>
        </div>

        <h2>OTP Verified Successfully!</h2>
        <p class="subtitle">
            Your account has been created and verified successfully. You can now login to begin your reading journey!
        </p>

        <a href="<%= request.getContextPath() %>/login?success=verified" class="btn-primary btn-success">
            Login to Continue →
        </a>

    <% } else { %>
        <!-- VERIFICATION INPUT STATE -->
        <div class="icon-badge pending">
            <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                <polyline points="22,6 12,13 2,6"></polyline>
            </svg>
        </div>

        <h2>Enter Verification Code</h2>
        <p class="subtitle">
            We have sent a 6-digit verification code to<br>
            <span class="email-pill"><%= maskedEmail.isEmpty() ? "your registered email" : maskedEmail %></span>
        </p>

        <% if (errorMessage != null) { %>
            <div class="alert-box alert-error">
                <span>⚠️</span>
                <span><%= errorMessage %></span>
            </div>
        <% } %>

        <% if (infoMessage != null) { %>
            <div class="alert-box alert-info">
                <span>✓</span>
                <span><%= infoMessage %></span>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/verifyOtp" method="post" id="verifyForm">
            <input type="hidden" name="action" value="verify">

            <div class="otp-input-group">
                <input type="text"
                       name="otp"
                       class="otp-input"
                       placeholder="••••••"
                       maxlength="6"
                       pattern="[0-9]{6}"
                       inputmode="numeric"
                       autocomplete="one-time-code"
                       required
                       autofocus>
            </div>

            <div class="timer-box" id="timerContainer">
                Code expires in: <span id="timerText">05:00</span>
            </div>

            <button type="submit" class="btn-primary">
                Verify &amp; Register
            </button>
        </form>

        <div class="resend-section">
            <form action="<%= request.getContextPath() %>/verifyOtp" method="post" style="display:inline;">
                <input type="hidden" name="action" value="resend">
                <span>Didn't receive code?</span>
                <button type="submit" class="resend-btn" id="resendBtn">Resend OTP</button>
            </form>

            <a href="<%= request.getContextPath() %>/customer/register.jsp" class="back-link">
                ← Re-enter Details
            </a>
        </div>
    <% } %>

</div>

<script>
    // Live countdown timer for OTP expiry
    let remaining = <%= remainingSeconds > 0 ? remainingSeconds : 300 %>;
    const timerText = document.getElementById("timerText");
    const resendBtn = document.getElementById("resendBtn");

    function updateTimer() {
        if (!timerText) return;
        if (remaining <= 0) {
            timerText.innerText = "Expired";
            timerText.style.color = "#dc2626";
            return;
        }
        const mins = Math.floor(remaining / 60);
        const secs = remaining % 60;
        timerText.innerText = (mins < 10 ? "0" : "") + mins + ":" + (secs < 10 ? "0" : "") + secs;
        remaining--;
    }

    if (timerText) {
        updateTimer();
        setInterval(updateTimer, 1000);
    }
</script>

</body>
</html>
