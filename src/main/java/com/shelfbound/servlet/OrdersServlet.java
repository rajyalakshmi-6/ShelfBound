package com.shelfbound.servlet;

import java.io.IOException;
import java.util.List;

import com.shelfbound.dao.OrderDAO;
import com.shelfbound.daoimpl.OrderDAOImpl;
import com.shelfbound.model.Order;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class OrdersServlet extends HttpServlet {

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

            OrderDAO dao = new OrderDAOImpl();
            List<Order> orders = dao.getOrdersByUser(userId);

            request.setAttribute("orders", orders);

            request.getRequestDispatcher("/customer/orders.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}