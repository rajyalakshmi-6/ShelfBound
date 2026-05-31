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
<title>Manage Messages</title>

<style>

/* ================= BACKGROUND ================= */
body {
	margin: 0;
	font-family: Segoe UI;
	background: linear-gradient(135deg, #dbeafe, #eff6ff);
}

/* ================= CONTAINER ================= */
.container {
	max-width: 1200px;
	margin: auto;
	padding: 30px;
}

/* ================= HEADER ================= */
h1 {
	color: #1e3a8a;
}

/* ================= DASHBOARD BUTTON ================= */
.dashboard-btn {
	background: #1e3a8a;
	color: white;
	padding: 10px 16px;
	border-radius: 8px;
	text-decoration: none;
	font-weight: 600;
	display: inline-block;
	transition: all 0.25s ease;
}

/* HOVER EFFECT */
.dashboard-btn:hover {
	background: #243b9f;
	transform: translateY(-2px);
	box-shadow: 0 4px 10px rgba(30, 58, 138, 0.25);
}

/* ================= TABLE ================= */
table {
	width: 100%;
	background: white;
	border-collapse: collapse;
	margin-top: 20px;
	border-radius: 10px;
	overflow: hidden;
}

th {
	background: #1e3a8a;
	color: white;
	padding: 12px;
}

td {
	padding: 12px;
	text-align: center;
	border-bottom: 1px solid #eee;
	vertical-align: middle;
}

/* ================= STATUS BADGES ================= */
.badge {
	padding: 5px 10px;
	border-radius: 20px;
	font-size: 12px;
	font-weight: bold;
}

.pending {
	background: #fef3c7;
	color: #92400e;
}

.read {
	background: #dbeafe;
	color: #1e40af;
}

.replied {
	background: #dcfce7;
	color: #166534;
}

/* ================= BUTTONS ================= */
.btn {
	padding: 6px 10px;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	font-weight: 600;
}

.reply {
	background: #2563eb;
	color: white;
}

.delete {
	background: #dc2626;
	color: white;
}

/* ================= TOAST POPUP ================= */
.toast {
	position: fixed;
	top: 20px;
	right: 20px;
	background: rgba(220, 252, 231, 0.95);
	color: #166534;
	padding: 12px 16px;
	border-radius: 8px;
	animation: fade 1s ease-in-out;
	font-weight: 600;
}

@
keyframes fade { 0%{
	opacity: 0;
	transform: translateY(-10px);
}

10
%
{
opacity
:
1;
}
80
%
{
opacity
:
1;
}
100
%
{
opacity
:
0;
}
}

/* ================= MODAL ================= */
.modal {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5);
}

.modal-content {
	background: white;
	width: 450px;
	margin: 10% auto;
	padding: 20px;
	border-radius: 12px;
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
}

textarea {
	width: 100%;
	height: 120px;
	padding: 10px;
	border-radius: 6px;
	border: 1px solid #ccc;
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