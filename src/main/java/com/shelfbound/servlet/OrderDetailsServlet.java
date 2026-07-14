package com.shelfbound.servlet;

import java.io.IOException;

import com.shelfbound.dao.OrderDAO;
import com.shelfbound.daoimpl.OrderDAOImpl;
import com.shelfbound.model.Order;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class OrderDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {

            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // ── Parse orderId safely ──
            int orderId;
            try {
                orderId = Integer.parseInt(request.getParameter("orderId"));
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/orders?error=invalid");
                return;
            }

            OrderDAO dao = new OrderDAOImpl();
            Order order = dao.getOrderById(orderId, userId);

            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/orders?error=notfound");
                return;
            }

            request.setAttribute("order", order);

            request.getRequestDispatcher("/customer/order-details.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/orders?error=exception");
        }
    }
}