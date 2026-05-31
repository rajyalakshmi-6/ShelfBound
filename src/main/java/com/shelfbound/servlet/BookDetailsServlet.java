package com.shelfbound.servlet;

import java.io.IOException;

import com.shelfbound.dao.BookDAO;
import com.shelfbound.daoimpl.BookDAOImpl;
import com.shelfbound.model.Book;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class BookDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // 1. READ BOOK ID FROM URL
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            int bookId = Integer.parseInt(idParam);

            // 2. CALL DAO
            BookDAO dao = new BookDAOImpl();
            Book book = dao.getBookById(bookId);

            // 3. IF BOOK NOT FOUND
            if (book == null) {
                request.setAttribute("error", "Book not found");
                request.getRequestDispatcher("/customer/home.jsp")
                       .forward(request, response);
                return;
            }

            // 4. SEND DATA TO JSP
            request.setAttribute("book", book);

            // 5. FORWARD TO DETAILS PAGE
            request.getRequestDispatcher("/customer/book-details.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute("error", "Something went wrong");
            request.getRequestDispatcher("/customer/home.jsp")
                   .forward(request, response);
        }
    }
}