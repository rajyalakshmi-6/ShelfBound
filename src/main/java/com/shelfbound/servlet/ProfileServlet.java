package com.shelfbound.servlet;

import java.io.IOException;

import com.shelfbound.dao.CartDAO;
import com.shelfbound.dao.OrderDAO;
import com.shelfbound.dao.UserDAO;
import com.shelfbound.dao.WishlistDAO;
import com.shelfbound.daoimpl.CartDAOImpl;
import com.shelfbound.daoimpl.OrderDAOImpl;
import com.shelfbound.daoimpl.UserDAOImpl;
import com.shelfbound.daoimpl.WishlistDAOImpl;
import com.shelfbound.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // User not logged in
        if (session == null ||
            session.getAttribute("loggedUser") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login");

            return;
        }

    
        
        User user =
                (User) session.getAttribute("loggedUser");
        int userId = user.getUserId();

        OrderDAO orderDAO = new OrderDAOImpl();
        WishlistDAO wishlistDAO = new WishlistDAOImpl();
        CartDAO cartDAO = new CartDAOImpl();

        int orderCount = orderDAO.getOrderCount(userId);

        int wishlistCount = wishlistDAO.getWishlistCount(userId);

        int cartCount = cartDAO.getCartCount(userId);
        
        request.setAttribute("orderCount", orderCount);
        request.setAttribute("wishlistCount", wishlistCount);
        request.setAttribute("cartCount", cartCount);

        request.setAttribute("user", user);

        request.getRequestDispatcher(
                "/customer/profile.jsp")
                .forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("loggedUser") == null) {

            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");

        // Read updated values
        user.setUsername(request.getParameter("username"));
        user.setPhone(request.getParameter("phone"));
        user.setAddress(request.getParameter("address"));
        user.setCity(request.getParameter("city"));
        user.setState(request.getParameter("state"));
        user.setPincode(request.getParameter("pincode"));

        UserDAO userDAO = new UserDAOImpl();

        boolean updated = userDAO.updateUser(user);

        if (updated) {

            // Update session
            session.setAttribute("loggedUser", user);
            session.setAttribute("username", user.getUsername());

            response.sendRedirect(
                    request.getContextPath() +
                    "/profile?success=1"); // gives success is true (1) for the profile .jsp to display message 

        } else {

            response.sendRedirect(
                    request.getContextPath() +
                    "/profile?error=1");
        }
    }
}