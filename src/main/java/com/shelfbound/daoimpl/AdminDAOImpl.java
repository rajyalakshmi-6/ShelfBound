package com.shelfbound.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.shelfbound.connection.DBConnection;
import com.shelfbound.dao.AdminDAO;
import com.shelfbound.model.Admin;

public class AdminDAOImpl implements AdminDAO {


	// =========================
	// ADMIN LOGIN
	// =========================
	@Override
	public Admin loginAdmin(String username,
			String password) {

		String sql =
				"SELECT * FROM admin " +
						"WHERE username=? AND password=?";

		try (
				Connection conn = DBConnection.getConnection();
				PreparedStatement ps =
						conn.prepareStatement(sql)
				) {

			ps.setString(1, username);
			ps.setString(2, password);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {

				Admin admin = new Admin();

				admin.setAdminId(
						rs.getInt("admin_id")
						);

				admin.setUsername(
						rs.getString("username")
						);

				admin.setPassword(
						rs.getString("password")
						);

				return admin;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}
	
	@Override
	public int getTotalUsers() {

	    String sql =
	        "SELECT COUNT(*) FROM users";

	    try (
	        Connection conn =
	            DBConnection.getConnection();

	        PreparedStatement ps =
	            conn.prepareStatement(sql);

	        ResultSet rs =
	            ps.executeQuery()
	    ) {

	        if(rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch(Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}

	@Override
	public int getTotalBooks() {

	    String sql =
	        "SELECT COUNT(*) FROM books";

	    try (
	        Connection conn =
	            DBConnection.getConnection();

	        PreparedStatement ps =
	            conn.prepareStatement(sql);

	        ResultSet rs =
	            ps.executeQuery()
	    ) {

	        if(rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch(Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	
	
	@Override
	public int getTotalOrders() {

	    String sql =
	        "SELECT COUNT(*) FROM orders";

	    try (
	        Connection conn =
	            DBConnection.getConnection();

	        PreparedStatement ps =
	            conn.prepareStatement(sql);

	        ResultSet rs =
	            ps.executeQuery()
	    ) {

	        if(rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch(Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	@Override
	public int getPendingOrders() {

	    String sql =
	        "SELECT COUNT(*) " +
	        "FROM orders " +
	        "WHERE order_status='Pending'";

	    try (
	        Connection conn =
	            DBConnection.getConnection();

	        PreparedStatement ps =
	            conn.prepareStatement(sql);

	        ResultSet rs =
	            ps.executeQuery()
	    ) {

	        if(rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch(Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}


}
