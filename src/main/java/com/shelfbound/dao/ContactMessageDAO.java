package com.shelfbound.dao;

import java.util.List;
import com.shelfbound.model.ContactMessage;

public interface ContactMessageDAO {

    // USER SIDE
    boolean saveMessage(ContactMessage message);

    // ADMIN SIDE (NEW)
    List<ContactMessage> getAllMessages();

    boolean markAsRead(int messageId);

    boolean replyToMessage(int messageId, String reply);

    boolean deleteMessage(int messageId);
}