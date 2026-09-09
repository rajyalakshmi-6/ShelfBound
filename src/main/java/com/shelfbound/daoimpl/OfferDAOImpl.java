package com.shelfbound.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.shelfbound.connection.DBConnection;
import com.shelfbound.dao.OfferDAO;
import com.shelfbound.model.Offer;

public class OfferDAOImpl implements OfferDAO {

    @Override
    public List<Offer> getAllOffers() {
        List<Offer> list = new ArrayList<>();
        String sql = "SELECT * FROM offers ORDER BY offer_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToOffer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Offer> getActiveOffers() {
        List<Offer> list = new ArrayList<>();
        String sql = "SELECT * FROM offers WHERE status = 'ACTIVE' ORDER BY discount_percentage DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToOffer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Offer getOfferById(int offerId) {
        String sql = "SELECT * FROM offers WHERE offer_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, offerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToOffer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Offer getOfferByCode(String couponCode) {
        if (couponCode == null) return null;
        String sql = "SELECT * FROM offers WHERE UPPER(coupon_code) = UPPER(?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, couponCode.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToOffer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean addOffer(Offer offer) {
        String sql = "INSERT INTO offers (coupon_code, discount_percentage, description, min_order_amount, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, offer.getCouponCode().trim().toUpperCase());
            ps.setDouble(2, offer.getDiscountPercentage());
            ps.setString(3, offer.getDescription() != null ? offer.getDescription().trim() : "");
            ps.setDouble(4, offer.getMinOrderAmount());
            ps.setString(5, offer.getStatus() != null ? offer.getStatus() : "ACTIVE");

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteOffer(int offerId) {
        String sql = "DELETE FROM offers WHERE offer_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, offerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateOfferStatus(int offerId, String status) {
        String sql = "UPDATE offers SET status = ? WHERE offer_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, offerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateOffer(Offer offer) {
        String sql = "UPDATE offers SET coupon_code = ?, discount_percentage = ?, description = ?, min_order_amount = ?, status = ? WHERE offer_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, offer.getCouponCode().trim().toUpperCase());
            ps.setDouble(2, offer.getDiscountPercentage());
            ps.setString(3, offer.getDescription() != null ? offer.getDescription().trim() : "");
            ps.setDouble(4, offer.getMinOrderAmount());
            ps.setString(5, offer.getStatus() != null ? offer.getStatus().toUpperCase() : "ACTIVE");
            ps.setInt(6, offer.getOfferId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean isCouponCodeExists(String couponCode) {
        if (couponCode == null) return false;
        String sql = "SELECT COUNT(*) FROM offers WHERE UPPER(coupon_code) = UPPER(?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, couponCode.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean isCouponCodeExistsForOther(String couponCode, int offerId) {
        if (couponCode == null) return false;
        String sql = "SELECT COUNT(*) FROM offers WHERE UPPER(coupon_code) = UPPER(?) AND offer_id != ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, couponCode.trim());
            ps.setInt(2, offerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Offer mapResultSetToOffer(ResultSet rs) throws SQLException {
        Offer offer = new Offer();
        offer.setOfferId(rs.getInt("offer_id"));
        offer.setCouponCode(rs.getString("coupon_code"));
        offer.setDiscountPercentage(rs.getDouble("discount_percentage"));
        offer.setDescription(rs.getString("description"));
        offer.setMinOrderAmount(rs.getDouble("min_order_amount"));
        offer.setStatus(rs.getString("status"));
        offer.setCreatedAt(rs.getTimestamp("created_at"));
        return offer;
    }
}
