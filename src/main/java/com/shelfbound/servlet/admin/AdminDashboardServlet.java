package com.shelfbound.servlet.admin;

import java.io.IOException;

import com.shelfbound.dao.AdminDAO;
import com.shelfbound.daoimpl.AdminDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminDashboardServlet
extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if(session == null ||
           session.getAttribute("adminId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/adminLogin");

            return;
        }

        AdminDAO dao =
                new AdminDAOImpl();

        int totalUsers =
                dao.getTotalUsers();

        int totalBooks =
                dao.getTotalBooks();

        int totalOrders =
                dao.getTotalOrders();

        int pendingOrders =
                dao.getPendingOrders();

        request.setAttribute(
                "totalUsers",
                totalUsers);

        request.setAttribute(
                "totalBooks",
                totalBooks);

        request.setAttribute(
                "totalOrders",
                totalOrders);

        request.setAttribute(
                "pendingOrders",
                pendingOrders);

        request.getRequestDispatcher(
                "/admin/admin-dashboard.jsp")
                .forward(request, response);
    }
}