package com.shelfbound.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import com.shelfbound.model.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class RemoveCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. GET BOOK ID
            int bookId = Integer.parseInt(request.getParameter("bookId"));

            // 1b. GET MODE — "increase", "decrease", or null (null = full remove)
            String mode = request.getParameter("mode");

            // 2. GET EXISTING SESSION ONLY — false means do NOT create a new one
            HttpSession session = request.getSession(false);

            // if session is missing (e.g. expired), just go back to cart page
            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            List<CartItem> cart =
                (List<CartItem>) session.getAttribute("cart");

            if (cart == null) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // 3. DECIDE WHAT TO DO BASED ON MODE
            if ("increase".equals(mode)) {
                // + button: find the item, qty + 1
                for (CartItem item : cart) {
                    if (item.getBook().getBookId() == bookId) {
                        item.setQuantity(item.getQuantity() + 1);
                        break;
                    }
                }

            } else if ("decrease".equals(mode)) {
                // − button: find the item, qty - 1, never below 1
                for (CartItem item : cart) {
                    if (item.getBook().getBookId() == bookId) {
                        if (item.getQuantity() > 1) {
                            item.setQuantity(item.getQuantity() - 1);
                        }
                        break;
                    }
                }

            } else {
                // no mode sent = normal Remove popup "Cancel" button — full delete
                cart.removeIf(item ->
                    item.getBook().getBookId() == bookId
                );
            }

            // 4. UPDATE SESSION (same session object, just re-confirming the attribute)
            session.setAttribute("cart", cart);

            // 5. REDIRECT BACK TO CART
            response.sendRedirect(request.getContextPath() + "/cart");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}