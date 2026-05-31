package com.shelfbound.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.shelfbound.connection.DBConnection;
import com.shelfbound.dao.CartDAO;
import com.shelfbound.model.Cart;

public class CartDAOImpl implements CartDAO {

    @Override
    public Cart getCartItem(
            int userId,
            int bookId)
            throws Exception {

        String sql =
                "SELECT * FROM cart " +
                "WHERE user_id=? AND book_id=?";

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setInt(1, userId);
            ps.setInt(2, bookId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    Cart cart =
                            new Cart();

                    cart.setCartId(
                            rs.getInt("cart_id"));

                    cart.setUserId(
                            rs.getInt("user_id"));

                    cart.setBookId(
                            rs.getInt("book_id"));

                    cart.setQuantity(
                            rs.getInt("quantity"));

                    cart.setAddedAt(
                            rs.getTimestamp("added_at"));

                    return cart;
                }
            }
        }

        return null;
    }

    @Override
    public boolean addToCart(
            int userId,
            int bookId,
            int quantity)
            throws Exception {

        Cart existing =
                getCartItem(
                        userId,
                        bookId);

        if (existing != null) {

            return updateQuantity(
                    userId,
                    bookId,
                    existing.getQuantity()
                            + quantity);
        }

        String sql =
                "INSERT INTO cart " +
                "(user_id, book_id, quantity) " +
                "VALUES (?, ?, ?)";

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            ps.setInt(3, quantity);

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean updateQuantity(
            int userId,
            int bookId,
            int quantity)
            throws Exception {

        String sql =
                "UPDATE cart " +
                "SET quantity=? " +
                "WHERE user_id=? " +
                "AND book_id=?";

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setInt(1, quantity);
            ps.setInt(2, userId);
            ps.setInt(3, bookId);

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean removeFromCart(
            int userId,
            int bookId)
            throws Exception {

        String sql =
                "DELETE FROM cart " +
                "WHERE user_id=? " +
                "AND book_id=?";

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setInt(1, userId);
            ps.setInt(2, bookId);

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<Cart> getCartByUserId(
            int userId)
            throws Exception {

        List<Cart> list =
                new ArrayList<>();

        String sql =
                "SELECT * FROM cart " +
                "WHERE user_id=?";

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setInt(1, userId);

            try (ResultSet rs =
                         ps.executeQuery()) {

                while (rs.next()) {

                    Cart cart =
                            new Cart();

                    cart.setCartId(
                            rs.getInt("cart_id"));

                    cart.setUserId(
                            rs.getInt("user_id"));

                    cart.setBookId(
                            rs.getInt("book_id"));

                    cart.setQuantity(
                            rs.getInt("quantity"));

                    cart.setAddedAt(
                            rs.getTimestamp("added_at"));

                    list.add(cart);
                }
            }
        }

        return list;
    }
}