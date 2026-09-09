<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.shelfbound.model.Book"%>

<%
List<Book> books = (List<Book>) request.getAttribute("books");
String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Books</title>

<style>

/* ================= GLOBAL ================= */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	font-family: 'Inter', "Segoe UI", -apple-system, sans-serif;
}

body {
	background: 
		radial-gradient(1100px circle at 15% 10%, rgba(30, 58, 138, 0.08), transparent 45%),
		radial-gradient(900px circle at 85% 25%, rgba(255, 122, 0, 0.06), transparent 50%),
		radial-gradient(1200px circle at 50% 80%, rgba(30, 58, 138, 0.05), transparent 60%),
		#f8fafc;
	min-height: 100vh;
	padding: 30px 20px;
	color: #0f172a;
	-webkit-font-smoothing: antialiased;
}

/* ================= CONTAINER ================= */
.container {
	max-width: 1300px;
	margin: auto;
}

h1 {
	font-size: 26px;
	font-weight: 800;
	color: #0f172a;
	letter-spacing: -0.5px;
	margin-bottom: 24px;
	display: flex;
	align-items: center;
	gap: 10px;
}

/* ================= TOP BAR ================= */
.top-bar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 24px;
}

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
}

.dashboard-btn:hover {
	background: #0f172a;
	transform: translateY(-2px);
	box-shadow: 0 8px 18px rgba(0, 0, 0, 0.18);
	color: #ff7a00;
}

.btn-add {
	background: linear-gradient(135deg, #10b981, #059669);
	color: #ffffff;
	padding: 10px 20px;
	border-radius: 10px;
	font-size: 13.5px;
	font-weight: 700;
	text-decoration: none;
	box-shadow: 0 4px 14px rgba(16, 185, 129, 0.35);
	transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
	display: inline-flex;
	align-items: center;
	gap: 6px;
}

.btn-add:hover {
	transform: translateY(-2px);
	box-shadow: 0 8px 20px rgba(16, 185, 129, 0.45);
	filter: brightness(1.05);
}

/* ================= TABLE WRAPPER ================= */
.table-wrapper {
	background: rgba(255, 255, 255, 0.92);
	backdrop-filter: blur(14px);
	-webkit-backdrop-filter: blur(14px);
	border: 1px solid rgba(226, 232, 240, 0.85);
	border-radius: 16px;
	overflow-x: auto;
	-webkit-overflow-scrolling: touch;
	box-shadow: 0 10px 30px rgba(15, 23, 42, 0.05), 0 1px 3px rgba(15, 23, 42, 0.04);
}

/* ================= TABLE ================= */
table {
	width: 100%;
	min-width: 760px;
	border-collapse: collapse;
	table-layout: auto;
}

th {
	background: #0f172a;
	color: #f8fafc;
	font-size: 12.5px;
	font-weight: 700;
	letter-spacing: 0.5px;
	text-transform: uppercase;
	padding: 15px 12px;
	text-align: center;
	border-bottom: 2px solid rgba(255, 122, 0, 0.3);
}

td {
	padding: 14px 12px;
	text-align: center;
	vertical-align: middle;
	border-bottom: 1px solid #f1f5f9;
	font-size: 13.5px;
	color: #334155;
	transition: background 0.2s ease;
}

tr:last-child td {
	border-bottom: none;
}

tr:hover td {
	background: rgba(248, 250, 252, 0.8);
}

/* ================= IMAGE ================= */
.book-img {
	width: 50px;
	height: 72px;
	object-fit: cover;
	border-radius: 6px;
	box-shadow: 0 3px 8px rgba(0, 0, 0, 0.12);
	transition: transform 0.25s ease, box-shadow 0.25s ease;
}

.book-img:hover {
	transform: scale(1.08);
	box-shadow: 0 6px 14px rgba(0, 0, 0, 0.18);
}

/* ================= STOCK INPUT ================= */
input[type="number"] {
	width: 65px;
	padding: 6px 8px;
	text-align: center;
	border: 1px solid #cbd5e1;
	border-radius: 7px;
	font-size: 13px;
	font-weight: 600;
	color: #0f172a;
	background: #ffffff;
	transition: all 0.2s ease;
	outline: none;
}

input[type="number"]:focus {
	border-color: #ff7a00;
	box-shadow: 0 0 0 3px rgba(255, 122, 0, 0.18);
}

/* ================= BUTTONS ================= */
.update-btn {
	background: #2563eb;
	color: #ffffff;
	border: none;
	padding: 6px 12px;
	border-radius: 7px;
	font-size: 12px;
	font-weight: 600;
	cursor: pointer;
	margin-left: 6px;
	box-shadow: 0 2px 6px rgba(37, 99, 235, 0.25);
	transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
}

.delete-btn {
	background: #ef4444;
	color: #ffffff;
	border: none;
	padding: 6px 12px;
	border-radius: 7px;
	font-size: 12px;
	font-weight: 600;
	cursor: pointer;
	box-shadow: 0 2px 6px rgba(239, 68, 68, 0.25);
	transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
}

.update-btn:hover {
	background: #1d4ed8;
	transform: translateY(-1px);
	box-shadow: 0 4px 10px rgba(37, 99, 235, 0.35);
}

.delete-btn:hover {
	background: #dc2626;
	transform: translateY(-1px);
	box-shadow: 0 4px 10px rgba(239, 68, 68, 0.35);
}

/* ================= TOAST POPUP (SMOKY GLASS) ================= */
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
	opacity: 0;
	transform: translateY(-15px);
	transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
	z-index: 1000;
}

.toast.show {
	opacity: 1;
	transform: translateY(0);
}

.toast.added,
.toast.updated,
.toast.deleted {
	color: #065f46;
}

@media (max-width: 640px) {
	body {
		padding: 20px 14px;
	}
	.top-bar {
		flex-direction: column;
		align-items: stretch;
		gap: 12px;
	}
	.dashboard-btn, .btn-add {
		justify-content: center;
		width: 100%;
	}
	h1 {
		font-size: 22px;
	}
}
</style>

</head>

<body>

<div class="container">

	<h1>📚 Manage Books</h1>

	<!-- TOAST -->
	<%
	if (success != null) {
	%>

	<div id="toast" class="toast <%=success%>">
		<%
		if ("added".equals(success)) out.print("Book Added Successfully");
		else if ("deleted".equals(success)) out.print("Book Deleted Successfully");
		else if ("updated".equals(success)) out.print("Stock Updated Successfully");
		else out.print("Action Completed");
		%>
	</div>

	<%
	}
	%>

	<!-- TOP BAR -->
	<div class="top-bar">

		<a class="dashboard-btn"
		   href="<%=request.getContextPath()%>/adminDashboard">
			← Dashboard
		</a>

		<a class="btn-add"
		   href="<%=request.getContextPath()%>/adminBook?action=showAddForm">
			+ Add Book
		</a>
		

	</div>

	<!-- TABLE -->
	<div class="table-wrapper">

		<table>

			<!-- 🔥 HEADER (now perfectly aligned) -->
			<tr>
				<th style="width:6%">ID</th>
				<th style="width:10%">Image</th>
				<th style="width:18%">Title</th>
				<th style="width:15%">Author</th>
				<th style="width:10%">Price</th>
				<th style="width:10%">Stock</th>
				<th style="width:15%">Update Stock</th>
				<th style="width:10%">Delete</th>
			</tr>

			<%
			if (books != null) {
				for (Book b : books) {
			%>

			<tr>

				<td><%=b.getBookId()%></td>

				<td>
					<img class="book-img"
     src="<%= request.getContextPath() %>/assets/<%= b.getImageUrl() %>"
     alt="Book Image">
				</td>

				<td><%=b.getTitle()%></td>
				<td><%=b.getAuthor()%></td>
				<td>₹ <%=b.getPrice()%></td>

				<td><%=b.getStockQuantity()%></td>

				<!-- UPDATE -->
				<td>
					<form method="post"
						action="<%=request.getContextPath()%>/adminBook">

						<input type="hidden" name="action" value="stock">
						<input type="hidden" name="bookId" value="<%=b.getBookId()%>">

						<input type="number"
							name="stockQuantity"
							value="<%=b.getStockQuantity()%>">

						<button class="update-btn">Update</button>

					</form>
				</td>

				<!-- DELETE -->
				<td>
					<form method="post"
						action="<%=request.getContextPath()%>/adminBook">

						<input type="hidden" name="action" value="delete">
						<input type="hidden" name="bookId" value="<%=b.getBookId()%>">

						<button class="delete-btn"
							onclick="return confirm('Delete book?')">
							Delete
						</button>

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

<!-- TOAST SCRIPT (2 seconds) -->
<script>
window.onload = function () {
	const toast = document.getElementById("toast");

	if (toast) {
		toast.classList.add("show");

		setTimeout(() => {
			toast.classList.remove("show");
		}, 2000); // 🔥 2 seconds as requested
	}
};
</script>

</body>
</html>