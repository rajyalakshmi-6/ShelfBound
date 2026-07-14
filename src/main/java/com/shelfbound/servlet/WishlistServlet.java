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

 // ─── POST: Toggle a book in/out of the wishlist ─────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        if (session == null || session.getAttribute("userId") == null) {
            if (isAjax) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String bookIdParam = request.getParameter("bookId");
        String status = null;

        if (bookIdParam != null && !bookIdParam.isEmpty()) {
            int bookId = Integer.parseInt(bookIdParam);

            if (wishlistDAO.isInWishlist(userId, bookId)) {
                wishlistDAO.removeFromWishlist(userId, bookId);
                status = "removed";
            } else {
                wishlistDAO.addToWishlist(userId, bookId);
                status = "added";
            }
        }

        if (isAjax) {
            // Send back a plain-text status, no redirect, no page reload
            response.setContentType("text/plain");
            response.getWriter().write(status != null ? status : "error");
            return;
        }

        // Fallback for any non-AJAX callers (e.g. wishlist.jsp's "Remove" form)
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}