package com.shelfbound.model;

import java.sql.Timestamp;

public class ContactMessage {

    private int messageId;
    private String name;
    private String email;
    private String message;
    private String status;    // Pending / Read / Replied
    private String adminReply;

    private Timestamp submittedAt;
    private Timestamp repliedAt;

    public ContactMessage() {
    }

    public int getMessageId() {
        return messageId;
    }

    public void setMessageId(int messageId) {
        this.messageId = messageId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAdminReply() {
        return adminReply;
    }

    public void setAdminReply(String adminReply) {
        this.adminReply = adminReply;
    }

    public Timestamp getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Timestamp submittedAt) {
        this.submittedAt = submittedAt;
    }

    public Timestamp getRepliedAt() {
        return repliedAt;
    }

    public void setRepliedAt(Timestamp repliedAt) {
        this.repliedAt = repliedAt;
    }
}