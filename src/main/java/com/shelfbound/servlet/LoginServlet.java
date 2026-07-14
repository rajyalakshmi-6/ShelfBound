
package com.shelfbound.servlet;
import com.shelfbound.model.User;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.shelfbound.connection.DBConnection;
import com.shelfbound.dao.BookDAO;
import com.shelfbound.dao.CartDAO;
import com.shelfbound.daoimpl.BookDAOImpl;
import com.shelfbound.daoimpl.CartDAOImpl;
import com.shelfbound.model.Book;
import com.shelfbound.model.Cart;
import com.shelfbound.model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================
    // OPEN LOGIN PAGE
    // =========================
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/customer/login.jsp")
               .forward(request, response);
    }

    // =========================
    // LOGIN PROCESS
    // =========================
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email =
            request.getParameter("email");

        String password =
            request.getParameter("password");

        // =========================
        // BASIC VALIDATION
        // =========================
        if (email == null || password == null ||
            email.trim().isEmpty() ||
            password.trim().isEmpty()) {

            request.setAttribute(
                "errorMessage",
                "Please enter email and password."
            );

            request.getRequestDispatcher(
                "/customer/login.jsp"
            ).forward(request, response);

            return;
        }

        email = email.trim();
        password = password.trim();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            // =========================
            // CHECK LOGIN
            // =========================
            String sql =
                "SELECT *\r\n"
                + "FROM users\r\n"
                + "WHERE email=? AND password=?";

            ps = con.prepareStatement(sql);

            ps.setString(1, email);
            ps.setString(2, password);

            rs = ps.executeQuery();

            // =========================
            // LOGIN SUCCESS
            // =========================
            if (rs.next()) {
            	
            	User user = new User();
            	

            	user.setUserId(rs.getInt("user_id"));
            	user.setUsername(rs.getString("username"));
            	user.setEmail(rs.getString("email"));
            	user.setPhone(rs.getString("phone"));
            	user.setAddress(rs.getString("address"));
            	user.setCity(rs.getString("city"));
            	user.setState(rs.getString("state"));
            	user.setPincode(rs.getString("pincode"));
            	
            	int userId = user.getUserId();

            	String dbUsername = user.getUsername();

                // CREATE SESSION
                HttpSession session = request.getSession();

                session.setAttribute("userId",userId);

                session.setAttribute(
                    "username",
                    dbUsername
                );
             // NEW
                session.setAttribute("loggedUser", user);

                
             // =========================
             // LOAD CART FROM DATABASE
             // =========================

             CartDAO cartDAO =
                     new CartDAOImpl();

             BookDAO bookDAO =
                     new BookDAOImpl();

             List<Cart> dbCart =
                     cartDAO.getCartByUserId(userId);

             List<CartItem> sessionCart =
                     new ArrayList<>();

             for (Cart cartRow : dbCart) {

                 Book book =
                         bookDAO.getBookById(
                                 cartRow.getBookId());

                 if (book != null) {

                     CartItem item =
                             new CartItem();

                     item.setBook(book);

                     item.setQuantity(
                             cartRow.getQuantity());

                     sessionCart.add(item);
                 }
             }

             // Save cart into session
             session.setAttribute(
                     "cart",
                     sessionCart);

                // REDIRECT HOME
                response.sendRedirect(
                    request.getContextPath() + "/home"
                );

            } else {

                // =========================
                // INVALID LOGIN
                // =========================
                request.setAttribute(
                    "errorMessage",
                    "Invalid email or password."
                );

                request.getRequestDispatcher(
                    "/customer/login.jsp"
                ).forward(request, response);
            }

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                "errorMessage",
                "Server error. Please try again later."
            );

            request.getRequestDispatcher(
                "/customer/login.jsp"
            ).forward(request, response);

        } finally {

            try {
                if (rs != null)
                    rs.close();
            } catch (Exception e) {
            }

            try {
                if (ps != null)
                    ps.close();
            } catch (Exception e) {
            }

            try {
                if (con != null)
                    con.close();
            } catch (Exception e) {
            }
        }
    }
}

