package com.shelfbound.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.shelfbound.connection.DBConnection;
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

            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String pincode = request.getParameter("pincode");
            String paymentMethod = request.getParameter("paymentMethod");

            if (address == null) address = "";
            if (city == null) city = "";
            if (pincode == null) pincode = "";
            if (paymentMethod == null) paymentMethod = "COD";

            String shippingAddress = address + ", " + city + " - " + pincode;

            double totalAmount = 0;

            for (CartItem item : cart) {
                totalAmount += item.getBook().getPrice() * item.getQuantity();
            }

            Connection con = DBConnection.getConnection();

            String orderSql =
                "INSERT INTO orders (user_id, total_amount, order_status, payment_method, shipping_address) " +
                "VALUES (?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(orderSql,
                    PreparedStatement.RETURN_GENERATED_KEYS);

            ps.setInt(1, userId);
            ps.setDouble(2, totalAmount);
            ps.setString(3, "Pending");
            ps.setString(4, paymentMethod);
            ps.setString(5, shippingAddress);

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            int orderId = 0;

            if (rs.next()) {
                orderId = rs.getInt(1);
            }

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

            session.removeAttribute("cart");

            //  FIXED PATH (IMPORTANT)
            response.sendRedirect(
                request.getContextPath() + "/customer/order-success.jsp?orderId=" + orderId
            );

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}