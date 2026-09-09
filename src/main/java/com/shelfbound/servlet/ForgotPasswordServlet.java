package com.shelfbound.servlet;

import java.io.IOException;

import com.shelfbound.daoimpl.UserDAOImpl;
import com.shelfbound.util.EmailService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ForgotPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/customer/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        if (email != null) {
            email = email.trim();
        }

        if (email == null || email.isEmpty()) {
            request.setAttribute("errorMessage", "Please enter your registered email address.");
            request.getRequestDispatcher("/customer/forgot-password.jsp").forward(request, response);
            return;
        }

        try {
            UserDAOImpl dao = new UserDAOImpl();
            boolean exists = dao.isEmailExists(email);

            if (!exists) {
                request.setAttribute("errorMessage", "No account found with this email address. Please check and try again.");
                request.getRequestDispatcher("/customer/forgot-password.jsp").forward(request, response);
                return;
            }

            // Generate Password Reset OTP (Valid for 10 minutes)
            String resetOtp = EmailService.generateOtp();
            EmailService.sendOtpEmail(email, resetOtp, "password_reset");

            HttpSession session = request.getSession();
            session.setAttribute("resetEmail", email);
            session.setAttribute("resetOtp", resetOtp);
            session.setAttribute("resetOtpExpiry", System.currentTimeMillis() + (10 * 60 * 1000)); // 10 mins

            response.sendRedirect(request.getContextPath() + "/resetPassword");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Server error processing password reset request.");
            request.getRequestDispatcher("/customer/forgot-password.jsp").forward(request, response);
        }
    }
}
