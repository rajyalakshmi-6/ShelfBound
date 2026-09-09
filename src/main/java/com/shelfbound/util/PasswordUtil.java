package com.shelfbound.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for BCrypt password hashing and verification.
 * Supports seamless backward compatibility with legacy plain-text passwords.
 */
public class PasswordUtil {

    private static final int LOG_ROUNDS = 12;

    /**
     * Hashes a plain-text password using BCrypt with automatic salting.
     * 
     * @param plainTextPassword The raw user password
     * @return The 60-character BCrypt hash string
     */
    public static String hashPassword(String plainTextPassword) {
        if (plainTextPassword == null || plainTextPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty.");
        }
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt(LOG_ROUNDS));
    }

    /**
     * Verifies an entered plain-text password against a stored database value.
     * If the stored value is a BCrypt hash, it uses cryptographic verification.
     * If the stored value is legacy plain-text, it falls back to equality check.
     * 
     * @param plainTextPassword The raw entered password
     * @param storedPassword    The value stored in MySQL (BCrypt hash or legacy plain-text)
     * @return true if password matches, false otherwise
     */
    public static boolean checkPassword(String plainTextPassword, String storedPassword) {
        if (plainTextPassword == null || storedPassword == null) {
            return false;
        }

        if (isBcryptHash(storedPassword)) {
            try {
                return BCrypt.checkpw(plainTextPassword, storedPassword);
            } catch (Exception e) {
                System.err.println("[PasswordUtil] BCrypt verification error: " + e.getMessage());
                return false;
            }
        }

        // Fallback for legacy plain-text passwords
        return storedPassword.equals(plainTextPassword);
    }

    /**
     * Determines whether a given string is formatted as a valid BCrypt hash.
     */
    public static boolean isBcryptHash(String value) {
        if (value == null || value.length() < 59) {
            return false;
        }
        return value.startsWith("$2a$") || value.startsWith("$2b$") || value.startsWith("$2y$");
    }
}
