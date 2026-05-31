package com.shelfbound.servlet.admin;

import java.io.IOException;
import java.util.List;

import com.shelfbound.dao.BookDAO;
import com.shelfbound.daoimpl.BookDAOImpl;
import com.shelfbound.model.Book;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminBookServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================
    // GET REQUEST
    // =========================
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/adminLogin");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) action = "view";

        try {

            BookDAO dao = new BookDAOImpl();

            // VIEW BOOKS
            if ("view".equals(action)) {

                List<Book> books = dao.getAllBooks();
                request.setAttribute("books", books);

                request.getRequestDispatcher("/admin/manage-books.jsp")
                        .forward(request, response);
            }

            // OPEN ADD FORM
            else if ("showAddForm".equals(action)) {

                request.getRequestDispatcher("/admin/add-book.jsp")
                        .forward(request, response);
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // =========================
    // POST REQUEST
    // =========================
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/adminLogin");
            return;
        }

        String action = request.getParameter("action");

        try {

            BookDAO dao = new BookDAOImpl();

            // =====================
            // ADD BOOK
            // =====================
            if ("add".equals(action)) {

                Book book = new Book();

                book.setTitle(request.getParameter("title"));
                book.setAuthor(request.getParameter("author"));
                book.setDescription(request.getParameter("description"));
                book.setPrice(Double.parseDouble(request.getParameter("price")));
                book.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
                book.setImageUrl(request.getParameter("imageUrl"));

                boolean result = dao.addBook(book);

                if (result) {
                    response.sendRedirect(
                        request.getContextPath()
                        + "/adminBook?action=view&success=added"
                    );
                } else {
                    response.sendRedirect(
                        request.getContextPath()
                        + "/adminBook?action=view&success=error"
                    );
                }
            }

            // =====================
            // DELETE BOOK
            // =====================
            else if ("delete".equals(action)) {

                int bookId = Integer.parseInt(request.getParameter("bookId"));

                dao.deleteBook(bookId);

                response.sendRedirect(
                    request.getContextPath()
                    + "/adminBook?action=view&success=deleted"
                );
            }

            // =====================
            // UPDATE STOCK
            // =====================
            else if ("stock".equals(action)) {

                int bookId = Integer.parseInt(request.getParameter("bookId"));
                int stock = Integer.parseInt(request.getParameter("stockQuantity"));

                dao.updateStock(bookId, stock);

                response.sendRedirect(
                    request.getContextPath()
                    + "/adminBook?action=view&success=updated"
                );
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}