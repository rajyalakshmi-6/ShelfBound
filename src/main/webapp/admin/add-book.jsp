<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String successMessage = (String) session.getAttribute("successMessage");
String errorMessage = (String) session.getAttribute("errorMessage");

// clear after showing once
session.removeAttribute("successMessage");
session.removeAttribute("errorMessage");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Book</title>

<style>

body {
    margin: 0;
    padding: 0;
    font-family: Segoe UI, sans-serif;
    background: linear-gradient(135deg, #dbeafe, #eff6ff, #f8fbff);
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
}

/* FORM CARD */
/* FORM BOX */
.form-container {
    width: 100%;
    max-width: 450px;   /*  THIS FIXES OVERFLOW */
    background: white;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 8px 20px rgba(0,0,0,0.1);
}

h2 {
    text-align: center;
    color: #1e3a8a;
    margin-bottom: 20px;
}

/* INPUTS */
input, textarea {
    width: 100%;
    padding: 10px;
    margin-top: 5px;
    margin-bottom: 15px;
    border: 1px solid #cbd5e1;
    border-radius: 6px;
}

textarea {
    resize: none;
}

/* BUTTON */
button {
    width: 100%;
    padding: 12px;
    background: #1e3a8a;
    color: white;
    border: none;
    border-radius: 6px;
    cursor: pointer;
}

button:hover {
    background: #163172;
}


/* BACK BUTTON */
.back-btn {
    display: block;
    text-align: center;
    margin-top: 15px;
    text-decoration: none;
    color: #1e3a8a;
}

/* POPUP */
.popup {
    position: fixed;
    top: 20px;
    right: 20px;
    padding: 15px 20px;
    border-radius: 8px;
    color: white;
    font-weight: bold;
    animation: fadeIn 0.5s;
}

.success {
    background: #22c55e;
}

.error {
    background: #ef4444;
}

@keyframes fadeIn {
    from {opacity: 0; transform: translateY(-10px);}
    to {opacity: 1; transform: translateY(0);}
}

</style>

</head>

<body>

<% if (successMessage != null) { %>
<div class="popup success">
    <%= successMessage %>
</div>
<% } %>

<% if (errorMessage != null) { %>
<div class="popup error">
    <%= errorMessage %>
</div>
<% } %>

<div class="form-container">

    <h2>Add New Book</h2>

    <form action="<%=request.getContextPath()%>/adminBook"
          method="post">

        <input type="hidden" name="action" value="add">

        <label>Title</label>
        <input type="text" name="title" required>

        <label>Author</label>
        <input type="text" name="author" required>

        <label>Description</label>
        <textarea name="description"></textarea>

        <label>Price</label>
        <input type="number" step="0.01" name="price" required>

        <label>Stock Quantity</label>
        <input type="number" name="stockQuantity" required>

        <label>Image URL</label>
        <input type="text" name="imageUrl">

        <button type="submit">Add Book</button>

    </form>

    <a class="back-btn"
       href="<%=request.getContextPath()%>/adminBook?action=view">
       ← Back to Books
    </a>

</div>

</body>
</html>