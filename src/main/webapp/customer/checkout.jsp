<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.shelfbound.model.CartItem" %>
<%@ page import="com.shelfbound.model.Offer" %>
<%@ page import="com.shelfbound.dao.OfferDAO" %>
<%@ page import="com.shelfbound.daoimpl.OfferDAOImpl" %>
<%@ page import="com.shelfbound.connection.DBConnection" %>

<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

    if (cart == null || cart.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/cart");
        return;
    }

    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");

    // Default empty values
    String userFullName = username != null ? username : "";
    String userPhone = "";
    String userAddress = "";
    String userCity = "";
    String userState = "";
    String userPincode = "";

    // Fetch user details from database if logged in
    if (userId != null) {
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT username, phone, address, city, state, pincode FROM users WHERE user_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String dbUsername = rs.getString("username");
                if (dbUsername != null && !dbUsername.isEmpty()) {
                    userFullName = dbUsername;
                }
                userPhone = rs.getString("phone") != null ? rs.getString("phone") : "";
                userAddress = rs.getString("address") != null ? rs.getString("address") : "";
                userCity = rs.getString("city") != null ? rs.getString("city") : "";
                userState = rs.getString("state") != null ? rs.getString("state") : "";
                userPincode = rs.getString("pincode") != null ? rs.getString("pincode") : "";
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Calculate totals
    double subtotal = 0;
    for (CartItem item : cart) {
        subtotal += item.getBook().getPrice() * item.getQuantity();
    }

    /* ========== CHANGED: Added request-parameter fallback for coupon ========== */
    String appliedCoupon = (String) session.getAttribute("appliedCoupon");
    
    // Fallback: if user navigated with ?coupon=WELCOME20
    if (appliedCoupon == null) {
        appliedCoupon = request.getParameter("coupon");
        if (appliedCoupon != null) {
            appliedCoupon = appliedCoupon.toUpperCase();
            session.setAttribute("appliedCoupon", appliedCoupon);
        }
    }
    
    if (appliedCoupon == null) appliedCoupon = "";
    /* ========== END CHANGE ========== */

    double discountPercent = 0;
    if (!appliedCoupon.isEmpty()) {
        Double sessionPercent = (Double) session.getAttribute("couponDiscountPercent");
        if (sessionPercent != null && sessionPercent > 0) {
            discountPercent = sessionPercent;
        } else {
            com.shelfbound.dao.OfferDAO offerDAO = new com.shelfbound.daoimpl.OfferDAOImpl();
            com.shelfbound.model.Offer offer = offerDAO.getOfferByCode(appliedCoupon);
            if (offer != null && offer.isActive() && subtotal >= offer.getMinOrderAmount()) {
                discountPercent = offer.getDiscountPercentage() / 100.0;
                session.setAttribute("couponDiscountPercent", discountPercent);
            }
        }
    }
    double discountAmount = subtotal * discountPercent;
    double shipping = 0;
    double grandTotal = subtotal - discountAmount + shipping;

    int totalItems = 0;
    for (CartItem item : cart) {
        totalItems += item.getQuantity();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Checkout - ShelfBound</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700&display=swap" rel="stylesheet">
<style>
/* =====================================================
   CHECKOUT PAGE - ShelfBound (Rich UI)
===================================================== */

:root {
    --navy-900: #0f172a;
    --navy-800: #1e293b;
    --navy-700: #1e3a8a;
    --navy-600: #1d4ed8;
    --accent-orange: #ff7a00;
    --accent-orange-light: #fff7ed;
    --bg-main: #f8fafc;
    --bg-card: #ffffff;
    --text-primary: #1e293b;
    --text-secondary: #475569;
    --text-muted: #64748b;
    --border-light: #e2e8f0;
    --border-medium: #cbd5e1;
    --success: #16a34a;
    --success-light: #dcfce7;
    --success-dark: #15803d;
    --danger: #ef4444;
    --danger-light: #fee2e2;
    --warning: #f59e0b;
    --warning-light: #fef3c7;
    --info: #0ea5e9;
    --info-light: #e0f2fe;
    --shadow-sm: 0 1px 3px rgba(0,0,0,0.06);
    --shadow-md: 0 4px 16px rgba(15,23,42,.08);
    --shadow-hover: 0 10px 24px rgba(15,23,42,.12);
    --shadow-glow: 0 0 20px rgba(30, 58, 138, 0.15);
    --radius-lg: 16px;
    --radius-md: 12px;
    --radius-sm: 8px;
    --transition: .25s cubic-bezier(.4,0,.2,1);
}

* { margin: 0; padding: 0; box-sizing: border-box; }

body {
    font-family: 'Inter', 'Segoe UI', system-ui, sans-serif;
    background: linear-gradient(135deg, #f0f4ff 0%, #f8fafc 50%, #fff1e6 100%);
    color: var(--text-primary);
    overflow-x: hidden;
    line-height: 1.5;
    min-height: 100vh;
}

::-webkit-scrollbar { width: 8px; }
::-webkit-scrollbar-track { background: transparent; }
::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 4px; }
::-webkit-scrollbar-thumb:hover { background: #94a3b8; }

/* ================= NAVBAR (Same as Cart Page) ================= */
.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 14px 40px;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(12px);
    border-bottom: 1px solid var(--border-light);
    position: sticky;
    top: 0;
    z-index: 1000;
    box-shadow: var(--shadow-sm);
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
    gap: 12px;
}

.nav-links a {
    text-decoration: none;
    color: var(--text-muted);
    font-weight: 600;
    font-size: 14px;
    padding: 8px 14px;
    border-radius: 8px;
    transition: var(--transition);
}
.nav-links a:hover {
    color: var(--navy-700);
    background: rgba(30, 58, 138, 0.07);
}
.nav-links a.active {
    color: var(--navy-700);
    background: rgba(30, 58, 138, 0.07);
}

.welcome-user {
    color: var(--navy-700);
    font-weight: 700;
    font-size: 13px;
    padding: 8px 14px;
    background: rgba(30, 58, 138, 0.06);
    border-radius: 8px;
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

/* ================= PROFILE AVATAR ================= */
.profile-avatar-link {
    display: inline-flex;
    text-decoration: none;
    padding: 0 !important;
}
.profile-avatar {
    width: 34px; height: 34px;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--navy-700), var(--navy-600));
    color: #ffffff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 13px;
    font-weight: 700;
    letter-spacing: 0.3px;
    box-shadow: 0 2px 6px rgba(30, 58, 138, 0.3);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
    user-select: none;
}
.profile-avatar-guest {
    background: #f1f5f9;
    font-size: 16px;
    box-shadow: none;
    border: 1.5px solid var(--border-light);
    color: var(--text-muted);
}
.profile-avatar-link:hover .profile-avatar {
    transform: scale(1.08);
    box-shadow: 0 4px 10px rgba(30, 58, 138, 0.4);
}

/* ================= PROGRESS STEPS ================= */
.progress-container {
    background: linear-gradient(135deg, var(--navy-700), var(--navy-600));
    padding: 24px 40px;
    position: relative;
    overflow: hidden;
}

.progress-container::before {
    content: '';
    position: absolute;
    top: -50%;
    right: -10%;
    width: 400px;
    height: 400px;
    background: rgba(255,255,255,0.03);
    border-radius: 50%;
}

.progress-steps {
    max-width: 600px;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    position: relative;
}

.progress-steps::before {
    content: '';
    position: absolute;
    top: 20px;
    left: 60px;
    right: 60px;
    height: 3px;
    background: rgba(255,255,255,0.2);
    z-index: 0;
    border-radius: 2px;
}

.progress-line-fill {
    position: absolute;
    top: 20px;
    left: 60px;
    width: 50%;
    height: 3px;
    background: linear-gradient(90deg, var(--accent-orange), #ff9a44);
    z-index: 0;
    border-radius: 2px;
    transition: width 0.5s ease;
}

.step {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    z-index: 1;
    position: relative;
}

.step-circle {
    width: 44px;
    height: 44px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
    font-weight: 800;
    transition: var(--transition);
    border: 3px solid transparent;
}

.step-circle.completed {
    background: var(--accent-orange);
    color: white;
    box-shadow: 0 4px 12px rgba(255, 122, 0, 0.4);
}

.step-circle.active {
    background: white;
    color: var(--navy-700);
    box-shadow: 0 4px 16px rgba(255,255,255,0.3);
    border-color: var(--accent-orange);
    animation: pulse-checkout 2s infinite;
}

.step-circle.pending {
    background: rgba(255,255,255,0.1);
    color: rgba(255,255,255,0.6);
    border-color: rgba(255,255,255,0.2);
}

@keyframes pulse-checkout {
    0%, 100% { box-shadow: 0 4px 16px rgba(255,255,255,0.3); }
    50% { box-shadow: 0 4px 24px rgba(255, 122, 0, 0.5); }
}

.step-label {
    font-size: 13px;
    font-weight: 700;
    color: rgba(255,255,255,0.7);
}

.step-label.active { color: white; }
.step-label.completed { color: var(--accent-orange); }

/* ================= PAGE WRAPPER ================= */
.page-wrapper {
    max-width: 1200px;
    margin: 0 auto;
    padding: 40px 40px 80px;
}

.page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 32px;
    flex-wrap: wrap;
    gap: 16px;
}

.page-title {
    font-family: 'Fraunces', serif;
    font-size: 32px;
    font-weight: 700;
    color: var(--text-primary);
    letter-spacing: -0.5px;
    margin: 0;
}

.page-title span {
    color: var(--accent-orange);
}

.back-to-cart {
    color: var(--navy-700);
    text-decoration: none;
    font-size: 14px;
    font-weight: 600;
    padding: 10px 18px;
    border-radius: var(--radius-sm);
    background: white;
    border: 1.5px solid var(--border-light);
    transition: var(--transition);
    display: inline-flex;
    align-items: center;
    gap: 8px;
    box-shadow: var(--shadow-sm);
}

.back-to-cart:hover {
    background: var(--navy-700);
    color: white;
    border-color: var(--navy-700);
    transform: translateY(-1px);
    box-shadow: var(--shadow-md);
}

/* ================= CHECKOUT LAYOUT ================= */
.checkout-layout {
    display: grid;
    grid-template-columns: 1fr 400px;
    gap: 32px;
    align-items: start;
}

/* ================= SECTION CARDS ================= */
.section-card {
    background: var(--bg-card);
    border: 1px solid var(--border-light);
    border-radius: var(--radius-lg);
    padding: 28px;
    margin-bottom: 24px;
    box-shadow: var(--shadow-sm);
    transition: var(--transition);
    position: relative;
    overflow: hidden;
}

.section-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 4px;
    background: linear-gradient(90deg, var(--navy-700), var(--accent-orange));
    opacity: 0;
    transition: opacity 0.3s ease;
}

.section-card:hover {
    box-shadow: var(--shadow-md);
    transform: translateY(-2px);
}

.section-card:hover::before {
    opacity: 1;
}

.section-header {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 24px;
    padding-bottom: 16px;
    border-bottom: 2px solid var(--border-light);
}

.section-icon {
    width: 48px;
    height: 48px;
    border-radius: 12px;
    background: linear-gradient(135deg, var(--navy-700), var(--navy-600));
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
    flex-shrink: 0;
    box-shadow: 0 4px 12px rgba(30, 58, 138, 0.25);
}

.section-icon.orange {
    background: linear-gradient(135deg, var(--accent-orange), #ff9a44);
    box-shadow: 0 4px 12px rgba(255, 122, 0, 0.25);
}

.section-icon.green {
    background: linear-gradient(135deg, var(--success), #22c55e);
    box-shadow: 0 4px 12px rgba(22, 163, 74, 0.25);
}

.section-title {
    font-size: 20px;
    font-weight: 800;
    color: var(--text-primary);
}

.section-subtitle {
    font-size: 13px;
    color: var(--text-muted);
    margin-top: 2px;
    font-weight: 500;
}

/* ================= DELIVERY FORM ================= */
.form-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
}

.form-group {
    margin-bottom: 20px;
}

.form-group.full-width {
    grid-column: 1 / -1;
}

.form-label {
    display: block;
    font-size: 13px;
    font-weight: 700;
    color: var(--text-secondary);
    margin-bottom: 8px;
    text-transform: uppercase;
    letter-spacing: 0.3px;
}

.form-label .required {
    color: var(--danger);
    margin-left: 2px;
}

.form-input {
    width: 100%;
    padding: 14px 16px;
    border: 2px solid var(--border-light);
    border-radius: var(--radius-sm);
    font-size: 15px;
    font-family: inherit;
    color: var(--text-primary);
    background: #fafbfc;
    transition: var(--transition);
    outline: none;
}

.form-input::placeholder {
    color: #94a3b8;
    font-weight: 400;
}

.form-input:focus {
    border-color: var(--navy-600);
    background: white;
    box-shadow: 0 0 0 4px rgba(29, 78, 216, 0.08);
}

.form-input:hover {
    border-color: var(--border-medium);
    background: white;
}

.form-input:invalid:not(:placeholder-shown) {
    border-color: var(--danger);
    background: var(--danger-light);
}

textarea.form-input {
    resize: vertical;
    min-height: 90px;
}

/* ================= PAYMENT METHODS ================= */
.payment-methods {
    display: flex;
    flex-direction: column;
    gap: 14px;
}

.payment-option {
    position: relative;
}

.payment-option input[type="radio"] {
    position: absolute;
    opacity: 0;
    width: 0;
    height: 0;
}

.payment-card {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 18px 20px;
    border: 2px solid var(--border-light);
    border-radius: var(--radius-md);
    cursor: pointer;
    transition: var(--transition);
    background: linear-gradient(135deg, #fafbfc, #f8fafc);
    position: relative;
    overflow: hidden;
}

.payment-card::before {
    content: '';
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    width: 4px;
    background: var(--navy-600);
    transform: scaleY(0);
    transition: transform 0.3s ease;
}

.payment-card:hover {
    border-color: var(--border-medium);
    background: white;
    transform: translateX(4px);
    box-shadow: var(--shadow-sm);
}

.payment-option input[type="radio"]:checked + .payment-card {
    border-color: var(--navy-600);
    background: linear-gradient(135deg, rgba(30, 58, 138, 0.04), rgba(29, 78, 216, 0.02));
    box-shadow: 0 4px 16px rgba(30, 58, 138, 0.1);
}

.payment-option input[type="radio"]:checked + .payment-card::before {
    transform: scaleY(1);
}

.payment-radio {
    width: 24px;
    height: 24px;
    border: 2.5px solid var(--border-medium);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    transition: var(--transition);
    background: white;
}

.payment-option input[type="radio"]:checked + .payment-card .payment-radio {
    border-color: var(--navy-600);
    background: var(--navy-600);
}

.payment-radio::after {
    content: '';
    width: 10px;
    height: 10px;
    border-radius: 50%;
    background: white;
    transform: scale(0);
    transition: transform 0.2s ease;
}

.payment-option input[type="radio"]:checked + .payment-card .payment-radio::after {
    transform: scale(1);
}

.payment-icon {
    width: 52px;
    height: 52px;
    border-radius: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 26px;
    flex-shrink: 0;
    transition: transform 0.3s ease;
}

.payment-card:hover .payment-icon {
    transform: scale(1.1) rotate(-5deg);
}

.payment-icon.cod { 
    background: linear-gradient(135deg, var(--success-light), #bbf7d0);
    box-shadow: 0 4px 12px rgba(22, 163, 74, 0.15);
}
.payment-icon.upi { 
    background: linear-gradient(135deg, #dbeafe, #bfdbfe);
    box-shadow: 0 4px 12px rgba(29, 78, 216, 0.15);
}
.payment-icon.card { 
    background: linear-gradient(135deg, #fef3c7, #fde68a);
    box-shadow: 0 4px 12px rgba(245, 158, 11, 0.15);
}

.payment-info {
    flex: 1;
}

.payment-name {
    font-size: 16px;
    font-weight: 800;
    color: var(--text-primary);
}

.payment-desc {
    font-size: 13px;
    color: var(--text-muted);
    margin-top: 3px;
    font-weight: 500;
}

.payment-badge {
    font-size: 11px;
    font-weight: 700;
    padding: 4px 10px;
    border-radius: 20px;
    background: var(--success-light);
    color: var(--success-dark);
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

/* ================= ORDER SUMMARY SIDEBAR ================= */
.summary-sidebar {
    position: sticky;
    top: 88px;
}

.summary-card {
    background: var(--bg-card);
    border: 1px solid var(--border-light);
    border-radius: var(--radius-lg);
    padding: 28px;
    box-shadow: var(--shadow-md);
    position: relative;
    overflow: hidden;
}

.summary-card::after {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 5px;
    background: linear-gradient(90deg, var(--navy-700), var(--accent-orange), var(--success));
}

.summary-card h3 {
    font-size: 20px;
    font-weight: 800;
    color: var(--text-primary);
    margin-bottom: 20px;
    padding-bottom: 16px;
    border-bottom: 2px solid var(--border-light);
    display: flex;
    align-items: center;
    gap: 10px;
}

/* Order Items */
.order-items {
    max-height: 320px;
    overflow-y: auto;
    margin-bottom: 20px;
    padding-right: 4px;
}

.order-item {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 12px 0;
    border-bottom: 1px solid #f1f5f9;
    transition: var(--transition);
}

.order-item:hover {
    background: #fafbfc;
    margin: 0 -12px;
    padding: 12px;
    border-radius: var(--radius-sm);
}

.order-item:last-child {
    border-bottom: none;
}

.order-item-img {
    width: 52px;
    height: 72px;
    object-fit: cover;
    border-radius: 8px;
    border: 2px solid var(--border-light);
    background: linear-gradient(135deg, #f1f5f9, #e2e8f0);
    flex-shrink: 0;
    box-shadow: var(--shadow-sm);
    transition: transform 0.3s ease;
}

.order-item:hover .order-item-img {
    transform: scale(1.05);
}

.order-item-details {
    flex: 1;
    min-width: 0;
}

.order-item-title {
    font-size: 14px;
    font-weight: 700;
    color: var(--text-primary);
    line-height: 1.3;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
}

.order-item-meta {
    font-size: 12px;
    color: var(--text-muted);
    margin-top: 3px;
    font-weight: 500;
}

.order-item-price {
    font-size: 15px;
    font-weight: 800;
    color: var(--navy-700);
    white-space: nowrap;
}

/* Item Count Badge */
.item-count {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 12px;
    background: linear-gradient(135deg, var(--navy-700), var(--navy-600));
    color: white;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 700;
    margin-bottom: 16px;
}

/* Coupon Applied Badge */
.coupon-applied {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 12px 16px;
    background: linear-gradient(135deg, var(--success-light), #f0fdf4);
    border: 2px dashed var(--success);
    border-radius: var(--radius-sm);
    margin-bottom: 20px;
    position: relative;
    overflow: hidden;
}

.coupon-applied::before {
    content: '';
    position: absolute;
    top: -20px;
    right: -20px;
    width: 60px;
    height: 60px;
    background: rgba(22, 163, 74, 0.08);
    border-radius: 50%;
}

.coupon-code {
    font-size: 14px;
    font-weight: 800;
    color: var(--success);
    display: flex;
    align-items: center;
    gap: 6px;
}

.coupon-saving {
    font-size: 13px;
    font-weight: 700;
    color: var(--success);
}

/* Price Breakdown */
.price-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 14px;
    font-size: 15px;
    color: var(--text-secondary);
    font-weight: 500;
}

.price-row .free { 
    color: var(--success); 
    font-weight: 700;
    background: var(--success-light);
    padding: 2px 10px;
    border-radius: 12px;
    font-size: 13px;
}
.price-row .discount { 
    color: var(--success); 
    font-weight: 800;
}

.price-divider {
    height: 2px;
    background: linear-gradient(90deg, var(--border-light), var(--border-medium), var(--border-light));
    margin: 18px 0;
    border-radius: 1px;
}

.price-row.total {
    font-size: 20px;
    font-weight: 900;
    color: var(--text-primary);
    margin-bottom: 24px;
}

.price-row.total span:last-child {
    color: var(--navy-700);
    font-size: 26px;
    background: linear-gradient(135deg, var(--navy-700), var(--navy-600));
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

/* Savings Badge */
.savings-badge {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 14px;
    background: linear-gradient(135deg, #fef3c7, #fde68a, #fcd34d);
    border-radius: var(--radius-sm);
    margin-bottom: 24px;
    font-size: 14px;
    font-weight: 800;
    color: #92400e;
    box-shadow: 0 2px 8px rgba(245, 158, 11, 0.15);
    animation: shimmer 3s infinite;
}

@keyframes shimmer {
    0%, 100% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
}

/* Place Order Button */
.btn-place-order {
    display: block;
    width: 100%;
    padding: 18px 28px;
    background: linear-gradient(135deg, var(--success), #059669, #047857);
    background-size: 200% 200%;
    color: #ffffff;
    border: none;
    border-radius: var(--radius-lg);
    font-weight: 900;
    font-size: 17px;
    text-align: center;
    transition: var(--transition);
    box-shadow: 0 6px 20px rgba(22, 163, 74, 0.3);
    cursor: pointer;
    font-family: inherit;
    letter-spacing: 0.3px;
    position: relative;
    overflow: hidden;
}

.btn-place-order::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
    transition: left 0.5s ease;
}

.btn-place-order:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 30px rgba(22, 163, 74, 0.4);
}

.btn-place-order:hover::before {
    left: 100%;
}

.btn-place-order:active {
    transform: translateY(-1px) scale(0.98);
}

/* Secure Badge */
.secure-checkout-badge {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    margin-top: 18px;
    font-size: 13px;
    color: var(--text-muted);
    font-weight: 600;
    padding: 10px;
    background: #f8fafc;
    border-radius: var(--radius-sm);
}

/* Trust Badges */
.trust-badges {
    display: flex;
    justify-content: center;
    gap: 16px;
    margin-top: 20px;
    padding-top: 20px;
    border-top: 2px dashed var(--border-light);
}

.trust-badge {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 12px;
    color: var(--text-muted);
    font-weight: 600;
    padding: 8px 12px;
    background: #f8fafc;
    border-radius: 20px;
    border: 1px solid var(--border-light);
    transition: var(--transition);
}

.trust-badge:hover {
    background: var(--navy-700);
    color: white;
    border-color: var(--navy-700);
    transform: translateY(-2px);
}

.trust-badge span {
    font-size: 16px;
}

/* ================= TOAST NOTIFICATIONS ================= */
.toast-container {
    position: fixed;
    bottom: 24px;
    right: 24px;
    z-index: 9999;
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.toast {
    background: var(--bg-card);
    border-left: 4px solid var(--success);
    padding: 16px 20px;
    border-radius: var(--radius-md);
    box-shadow: var(--shadow-hover);
    display: flex;
    align-items: center;
    gap: 12px;
    min-width: 280px;
    animation: toastIn 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    font-size: 14px;
    font-weight: 600;
    color: var(--text-primary);
}

.toast.error { border-left-color: #ef4444; }

@keyframes toastIn {
    from { transform: translateX(100%); opacity: 0; }
    to { transform: translateX(0); opacity: 1; }
}

.toast-exit {
    animation: toastOut 0.3s cubic-bezier(0.4, 0, 0.2, 1) forwards;
}

@keyframes toastOut {
    to { transform: translateX(100%); opacity: 0; }
}

/* ================= RESPONSIVE ================= */
@media (max-width: 1024px) {
    .checkout-layout {
        grid-template-columns: 1fr;
    }
    .summary-sidebar {
        position: static;
        max-width: 500px;
        margin: 0 auto;
    }
}

@media (max-width: 768px) {
    .navbar { padding: 14px 20px; }
    .progress-container { padding: 20px 20px; }
    .page-wrapper { padding: 24px 20px 60px; }
    .page-title { font-size: 26px; }
    .section-card { padding: 20px; }
    .form-row { grid-template-columns: 1fr; }
    .trust-badges { flex-wrap: wrap; gap: 10px; }
    .payment-card { padding: 14px 16px; }
}

@media (max-width: 480px) {
    .page-wrapper { padding: 20px 16px 40px; }
    .page-title { font-size: 22px; }
    .payment-icon { width: 44px; height: 44px; font-size: 20px; }
    .btn-place-order { padding: 16px 20px; font-size: 15px; }
    .section-icon { width: 40px; height: 40px; font-size: 18px; }
}
</style>
</head>

<body>

<!-- ================= NAVBAR (Same as Cart Page) ================= -->
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

<!-- ================= PROGRESS STEPS ================= -->
<div class="progress-container">
    <div class="progress-steps">
        <div class="progress-line-fill"></div>

        <div class="step">
            <div class="step-circle completed">&#10003;</div>
            <span class="step-label completed">Cart</span>
        </div>

        <div class="step">
            <div class="step-circle active">2</div>
            <span class="step-label active">Checkout</span>
        </div>

        <div class="step">
            <div class="step-circle pending">3</div>
            <span class="step-label">Confirmation</span>
        </div>
    </div>
</div>

<!-- ================= MAIN CONTENT ================= -->
<div class="page-wrapper">

    <div class="page-header">
        <h1 class="page-title">Secure <span>Checkout</span></h1>
        <a href="<%= request.getContextPath() %>/cart" class="back-to-cart">
            &#8592; Back to Cart
        </a>
    </div>

    <div class="checkout-layout">

        <!-- LEFT: Forms -->
        <div class="checkout-forms">

            <form action="<%= request.getContextPath() %>/checkout" method="post" id="checkoutForm">

                <!-- Delivery Address Section -->
                <div class="section-card">
                    <div class="section-header">
                        <div class="section-icon orange">&#127968;</div>
                        <div>
                            <div class="section-title">Delivery Address</div>
                            <div class="section-subtitle">Your saved shipping details</div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Full Name <span class="required">*</span></label>
                            <input type="text" name="fullName" class="form-input" placeholder="Enter your full name" 
                                   value="<%= userFullName %>" required autocomplete="name">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Phone Number <span class="required">*</span></label>
                            <input type="tel" name="phone" class="form-input" placeholder="+91 98765 43210" 
                                   value="<%= userPhone %>" required autocomplete="tel" pattern="[0-9+\s]{10,15}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Address <span class="required">*</span></label>
                        <textarea name="address" class="form-input" placeholder="House no, Street, Landmark, Area..." 
                                  required autocomplete="street-address"><%= userAddress %></textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">City <span class="required">*</span></label>
                            <input type="text" name="city" class="form-input" placeholder="Mumbai" 
                                   value="<%= userCity %>" required autocomplete="address-level2">
                        </div>
                        <div class="form-group">
                            <label class="form-label">State <span class="required">*</span></label>
                            <input type="text" name="state" class="form-input" placeholder="Maharashtra" 
                                   value="<%= userState %>" required autocomplete="address-level1">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Pincode <span class="required">*</span></label>
                            <input type="text" name="pincode" class="form-input" placeholder="400001" 
                                   value="<%= userPincode %>" required autocomplete="postal-code" pattern="[0-9]{6}">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Country</label>
                            <input type="text" name="country" class="form-input" value="India" 
                                   readonly style="background: #f1f5f9; color: var(--text-muted); font-weight: 600;">
                        </div>
                    </div>
                </div>

                <!-- Payment Method Section -->
                <div class="section-card">
                    <div class="section-header">
                        <div class="section-icon green">&#128179;</div>
                        <div>
                            <div class="section-title">Payment Method</div>
                            <div class="section-subtitle">Choose how you want to pay</div>
                        </div>
                    </div>

                    <div class="payment-methods">
                        <label class="payment-option">
                            <input type="radio" name="paymentMethod" value="COD" checked>
                            <div class="payment-card">
                                <div class="payment-radio"></div>
                                <div class="payment-icon cod">&#128666;</div>
                                <div class="payment-info">
                                    <div class="payment-name">Cash on Delivery</div>
                                    <div class="payment-desc">Pay when you receive your order</div>
                                </div>
                                <span class="payment-badge">Popular</span>
                            </div>
                        </label>

                        <label class="payment-option">
                            <input type="radio" name="paymentMethod" value="UPI">
                            <div class="payment-card">
                                <div class="payment-radio"></div>
                                <div class="payment-icon upi">&#128241;</div>
                                <div class="payment-info">
                                    <div class="payment-name">UPI / GPay / PhonePe</div>
                                    <div class="payment-desc">Fast and secure UPI payment</div>
                                </div>
                            </div>
                        </label>

                        <label class="payment-option">
                            <input type="radio" name="paymentMethod" value="CARD">
                            <div class="payment-card">
                                <div class="payment-radio"></div>
                                <div class="payment-icon card">&#128179;</div>
                                <div class="payment-info">
                                    <div class="payment-name">Credit / Debit Card</div>
                                    <div class="payment-desc">Visa, Mastercard, RuPay</div>
                                </div>
                            </div>
                        </label>
                    </div>
                </div>

            </form>

        </div>

        <!-- RIGHT: Order Summary -->
        <div class="summary-sidebar">
            <div class="summary-card">
                <h3>&#128722; Order Summary</h3>

                <div class="item-count">
                    <span>&#128218;</span> <%= totalItems %> item<%= totalItems > 1 ? "s" : "" %> in cart
                </div>

                <!-- Order Items -->
                <div class="order-items">
                    <% for (CartItem item : cart) { %>
                    <div class="order-item">
                        <img src="<%= request.getContextPath() + "/assets/" + item.getBook().getImageUrl() %>" 
                             alt="<%= item.getBook().getTitle() %>" class="order-item-img">
                        <div class="order-item-details">
                            <div class="order-item-title"><%= item.getBook().getTitle() %></div>
                            <div class="order-item-meta">Qty: <%= item.getQuantity() %> x &#8377;<%= String.format("%.0f", item.getBook().getPrice()) %></div>
                        </div>
                        <div class="order-item-price">&#8377; <%= String.format("%.2f", item.getBook().getPrice() * item.getQuantity()) %></div>
                    </div>
                    <% } %>
                </div>

                <% if (discountAmount > 0) { %>
                <!-- Coupon Applied -->
                <div class="coupon-applied">
                    <span class="coupon-code">&#127873; <%= appliedCoupon %></span>
                    <span class="coupon-saving">-&#8377;<%= String.format("%.2f", discountAmount) %></span>
                </div>
                <% } %>

                <!-- Price Breakdown -->
                <div class="price-row">
                    <span>Subtotal</span>
                    <span>&#8377; <%= String.format("%.2f", subtotal) %></span>
                </div>
                <div class="price-row">
                    <span>Shipping</span>
                    <span class="free">FREE</span>
                </div>
                <% if (discountAmount > 0) { %>
                <div class="price-row">
                    <span>Discount</span>
                    <span class="discount">-&#8377; <%= String.format("%.2f", discountAmount) %></span>
                </div>
                <% } %>

                <div class="price-divider"></div>

                <div class="price-row total">
                    <span>Grand Total</span>
                    <span>&#8377; <%= String.format("%.2f", grandTotal) %></span>
                </div>

                <% if (discountAmount > 0) { %>
                <div class="savings-badge">
                    <span>&#127881;</span> You saved &#8377;<%= String.format("%.2f", discountAmount) %> on this order!
                </div>
                <% } %>

                <button type="submit" form="checkoutForm" class="btn-place-order">
                    &#128504; Place Order Securely
                </button>

                <div class="secure-checkout-badge">
                    <span>&#128274;</span> Secure SSL Encrypted Checkout
                </div>

                <div class="trust-badges">
                    <div class="trust-badge">
                        <span>&#9989;</span> Genuine
                    </div>
                    <div class="trust-badge">
                        <span>&#128666;</span> Free Ship
                    </div>
                    <div class="trust-badge">
                        <span>&#128260;</span> Returns
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<!-- Toast Container -->
<div class="toast-container" id="toastContainer"></div>

<script>
// Form validation
document.getElementById('checkoutForm').addEventListener('submit', function(e) {
    var phone = document.querySelector('input[name="phone"]').value;
    var pincode = document.querySelector('input[name="pincode"]').value;

    if (!/^\d{6}$/.test(pincode.replace(/\s/g, ''))) {
        e.preventDefault();
        showToast('Please enter a valid 6-digit pincode', 'error');
        return false;
    }

    if (phone.replace(/\D/g, '').length < 10) {
        e.preventDefault();
        showToast('Please enter a valid phone number', 'error');
        return false;
    }
});

// Toast notifications
function showToast(message, type) {
    var container = document.getElementById('toastContainer');
    var toast = document.createElement('div');
    toast.className = 'toast ' + (type || '');
    var icons = { success: '&#10004;', error: '&#10008;', info: '&#8505;' };
    toast.innerHTML = '<span>' + (icons[type] || '&#10004;') + '</span> ' + message;
    container.appendChild(toast);

    setTimeout(function() {
        toast.classList.add('toast-exit');
        setTimeout(function() { toast.remove(); }, 300);
    }, 3000);
}
</script>

</body>
</html>