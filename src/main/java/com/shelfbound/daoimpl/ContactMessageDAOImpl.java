package com.shelfbound.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.shelfbound.connection.DBConnection;
import com.shelfbound.dao.ContactMessageDAO;
import com.shelfbound.model.ContactMessage;

public class ContactMessageDAOImpl implements ContactMessageDAO {

    // =========================
    // SAVE MESSAGE (USER SIDE)
    // =========================
    @Override
    public boolean saveMessage(ContactMessage contact) {

        String sql =
            "INSERT INTO contact_messages " +
            "(name,email,message) VALUES(?,?,?)";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, contact.getName());
            ps.setString(2, contact.getEmail());
            ps.setString(3, contact.getMessage());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // =========================
    // GET ALL MESSAGES (ADMIN)
    // =========================
    @Override
    public List<ContactMessage> getAllMessages() {

        List<ContactMessage> list = new ArrayList<>();

        String sql =
            "SELECT * FROM contact_messages ORDER BY submitted_at DESC";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                ContactMessage m = new ContactMessage();

                m.setMessageId(rs.getInt("message_id"));
                m.setName(rs.getString("name"));
                m.setEmail(rs.getString("email"));
                m.setMessage(rs.getString("message"));
                m.setStatus(rs.getString("status"));
                m.setAdminReply(rs.getString("admin_reply"));
                m.setSubmittedAt(rs.getTimestamp("submitted_at"));
                m.setRepliedAt(rs.getTimestamp("replied_at"));

                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =========================
    // MARK AS READ
    // =========================
    @Override
    public boolean markAsRead(int messageId) {

        String sql =
            "UPDATE contact_messages SET status='Read' WHERE message_id=?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, messageId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // =========================
    // REPLY TO MESSAGE
    // =========================
    @Override
    public boolean replyToMessage(int messageId, String reply) {

        String sql =
            "UPDATE contact_messages " +
            "SET admin_reply=?, status='Replied', replied_at=CURRENT_TIMESTAMP " +
            "WHERE message_id=?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, reply);
            ps.setInt(2, messageId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // =========================
    // DELETE MESSAGE
    // =========================
    @Override
    public boolean deleteMessage(int messageId) {

        String sql =
            "DELETE FROM contact_messages WHERE message_id=?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, messageId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}