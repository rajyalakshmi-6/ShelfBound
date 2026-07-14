package com.shelfbound.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.shelfbound.connection.DBConnection;
import com.shelfbound.dao.CartDAO;
import com.shelfbound.daoimpl.CartDAOImpl;
import com.shelfbound.model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================
    // REDIRECT GET REQUEST
    // =========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/customer/checkout.jsp")
               .forward(request, response);
    }

    // =========================
    // MAIN CHECKOUT LOGIC
    // =========================
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {

            HttpSession session = request.getSession();

            List<CartItem> cart =
                (List<CartItem>) session.getAttribute("cart");

            if (cart == null || cart.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // ============================================
            // READ ALL FORM FIELDS
            // ============================================
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String pincode = request.getParameter("pincode");
            String country = request.getParameter("country");
            String paymentMethod = request.getParameter("paymentMethod");

            // Fallback defaults
            if (fullName == null) fullName = "";
            if (phone == null) phone = "";
            if (address == null) address = "";
            if (city == null) city = "";
            if (state == null) state = "";
            if (pincode == null) pincode = "";
            if (country == null) country = "India";
            if (paymentMethod == null) paymentMethod = "COD";

            // Build complete shipping address
            String shippingAddress = fullName + "\n" +
                                     phone + "\n" +
                                     address + "\n" +
                                     city + ", " + state + " - " + pincode + "\n" +
                                     country;

            // ============================================
            // CALCULATE TOTAL WITH DISCOUNT
            // ============================================
            double subtotal = 0;
            for (CartItem item : cart) {
                subtotal += item.getBook().getPrice() * item.getQuantity();
            }

            // Check for applied coupon
            String appliedCoupon = (String) session.getAttribute("appliedCoupon");
            double discountPercent = 0;
            if ("WELCOME20".equals(appliedCoupon)) {
                discountPercent = 0.20;
            }
            double discountAmount = subtotal * discountPercent;
            double totalAmount = subtotal - discountAmount;

            Connection con = DBConnection.getConnection();

            // ============================================
            // INSERT ORDER
            // ============================================
            String orderSql =
                "INSERT INTO orders (user_id, total_amount, order_status, payment_method, shipping_address, order_date, discount_amount) " +
                "VALUES (?, ?, ?, ?, ?, NOW(), ?)";

            PreparedStatement ps = con.prepareStatement(orderSql,
                    PreparedStatement.RETURN_GENERATED_KEYS);

            ps.setInt(1, userId);
            ps.setDouble(2, totalAmount);
            ps.setString(3, "Pending");
            ps.setString(4, paymentMethod);
            ps.setString(5, shippingAddress);
            ps.setDouble(6, discountAmount);

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            int orderId = 0;

            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            // ============================================
            // INSERT ORDER ITEMS
            // ============================================
            String itemSql =
                "INSERT INTO order_items (order_id, book_id, quantity, price) VALUES (?, ?, ?, ?)";

            PreparedStatement itemPs = con.prepareStatement(itemSql);

            for (CartItem item : cart) {

                itemPs.setInt(1, orderId);
                itemPs.setInt(2, item.getBook().getBookId());
                itemPs.setInt(3, item.getQuantity());
                itemPs.setDouble(4, item.getBook().getPrice());

                itemPs.addBatch();
            }

            itemPs.executeBatch();

            // ============================================
            // UPDATE USER DETAILS (Save latest address)
            // ============================================
            String updateUserSql =
                "UPDATE users SET phone = ?, address = ?, city = ?, state = ?, pincode = ? " +
                "WHERE user_id = ?";

            PreparedStatement updatePs = con.prepareStatement(updateUserSql);
            updatePs.setString(1, phone);
            updatePs.setString(2, address);
            updatePs.setString(3, city);
            updatePs.setString(4, state);
            updatePs.setString(5, pincode);
            updatePs.setInt(6, userId);
            updatePs.executeUpdate();
            updatePs.close();

            // ============================================
            // ✅ CLEAR CART FROM DATABASE (NEW!)
            // ============================================
            CartDAO cartDAO = new CartDAOImpl();
            cartDAO.clearCart(userId);

            // ============================================
            // CLEAR CART AND COUPON FROM SESSION
            // ============================================
            session.removeAttribute("cart");
            session.removeAttribute("appliedCoupon");
            session.removeAttribute("couponError");

            // Close resources
            itemPs.close();
            rs.close();
            ps.close();
            con.close();

            // ============================================
            // REDIRECT TO SUCCESS PAGE
            // ============================================
            response.sendRedirect(
                request.getContextPath() + "/customer/order-success.jsp?orderId=" + orderId
            );

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}