package com.shelfbound.servlet;

import com.shelfbound.dao.WishlistDAO;
import com.shelfbound.daoimpl.WishlistDAOImpl;
import com.shelfbound.model.Book;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {

    private WishlistDAO wishlistDAO;

    @Override
    public void init() {
        wishlistDAO = new WishlistDAOImpl();
    }

    // ─── GET: Load and display the wishlist page ────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // FIX: session attribute is "userId" (camelCase), not "user_id"
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        List<Book> wishlistBooks = wishlistDAO.getWishlistByUserId(userId);
        request.setAttribute("wishlistBooks", wishlistBooks);

        request.getRequestDispatcher("/customer/wishlist.jsp")
               .forward(request, response);
    }

    // ─── POST: Add a book to wishlist ───────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // FIX: session attribute is "userId" (camelCase), not "user_id"
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String bookIdParam = request.getParameter("bookId");

        if (bookIdParam != null && !bookIdParam.isEmpty()) {
            int bookId = Integer.parseInt(bookIdParam);
            wishlistDAO.addToWishlist(userId, bookId);
        }

        // Redirect back to wherever the user came from
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}