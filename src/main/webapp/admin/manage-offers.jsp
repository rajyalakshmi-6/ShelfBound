<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.shelfbound.model.Offer"%>

<%
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null || adminSession.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/adminLogin");
        return;
    }

    List<Offer> offers = (List<Offer>) request.getAttribute("offers");
    String success = request.getParameter("success");
    String error = request.getParameter("error");

    int totalOffers = offers != null ? offers.size() : 0;
    int activeOffers = 0;
    double maxDiscount = 0.0;

    if (offers != null) {
        for (Offer o : offers) {
            if (o.isActive()) {
                activeOffers++;
            }
            if (o.getDiscountPercentage() > maxDiscount) {
                maxDiscount = o.getDiscountPercentage();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Offers &amp; Coupons - ShelfBound Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

body {
    background: 
        radial-gradient(1100px circle at 15% 10%, rgba(30, 58, 138, 0.08), transparent 45%),
        radial-gradient(900px circle at 85% 25%, rgba(255, 122, 0, 0.06), transparent 50%),
        radial-gradient(1200px circle at 50% 80%, rgba(30, 58, 138, 0.05), transparent 60%),
        #f8fafc;
    min-height: 100vh;
    color: #0f172a;
    padding: 30px 24px;
    -webkit-font-smoothing: antialiased;
}

.container {
    max-width: 1240px;
    margin: 0 auto;
}

/* TOP NAV */
.top-nav {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
}

.back-btn {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: rgba(15, 23, 42, 0.9);
    color: #ffffff;
    text-decoration: none;
    padding: 10px 18px;
    border-radius: 12px;
    font-size: 13.5px;
    font-weight: 600;
    box-shadow: 0 4px 14px rgba(15, 23, 42, 0.15);
    transition: all 0.2s ease;
}

.back-btn:hover {
    background: #1e3a8a;
    transform: translateY(-1px);
}

.page-title {
    font-size: 26px;
    font-weight: 800;
    letter-spacing: -0.5px;
    color: #0f172a;
    margin-bottom: 6px;
}

.page-subtitle {
    font-size: 14px;
    color: #64748b;
    margin-bottom: 24px;
}

/* METRICS */
.metrics-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 16px;
    margin-bottom: 28px;
}

.metric-card {
    background: rgba(255, 255, 255, 0.85);
    backdrop-filter: blur(14px);
    border: 1px solid rgba(226, 232, 240, 0.85);
    border-radius: 16px;
    padding: 18px 22px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
}

.metric-label {
    font-size: 12.5px;
    font-weight: 700;
    color: #64748b;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 6px;
}

.metric-val {
    font-size: 28px;
    font-weight: 800;
    color: #0f172a;
}

.metric-val.green { color: #10b981; }
.metric-val.orange { color: #ff7a00; }

/* CONTROLS BAR */
.controls-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 16px;
    margin-bottom: 20px;
    flex-wrap: wrap;
}

.search-input {
    width: 320px;
    padding: 12px 18px;
    border-radius: 12px;
    border: 1.5px solid #cbd5e1;
    background: #ffffff;
    font-size: 14px;
    color: #0f172a;
    outline: none;
    transition: all 0.2s ease;
}

.search-input:focus {
    border-color: #ff7a00;
    box-shadow: 0 0 0 3px rgba(255, 122, 0, 0.15);
}

.btn-add-offer {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: linear-gradient(135deg, #1e3a8a, #ff7a00);
    color: #ffffff;
    border: none;
    padding: 12px 24px;
    border-radius: 12px;
    font-size: 14px;
    font-weight: 700;
    cursor: pointer;
    box-shadow: 0 4px 16px rgba(255, 122, 0, 0.25);
    transition: all 0.25s ease;
}

.btn-add-offer:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 24px rgba(255, 122, 0, 0.35);
}

/* TABLE WRAPPER */
.table-card {
    background: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(16px);
    border: 1px solid rgba(226, 232, 240, 0.9);
    border-radius: 18px;
    box-shadow: 0 8px 30px rgba(15, 23, 42, 0.05);
    overflow: hidden;
}

.table-wrapper {
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
}

table {
    width: 100%;
    min-width: 800px;
    border-collapse: collapse;
    text-align: left;
}

thead {
    background: #f1f5f9;
    border-bottom: 1.5px solid #e2e8f0;
}

th {
    padding: 14px 20px;
    font-size: 12px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: #475569;
}

td {
    padding: 16px 20px;
    font-size: 14px;
    color: #1e293b;
    border-bottom: 1px solid #f1f5f9;
    vertical-align: middle;
}

tbody tr:hover {
    background: rgba(248, 250, 252, 0.8);
}

/* BADGES */
.code-pill {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    background: #eff6ff;
    color: #1e3a8a;
    border: 1px dashed #60a5fa;
    padding: 4px 12px;
    border-radius: 8px;
    font-family: 'Courier New', Courier, monospace;
    font-weight: 800;
    font-size: 14px;
    letter-spacing: 0.5px;
}

.discount-badge {
    display: inline-block;
    background: #dcfce7;
    color: #15803d;
    font-weight: 800;
    font-size: 13px;
    padding: 4px 10px;
    border-radius: 999px;
}

.status-pill {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 12px;
    font-weight: 700;
    padding: 4px 12px;
    border-radius: 999px;
    text-transform: uppercase;
    letter-spacing: 0.3px;
}

.status-active {
    background: #dcfce7;
    color: #15803d;
}

.status-active::before {
    content: "";
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: #16a34a;
}

.status-inactive {
    background: #fee2e2;
    color: #b91c1c;
}

.status-inactive::before {
    content: "";
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: #dc2626;
}

/* ACTIONS */
.action-btns {
    display: flex;
    align-items: center;
    gap: 8px;
}

.btn-toggle {
    padding: 7px 14px;
    border-radius: 8px;
    font-size: 12px;
    font-weight: 700;
    border: none;
    cursor: pointer;
    transition: all 0.2s ease;
}

.btn-toggle.pause {
    background: #f1f5f9;
    color: #475569;
    border: 1px solid #cbd5e1;
}

.btn-toggle.pause:hover {
    background: #e2e8f0;
    color: #0f172a;
}

.btn-toggle.activate {
    background: #dcfce7;
    color: #15803d;
    border: 1px solid #86efac;
}

.btn-toggle.activate:hover {
    background: #bbf7d0;
}

.btn-delete {
    padding: 7px 12px;
    border-radius: 8px;
    font-size: 12px;
    font-weight: 700;
    background: #fef2f2;
    color: #dc2626;
    border: 1px solid #fecaca;
    cursor: pointer;
    transition: all 0.2s ease;
}

.btn-delete:hover {
    background: #dc2626;
    color: #ffffff;
    border-color: #dc2626;
}

.btn-edit {
    padding: 7px 13px;
    border-radius: 8px;
    font-size: 12px;
    font-weight: 700;
    background: #eff6ff;
    color: #1d4ed8;
    border: 1px solid #bfdbfe;
    cursor: pointer;
    transition: all 0.2s ease;
    display: inline-flex;
    align-items: center;
    gap: 4px;
}

.btn-edit:hover {
    background: #1d4ed8;
    color: #ffffff;
    border-color: #1d4ed8;
}

/* TOAST */
.toast {
    position: fixed;
    top: 24px;
    right: 24px;
    padding: 14px 22px;
    border-radius: 12px;
    font-size: 14px;
    font-weight: 600;
    box-shadow: 0 10px 30px rgba(0,0,0,0.15);
    z-index: 9999;
    display: flex;
    align-items: center;
    gap: 10px;
    animation: slideIn 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

.toast-success {
    background: #10b981;
    color: #ffffff;
}

.toast-error {
    background: #ef4444;
    color: #ffffff;
}

@keyframes slideIn {
    from { transform: translateX(100%); opacity: 0; }
    to { transform: translateX(0); opacity: 1; }
}

/* ================= MODAL ================= */
.modal-overlay {
    position: fixed;
    inset: 0;
    background: rgba(15, 23, 42, 0.6);
    backdrop-filter: blur(8px);
    -webkit-backdrop-filter: blur(8px);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 10000;
    opacity: 0;
    pointer-events: none;
    transition: opacity 0.25s ease;
    padding: 20px;
}

.modal-overlay.open {
    opacity: 1;
    pointer-events: auto;
}

.modal-card {
    background: #ffffff;
    border-radius: 20px;
    width: 100%;
    max-width: 520px;
    box-shadow: 0 25px 50px -12px rgba(15, 23, 42, 0.25);
    border: 1px solid rgba(226, 232, 240, 0.9);
    transform: scale(0.95) translateY(10px);
    transition: transform 0.25s cubic-bezier(0.16, 1, 0.3, 1);
    overflow: hidden;
}

.modal-overlay.open .modal-card {
    transform: scale(1) translateY(0);
}

.modal-header {
    padding: 20px 24px;
    border-bottom: 1px solid #e2e8f0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #f8fafc;
}

.modal-title {
    font-size: 18px;
    font-weight: 800;
    color: #0f172a;
    display: flex;
    align-items: center;
    gap: 8px;
}

.modal-close {
    background: transparent;
    border: none;
    font-size: 20px;
    color: #64748b;
    cursor: pointer;
    padding: 4px 8px;
    border-radius: 8px;
    transition: all 0.2s ease;
}

.modal-close:hover {
    color: #0f172a;
    background: #e2e8f0;
}

.modal-body {
    padding: 24px;
}

.form-group {
    margin-bottom: 18px;
}

.form-group label {
    display: block;
    font-size: 13px;
    font-weight: 700;
    color: #334155;
    margin-bottom: 6px;
}

.form-group input, .form-group select {
    width: 100%;
    padding: 11px 14px;
    border: 1.5px solid #cbd5e1;
    border-radius: 10px;
    font-size: 14px;
    color: #0f172a;
    outline: none;
    transition: border-color 0.2s ease, box-shadow 0.2s ease;
    background: #ffffff;
}

.form-group input:focus, .form-group select:focus {
    border-color: #ff7a00;
    box-shadow: 0 0 0 3px rgba(255, 122, 0, 0.15);
}

.form-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 14px;
}

.modal-footer {
    padding: 16px 24px;
    border-top: 1px solid #e2e8f0;
    background: #f8fafc;
    display: flex;
    justify-content: flex-end;
    gap: 12px;
}

.btn-secondary {
    background: #e2e8f0;
    color: #334155;
    border: none;
    padding: 10px 18px;
    border-radius: 10px;
    font-size: 13.5px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
}

.btn-secondary:hover {
    background: #cbd5e1;
}

.btn-primary {
    background: linear-gradient(135deg, #1e3a8a, #ff7a00);
    color: #ffffff;
    border: none;
    padding: 10px 22px;
    border-radius: 10px;
    font-size: 13.5px;
    font-weight: 700;
    cursor: pointer;
    box-shadow: 0 4px 14px rgba(255, 122, 0, 0.25);
    transition: all 0.2s ease;
}

.btn-primary:hover {
    transform: translateY(-1px);
    box-shadow: 0 6px 18px rgba(255, 122, 0, 0.35);
}

.empty-state {
    text-align: center;
    padding: 60px 20px;
    color: #64748b;
}

.empty-state-icon {
    font-size: 48px;
    margin-bottom: 12px;
}
</style>
</head>
<body>

<% if (success != null && !success.trim().isEmpty()) { %>
    <div class="toast toast-success" id="toast">
        <span>✔</span> <%= success %>
    </div>
<% } else if (error != null && !error.trim().isEmpty()) { %>
    <div class="toast toast-error" id="toast">
        <span>✖</span> <%= error %>
    </div>
<% } %>

<div class="container">

    <!-- TOP NAVIGATION -->
    <div class="top-nav">
        <a href="<%= request.getContextPath() %>/adminDashboard" class="back-btn">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <path d="M19 12H5M12 19l-7-7 7-7"/>
            </svg>
            Dashboard
        </a>
        <div style="font-size: 13px; font-weight: 700; color: #64748b;">
            ShelfBound Admin Portal
        </div>
    </div>

    <h1 class="page-title">Manage Offers &amp; Coupons</h1>
    <p class="page-subtitle">Configure discount percentages, minimum order values, and promotional codes for customer checkouts.</p>

    <!-- METRICS -->
    <div class="metrics-grid">
        <div class="metric-card">
            <div class="metric-label">Total Offers</div>
            <div class="metric-val"><%= totalOffers %></div>
        </div>
        <div class="metric-card">
            <div class="metric-label">Active Offers</div>
            <div class="metric-val green"><%= activeOffers %></div>
        </div>
        <div class="metric-card">
            <div class="metric-label">Highest Discount</div>
            <div class="metric-val orange"><%= String.format("%.0f", maxDiscount) %>% OFF</div>
        </div>
    </div>

    <!-- CONTROLS & ADD OFFER BUTTON -->
    <div class="controls-bar">
        <input type="text" id="offerSearch" class="search-input" placeholder="Search by coupon code or description..." onkeyup="filterOffers()">
        <button type="button" class="btn-add-offer" onclick="openAddModal()">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <line x1="12" y1="5" x2="12" y2="19"></line>
                <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
            Add New Offer
        </button>
    </div>

    <!-- TABLE -->
    <div class="table-card">
        <div class="table-wrapper">
            <table id="offersTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Coupon Code</th>
                        <th>Discount</th>
                        <th>Min Order</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (offers != null && !offers.isEmpty()) {
                            for (Offer o : offers) {
                    %>
                    <tr class="offer-row">
                        <td style="font-weight: 700; color: #64748b;">#<%= o.getOfferId() %></td>
                        <td>
                            <span class="code-pill">
                                🎟️ <%= o.getCouponCode() %>
                            </span>
                        </td>
                        <td>
                            <span class="discount-badge">
                                <%= String.format("%.0f", o.getDiscountPercentage()) %>% OFF
                            </span>
                        </td>
                        <td style="font-weight: 600;">
                            <% if (o.getMinOrderAmount() > 0) { %>
                                &#8377;<%= String.format("%.2f", o.getMinOrderAmount()) %>
                            <% } else { %>
                                <span style="color: #64748b; font-size: 13px;">No minimum</span>
                            <% } %>
                        </td>
                        <td style="color: #475569; max-width: 280px;"><%= o.getDescription() != null && !o.getDescription().isEmpty() ? o.getDescription() : "-" %></td>
                        <td>
                            <span class="status-pill <%= o.isActive() ? "status-active" : "status-inactive" %>">
                                <%= o.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <div class="action-btns">
                                <!-- Status Toggle Form -->
                                <form action="<%= request.getContextPath() %>/adminOffer" method="POST" style="display:inline;">
                                    <input type="hidden" name="action" value="toggle">
                                    <input type="hidden" name="offerId" value="<%= o.getOfferId() %>">
                                    <input type="hidden" name="status" value="<%= o.isActive() ? "INACTIVE" : "ACTIVE" %>">
                                    <% if (o.isActive()) { %>
                                        <button type="submit" class="btn-toggle pause" title="Pause this offer">Deactivate</button>
                                    <% } else { %>
                                        <button type="submit" class="btn-toggle activate" title="Activate this offer">Activate</button>
                                    <% } %>
                                </form>

                                <!-- Edit Button -->
                                <button type="button" class="btn-edit" title="Edit this offer"
                                        onclick="openEditModal(<%= o.getOfferId() %>, '<%= o.getCouponCode() %>', <%= o.getDiscountPercentage() %>, <%= o.getMinOrderAmount() %>, '<%= o.getDescription() != null ? o.getDescription().replace("'", "\\'").replace("\"", "&quot;") : "" %>', '<%= o.getStatus() %>')">
                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                    </svg>
                                    Edit
                                </button>

                                <!-- Delete Form -->
                                <form action="<%= request.getContextPath() %>/adminOffer" method="POST" style="display:inline;" onsubmit="return confirmDelete('<%= o.getCouponCode() %>');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="offerId" value="<%= o.getOfferId() %>">
                                    <button type="submit" class="btn-delete" title="Delete this coupon">
                                        Delete
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="7">
                            <div class="empty-state">
                                <div class="empty-state-icon">🏷️</div>
                                <h3>No Promotional Offers Found</h3>
                                <p style="margin-top: 6px;">Click the "Add New Offer" button above to create your first coupon.</p>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<!-- ================= ADD OFFER MODAL ================= -->
<div class="modal-overlay" id="addOfferModal">
    <div class="modal-card">
        <div class="modal-header">
            <div class="modal-title">
                <span>🏷️</span> Create Promotional Offer
            </div>
            <button type="button" class="modal-close" onclick="closeAddModal()">&times;</button>
        </div>
        <form action="<%= request.getContextPath() %>/adminOffer" method="POST" id="addOfferForm">
            <input type="hidden" name="action" value="add">
            <div class="modal-body">
                <div class="form-group">
                    <label for="couponCode">Coupon Code *</label>
                    <input type="text" id="couponCode" name="couponCode" placeholder="e.g. SUMMER25, FESTIVE40" required
                           style="text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px;"
                           oninput="this.value = this.value.toUpperCase().replace(/[^A-Z0-9_-]/g, '')">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="discountPercentage">Discount Percentage (%) *</label>
                        <input type="number" id="discountPercentage" name="discountPercentage" min="1" max="100" step="0.5" placeholder="e.g. 25" required>
                    </div>

                    <div class="form-group">
                        <label for="minOrderAmount">Min Order (&#8377;)</label>
                        <input type="number" id="minOrderAmount" name="minOrderAmount" min="0" step="1" value="0" placeholder="0 for no minimum">
                    </div>
                </div>

                <div class="form-group">
                    <label for="description">Offer Description</label>
                    <input type="text" id="description" name="description" placeholder="e.g. Flat 25% OFF on all bestsellers">
                </div>

                <div class="form-group">
                    <label for="status">Initial Status</label>
                    <select id="status" name="status">
                        <option value="ACTIVE" selected>ACTIVE (Available immediately)</option>
                        <option value="INACTIVE">INACTIVE (Save as draft)</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeAddModal()">Cancel</button>
                <button type="submit" class="btn-primary">Create Offer</button>
            </div>
        </form>
    </div>
</div>

<!-- ================= EDIT OFFER MODAL ================= -->
<div class="modal-overlay" id="editOfferModal">
    <div class="modal-card">
        <div class="modal-header">
            <div class="modal-title">
                <span>✏️</span> Edit Promotional Offer
            </div>
            <button type="button" class="modal-close" onclick="closeEditModal()">&times;</button>
        </div>
        <form action="<%= request.getContextPath() %>/adminOffer" method="POST" id="editOfferForm">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="offerId" id="editOfferId">
            <div class="modal-body">
                <div class="form-group">
                    <label for="editCouponCode">Coupon Code *</label>
                    <input type="text" id="editCouponCode" name="couponCode" placeholder="e.g. SUMMER25" required
                           style="text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px;"
                           oninput="this.value = this.value.toUpperCase().replace(/[^A-Z0-9_-]/g, '')">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="editDiscountPercentage">Discount Percentage (%) *</label>
                        <input type="number" id="editDiscountPercentage" name="discountPercentage" min="1" max="100" step="0.5" placeholder="e.g. 25" required>
                    </div>

                    <div class="form-group">
                        <label for="editMinOrderAmount">Min Order (&#8377;)</label>
                        <input type="number" id="editMinOrderAmount" name="minOrderAmount" min="0" step="1" value="0" placeholder="0 for no minimum">
                    </div>
                </div>

                <div class="form-group">
                    <label for="editDescription">Offer Description</label>
                    <input type="text" id="editDescription" name="description" placeholder="e.g. Flat 25% OFF on all bestsellers">
                </div>

                <div class="form-group">
                    <label for="editStatus">Status</label>
                    <select id="editStatus" name="status">
                        <option value="ACTIVE">ACTIVE (Available for customers)</option>
                        <option value="INACTIVE">INACTIVE (Disabled)</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeEditModal()">Cancel</button>
                <button type="submit" class="btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<script>
function openAddModal() {
    document.getElementById('addOfferModal').classList.add('open');
    document.getElementById('couponCode').focus();
}

function closeAddModal() {
    document.getElementById('addOfferModal').classList.remove('open');
}

// Close add modal on click outside card
document.getElementById('addOfferModal').addEventListener('click', function(e) {
    if (e.target === this) {
        closeAddModal();
    }
});

// Edit Modal
function openEditModal(id, code, discount, minOrder, desc, status) {
    document.getElementById('editOfferId').value = id;
    document.getElementById('editCouponCode').value = code;
    document.getElementById('editDiscountPercentage').value = discount;
    document.getElementById('editMinOrderAmount').value = minOrder;
    document.getElementById('editDescription').value = desc || '';
    document.getElementById('editStatus').value = status;
    document.getElementById('editOfferModal').classList.add('open');
    document.getElementById('editCouponCode').focus();
}

function closeEditModal() {
    document.getElementById('editOfferModal').classList.remove('open');
}

// Close edit modal on click outside card
document.getElementById('editOfferModal').addEventListener('click', function(e) {
    if (e.target === this) {
        closeEditModal();
    }
});

// Close modal on Escape
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeAddModal();
        closeEditModal();
    }
});

// Confirm deletion
function confirmDelete(code) {
    return confirm("Are you sure you want to delete coupon '" + code + "'?\nThis action cannot be undone.");
}

// Live search filter
function filterOffers() {
    var query = document.getElementById('offerSearch').value.toLowerCase();
    var rows = document.querySelectorAll('.offer-row');
    rows.forEach(function(row) {
        var text = row.textContent.toLowerCase();
        row.style.display = text.indexOf(query) > -1 ? '' : 'none';
    });
}

// Auto-hide toast
var toast = document.getElementById('toast');
if (toast) {
    setTimeout(function() {
        toast.style.opacity = '0';
        toast.style.transform = 'translateX(100%)';
        toast.style.transition = 'all 0.3s ease';
        setTimeout(function() { toast.remove(); }, 300);
    }, 3500);
}
</script>

</body>
</html>