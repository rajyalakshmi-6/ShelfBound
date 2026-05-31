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

            // 2. GET SESSION
            HttpSession session = request.getSession();

            List<CartItem> cart =
                (List<CartItem>) session.getAttribute("cart");

            if (cart == null) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // 3. REMOVE ITEM
            cart.removeIf(item ->
                item.getBook().getBookId() == bookId
            );

            // 4. UPDATE SESSION
            session.setAttribute("cart", cart);

            // 5. REDIRECT BACK TO CART
            response.sendRedirect(request.getContextPath() + "/cart");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}