<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    Integer totalUsers    = (Integer) request.getAttribute("totalUsers");
    Integer totalBooks    = (Integer) request.getAttribute("totalBooks");
    Integer totalOrders   = (Integer) request.getAttribute("totalOrders");
    Integer pendingOrders = (Integer) request.getAttribute("pendingOrders");
    String  adminUsername = (String)  session.getAttribute("adminUsername");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Shelf Bound</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin-dashboard.css">
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <div class="navbar-left">
        <div class="navbar-logo">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
            </svg>
        </div>
        <span class="navbar-brand">Shelf Bound</span>
        <span class="navbar-divider"></span>
        <span class="navbar-role">Admin Panel</span>
    </div>
    <div class="navbar-center">
        <a href="<%= request.getContextPath() %>/adminDashboard" class="nav-link active">
            <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
                <rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/>
            </svg>
            Dashboard
        </a>
        <a href="<%= request.getContextPath() %>/adminBook?action=view" class="nav-link">
            <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
            </svg>
            Books
        </a>
        <a href="<%= request.getContextPath() %>/adminOrder?action=view" class="nav-link">
            <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/>
                <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
            </svg>
            Orders
        </a>
        <a href="<%= request.getContextPath() %>/adminMessage?action=view" class="nav-link">
            <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
            </svg>
            Messages
        </a>
    </div>
    <div class="navbar-right">
        <div class="navbar-user">
            <div class="user-avatar"><%= adminUsername != null ? adminUsername.substring(0,1).toUpperCase() : "A" %></div>
            <span class="user-name"><%= adminUsername %></span>
        </div>
        <a href="<%= request.getContextPath() %>/logout" class="logout-btn">Logout</a>
    </div>
</nav>

<div class="dashboard-container">

    <!-- HEADER -->
    <div class="header">
        <div class="header-left">
            <div class="header-title-row">
                <h1>Admin Dashboard</h1>
             
            </div>
            <p>Welcome back, <strong><%= adminUsername %></strong></p>
        </div>
        <div class="header-right">
            <span class="date-pill" id="datePill"></span>
        </div>
    </div>

    <!-- STAT CARDS -->
    <div class="cards">

        <div class="card card-users">
            <div class="card-accent"></div>
            <div class="card-label">
                <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                    <circle cx="9" cy="7" r="4"/>
                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                    <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                </svg>
                Total Users
            </div>
            <h2><%= totalUsers %></h2>
            <div class="card-trend trend-up">&#x2191; Active this month</div>
        </div>

        <div class="card card-books">
            <div class="card-accent"></div>
            <div class="card-label">
                <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
                </svg>
                Total Books
            </div>
            <h2><%= totalBooks %></h2>
            <div class="card-trend trend-up">&#x2191; New titles added</div>
        </div>

        <div class="card card-orders">
            <div class="card-accent"></div>
            <div class="card-label">
                <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M16.5 9.4l-9-5.19"/>
                    <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/>
                    <polyline points="3.27 6.96 12 12.01 20.73 6.96"/>
                    <line x1="12" y1="22.08" x2="12" y2="12"/>
                </svg>
                Total Orders
            </div>
            <h2><%= totalOrders %></h2>
            <div class="card-trend trend-neutral">All time</div>
        </div>

        <div class="card card-pending">
            <div class="card-accent"></div>
            <div class="card-label">
                <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"/>
                    <polyline points="12 6 12 12 16 14"/>
                </svg>
                Pending Orders
            </div>
            <h2><%= pendingOrders %></h2>
            <div class="card-trend trend-warn">&#x26A0; Needs attention</div>
        </div>

    </div>

    <!-- MODULE BUTTONS -->
    <div class="modules-heading">Quick Access</div>

    <div class="modules">

        <a href="<%= request.getContextPath() %>/adminBook?action=view" class="module-btn">
            <div class="module-icon">
                <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
                </svg>
            </div>
            <div>
                <div class="module-title">Manage Books</div>
                <div class="module-desc">Add, edit or remove listings</div>
            </div>
        </a>

        <a href="<%= request.getContextPath() %>/adminOrder?action=view" class="module-btn">
            <div class="module-icon">
                <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/>
                    <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
                </svg>
            </div>
            <div>
                <div class="module-title">Manage Orders</div>
                <div class="module-desc">View and update customer orders</div>
            </div>
        </a>

        <a href="<%= request.getContextPath() %>/adminMessage?action=view" class="module-btn">
            <div class="module-icon">
                <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                </svg>
            </div>
            <div>
                <div class="module-title">Customer Messages</div>
                <div class="module-desc">Reply to support inquiries</div>
            </div>
        </a>

    </div>

</div>

<script>
    const el = document.getElementById('datePill');
    if (el) {
        const d = new Date();
        el.textContent = d.toLocaleDateString('en-IN', {
            weekday: 'short', day: 'numeric', month: 'short', year: 'numeric'
        });
    }
</script>

</body>
</html>