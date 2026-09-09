<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.shelfbound.model.CartItem" %>
<%@ page import="com.shelfbound.model.Offer" %>
<%@ page import="com.shelfbound.dao.OfferDAO" %>
<%@ page import="com.shelfbound.daoimpl.OfferDAOImpl" %>

<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    String username = (String) session.getAttribute("username");
    double grandTotal = 0;
    double discountAmount = 0;

    OfferDAO cartOfferDAO = new OfferDAOImpl();
    List<Offer> activeOffers = cartOfferDAO.getActiveOffers();

    // ============================================
    // COUPON STATE - Read from session
    // ============================================
    String appliedCoupon = (String) session.getAttribute("appliedCoupon");
    if (appliedCoupon == null) appliedCoupon = "";

    String couponError = (String) session.getAttribute("couponError");
    if (couponError == null) couponError = "";

    /* ========== CHANGED: HANDLE COUPON AJAX DIRECTLY IN JSP ========== */
    String couponAction = request.getParameter("couponAction");
    String couponInput  = request.getParameter("couponInput");

    if ("apply".equals(couponAction) && couponInput != null && !couponInput.trim().isEmpty()) {
        String code = couponInput.trim().toUpperCase();
        if ("WELCOME20".equals(code)) {
            session.setAttribute("appliedCoupon", code);
            session.removeAttribute("couponError");
            appliedCoupon = code; // update for current render
            couponError = "";
        } else {
            session.setAttribute("couponError", "Invalid coupon code");
            session.removeAttribute("appliedCoupon");
            appliedCoupon = "";
            couponError = "Invalid coupon code";
        }
    } else if ("clear".equals(couponAction)) {
        session.removeAttribute("appliedCoupon");
        session.removeAttribute("couponError");
        appliedCoupon = "";
        couponError = "";
    }
    /* ========== END CHANGE ========== */
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Your Cart - ShelfBound</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/cart.css">
<style>
/* Offers Pop-up Modal (Middle of Page) */
.offers-modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(15, 23, 42, 0.65);
    backdrop-filter: blur(6px);
    -webkit-backdrop-filter: blur(6px);
    z-index: 10000;
    display: none;
    align-items: center;
    justify-content: center;
    padding: 18px;
    box-sizing: border-box;
}

.offers-modal-overlay.open {
    display: flex;
}

.offers-modal-box {
    background: #ffffff;
    width: 100%;
    max-width: 520px;
    max-height: 85vh;
    border-radius: 20px;
    box-shadow: 0 25px 50px -12px rgba(15, 23, 42, 0.35);
    display: flex;
    flex-direction: column;
    overflow: hidden;
    animation: modalPop 0.28s cubic-bezier(0.16, 1, 0.3, 1);
}

@keyframes modalPop {
    from {
        opacity: 0;
        transform: scale(0.93) translateY(12px);
    }
    to {
        opacity: 1;
        transform: scale(1) translateY(0);
    }
}

.offers-modal-header {
    padding: 18px 22px;
    background: linear-gradient(135deg, #1e3a8a, #0f172a);
    color: #ffffff;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.offers-modal-header h3 {
    font-size: 17px;
    font-weight: 800;
    display: flex;
    align-items: center;
    gap: 8px;
    margin: 0;
}

.offers-modal-subtitle {
    font-size: 12px;
    color: #cbd5e1;
    margin-top: 3px;
    font-weight: 500;
}

.offers-modal-close {
    background: rgba(255, 255, 255, 0.15);
    border: none;
    color: #ffffff;
    width: 32px;
    height: 32px;
    border-radius: 50%;
    font-size: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.2s;
}

.offers-modal-close:hover {
    background: rgba(255, 255, 255, 0.3);
    transform: rotate(90deg);
}

.offers-modal-body {
    padding: 18px 22px;
    overflow-y: auto;
    display: flex;
    flex-direction: column;
    gap: 14px;
    max-height: calc(85vh - 130px);
}

.checkout-offer-card {
    background: #ffffff;
    border: 1.5px solid #e2e8f0;
    border-radius: 14px;
    padding: 16px;
    transition: all 0.2s;
    position: relative;
    box-sizing: border-box;
}

.checkout-offer-card.active-applied {
    border-color: #16a34a;
    background: #f0fdf4;
    box-shadow: 0 4px 14px rgba(22, 163, 74, 0.12);
}

.checkout-offer-card.eligible {
    border-color: #cbd5e1;
}

.checkout-offer-card.eligible:hover {
    border-color: #3b82f6;
    box-shadow: 0 4px 166 rgba(59, 130, 246, 0.12);
}

.checkout-offer-card.ineligible {
    background: #f8fafc;
    border-color: #e2e8f0;
    opacity: 0.9;
}

.offer-card-top {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 10px;
    margin-bottom: 8px;
}

.offer-coupon-badge {
    background: #f1f5f9;
    color: #1e3a8a;
    font-size: 14px;
    font-weight: 800;
    padding: 4px 10px;
    border-radius: 8px;
    border: 1.5px dashed #3b82f6;
    letter-spacing: 0.8px;
    display: inline-flex;
    align-items: center;
    gap: 6px;
}

.offer-card-top .offer-discount-tag {
    background: linear-gradient(135deg, #ff7a00, #ea580c);
    color: #ffffff;
    font-size: 13px;
    font-weight: 900;
    padding: 4px 10px;
    border-radius: 12px;
    box-shadow: 0 2px 6px rgba(234, 88, 12, 0.25);
    white-space: nowrap;
}

.offer-card-desc {
    font-size: 13px;
    color: #334155;
    font-weight: 500;
    margin-bottom: 8px;
    line-height: 1.4;
}

.offer-card-meta {
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 12px;
    color: #64748b;
    padding-top: 10px;
    border-top: 1px solid #f1f5f9;
    margin-top: 8px;
}

.offer-min-spend {
    font-weight: 600;
    color: #475569;
}

.offer-need-more {
    background: #fffbeb;
    border: 1px solid #fde68a;
    color: #b45309;
    font-size: 12.5px;
    font-weight: 700;
    padding: 8px 12px;
    border-radius: 8px;
    margin: 8px 0;
    display: flex;
    align-items: center;
    gap: 6px;
}

.offer-need-more span {
    font-size: 14px;
}

.btn-apply-offer {
    background: linear-gradient(135deg, #1e3a8a, #2563eb);
    color: #ffffff;
    border: none;
    padding: 7px 16px;
    border-radius: 8px;
    font-size: 12.5px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.2s;
    white-space: nowrap;
    font-family: inherit;
}

.btn-apply-offer:hover {
    background: linear-gradient(135deg, #0f172a, #1e3a8a);
    transform: translateY(-1px);
    box-shadow: 0 3px 10px rgba(37, 99, 235, 0.25);
}

.btn-apply-disabled {
    background: #e2e8f0;
    color: #94a3b8;
    border: none;
    padding: 7px 14px;
    border-radius: 8px;
    font-size: 12px;
    font-weight: 700;
    cursor: not-allowed;
    white-space: nowrap;
    font-family: inherit;
}

.applied-pill {
    background: #dcfce7;
    color: #15803d;
    font-size: 12px;
    font-weight: 800;
    padding: 5px 12px;
    border-radius: 8px;
    border: 1px solid #86efac;
    display: inline-flex;
    align-items: center;
    gap: 4px;
}

.offers-modal-footer {
    padding: 12px 22px;
    background: #f8fafc;
    border-top: 1px solid #e2e8f0;
    display: flex;
    justify-content: space-between;
    align-items: center;
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
        <a href="<%= request.getContextPath() %>/cart" class="active">Cart</a>
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

<!-- ================= CART CONTENT ================= -->
<div class="page-wrapper">

    <div class="page-header">
        <h2 class="page-title">My Shopping Cart</h2>
        <a href="<%= request.getContextPath() %>/books" class="continue-shopping">&#8592; Continue Shopping</a>
    </div>

    <%
    if (cart == null || cart.isEmpty()) {
    %>

        <div class="empty-cart">
            <div class="empty-cart-icon">&#128722;</div>
            <h3>Your cart is empty</h3>
            <p>Looks like you haven't added any books yet. Start exploring our collection!</p>
            <a href="<%= request.getContextPath() %>/books" class="btn-browse">Browse Books</a>
        </div>

    <%
    } else {
        // ============================================
        // STEP 1: Calculate grandTotal FIRST (pre-loop)
        // ============================================
        for (CartItem item : cart) {
            double itemTotal = item.getBook().getPrice() * item.getQuantity();
            grandTotal += itemTotal;
        }

        // ============================================
        // STEP 2: Calculate discount and final total
        // ============================================
        double discountPercent = 0;
        Double sessionPercent = (Double) session.getAttribute("couponDiscountPercent");
        if (sessionPercent != null && sessionPercent > 0) {
            discountPercent = sessionPercent;
        } else if (!appliedCoupon.isEmpty()) {
            com.shelfbound.dao.OfferDAO offerDAO = new com.shelfbound.daoimpl.OfferDAOImpl();
            com.shelfbound.model.Offer offer = offerDAO.getOfferByCode(appliedCoupon);
            if (offer != null && offer.isActive() && grandTotal >= offer.getMinOrderAmount()) {
                discountPercent = offer.getDiscountPercentage() / 100.0;
                session.setAttribute("couponDiscountPercent", discountPercent);
            }
        }
        discountAmount = grandTotal * discountPercent;
        double finalTotal = grandTotal - discountAmount;
    %>

        <div class="cart-layout">
            <!-- Cart Items Table -->
            <div class="cart-table-wrap">
                <table class="cart-table">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Total</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    // ============================================
                    // STEP 3: Display loop - ONLY for display!
                    // ============================================
                    for (CartItem item : cart) {
                        double total = item.getBook().getPrice() * item.getQuantity();
                    %>
                        <tr>
                            <td data-label="Product">
                                <div class="product-cell">
                                    <img class="product-img"
                                         src="<%= request.getContextPath() + "/assets/" + item.getBook().getImageUrl() %>"
                                         alt="<%= item.getBook().getTitle() %>">
                                    <div class="product-info">
                                        <div class="product-title"><%= item.getBook().getTitle() %></div>
                                        <div class="product-author"><%= item.getBook().getAuthor() %></div>
                                    </div>
                                </div>
                            </td>
                            <td data-label="Price" class="price-cell">&#8377; <%= String.format("%.2f", item.getBook().getPrice()) %></td>
                            <td data-label="Quantity">
                                <div class="qty-control">
                                    <form action="<%= request.getContextPath() %>/removeCart" method="post" class="qty-form">
                                        <input type="hidden" name="bookId" value="<%= item.getBook().getBookId() %>"/>
                                        <input type="hidden" name="mode" value="decrease"/>
                                        <button type="submit" class="qty-btn">&#8722;</button>
                                    </form>
                                    <span class="qty-value"><%= item.getQuantity() %></span>
                                    <form action="<%= request.getContextPath() %>/removeCart" method="post" class="qty-form">
                                        <input type="hidden" name="bookId" value="<%= item.getBook().getBookId() %>"/>
                                        <input type="hidden" name="mode" value="increase"/>
                                        <button type="submit" class="qty-btn">&#43;</button>
                                    </form>
                                </div>
                            </td>
                            <td data-label="Total" class="total-cell">&#8377; <%= String.format("%.2f", total) %></td>
                            <td data-label="Action">
                                <button type="button" class="btn-remove"
                                        onclick="openRemoveModal('<%= item.getBook().getBookId() %>')">
                                    Remove
                                </button>
                            </td>
                        </tr>
                    <%
                    }
                    %>
                    </tbody>
                </table>
            </div>

            <!-- Order Summary -->
            <div class="cart-summary">
                <div class="summary-card">
                    <h3>Order Summary</h3>

                    <div class="summary-row">
                        <span>Subtotal</span>
                        <span id="subtotalValue">&#8377; <%= String.format("%.2f", grandTotal) %></span>
                    </div>
                    <div class="summary-row">
                        <span>Shipping</span>
                        <span class="free">Free</span>
                    </div>
                    <div class="summary-row">
                        <span>Discount</span>
                        <span class="discount" id="discountAmount">
                            <% if (discountAmount > 0) { %>
                                -&#8377; <%= String.format("%.2f", discountAmount) %>
                            <% } else { %>
                                -&#8377; 0.00
                            <% } %>
                        </span>
                    </div>

                    <div class="summary-divider"></div>

                    <div class="summary-row total">
                        <span>Grand Total</span>
                        <span id="finalTotal">&#8377; <%= String.format("%.2f", finalTotal) %></span>
                    </div>

                    <%-- /* CHANGED: Pass coupon in URL as extra safety */ --%>
                    <a class="btn-checkout" href="<%= request.getContextPath() %>/checkout<%= !appliedCoupon.isEmpty() ? "?coupon=" + appliedCoupon : "" %>">
                        Proceed to Checkout &#8594;
                    </a>

                    <div class="secure-badge">
                        <span>&#128274;</span> Secure Checkout
                    </div>
                </div>

                <!-- Coupon Box - AJAX based (no form post to /cart) -->
                <div class="coupon-box">
                    <h4>Have a coupon?</h4>

                    <div class="coupon-input">
                        <input type="text" name="couponInput" id="couponInput" 
                               placeholder="Enter coupon code" 
                               value="<%= appliedCoupon %>"
                               class="<%= !couponError.isEmpty() ? "error" : (!appliedCoupon.isEmpty() ? "success" : "") %>">
                        <button type="button" id="couponApplyBtn" onclick="applyCoupon()">Apply</button>
                    </div>

                    <div class="coupon-status <%= !couponError.isEmpty() ? "error" : (!appliedCoupon.isEmpty() ? "success" : "") %>" id="couponStatus">
                        <%= !couponError.isEmpty() ? couponError : (!appliedCoupon.isEmpty() ? ("Yay! Coupon applied! " + String.format("%.0f", discountPercent * 100) + "% OFF") : "") %>
                    </div>

                    <%-- Remove Coupon Button (shown when coupon is applied) --%>
                    <div id="removeCouponDiv" style="<%= !appliedCoupon.isEmpty() ? "" : "display:none;" %>">
                        <button type="button" class="btn-remove-coupon" onclick="removeCoupon()">Remove coupon</button>
                    </div>

                    <!-- All Offers Button on Cart Page -->
                    <button type="button" class="btn-view-all-offers-cart" onclick="openOffersModal()" style="margin-top: 12px; width: 100%; display: flex; align-items: center; justify-content: space-between; padding: 10px 14px; background: linear-gradient(135deg, #eff6ff, #f0fdf4); border: 1.5px dashed #2563eb; border-radius: 8px; color: #1e3a8a; font-weight: 800; font-size: 13px; cursor: pointer; transition: all 0.2s; font-family: inherit;">
                        <span>🏷️ View All Offers &amp; Coupons</span>
                        <span style="background: #2563eb; color: white; border-radius: 10px; padding: 2px 8px; font-size: 11px;"><%= activeOffers != null ? activeOffers.size() : 0 %> Available</span>
                    </button>
                </div>
            </div>
        </div>

    <%
    }
    %>

</div>


<!-- ================= REMOVE MODAL ================= -->
<div id="removeModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-icon">&#128722;</div>
        <h3 class="modal-heading">Remove from Cart?</h3>
        <p class="modal-sub">You can move this item to your wishlist instead of removing it completely.</p>

        <div class="modal-actions">
            <form id="wishlistForm" action="<%= request.getContextPath() %>/wishlist" method="post">
                <input type="hidden" name="bookId" id="wishlistBookId"/>
                <button type="submit" class="btn-wishlist">&#10084; Move to Wishlist</button>
            </form>

            <form id="removeForm" action="<%= request.getContextPath() %>/removeCart" method="post">
                <input type="hidden" name="bookId" id="cancelBookId"/>
                <button type="submit" class="btn-cancel">Remove Item</button>
            </form>
        </div>
    </div>
</div>

<!-- ================= ALL OFFERS MODAL (Middle of Page) ================= -->
<div class="offers-modal-overlay" id="offersModal" onclick="handleOffersModalClick(event)">
    <div class="offers-modal-box">
        <div class="offers-modal-header">
            <div>
                <h3>🏷️ Available Offers &amp; Coupons</h3>
                <div class="offers-modal-subtitle">Pick an eligible offer to save more on your order</div>
            </div>
            <button type="button" class="offers-modal-close" onclick="closeOffersModal()">&times;</button>
        </div>

        <div class="offers-modal-body">
            <%
                if (activeOffers == null || activeOffers.isEmpty()) {
            %>
            <div style="text-align: center; padding: 36px 16px; color: #64748b;">
                <div style="font-size: 40px; margin-bottom: 10px;">🏷️</div>
                <h4 style="color: #0f172a; margin-bottom: 6px;">No Offers Available Right Now</h4>
                <p style="font-size: 13px;">Check back soon for exclusive deals and festive discounts!</p>
            </div>
            <%
                } else {
                    for (Offer offer : activeOffers) {
                        boolean isEligible = grandTotal >= offer.getMinOrderAmount();
                        boolean isCurrent = appliedCoupon != null && appliedCoupon.equalsIgnoreCase(offer.getCouponCode());
                        double deficit = offer.getMinOrderAmount() - grandTotal;
            %>
            <div class="checkout-offer-card <%= isCurrent ? "active-applied" : (isEligible ? "eligible" : "ineligible") %>">
                <div class="offer-card-top">
                    <div class="offer-coupon-badge">
                        <span>🏷️</span> <%= offer.getCouponCode() %>
                    </div>
                    <div class="offer-discount-tag">
                        <%= String.format("%.0f", offer.getDiscountPercentage()) %>% OFF
                    </div>
                </div>

                <div class="offer-card-desc">
                    <%= offer.getDescription() != null && !offer.getDescription().trim().isEmpty() 
                            ? offer.getDescription() 
                            : "Get " + String.format("%.0f", offer.getDiscountPercentage()) + "% discount on your entire order!" %>
                </div>

                <% if (!isEligible) { %>
                <div class="offer-need-more">
                    <span>⚠️</span>
                    <div>Add <strong>&#8377;<%= String.format("%.0f", Math.ceil(deficit)) %></strong> more to avail this offer</div>
                </div>
                <% } %>

                <div class="offer-card-meta">
                    <div class="offer-min-spend">
                        <% if (offer.getMinOrderAmount() > 0) { %>
                            Min. order: <strong>&#8377;<%= String.format("%.0f", offer.getMinOrderAmount()) %></strong>
                        <% } else { %>
                            No minimum order requirement
                        <% } %>
                    </div>

                    <div>
                        <% if (isCurrent) { %>
                            <span class="applied-pill">&#10004; Currently Applied</span>
                        <% } else if (isEligible) { %>
                            <button type="button" class="btn-apply-offer" onclick="applyCartOffer('<%= offer.getCouponCode() %>')">
                                Apply Offer
                            </button>
                        <% } else { %>
                            <button type="button" class="btn-apply-disabled" disabled title="Cart total does not meet minimum order requirement">
                                Not Eligible
                            </button>
                        <% } %>
                    </div>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div>

        <div class="offers-modal-footer">
            <div style="font-size: 13px; color: #64748b; font-weight: 600;">
                Cart Subtotal: <strong>&#8377; <%= String.format("%.2f", grandTotal) %></strong>
            </div>
            <button type="button" onclick="closeOffersModal()" style="padding: 8px 18px; border-radius: 8px; border: 1px solid #cbd5e1; background: #ffffff; color: #475569; cursor: pointer; font-weight: 600; font-size: 13px; transition: all 0.2s;">
                Close
            </button>
        </div>
    </div>
</div>

<!-- Toast Container -->
<div class="toast-container" id="toastContainer"></div>

<script>
// Subtotal value from server for JS calculations
var currentSubtotal = <%= grandTotal %>;

/* ========== DYNAMIC COUPON FUNCTIONS ========== */
function applyCoupon() {
    var input = document.getElementById('couponInput');
    var code = input.value.trim().toUpperCase();
    var statusDiv = document.getElementById('couponStatus');
    var removeDiv = document.getElementById('removeCouponDiv');

    if (!code) {
        statusDiv.className = 'coupon-status error';
        statusDiv.textContent = 'Please enter a coupon code';
        input.className = 'error';
        return;
    }

    fetch('<%= request.getContextPath() %>/cart?couponAction=apply&couponInput=' + encodeURIComponent(code), {
        method: 'GET',
        headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'Accept': 'application/json'
        }
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        if (data.success) {
            input.className = 'success';
            statusDiv.className = 'coupon-status success';
            statusDiv.textContent = data.message;
            removeDiv.style.display = 'block';

            document.getElementById('discountAmount').innerHTML = '-&#8377; ' + data.discountAmount.toFixed(2);
            document.getElementById('finalTotal').innerHTML = '&#8377; ' + data.newTotal.toFixed(2);

            showToast(data.message, 'success');
        } else {
            input.className = 'error';
            statusDiv.className = 'coupon-status error';
            statusDiv.textContent = data.message;
            removeDiv.style.display = 'none';

            document.getElementById('discountAmount').innerHTML = '-&#8377; 0.00';
            document.getElementById('finalTotal').innerHTML = '&#8377; ' + currentSubtotal.toFixed(2);

            showToast(data.message, 'error');
        }
    })
    .catch(function(err) {
        console.error('Coupon apply error:', err);
        showToast('Error applying coupon. Please try again.', 'error');
    });
}

function removeCoupon() {
    var input = document.getElementById('couponInput');
    var statusDiv = document.getElementById('couponStatus');
    var removeDiv = document.getElementById('removeCouponDiv');

    fetch('<%= request.getContextPath() %>/cart?couponAction=clear', {
        method: 'GET',
        headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'Accept': 'application/json'
        }
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        input.value = '';
        input.className = '';
        statusDiv.className = 'coupon-status';
        statusDiv.textContent = '';
        removeDiv.style.display = 'none';

        document.getElementById('discountAmount').innerHTML = '-&#8377; 0.00';
        document.getElementById('finalTotal').innerHTML = '&#8377; ' + currentSubtotal.toFixed(2);

        showToast('Coupon removed', 'info');
    })
    .catch(function() {
        showToast('Coupon removed', 'info');
    });
}
/* ========== END DYNAMIC COUPON FUNCTIONS ========== */

// Allow Enter key to apply coupon
document.getElementById('couponInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        e.preventDefault();
        applyCoupon();
    }
});

// ===== REMOVE MODAL =====
function openRemoveModal(bookId) {
    document.getElementById('wishlistBookId').value = bookId;
    document.getElementById('cancelBookId').value = bookId;
    document.getElementById('removeModal').classList.add('active');
}

function closeRemoveModal() {
    document.getElementById('removeModal').classList.remove('active');
}

document.getElementById('removeModal').addEventListener('click', function(e){
    if (e.target === this) closeRemoveModal();
});

// Intercept "Move to Wishlist" submit
if (document.getElementById('wishlistForm')) {
    document.getElementById('wishlistForm').addEventListener('submit', function(e){
        e.preventDefault();
        var bookId = document.getElementById('wishlistBookId').value;
        var wishlistBody = new URLSearchParams();
        wishlistBody.append('bookId', bookId);

        fetch(this.action, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: wishlistBody
        })
        .then(function() {
            var removeBody = new URLSearchParams();
            removeBody.append('bookId', bookId);
            return fetch('<%= request.getContextPath() %>/removeCart', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: removeBody
            });
        })
        .then(function() {
            closeRemoveModal();
            showToast('Added to Wishlist!', 'success');
            setTimeout(function() { window.location.reload(); }, 1200);
        })
        .catch(function() {
            window.location.reload();
        });
    });
}

// Intercept "Remove Item" submit for toast
if (document.getElementById('removeForm')) {
    document.getElementById('removeForm').addEventListener('submit', function(e){
        e.preventDefault();
        var bookId = document.getElementById('cancelBookId').value;
        var removeBody = new URLSearchParams();
        removeBody.append('bookId', bookId);

        fetch(this.action, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: removeBody
        })
        .then(function() {
            closeRemoveModal();
            showToast('Removed from cart', 'info');
            setTimeout(function() { window.location.reload(); }, 1200);
        })
        .catch(function() {
            window.location.reload();
        });
    });
}

// ================= OFFERS MODAL LOGIC =================
function openOffersModal() {
    var modal = document.getElementById('offersModal');
    if (modal) {
        modal.classList.add('open');
        document.body.style.overflow = 'hidden';
    }
}

function closeOffersModal() {
    var modal = document.getElementById('offersModal');
    if (modal) {
        modal.classList.remove('open');
        document.body.style.overflow = '';
    }
}

function handleOffersModalClick(event) {
    if (event.target && event.target.id === 'offersModal') {
        closeOffersModal();
    }
}

document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeOffersModal();
    }
});

function applyCartOffer(code) {
    if (!code) return;
    var input = document.getElementById('couponInput');
    if (input) {
        input.value = code;
    }
    closeOffersModal();
    applyCoupon();
}

// ===== TOAST NOTIFICATIONS =====
function showToast(message, type) {
    var container = document.getElementById('toastContainer');
    var toast = document.createElement('div');
    toast.className = 'toast ' + type;
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