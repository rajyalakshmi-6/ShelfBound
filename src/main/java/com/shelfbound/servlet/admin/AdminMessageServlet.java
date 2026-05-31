package com.shelfbound.servlet.admin;

import java.io.IOException;
import java.util.List;

import com.shelfbound.dao.ContactMessageDAO;
import com.shelfbound.daoimpl.ContactMessageDAOImpl;
import com.shelfbound.model.ContactMessage;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminMessageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/adminLogin");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "view";

        ContactMessageDAO dao = new ContactMessageDAOImpl();

        try {

            if ("view".equals(action)) {

                List<ContactMessage> messages = dao.getAllMessages();

                request.setAttribute("messages", messages);

                request.getRequestDispatcher("/admin/manage-messages.jsp")
                        .forward(request, response);
            }

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

        ContactMessageDAO dao = new ContactMessageDAOImpl();

        try {

            // =========================
            // MARK AS READ
            // =========================
            if ("read".equals(action)) {

                int id = Integer.parseInt(request.getParameter("messageId"));
                dao.markAsRead(id);
            }

            // =========================
            // REPLY MESSAGE
            // =========================
            else if ("reply".equals(action)) {

                int id = Integer.parseInt(request.getParameter("messageId"));
                String reply = request.getParameter("reply");

                dao.replyToMessage(id, reply);
            }

            // =========================
            // DELETE MESSAGE
            // =========================
            else if ("delete".equals(action)) {

                int id = Integer.parseInt(request.getParameter("messageId"));
                dao.deleteMessage(id);
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }

        response.sendRedirect(request.getContextPath() + "/adminMessage?action=view&success=1");
    }
}