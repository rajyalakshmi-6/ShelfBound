package com.shelfbound.servlet;

import java.io.IOException;
import java.util.Set;
import java.util.HashSet;
import java.util.List;

import com.shelfbound.dao.BookDAO;
import com.shelfbound.dao.WishlistDAO;
import com.shelfbound.daoimpl.BookDAOImpl;
import com.shelfbound.daoimpl.WishlistDAOImpl;
import com.shelfbound.model.Book;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class HomeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // DAO OBJECT
            BookDAO dao = new BookDAOImpl();

            // FETCH DATA FROM DB
            List<Book> allBooks = dao.getAllBooks();

            List<Book> newArrivals = dao.getNewArrivals();
            List<Book> popularBooks = dao.getPopularBooks();
            
         // Get wishlist book IDs for the logged-in user
            Set<Integer> wishlistIds = new HashSet<>();
            String username = (String) request.getSession().getAttribute("username");
            if (username != null) {
                // Assuming you have a WishlistDAO - add this method if not present
                WishlistDAO wishlistDAO = new WishlistDAOImpl();
                List<Integer> ids = wishlistDAO.getWishlistBookIds(username);
                wishlistIds.addAll(ids);
            }
            request.setAttribute("wishlistIds", wishlistIds);

            // SEND TO JSP
            request.setAttribute("allBooks", allBooks);
            request.setAttribute("newArrivals", newArrivals);
            request.setAttribute("popularBooks", popularBooks);

            // FORWARD TO HOME PAGE
            request.getRequestDispatcher("/customer/home.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            // fallback error page or empty data
            request.setAttribute("error", "Unable to load books");
            request.getRequestDispatcher("/customer/home.jsp")
                   .forward(request, response);
        }
    }
}