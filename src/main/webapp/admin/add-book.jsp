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
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Add Book</title>

<style>

* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    font-family: 'Inter', "Segoe UI", -apple-system, sans-serif;
}

body {
    margin: 0;
    padding: 40px 20px;
    background: 
        radial-gradient(1000px circle at 20% 15%, rgba(30, 58, 138, 0.08), transparent 45%),
        radial-gradient(800px circle at 80% 30%, rgba(255, 122, 0, 0.06), transparent 50%),
        radial-gradient(1100px circle at 50% 85%, rgba(30, 58, 138, 0.05), transparent 60%),
        #f8fafc;
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    color: #0f172a;
    -webkit-font-smoothing: antialiased;
}

/* FORM CARD */
.form-container {
    width: 100%;
    max-width: 480px;
    background: rgba(255, 255, 255, 0.94);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    padding: 32px 30px;
    border-radius: 18px;
    border: 1px solid rgba(226, 232, 240, 0.85);
    box-shadow: 0 16px 36px rgba(15, 23, 42, 0.06), 0 1px 3px rgba(15, 23, 42, 0.04);
}

h2 {
    text-align: center;
    color: #0f172a;
    font-size: 22px;
    font-weight: 800;
    letter-spacing: -0.4px;
    margin-bottom: 24px;
}

label {
    display: block;
    font-size: 13px;
    font-weight: 600;
    color: #475569;
    margin-bottom: 4px;
}

/* INPUTS */
input, textarea {
    width: 100%;
    padding: 10px 14px;
    margin-bottom: 16px;
    border: 1px solid #cbd5e1;
    border-radius: 9px;
    font-size: 13.5px;
    font-family: inherit;
    color: #0f172a;
    background: #ffffff;
    outline: none;
    transition: all 0.2s ease;
}

input:focus, textarea:focus {
    border-color: #ff7a00;
    box-shadow: 0 0 0 3px rgba(255, 122, 0, 0.18);
}

textarea {
    resize: none;
}

/* BUTTON */
button {
    width: 100%;
    padding: 12px;
    background: #0f172a;
    color: white;
    font-size: 14px;
    font-weight: 700;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    box-shadow: 0 4px 12px rgba(15, 23, 42, 0.2);
    transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
    margin-top: 6px;
}

button:hover {
    background: #ff7a00;
    transform: translateY(-2px);
    box-shadow: 0 8px 18px rgba(255, 122, 0, 0.35);
}

/* BACK BUTTON */
.back-btn {
    display: block;
    text-align: center;
    margin-top: 18px;
    text-decoration: none;
    font-size: 13px;
    font-weight: 600;
    color: #64748b;
    transition: color 0.2s ease;
}

.back-btn:hover {
    color: #0f172a;
}

/* POPUP */
.popup {
    position: fixed;
    top: 24px;
    right: 24px;
    padding: 14px 20px;
    border-radius: 12px;
    font-size: 13.5px;
    font-weight: 700;
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    animation: fadeIn 0.4s ease-out;
    z-index: 1000;
}

.success {
    background: rgba(16, 185, 129, 0.14);
    color: #065f46;
    border: 1px solid rgba(16, 185, 129, 0.35);
    box-shadow: 0 12px 28px rgba(0, 0, 0, 0.1);
}

.error {
    background: rgba(239, 68, 68, 0.14);
    color: #991b1b;
    border: 1px solid rgba(239, 68, 68, 0.35);
    box-shadow: 0 12px 28px rgba(0, 0, 0, 0.1);
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(-10px); }
    to { opacity: 1; transform: translateY(0); }
}

@media (max-width: 520px) {
    body {
        padding: 20px 14px;
        align-items: flex-start;
    }
    .form-container {
        padding: 24px 18px;
        border-radius: 14px;
    }
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