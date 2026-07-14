<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.shelfbound.model.CartItem" %>

<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    String username = (String) session.getAttribute("username");
    double grandTotal = 0;
    double discountAmount = 0;

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
        if ("WELCOME20".equals(appliedCoupon)) {
            discountPercent = 0.20;
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
                        <%= !couponError.isEmpty() ? couponError : (!appliedCoupon.isEmpty() ? "Yay! Coupon applied! 20% OFF" : "") %>
                    </div>

                    <%-- Remove Coupon Button (shown when coupon is applied) --%>
                    <div id="removeCouponDiv" style="<%= !appliedCoupon.isEmpty() ? "" : "display:none;" %>">
                        <button type="button" class="btn-remove-coupon" onclick="removeCoupon()">Remove coupon</button>
                    </div>
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

<!-- Toast Container -->
<div class="toast-container" id="toastContainer"></div>

<script>
// Subtotal value from server for JS calculations
var currentSubtotal = <%= grandTotal %>;

/* ========== CHANGED: Simplified & Fixed Coupon Functions ========== */
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

    // Single GET request — JSP scriptlet at top updates the session
    fetch('<%= request.getContextPath() %>/cart?couponAction=apply&couponInput=' + encodeURIComponent(code), {
        method: 'GET'
    })
    .then(function() {
        if (code === 'WELCOME20') {
            input.className = 'success';
            statusDiv.className = 'coupon-status success';
            statusDiv.textContent = 'Yay! Coupon applied! 20% OFF';
            removeDiv.style.display = 'block';

            var discount = currentSubtotal * 0.20;
            var newTotal = currentSubtotal - discount;

            document.getElementById('discountAmount').innerHTML = '-&#8377; ' + discount.toFixed(2);
            document.getElementById('finalTotal').innerHTML = '&#8377; ' + newTotal.toFixed(2);

            showToast('Coupon WELCOME20 applied! 20% OFF', 'success');
        } else {
            input.className = 'error';
            statusDiv.className = 'coupon-status error';
            statusDiv.textContent = 'Invalid coupon code';
            removeDiv.style.display = 'none';

            document.getElementById('discountAmount').innerHTML = '-&#8377; 0.00';
            document.getElementById('finalTotal').innerHTML = '&#8377; ' + currentSubtotal.toFixed(2);

            showToast('Invalid coupon code', 'error');
        }
    })
    .catch(function() {
        showToast('Error applying coupon. Please try again.', 'error');
    });
}

function removeCoupon() {
    var input = document.getElementById('couponInput');
    var statusDiv = document.getElementById('couponStatus');
    var removeDiv = document.getElementById('removeCouponDiv');

    // Tell server to clear session
    fetch('<%= request.getContextPath() %>/cart?couponAction=clear', {
        method: 'GET'
    }).catch(function(){});

    input.value = '';
    input.className = '';
    statusDiv.className = 'coupon-status';
    statusDiv.textContent = '';
    removeDiv.style.display = 'none';

    document.getElementById('discountAmount').innerHTML = '-&#8377; 0.00';
    document.getElementById('finalTotal').innerHTML = '&#8377; ' + currentSubtotal.toFixed(2);

    showToast('Coupon removed', 'info');
}
/* ========== END CHANGE ========== */

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