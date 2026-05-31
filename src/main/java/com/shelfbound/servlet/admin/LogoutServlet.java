package com.shelfbound.servlet.admin;

import java.io.IOException;  // helping to logout admin and user

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get current session (if exists)
        HttpSession session = request.getSession(false);

        // 2. Invalidate session (logout user/admin)
        if (session != null) {
            session.invalidate();
        }

        // 3. Redirect to HOME page
        response.sendRedirect(
                request.getContextPath() + "/home"
        );
    }
}