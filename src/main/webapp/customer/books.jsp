<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="com.shelfbound.model.Book" %>

<%
    List<Book> books        = (List<Book>) request.getAttribute("books");
    String     errorMessage = (String)     request.getAttribute("errorMessage");
    String     username     = (String)     session.getAttribute("username");

    // Wishlist IDs sent by BooksServlet — used to pre-fill hearts pink on load
    Set<Integer> wishlistIds = (Set<Integer>) request.getAttribute("wishlistIds");
    if (wishlistIds == null) wishlistIds = new HashSet<>();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Books - ShelfBound</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/books.css">
</head>
<body>

<!-- ================= NAVBAR ================= -->
<div class="navbar">

    <a href="${pageContext.request.contextPath}/home" class="logo-container">
        <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="ShelfBound Logo" class="logo-img">
        <div class="logo">
            <span class="logo-shelf">Shelf</span>
            <span class="logo-bound">Bound</span>
        </div>
    </a>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <a href="${pageContext.request.contextPath}/books">Books</a>
        <a href="${pageContext.request.contextPath}/cart">Cart</a>
        <a href="${pageContext.request.contextPath}/orders">Orders</a>
        <a href="${pageContext.request.contextPath}/wishlist">Wishlist</a>
        <a href="${pageContext.request.contextPath}/about">About</a>
        <a href="${pageContext.request.contextPath}/contact">Contact</a>

        <%
            if (username == null) {
        %>
            <a href="${pageContext.request.contextPath}/login">Login</a>
        <%
            } else {
        %>
            <span class="welcome-user">Welcome, <%= username %></span>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
        <%
            }
        %>

        <a href="${pageContext.request.contextPath}/admin">Admin</a>
    </div>

</div>

<!-- ================= MAIN LAYOUT ================= -->
<div class="layout">

    <!-- ================= SIDEBAR ================= -->
    <div class="sidebar">
        <h3>Categories</h3>
        <a href="${pageContext.request.contextPath}/books">All Books</a>
        <a href="${pageContext.request.contextPath}/books?categoryId=1">Fiction</a>
        <a href="${pageContext.request.contextPath}/books?categoryId=2">Non-Fiction</a>
        <a href="${pageContext.request.contextPath}/books?categoryId=3">Kids</a>
        <a href="${pageContext.request.contextPath}/books?categoryId=4">Competitive Exams</a>
        <a href="${pageContext.request.contextPath}/books?categoryId=5">Popular Books</a>
        <a href="${pageContext.request.contextPath}/books?categoryId=6">New Arrivals</a>
        <a href="${pageContext.request.contextPath}/books?categoryId=7">Adult Learning</a>
    </div>

    <!-- ================= BOOK SECTION ================= -->
    <div class="book-section">

        <h2>Books Collection</h2>

        <%
            if (errorMessage != null) {
        %>
            <div class="error-message"><%= errorMessage %></div>
        <%
            }
        %>

        <div class="book-grid">
            <%
                if (books != null && !books.isEmpty()) {
                    for (Book b : books) {
                        // Check if this book is already in wishlist
                        boolean isWishlisted = wishlistIds.contains(b.getBookId());
            %>

            <a class="book-link"
               href="${pageContext.request.contextPath}/book?id=<%= b.getBookId() %>">
                <div class="book-card">

                    <img src="<%= request.getContextPath() %>/assets/<%= b.getImageUrl() %>" alt="Book Image">

                    <h3><%= b.getTitle() %></h3>

                    <%-- AUTHOR ROW: heart pre-filled pink if book is already wishlisted --%>
                    <div class="author-row">
                        <span class="author-name"><%= b.getAuthor() %></span>
                        <form action="${pageContext.request.contextPath}/wishlist"
                              method="post"
                              class="wishlist-form"
                              onclick="event.stopPropagation()">
                            <input type="hidden" name="bookId" value="<%= b.getBookId() %>">
                            <button type="submit"
                                    class="wishlist-btn <%= isWishlisted ? "wishlisted" : "" %>"
                                    title="<%= isWishlisted ? "Remove from Wishlist" : "Add to Wishlist" %>"
                                    onclick="this.classList.toggle('wishlisted'); event.stopPropagation();">
                                &#9829;
                            </button>
                        </form>
                    </div>

                    <p class="price">&#8377; <%= b.getPrice() %></p>

                </div>
            </a>

            <%
                    }
                } else {
            %>
                <p class="no-books">No books available right now.</p>
            <%
                }
            %>
        </div>

    </div>

</div>

</body>
</html>