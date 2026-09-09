package com.shelfbound.util;

import java.io.InputStream;
import java.security.SecureRandom;
import java.util.List;
import java.util.Properties;
import java.util.concurrent.CompletableFuture;

import com.shelfbound.model.CartItem;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;

public class EmailService {

    private static final SecureRandom RANDOM = new SecureRandom();

    private static String brevoApiKey = "";
    private static String senderEmail = "devaralarajyalakshmi265@gmail.com";
    private static String senderName  = "ShelfBound BookStore";

    private static String host = "smtp.gmail.com";
    private static String port = "587";
    private static String user = "";
    private static String pass = "";

    static {
        loadConfig();
    }

    /**
     * Loads SMTP & Brevo configuration from email.properties in classpath,
     * with fallback to System Properties and Environment Variables.
     */
    public static void loadConfig() {
        try (InputStream in = EmailService.class.getClassLoader().getResourceAsStream("email.properties")) {
            if (in != null) {
                Properties fileProps = new Properties();
                fileProps.load(in);

                String propBrevo = fileProps.getProperty("brevo.api.key");
                String propSenderEmail = fileProps.getProperty("brevo.sender.email");
                String propSenderName  = fileProps.getProperty("brevo.sender.name");

                if (propBrevo != null && !propBrevo.trim().isEmpty()) brevoApiKey = propBrevo.trim();
                if (propSenderEmail != null && !propSenderEmail.trim().isEmpty()) senderEmail = propSenderEmail.trim();
                if (propSenderName != null && !propSenderName.trim().isEmpty()) senderName = propSenderName.trim();

                String propHost = fileProps.getProperty("mail.smtp.host");
                String propPort = fileProps.getProperty("mail.smtp.port");
                String propUser = fileProps.getProperty("mail.smtp.user");
                String propPass = fileProps.getProperty("mail.smtp.password");

                if (propHost != null && !propHost.trim().isEmpty()) host = propHost.trim();
                if (propPort != null && !propPort.trim().isEmpty()) port = propPort.trim();
                if (propUser != null && !propUser.trim().isEmpty()) user = propUser.trim();
                if (propPass != null && !propPass.trim().isEmpty()) pass = propPass.trim();
            }
        } catch (Exception e) {
            System.err.println("[EmailService] Could not read email.properties from classpath: " + e.getMessage());
        }

        // Brevo Environment Variables (support common naming variations)
        String envBrevo = System.getenv("BREVO_API_KEY");
        if (envBrevo == null || envBrevo.trim().isEmpty()) envBrevo = System.getenv("BREVO_KEY");
        if (envBrevo == null || envBrevo.trim().isEmpty()) envBrevo = System.getenv("BREVO_APIKEY");
        if (envBrevo == null || envBrevo.trim().isEmpty()) envBrevo = System.getenv("brevo_api_key");

        if (envBrevo != null && !envBrevo.trim().isEmpty()) {
            brevoApiKey = envBrevo.trim();
        }

        if (System.getenv("BREVO_SENDER_EMAIL") != null && !System.getenv("BREVO_SENDER_EMAIL").trim().isEmpty()) {
            senderEmail = System.getenv("BREVO_SENDER_EMAIL").trim();
        }

        // SMTP Environment Variables override file configuration
        if (System.getenv("SMTP_USER") != null && !System.getenv("SMTP_USER").trim().isEmpty()) {
            user = System.getenv("SMTP_USER").trim();
        } else if (user.isEmpty() && System.getProperty("mail.smtp.user") != null) {
            user = System.getProperty("mail.smtp.user").trim();
        }

        if (System.getenv("SMTP_PASSWORD") != null && !System.getenv("SMTP_PASSWORD").trim().isEmpty()) {
            pass = System.getenv("SMTP_PASSWORD").trim();
        } else if (System.getenv("SMTP_PASS") != null && !System.getenv("SMTP_PASS").trim().isEmpty()) {
            pass = System.getenv("SMTP_PASS").trim();
        } else if (pass.isEmpty() && System.getProperty("mail.smtp.password") != null) {
            pass = System.getProperty("mail.smtp.password").trim();
        }

        if (System.getenv("SMTP_HOST") != null) {
            host = System.getenv("SMTP_HOST").trim();
        }
        if (System.getenv("SMTP_PORT") != null) {
            port = System.getenv("SMTP_PORT").trim();
        }
    }

    /**
     * Checks if actual Brevo API or SMTP credentials have been configured.
     */
    public static boolean isConfigured() {
        boolean brevoOk = brevoApiKey != null && !brevoApiKey.trim().isEmpty() && !brevoApiKey.contains("YOUR_KEY");
        boolean smtpOk  = user != null && !user.trim().isEmpty() && !user.contains("YOUR_EMAIL")
                && pass != null && !pass.trim().isEmpty() && !pass.contains("YOUR_16_CHAR");
        return brevoOk || smtpOk;
    }

    /**
     * Generates a secure 6-digit numeric OTP.
     */
    public static String generateOtp() {
        int otp = 100000 + RANDOM.nextInt(900000);
        return String.valueOf(otp);
    }

    /**
     * Escapes a string for inclusion into a JSON literal, enclosing it in double quotes.
     */
    private static String toJsonString(String s) {
        if (s == null) return "null";
        StringBuilder sb = new StringBuilder("\"");
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '"':  sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\b': sb.append("\\b"); break;
                case '\f': sb.append("\\f"); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                default:
                    if (c < ' ') {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else {
                        sb.append(c);
                    }
            }
        }
        sb.append("\"");
        return sb.toString();
    }

    /**
     * Sends email via Brevo REST API over HTTPS (Port 443).
     * Render and cloud hosts never block port 443.
     */
    private static boolean sendViaBrevoApi(String toEmail, String subject, String htmlBody) {
        try {
            String payload = "{"
                + "\"sender\":{\"name\":" + toJsonString(senderName) + ",\"email\":" + toJsonString(senderEmail) + "},"
                + "\"to\":[{\"email\":" + toJsonString(toEmail) + "}],"
                + "\"subject\":" + toJsonString(subject) + ","
                + "\"htmlContent\":" + toJsonString(htmlBody)
                + "}";

            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://api.brevo.com/v3/smtp/email"))
                    .header("accept", "application/json")
                    .header("api-key", brevoApiKey)
                    .header("content-type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(payload, StandardCharsets.UTF_8))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() >= 200 && response.statusCode() < 300) {
                System.out.println("✔ [EmailService] Email successfully delivered via Brevo HTTPS API to: " + toEmail + " | Subject: " + subject);
                return true;
            } else {
                System.err.println("❌ [EmailService] Brevo API error (HTTP " + response.statusCode() + "): " + response.body());
                return false;
            }
        } catch (Exception e) {
            System.err.println("❌ [EmailService] Brevo HTTP request failed for " + toEmail + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Sends email via standard Jakarta Mail SMTP.
     */
    private static boolean sendViaSmtp(String toEmail, String subject, String htmlBody) {
        if (user == null || user.trim().isEmpty() || pass == null || pass.trim().isEmpty()) {
            System.err.println("❌ [EmailService] SMTP credentials not available for fallback.");
            return false;
        }
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", port);
            props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
            props.put("mail.smtp.connectiontimeout", "10000");
            props.put("mail.smtp.timeout", "10000");
            props.put("mail.smtp.writetimeout", "10000");

            Session mailSession = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(user, pass);
                }
            });

            MimeMessage message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(user, "ShelfBound BookStore"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject(subject, "UTF-8");
            message.setContent(htmlBody, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("✔ [EmailService] Email successfully delivered via SMTP to: " + toEmail + " | Subject: " + subject);
            return true;
        } catch (Exception e) {
            System.err.println("❌ [EmailService] SMTP delivery failed to " + toEmail + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Low-level HTML email dispatcher with optional async execution.
     * Uses Brevo API if configured, otherwise falls back to SMTP.
     */
    public static boolean sendHtmlEmail(String toEmail, String subject, String htmlBody, boolean async) {
        if (brevoApiKey == null || brevoApiKey.trim().isEmpty()) {
            loadConfig();
        }

        if (!isConfigured()) {
            System.out.println("ℹ [EmailService] Neither Brevo API nor SMTP configured. Skipped sending email to " + toEmail + " (" + subject + ")");
            return true;
        }

        System.out.println("ℹ [EmailService] Initiating email delivery to: " + toEmail + " | Brevo Engine Active: " + (brevoApiKey != null && !brevoApiKey.trim().isEmpty()));

        Runnable sendTask = () -> {
            if (brevoApiKey != null && !brevoApiKey.trim().isEmpty()) {
                boolean sent = sendViaBrevoApi(toEmail, subject, htmlBody);
                if (sent) return;
                System.out.println("⚠ [EmailService] Brevo delivery failed, attempting fallback to SMTP...");
            } else {
                System.out.println("⚠ [EmailService] Brevo API Key not active, attempting SMTP directly...");
            }
            sendViaSmtp(toEmail, subject, htmlBody);
        };

        if (async) {
            CompletableFuture.runAsync(sendTask);
            return true;
        } else {
            sendTask.run();
            return true;
        }
    }

    /**
     * 1. REGISTRATION & PASSWORD RESET OTP EMAIL
     */
    public static boolean sendOtpEmail(String toEmail, String otp, String purpose) {
        // Log OTP to server console
        System.out.println("\n=======================================================");
        System.out.println(" [ShelfBound OTP Service] Target Email: " + toEmail);
        System.out.println(" Purpose: " + purpose);
        System.out.println(" Verification Code (OTP): " + otp);
        System.out.println("=======================================================\n");

        String subject;
        String titleText;
        String messageText;
        String expiryText;

        if ("password_reset".equalsIgnoreCase(purpose)) {
            subject = "ShelfBound - Password Reset Code: " + otp;
            titleText = "Password Reset Request";
            messageText = "We received a request to reset your ShelfBound account password. Use the verification code below to set a new password:";
            expiryText = "This code is valid for <strong>10 minutes</strong>. If you did not request this, please ignore this email.";
        } else {
            subject = "ShelfBound - Verify Your Email: " + otp;
            titleText = "Verify Your Account";
            messageText = "Thank you for joining ShelfBound! Please enter the 6-digit verification code below to complete your registration:";
            expiryText = "This code is valid for <strong>5 minutes</strong>. If you did not register, please ignore this email.";
        }

        String htmlBody = wrapBrandedTemplate(titleText,
                "<p style='margin:0 0 20px;color:#475569;font-size:15px;line-height:1.6;'>" + messageText + "</p>"
                + "<div style='background:#f8fafc;border:2px dashed #cbd5e1;border-radius:12px;padding:20px;text-align:center;margin:0 0 24px;'>"
                + "<span style='font-size:36px;font-weight:800;letter-spacing:8px;color:#ff7a00;font-family:monospace;'>" + otp + "</span>"
                + "</div>"
                + "<p style='margin:0 0 10px;color:#64748b;font-size:13px;line-height:1.5;'>" + expiryText + "</p>");

        return sendHtmlEmail(toEmail, subject, htmlBody, false);
    }

    /**
     * 2. NEWSLETTER SUBSCRIPTION WELCOME EMAIL
     */
    public static void sendNewsletterWelcome(String toEmail) {
        String subject = "Welcome to ShelfBound BookStore - You're Subscribed! 📚";
        String content = "<p style='margin:0 0 16px;color:#334155;font-size:15px;line-height:1.6;'>"
                + "Hello Book Lover! 📖</p>"
                + "<p style='margin:0 0 20px;color:#475569;font-size:14.5px;line-height:1.6;'>"
                + "Thank you for subscribing to the <strong>ShelfBound</strong> newsletter. You will now be the first to know about new arrivals, author spotlights, and exclusive community discounts."
                + "</p>"
                + "<div style='background:#eff6ff;border:1px solid #bfdbfe;border-radius:12px;padding:20px;text-align:center;margin:0 0 24px;'>"
                + "<span style='display:block;font-size:13px;font-weight:700;color:#1e40af;text-transform:uppercase;letter-spacing:1px;margin-bottom:6px;'>Your Welcome Gift: 20% OFF</span>"
                + "<span style='font-size:24px;font-weight:800;letter-spacing:3px;color:#ff7a00;font-family:monospace;'>WELCOME20</span>"
                + "<p style='margin:8px 0 0;color:#64748b;font-size:12px;'>Apply this code at checkout on your next order!</p>"
                + "</div>"
                + "<p style='margin:0;color:#64748b;font-size:13px;'>Happy reading,<br><strong>The ShelfBound Team</strong></p>";

        String htmlBody = wrapBrandedTemplate("Welcome to Our Reading Community", content);
        sendHtmlEmail(toEmail, subject, htmlBody, true);
    }

    /**
     * 3. ORDER PLACEMENT CONFIRMATION EMAIL
     */
    public static void sendOrderConfirmation(String toEmail, String customerName, int orderId,
                                            double totalAmount, String paymentMethod,
                                            String shippingAddress, List<CartItem> items) {
        String subject = "Order Confirmed! #" + orderId + " - ShelfBound BookStore";

        StringBuilder itemsTable = new StringBuilder();
        itemsTable.append("<table style='width:100%;border-collapse:collapse;margin:20px 0;font-size:14px;'>")
                  .append("<tr style='background:#f1f5f9;border-bottom:2px solid #cbd5e1;text-align:left;'>")
                  .append("<th style='padding:10px 12px;color:#334155;'>Book Title</th>")
                  .append("<th style='padding:10px 12px;text-align:center;color:#334155;'>Qty</th>")
                  .append("<th style='padding:10px 12px;text-align:right;color:#334155;'>Price</th>")
                  .append("</tr>");

        if (items != null) {
            for (CartItem item : items) {
                itemsTable.append("<tr style='border-bottom:1px solid #e2e8f0;'>")
                          .append("<td style='padding:10px 12px;color:#1e293b;font-weight:600;'>").append(item.getBook().getTitle()).append("</td>")
                          .append("<td style='padding:10px 12px;text-align:center;color:#64748b;'>").append(item.getQuantity()).append("</td>")
                          .append("<td style='padding:10px 12px;text-align:right;color:#0f172a;font-weight:700;'>₹").append(String.format("%.2f", item.getTotalPrice())).append("</td>")
                          .append("</tr>");
            }
        }
        itemsTable.append("</table>");

        String content = "<p style='margin:0 0 14px;color:#334155;font-size:15px;line-height:1.6;'>"
                + "Dear <strong>" + (customerName != null ? customerName : "Customer") + "</strong>,</p>"
                + "<p style='margin:0 0 20px;color:#475569;font-size:14.5px;line-height:1.6;'>"
                + "Thank you for your order! We have received your purchase and our library team is preparing your books for dispatch."
                + "</p>"
                + "<div style='background:#f8fafc;border:1px solid #e2e8f0;border-radius:12px;padding:16px 20px;margin-bottom:20px;'>"
                + "<div style='display:flex;justify-content:space-between;margin-bottom:8px;font-size:13.5px;'><strong>Order ID:</strong> #" + orderId + "</div>"
                + "<div style='display:flex;justify-content:space-between;margin-bottom:8px;font-size:13.5px;'><strong>Payment Method:</strong> " + paymentMethod + "</div>"
                + "<div style='display:flex;justify-content:space-between;margin-bottom:8px;font-size:13.5px;'><strong>Delivery Address:</strong> " + shippingAddress + "</div>"
                + "<div style='display:flex;justify-content:space-between;font-size:15px;font-weight:700;color:#ff7a00;margin-top:10px;border-top:1px dashed #cbd5e1;padding-top:10px;'><strong>Total Paid:</strong> ₹" + String.format("%.2f", totalAmount) + "</div>"
                + "</div>"
                + "<h4 style='margin:20px 0 10px;color:#0f172a;font-size:15px;'>Items Ordered:</h4>"
                + itemsTable.toString()
                + "<p style='margin:20px 0 0;color:#64748b;font-size:13px;line-height:1.5;'>"
                + "You can track the progress of this order anytime in your ShelfBound account under <strong>My Orders</strong>."
                + "</p>";

        String htmlBody = wrapBrandedTemplate("Thank You For Your Order! 📦", content);
        sendHtmlEmail(toEmail, subject, htmlBody, true);
    }

    /**
     * 4. ORDER STATUS UPDATE EMAIL (ADMIN ACTION)
     */
    public static void sendOrderStatusUpdate(String toEmail, String customerName, int orderId, String newStatus) {
        String subject = "Order #" + orderId + " Status Update: " + newStatus + " - ShelfBound BookStore";

        String statusColor = "#2563eb";
        String statusDescription = "Your order status has been updated to <strong>" + newStatus + "</strong>.";

        if ("Shipped".equalsIgnoreCase(newStatus)) {
            statusColor = "#8b5cf6";
            statusDescription = "Great news! Your books have been packed and handed over to our courier partner. They are on their way to you! 🚚";
        } else if ("Delivered".equalsIgnoreCase(newStatus)) {
            statusColor = "#10b981";
            statusDescription = "Your order has been marked as <strong>Delivered</strong>! We hope you enjoy your new reading journey. ✨";
        } else if ("Cancelled".equalsIgnoreCase(newStatus)) {
            statusColor = "#ef4444";
            statusDescription = "Your order #" + orderId + " has been cancelled. If you did not request this or have questions, please contact support.";
        } else if ("Confirmed".equalsIgnoreCase(newStatus)) {
            statusColor = "#0284c7";
            statusDescription = "Your order has been officially confirmed by our team and is now queued for packing.";
        }

        String content = "<p style='margin:0 0 14px;color:#334155;font-size:15px;line-height:1.6;'>"
                + "Hello <strong>" + (customerName != null ? customerName : "Customer") + "</strong>,</p>"
                + "<p style='margin:0 0 20px;color:#475569;font-size:14.5px;line-height:1.6;'>"
                + "There is an update regarding your ShelfBound Order <strong>#" + orderId + "</strong>:"
                + "</p>"
                + "<div style='background:#f8fafc;border:1px solid #e2e8f0;border-radius:12px;padding:24px;text-align:center;margin:0 0 24px;'>"
                + "<div style='display:inline-block;background:" + statusColor + ";color:#ffffff;font-size:16px;font-weight:700;padding:8px 24px;border-radius:9999px;margin-bottom:12px;letter-spacing:0.5px;text-transform:uppercase;'>"
                + newStatus
                + "</div>"
                + "<p style='margin:0;color:#334155;font-size:14.5px;line-height:1.5;'>" + statusDescription + "</p>"
                + "</div>"
                + "<p style='margin:0;color:#64748b;font-size:13px;line-height:1.5;'>"
                + "For complete order information or tracking details, log in to your ShelfBound account and visit the <strong>My Orders</strong> section."
                + "</p>";

        String htmlBody = wrapBrandedTemplate("Order Status Update", content);
        sendHtmlEmail(toEmail, subject, htmlBody, true);
    }

    /**
     * 5. ADMIN REPLY TO CUSTOMER INQUIRY EMAIL
     */
    public static void sendAdminReply(String toEmail, String customerName, String originalMessage, String replyText) {
        String subject = "Response to your inquiry - ShelfBound BookStore Support";

        String content = "<p style='margin:0 0 14px;color:#334155;font-size:15px;line-height:1.6;'>"
                + "Dear <strong>" + (customerName != null ? customerName : "Customer") + "</strong>,</p>"
                + "<p style='margin:0 0 20px;color:#475569;font-size:14.5px;line-height:1.6;'>"
                + "Thank you for reaching out to ShelfBound BookStore. Our customer support team has reviewed your inquiry:"
                + "</p>"
                + "<div style='background:#f8fafc;border-left:4px solid #cbd5e1;padding:14px 18px;border-radius:0 12px 12px 0;margin:0 0 20px;'>"
                + "<span style='display:block;font-size:11.5px;font-weight:700;color:#64748b;text-transform:uppercase;margin-bottom:6px;'>Your Message:</span>"
                + "<p style='margin:0;color:#475569;font-size:14px;font-style:italic;'>\"" + originalMessage + "\"</p>"
                + "</div>"
                + "<div style='background:#f0fdf4;border-left:4px solid #10b981;padding:16px 20px;border-radius:0 12px 12px 0;margin:0 0 24px;'>"
                + "<span style='display:block;font-size:12px;font-weight:700;color:#15803d;text-transform:uppercase;margin-bottom:6px;'>Official ShelfBound Response:</span>"
                + "<p style='margin:0;color:#1e293b;font-size:15px;line-height:1.6;white-space:pre-wrap;'>" + replyText + "</p>"
                + "</div>"
                + "<p style='margin:0;color:#64748b;font-size:13px;line-height:1.5;'>"
                + "If you have any further questions, feel free to reply directly to this email or visit our Contact Us page."
                + "</p>";

        String htmlBody = wrapBrandedTemplate("Customer Support Response", content);
        sendHtmlEmail(toEmail, subject, htmlBody, true);
    }

    /**
     * Common reusable branded HTML container
     */
    private static String wrapBrandedTemplate(String headerTitle, String innerContent) {
        return "<!DOCTYPE html>"
                + "<html><head><meta charset='UTF-8'></head>"
                + "<body style='margin:0;padding:0;background-color:#f1f5f9;font-family:Segoe UI,Tahoma,Geneva,Verdana,sans-serif;'>"
                + "<div style='max-width:600px;margin:30px auto;background:#ffffff;border-radius:16px;overflow:hidden;border:1px solid #e2e8f0;box-shadow:0 10px 30px rgba(0,0,0,0.06);'>"
                + "<div style='background:linear-gradient(135deg,#0f172a,#1e3a8a);padding:32px 24px;text-align:center;'>"
                + "<h1 style='margin:0;font-size:28px;font-weight:800;letter-spacing:-0.5px;color:#ffffff;'><span style='color:#ff7a00;'>Shelf</span>Bound</h1>"
                + "<p style='margin:6px 0 0;color:rgba(255,255,255,0.7);font-size:13px;letter-spacing:1px;text-transform:uppercase;'>BookStore</p>"
                + "</div>"
                + "<div style='padding:36px 32px;color:#1e293b;'>"
                + "<h2 style='margin:0 0 18px;color:#0f172a;font-size:20px;font-weight:700;'>" + headerTitle + "</h2>"
                + innerContent
                + "<hr style='border:none;border-top:1px solid #e2e8f0;margin:28px 0 20px;'>"
                + "<p style='margin:0;color:#94a3b8;font-size:12px;text-align:center;'>© 2026 ShelfBound BookStore. All rights reserved.</p>"
                + "</div></div></body></html>";
    }

    public static void main(String[] args) {
        String testEmail = (args.length > 0) ? args[0] : user;
        System.out.println("Testing email delivery to: " + testEmail);
        String testOtp = generateOtp();
        boolean success = sendOtpEmail(testEmail, testOtp, "registration");
        System.out.println("Result: " + (success ? "SUCCESS! Real email sent." : "FAILED to send email."));
    }
}
