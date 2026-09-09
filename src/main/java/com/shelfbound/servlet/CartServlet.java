package com.shelfbound.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.shelfbound.dao.BookDAO;
import com.shelfbound.dao.CartDAO;
import com.shelfbound.dao.OfferDAO;
import com.shelfbound.daoimpl.BookDAOImpl;
import com.shelfbound.daoimpl.CartDAOImpl;
import com.shelfbound.daoimpl.OfferDAOImpl;
import com.shelfbound.model.Book;
import com.shelfbound.model.CartItem;
import com.shelfbound.model.Offer;

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
            String ajaxHeader = request.getHeader("X-Requested-With");
            String acceptHeader = request.getHeader("Accept");
            boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(ajaxHeader)
                    || (acceptHeader != null && acceptHeader.contains("application/json"));

            if (userId == null) {
                if (isAjax) {
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\":false,\"message\":\"Please login to add books to your cart.\",\"redirect\":\"" + request.getContextPath() + "/login\"}");
                    return;
                }

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
            // STEP 11: REDIRECT TO CART PAGE OR RETURN JSON
            // ==========================================
            if (isAjax) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                int totalItems = 0;
                if (cart != null) {
                    for (CartItem ci : cart) {
                        totalItems += ci.getQuantity();
                    }
                }
                response.getWriter().write("{\"success\":true,\"message\":\"Added to cart!\",\"cartCount\":" + totalItems + "}");
                return;
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/cart");

        } catch (Exception e) {

            e.printStackTrace();

            String ajaxHeader = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equalsIgnoreCase(ajaxHeader)) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\":false,\"message\":\"An error occurred while adding to cart.\"}");
                return;
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/home");
        }
    }

    // ==========================================
    // OPEN CART PAGE & HANDLE COUPON AJAX
    // ==========================================
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String couponAction = request.getParameter("couponAction");

        if (couponAction != null) {
            HttpSession session = request.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            double subtotal = 0.0;
            if (cart != null) {
                for (CartItem ci : cart) {
                    subtotal += ci.getBook().getPrice() * ci.getQuantity();
                }
            }

            boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                    || (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json"));

            if ("apply".equalsIgnoreCase(couponAction)) {
                String couponInput = request.getParameter("couponInput");
                if (couponInput == null || couponInput.trim().isEmpty()) {
                    if (isAjax) {
                        response.setContentType("application/json;charset=UTF-8");
                        response.getWriter().write("{\"success\":false,\"message\":\"Please enter a coupon code.\"}");
                        return;
                    }
                    session.setAttribute("couponError", "Please enter a coupon code.");
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }

                String code = couponInput.trim().toUpperCase();
                OfferDAO offerDAO = new OfferDAOImpl();
                Offer offer = offerDAO.getOfferByCode(code);

                if (offer == null) {
                    session.removeAttribute("appliedCoupon");
                    session.removeAttribute("couponDiscountPercent");
                    session.setAttribute("couponError", "Invalid coupon code.");
                    if (isAjax) {
                        response.setContentType("application/json;charset=UTF-8");
                        response.getWriter().write("{\"success\":false,\"message\":\"Invalid coupon code.\"}");
                        return;
                    }
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }

                if (!offer.isActive()) {
                    session.removeAttribute("appliedCoupon");
                    session.removeAttribute("couponDiscountPercent");
                    session.setAttribute("couponError", "This coupon is currently inactive.");
                    if (isAjax) {
                        response.setContentType("application/json;charset=UTF-8");
                        response.getWriter().write("{\"success\":false,\"message\":\"This coupon is currently inactive.\"}");
                        return;
                    }
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }

                if (subtotal < offer.getMinOrderAmount()) {
                    session.removeAttribute("appliedCoupon");
                    session.removeAttribute("couponDiscountPercent");
                    String msg = "Minimum cart total of ₹" + String.format("%.2f", offer.getMinOrderAmount()) + " required for this coupon.";
                    session.setAttribute("couponError", msg);
                    if (isAjax) {
                        response.setContentType("application/json;charset=UTF-8");
                        response.getWriter().write("{\"success\":false,\"message\":\"" + msg + "\"}");
                        return;
                    }
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }

                // Valid coupon!
                double discountPercent = offer.getDiscountPercentage() / 100.0;
                double discountAmount = subtotal * discountPercent;
                double newTotal = subtotal - discountAmount;

                session.setAttribute("appliedCoupon", offer.getCouponCode());
                session.setAttribute("couponDiscountPercent", discountPercent);
                session.removeAttribute("couponError");

                if (isAjax) {
                    response.setContentType("application/json;charset=UTF-8");
                    String msg = "Yay! Coupon applied! " + String.format("%.0f", offer.getDiscountPercentage()) + "% OFF";
                    response.getWriter().write("{\"success\":true,\"message\":\"" + msg + "\",\"couponCode\":\"" + offer.getCouponCode() + "\",\"discountPercent\":" + offer.getDiscountPercentage() + ",\"discountAmount\":" + discountAmount + ",\"newTotal\":" + newTotal + "}");
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/cart");
                return;

            } else if ("clear".equalsIgnoreCase(couponAction)) {
                session.removeAttribute("appliedCoupon");
                session.removeAttribute("couponDiscountPercent");
                session.removeAttribute("couponError");

                if (isAjax) {
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"success\":true,\"message\":\"Coupon removed.\",\"subtotal\":" + subtotal + "}");
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
        }

        request.getRequestDispatcher(
                "/customer/cart.jsp")
                .forward(request, response);
    }
}