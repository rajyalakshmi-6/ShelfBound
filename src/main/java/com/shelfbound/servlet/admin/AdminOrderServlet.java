package com.shelfbound.servlet.admin;

import java.io.IOException;
import java.util.List;

import com.shelfbound.dao.OrderDAO;
import com.shelfbound.daoimpl.OrderDAOImpl;
import com.shelfbound.model.Order;
import com.shelfbound.model.User;
import com.shelfbound.util.EmailService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================
    // VIEW ORDERS
    // =========================
    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/adminLogin");
            return;
        }

        try {

            OrderDAO dao = new OrderDAOImpl();

            List<Order> orders = dao.getAllOrders();

            request.setAttribute("orders", orders);

            request.getRequestDispatcher("/admin/manage-orders.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    // =========================
    // UPDATE ORDER STATUS
    // =========================
    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/adminLogin");
            return;
        }

        String action = request.getParameter("action");

        try {

            OrderDAO dao = new OrderDAOImpl();

            if ("updateStatus".equals(action)) {

                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String status = request.getParameter("status");

                dao.updateOrderStatus(orderId, status);

                // Send real email notification to customer
                try {
                    User user = dao.getUserByOrderId(orderId);
                    if (user != null && user.getEmail() != null) {
                        EmailService.sendOrderStatusUpdate(user.getEmail(), user.getUsername(), orderId, status);
                    }
                } catch (Exception ex) {
                    System.err.println("[AdminOrderServlet] Failed to send status update email: " + ex.getMessage());
                }
            }

            response.sendRedirect(
                request.getContextPath() + "/adminOrder"
            );

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}