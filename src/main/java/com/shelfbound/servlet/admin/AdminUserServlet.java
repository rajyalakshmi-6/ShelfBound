package com.shelfbound.servlet.admin;

import java.io.IOException;
import java.util.List;

import com.shelfbound.dao.UserDAO;
import com.shelfbound.daoimpl.UserDAOImpl;
import com.shelfbound.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminUserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/adminLogin");
            return;
        }

        try {
            UserDAO dao = new UserDAOImpl();
            List<User> users = dao.getAllUsers();
            request.setAttribute("users", users);

            request.getRequestDispatcher("/admin/manage-users.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/adminLogin");
            return;
        }

        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        try {
            if (userIdStr != null && !userIdStr.trim().isEmpty()) {
                int userId = Integer.parseInt(userIdStr.trim());
                UserDAO dao = new UserDAOImpl();

                if ("block".equalsIgnoreCase(action)) {
                    dao.updateUserStatus(userId, "BLOCKED");
                } else if ("unblock".equalsIgnoreCase(action)) {
                    dao.updateUserStatus(userId, "ACTIVE");
                }
            }
            response.sendRedirect(request.getContextPath() + "/adminUser?success=1");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
