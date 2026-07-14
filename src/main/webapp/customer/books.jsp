<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="com.shelfbound.model.Book" %>

<%
    List<Book> books        = (List<Book>) request.getAttribute("books");
    String search = (String)request.getAttribute("search");
    String     errorMessage = (String)     request.getAttribute("errorMessage");
    String     username     = (String)     session.getAttribute("username");
    
 // NEW: track which category is currently selected
    String categoryId = request.getParameter("categoryId");
    if (categoryId == null) categoryId = "";

    // Wishlist IDs sent by BooksServlet — used to pre-fill hearts pink on load
    Set<Integer> wishlistIds = (Set<Integer>) request.getAttribute("wishlistIds");
    if (wishlistIds == null) wishlistIds = new HashSet<>();

    int totalBooks = (books != null) ? books.size() : 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Books - ShelfBound</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/books.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700&display=swap" rel="stylesheet">
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
        <a href="<%= request.getContextPath() %>/books" class="active">Books</a>
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

<!-- ================= MAIN LAYOUT ================= -->
<div class="layout">

    <!-- ================= SIDEBAR ================= -->
    <div class="sidebar">
    <h3>&#128218; Categories</h3>
    <a href="<%= request.getContextPath() %>/books"
       class="<%= categoryId.isEmpty() ? "active" : "" %>">All Books</a>
    <a href="<%= request.getContextPath() %>/books?categoryId=1"
       class="<%= "1".equals(categoryId) ? "active" : "" %>">Fiction</a>
    <a href="<%= request.getContextPath() %>/books?categoryId=2"
       class="<%= "2".equals(categoryId) ? "active" : "" %>">Non-Fiction</a>
    <a href="<%= request.getContextPath() %>/books?categoryId=3"
       class="<%= "3".equals(categoryId) ? "active" : "" %>">Kids</a>
    <a href="<%= request.getContextPath() %>/books?categoryId=4"
       class="<%= "4".equals(categoryId) ? "active" : "" %>">Competitive Exams</a>
    <a href="<%= request.getContextPath() %>/books?categoryId=5"
       class="<%= "5".equals(categoryId) ? "active" : "" %>">Popular Books</a>
    <a href="<%= request.getContextPath() %>/books?categoryId=6"
       class="<%= "6".equals(categoryId) ? "active" : "" %>">New Arrivals</a>
    <a href="<%= request.getContextPath() %>/books?categoryId=7"
       class="<%= "7".equals(categoryId) ? "active" : "" %>">Adult Learning</a>
</div>

    <!-- ================= BOOK SECTION ================= -->
    <div class="book-section">

        <!-- ================= COUPON CARDS SCROLLING SECTION ================= -->
        <div class="coupon-strip">
            <div class="coupon-track">

                <!-- Set 1 -->
                <div class="coupon-card">
                    <div class="coupon-ribbon">20%<span>OFF</span></div>
                    <div class="coupon-divider"></div>
                    <div class="coupon-content">
                        <p class="coupon-title">&#127881; FLAT 20% OFF on Your First Order!</p>
                        <p class="coupon-sub">Applied automatically at checkout</p>
                    </div>
                </div>

                <div class="coupon-card">
                    <div class="coupon-ribbon">&#9889;<span>CODE</span></div>
                    <div class="coupon-divider"></div>
                    <div class="coupon-content">
                        <p class="coupon-title">Use Code <span class="coupon-code">WELCOME20</span></p>
                        <p class="coupon-sub">Copy and apply on cart page</p>
                    </div>
                </div>

                <div class="coupon-card">
                    <div class="coupon-ribbon">&#128293;<span>HOT</span></div>
                    <div class="coupon-divider"></div>
                    <div class="coupon-content">
                        <p class="coupon-title">Limited Time Only!</p>
                        <p class="coupon-sub">Offer ends soon, grab it now</p>
                    </div>
                </div>

                <div class="coupon-card">
                    <div class="coupon-ribbon">&#128666;<span>FREE</span></div>
                    <div class="coupon-divider"></div>
                    <div class="coupon-content">
                        <p class="coupon-title">Free Delivery on All Orders</p>
                        <p class="coupon-sub">No minimum order value</p>
                    </div>
                </div>

                <!-- Set 2 — EXACT duplicate for seamless loop -->
                <div class="coupon-card">
                    <div class="coupon-ribbon">20%<span>OFF</span></div>
                    <div class="coupon-divider"></div>
                    <div class="coupon-content">
                        <p class="coupon-title">&#127881; FLAT 20% OFF on Your First Order!</p>
                        <p class="coupon-sub">Applied automatically at checkout</p>
                    </div>
                </div>

                <div class="coupon-card">
                    <div class="coupon-ribbon">&#9889;<span>CODE</span></div>
                    <div class="coupon-divider"></div>
                    <div class="coupon-content">
                        <p class="coupon-title">Use Code <span class="coupon-code">WELCOME20</span></p>
                        <p class="coupon-sub">Copy and apply on cart page</p>
                    </div>
                </div>

                <div class="coupon-card">
                    <div class="coupon-ribbon">&#128293;<span>HOT</span></div>
                    <div class="coupon-divider"></div>
                    <div class="coupon-content">
                        <p class="coupon-title">Limited Time Only!</p>
                        <p class="coupon-sub">Offer ends soon, grab it now</p>
                    </div>
                </div>

                <div class="coupon-card">
                    <div class="coupon-ribbon">&#128666;<span>FREE</span></div>
                    <div class="coupon-divider"></div>
                    <div class="coupon-content">
                        <p class="coupon-title">Free Delivery on All Orders</p>
                        <p class="coupon-sub">No minimum order value</p>
                    </div>
                </div>

            </div>
        </div>
        <!-- ================= COUPON CARDS SCROLLING SECTION - END ================= -->

        <!-- Section Header -->
        <div class="section-header">
            <%
                if(search != null && !search.isEmpty()){
            %>
                <h2>Search Results for "<%=search%>"</h2>
            <%
                } else {
            %>
                <h2><span class="section-icon">&#128218;</span> Books Collection</h2>
            <%
                }
            %>
        </div>

        <%
            if (errorMessage != null) {
        %>
            <div class="error-message"><%= errorMessage %></div>
        <%
            }
        %>

        <div class="book-grid" id="bookGrid">
            <%
                if (books != null && !books.isEmpty()) {
                    int index = 0;
                    for (Book b : books) {
                        boolean isWishlisted = wishlistIds.contains(b.getBookId());
                        String hiddenClass = (index >= 20) ? "book-hidden" : "";
            %>

            <a class="book-link <%= hiddenClass %>"
               href="<%= request.getContextPath() %>/book?id=<%= b.getBookId() %>"
               data-index="<%= index %>">
                <div class="book-card">

                    <span class="discount-tag">-20% OFF</span>

                    <img src="<%= request.getContextPath() %>/assets/<%= b.getImageUrl() %>" alt="<%= b.getTitle() %>">

                    <h3><%= b.getTitle() %></h3>

                    <div class="author-row">
                        <span class="author-name"><%= b.getAuthor() %></span>
                        <button type="button"
                                class="wishlist-btn <%= isWishlisted ? "wishlisted" : "" %>"
                                data-book-id="<%= b.getBookId() %>"
                                title="<%= isWishlisted ? "Remove from Wishlist" : "Add to Wishlist" %>"
                                onclick="toggleWishlist(this, event)">
                            &#9829;
                        </button>
                    </div>

                    <p class="price">
                        &#8377; <%= b.getPrice() %>
                        <span class="original">&#8377; <%= String.format("%.0f", b.getPrice() * 1.25) %></span>
                    </p>

                </div>
            </a>

            <%
                        index++;
                    }
                } else {
            %>
               <%
                    if(search != null && !search.isEmpty()){
               %>
                    <p class="no-books">No books found for "<%=search%>"</p>
               <%
                    } else {
               %>
                    <p class="no-books">No books available with your search.</p>
               <%
                    }
               %>
            <%
                }
            %>
        </div>

        <!-- Load More Button -->
        <%
            if (books != null && books.size() > 20) {
        %>
        <div class="load-more-wrap" id="loadMoreWrap">
            <button class="load-more-btn" id="loadMoreBtn" onclick="loadMoreBooks()">
                <span class="load-more-text">Load More</span>
                <span class="load-more-count">Showing 20 of <%= totalBooks %></span>
            </button>
        </div>
        <%
            }
        %>

    </div>

</div>

<!-- Toast Container -->
<div class="toast-container" id="toastContainer"></div>

<script>
// ===== LOAD MORE FUNCTIONALITY =====
var booksPerPage = 20;
var currentlyShown = 20;
var totalBooks = <%= totalBooks %>;

function loadMoreBooks() {
    var hiddenBooks = document.querySelectorAll('.book-hidden');
    var toShow = Math.min(booksPerPage, hiddenBooks.length);

    for (var i = 0; i < toShow; i++) {
        hiddenBooks[i].classList.remove('book-hidden');
        hiddenBooks[i].classList.add('book-fade-in');
    }

    currentlyShown += toShow;

    // Update button text
    var btnText = document.querySelector('.load-more-text');
    var btnCount = document.querySelector('.load-more-count');
    if (btnText) btnText.textContent = 'Load More';
    if (btnCount) btnCount.textContent = 'Showing ' + currentlyShown + ' of ' + totalBooks;

    // Hide button if no more books
    if (currentlyShown >= totalBooks) {
        var wrap = document.getElementById('loadMoreWrap');
        if (wrap) {
            wrap.style.opacity = '0';
            wrap.style.transform = 'translateY(10px)';
            setTimeout(function() {
                wrap.style.display = 'none';
            }, 300);
        }
    }
}

// ===== WISHLIST TOGGLE =====
function toggleWishlist(btn, event) {
    event.stopPropagation();
    event.preventDefault();

    var bookId = btn.getAttribute('data-book-id');
    var wasWishlisted = btn.classList.contains('wishlisted');

    btn.classList.toggle('wishlisted');
    btn.disabled = true;

    fetch('<%= request.getContextPath() %>/wishlist', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: 'bookId=' + encodeURIComponent(bookId)
    })
    .then(function(response) {
        if (!response.ok) throw new Error('Request failed');
        return response.text();
    })
    .then(function(status) {
        if (status === 'added') {
            btn.classList.add('wishlisted');
            btn.title = 'Remove from Wishlist';
            showToast('Added to Wishlist! &#10084;', 'success');
        } else if (status === 'removed') {
            btn.classList.remove('wishlisted');
            btn.title = 'Add to Wishlist';
            showToast('Removed from Wishlist', 'info');
        }
        btn.disabled = false;
    })
    .catch(function(err) {
        console.error('Wishlist toggle failed:', err);
        if (wasWishlisted) {
            btn.classList.add('wishlisted');
        } else {
            btn.classList.remove('wishlisted');
        }
        btn.disabled = false;
        showToast('Something went wrong. Please try again.', 'error');
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