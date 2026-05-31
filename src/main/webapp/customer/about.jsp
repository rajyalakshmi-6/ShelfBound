<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String username = (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>About Us — ShelfBound</title>

<link rel="stylesheet"
    href="<%= request.getContextPath() %>/assets/css/home.css">

<style>

    .about-wrapper {
        max-width: 960px;
        margin: 0 auto;
        padding: 0 2rem 5rem;
    }

    .about-section {
        padding: 3rem 0;
        border-bottom: 1px solid #e8e6df;
    }

    .about-section:last-child {
        border-bottom: none;
    }

    .eyebrow {
        font-size: 11px;
        font-weight: 600;
        letter-spacing: 0.1em;
        text-transform: uppercase;
        color: #534AB7;
        margin-bottom: 10px;
    }

    .about-title {
        font-size: 28px;
        font-weight: 700;
        color: #1a1a1a;
        margin-bottom: 14px;
        line-height: 1.3;
    }

    .about-body {
        font-size: 15px;
        line-height: 1.85;
        color: #555;
        max-width: 640px;
    }

    /* ── Stats ── */
    .stats-row {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
        gap: 14px;
        margin-top: 2rem;
    }

    .stat-card {
        background: #fff;
        border: 1px solid #e8e6df;
        border-radius: 10px;
        padding: 1.25rem 1rem;
        text-align: center;
    }

    .stat-num {
        font-size: 22px;
        font-weight: 700;
        color: #534AB7;
    }

    .stat-label {
        font-size: 12px;
        color: #888;
        margin-top: 5px;
    }

    /* ── Value cards ── */
    .values-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
        gap: 16px;
        margin-top: 2rem;
    }

    .value-card {
        background: #fff;
        border: 1px solid #e8e6df;
        border-radius: 12px;
        padding: 1.3rem 1.4rem;
        transition: border-color 0.2s;
    }

    .value-card:hover {
        border-color: #AFA9EC;
    }

    .value-icon {
        font-size: 24px;
        margin-bottom: 12px;
        color: #534AB7;
    }

    .value-title {
        font-size: 14px;
        font-weight: 600;
        color: #1a1a1a;
        margin-bottom: 6px;
    }

    .value-desc {
        font-size: 13px;
        color: #666;
        line-height: 1.65;
    }

    /* ── Categories ── */
    .categories-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
        gap: 10px;
        margin-top: 2rem;
    }

    .cat-pill {
        display: flex;
        align-items: center;
        gap: 10px;
        background: #fff;
        border: 1px solid #e8e6df;
        border-radius: 8px;
        padding: 10px 14px;
        font-size: 13px;
        color: #1a1a1a;
        transition: border-color 0.2s;
    }

    .cat-pill:hover {
        border-color: #AFA9EC;
    }

    .cat-dot {
        width: 9px;
        height: 9px;
        border-radius: 50%;
        flex-shrink: 0;
    }

    /* ── Contact Us header ── */
    .contact-header-box {
        background: #EEEDFE;
        border-radius: 14px;
        padding: 2.5rem 2rem;
        display: flex;
        align-items: center;
        justify-content: space-between;
        flex-wrap: wrap;
        gap: 1.5rem;
        margin-top: 1rem;
    }

    .contact-header-box .left .eyebrow {
        color: #534AB7;
    }

    .contact-header-box .left h2 {
        font-size: 24px;
        font-weight: 700;
        color: #26215C;
        margin-bottom: 10px;
    }

    .contact-header-box .left p {
        font-size: 14px;
        color: #534AB7;
        max-width: 460px;
        line-height: 1.75;
    }

    .contact-btn {
        display: inline-block;
        background: #534AB7;
        color: #fff;
        padding: 12px 28px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        text-decoration: none;
        white-space: nowrap;
        transition: background 0.2s;
    }

    .contact-btn:hover {
        background: #3C3489;
        color: #fff;
    }
    
    .navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 14px 40px;
   background: linear-gradient(135deg, #dff6ff, #a8d8ff);
    backdrop-filter: blur(8px);
    border-bottom: 1px solid #e8e6df;
    position: sticky;
    top: 0;
    z-index: 1000;
}

</style>

</head>

<body>

<!-- ================= NAVBAR ================= -->

<div class="navbar">

    <a href="<%= request.getContextPath() %>/home" class="logo-container">
        <img src="<%= request.getContextPath() %>/assets/images/logo.png"
             alt="ShelfBound Logo" class="logo-img">
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
        <a href="<%= request.getContextPath() %>/about" class="active">About</a>
        <a href="<%= request.getContextPath() %>/contact">Contact</a>

        <%
            if (username == null) {
        %>
            <a href="<%= request.getContextPath() %>/login">Login</a>
        <%
            } else {
        %>
            <span class="welcome-user">Welcome, <%= username %></span>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Logout</a>
        <%
            }
        %>

        <a href="<%= request.getContextPath() %>/adminLogin">Admin</a>

    </div>

</div>

<!-- ================= ABOUT PAGE CONTENT ================= -->

<div class="about-wrapper">

    <!-- ── Our Story ── -->
    <div class="about-section">
        <div class="eyebrow">Our story</div>
        <h2 class="about-title">Books for every curious mind</h2>
        <p class="about-body">
            ShelfBound was born from a simple belief — the right book at the right moment
            can change everything. We curate thousands of titles across every genre, bringing
            together readers, stories, and ideas under one roof. Whether you're a seasoned
            bibliophile or picking up your first novel, there's always a shelf here waiting for you.
        </p>

        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-num">10,000+</div>
                <div class="stat-label">Titles in stock</div>
            </div>
            <div class="stat-card">
                <div class="stat-num">2+</div>
                <div class="stat-label">Categories</div>
            </div>
            <div class="stat-card">
                <div class="stat-num">5K+</div>
                <div class="stat-label">Happy readers</div>
            </div>
            <div class="stat-card">
                <div class="stat-num">Since 2026</div>
                <div class="stat-label">Serving readers</div>
            </div>
        </div>
    </div>

    <!-- ── Why ShelfBound ── -->
    <div class="about-section">
        <div class="eyebrow">Why ShelfBound</div>
        <h2 class="about-title">What makes us different</h2>

        <div class="values-grid">

            <div class="value-card">
                <div class="value-icon">&#128218;</div>
                <div class="value-title">Curated collections</div>
                <div class="value-desc">
                    Every title is handpicked by our team of avid readers —
                    no algorithm, just passion.
                </div>
            </div>

            <div class="value-card">
                <div class="value-icon">&#128666;</div>
                <div class="value-title">Fast delivery</div>
                <div class="value-desc">
                    Get your books delivered to your doorstep within 2–4 business
                    days, anywhere in India.
                </div>
            </div>

            <div class="value-card">
                <div class="value-icon">&#9989;</div>
                <div class="value-title">Genuine editions</div>
                <div class="value-desc">
                    We source directly from publishers. Every book is 100% authentic,
                    sealed and quality-checked.
                </div>
            </div>

            <div class="value-card">
                <div class="value-icon">&#10084;</div>
                <div class="value-title">Reader community</div>
                <div class="value-desc">
                    Join thousands of readers who share reviews, recommendations,
                    and reading lists.
                </div>
            </div>

        </div>
    </div>

    <!-- ── Our Collection ── -->
    <div class="about-section">
        <div class="eyebrow">Our collection</div>
        <h2 class="about-title">Something for every reader</h2>
        <p class="about-body">
            From timeless classics to trending releases, we stock across every category imaginable.
        </p>

        <div class="categories-grid">
            <div class="cat-pill"><span class="cat-dot" style="background:#7F77DD;"></span>Fiction</div>
            <div class="cat-pill"><span class="cat-dot" style="background:#1D9E75;"></span>Non-fiction</div>
            <div class="cat-pill"><span class="cat-dot" style="background:#D85A30;"></span>Mystery &amp; thriller</div>
            <div class="cat-pill"><span class="cat-dot" style="background:#378ADD;"></span>Science &amp; tech</div>
            <div class="cat-pill"><span class="cat-dot" style="background:#D4537E;"></span>Romance</div>
            <div class="cat-pill"><span class="cat-dot" style="background:#EF9F27;"></span>Self-help</div>
            <div class="cat-pill"><span class="cat-dot" style="background:#639922;"></span>Kids books</div>
            <div class="cat-pill"><span class="cat-dot" style="background:#888780;"></span>History &amp; culture</div>
            <div class="cat-pill"><span class="cat-dot" style="background:#534AB7;"></span>Fantasy &amp; sci-fi</div>
            <div class="cat-pill"><span class="cat-dot" style="background:#993C1D;"></span>Biographies</div>
            <div class="cat-pill"><span class="cat-dot" style="background:#0F6E56;"></span>Competitive &amp; exam</div>
            <div class="cat-pill"><span class="cat-dot" style="background:#BA7517;"></span>Art &amp; design</div>
        </div>
    </div>

    <!-- ── Contact Us banner ── -->
    <div class="about-section">
        <div class="eyebrow">Contact us</div>
        <div class="contact-header-box">
            <div class="left">
                <h2>We'd love to hear from you</h2>
                <p>
                    Have a question about an order, a suggestion, or just want to share
                    what you're reading? Drop us a message.
                </p>
            </div>
            <a href="<%= request.getContextPath() %>/contact" class="contact-btn">
                Get in touch &rarr;
            </a>
        </div>
    </div>

</div>

</body>
</html>