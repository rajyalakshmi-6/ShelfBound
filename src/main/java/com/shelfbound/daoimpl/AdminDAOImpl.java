package com.shelfbound.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.shelfbound.connection.DBConnection;
import com.shelfbound.dao.AdminDAO;
import com.shelfbound.model.Admin;
import com.shelfbound.util.PasswordUtil;

public class AdminDAOImpl implements AdminDAO {


	// =========================
	// ADMIN LOGIN
	// =========================
	@Override
	public Admin loginAdmin(String username,
			String password) {

		String sql = "SELECT * FROM admin WHERE username=?";

		try (
				Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)
				) {

			ps.setString(1, username);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				String storedPassword = rs.getString("password");

				if (PasswordUtil.checkPassword(password, storedPassword)) {
					// Auto-upgrade legacy plain text admin password to BCrypt
					if (!PasswordUtil.isBcryptHash(storedPassword)) {
						try (PreparedStatement updatePs = conn.prepareStatement("UPDATE admin SET password=? WHERE admin_id=?")) {
							updatePs.setString(1, PasswordUtil.hashPassword(password));
							updatePs.setInt(2, rs.getInt("admin_id"));
							updatePs.executeUpdate();
							System.out.println("✔ [AdminDAOImpl] Auto-upgraded admin password to BCrypt hash in MySQL.");
						} catch (Exception ex) {
							System.err.println("Could not auto-upgrade admin password: " + ex.getMessage());
						}
					}

					Admin admin = new Admin();

					admin.setAdminId(rs.getInt("admin_id"));
					admin.setUsername(rs.getString("username"));
					admin.setPassword(storedPassword);

					return admin;
				}
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
