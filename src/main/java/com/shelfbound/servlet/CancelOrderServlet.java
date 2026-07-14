package com.shelfbound.servlet;

import java.io.IOException;

import com.shelfbound.dao.OrderDAO;
import com.shelfbound.daoimpl.OrderDAOImpl;
import com.shelfbound.model.Order;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class CancelOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {

            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            // ── Security: must be logged in ──
            if (userId == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // ── Parse orderId ──
            int orderId;
            try {
                orderId = Integer.parseInt(request.getParameter("orderId"));
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/orders?error=invalid");
                return;
            }

            OrderDAO dao = new OrderDAOImpl();

            // ── Verify ownership ──
            Order order = dao.getOrderById(orderId, userId);
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/orders?error=notfound");
                return;
            }

            // ── Check if order is cancellable ──
            String currentStatus = order.getStatus().toLowerCase();
            if (currentStatus.equals("cancelled") ||
                currentStatus.equals("delivered") ||
                currentStatus.equals("completed") ||
                currentStatus.equals("shipped") ||
                currentStatus.equals("out for delivery")) {
                response.sendRedirect(request.getContextPath() + "/orderDetails?orderId=" + orderId + "&error=notcancellable");
                return;
            }

            // ── Perform cancellation ──
            boolean cancelled = dao.updateOrderStatus(orderId, "Cancelled");

            if (cancelled) {
                // Success → redirect back with success message
                response.sendRedirect(request.getContextPath() + "/orderDetails?orderId=" + orderId + "&cancelled=true");
            } else {
                // Failed → redirect back with error
                response.sendRedirect(request.getContextPath() + "/orderDetails?orderId=" + orderId + "&error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/orders?error=exception");
        }
    }
}