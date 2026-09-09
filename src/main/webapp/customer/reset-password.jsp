<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String email = (String) session.getAttribute("resetEmail");
    if (email == null) {
        email = "";
    }
    String maskedEmail = "";
    if (email != null && email.contains("@")) {
        int atIdx = email.indexOf("@");
        if (atIdx > 2) {
            maskedEmail = email.substring(0, 2) + "***" + email.substring(atIdx);
        } else {
            maskedEmail = email.substring(0, 1) + "***" + email.substring(atIdx);
        }
    }

    String errorMessage = (String) request.getAttribute("errorMessage");
    String infoMessage = (String) request.getAttribute("infoMessage");

    Long resetOtpExpiry = (Long) session.getAttribute("resetOtpExpiry");
    long remainingSeconds = 0;
    if (resetOtpExpiry != null) {
        remainingSeconds = Math.max(0, (resetOtpExpiry - System.currentTimeMillis()) / 1000);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Set New Password - ShelfBound</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=JetBrains+Mono:wght@600;700&display=swap" rel="stylesheet">

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

.reset-card {
    width: 100%;
    max-width: 480px;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border-radius: 24px;
    padding: 40px 36px;
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
    font-size: 28px;
    font-weight: 800;
    letter-spacing: -0.5px;
    margin-bottom: 18px;
}
.brand-header .shelf { color: #ff7a00; }
.brand-header .bound { color: #1e3a8a; }

.icon-badge {
    width: 66px;
    height: 66px;
    margin: 0 auto 16px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #eff6ff, #dbeafe);
    border: 2px solid #bfdbfe;
    color: #1d4ed8;
    box-shadow: 0 8px 20px rgba(37, 99, 235, 0.12);
}

h2 {
    font-size: 22px;
    font-weight: 800;
    color: #0f172a;
    letter-spacing: -0.4px;
    margin-bottom: 8px;
}

.subtitle {
    font-size: 13.5px;
    color: #64748b;
    line-height: 1.5;
    margin-bottom: 14px;
}

.email-pill {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    background: #f1f5f9;
    padding: 5px 14px;
    border-radius: 9999px;
    font-size: 12.5px;
    font-weight: 600;
    color: #1e293b;
    border: 1px solid #e2e8f0;
    margin-bottom: 20px;
}

.alert-error {
    background: #fef2f2;
    color: #991b1b;
    border: 1px solid #fecaca;
    padding: 11px 14px;
    border-radius: 12px;
    font-size: 13px;
    font-weight: 600;
    margin-bottom: 18px;
    text-align: left;
    display: flex;
    align-items: center;
    gap: 8px;
}

.alert-info {
    background: #eff6ff;
    color: #1e40af;
    border: 1px solid #bfdbfe;
    padding: 11px 14px;
    border-radius: 12px;
    font-size: 13px;
    font-weight: 600;
    margin-bottom: 18px;
    text-align: left;
    display: flex;
    align-items: center;
    gap: 8px;
}

.form-group {
    text-align: left;
    margin-bottom: 18px;
}

.form-group label {
    display: block;
    margin-bottom: 6px;
    font-size: 13px;
    font-weight: 600;
    color: #334155;
}

.otp-input-wrapper {
    position: relative;
}

.otp-input-field {
    width: 100%;
    padding: 12px 16px;
    font-family: 'JetBrains Mono', monospace;
    font-size: 20px;
    letter-spacing: 8px;
    text-align: center;
    font-weight: 700;
    border: 1.5px solid #cbd5e1;
    border-radius: 12px;
    color: #0f172a;
    background: #ffffff;
    outline: none;
    transition: all 0.25s ease;
}

.otp-input-field:focus {
    border-color: #ff7a00;
    box-shadow: 
        0 0 0 4px rgba(255, 122, 0, 0.16),
        0 0 16px rgba(255, 122, 0, 0.1);
}

.standard-input {
    width: 100%;
    padding: 12px 16px;
    font-size: 14.5px;
    border: 1.5px solid #cbd5e1;
    border-radius: 12px;
    color: #0f172a;
    background: #ffffff;
    outline: none;
    transition: all 0.25s ease;
    font-family: inherit;
}

.standard-input:focus {
    border-color: #ff7a00;
    box-shadow: 
        0 0 0 4px rgba(255, 122, 0, 0.16),
        0 0 16px rgba(255, 122, 0, 0.1);
}

.btn-primary {
    width: 100%;
    padding: 13px;
    background: linear-gradient(135deg, #ff7a00, #ff9500);
    color: white;
    font-size: 15px;
    font-weight: 700;
    border: none;
    border-radius: 12px;
    cursor: pointer;
    box-shadow: 0 4px 16px rgba(255, 122, 0, 0.35);
    transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
    margin-top: 6px;
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 22px rgba(255, 122, 0, 0.45);
}

.timer-bar {
    font-size: 12.5px;
    color: #64748b;
    margin-top: 16px;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
}

.timer-countdown {
    font-family: 'JetBrains Mono', monospace;
    font-weight: 700;
    color: #ff7a00;
}

.resend-section {
    margin-top: 14px;
    font-size: 13px;
    color: #64748b;
}

.resend-btn {
    background: none;
    border: none;
    color: #2563eb;
    font-size: 13px;
    font-weight: 700;
    cursor: pointer;
    text-decoration: none;
    padding: 0;
    font-family: inherit;
    transition: color 0.2s;
}

.resend-btn:hover:not(:disabled) {
    color: #1d4ed8;
    text-decoration: underline;
}

.resend-btn:disabled {
    color: #94a3b8;
    cursor: not-allowed;
    text-decoration: none;
}

.footer-links {
    margin-top: 22px;
    padding-top: 18px;
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

.password-hint {
    font-size: 11.5px;
    color: #94a3b8;
    margin-top: 4px;
}

@media (max-width: 480px) {
    body {
        padding: 20px 12px;
    }
    .reset-card {
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

<div class="reset-card">

    <div class="brand-header">
        <span class="shelf">Shelf</span><span class="bound">Bound</span>
    </div>

    <div class="icon-badge">
        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 2l-2 2m-1.5 1.5L14 9"></path>
            <circle cx="7.5" cy="16.5" r="5.5"></circle>
            <path d="M16 8l4 4-1.5 1.5L16 11l-2.5 2.5"></path>
        </svg>
    </div>

    <h2>Set New Password</h2>
    <p class="subtitle">
        Enter the 6-digit verification code sent to your email along with your new password.
    </p>

    <% if (!maskedEmail.isEmpty()) { %>
        <div class="email-pill">
            <span>✉️</span>
            <span><%= maskedEmail %></span>
        </div>
    <% } %>

    <% if (errorMessage != null) { %>
        <div class="alert-error">
            <span>⚠️</span>
            <span><%= errorMessage %></span>
        </div>
    <% } %>

    <% if (infoMessage != null) { %>
        <div class="alert-info">
            <span>ℹ️</span>
            <span><%= infoMessage %></span>
        </div>
    <% } %>

    <form id="resetForm" action="<%= request.getContextPath() %>/resetPassword" method="post" onsubmit="return validatePasswords()">
        
        <div class="form-group">
            <label>6-Digit Verification Code</label>
            <div class="otp-input-wrapper">
                <input type="text"
                       name="otp"
                       id="otpInput"
                       class="otp-input-field"
                       placeholder="••••••"
                       maxlength="6"
                       pattern="[0-9]{6}"
                       inputmode="numeric"
                       autocomplete="one-time-code"
                       required
                       autofocus>
            </div>
        </div>

        <div class="form-group">
            <label>New Password</label>
            <input type="password"
                   name="newPassword"
                   id="newPassword"
                   class="standard-input"
                   placeholder="Enter new password (min. 6 characters)"
                   minlength="6"
                   required>
            <div class="password-hint">Must be at least 6 characters.</div>
        </div>

        <div class="form-group">
            <label>Confirm New Password</label>
            <input type="password"
                   name="confirmPassword"
                   id="confirmPassword"
                   class="standard-input"
                   placeholder="Re-enter new password"
                   minlength="6"
                   required>
            <div id="matchError" style="display:none;color:#dc2626;font-size:12px;margin-top:4px;font-weight:600;">
                Passwords do not match.
            </div>
        </div>

        <button type="submit" class="btn-primary">
            Reset Password &amp; Login →
        </button>
    </form>

    <!-- Resend Code -->
    <div class="timer-bar">
        <span>Code expires in:</span>
        <span id="countdownDisplay" class="timer-countdown">--:--</span>
    </div>

    <div class="resend-section">
        <span>Didn't receive the code? </span>
        <form action="<%= request.getContextPath() %>/resetPassword" method="post" style="display:inline;">
            <input type="hidden" name="action" value="resend">
            <button type="submit" id="resendBtn" class="resend-btn">
                Resend Code
            </button>
        </form>
    </div>

    <div class="footer-links">
        <a href="<%= request.getContextPath() %>/login" class="back-link">
            ← Back to Login
        </a>
    </div>

</div>

<script>
    // Countdown Timer logic
    let remainingSeconds = <%= remainingSeconds %>;
    const countdownEl = document.getElementById('countdownDisplay');
    const resendBtn = document.getElementById('resendBtn');

    function updateTimer() {
        if (remainingSeconds <= 0) {
            countdownEl.textContent = "Expired";
            countdownEl.style.color = "#dc2626";
            if (resendBtn) resendBtn.disabled = false;
            return;
        }

        const mins = Math.floor(remainingSeconds / 60);
        const secs = remainingSeconds % 60;
        countdownEl.textContent = 
            (mins < 10 ? '0' : '') + mins + ':' + 
            (secs < 10 ? '0' : '') + secs;

        remainingSeconds--;
        setTimeout(updateTimer, 1000);
    }

    updateTimer();

    // Password Match Client-Side Validation
    function validatePasswords() {
        const p1 = document.getElementById('newPassword').value;
        const p2 = document.getElementById('confirmPassword').value;
        const err = document.getElementById('matchError');

        if (p1 !== p2) {
            err.style.display = 'block';
            return false;
        }
        err.style.display = 'none';
        return true;
    }

    // Auto-focus & sanitize numeric OTP
    const otpInput = document.getElementById('otpInput');
    if (otpInput) {
        otpInput.addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '').slice(0, 6);
        });
    }
</script>

</body>
</html>
