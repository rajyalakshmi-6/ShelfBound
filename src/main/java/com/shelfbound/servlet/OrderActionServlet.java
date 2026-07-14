package com.shelfbound.servlet;

import java.io.IOException;

import com.shelfbound.dao.OrderDAO;
import com.shelfbound.daoimpl.OrderDAOImpl;
import com.shelfbound.model.Order;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class OrderActionServlet extends HttpServlet {

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

            // ── Parse action type ──
            String action = request.getParameter("action");
            if (action == null || (!action.equals("cancel") && !action.equals("return"))) {
                response.sendRedirect(request.getContextPath() + "/orders?error=invalidaction");
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

            String currentStatus = order.getStatus().toLowerCase();
            boolean success = false;

            if (action.equals("cancel")) {
                // ── CANCEL LOGIC ──
                if (currentStatus.equals("cancelled") ||
                    currentStatus.equals("delivered") ||
                    currentStatus.equals("completed") ||
                    currentStatus.equals("shipped") ||
                    currentStatus.equals("out for delivery") ||
                    currentStatus.equals("returned")) {
                    response.sendRedirect(request.getContextPath() + "/orderDetails?orderId=" + orderId + "&error=notcancellable");
                    return;
                }
                success = dao.updateOrderStatus(orderId, "Cancelled");
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/orderDetails?orderId=" + orderId + "&cancelled=true");
                } else {
                    response.sendRedirect(request.getContextPath() + "/orderDetails?orderId=" + orderId + "&error=failed");
                }

            } else if (action.equals("return")) {
                // ── RETURN LOGIC ──
                if (!currentStatus.equals("delivered") && !currentStatus.equals("completed")) {
                    response.sendRedirect(request.getContextPath() + "/orderDetails?orderId=" + orderId + "&error=notreturnable");
                    return;
                }

                // 7-day return window check from delivery date
                String deliveryDateStr = order.getDeliveryDate();
                boolean withinReturnWindow = true;

                if (deliveryDateStr != null && !deliveryDateStr.trim().isEmpty()) {
                    try {
                        java.time.LocalDateTime deliveryDate = java.time.LocalDateTime.parse(
                            deliveryDateStr, java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                        long daysSinceDelivery = java.time.temporal.ChronoUnit.DAYS.between(deliveryDate, java.time.LocalDateTime.now());
                        if (daysSinceDelivery > 7) {
                            withinReturnWindow = false;
                        }
                    } catch (Exception ex) {
                        // parsing failed — allow return gracefully
                    }
                } else {
                    // Fallback for old orders without delivery_date: check against order_date
                    String orderDateStr = order.getOrderDate();
                    if (orderDateStr != null && !orderDateStr.trim().isEmpty()) {
                        try {
                            java.time.LocalDateTime orderDate = java.time.LocalDateTime.parse(
                                orderDateStr, java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                            long daysSinceOrder = java.time.temporal.ChronoUnit.DAYS.between(orderDate, java.time.LocalDateTime.now());
                            if (daysSinceOrder > 7) {
                                withinReturnWindow = false;
                            }
                        } catch (Exception ex) {
                            // parsing failed — allow return gracefully
                        }
                    }
                }

                if (!withinReturnWindow) {
                    response.sendRedirect(request.getContextPath() + "/orderDetails?orderId=" + orderId + "&error=notreturnable");
                    return;
                }
                success = dao.updateOrderStatus(orderId, "Returned");
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/orderDetails?orderId=" + orderId + "&returned=true");
                } else {
                    response.sendRedirect(request.getContextPath() + "/orderDetails?orderId=" + orderId + "&error=returnfailed");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/orders?error=exception");
        }
    }
}