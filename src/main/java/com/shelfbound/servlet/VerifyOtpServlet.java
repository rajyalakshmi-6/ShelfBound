package com.shelfbound.servlet;

import java.io.IOException;

import com.shelfbound.daoimpl.UserDAOImpl;
import com.shelfbound.model.User;
import com.shelfbound.util.EmailService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class VerifyOtpServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pendingUser") == null) {
            response.sendRedirect(request.getContextPath() + "/customer/register.jsp");
            return;
        }

        request.getRequestDispatcher("/customer/verify-otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("pendingUser") == null) {
            response.sendRedirect(request.getContextPath() + "/customer/register.jsp");
            return;
        }

        String action = request.getParameter("action");
        User pendingUser = (User) session.getAttribute("pendingUser");
        String regOtp = (String) session.getAttribute("regOtp");
        Long regOtpExpiry = (Long) session.getAttribute("regOtpExpiry");

        // RESEND OTP ACTION
        if ("resend".equalsIgnoreCase(action)) {
            String newOtp = EmailService.generateOtp();
            EmailService.sendOtpEmail(pendingUser.getEmail(), newOtp, "registration");

            session.setAttribute("regOtp", newOtp);
            session.setAttribute("regOtpExpiry", System.currentTimeMillis() + (5 * 60 * 1000)); // 5 mins

            request.setAttribute("infoMessage", "A new verification code has been sent to your email.");
            request.getRequestDispatcher("/customer/verify-otp.jsp").forward(request, response);
            return;
        }

        // VERIFY OTP ACTION
        String enteredOtp = request.getParameter("otp");
        if (enteredOtp != null) {
            enteredOtp = enteredOtp.trim();
        }

        if (enteredOtp == null || enteredOtp.isEmpty()) {
            request.setAttribute("errorMessage", "Please enter the 6-digit verification code.");
            request.getRequestDispatcher("/customer/verify-otp.jsp").forward(request, response);
            return;
        }

        // Check Expiry (5 minutes)
        if (regOtpExpiry == null || System.currentTimeMillis() > regOtpExpiry) {
            request.setAttribute("errorMessage", "The verification code has expired. Please click 'Resend OTP'.");
            request.setAttribute("resendAllowed", true);
            request.getRequestDispatcher("/customer/verify-otp.jsp").forward(request, response);
            return;
        }

        // Validate OTP Match
        if (!enteredOtp.equals(regOtp)) {
            request.setAttribute("errorMessage", "Invalid verification code. Please check your email and try again.");
            request.setAttribute("resendAllowed", true);
            request.getRequestDispatcher("/customer/verify-otp.jsp").forward(request, response);
            return;
        }

        // OTP Verified Successfully -> Register User in Database
        try {
            UserDAOImpl dao = new UserDAOImpl();
            boolean inserted = dao.registerUser(pendingUser);

            if (inserted) {
                // Clear session OTP registration data
                session.removeAttribute("pendingUser");
                session.removeAttribute("regOtp");
                session.removeAttribute("regOtpExpiry");
                session.removeAttribute("regOtpEmail");

                request.setAttribute("isVerified", true);
                request.getRequestDispatcher("/customer/verify-otp.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Registration failed due to a database error. Please try again.");
                request.getRequestDispatcher("/customer/verify-otp.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Server error during registration confirmation.");
            request.getRequestDispatcher("/customer/verify-otp.jsp").forward(request, response);
        }
    }
}
