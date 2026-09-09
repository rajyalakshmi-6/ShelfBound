<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.shelfbound.model.Order" %>
<%@ page import="com.shelfbound.model.OrderItem" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.temporal.ChronoUnit" %>

<%
    Order order = (Order) request.getAttribute("order");
    String username = (String) session.getAttribute("username");
    NumberFormat currency = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));

    // Calculate estimated delivery date (5-7 days from order date)
    String deliveryEstimate = "";
    try {
        LocalDateTime orderDate = LocalDateTime.parse(order.getOrderDate(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        LocalDateTime estDelivery = orderDate.plusDays(5);
        LocalDateTime estDeliveryMax = orderDate.plusDays(7);
        deliveryEstimate = estDelivery.format(DateTimeFormatter.ofPattern("dd MMM")) + " - " + estDeliveryMax.format(DateTimeFormatter.ofPattern("dd MMM, yyyy"));
    } catch (Exception e) {
        deliveryEstimate = "5-7 business days";
    }

    // Status progress mapping
    String status = order.getStatus().toLowerCase();
    int progressStep = 0;
    switch(status) {
        case "pending": progressStep = 1; break;
        case "confirmed": progressStep = 2; break;
        case "shipped": progressStep = 3; break;
        case "out for delivery": progressStep = 4; break;
        case "delivered": progressStep = 5; break;
        case "completed": progressStep = 5; break;
        case "cancelled": progressStep = -1; break;
    }

    // Determine if order can be cancelled
    boolean canCancel = !status.equals("cancelled") && !status.equals("delivered") 
                        && !status.equals("completed") && !status.equals("shipped") 
                        && !status.equals("out for delivery") && !status.equals("returned");

    // Determine if order can be returned (only delivered/completed)
    boolean canReturn = (status.equals("delivered") || status.equals("completed"));

    // Flash message params from OrderActionServlet redirect
    String cancelledParam = request.getParameter("cancelled");
    String returnedParam = request.getParameter("returned");
    String errorParam = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Order #<%= order.getOrderId() %> — ShelfBound</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

<style>

:root {
    --primary-blue: #1e3a8a;
    --primary-blue-light: #2563eb;
    --accent-orange: #ff7a00;
    --accent-orange-light: #ff9500;
    --bg-white: #ffffff;
    --bg-light: #f8fafc;
    --bg-gradient-start: #dff6ff;
    --bg-gradient-end: #a8d8ff;
    --text-dark: #1e293b;
    --text-medium: #475569;
    --text-muted: #64748b;
    --text-light: #94a3b8;
    --border-light: #e2e8f0;
    --border-lighter: #f1f5f9;
    --success: #10b981;
    --success-light: #d1fae5;
    --warning: #f59e0b;
    --warning-light: #fef3c7;
    --danger: #ef4444;
    --danger-light: #fee2e2;
    --info: #3b82f6;
    --info-light: #dbeafe;
    --shadow-sm: 0 1px 2px rgba(0,0,0,0.04);
    --shadow-md: 0 4px 12px rgba(0,0,0,0.06);
    --shadow-lg: 0 12px 40px rgba(0,0,0,0.1);
    --shadow-xl: 0 20px 60px rgba(0,0,0,0.12);
    --radius-sm: 8px;
    --radius-md: 12px;
    --radius-lg: 16px;
    --radius-xl: 20px;
    --radius-full: 9999px;
}

* { box-sizing: border-box; margin: 0; padding: 0; }

html { scroll-behavior: smooth; }

body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    background: 
        radial-gradient(1200px circle at 10% 10%, rgba(30, 58, 138, 0.06), transparent 40%),
        radial-gradient(1000px circle at 90% 20%, rgba(255, 122, 0, 0.05), transparent 40%),
        radial-gradient(800px circle at 50% 80%, rgba(30, 58, 138, 0.04), transparent 50%),
        #f8fafc;
    min-height: 100vh;
    color: var(--text-dark);
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

/* ═══════════════════════════════════════════════════════════════
   NAVBAR (SMOKY GLASS)
   ═══════════════════════════════════════════════════════════════ */
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
    transition: all 0.28s cubic-bezier(0.4, 0, 0.2, 1);
}

.logo-container {
    display: flex;
    align-items: center;
    gap: 0;
    text-decoration: none;
    transition: all 0.28s cubic-bezier(0.4, 0, 0.2, 1);
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
.logo-bound { color: var(--primary-blue); }

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
    transition: all 0.28s cubic-bezier(0.4, 0, 0.2, 1);
    border: 1px solid transparent;
}
.nav-links a:hover {
    color: var(--primary-blue);
    background: rgba(30, 58, 138, 0.06);
    border-color: rgba(30, 58, 138, 0.12);
    transform: translateY(-1px);
}
.nav-links a.active {
    color: var(--primary-blue);
    background: rgba(30, 58, 138, 0.09);
    border-color: rgba(30, 58, 138, 0.18);
    box-shadow: inset 0 1px 2px rgba(30, 58, 138, 0.08);
}

.welcome-user {
    color: var(--primary-blue);
    font-weight: 700;
    font-size: 13px;
    padding: 8px 16px;
    background: rgba(30, 58, 138, 0.06);
    border: 1px solid rgba(30, 58, 138, 0.12);
    border-radius: 999px;
}

/* ================= LOGOUT BUTTON STYLES ================= */
.btn-logout {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 42px;
    height: 42px;
    border-radius: 10px;
    background: rgba(30, 58, 138, 0.08);
    color: var(--primary-blue);
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

.btn-logout svg {
    display: block;
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
    background: var(--primary-blue);
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

/* ═══════════════════════════════════════════════════════════════
   PAGE WRAPPER
   ═══════════════════════════════════════════════════════════════ */
.page-wrapper {
    max-width: 1000px;
    margin: 0 auto;
    padding: 32px 24px 80px;
}

/* ═══════════════════════════════════════════════════════════════
   BREADCRUMB
   ═══════════════════════════════════════════════════════════════ */
.breadcrumb {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 24px;
    font-size: 13px;
    color: var(--text-muted);
}

.breadcrumb a {
    color: var(--text-muted);
    text-decoration: none;
    font-weight: 500;
    transition: color 0.2s;
}

.breadcrumb a:hover { color: var(--primary-blue); }

.breadcrumb-separator {
    color: var(--text-light);
    font-size: 11px;
}

.breadcrumb-current {
    color: var(--text-dark);
    font-weight: 600;
}

/* ═══════════════════════════════════════════════════════════════
   BACK BUTTON
   ═══════════════════════════════════════════════════════════════ */
.back-btn {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    text-decoration: none;
    color: var(--primary-blue);
    font-size: 13.5px;
    font-weight: 600;
    padding: 10px 18px;
    border: 1px solid rgba(226, 232, 240, 0.9);
    border-radius: var(--radius-md);
    background: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(8px);
    margin-bottom: 28px;
    transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.back-btn:hover {
    background: #ffffff;
    border-color: var(--accent-orange);
    color: var(--accent-orange);
    transform: translateX(-3px);
    box-shadow: 0 4px 14px rgba(0, 0, 0, 0.08);
}

.back-btn svg {
    width: 18px;
    height: 18px;
    transition: transform 0.3s;
}

.back-btn:hover svg { transform: translateX(-3px); }

/* ═══════════════════════════════════════════════════════════════
   ORDER HEADER CARD
   ═══════════════════════════════════════════════════════════════ */
.order-header-card {
    background: linear-gradient(135deg, var(--primary-blue) 0%, var(--primary-blue-light) 50%, #4f8ef7 100%);
    border-radius: var(--radius-xl);
    padding: 32px;
    margin-bottom: 24px;
    box-shadow: var(--shadow-lg), 0 0 0 1px rgba(255,255,255,0.1) inset;
    position: relative;
    overflow: hidden;
}

.order-header-card::before {
    content: '';
    position: absolute;
    top: -50%;
    right: -10%;
    width: 300px;
    height: 300px;
    background: radial-gradient(circle, rgba(255,255,255,0.08) 0%, transparent 70%);
    border-radius: 50%;
}

.order-header-card::after {
    content: '';
    position: absolute;
    bottom: -30%;
    left: -5%;
    width: 200px;
    height: 200px;
    background: radial-gradient(circle, rgba(255,122,0,0.1) 0%, transparent 70%);
    border-radius: 50%;
}

.order-header-top {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    flex-wrap: wrap;
    gap: 16px;
    position: relative;
    z-index: 1;
}

.order-title-section h1 {
    color: #ffffff;
    font-size: 28px;
    font-weight: 800;
    margin-bottom: 6px;
    letter-spacing: -0.5px;
}

.order-meta-row {
    display: flex;
    align-items: center;
    gap: 16px;
    flex-wrap: wrap;
}

.order-date {
    color: rgba(255,255,255,0.75);
    font-size: 14px;
    font-weight: 500;
    display: flex;
    align-items: center;
    gap: 6px;
}

.order-date svg {
    width: 16px;
    height: 16px;
    opacity: 0.8;
}

/* Status Badge */
.status-badge {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 13px;
    font-weight: 700;
    padding: 8px 18px;
    border-radius: var(--radius-full);
    text-transform: capitalize;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    position: relative;
    z-index: 1;
}

.status-badge::before {
    content: '';
    width: 8px;
    height: 8px;
    border-radius: 50%;
    animation: pulse 2s infinite;
}

@keyframes pulse {
    0%, 100% { opacity: 1; transform: scale(1); }
    50% { opacity: 0.6; transform: scale(1.2); }
}

.status-badge.pending   { background: var(--warning-light); color: #b45309; }
.status-badge.pending::before   { background: var(--warning); }
.status-badge.confirmed { background: var(--info-light); color: #1d4ed8; }
.status-badge.confirmed::before { background: var(--info); }
.status-badge.shipped   { background: #e0e7ff; color: #3730a3; }
.status-badge.shipped::before   { background: #6366f1; }
.status-badge.out-for-delivery { background: #ede9fe; color: #6d28d9; }
.status-badge.out-for-delivery::before { background: #8b5cf6; }
.status-badge.delivered { background: var(--success-light); color: #047857; }
.status-badge.delivered::before { background: var(--success); }
.status-badge.completed { background: var(--success-light); color: #047857; }
.status-badge.completed::before { background: var(--success); }
.status-badge.returned {
    background: linear-gradient(135deg, #fefce8, #fef9c3);
    color: #854d0e;
}
.status-badge.returned::before {
    background: #eab308;
    animation: pulse 2s infinite;
}

.status-badge.cancelled { background: var(--danger-light); color: #b91c1c; }
.status-badge.cancelled::before { background: var(--danger); }

/* ═══════════════════════════════════════════════════════════════
   ORDER TIMELINE / PROGRESS TRACKER
   ═══════════════════════════════════════════════════════════════ */
.timeline-section {
    background: var(--bg-white);
    border-radius: var(--radius-xl);
    padding: 28px 32px;
    margin-bottom: 24px;
    box-shadow: var(--shadow-md);
    border: 1px solid var(--border-lighter);
}

.timeline-title {
    font-size: 14px;
    font-weight: 700;
    color: var(--text-dark);
    margin-bottom: 24px;
    display: flex;
    align-items: center;
    gap: 8px;
}

.timeline-title svg {
    width: 18px;
    height: 18px;
    color: var(--primary-blue);
}

.timeline-tracker {
    display: flex;
    justify-content: space-between;
    position: relative;
    padding: 0 10px;
}

.timeline-tracker::before {
    content: '';
    position: absolute;
    top: 14px;
    left: 30px;
    right: 30px;
    height: 3px;
    background: var(--border-light);
    border-radius: 2px;
    z-index: 0;
}

.timeline-progress-bar {
    position: absolute;
    top: 14px;
    left: 30px;
    height: 3px;
    background: linear-gradient(90deg, var(--success), var(--primary-blue-light));
    border-radius: 2px;
    z-index: 1;
    transition: width 1s cubic-bezier(0.4, 0, 0.2, 1);
}

.timeline-step {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    position: relative;
    z-index: 2;
    flex: 1;
}

.step-dot {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    font-weight: 700;
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    border: 3px solid var(--border-light);
    background: var(--bg-white);
    color: var(--text-light);
}

.step-dot.completed {
    background: linear-gradient(135deg, var(--success), #059669);
    border-color: var(--success);
    color: #ffffff;
    box-shadow: 0 2px 8px rgba(16, 185, 129, 0.3);
}

.step-dot.active {
    background: linear-gradient(135deg, var(--primary-blue), var(--primary-blue-light));
    border-color: var(--primary-blue);
    color: #ffffff;
    box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.2), 0 2px 8px rgba(37, 99, 235, 0.3);
    animation: stepPulse 2s infinite;
}

@keyframes stepPulse {
    0%, 100% { box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.2), 0 2px 8px rgba(37, 99, 235, 0.3); }
    50% { box-shadow: 0 0 0 8px rgba(37, 99, 235, 0.1), 0 2px 12px rgba(37, 99, 235, 0.4); }
}

.step-label {
    font-size: 11px;
    font-weight: 600;
    color: var(--text-light);
    text-align: center;
    max-width: 80px;
    line-height: 1.3;
}

.step-label.completed { color: var(--success); }
.step-label.active { color: var(--primary-blue); font-weight: 700; }

/* Cancelled state */
.timeline-tracker.cancelled::before { background: var(--danger-light); }
.timeline-tracker.cancelled .timeline-progress-bar { display: none; }

.cancelled-notice {
    background: linear-gradient(135deg, var(--danger-light), #fef2f2);
    border: 1px solid #fecaca;
    border-radius: var(--radius-md);
    padding: 16px 20px;
    display: flex;
    align-items: center;
    gap: 12px;
    margin-top: 20px;
}

.cancelled-notice svg {
    width: 24px;
    height: 24px;
    color: var(--danger);
    flex-shrink: 0;
}

.cancelled-notice-text {
    font-size: 14px;
    color: #991b1b;
    font-weight: 500;
}

/* ═══════════════════════════════════════════════════════════════
   MAIN GRID LAYOUT
   ═══════════════════════════════════════════════════════════════ */
.main-grid {
    display: grid;
    grid-template-columns: 1fr 340px;
    gap: 24px;
    margin-bottom: 24px;
}

@media (max-width: 900px) {
    .main-grid { grid-template-columns: 1fr; }
}

/* ═══════════════════════════════════════════════════════════════
   CARDS
   ═══════════════════════════════════════════════════════════════ */
.card {
    background: var(--bg-white);
    border-radius: var(--radius-xl);
    box-shadow: var(--shadow-md);
    border: 1px solid var(--border-lighter);
    overflow: hidden;
    transition: box-shadow 0.3s ease;
}

.card:hover { box-shadow: var(--shadow-lg); }

.card-header {
    padding: 20px 24px;
    border-bottom: 1px solid var(--border-lighter);
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.card-title {
    font-size: 15px;
    font-weight: 700;
    color: var(--text-dark);
    display: flex;
    align-items: center;
    gap: 10px;
}

.card-title-icon {
    width: 32px;
    height: 32px;
    border-radius: var(--radius-md);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
}

.card-body { padding: 20px 24px; }

/* ═══════════════════════════════════════════════════════════════
   INFO BLOCKS
   ═══════════════════════════════════════════════════════════════ */
.info-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
}

.info-item {
    padding: 12px 0;
    border-bottom: 1px solid var(--border-lighter);
}

.info-item:last-child { border-bottom: none; }

.info-label {
    font-size: 11px;
    font-weight: 600;
    color: var(--text-light);
    text-transform: uppercase;
    letter-spacing: 0.08em;
    margin-bottom: 4px;
}

.info-value {
    font-size: 14px;
    font-weight: 600;
    color: var(--text-dark);
    line-height: 1.5;
}

.info-value.highlight {
    color: var(--primary-blue);
    font-weight: 700;
}

/* Address Box */
.address-box {
    background: linear-gradient(135deg, #f8fafc, #f1f5f9);
    border: 1px solid var(--border-light);
    border-radius: var(--radius-md);
    padding: 16px;
    font-size: 14px;
    color: var(--text-medium);
    line-height: 1.8;
    position: relative;
}

.address-box::before {
    content: '📍';
    position: absolute;
    top: 12px;
    right: 12px;
    font-size: 20px;
    opacity: 0.3;
}

/* ═══════════════════════════════════════════════════════════════
   ORDER ITEMS
   ═══════════════════════════════════════════════════════════════ */
.items-list {
    display: flex;
    flex-direction: column;
    gap: 0;
}

.order-item {
    display: flex;
    align-items: center;
    gap: 18px;
    padding: 18px 0;
    border-bottom: 1px solid var(--border-lighter);
    transition: background 0.2s;
    position: relative;
}

.order-item:last-child { border-bottom: none; }

.order-item:hover {
    background: linear-gradient(90deg, transparent, rgba(30,58,138,0.02), transparent);
}

.item-image-wrapper {
    position: relative;
    flex-shrink: 0;
}

.item-image-wrapper img {
    width: 72px;
    height: 96px;
    object-fit: cover;
    border-radius: var(--radius-md);
    background: linear-gradient(135deg, #f1f5f9, #e2e8f0);
    border: 1px solid var(--border-light);
    box-shadow: var(--shadow-sm);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.order-item:hover .item-image-wrapper img {
    transform: scale(1.05);
    box-shadow: var(--shadow-md);
}

.item-qty-badge {
    position: absolute;
    bottom: -6px;
    right: -6px;
    background: linear-gradient(135deg, var(--primary-blue), var(--primary-blue-light));
    color: #ffffff;
    font-size: 11px;
    font-weight: 700;
    width: 24px;
    height: 24px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 2px solid var(--bg-white);
    box-shadow: var(--shadow-sm);
}

.item-info { flex: 1; min-width: 0; }

.item-title {
    font-size: 15px;
    font-weight: 600;
    color: var(--text-dark);
    margin-bottom: 6px;
    line-height: 1.4;
    transition: color 0.2s;
}

.order-item:hover .item-title { color: var(--primary-blue); }

.item-meta-row {
    display: flex;
    align-items: center;
    gap: 12px;
    flex-wrap: wrap;
}

.meta-chip {
    font-size: 12px;
    font-weight: 500;
    background: var(--bg-light);
    color: var(--text-muted);
    padding: 4px 12px;
    border-radius: var(--radius-full);
    border: 1px solid var(--border-light);
}

.item-subtotal {
    font-size: 16px;
    font-weight: 800;
    color: var(--primary-blue);
    white-space: nowrap;
    text-align: right;
}

.item-subtotal-label {
    font-size: 11px;
    color: var(--text-light);
    font-weight: 500;
    margin-bottom: 2px;
    text-align: right;
}

/* ═══════════════════════════════════════════════════════════════
   ORDER SUMMARY (RIGHT SIDEBAR)
   ═══════════════════════════════════════════════════════════════ */
.summary-card {
    position: sticky;
    top: 80px;
}

.summary-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 0;
    font-size: 14px;
}

.summary-row:not(:last-child) {
    border-bottom: 1px dashed var(--border-light);
}

.summary-label {
    color: var(--text-muted);
    font-weight: 500;
}

.summary-value {
    color: var(--text-dark);
    font-weight: 600;
}

.summary-divider {
    height: 1px;
    background: linear-gradient(90deg, transparent, var(--border-light), transparent);
    margin: 12px 0;
}

.summary-total {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px 0 8px;
}

.total-label-main {
    font-size: 15px;
    font-weight: 700;
    color: var(--text-dark);
}

.total-amount-main {
    font-size: 24px;
    font-weight: 900;
    color: var(--primary-blue);
    letter-spacing: -0.5px;
}

.total-savings {
    font-size: 12px;
    color: var(--success);
    font-weight: 600;
    margin-top: 4px;
    display: flex;
    align-items: center;
    gap: 4px;
}

/* ═══════════════════════════════════════════════════════════════
   ACTION BUTTONS
   ═══════════════════════════════════════════════════════════════ */
.action-buttons {
    display: flex;
    flex-direction: column;
    gap: 10px;
    margin-top: 20px;
}

.btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 12px 20px;
    border-radius: var(--radius-md);
    font-size: 14px;
    font-weight: 600;
    text-decoration: none;
    border: none;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    width: 100%;
}

.btn-primary {
    background: linear-gradient(135deg, var(--primary-blue), var(--primary-blue-light));
    color: #ffffff;
    box-shadow: 0 4px 12px rgba(30, 58, 138, 0.25);
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(30, 58, 138, 0.35);
}

.btn-secondary {
    background: var(--bg-white);
    color: var(--primary-blue);
    border: 1.5px solid #bfdbfe;
}

.btn-secondary:hover {
    background: #eff6ff;
    border-color: #93c5fd;
    transform: translateY(-2px);
}

.btn-outline {
    background: transparent;
    color: var(--text-muted);
    border: 1.5px solid var(--border-light);
}

.btn-outline:hover {
    background: var(--bg-light);
    color: var(--text-dark);
    border-color: var(--text-light);
}

.btn svg {
    width: 18px;
    height: 18px;
}

.btn-return {
    background: linear-gradient(135deg, #fefce8, #fef9c3);  /* light yellow */
    color: #854d0e;                                          /* dark amber text */
    border: 1.5px solid #fde047;                             /* yellow border */
    box-shadow: 0 2px 8px rgba(202, 138, 4, 0.1);
}
.btn-return:hover {
    background: linear-gradient(135deg, #fef9c3, #fde047);
    border-color: #eab308;
    color: #713f12;
    transform: translateY(-2px);
    box-shadow: 0 4px 14px rgba(202, 138, 4, 0.2);
}

.btn-cancel {
    background: linear-gradient(135deg, #fef2f2, #fee2e2);  /* light pink-red */
    color: #b91c1c;                                          /* dark red text */
    border: 1.5px solid #fecaca;                             /* soft red border */
    box-shadow: 0 2px 8px rgba(185, 28, 28, 0.1);
}
.btn-cancel:hover {
    background: linear-gradient(135deg, #fee2e2, #fecaca);
    border-color: #f87171;
    color: #991b1b;
    transform: translateY(-2px);
    box-shadow: 0 4px 14px rgba(185, 28, 28, 0.2);
}

/* ═══════════════════════════════════════════════════════════════
   DELIVERY ESTIMATE CARD
   ═══════════════════════════════════════════════════════════════ */
.delivery-card {
    background: linear-gradient(135deg, #ecfdf5, #d1fae5);
    border: 1px solid #a7f3d0;
    border-radius: var(--radius-lg);
    padding: 16px 20px;
    margin-top: 16px;
    display: flex;
    align-items: center;
    gap: 14px;
}

.delivery-card svg {
    width: 28px;
    height: 28px;
    color: var(--success);
    flex-shrink: 0;
}

.delivery-info h4 {
    font-size: 13px;
    font-weight: 700;
    color: #065f46;
    margin-bottom: 2px;
}

.delivery-info p {
    font-size: 13px;
    color: #047857;
    font-weight: 500;
}

/* ═══════════════════════════════════════════════════════════════
   PAYMENT METHOD
   ═══════════════════════════════════════════════════════════════ */
.payment-method {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 0;
}

.payment-icon {
    width: 40px;
    height: 26px;
    background: linear-gradient(135deg, #1e3a8a, #2563eb);
    border-radius: 4px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #ffffff;
    font-size: 10px;
    font-weight: 700;
    letter-spacing: 1px;
}

.payment-details {
    flex: 1;
}

.payment-name {
    font-size: 14px;
    font-weight: 600;
    color: var(--text-dark);
}

.payment-status {
    font-size: 12px;
    color: var(--success);
    font-weight: 500;
    display: flex;
    align-items: center;
    gap: 4px;
}

/* ═══════════════════════════════════════════════════════════════
   TRACKING SECTION
   ═══════════════════════════════════════════════════════════════ */
.tracking-section {
    background: linear-gradient(135deg, #eff6ff, #dbeafe);
    border: 1px solid #bfdbfe;
    border-radius: var(--radius-lg);
    padding: 16px 20px;
    margin-top: 16px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
}

.tracking-info h4 {
    font-size: 13px;
    font-weight: 700;
    color: var(--primary-blue);
    margin-bottom: 2px;
}

.tracking-info p {
    font-size: 12px;
    color: var(--primary-blue-light);
    font-weight: 500;
    font-family: 'Courier New', monospace;
    letter-spacing: 0.5px;
}

/* ═══════════════════════════════════════════════════════════════
   HELP SECTION
   ═══════════════════════════════════════════════════════════════ */
.help-section {
    background: var(--bg-white);
    border-radius: var(--radius-xl);
    box-shadow: var(--shadow-md);
    border: 1px solid var(--border-lighter);
    padding: 24px;
    margin-top: 24px;
    text-align: center;
}

.help-title {
    font-size: 16px;
    font-weight: 700;
    color: var(--text-dark);
    margin-bottom: 8px;
}

.help-text {
    font-size: 14px;
    color: var(--text-muted);
    margin-bottom: 16px;
    line-height: 1.6;
}

.help-buttons {
    display: flex;
    gap: 12px;
    justify-content: center;
    flex-wrap: wrap;
}

.help-btn {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 10px 20px;
    border-radius: var(--radius-md);
    font-size: 13px;
    font-weight: 600;
    text-decoration: none;
    transition: all 0.25s;
}

.help-btn-chat {
    background: linear-gradient(135deg, var(--primary-blue), var(--primary-blue-light));
    color: #ffffff;
    box-shadow: 0 2px 8px rgba(30, 58, 138, 0.2);
}

.help-btn-chat:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(30, 58, 138, 0.3);
}

.help-btn-email {
    background: var(--bg-light);
    color: var(--text-dark);
    border: 1px solid var(--border-light);
}

.help-btn-email:hover {
    background: var(--border-lighter);
    border-color: var(--border-light);
}

/* ═══════════════════════════════════════════════════════════════
   ANIMATIONS
   ═══════════════════════════════════════════════════════════════ */
@keyframes fadeInUp {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}

.animate-in {
    animation: fadeInUp 0.6s cubic-bezier(0.4, 0, 0.2, 1) forwards;
    opacity: 0;
}

.delay-1 { animation-delay: 0.1s; }
.delay-2 { animation-delay: 0.2s; }
.delay-3 { animation-delay: 0.3s; }
.delay-4 { animation-delay: 0.4s; }

/* ═══════════════════════════════════════════════════════════════
   FLASH MESSAGES
   ═══════════════════════════════════════════════════════════════ */
.flash-message {
    padding: 16px 24px;
    border-radius: var(--radius-lg);
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 14px;
    font-weight: 600;
    animation: fadeInUp 0.4s ease;
    box-shadow: var(--shadow-md);
}

.flash-success {
    background: linear-gradient(135deg, #ecfdf5, #d1fae5);
    border: 1px solid #a7f3d0;
    color: #065f46;
}

.flash-error {
    background: linear-gradient(135deg, #fef2f2, #fee2e2);
    border: 1px solid #fecaca;
    color: #991b1b;
}

.flash-message svg {
    width: 20px;
    height: 20px;
    flex-shrink: 0;
}

/* ═══════════════════════════════════════════════════════════════
   RETURN POLICY CARD
   ═══════════════════════════════════════════════════════════════ */
.return-policy-card {
    background: linear-gradient(135deg, #fefce8, #fef9c3);
    border: 1px solid #fde047;
    border-radius: var(--radius-lg);
    padding: 16px 20px;
    margin-top: 16px;
    display: flex;
    align-items: center;
    gap: 14px;
}

.return-policy-card svg {
    width: 28px;
    height: 28px;
    color: #ca8a04;
    flex-shrink: 0;
}

.return-policy-info h4 {
    font-size: 13px;
    font-weight: 700;
    color: #854d0e;
    margin-bottom: 2px;
}

.return-policy-info p {
    font-size: 13px;
    color: #a16207;
    font-weight: 500;
    line-height: 1.5;
}

/* ═══════════════════════════════════════════════════════════════
   RESPONSIVE
   ═══════════════════════════════════════════════════════════════ */
@media (max-width: 900px) {
    .main-grid { grid-template-columns: 1fr; }
    .summary-card { position: static; }
    .navbar { padding: 14px 20px; }
    .page-wrapper { padding: 20px 16px 60px; }
}

@media (max-width: 700px) {
    .navbar {
        flex-direction: column;
        gap: 12px;
        padding: 16px 20px;
    }

    .nav-links { justify-content: center; gap: 6px; }
    .nav-links a { font-size: 13px; padding: 6px 10px; }

    .order-header-card { padding: 24px 20px; }
    .order-title-section h1 { font-size: 22px; }

    .timeline-tracker {
        overflow-x: auto;
        padding-bottom: 10px;
    }

    .timeline-step { min-width: 70px; }
    .step-label { font-size: 10px; max-width: 60px; }

    .info-grid { grid-template-columns: 1fr; }

    .order-item {
        flex-wrap: wrap;
        gap: 12px;
    }

    .item-subtotal {
        width: 100%;
        text-align: left;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .item-subtotal-label { margin-bottom: 0; }

    .card-header, .card-body { padding: 16px 20px; }

    .help-buttons { flex-direction: column; }
    .help-btn { justify-content: center; }
}

@media (max-width: 480px) {
    .order-header-top { flex-direction: column; }
    .status-badge { align-self: flex-start; }
    .timeline-tracker::before { left: 20px; right: 20px; }
}

</style>
</head>
<body>

<!-- ═══════════════════════════════════════════════════════════════
     NAVBAR
     ═══════════════════════════════════════════════════════════════ -->
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
        <a href="<%= request.getContextPath() %>/orders" class="active">Orders</a>
        <a href="<%= request.getContextPath() %>/wishlist">Wishlist</a>

        <a href="<%= request.getContextPath() %>/profile" class="profile-avatar-link" title="<%= username != null ? username : "Profile" %>">
            <% if (username != null && !username.trim().isEmpty()) {
                String initials = username.trim().length() >= 2
                        ? username.trim().substring(0, 2).toUpperCase()
                        : username.trim().substring(0, 1).toUpperCase();
            %>
            <div class="profile-avatar"><%= initials %></div>
            <% } else { %>
            <div class="profile-avatar profile-avatar-guest">👤</div>
            <% } %>
        </a>

        <% if (username == null) { %>
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

<!-- ═══════════════════════════════════════════════════════════════
     PAGE CONTENT
     ═══════════════════════════════════════════════════════════════ -->
<div class="page-wrapper">

    <%-- Flash Messages from OrderActionServlet --%>
    <% if ("true".equals(cancelledParam)) { %>
    <div class="flash-message flash-success">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        Order cancelled successfully. A refund will be processed within 5-7 business days.
    </div>
    <% } else if ("true".equals(returnedParam)) { %>
    <div class="flash-message flash-success">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        Return request submitted successfully. Our team will pick up the items within 2-3 business days.
    </div>
    <% } else if ("notcancellable".equals(errorParam)) { %>
    <div class="flash-message flash-error">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        This order cannot be cancelled at this stage.
    </div>
    <% } else if ("notreturnable".equals(errorParam)) { %>
    <div class="flash-message flash-error">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        This order cannot be returned. Returns are only available within 7 days of delivery.
    </div>
    <% } else if ("failed".equals(errorParam) || "returnfailed".equals(errorParam)) { %>
    <div class="flash-message flash-error">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        Action failed. Please try again or contact support.
    </div>
    <% } %>

    <!-- Breadcrumb -->
    <nav class="breadcrumb animate-in">
        <a href="<%= request.getContextPath() %>/home">Home</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%= request.getContextPath() %>/orders">My Orders</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Order #<%= order.getOrderId() %></span>
    </nav>

    <!-- Back Button -->
    <a href="<%= request.getContextPath() %>/orders" class="back-btn animate-in delay-1">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
        Back to My Orders
    </a>

    <!-- Order Header Card -->
    <div class="order-header-card animate-in delay-1">
        <div class="order-header-top">
            <div class="order-title-section">
                <h1>Order #<%= order.getOrderId() %></h1>
                <div class="order-meta-row">
                    <span class="order-date">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                        Placed on <%= order.getOrderDate() %>
                    </span>
                </div>
            </div>
            <span class="status-badge <%= status %>">
                <%= order.getStatus() %>
            </span>
        </div>
    </div>

    <!-- Order Timeline -->
    <% if (!status.equals("cancelled")) { %>
    <div class="timeline-section animate-in delay-2">
        <div class="timeline-title">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/></svg>
            Order Progress
        </div>
        <div class="timeline-tracker">
            <div class="timeline-progress-bar" style="width: <%= Math.max(0, (progressStep - 1) * 25) %>%;"></div>

            <div class="timeline-step">
                <div class="step-dot <%= progressStep >= 1 ? "completed" : "" %> <%= progressStep == 1 ? "active" : "" %>">1</div>
                <span class="step-label <%= progressStep >= 1 ? "completed" : "" %> <%= progressStep == 1 ? "active" : "" %>">Order Placed</span>
            </div>
            <div class="timeline-step">
                <div class="step-dot <%= progressStep >= 2 ? "completed" : "" %> <%= progressStep == 2 ? "active" : "" %>">2</div>
                <span class="step-label <%= progressStep >= 2 ? "completed" : "" %> <%= progressStep == 2 ? "active" : "" %>">Confirmed</span>
            </div>
            <div class="timeline-step">
                <div class="step-dot <%= progressStep >= 3 ? "completed" : "" %> <%= progressStep == 3 ? "active" : "" %>">3</div>
                <span class="step-label <%= progressStep >= 3 ? "completed" : "" %> <%= progressStep == 3 ? "active" : "" %>">Shipped</span>
            </div>
            <div class="timeline-step">
                <div class="step-dot <%= progressStep >= 4 ? "completed" : "" %> <%= progressStep == 4 ? "active" : "" %>">4</div>
                <span class="step-label <%= progressStep >= 4 ? "completed" : "" %> <%= progressStep == 4 ? "active" : "" %>">Out for Delivery</span>
            </div>
            <div class="timeline-step">
                <div class="step-dot <%= progressStep >= 5 ? "completed" : "" %> <%= progressStep == 5 ? "active" : "" %>">5</div>
                <span class="step-label <%= progressStep >= 5 ? "completed" : "" %> <%= progressStep == 5 ? "active" : "" %>">Delivered</span>
            </div>
        </div>

        <% if (progressStep >= 3 && progressStep < 5) { %>
        <div class="tracking-section">
            <div class="tracking-info">
                <h4>📦 Tracking Number</h4>
                <p>SHB-<%= order.getOrderId() %>-<%= order.getOrderDate().replaceAll("[^0-9]", "").substring(0, 8) %></p>
            </div>
        </div>
        <% } %>

        <% if (progressStep >= 1 && progressStep < 5) { %>
        <div class="delivery-card">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16V6a4 4 0 00-4-4H5.5A2.5 2.5 0 003 4.5v11A2.5 2.5 0 005.5 18H7m6-2h3.5a2.5 2.5 0 002.5-2.5v-7a2.5 2.5 0 00-2.5-2.5H13m0 0V3m0 3h-3m3 0l-2 2m2-2l2 2"/></svg>
            <div class="delivery-info">
                <h4>Estimated Delivery</h4>
                <p><%= deliveryEstimate %></p>
            </div>
        </div>
        <% } %>

        <% if (status.equals("delivered") || status.equals("completed")) { %>
        <div class="return-policy-card">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/></svg>
            <div class="return-policy-info">
                <h4>🔄 Return Policy</h4>
                <p>You have <strong>7 days</strong> from the delivery date to return this order. <span style="color: var(--success); font-weight: 600;">Hassle-free returns!</span></p>
            </div>
        </div>
        <% } %>
    </div>
    <% } else { %>
    <div class="timeline-section animate-in delay-2">
        <div class="timeline-title">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
            Order Status
        </div>
        <div class="cancelled-notice">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
            <span class="cancelled-notice-text">This order has been cancelled. If you have any questions, please contact our support team.</span>
        </div>
    </div>
    <% } %>

    <!-- Main Grid: Items + Summary -->
    <div class="main-grid">

        <!-- Left Column: Items & Details -->
        <div class="left-column">

            <!-- Order Items -->
            <div class="card animate-in delay-3">
                <div class="card-header">
                    <div class="card-title">
                        <span class="card-title-icon" style="background: linear-gradient(135deg, #dbeafe, #bfdbfe);">📚</span>
                        Items Ordered
                    </div>
                    <span style="font-size: 13px; color: var(--text-light); font-weight: 600;"><%= order.getItems().size() %> item<%= order.getItems().size() > 1 ? "s" : "" %></span>
                </div>
                <div class="card-body">
                    <div class="items-list">
                        <% int itemCount = 0;
                           double subtotal = 0;
                           for (OrderItem item : order.getItems()) {
                               itemCount++;
                               subtotal += item.getPrice() * item.getQuantity();
                        %>
                        <div class="order-item">
                            <div class="item-image-wrapper">
                                <img src="<%= request.getContextPath() %>/assets/<%= item.getImageUrl() %>" alt="<%= item.getTitle() %>">
                                <span class="item-qty-badge"><%= item.getQuantity() %></span>
                            </div>
                            <div class="item-info">
                                <div class="item-title"><%= item.getTitle() %></div>
                                <div class="item-meta-row">
                                    <span class="meta-chip">Qty: <%= item.getQuantity() %></span>
                                    <span class="meta-chip">₹<%= String.format("%.2f", item.getPrice()) %> each</span>
                                </div>
                            </div>
                            <div>
                                <div class="item-subtotal-label">Subtotal</div>
                                <div class="item-subtotal"><%= currency.format(item.getPrice() * item.getQuantity()) %></div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Customer & Shipping Details -->
            <div class="card animate-in delay-4" style="margin-top: 24px;">
                <div class="card-header">
                    <div class="card-title">
                        <span class="card-title-icon" style="background: linear-gradient(135deg, #fef3c7, #fde68a);">👤</span>
                        Order Details
                    </div>
                </div>
                <div class="card-body">
                    <div class="info-grid">
                        <div>
                            <div class="info-item">
                                <div class="info-label">Customer Name</div>
                                <div class="info-value"><%= username != null ? username : "N/A" %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Order ID</div>
                                <div class="info-value highlight">#<%= order.getOrderId() %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Order Date</div>
                                <div class="info-value"><%= order.getOrderDate() %></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Status</div>
                                <div class="info-value" style="text-transform: capitalize;"><%= order.getStatus() %></div>
                            </div>
                        </div>
                        <div>
                            <div class="info-item">
                                <div class="info-label">Shipping Address</div>
                                <div class="address-box">
                                    <% String addr = order.getShippingAddress();
                                       if (addr != null && !addr.trim().isEmpty()) {
                                           out.print(addr.replace(",", "<br>"));
                                       } else { %>
                                    <span style="color:var(--text-light);">No address on record</span>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- Right Column: Summary & Actions -->
        <div class="right-column">
            <div class="card summary-card animate-in delay-3">
                <div class="card-header">
                    <div class="card-title">
                        <span class="card-title-icon" style="background: linear-gradient(135deg, #d1fae5, #a7f3d0);">💰</span>
                        Order Summary
                    </div>
                </div>
                <div class="card-body">
                    <% 
                        double shipping = subtotal > 500 ? 0 : 49;
                        double discount = order.getDiscountAmount();
                        double total = subtotal + shipping - discount;
                    %>

                    <div class="summary-row">
                        <span class="summary-label">Subtotal (<%= itemCount %> items)</span>
                        <span class="summary-value"><%= currency.format(subtotal) %></span>
                    </div>
                    <% if (discount > 0) { %>
                    <div class="summary-row">
                        <span class="summary-label">Discount</span>
                        <span class="summary-value" style="color: var(--success);">- <%= currency.format(discount) %></span>
                    </div>
                    <% } %>
                    <div class="summary-row">
                        <span class="summary-label">Shipping</span>
                        <span class="summary-value" style="color: <%= shipping == 0 ? "var(--success)" : "var(--text-dark)" %>;">
                            <%= shipping == 0 ? "FREE" : currency.format(shipping) %>
                        </span>
                    </div>

                    <div class="summary-divider"></div>

                    <div class="summary-total">
                        <div>
                            <div class="total-label-main">Order Total</div>
                            <% if (discount > 0) { %>
                            <div class="total-savings">
                                <svg width="14" height="14" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                                You saved <%= currency.format(discount) %> with coupon
                            </div>
                            <% } %>
                        </div>
                        <div class="total-amount-main"><%= currency.format(total) %></div>
                    </div>

                    <!-- Payment Method -->
                    <div style="margin-top: 20px; padding-top: 16px; border-top: 1px dashed var(--border-light);">
                        <div class="info-label" style="margin-bottom: 8px;">Payment Method</div>
                        <div class="payment-method">
                            <div class="payment-icon">VISA</div>
                            <div class="payment-details">
                                <div class="payment-name">Card ending in 4242</div>
                                <div class="payment-status">
                                    <svg width="14" height="14" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
                                    Paid on <%= order.getOrderDate().split(" ")[0] %>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <button class="btn btn-primary" onclick="window.print()">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"/></svg>
                            Download Invoice
                        </button>
                        <a href="<%= request.getContextPath() %>/books" class="btn btn-secondary">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/></svg>
                            Reorder Items
                        </a>
                        <% if (canCancel) { %>
                        <form action="<%= request.getContextPath() %>/orderAction" method="post" style="width:100%;" onsubmit="return confirm('Are you sure you want to cancel this order?\n\nThis action cannot be undone. A refund will be processed within 5-7 business days.');">
                            <input type="hidden" name="action" value="cancel">
                            <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                            <button type="submit" class="btn btn-cancel">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
                                Cancel Order
                            </button>
                        </form>
                        <% } %>
                        <% if (canReturn) { %>
                        <form action="<%= request.getContextPath() %>/orderAction" method="post" style="width:100%;" onsubmit="return confirm('Request return for order #<%= order.getOrderId() %>?\n\nOur pickup team will collect the items within 2-3 business days. Refund will be processed within 5-7 days after pickup.');">
                            <input type="hidden" name="action" value="return">
                            <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                            <button type="submit" class="btn btn-return">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/></svg>
                                Return Order
                            </button>
                        </form>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Help Section -->
    <div class="help-section animate-in delay-4">
        <div class="help-title">Need Help with Your Order?</div>
        <div class="help-text">Our support team is available 24/7 to assist you with any questions about your order, returns, or refunds.</div>
        <div class="help-buttons">
            <a href="<%= request.getContextPath() %>/support/chat" class="help-btn help-btn-chat">
                <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/></svg>
                Live Chat
            </a>
            <a href="mailto:support@shelfbound.com" class="help-btn help-btn-email">
                <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
                Email Support
            </a>
        </div>
    </div>

</div>

<script>
// Animate timeline progress bar on load
document.addEventListener('DOMContentLoaded', function() {
    const progressBar = document.querySelector('.timeline-progress-bar');
    if (progressBar) {
        setTimeout(() => {
            progressBar.style.width = progressBar.style.width;
        }, 300);
    }

    // Add hover effect to order items
    const items = document.querySelectorAll('.order-item');
    items.forEach(item => {
        item.addEventListener('mouseenter', function() {
            this.style.transform = 'translateX(4px)';
        });
        item.addEventListener('mouseleave', function() {
            this.style.transform = 'translateX(0)';
        });
    });
});
</script>

</body>
</html>