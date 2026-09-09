<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.shelfbound.model.Order" %>
<%@ page import="com.shelfbound.model.OrderItem" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    NumberFormat currency = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
    String username = (String) session.getAttribute("username");

    // Count orders by status for sidebar
    int totalOrders = orders != null ? orders.size() : 0;
    int pendingCount = 0, processingCount = 0, completedCount = 0, cancelledCount = 0, returnedCount = 0;
    if (orders != null) {
        for (Order o : orders) {
            String status = o.getStatus().toLowerCase();
            if (status.contains("pending") || status.contains("confirmed")) pendingCount++;
            else if (status.contains("shipped") || status.contains("out for delivery") || status.contains("processing")) processingCount++;
            else if (status.contains("completed") || status.contains("delivered")) completedCount++;
            else if (status.contains("cancelled")) cancelledCount++;
            else if (status.contains("returned")) returnedCount++; 
        }
    }

    // Flash messages from orders list page
    String ordersError = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders | ShelfBound</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
   <style>
   /* =====================================================
   ORDERS PAGE - ShelfBound
   Real e-commerce order history with cancel support
===================================================== */

:root {
    --navy-900: #0f172a;
    --navy-700: #1e3a8a;
    --navy-600: #1d4ed8;
    --accent-orange: #ff7a00;
    --orange-100: #fff1e0;
    --bg-main: #f3f4f6;
    --bg-card: #ffffff;
    --text-primary: #1e293b;
    --text-muted: #64748b;
    --border-light: #e2e8f0;
    --success: #16a34a;
    --success-bg: #dcfce7;
    --warning: #f59e0b;
    --warning-bg: #fef3c7;
    --danger: #dc2626;
    --danger-bg: #fee2e2;
    --info: #0ea5e9;
    --info-bg: #e0f2fe;
    --purple: #8b5cf6;
    --purple-bg: #ede9fe;
    --shadow-sm: 0 1px 3px rgba(0,0,0,0.06);
    --shadow-md: 0 4px 14px rgba(15,23,42,.08);
    --shadow-hover: 0 10px 24px rgba(15,23,42,.12);
    --radius-lg: 14px;
    --radius-md: 10px;
    --transition: .2s cubic-bezier(.4,0,.2,1);
}

* { margin: 0; padding: 0; box-sizing: border-box; }

body {
    font-family: 'Inter', 'Segoe UI', system-ui, -apple-system, sans-serif;
    background: 
        radial-gradient(1200px circle at 10% 10%, rgba(30, 58, 138, 0.06), transparent 40%),
        radial-gradient(1000px circle at 90% 20%, rgba(255, 122, 0, 0.05), transparent 40%),
        radial-gradient(800px circle at 50% 80%, rgba(30, 58, 138, 0.04), transparent 50%),
        #f8fafc;
    color: var(--text-primary);
    min-height: 100vh;
    -webkit-font-smoothing: antialiased;
}

/* ================= FLASH MESSAGES ================= */
.flash-message {
    padding: 14px 20px;
    border-radius: var(--radius-md);
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 14px;
    font-weight: 600;
    animation: fadeInUp 0.4s ease;
    box-shadow: var(--shadow-sm);
    backdrop-filter: blur(10px);
}

.flash-error {
    background: rgba(254, 242, 242, 0.9);
    border: 1px solid #fecaca;
    color: #991b1b;
}

.flash-success {
    background: rgba(236, 253, 245, 0.9);
    border: 1px solid #a7f3d0;
    color: #065f46;
}

@keyframes fadeInUp {
    from { opacity: 0; transform: translateY(-10px); }
    to { opacity: 1; transform: translateY(0); }
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

/* ================= LOGOUT BUTTON STYLES ================= */
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

@media (max-width: 700px) {
    .navbar {
        flex-direction: column;
        gap: 16px;
        padding: 20px;
    }
    .nav-links {
        justify-content: center;
        gap: 8px;
    }
}

/* ================= PAGE HEADER ================= */
.page-header {
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    border-bottom: 1px solid rgba(226, 232, 240, 0.8);
    padding: 26px 40px;
}

.page-header-inner {
    max-width: 1200px;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 16px;
}

.page-title {
    font-size: 28px;
    font-weight: 800;
    color: var(--text-primary);
    letter-spacing: -0.5px;
    margin: 0;
}

.page-title span {
    color: var(--accent-orange);
}

.order-search {
    display: flex;
    align-items: center;
    gap: 0;
    background: rgba(255, 255, 255, 0.95);
    border: 1.5px solid rgba(226, 232, 240, 0.9);
    border-radius: 999px;
    padding: 0 4px 0 16px;
    width: 330px;
    max-width: 100%;
    transition: var(--transition);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
}

.order-search:focus-within {
    border-color: var(--accent-orange);
    box-shadow: 0 0 0 4px rgba(255, 122, 0, 0.15);
    background: #ffffff;
}

.order-search input {
    flex: 1;
    border: none;
    background: transparent;
    padding: 10px 0;
    font-size: 14px;
    font-family: inherit;
    color: var(--text-primary);
    outline: none;
}

.order-search input::placeholder {
    color: #94a3b8;
}

.order-search button {
    background: var(--navy-700);
    color: white;
    border: none;
    padding: 8px 18px;
    border-radius: 999px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    transition: var(--transition);
}

.order-search button:hover {
    background: var(--accent-orange);
}

/* ================= MAIN LAYOUT ================= */
.orders-layout {
    max-width: 1200px;
    margin: 0 auto;
    padding: 24px 40px 60px;
    display: grid;
    grid-template-columns: 220px 1fr;
    gap: 24px;
    align-items: start;
}

/* ================= SIDEBAR FILTERS ================= */
.orders-sidebar {
    background: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    border-radius: var(--radius-lg);
    border: 1px solid rgba(226, 232, 240, 0.85);
    box-shadow: 0 10px 25px rgba(15, 23, 42, 0.04);
    padding: 20px;
    position: sticky;
    top: 90px;
}

.sidebar-title {
    font-size: 13px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: var(--text-muted);
    margin-bottom: 14px;
    padding-bottom: 10px;
    border-bottom: 1px solid var(--border-light);
}

.filter-list {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.filter-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 10px 12px;
    border-radius: 8px;
    text-decoration: none;
    color: var(--text-primary);
    font-size: 14px;
    font-weight: 500;
    transition: var(--transition);
    cursor: pointer;
    border: none;
    background: none;
    width: 100%;
    font-family: inherit;
}

.filter-item:hover {
    background: #f8fafc;
    color: var(--navy-700);
}

.filter-item.active {
    background: var(--orange-100);
    color: #c2570a;
    font-weight: 600;
}

.filter-count {
    font-size: 12px;
    font-weight: 600;
    color: var(--text-muted);
    background: #f1f5f9;
    padding: 2px 8px;
    border-radius: 999px;
}

.filter-item.active .filter-count {
    background: rgba(255, 122, 0, 0.15);
    color: #c2570a;
}

/* ================= ORDER CARDS ================= */
.orders-list {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.order-card {
    background: rgba(255, 255, 255, 0.92);
    backdrop-filter: blur(14px);
    -webkit-backdrop-filter: blur(14px);
    border-radius: 16px;
    border: 1px solid rgba(226, 232, 240, 0.85);
    box-shadow: 0 6px 20px rgba(15, 23, 42, 0.04);
    overflow: hidden;
    transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
}

.order-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 12px 30px rgba(15, 23, 42, 0.08);
    border-color: rgba(255, 122, 0, 0.35);
}

/* Order Header */
.order-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px 24px;
    background: rgba(248, 250, 252, 0.85);
    border-bottom: 1px solid rgba(226, 232, 240, 0.8);
    flex-wrap: wrap;
    gap: 10px;
}

.order-meta-left {
    display: flex;
    align-items: center;
    gap: 20px;
    flex-wrap: wrap;
}

.order-meta-block {
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.order-meta-label {
    font-size: 11px;
    color: var(--text-muted);
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.order-meta-value {
    font-size: 14px;
    font-weight: 700;
    color: var(--text-primary);
}

.order-id-link {
    color: var(--navy-700);
    text-decoration: none;
    transition: var(--transition);
}

.order-id-link:hover {
    color: var(--accent-orange);
    text-decoration: underline;
}

/* Status Badge */
.status-badge {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 14px;
    border-radius: 999px;
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 0.3px;
    text-transform: uppercase;
}

.status-badge::before {
    content: "";
    width: 6px;
    height: 6px;
    border-radius: 50%;
    flex-shrink: 0;
}

.status-badge.pending {
    background: var(--warning-bg);
    color: #b45309;
}
.status-badge.pending::before {
    background: var(--warning);
    animation: pulse 2s infinite;
}

.status-badge.confirmed {
    background: var(--info-bg);
    color: #0369a1;
}
.status-badge.confirmed::before {
    background: var(--info);
    animation: pulse 2s infinite;
}

.status-badge.processing, .status-badge.shipped {
    background: var(--purple-bg);
    color: #6d28d9;
}
.status-badge.processing::before, .status-badge.shipped::before {
    background: var(--purple);
    animation: pulse 2s infinite;
}

.status-badge.out-for-delivery {
    background: #dbeafe;
    color: #1d4ed8;
}
.status-badge.out-for-delivery::before {
    background: #3b82f6;
    animation: pulse 2s infinite;
}

.status-badge.completed, .status-badge.delivered {
    background: var(--success-bg);
    color: #15803d;
}
.status-badge.completed::before, .status-badge.delivered::before {
    background: var(--success);
}

.status-badge.returned {
    background: linear-gradient(135deg, #fef3c7, #fde68a);  /* light brown/amber */
    color: #92400e;                                          /* dark brown text */
    border: 1px solid #fcd34d;
}
.status-badge.returned::before {
    background: #eab308;
    animation: pulse 2s infinite;
}

.status-badge.cancelled {
    background: var(--danger-bg);
    color: #b91c1c;
}
.status-badge.cancelled::before {
    background: var(--danger);
}

@keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.4; }
}

/* Order Body */
.order-body {
    padding: 20px 24px;
}

.delivery-info {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 13px;
    color: var(--text-muted);
    margin-bottom: 16px;
    padding-bottom: 14px;
    border-bottom: 1px dashed var(--border-light);
}

.delivery-info .delivery-icon {
    font-size: 16px;
}

.delivery-info .delivery-date {
    color: var(--text-primary);
    font-weight: 600;
}

/* Items Grid */
.items-grid {
    display: flex;
    flex-direction: column;
    gap: 14px;
}

.item-row {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 10px 0;
}

.item-row:not(:last-child) {
    border-bottom: 1px solid #f1f5f9;
}

.item-thumb {
    width: 64px;
    height: 88px;
    border-radius: 8px;
    object-fit: cover;
    background: #f1f5f9;
    flex-shrink: 0;
    border: 1px solid var(--border-light);
    transition: var(--transition);
}

.item-row:hover .item-thumb {
    transform: scale(1.05);
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.item-details {
    flex: 1;
    min-width: 0;
}

.item-title {
    font-size: 14px;
    font-weight: 600;
    color: var(--text-primary);
    margin-bottom: 4px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.item-meta {
    font-size: 13px;
    color: var(--text-muted);
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
}

.item-meta span {
    display: flex;
    align-items: center;
    gap: 4px;
}

.item-price {
    font-size: 15px;
    font-weight: 700;
    color: var(--navy-700);
    flex-shrink: 0;
}

/* Order Footer */
.order-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 14px 24px;
    background: #f8fafc;
    border-top: 1px solid var(--border-light);
    flex-wrap: wrap;
    gap: 12px;
}

.order-total {
    font-size: 15px;
    font-weight: 700;
    color: var(--text-primary);
}

.order-total span {
    color: var(--navy-700);
    font-size: 18px;
}

.order-actions {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}

.btn {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 9px 18px;
    border-radius: 8px;
    font-size: 13px;
    font-weight: 600;
    text-decoration: none;
    transition: var(--transition);
    cursor: pointer;
    border: none;
    font-family: inherit;
}

.btn-primary {
    background: var(--navy-700);
    color: white;
    box-shadow: 0 2px 8px rgba(30, 58, 138, 0.2);
}

.btn-primary:hover {
    background: var(--navy-600);
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(30, 58, 138, 0.3);
}

.btn-secondary {
    background: white;
    color: var(--text-primary);
    border: 1.5px solid var(--border-light);
}

.btn-secondary:hover {
    background: #f8fafc;
    border-color: #cbd5e1;
    transform: translateY(-1px);
}

.btn-success {
    background: var(--success-bg);
    color: #15803d;
    border: 1.5px solid #bbf7d0;
}

.btn-success:hover {
    background: #bbf7d0;
    transform: translateY(-1px);
}

.btn-return {
    background: linear-gradient(135deg, #fefce8, #fef9c3);
    color: #854d0e;
    border: 1.5px solid #fde047;
    box-shadow: 0 2px 8px rgba(202, 138, 4, 0.1);
}
.btn-return:hover {
    background: linear-gradient(135deg, #fef9c3, #fde047);
    border-color: #eab308;
    color: #713f12;
    transform: translateY(-1px);
    box-shadow: 0 4px 14px rgba(202, 138, 4, 0.2);
}

/* Cancel Button (Light Red Gradient) */
.btn-cancel {
    background: linear-gradient(135deg, #fef2f2, #fee2e2);
    color: #b91c1c;
    border: 1.5px solid #fecaca;
    box-shadow: 0 2px 8px rgba(185, 28, 28, 0.1);
}

.btn-cancel:hover {
    background: linear-gradient(135deg, #fee2e2, #fecaca);
    border-color: #f87171;
    color: #991b1b;
    transform: translateY(-1px);
    box-shadow: 0 4px 14px rgba(185, 28, 28, 0.2);
}



/* ================= EMPTY STATE ================= */
.empty-state {
    text-align: center;
    padding: 80px 40px;
    background: white;
    border-radius: var(--radius-lg);
    border: 1px solid var(--border-light);
    box-shadow: var(--shadow-sm);
}

.empty-icon {
    font-size: 64px;
    margin-bottom: 20px;
    opacity: 0.6;
}

.empty-title {
    font-size: 22px;
    font-weight: 700;
    color: var(--text-primary);
    margin-bottom: 8px;
}

.empty-subtitle {
    font-size: 15px;
    color: var(--text-muted);
    margin-bottom: 28px;
    max-width: 400px;
    margin-left: auto;
    margin-right: auto;
    line-height: 1.5;
}

.empty-btn {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 13px 28px;
    background: linear-gradient(135deg, var(--accent-orange), #ffa54a);
    color: white;
    text-decoration: none;
    border-radius: 10px;
    font-weight: 700;
    font-size: 15px;
    transition: var(--transition);
    box-shadow: 0 4px 14px rgba(255, 122, 0, 0.3);
}

.empty-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(255, 122, 0, 0.4);
}

/* ================= FOOTER ================= */
.orders-footer {
    max-width: 1200px;
    margin: 40px auto 0;
    padding: 0 40px;
}

.footer-box {
    text-align: center;
    padding: 40px;
    background: linear-gradient(135deg, #ffffff, #f3f7ff);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border-light);
    box-shadow: var(--shadow-sm);
}

.footer-text {
    font-size: 20px;
    font-weight: 600;
    color: var(--navy-700);
    margin-bottom: 10px;
}

.footer-sub {
    font-size: 14px;
    color: var(--text-muted);
    margin-bottom: 24px;
}

.shop-btn {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 12px 28px;
    background: linear-gradient(135deg, #16a34a, #15803d);
    color: white;
    text-decoration: none;
    border-radius: 10px;
    font-weight: 700;
    font-size: 14px;
    transition: var(--transition);
    box-shadow: 0 4px 14px rgba(22, 163, 74, 0.3);
}

.shop-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 18px rgba(22, 163, 74, 0.4);
}

/* ================= RESPONSIVE ================= */
@media (max-width: 900px) {
    .orders-layout {
        grid-template-columns: 1fr;
        padding: 20px 20px 40px;
    }

    .orders-sidebar {
        position: static;
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        padding: 16px;
    }

    .sidebar-title {
        width: 100%;
        margin-bottom: 8px;
    }

    .filter-list {
        flex-direction: row;
        flex-wrap: wrap;
    }

    .filter-item {
        width: auto;
        padding: 8px 14px;
    }

    .page-header {
        padding: 20px;
    }

    .page-header-inner {
        flex-direction: column;
        align-items: flex-start;
    }

    .order-search {
        width: 100%;
    }

    .order-header {
        flex-direction: column;
        align-items: flex-start;
    }

    .order-footer {
        flex-direction: column;
        align-items: flex-start;
    }

    .item-row {
        gap: 12px;
    }

    .item-thumb {
        width: 52px;
        height: 72px;
    }

    .orders-footer {
        padding: 0 20px;
    }
}

@media (max-width: 480px) {
    .navbar {
        flex-direction: column;
        gap: 16px;
        padding: 16px 20px;
    }

    .nav-links {
        justify-content: center;
        gap: 8px;
    }

    .order-actions {
        width: 100%;
    }

    .btn {
        flex: 1;
        justify-content: center;
    }
}
   </style>
</head>
<body>

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
        <a href="<%= request.getContextPath() %>/orders" class="active">Orders</a>
        <a href="<%= request.getContextPath() %>/wishlist">Wishlist</a>

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
            <div class="profile-avatar profile-avatar-guest">👤</div>
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

<!-- ================= PAGE HEADER ================= -->
<div class="page-header">
    <div class="page-header-inner">
        <h1 class="page-title">My <span>Orders</span></h1>
        <div class="order-search">
            <input type="text" id="orderSearchInput" placeholder="Search by order ID or book name...">
            <button type="button" onclick="filterOrders()">Search</button>
        </div>
    </div>
</div>

<!-- ================= MAIN LAYOUT ================= -->
<div class="orders-layout">

    <!-- Sidebar Filters -->
    <div class="orders-sidebar">
        <div class="sidebar-title">Filter Orders</div>
        <div class="filter-list">
            <button class="filter-item active" data-filter="all" onclick="setFilter('all')">
                All Orders
                <span class="filter-count" id="count-all"><%= totalOrders %></span>
            </button>
            <button class="filter-item" data-filter="pending" onclick="setFilter('pending')">
                Pending
                <span class="filter-count" id="count-pending"><%= pendingCount %></span>
            </button>
            <button class="filter-item" data-filter="processing" onclick="setFilter('processing')">
                Processing
                <span class="filter-count" id="count-processing"><%= processingCount %></span>
            </button>
            <button class="filter-item" data-filter="completed" onclick="setFilter('completed')">
                Completed
                <span class="filter-count" id="count-completed"><%= completedCount %></span>
            </button>
            <button class="filter-item" data-filter="cancelled" onclick="setFilter('cancelled')">
                Cancelled
                <span class="filter-count" id="count-cancelled"><%= cancelledCount %></span>
            </button>
            <button class="filter-item" data-filter="returned" onclick="setFilter('returned')">
                Returned
                <span class="filter-count" id="count-returned"><%= returnedCount %></span>
            </button>
        </div>
    </div>

    <!-- Orders List -->
    <div class="orders-list" id="ordersList">

        <%
        if (orders == null || orders.isEmpty()) {
        %>

        <!-- Empty State -->
        <div class="empty-state" id="emptyState">
            <div class="empty-icon">📦</div>
            <div class="empty-title">No orders yet</div>
            <div class="empty-subtitle">Looks like you haven't placed any orders. Start exploring our collection and find your next favorite book!</div>
            <a href="<%= request.getContextPath() %>/books" class="empty-btn">
                🛒 Start Shopping
            </a>
        </div>

        <%
        } else {
            for (Order o : orders) {
                String rawStatus = o.getStatus().toLowerCase();
                String statusClass;
                String filterType;
                boolean isCancellable = false;

                // Determine status class and filter type
                if (rawStatus.contains("pending") || rawStatus.contains("confirmed")) {
                    statusClass = rawStatus.contains("confirmed") ? "confirmed" : "pending";
                    filterType = "pending";
                    isCancellable = true;
                } else if (rawStatus.contains("shipped")) {
                    statusClass = "shipped";
                    filterType = "processing";
                } else if (rawStatus.contains("out for delivery")) {
                    statusClass = "out-for-delivery";
                    filterType = "processing";
                } else if (rawStatus.contains("returned")) {
                    statusClass = "returned";
                    filterType = "returned";
                } else if (rawStatus.contains("delivered") || rawStatus.contains("completed")) {
                    statusClass = rawStatus.contains("delivered") ? "delivered" : "completed";
                    filterType = "completed";
                } else if (rawStatus.contains("cancelled")) {
                    statusClass = "cancelled";
                    filterType = "cancelled";
                } else {
                    statusClass = "pending";
                    filterType = "pending";
                    isCancellable = true;
                }

                // Build search text from all items
                StringBuilder searchText = new StringBuilder();
                searchText.append(o.getOrderId()).append(" ");
                if (o.getItems() != null) {
                    for (OrderItem item : o.getItems()) {
                        searchText.append(item.getTitle()).append(" ");
                    }
                }
        %>

        <!-- Order Card -->
        <div class="order-card" 
             data-status="<%= filterType %>" 
             data-order-id="<%= o.getOrderId() %>"
             data-search="<%= searchText.toString().toLowerCase() %>">

            <!-- Order Header -->
            <div class="order-header">
                <div class="order-meta-left">
                    <div class="order-meta-block">
                        <span class="order-meta-label">Order ID</span>
                        <span class="order-meta-value">
                            <a href="<%= request.getContextPath() %>/orderDetails?orderId=<%= o.getOrderId() %>" class="order-id-link">
                                #<%= o.getOrderId() %>
                            </a>
                        </span>
                    </div>
                    <div class="order-meta-block">
                        <span class="order-meta-label">Order Date</span>
                        <span class="order-meta-value"><%= o.getOrderDate() != null ? o.getOrderDate() : "N/A" %></span>
                    </div>
                </div>
                <span class="status-badge <%= statusClass %>">
                    <%= o.getStatus() %>
                </span>
            </div>

            <!-- Order Body -->
            <div class="order-body">
                                <div class="delivery-info">
                    <span class="delivery-icon">
                        <% if (filterType.equals("completed")) { %><i class="fas fa-check-circle" style="color: var(--success);"></i><% } 
                           else if (filterType.equals("cancelled")) { %><i class="fas fa-times-circle" style="color: var(--danger);"></i><% } 
                           else if (filterType.equals("processing")) { %><i class="fas fa-shipping-fast" style="color: var(--purple);"></i><% } 
                           else if (filterType.equals("returned")) { %><i class="fas fa-undo-alt" style="color: #92400e;"></i><% } 
                           else { %><i class="fas fa-box" style="color: var(--navy-700);"></i><% } %>
                    </span>
                    <span>
                        <% if (filterType.equals("completed")) { %>
                            Delivered successfully on <span class="delivery-date"><%= o.getOrderDate() != null ? o.getOrderDate() : "N/A" %></span>
                        <% } else if (filterType.equals("returned")) { %>
                              <i class="fas fa-undo-alt" style="color: #92400e; margin-right: 6px;"></i>Return in progress. <span class="delivery-date">Pickup within 2-3 days, refund in 5-7 days</span>
                        <% } else if (filterType.equals("cancelled")) { %>
                            Order was cancelled. <span class="delivery-date">Refund processed within 5-7 days</span>
                        <% } else if (filterType.equals("processing")) { %>
                            On the way! <span class="delivery-date">Arriving soon</span>
                        <% } else { %>
Expected delivery by <span class="delivery-date">3-5 business days</span>
                        <% } %>
                    </span>
                </div>

                <div class="items-grid">
                    <%
                        if (o.getItems() != null) {
                            for (OrderItem item : o.getItems()) {
                    %>
                    <div class="item-row">
                        <img src="<%= request.getContextPath() %>/assets/<%= item.getImageUrl() %>" alt="<%= item.getTitle() %>" class="item-thumb">
                        <div class="item-details">
                            <div class="item-title"><%= item.getTitle() %></div>
                            <div class="item-meta">
                                <span>📚 Qty: <%= item.getQuantity() %></span>
                                <span>💰 <%= currency.format(item.getPrice()) %> each</span>
                            </div>
                        </div>
                        <div class="item-price"><%= currency.format(item.getPrice() * item.getQuantity()) %></div>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>
            </div>

            <!-- Order Footer -->
            <div class="order-footer">
                <div class="order-total">
                    Order Total: <span><%= currency.format(o.getTotalAmount()) %></span>
                </div>
                <div class="order-actions">
                    <a href="<%= request.getContextPath() %>/orderDetails?orderId=<%= o.getOrderId() %>" class="btn btn-primary">
                        👁 View Details
                    </a>
                    <% if (filterType.equals("processing")) { %>
                    <button class="btn btn-secondary">📍 Track Order</button>
                    <% } %>
                    <% if (filterType.equals("completed")) { %>
                    <a href="<%= request.getContextPath() %>/books" class="btn btn-success">🔄 Buy Again</a>
                    <% } %>
                    <% if (isCancellable) { %>
                    <form action="<%= request.getContextPath() %>/cancelOrder" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to cancel order #<%= o.getOrderId() %>?\\n\\nThis action cannot be undone. A refund will be processed within 5-7 business days.');">
                        <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                        <button type="submit" class="btn btn-cancel">✕ Cancel Order</button>
                    </form>
                    <% } %>
                </div>
            </div>

        </div>

        <%
            }
        }
        %>

        <!-- No Results Message (hidden by default) -->
        <div class="empty-state" id="noResultsState" style="display: none;">
            <div class="empty-icon">🔍</div>
            <div class="empty-title">No orders found</div>
            <div class="empty-subtitle">We couldn't find any orders matching your search. Try different keywords or check your filters.</div>
            <button class="empty-btn" onclick="clearFilters()">Clear Filters</button>
        </div>

    </div>
</div>

<!-- ================= FOOTER ================= -->
<div class="orders-footer">
    <div class="footer-box">
        <div class="footer-text">✨ Go and Explore More</div>
        <div class="footer-sub">Discover new books, stories, and knowledge waiting for you.</div>
        <a href="<%= request.getContextPath() %>/books" class="shop-btn">
            🛒 Continue Shopping
        </a>
    </div>
</div>

<!-- ================= FILTER & SEARCH JAVASCRIPT ================= -->
<script>
let currentFilter = 'all';
let currentSearch = '';

// Filter button click handler
function setFilter(filterType) {
    currentFilter = filterType;

    // Update active button styling
    document.querySelectorAll('.filter-item').forEach(btn => {
        btn.classList.remove('active');
        if (btn.getAttribute('data-filter') === filterType) {
            btn.classList.add('active');
        }
    });

    applyFilters();
}

// Search input handler
function filterOrders() {
    currentSearch = document.getElementById('orderSearchInput').value.trim().toLowerCase();
    applyFilters();
}

// Real-time search on typing
document.getElementById('orderSearchInput').addEventListener('input', function() {
    currentSearch = this.value.trim().toLowerCase();
    applyFilters();
});

// Enter key on search
document.getElementById('orderSearchInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        filterOrders();
    }
});

// Main filter logic
function applyFilters() {
    const orderCards = document.querySelectorAll('.order-card');
    let visibleCount = 0;

    orderCards.forEach(card => {
        const cardStatus = card.getAttribute('data-status');
        const cardSearch = card.getAttribute('data-search') || '';
        const orderId = card.getAttribute('data-order-id') || '';

        // Check status filter
        const statusMatch = currentFilter === 'all' || cardStatus === currentFilter;

        // Check search filter (searches order ID and book titles)
        const searchMatch = currentSearch === '' || 
                           cardSearch.includes(currentSearch) || 
                           orderId.includes(currentSearch);

        if (statusMatch && searchMatch) {
            card.style.display = '';
            visibleCount++;
        } else {
            card.style.display = 'none';
        }
    });

    // Toggle empty states
    const emptyState = document.getElementById('emptyState');
    const noResultsState = document.getElementById('noResultsState');

    if (visibleCount === 0) {
        // Hide all cards, show no results
        noResultsState.style.display = '';
        if (emptyState) emptyState.style.display = 'none';
    } else {
        noResultsState.style.display = 'none';
        if (emptyState) emptyState.style.display = 'none';
    }
}

// Clear all filters
function clearFilters() {
    currentFilter = 'all';
    currentSearch = '';
    document.getElementById('orderSearchInput').value = '';

    // Reset filter buttons
    document.querySelectorAll('.filter-item').forEach(btn => {
        btn.classList.remove('active');
        if (btn.getAttribute('data-filter') === 'all') {
            btn.classList.add('active');
        }
    });

    applyFilters();
}
</script>

</body>
</html>