package com.shelfbound.daoimpl;

import com.shelfbound.connection.DBConnection;
import com.shelfbound.dao.WishlistDAO;
import com.shelfbound.model.Book;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAOImpl implements WishlistDAO {

    // ─── ADD TO WISHLIST ────────────────────────────────────────────────────────
    @Override
    public void addToWishlist(int userId, int bookId) {

        // Only insert if not already present (avoids duplicate entry error)
        String sql = "INSERT INTO wishlist (user_id, book_id) "
                   + "SELECT ?, ? FROM DUAL "
                   + "WHERE NOT EXISTS ("
                   + "    SELECT 1 FROM wishlist WHERE user_id = ? AND book_id = ?"
                   + ")";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            ps.setInt(3, userId);
            ps.setInt(4, bookId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ─── REMOVE FROM WISHLIST ───────────────────────────────────────────────────
    @Override
    public void removeFromWishlist(int userId, int bookId) {

        String sql = "DELETE FROM wishlist WHERE user_id = ? AND book_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ─── GET WISHLIST FOR USER ──────────────────────────────────────────────────
    @Override
    public List<Book> getWishlistByUserId(int userId) {

        List<Book> books = new ArrayList<>();

        // Join wishlist with books table to get full book details
        String sql = "SELECT b.book_id, b.title, b.author, b.price, "
                   + "       b.image_url, b.description, b.stock_quantity, "
                   + "       b.rating, b.category_id "
                   + "FROM wishlist w "
                   + "JOIN books b ON w.book_id = b.book_id "
                   + "WHERE w.user_id = ? "
                   + "ORDER BY w.added_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Book book = new Book();
                book.setBookId(rs.getInt("book_id"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setPrice(rs.getDouble("price"));
                book.setImageUrl(rs.getString("image_url"));
                book.setDescription(rs.getString("description"));
                book.setStockQuantity(rs.getInt("stock_quantity"));
                book.setRating(rs.getDouble("rating"));
               // book.setCategoryId(rs.getInt("category_id"));
                books.add(book);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return books;
    }

    // ─── IS IN WISHLIST ─────────────────────────────────────────────────────────
    @Override
    public boolean isInWishlist(int userId, int bookId) {

        String sql = "SELECT 1 FROM wishlist WHERE user_id = ? AND book_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
    
    
    @Override
    public List<Integer> getWishlistBookIds(String username) {
        List<Integer> ids = new ArrayList<>();
        // Adjust query to match your table/column names
        String sql = "SELECT book_id FROM wishlist WHERE username = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt("book_id"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ids;
    }
}