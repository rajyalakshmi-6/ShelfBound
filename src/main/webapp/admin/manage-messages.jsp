<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.shelfbound.model.ContactMessage"%>

<%
List<ContactMessage> messages = (List<ContactMessage>) request.getAttribute("messages");

String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Messages</title>

<style>

/* ================= BACKGROUND ================= */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	font-family: 'Inter', "Segoe UI", -apple-system, sans-serif;
}

body {
	margin: 0;
	background: 
		radial-gradient(1100px circle at 15% 10%, rgba(30, 58, 138, 0.08), transparent 45%),
		radial-gradient(900px circle at 85% 25%, rgba(255, 122, 0, 0.06), transparent 50%),
		radial-gradient(1200px circle at 50% 80%, rgba(30, 58, 138, 0.05), transparent 60%),
		#f8fafc;
	min-height: 100vh;
	color: #0f172a;
	-webkit-font-smoothing: antialiased;
}

/* ================= CONTAINER ================= */
.container {
	max-width: 1200px;
	margin: auto;
	padding: 30px 20px;
}

/* ================= HEADER ================= */
h1 {
	font-size: 26px;
	font-weight: 800;
	color: #0f172a;
	letter-spacing: -0.5px;
	margin-bottom: 12px;
}

/* ================= DASHBOARD BUTTON ================= */
.dashboard-btn {
	background: rgba(15, 23, 42, 0.88);
	color: #ffffff;
	padding: 10px 18px;
	border-radius: 10px;
	text-decoration: none;
	font-size: 13px;
	font-weight: 600;
	letter-spacing: 0.2px;
	backdrop-filter: blur(8px);
	border: 1px solid rgba(255, 255, 255, 0.1);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
	transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
	display: inline-flex;
	align-items: center;
	gap: 6px;
	margin-bottom: 24px;
}

.dashboard-btn:hover {
	background: #0f172a;
	transform: translateY(-2px);
	box-shadow: 0 8px 18px rgba(0, 0, 0, 0.18);
	color: #ff7a00;
}

/* ================= TABLE WRAPPER ================= */
.table-wrapper {
	background: rgba(255, 255, 255, 0.92);
	backdrop-filter: blur(14px);
	-webkit-backdrop-filter: blur(14px);
	border: 1px solid rgba(226, 232, 240, 0.85);
	border-radius: 14px;
	overflow-x: auto;
	-webkit-overflow-scrolling: touch;
	box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
}

table {
	width: 100%;
	min-width: 700px;
	border-collapse: collapse;
}

th {
	background: #0f172a;
	color: #f8fafc;
	font-size: 12.5px;
	font-weight: 700;
	letter-spacing: 0.5px;
	text-transform: uppercase;
	padding: 14px 16px;
	border-bottom: 2px solid rgba(255, 122, 0, 0.3);
}

td {
	padding: 14px 16px;
	text-align: center;
	border-bottom: 1px solid #f1f5f9;
	vertical-align: middle;
	font-size: 13.5px;
	color: #334155;
	transition: background 0.2s ease;
}

tr:last-child td {
	border-bottom: none;
}

tr:hover td {
	background: rgba(248, 250, 252, 0.85);
}

/* ================= STATUS BADGES ================= */
.badge {
	padding: 5px 12px;
	border-radius: 999px;
	font-size: 11.5px;
	font-weight: 700;
	letter-spacing: 0.3px;
	text-transform: uppercase;
	display: inline-block;
}

.pending {
	background: rgba(245, 158, 11, 0.12);
	color: #b45309;
	border: 1px solid rgba(245, 158, 11, 0.3);
}

.read {
	background: rgba(59, 130, 246, 0.12);
	color: #1d4ed8;
	border: 1px solid rgba(59, 130, 246, 0.3);
}

.replied {
	background: rgba(16, 185, 129, 0.12);
	color: #047857;
	border: 1px solid rgba(16, 185, 129, 0.3);
}

/* ================= BUTTONS ================= */
.btn {
	padding: 7px 14px;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	font-size: 12.5px;
	font-weight: 600;
	transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
}

.reply {
	background: #2563eb;
	color: white;
	box-shadow: 0 2px 6px rgba(37, 99, 235, 0.25);
}

.reply:hover {
	background: #1d4ed8;
	transform: translateY(-1px);
	box-shadow: 0 4px 10px rgba(37, 99, 235, 0.35);
}

.delete {
	background: #ef4444;
	color: white;
	box-shadow: 0 2px 6px rgba(239, 68, 68, 0.25);
	margin-left: 4px;
}

.delete:hover {
	background: #dc2626;
	transform: translateY(-1px);
	box-shadow: 0 4px 10px rgba(239, 68, 68, 0.35);
}

/* ================= TOAST POPUP ================= */
.toast {
	position: fixed;
	top: 24px;
	right: 24px;
	background: rgba(16, 185, 129, 0.14);
	color: #065f46;
	padding: 14px 20px;
	border-radius: 12px;
	font-weight: 700;
	font-size: 13.5px;
	border: 1px solid rgba(16, 185, 129, 0.35);
	box-shadow: 0 12px 28px rgba(0, 0, 0, 0.1);
	backdrop-filter: blur(12px);
	-webkit-backdrop-filter: blur(12px);
	animation: fade 2.5s forwards;
	z-index: 1000;
}

@keyframes fade {
	0% { opacity: 0; transform: translateY(-10px); }
	15% { opacity: 1; transform: translateY(0); }
	80% { opacity: 1; transform: translateY(0); }
	100% { opacity: 0; transform: translateY(-10px); }
}

/* ================= MODAL ================= */
.modal {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(15, 23, 42, 0.6);
	backdrop-filter: blur(8px);
	-webkit-backdrop-filter: blur(8px);
	z-index: 999;
}

.modal-content {
	background: #ffffff;
	width: 480px;
	margin: 10% auto;
	padding: 28px;
	border-radius: 16px;
	box-shadow: 0 20px 40px rgba(0, 0, 0, 0.25);
	border: 1px solid rgba(226, 232, 240, 0.9);
}

.modal-content h3 {
	font-size: 18px;
	font-weight: 700;
	color: #0f172a;
	margin-bottom: 12px;
}

.modal-content p {
	font-size: 13.5px;
	color: #64748b;
	background: #f8fafc;
	padding: 12px;
	border-radius: 8px;
	border: 1px solid #e2e8f0;
	margin-bottom: 16px;
}

textarea {
	width: 100%;
	height: 120px;
	padding: 12px;
	border-radius: 8px;
	border: 1px solid #cbd5e1;
	font-size: 13.5px;
	font-family: inherit;
	color: #0f172a;
	resize: vertical;
	outline: none;
	transition: all 0.2s ease;
}

textarea:focus {
	border-color: #ff7a00;
	box-shadow: 0 0 0 3px rgba(255, 122, 0, 0.18);
}

.modal-content button[type="button"] {
	background: #f1f5f9;
	color: #475569;
	border: 1px solid #cbd5e1;
	padding: 7px 14px;
	border-radius: 8px;
	font-size: 12.5px;
	font-weight: 600;
	cursor: pointer;
	margin-left: 6px;
	transition: all 0.2s;
}

.modal-content button[type="button"]:hover {
	background: #e2e8f0;
	color: #0f172a;
}

@media (max-width: 640px) {
	body {
		padding: 20px 14px;
	}
	.modal-content {
		width: 92%;
		padding: 22px 18px;
	}
	h1 {
		font-size: 22px;
	}
}
</style>

<script>
	function openModal(id, message) {
		document.getElementById("mid").value = id;
		document.getElementById("msgText").innerText = message;
		document.getElementById("modal").style.display = "block";
	}

	function closeModal() {
		document.getElementById("modal").style.display = "none";
	}
</script>

</head>

<body>

	<div class="container">

		<h1>🗨 Customer Messages</h1>

		<a class="dashboard-btn"
			href="<%=request.getContextPath()%>/adminDashboard"> ← Dashboard
		</a>

		<%
		if ("1".equals(success)) {
		%>
		<div class="toast">Action completed successfully</div>
		<%
		}
		%>

		<div class="table-wrapper">
		<table>

			<tr>
				<th>Name</th>
				<th>Email</th>
				<th>Message</th>
				<th>Status</th>
				<th>Actions</th>
			</tr>

			<%
			if (messages != null) {
				for (ContactMessage m : messages) {
			%>

			<tr>

				<td><%=m.getName()%></td>
				<td><%=m.getEmail()%></td>
				<td><%=m.getMessage()%></td>

				<td><span
					class="badge 
<%=m.getStatus() == null ? "pending" : m.getStatus().toLowerCase()%>">

						<%=m.getStatus()%>

				</span></td>

				<td>

					<button class="btn reply"
						onclick="openModal('<%=m.getMessageId()%>',
'<%=m.getMessage()%>')">

						Reply</button>

					<form method="post"
						action="<%=request.getContextPath()%>/adminMessage"
						style="display: inline;">

						<input type="hidden" name="action" value="delete"> <input
							type="hidden" name="messageId" value="<%=m.getMessageId()%>">

						<button class="btn delete"
							onclick="return confirm('Delete message?')">Delete</button>

					</form>

				</td>

			</tr>

			<%
			}
			}
			%>

		</table>
		</div>

	</div>

	<!-- MODAL -->
	<div id="modal" class="modal">

		<div class="modal-content">

			<h3>Reply Message</h3>

			<p id="msgText"></p>

			<form method="post"
				action="<%=request.getContextPath()%>/adminMessage">

				<input type="hidden" name="action" value="reply"> <input
					type="hidden" name="messageId" id="mid">

				<textarea name="reply" placeholder="Write reply..."></textarea>

				<br>
				<br>

				<button class="btn reply">Send Reply</button>
				<button type="button" onclick="closeModal()">Close</button>

			</form>

		</div>

	</div>

</body>
</html>