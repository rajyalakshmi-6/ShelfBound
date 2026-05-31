package com.shelfbound.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.shelfbound.dao.BookDAO;
import com.shelfbound.dao.CartDAO;
import com.shelfbound.daoimpl.BookDAOImpl;
import com.shelfbound.daoimpl.CartDAOImpl;
import com.shelfbound.model.Book;
import com.shelfbound.model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CartServlet extends HttpServlet {

    // ==========================================
    // ADD TO CART
    // ==========================================
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // ==========================================
            // STEP 1: READ BOOK ID FROM FORM
            // ==========================================
            // Example:
            // <input type="hidden" name="bookId" value="5">

            int bookId =
                    Integer.parseInt(
                            request.getParameter("bookId"));

            // ==========================================
            // STEP 2: READ QUANTITY
            // ==========================================

            String qtyParam =
                    request.getParameter("quantity");

            // If quantity is not sent,
            // use default value = 1

            int quantity =
                    (qtyParam != null)
                    ? Integer.parseInt(qtyParam)
                    : 1;

            // Prevent invalid quantity

            if (quantity <= 0) {
                quantity = 1;
            }

            // ==========================================
            // STEP 3: FETCH BOOK FROM DATABASE
            // ==========================================

            BookDAO bookDAO =
                    new BookDAOImpl();

            Book book =
                    bookDAO.getBookById(bookId);

            // If book doesn't exist

            if (book == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/home");

                return;
            }

            // ==========================================
            // STEP 4: GET CURRENT USER SESSION
            // ==========================================

            HttpSession session =
                    request.getSession();

            // LoginServlet stores:
            // session.setAttribute("userId", userId);

            Integer userId =
                    (Integer) session.getAttribute(
                            "userId");

            // ==========================================
            // STEP 5: USER NOT LOGGED IN
            // ==========================================

            if (userId == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/login");

                return;
            }

            // ==========================================
            // STEP 6: SAVE CART DATA TO DATABASE
            // ==========================================

            CartDAO cartDAO =
                    new CartDAOImpl();

            /*
             * If same book already exists
             * update quantity
             *
             * Else insert new row
             */

            cartDAO.addToCart(
                    userId,
                    bookId,
                    quantity);

            // ==========================================
            // STEP 7: UPDATE SESSION CART
            // ==========================================
            // We still keep session cart because
            // cart.jsp currently reads from session

            List<CartItem> cart =
                    (List<CartItem>)
                    session.getAttribute("cart");

            if (cart == null) {

                cart = new ArrayList<>();
            }

            boolean exists = false;

            // ==========================================
            // STEP 8: CHECK WHETHER BOOK ALREADY EXISTS
            // ==========================================

            for (CartItem item : cart) {

                if (item.getBook()
                        .getBookId() == bookId) {

                    // Increase quantity

                    item.setQuantity(
                            item.getQuantity()
                            + quantity);

                    exists = true;

                    break;
                }
            }

            // ==========================================
            // STEP 9: ADD NEW ITEM TO SESSION CART
            // ==========================================

            if (!exists) {

                CartItem newItem =
                        new CartItem();

                newItem.setBook(book);

                newItem.setQuantity(
                        quantity);

                cart.add(newItem);
            }

            // ==========================================
            // STEP 10: SAVE UPDATED CART INTO SESSION
            // ==========================================

            session.setAttribute(
                    "cart",
                    cart);

            // ==========================================
            // STEP 11: REDIRECT TO CART PAGE
            // ==========================================

            response.sendRedirect(
                    request.getContextPath()
                    + "/cart");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/home");
        }
    }

    // ==========================================
    // OPEN CART PAGE
    // ==========================================
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/customer/cart.jsp")
                .forward(request, response);
    }
}