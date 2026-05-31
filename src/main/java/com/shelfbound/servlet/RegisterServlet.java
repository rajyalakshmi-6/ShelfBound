package com.shelfbound.servlet;

import java.io.IOException;

import com.shelfbound.daoimpl.UserDAOImpl;
import com.shelfbound.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================
    // OPEN REGISTER PAGE
    // =========================
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/customer/register.jsp")
               .forward(request, response);
    }

    // =========================
    // REGISTER PROCESS
    // =========================
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // =========================
        // GET FORM DATA
        // =========================
        String username =
            request.getParameter("username");

        String email =
            request.getParameter("email");

        String password =
            request.getParameter("password");

        String confirmPassword =
            request.getParameter("confirmPassword");

        String phone =
            request.getParameter("phone");

        String address =
            request.getParameter("address");

        String city =
            request.getParameter("city");

        String state =
            request.getParameter("state");

        String pincode =
            request.getParameter("pincode");

        // =========================
        // NULL SAFETY + TRIM
        // =========================
        username = username != null ? username.trim() : "";
        email = email != null ? email.trim() : "";
        password = password != null ? password.trim() : "";
        confirmPassword = confirmPassword != null ? confirmPassword.trim() : "";
        phone = phone != null ? phone.trim() : "";
        address = address != null ? address.trim() : "";
        city = city != null ? city.trim() : "";
        state = state != null ? state.trim() : "";
        pincode = pincode != null ? pincode.trim() : "";

        // =========================
        // BASIC VALIDATION
        // =========================
        if (username.isEmpty() ||
            email.isEmpty() ||
            password.isEmpty()) {

            request.setAttribute(
                "errorMessage",
                "Please fill all required fields."
            );

            request.getRequestDispatcher(
                "/customer/register.jsp"
            ).forward(request, response);

            return;
        }

        // =========================
        // PASSWORD MATCH CHECK
        // =========================
        if (!password.equals(confirmPassword)) {

            request.setAttribute(
                "errorMessage",
                "Password and Confirm Password must match."
            );

            request.getRequestDispatcher(
                "/customer/register.jsp"
            ).forward(request, response);

            return;
        }

        try {

            UserDAOImpl dao = new UserDAOImpl();

            // =========================
            // CHECK USERNAME EXISTS
            // =========================
            boolean usernameExists =
                dao.isUsernameExists(username);

            if (usernameExists) {

                request.setAttribute(
                    "errorMessage",
                    "Username already exists."
                );

                request.getRequestDispatcher(
                    "/customer/register.jsp"
                ).forward(request, response);

                return;
            }
            
           
         // =========================
         // CHECK EMAIL EXISTS
         // =========================
         boolean emailExists =
             dao.isEmailExists(email);

         if (emailExists) {

             request.setAttribute(
                 "errorMessage",
                 "Email already registered."
             );

             request.getRequestDispatcher(
                 "/customer/register.jsp"
             ).forward(request, response);

             return;
         }
         


            // =========================
            // CREATE USER OBJECT
            // =========================
            User user = new User();

            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(password);
            user.setPhone(phone);
            user.setAddress(address);
            user.setCity(city);
            user.setState(state);
            user.setPincode(pincode);

            // =========================
            // REGISTER USER
            // =========================
            boolean inserted =
                dao.registerUser(user);

            if (inserted) {

                response.sendRedirect(
                    request.getContextPath() +
                    "/login?success=registered"
                );

            } else {

                request.setAttribute(
                    "errorMessage",
                    "Registration failed. Please try again."
                );

                request.getRequestDispatcher(
                    "/customer/register.jsp"
                ).forward(request, response);
            }

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                "errorMessage",
                "Server error during registration."
            );

            request.getRequestDispatcher(
                "/customer/register.jsp"
            ).forward(request, response);
        }
    }
}