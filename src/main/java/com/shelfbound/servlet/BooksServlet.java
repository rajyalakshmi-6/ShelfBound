package com.shelfbound.servlet;

import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.shelfbound.dao.BookDAO;
import com.shelfbound.dao.WishlistDAO;
import com.shelfbound.daoimpl.BookDAOImpl;
import com.shelfbound.daoimpl.WishlistDAOImpl;
import com.shelfbound.model.Book;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class BooksServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // DAO OBJECT
            BookDAO dao = new BookDAOImpl();

            // GET CATEGORY PARAMETER
            String categoryParam = request.getParameter("categoryId");

            List<Book> books;

            // =========================
            // FILTER BY CATEGORY
            // =========================
            if (categoryParam != null && !categoryParam.trim().isEmpty()) {
                int categoryId = Integer.parseInt(categoryParam);
                books = dao.getBooksByCategory(categoryId);
            } else {
                // ALL BOOKS
                books = dao.getAllBooks();
            }

            // SEND BOOKS TO JSP
            request.setAttribute("books", books);

            // =========================
            // WISHLIST IDS FOR LOGGED-IN USER
            // Fetched here so heart button shows pink
            // for already-wishlisted books on page load
            // =========================
            Set<Integer> wishlistIds = new HashSet<>();
            String username = (String) request.getSession().getAttribute("username");
            if (username != null) {
                WishlistDAO wishlistDAO = new WishlistDAOImpl();
                List<Integer> ids = wishlistDAO.getWishlistBookIds(username);
                wishlistIds.addAll(ids);
            }
            request.setAttribute("wishlistIds", wishlistIds);

            // FORWARD
            request.getRequestDispatcher(
                "/customer/books.jsp"
            ).forward(request, response);

        } catch (NumberFormatException e) {

            e.printStackTrace();

            // WISHLIST IDS — also set on error path so JSP never gets null
            Set<Integer> wishlistIds = new HashSet<>();
            String username = (String) request.getSession().getAttribute("username");
            if (username != null) {
                try {
                    WishlistDAO wishlistDAO = new WishlistDAOImpl();
                    List<Integer> ids = wishlistDAO.getWishlistBookIds(username);
                    wishlistIds.addAll(ids);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            request.setAttribute("wishlistIds", wishlistIds);
            request.setAttribute("errorMessage", "Invalid category selected.");

            request.getRequestDispatcher(
                "/customer/books.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            // WISHLIST IDS — also set on error path so JSP never gets null
            Set<Integer> wishlistIds = new HashSet<>();
            String username = (String) request.getSession().getAttribute("username");
            if (username != null) {
                try {
                    WishlistDAO wishlistDAO = new WishlistDAOImpl();
                    List<Integer> ids = wishlistDAO.getWishlistBookIds(username);
                    wishlistIds.addAll(ids);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            request.setAttribute("wishlistIds", wishlistIds);
            request.setAttribute("errorMessage", "Unable to load books.");

            request.getRequestDispatcher(
                "/customer/books.jsp"
            ).forward(request, response);
        }
    }
}