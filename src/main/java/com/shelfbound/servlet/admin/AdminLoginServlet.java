package com.shelfbound.servlet.admin;

import java.io.IOException;

import com.shelfbound.dao.AdminDAO;
import com.shelfbound.daoimpl.AdminDAOImpl;
import com.shelfbound.model.Admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminLoginServlet extends HttpServlet {


	private static final long serialVersionUID = 1L;

	// =========================
	// OPEN LOGIN PAGE
	// =========================
	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response)
					throws ServletException, IOException {

		request.getRequestDispatcher(
				"/admin/admin-login.jsp"
				).forward(request, response);
	}

	// =========================
	// ADMIN LOGIN PROCESS
	// =========================
	@Override
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response)
					throws ServletException, IOException {

		String username =
				request.getParameter("username");

		String password =
				request.getParameter("password");

		// =========================
		// BASIC VALIDATION
		// =========================
		if (username == null || password == null ||
				username.trim().isEmpty() ||
				password.trim().isEmpty()) {

			request.setAttribute(
					"errorMessage",
					"Please enter username and password."
					);

			request.getRequestDispatcher(
					"/admin/admin-login.jsp"
					).forward(request, response);

			return;
		}

		username = username.trim();
		password = password.trim();

		// =========================
		// DAO LOGIN
		// =========================
		AdminDAO dao =
				new AdminDAOImpl();

		Admin admin =
				dao.loginAdmin(username, password);

		// =========================
		// LOGIN SUCCESS
		// =========================
		if (admin != null) {

			HttpSession session =
					request.getSession();

			session.setAttribute(
					"adminId",
					admin.getAdminId()
					);

			session.setAttribute(
					"adminUsername",
					admin.getUsername()
					);

			response.sendRedirect(
					request.getContextPath() +
					"/adminDashboard"
					);

		} else {

			request.setAttribute(
					"errorMessage",
					"Invalid admin credentials."
					);

			request.getRequestDispatcher(
					"/admin/admin-login.jsp"
					).forward(request, response);
		}
	}


}
