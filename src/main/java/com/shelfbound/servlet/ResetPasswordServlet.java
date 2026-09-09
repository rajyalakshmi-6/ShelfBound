package com.shelfbound.servlet;

import java.io.IOException;

import com.shelfbound.daoimpl.UserDAOImpl;
import com.shelfbound.util.EmailService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ResetPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String resetEmail = (session != null) ? (String) session.getAttribute("resetEmail") : null;

        if (resetEmail == null || resetEmail.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/forgotPassword");
            return;
        }

        request.getRequestDispatcher("/customer/reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        String resetEmail = (session != null) ? (String) session.getAttribute("resetEmail") : null;

        if (resetEmail == null || resetEmail.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Your reset session has expired. Please try again.");
            request.getRequestDispatcher("/customer/forgot-password.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");

        // 1. Resend Code Action
        if ("resend".equalsIgnoreCase(action)) {
            try {
                String newOtp = EmailService.generateOtp();
                EmailService.sendOtpEmail(resetEmail, newOtp, "password_reset");

                session.setAttribute("resetOtp", newOtp);
                session.setAttribute("resetOtpExpiry", System.currentTimeMillis() + (10 * 60 * 1000)); // 10 mins

                request.setAttribute("infoMessage", "A new reset code has been sent to " + resetEmail);
                request.getRequestDispatcher("/customer/reset-password.jsp").forward(request, response);
                return;
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Failed to resend code. Please try again.");
                request.getRequestDispatcher("/customer/reset-password.jsp").forward(request, response);
                return;
            }
        }

        // 2. Submit New Password Action
        String enteredOtp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (enteredOtp != null) {
            enteredOtp = enteredOtp.trim();
        }

        String sessionOtp = (String) session.getAttribute("resetOtp");
        Long expiry = (Long) session.getAttribute("resetOtpExpiry");

        // Validate OTP existence and expiry
        if (sessionOtp == null || expiry == null || System.currentTimeMillis() > expiry) {
            request.setAttribute("errorMessage", "The verification code has expired. Please request a new code.");
            request.getRequestDispatcher("/customer/reset-password.jsp").forward(request, response);
            return;
        }

        // Validate OTP match
        if (enteredOtp == null || !sessionOtp.equals(enteredOtp)) {
            request.setAttribute("errorMessage", "Invalid verification code. Please check and try again.");
            request.getRequestDispatcher("/customer/reset-password.jsp").forward(request, response);
            return;
        }

        // Validate password
        if (newPassword == null || newPassword.trim().length() < 6) {
            request.setAttribute("errorMessage", "Password must be at least 6 characters long.");
            request.getRequestDispatcher("/customer/reset-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match. Please try again.");
            request.getRequestDispatcher("/customer/reset-password.jsp").forward(request, response);
            return;
        }

        try {
            UserDAOImpl dao = new UserDAOImpl();
            boolean updated = dao.updatePassword(resetEmail, newPassword);

            if (updated) {
                // Clear session attributes
                session.removeAttribute("resetEmail");
                session.removeAttribute("resetOtp");
                session.removeAttribute("resetOtpExpiry");

                response.sendRedirect(request.getContextPath() + "/login?success=passwordReset");
            } else {
                request.setAttribute("errorMessage", "Failed to update password. Please try again.");
                request.getRequestDispatcher("/customer/reset-password.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Server error while updating password.");
            request.getRequestDispatcher("/customer/reset-password.jsp").forward(request, response);
        }
    }
}
