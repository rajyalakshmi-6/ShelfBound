<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Bookstore</title>

<style>
body {
    font-family: Arial;
    margin: 0;
    background: #f4f4f4;
    text-align: center;
}

.container {
    margin-top: 120px;
}

h1 {
    font-size: 40px;
    color: #222;
}

p {
    font-size: 18px;
    color: #666;
}

a {
    display: inline-block;
    margin-top: 20px;
    padding: 12px 25px;
    background: black;
    color: white;
    text-decoration: none;
    border-radius: 6px;
}
</style>

</head>

<body>

<div class="container">

    <h1>Welcome to Bookstore 📚</h1>

    <p>Every shelf tells a story. Find yours.</p>

    <a href="<%=request.getContextPath()%>/customer/login.jsp">
        Go to Login
    </a>

</div>

</body>
</html>