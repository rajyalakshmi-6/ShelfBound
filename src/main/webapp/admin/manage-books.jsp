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
<title>Manage Books</title>

<style>

/* ================= GLOBAL ================= */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	font-family: Segoe UI, sans-serif;
}

body {
	background: linear-gradient(135deg, #dbeafe, #eff6ff, #f8fbff);
	padding: 25px;
}

/* ================= CONTAINER ================= */
.container {
	max-width: 1300px;
	margin: auto;
}

h1 {
	color: #1e3a8a;
	margin-bottom: 20px;
}

/* ================= TOP BAR ================= */
.top-bar {
	display: flex;
	justify-content: space-between;
	margin-bottom: 20px;
}

.dashboard-btn, .btn-add {
	padding: 10px 16px;
	border-radius: 8px;
	text-decoration: none;
	color: white;
	font-weight: 600;
}

.dashboard-btn {
    background: #1e3a8a;
    color: white;
    padding: 10px 16px;
    border-radius: 8px;
    text-decoration: none;
    font-weight: 600;
    transition: all 0.25s ease;
}

/* LIGHT HOVER EFFECT */
.dashboard-btn:hover {
    background: #243b9f;   /* slightly lighter blue */
    transform: translateY(-2px);
    box-shadow: 0 4px 10px rgba(30, 58, 138, 0.25);
}


.btn-add {
    background: linear-gradient(135deg, #22c55e, #16a34a);
    color: white;
    padding: 10px 16px;
    border-radius: 10px;
    font-weight: 600;
    box-shadow: 0 4px 10px rgba(34, 197, 94, 0.3);
    transition: 0.3s;
}

.btn-add:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 14px rgba(34, 197, 94, 0.4);
}
/* ================= TABLE WRAPPER ================= */
.table-wrapper {
	background: white;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
}

/* ================= TABLE ================= */
table {
	width: 100%;
	border-collapse: collapse;
	table-layout: fixed;   /* 🔥 FIX ALIGNMENT ISSUE */
}

th {
	background: #1e3a8a;
	color: white;
	padding: 14px;
	text-align: center;
}

td {
	padding: 12px;
	text-align: center;
	vertical-align: middle;
	border-bottom: 1px solid #eee;
}

/* ================= IMAGE ================= */
.book-img {
	width: 60px;
	height: 85px;
	object-fit: cover;
	border-radius: 4px;
}

/* ================= STOCK INPUT FIX ================= */
input[type="number"] {
	width: 60px;   /* 🔥 FIXED WIDTH FOR ALIGNMENT */
	padding: 5px;
	text-align: center;
	border: 1px solid #ccc;
	border-radius: 5px;
}

/* ================= BUTTONS ================= */
.update-btn {
	background: #2563eb;
	color: white;
	border: none;
	padding: 6px 10px;
	border-radius: 5px;
	cursor: pointer;
	margin-left: 5px;
}

.delete-btn {
	background: #dc2626;
	color: white;
	border: none;
	padding: 6px 10px;
	border-radius: 5px;
	cursor: pointer;
}

.update-btn:hover,
.delete-btn:hover {
	opacity: 0.9;
}

/* ================= TOAST POPUP (LIGHT GREEN) ================= */
.toast {
	position: fixed;
	top: 20px;
	right: 20px;
	background: rgba(34, 197, 94, 0.15); /* light green */
	color: #166534;
	padding: 14px 18px;
	border-radius: 10px;
	font-weight: 600;
	border: 1px solid rgba(34, 197, 94, 0.4);
	box-shadow: 0 10px 25px rgba(0,0,0,0.1);
	backdrop-filter: blur(6px);

	opacity: 0;
	transform: translateY(-15px);
	transition: all 0.3s ease;
}

.toast.show {
	opacity: 1;
	transform: translateY(0);
}

/* success variants */
.toast.added,
.toast.updated,
.toast.deleted {
	color: #166534;
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