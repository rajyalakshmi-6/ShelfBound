package com.shelfbound.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import com.shelfbound.util.EmailService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SubscribeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String email = request.getParameter("email");
        if (email != null) {
            email = email.trim();
        }

        PrintWriter out = response.getWriter();

        if (email == null || email.isEmpty() || !email.contains("@")) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"status\":\"error\",\"message\":\"Please provide a valid email address.\"}");
            return;
        }

        try {
            EmailService.sendNewsletterWelcome(email);
            out.write("{\"status\":\"success\",\"message\":\"Thank you for subscribing! Check your inbox for your welcome gift.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"status\":\"error\",\"message\":\"Could not process subscription.\"}");
        }
    }
}
