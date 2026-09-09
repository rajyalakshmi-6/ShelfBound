<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.shelfbound.model.User"%>

<%
    List<User> users = (List<User>) request.getAttribute("users");
    String success = request.getParameter("success");

    int totalCount = users != null ? users.size() : 0;
    int activeCount = 0;
    int blockedCount = 0;

    if (users != null) {
        for (User u : users) {
            if ("BLOCKED".equalsIgnoreCase(u.getStatus())) {
                blockedCount++;
            } else {
                activeCount++;
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Users - Admin Portal</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

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

/* TOP BAR */
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

/* METRIC PILLS */
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
.metric-val.red { color: #ef4444; }

/* CONTROLS */
.controls-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 16px;
    margin-bottom: 20px;
}

.search-input {
    width: 340px;
    padding: 12px 18px;
    border-radius: 12px;
    border: 1.5px solid #cbd5e1;
    background: #ffffff;
    font-size: 14px;
    outline: none;
    transition: all 0.2s ease;
}

.search-input:focus {
    border-color: #ff7a00;
    box-shadow: 0 0 0 4px rgba(255, 122, 0, 0.15);
}

/* TABLE */
.table-card {
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(16px);
    border-radius: 18px;
    border: 1px solid rgba(226, 232, 240, 0.9);
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
}

table {
    width: 100%;
    min-width: 820px;
    border-collapse: collapse;
    font-size: 13.5px;
}

thead th {
    background: #0f172a;
    color: #ffffff;
    font-weight: 700;
    padding: 14px 18px;
    text-align: left;
    font-size: 13px;
    letter-spacing: 0.3px;
}

tbody tr {
    border-bottom: 1px solid #f1f5f9;
    transition: background 0.15s ease;
}

tbody tr:hover {
    background: #f8fafc;
}

td {
    padding: 16px 18px;
    vertical-align: middle;
}

.user-cell {
    display: flex;
    align-items: center;
    gap: 12px;
}

.user-avatar {
    width: 38px;
    height: 38px;
    border-radius: 50%;
    background: linear-gradient(135deg, #1e3a8a, #ff7a00);
    color: white;
    font-weight: 700;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    box-shadow: 0 4px 10px rgba(30, 58, 138, 0.2);
}

.user-name {
    font-weight: 700;
    color: #0f172a;
    display: block;
}

.user-id {
    font-size: 11.5px;
    color: #94a3b8;
}

/* BADGES */
.status-badge {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 5px 12px;
    border-radius: 9999px;
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 0.3px;
    text-transform: uppercase;
}

.status-badge.active {
    background: #ecfdf5;
    color: #065f46;
    border: 1px solid #a7f3d0;
}

.status-badge.blocked {
    background: #fef2f2;
    color: #991b1b;
    border: 1px solid #fecaca;
}

.dot {
    width: 7px;
    height: 7px;
    border-radius: 50%;
}
.status-badge.active .dot { background: #10b981; }
.status-badge.blocked .dot { background: #ef4444; }

/* ACTION BUTTONS */
.btn-block {
    background: #fee2e2;
    color: #991b1b;
    border: 1px solid #fca5a5;
    padding: 7px 14px;
    border-radius: 8px;
    font-size: 12.5px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.2s ease;
}

.btn-block:hover {
    background: #ef4444;
    color: white;
    border-color: #ef4444;
}

.btn-unblock {
    background: #d1fae5;
    color: #065f46;
    border: 1px solid #6ee7b7;
    padding: 7px 14px;
    border-radius: 8px;
    font-size: 12.5px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.2s ease;
}

.btn-unblock:hover {
    background: #10b981;
    color: white;
    border-color: #10b981;
}

.alert-success {
    background: #ecfdf5;
    color: #065f46;
    border: 1px solid #a7f3d0;
    border-radius: 12px;
    padding: 12px 18px;
    margin-bottom: 20px;
    font-size: 13.5px;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 10px;
}

@media (max-width: 640px) {
    body {
        padding: 20px 14px;
    }
    .page-title {
        font-size: 22px;
    }
    .metrics-grid {
        grid-template-columns: 1fr;
    }
    .top-nav {
        margin-bottom: 16px;
    }
}
</style>
</head>
<body>

<div class="container">

    <div class="top-nav">
        <a href="<%= request.getContextPath() %>/adminDashboard" class="back-btn">
            ← Back to Dashboard
        </a>
    </div>

    <h1 class="page-title">Registered Customers &amp; Account Control</h1>
    <p class="page-subtitle">Monitor registered store users, inspect profile details, and manage customer account access.</p>

    <% if ("1".equals(success)) { %>
        <div class="alert-success">
            <span>✔</span>
            <span>User account status successfully updated!</span>
        </div>
    <% } %>

    <!-- METRICS -->
    <div class="metrics-grid">
        <div class="metric-card">
            <div class="metric-label">Total Users</div>
            <div class="metric-val"><%= totalCount %></div>
        </div>
        <div class="metric-card">
            <div class="metric-label">Active Users</div>
            <div class="metric-val green"><%= activeCount %></div>
        </div>
        <div class="metric-card">
            <div class="metric-label">Blocked Users</div>
            <div class="metric-val red"><%= blockedCount %></div>
        </div>
    </div>

    <!-- SEARCH -->
    <div class="controls-bar">
        <input type="text"
               id="userSearch"
               class="search-input"
               placeholder="Search by username, email, or city..."
               onkeyup="filterUsers()">
    </div>

    <!-- TABLE -->
    <div class="table-card">
        <table id="usersTable">
            <thead>
                <tr>
                    <th>User</th>
                    <th>Email Address</th>
                    <th>Phone</th>
                    <th>Location</th>
                    <th>Status</th>
                    <th style="text-align:center;">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (users != null && !users.isEmpty()) {
                        for (User u : users) {
                            boolean isBlocked = "BLOCKED".equalsIgnoreCase(u.getStatus());
                            String initial = u.getUsername() != null && !u.getUsername().isEmpty() ? 
                                             u.getUsername().substring(0, 1).toUpperCase() : "U";
                %>
                    <tr>
                        <td>
                            <div class="user-cell">
                                <div class="user-avatar"><%= initial %></div>
                                <div>
                                    <span class="user-name"><%= u.getUsername() %></span>
                                    <span class="user-id">ID #<%= u.getUserId() %></span>
                                </div>
                            </div>
                        </td>
                        <td>
                            <a href="mailto:<%= u.getEmail() %>" style="color:#2563eb;text-decoration:none;font-weight:600;">
                                <%= u.getEmail() %>
                            </a>
                        </td>
                        <td><%= u.getPhone() != null && !u.getPhone().isEmpty() ? u.getPhone() : "—" %></td>
                        <td>
                            <%= (u.getCity() != null ? u.getCity() : "") %>
                            <%= (u.getState() != null && !u.getState().isEmpty() ? ", " + u.getState() : "") %>
                            <% if ((u.getCity() == null || u.getCity().isEmpty()) && (u.getState() == null || u.getState().isEmpty())) { %>
                                —
                            <% } %>
                        </td>
                        <td>
                            <% if (isBlocked) { %>
                                <span class="status-badge blocked">
                                    <span class="dot"></span> Blocked
                                </span>
                            <% } else { %>
                                <span class="status-badge active">
                                    <span class="dot"></span> Active
                                </span>
                            <% } %>
                        </td>
                        <td style="text-align:center;">
                            <form action="<%= request.getContextPath() %>/adminUser" method="post" onsubmit="return confirmAction('<%= isBlocked ? "unblock" : "block" %>', '<%= u.getUsername() %>')">
                                <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                <% if (isBlocked) { %>
                                    <input type="hidden" name="action" value="unblock">
                                    <button type="submit" class="btn-unblock">
                                        ✔ Unblock User
                                    </button>
                                <% } else { %>
                                    <input type="hidden" name="action" value="block">
                                    <button type="submit" class="btn-block">
                                        ⛔ Block User
                                    </button>
                                <% } %>
                            </form>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="6" style="text-align:center;padding:32px;color:#94a3b8;">
                            No users found in database.
                        </td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

</div>

<script>
function filterUsers() {
    var filter = document.getElementById('userSearch').value.toLowerCase();
    var rows = document.querySelectorAll('#usersTable tbody tr');

    rows.forEach(function(row) {
        var text = row.textContent.toLowerCase();
        row.style.display = text.indexOf(filter) > -1 ? '' : 'none';
    });
}

function confirmAction(action, username) {
    if (action === 'block') {
        return confirm("Are you sure you want to BLOCK " + username + "?\nThey will not be able to log in to their account.");
    } else {
        return confirm("Are you sure you want to UNBLOCK " + username + "?\nThey will regain access to log in.");
    }
}
</script>

</body>
</html>
