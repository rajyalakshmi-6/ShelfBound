<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.shelfbound.model.Book"%>

<%
List<Book> books =
(List<Book>) request.getAttribute("books");
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Manage Books</title>

<link rel="stylesheet"
href="<%=request.getContextPath()%>/assets/css/admin-books.css">

</head>

<body>

<div class="container">

    <div class="top-bar">

        <h1>Manage Books</h1>

        <a href="<%=request.getContextPath()%>/adminBook?action=addForm"
           class="add-btn">

            Add New Book

        </a>

    </div>

    <table>

        <thead>

        <tr>

            <th>ID</th>

            <th>Image</th>

            <th>Title</th>

            <th>Author</th>

            <th>Price</th>

            <th>Stock</th>

            <th>Actions</th>

        </tr>

        </thead>

        <tbody>

        <%
        if(books != null){
            for(Book b : books){
        %>

        <tr>

            <td><%=b.getBookId()%></td>

            <td>
                <img
                src="<%=b.getImageUrl()%>"
                class="book-image"
                alt="Book">
            </td>

            <td><%=b.getTitle()%></td>

            <td><%=b.getAuthor()%></td>

            <td>₹ <%=b.getPrice()%></td>

            <td><%=b.getStockQuantity()%></td>

            <td>

                <a href="<%=request.getContextPath()%>/adminBook?action=delete&id=<%=b.getBookId()%>"
                   class="delete-btn">

                    Delete

                </a>

            </td>

        </tr>

        <%
            }
        }
        %>

        </tbody>

    </table>

</div>

</body>
</html>