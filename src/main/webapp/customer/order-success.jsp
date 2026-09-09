<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String orderId = request.getParameter("orderId");

    if (orderId == null) {
        orderId = (request.getAttribute("orderId") != null)
                ? request.getAttribute("orderId").toString()
                : "N/A";
    }

    String username = (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Order Success - ShelfBound</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700&display=swap" rel="stylesheet">
<style>
/* =====================================================
   ORDER SUCCESS PAGE - ShelfBound (Compact)
===================================================== */

:root {
    --navy-900: #0f172a;
    --navy-700: #1e3a8a;
    --navy-600: #1d4ed8;
    --accent-orange: #ff7a00;
    --success: #16a34a;
    --success-light: #dcfce7;
    --bg-main: #f8fafc;
    --bg-card: #ffffff;
    --text-primary: #1e293b;
    --text-secondary: #475569;
    --text-muted: #64748b;
    --border-light: #e2e8f0;
    --shadow-sm: 0 1px 3px rgba(0,0,0,0.06);
    --shadow-md: 0 4px 16px rgba(15,23,42,.08);
    --shadow-hover: 0 10px 24px rgba(15,23,42,.12);
    --radius-lg: 16px;
    --radius-md: 12px;
    --transition: .25s cubic-bezier(.4,0,.2,1);
}

* { margin: 0; padding: 0; box-sizing: border-box; }

body {
    font-family: 'Inter', 'Segoe UI', system-ui, sans-serif;
    background: 
        radial-gradient(1200px circle at 15% 15%, rgba(16, 185, 129, 0.08), transparent 45%),
        radial-gradient(1000px circle at 85% 20%, rgba(255, 122, 0, 0.06), transparent 45%),
        radial-gradient(900px circle at 50% 80%, rgba(30, 58, 138, 0.05), transparent 50%),
        #f8fafc;
    color: var(--text-primary);
    overflow-x: hidden;
    min-height: 100vh;
    -webkit-font-smoothing: antialiased;
}

/* ================= NAVBAR (SMOKY GLASS) ================= */
.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 14px 44px;
    background: rgba(255, 255, 255, 0.82);
    backdrop-filter: blur(20px) saturate(190%);
    -webkit-backdrop-filter: blur(20px) saturate(190%);
    border-bottom: 1px solid rgba(226, 232, 240, 0.85);
    position: sticky;
    top: 0;
    z-index: 1000;
    box-shadow: 0 4px 20px -2px rgba(15, 23, 42, 0.04), 0 0 16px rgba(255, 122, 0, 0.03);
    transition: var(--transition);
}

.logo-container {
    display: flex;
    align-items: center;
    gap: 0;
    text-decoration: none;
    transition: var(--transition);
}
.logo-container:hover { opacity: 0.95; }
.logo-img { height: 32px; width: auto; object-fit: contain; }

.logo {
    font-size: 28px;
    font-weight: 800;
    letter-spacing: -0.5px;
    display: flex;
    align-items: center;
    line-height: 1;
}
.logo-shelf { color: var(--accent-orange); }
.logo-bound { color: var(--navy-700); }

.nav-links {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 8px;
}

.nav-links a {
    text-decoration: none;
    color: var(--text-muted);
    font-weight: 600;
    font-size: 14px;
    padding: 8px 16px;
    border-radius: 999px;
    transition: var(--transition);
    border: 1px solid transparent;
}
.nav-links a:hover {
    color: var(--navy-700);
    background: rgba(30, 58, 138, 0.06);
    border-color: rgba(30, 58, 138, 0.12);
    transform: translateY(-1px);
}
.nav-links a.active {
    color: var(--navy-700);
    background: rgba(30, 58, 138, 0.09);
    border-color: rgba(30, 58, 138, 0.18);
    box-shadow: inset 0 1px 2px rgba(30, 58, 138, 0.08);
}

.welcome-user {
    color: var(--navy-700);
    font-weight: 700;
    font-size: 13px;
    padding: 8px 16px;
    background: rgba(30, 58, 138, 0.06);
    border: 1px solid rgba(30, 58, 138, 0.12);
    border-radius: 999px;
}

.btn-logout {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 42px;
    height: 42px;
    border-radius: 10px;
    background: rgba(30, 58, 138, 0.08);
    color: var(--navy-700);
    font-size: 16px;
    transition: all 0.3s ease;
    margin-left: 10px;
    vertical-align: middle;
    border: 1px solid rgba(30, 58, 138, 0.15);
}

.btn-logout:hover {
    background: #ef4444;
    border-color: #ef4444;
    color: #fff;
    transform: scale(1.08);
    box-shadow: 0 0 14px rgba(239, 68, 68, 0.4);
}

/* Profile Avatar */
.profile-avatar-link {
    display: inline-flex;
    text-decoration: none;
    padding: 0 !important;
    border: none !important;
}

.profile-avatar {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background: var(--navy-700);
    color: #ffffff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 13px;
    font-weight: 700;
    letter-spacing: 0.3px;
    box-shadow: 0 2px 8px rgba(30, 58, 138, 0.3);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
    user-select: none;
}

.profile-avatar-guest {
    background: #f1f5f9;
    font-size: 16px;
    box-shadow: none;
    border: 1.5px solid var(--border-light);
}

.profile-avatar-link:hover .profile-avatar {
    transform: scale(1.08);
    box-shadow: 0 4px 12px rgba(30, 58, 138, 0.4);
}

/* ================= MAIN WRAPPER ================= */
.success-wrapper {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: calc(100vh - 58px);
    padding: 16px;
    position: relative;
    overflow: hidden;
}

/* Floating particles */
.particles {
    position: absolute;
    top: 0; left: 0; right: 0; bottom: 0;
    pointer-events: none;
    overflow: hidden;
}

.particle {
    position: absolute;
    width: 8px;
    height: 8px;
    background: var(--accent-orange);
    border-radius: 50%;
    opacity: 0.3;
    animation: float-particle 8s infinite ease-in-out;
}

.particle:nth-child(1) { left: 10%; top: 20%; animation-delay: 0s; background: var(--success); }
.particle:nth-child(2) { left: 20%; top: 60%; animation-delay: 1s; background: var(--navy-600); }
.particle:nth-child(3) { left: 70%; top: 30%; animation-delay: 2s; background: var(--accent-orange); }
.particle:nth-child(4) { left: 80%; top: 70%; animation-delay: 3s; background: var(--success); }
.particle:nth-child(5) { left: 40%; top: 10%; animation-delay: 4s; background: var(--navy-600); }
.particle:nth-child(6) { left: 60%; top: 80%; animation-delay: 5s; background: var(--accent-orange); }
.particle:nth-child(7) { left: 30%; top: 40%; animation-delay: 6s; background: var(--success); }
.particle:nth-child(8) { left: 90%; top: 50%; animation-delay: 7s; background: var(--navy-600); }

@keyframes float-particle {
    0%, 100% { transform: translateY(0) rotate(0deg); opacity: 0.3; }
    50% { transform: translateY(-20px) rotate(180deg); opacity: 0.6; }
}

/* ================= SUCCESS CARD ================= */
.success-card {
    width: 100%;
    max-width: 480px;
    background: linear-gradient(135deg, rgba(255,255,255,0.98) 0%, rgba(254, 252, 232, 0.6) 50%, rgba(255, 247, 237, 0.4) 100%);
    padding: 28px 32px;
    text-align: center;
    border-radius: var(--radius-lg);
    box-shadow: 0 16px 48px rgba(15,23,42,0.1), 0 0 0 1px rgba(255,255,255,0.5);
    animation: card-entrance 0.8s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    z-index: 1;
    border: 1px solid var(--border-light);
}

.success-card::before {
    content: '';
    position: absolute;
    top: 0; left: 0; right: 0;
    height: 4px;
    background: linear-gradient(90deg, var(--success), #22c55e, var(--accent-orange));
    border-radius: var(--radius-lg) var(--radius-lg) 0 0;
}

@keyframes card-entrance {
    from {
        opacity: 0;
        transform: translateY(30px) scale(0.95);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

/* ================= ANIMATED CHECKMARK ================= */
.checkmark-container {
    width: 80px;
    height: 80px;
    margin: 0 auto 18px;
    position: relative;
}

.checkmark-circle {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--success), #22c55e);
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 6px 20px rgba(22, 163, 74, 0.35);
    animation: checkmark-pop 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.55) 0.3s both;
    position: relative;
}

.checkmark-circle::before {
    content: '';
    position: absolute;
    inset: -4px;
    border-radius: 50%;
    border: 2px solid var(--success);
    opacity: 0;
    animation: ripple-ring 1.5s ease-out 0.8s infinite;
}

@keyframes checkmark-pop {
    from {
        transform: scale(0);
        opacity: 0;
    }
    to {
        transform: scale(1);
        opacity: 1;
    }
}

@keyframes ripple-ring {
    0% { transform: scale(1); opacity: 0.5; }
    100% { transform: scale(1.3); opacity: 0; }
}

.checkmark-svg {
    width: 40px;
    height: 40px;
}

.checkmark-path {
    fill: none;
    stroke: white;
    stroke-width: 5;
    stroke-linecap: round;
    stroke-linejoin: round;
    stroke-dasharray: 100;
    stroke-dashoffset: 100;
    animation: draw-check 0.8s ease-out 0.8s forwards;
}

@keyframes draw-check {
    to { stroke-dashoffset: 0; }
}

/* ================= DELIVERY BOY ANIMATION ================= */
.delivery-scene {
    width: 100%;
    height: 130px;
    background: linear-gradient(180deg, transparent 0%, rgba(187, 247, 208, 0.25) 20%, rgba(219, 234, 254, 0.3) 50%, rgba(254, 243, 199, 0.25) 80%, transparent 100%);
    border: 2px dashed var(--border-light);
    margin: 18px 0;
    position: relative;
    overflow: hidden;
    border-radius: var(--radius-md);
}

.delivery-boy-wrapper {
    position: absolute;
    bottom: 8px;
    left: -200px;
    animation: delivery-ride 5s ease-out 1.2s forwards;
}

@keyframes delivery-ride {
    0% { left: -200px; transform: translateY(5px); }
    15% { left: 15%; transform: translateY(-5px); }
    30% { left: 30%; transform: translateY(5px); }
    45% { left: calc(50% - 50px); transform: translateY(0); }
    55% { left: calc(50% - 50px); transform: translateY(0); }
    70% { left: 70%; transform: translateY(-5px); }
    85% { left: 85%; transform: translateY(5px); }
    100% { left: calc(100% + 50px); transform: translateY(0); }
}

.delivery-boy {
    width: 100px;
    height: 100px;
    animation: boy-bounce 0.5s ease-in-out infinite alternate;
    transform-origin: bottom center;
}

@keyframes boy-bounce {
    from { transform: translateY(0) rotate(-2deg); }
    to { transform: translateY(-8px) rotate(2deg); }
}

.thumbs-up {
    animation: thumbs-wave 0.8s ease-in-out 3.5s 3;
    transform-origin: bottom left;
}

@keyframes thumbs-wave {
    0%, 100% { transform: rotate(0deg); }
    25% { transform: rotate(-15deg); }
    75% { transform: rotate(5deg); }
}

.road-line {
    position: absolute;
    bottom: 14px;
    left: 0;
    right: 0;
    height: 3px;
    background: #94a3b8;
    border-radius: 2px;
}

.road-line::before {
    content: '';
    position: absolute;
    top: 50%;
    left: 0;
    right: 0;
    height: 2px;
    background: repeating-linear-gradient(90deg, #e2e8f0 0px, #e2e8f0 25px, transparent 25px, transparent 45px);
    transform: translateY(-50%);
}

/* ================= LOGOUT BUTTON STYLES ================= */
.btn-logout {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 42px;
    height: 42px;
    border-radius: 10px;
    background: rgba(255, 255, 255, 0.08);
    color: #fff;
    font-size: 16px;
    transition: all 0.3s ease;
    margin-left: 10px;
    vertical-align: middle;
    border: 1px solid rgba(255, 255, 255, 0.15);
}

.btn-logout:hover {
    background: #ef4444;
    border-color: #ef4444;
    color: #fff;
    transform: scale(1.08);
    box-shadow: 0 0 14px rgba(239, 68, 68, 0.4);
}

.btn-logout svg {
    display: block;
}

/* ================= TEXT CONTENT ================= */
.success-title {
    font-family: 'Fraunces', serif;
    font-size: 26px;
    font-weight: 700;
    color: var(--text-primary);
    margin-bottom: 8px;
    animation: fade-up 0.6s ease-out 0.5s both;
}

.success-title span {
    background: linear-gradient(135deg, var(--success), #22c55e);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.success-message {
    font-size: 14px;
    color: var(--text-secondary);
    margin-bottom: 6px;
    animation: fade-up 0.6s ease-out 0.7s both;
    font-weight: 500;
}

.order-id-box {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    margin: 16px 0;
    padding: 10px 20px;
    background: linear-gradient(135deg, var(--navy-700), var(--navy-600));
    color: white;
    border-radius: var(--radius-md);
    font-size: 15px;
    font-weight: 800;
    box-shadow: 0 4px 12px rgba(30, 58, 138, 0.25);
    animation: fade-up 0.6s ease-out 0.9s both, pulse-glow 2s ease-in-out 2s infinite;
    letter-spacing: 0.5px;
}

.order-id-box .label {
    font-size: 11px;
    font-weight: 600;
    opacity: 0.8;
    text-transform: uppercase;
    letter-spacing: 1px;
}

@keyframes pulse-glow {
    0%, 100% { box-shadow: 0 4px 12px rgba(30, 58, 138, 0.25); }
    50% { box-shadow: 0 4px 24px rgba(30, 58, 138, 0.4); }
}

.processing-text {
    font-size: 12px;
    color: var(--text-muted);
    margin-bottom: 20px;
    animation: fade-up 0.6s ease-out 1.1s both;
    font-weight: 500;
}

.processing-text::before {
    content: '';
    display: inline-block;
    width: 6px;
    height: 6px;
    background: var(--success);
    border-radius: 50%;
    margin-right: 6px;
    animation: blink 1.5s infinite;
}

@keyframes blink {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.3; }
}

/* ================= ACTION BUTTONS ================= */
.actions {
    display: flex;
    justify-content: center;
    gap: 12px;
    flex-wrap: wrap;
    animation: fade-up 0.6s ease-out 1.3s both;
}

.btn {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 10px 20px;
    text-decoration: none;
    border-radius: var(--radius-lg);
    font-weight: 700;
    font-size: 13px;
    transition: var(--transition);
    border: none;
    cursor: pointer;
    font-family: inherit;
    letter-spacing: 0.3px;
}

.btn-home {
    background: linear-gradient(135deg, var(--navy-700), var(--navy-600));
    color: white;
    box-shadow: 0 4px 12px rgba(30, 58, 138, 0.25);
}

.btn-home:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 18px rgba(30, 58, 138, 0.35);
    background: linear-gradient(135deg, #1e3a8a, #1e40af);
}

.btn-orders {
    background: linear-gradient(135deg, var(--accent-orange), #ff5500);
    color: white;
    box-shadow: 0 4px 12px rgba(255, 122, 0, 0.25);
}

.btn-orders:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 18px rgba(255, 122, 0, 0.35);
}

/* ================= CONFETTI ================= */
.confetti-container {
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    pointer-events: none;
    z-index: 100;
    overflow: hidden;
}

.confetti {
    position: absolute;
    width: 8px;
    height: 8px;
    top: -10px;
    animation: confetti-fall 4s ease-out forwards;
}

.confetti:nth-child(1) { left: 10%; background: var(--success); animation-delay: 0s; transform: rotate(45deg); }
.confetti:nth-child(2) { left: 20%; background: var(--accent-orange); animation-delay: 0.2s; width: 6px; height: 6px; }
.confetti:nth-child(3) { left: 30%; background: var(--navy-600); animation-delay: 0.4s; transform: rotate(20deg); }
.confetti:nth-child(4) { left: 40%; background: #22c55e; animation-delay: 0.1s; width: 10px; height: 5px; }
.confetti:nth-child(5) { left: 50%; background: var(--accent-orange); animation-delay: 0.3s; }
.confetti:nth-child(6) { left: 60%; background: var(--success); animation-delay: 0.5s; width: 5px; height: 10px; }
.confetti:nth-child(7) { left: 70%; background: var(--navy-600); animation-delay: 0.15s; }
.confetti:nth-child(8) { left: 80%; background: #22c55e; animation-delay: 0.35s; width: 8px; height: 8px; }
.confetti:nth-child(9) { left: 90%; background: var(--accent-orange); animation-delay: 0.25s; }
.confetti:nth-child(10) { left: 15%; background: var(--success); animation-delay: 0.45s; width: 6px; height: 6px; }

@keyframes confetti-fall {
    0% { top: -10px; transform: rotate(0deg) translateX(0); opacity: 1; }
    100% { top: 100vh; transform: rotate(720deg) translateX(100px); opacity: 0; }
}

/* ================= ANIMATIONS ================= */
@keyframes fade-up {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* ================= RESPONSIVE ================= */
@media (max-width: 768px) {
    .navbar { padding: 10px 16px; }
    .success-card { padding: 22px 20px; margin: 0 10px; max-width: 420px; }
    .success-title { font-size: 22px; }
    .checkmark-container { width: 70px; height: 70px; }
    .checkmark-circle { width: 70px; height: 70px; }
    .checkmark-svg { width: 35px; height: 35px; }
    .delivery-boy { width: 80px; height: 80px; }
    .delivery-scene { height: 110px; }
    .actions { flex-direction: column; }
    .btn { width: 100%; justify-content: center; }
}

@media (max-width: 480px) {
    .success-title { font-size: 20px; }
    .order-id-box { font-size: 14px; padding: 8px 16px; }
    .success-card { padding: 18px 16px; }
}
</style>
</head>

<body>

<!-- Confetti Burst -->
<div class="confetti-container">
    <div class="confetti"></div>
    <div class="confetti"></div>
    <div class="confetti"></div>
    <div class="confetti"></div>
    <div class="confetti"></div>
    <div class="confetti"></div>
    <div class="confetti"></div>
    <div class="confetti"></div>
    <div class="confetti"></div>
    <div class="confetti"></div>
</div>

<!-- ================= NAVBAR ================= -->
<div class="navbar">
    <a href="<%= request.getContextPath() %>/home" class="logo-container">
        <img src="<%= request.getContextPath() %>/assets/images/logo.png" alt="ShelfBound Logo" class="logo-img">
        <div class="logo">
            <span class="logo-shelf">Shelf</span>
            <span class="logo-bound">Bound</span>
        </div>
    </a>

    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/home">Home</a>
        <a href="<%= request.getContextPath() %>/books">Books</a>
        <a href="<%= request.getContextPath() %>/cart">Cart</a>
        <a href="<%= request.getContextPath() %>/orders">Orders</a>

        <a href="<%= request.getContextPath() %>/profile" class="profile-avatar-link" title="<%= username != null ? username : "Profile" %>">
            <%
                if (username != null && !username.trim().isEmpty()) {
                    String initials = username.trim().length() >= 2
                            ? username.trim().substring(0, 2).toUpperCase()
                            : username.trim().substring(0, 1).toUpperCase();
            %>
            <div class="profile-avatar"><%= initials %></div>
            <%
                } else {
            %>
            <div class="profile-avatar profile-avatar-guest">&#128100;</div>
            <%
                }
            %>
        </a>

        <%
            if (username == null) {
        %>
            <a href="<%= request.getContextPath() %>/login">Login</a>
         <!-- ================= LOGOUT BUTTON START ================= -->
        <%
            } else {
        %>
            <span class="welcome-user">Welcome, <%= username %></span>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout" title="Logout">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 2v10"></path>
                    <path d="M18.36 6.64a9 9 0 1 1-12.72 0"></path>
                </svg>
            </a>
        <%
            }
        %>
        <!-- ================= LOGOUT BUTTON END ================= -->
        <a href="<%= request.getContextPath() %>/adminLogin">Admin</a>
    </div>
</div>

<!-- ================= MAIN CONTENT ================= -->
<div class="success-wrapper">

    <!-- Floating Particles -->
    <div class="particles">
        <div class="particle"></div>
        <div class="particle"></div>
        <div class="particle"></div>
        <div class="particle"></div>
        <div class="particle"></div>
        <div class="particle"></div>
        <div class="particle"></div>
        <div class="particle"></div>
    </div>

    <div class="success-card">

        <!-- Animated Checkmark -->
        <div class="checkmark-container">
            <div class="checkmark-circle">
                <svg class="checkmark-svg" viewBox="0 0 52 52">
                    <path class="checkmark-path" d="M14 27 L22 35 L38 16"/>
                </svg>
            </div>
        </div>

        <!-- Delivery Boy Animation -->
        <div class="delivery-scene">
            <div class="road-line"></div>
            <div class="delivery-boy-wrapper">
                <svg class="delivery-boy" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
                    <!-- Scooter body -->
                    <ellipse cx="50" cy="78" rx="35" ry="12" fill="#64748b"/>
                    <ellipse cx="50" cy="75" rx="32" ry="10" fill="#94a3b8"/>

                    <!-- Back wheel -->
                    <circle cx="25" cy="78" r="10" fill="#1e293b"/>
                    <circle cx="25" cy="78" r="6" fill="#cbd5e1"/>

                    <!-- Front wheel -->
                    <circle cx="75" cy="78" r="10" fill="#1e293b"/>
                    <circle cx="75" cy="78" r="6" fill="#cbd5e1"/>

                    <!-- Scooter deck -->
                    <rect x="20" y="68" width="60" height="8" rx="4" fill="#f97316"/>
                    <rect x="20" y="68" width="60" height="4" rx="2" fill="#fb923c"/>

                    <!-- Delivery box -->
                    <rect x="15" y="42" width="30" height="28" rx="4" fill="#1e3a8a"/>
                    <rect x="18" y="45" width="24" height="8" rx="2" fill="#1d4ed8"/>
                    <text x="30" y="52" text-anchor="middle" fill="white" font-size="6" font-weight="bold">SB</text>

                    <!-- Person body -->
                    <ellipse cx="58" cy="55" rx="14" ry="16" fill="#1e3a8a"/>

                    <!-- Person head -->
                    <circle cx="58" cy="38" r="12" fill="#fbbf24"/>

                    <!-- Helmet -->
                    <path d="M44 35 Q58 18 72 35" fill="#ef4444"/>
                    <rect x="42" y="33" width="32" height="6" rx="3" fill="#dc2626"/>

                    <!-- Face -->
                    <circle cx="54" cy="38" r="1.5" fill="#1e293b"/>
                    <circle cx="62" cy="38" r="1.5" fill="#1e293b"/>
                    <path d="M54 42 Q58 46 62 42" fill="none" stroke="#1e293b" stroke-width="1.5" stroke-linecap="round"/>

                    <!-- Arm with thumbs up -->
                    <g class="thumbs-up">
                        <!-- Arm -->
                        <path d="M68 50 Q78 45 82 38" fill="none" stroke="#fbbf24" stroke-width="6" stroke-linecap="round"/>
                        <!-- Hand -->
                        <circle cx="82" cy="36" r="7" fill="#fbbf24"/>
                        <!-- Thumb -->
                        <rect x="80" y="26" width="5" height="10" rx="2.5" fill="#fbbf24"/>
                        <rect x="79" y="24" width="7" height="5" rx="2.5" fill="#fbbf24"/>
                    </g>

                    <!-- Other hand on handle -->
                    <circle cx="72" cy="52" r="5" fill="#fbbf24"/>

                    <!-- Handlebar -->
                    <line x1="68" y1="50" x2="78" y2="48" stroke="#64748b" stroke-width="3" stroke-linecap="round"/>
                    <line x1="76" y1="46" x2="80" y2="46" stroke="#64748b" stroke-width="3" stroke-linecap="round"/>
                </svg>
            </div>
        </div>

        <h1 class="success-title">Order Placed <span>Successfully!</span></h1>

        <p class="success-message">
            Thank you for shopping with ShelfBound. Your books are on their way!
        </p>

        <div class="order-id-box">
            <span class="label">Order ID</span>
            <span>#<%= orderId %></span>
        </div>

        <p class="processing-text">
            Your order is being processed and will be delivered soon.
        </p>

        <div class="actions">
            <a class="btn btn-home" href="<%= request.getContextPath() %>/home">
                <span>&#127968;</span> Continue Shopping
            </a>
            <a class="btn btn-orders" href="<%= request.getContextPath() %>/orders">
                <span>&#128230;</span> View My Orders
            </a>
        </div>

    </div>
</div>

</body>
</html>