package com.shelfbound.servlet;

import java.io.IOException;

import com.shelfbound.dao.ContactMessageDAO;
import com.shelfbound.daoimpl.ContactMessageDAOImpl;
import com.shelfbound.model.ContactMessage;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ContactMessageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException,
            IOException {

        request.getRequestDispatcher(
                "/customer/contact.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException,
            IOException {

        String name =
            request.getParameter("name");

        String email =
            request.getParameter("email");

        String message =
            request.getParameter("message");

        ContactMessage contact =
                new ContactMessage();

        contact.setName(name);
        contact.setEmail(email);
        contact.setMessage(message);

        ContactMessageDAO dao =
                new ContactMessageDAOImpl();

        boolean success =
                dao.saveMessage(contact);

        if(success) {

            request.setAttribute(
                "successMessage",
                "Message sent successfully!");

        } else {

            request.setAttribute(
                "errorMessage",
                "Failed to send message.");
        }

        request.getRequestDispatcher(
                "/customer/contact.jsp")
                .forward(request, response);
    }
}