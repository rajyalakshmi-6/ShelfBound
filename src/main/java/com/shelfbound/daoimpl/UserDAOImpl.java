package com.shelfbound.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.shelfbound.connection.DBConnection;
import com.shelfbound.dao.UserDAO;
import com.shelfbound.model.User;
import com.shelfbound.util.PasswordUtil;

public class UserDAOImpl implements UserDAO {

    // =========================
    // REGISTER USER
    // =========================
    @Override
    public boolean registerUser(User user) {

        String sql =
            "INSERT INTO users " +
            "(username, email, password, phone, address, city, state, pincode, status) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());

            // Hash password with BCrypt
            String plainPwd = user.getPassword();
            String hashedPwd = (plainPwd != null && !PasswordUtil.isBcryptHash(plainPwd))
                    ? PasswordUtil.hashPassword(plainPwd)
                    : plainPwd;
            ps.setString(3, hashedPwd);

            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getCity());
            ps.setString(7, user.getState());
            ps.setString(8, user.getPincode());
            ps.setString(9, user.getStatus() != null ? user.getStatus() : "ACTIVE");

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // =========================
    // LOGIN USER
    // =========================
    @Override
    public User loginUser(String email, String password) {

        String sql =
            "SELECT * FROM users " +
            "WHERE email = ?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");

                // Verify with BCrypt (supports legacy plain text with auto-upgrade)
                if (!PasswordUtil.checkPassword(password, storedPassword)) {
                    return null;
                }

                // Auto-upgrade legacy plain text password to BCrypt
                if (!PasswordUtil.isBcryptHash(storedPassword)) {
                    try {
                        updatePassword(email, password);
                    } catch (Exception ex) {
                        // ignore
                    }
                }

                User user = new User();

                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(storedPassword);
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setCity(rs.getString("city"));
                user.setState(rs.getString("state"));
                user.setPincode(rs.getString("pincode"));
                user.setStatus(rs.getString("status") != null ? rs.getString("status") : "ACTIVE");

                return user;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // =========================
    // CHECK USERNAME EXISTS
    // =========================
    public boolean isUsernameExists(String username) {

        String sql =
            "SELECT user_id FROM users WHERE username=?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // CHECK EMAIL EXISTS
    public boolean isEmailExists(String email) {

        String sql = "SELECT user_id FROM users WHERE email=?";

        try ( Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) 
        {

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        

        return false;
    }
    
    @Override
    public boolean updateUser(User user) {

        String sql =
            "UPDATE users SET " +
            "username=?, phone=?, address=?, city=?, state=?, pincode=? " +
            "WHERE user_id=?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
        ) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getAddress());
            ps.setString(4, user.getCity());
            ps.setString(5, user.getState());
            ps.setString(6, user.getPincode());
            ps.setInt(7, user.getUserId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean updatePassword(String email, String newPassword) {
        String sql = "UPDATE users SET password=? WHERE email=?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
        ) {
            String hashedPassword = (newPassword != null && !PasswordUtil.isBcryptHash(newPassword))
                    ? PasswordUtil.hashPassword(newPassword)
                    : newPassword;
            ps.setString(1, hashedPassword);
            ps.setString(2, email);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY user_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setAddress(rs.getString("address"));
                u.setCity(rs.getString("city"));
                u.setState(rs.getString("state"));
                u.setPincode(rs.getString("pincode"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setStatus(rs.getString("status") != null ? rs.getString("status") : "ACTIVE");
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateUserStatus(int userId, String status) {
        String sql = "UPDATE users SET status=? WHERE user_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setPhone(rs.getString("phone"));
                    u.setAddress(rs.getString("address"));
                    u.setCity(rs.getString("city"));
                    u.setState(rs.getString("state"));
                    u.setPincode(rs.getString("pincode"));
                    u.setCreatedAt(rs.getTimestamp("created_at"));
                    u.setStatus(rs.getString("status") != null ? rs.getString("status") : "ACTIVE");
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}