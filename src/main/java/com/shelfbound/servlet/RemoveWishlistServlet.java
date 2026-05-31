package com.shelfbound.servlet;

import com.shelfbound.dao.WishlistDAO;
import com.shelfbound.daoimpl.WishlistDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/removeWishlist")
public class RemoveWishlistServlet extends HttpServlet {

    private WishlistDAO wishlistDAO;

    @Override
    public void init() {
        wishlistDAO = new WishlistDAOImpl();
    }

    // ─── POST: Remove a book from wishlist ──────────────────────────────────────
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
            wishlistDAO.removeFromWishlist(userId, bookId);
        }

        // Always redirect back to wishlist page after removal
        response.sendRedirect(request.getContextPath() + "/wishlist");
    }
}