package com.shelfbound.dao;

import java.util.List;
import com.shelfbound.model.User;

public interface UserDAO {

    // =========================
    // REGISTER USER
    // =========================
    boolean registerUser(User user);

    // =========================
    // USER LOGIN
    // =========================
    User loginUser(String username,
                   String password);

    // =========================
    // CHECK USERNAME EXISTS
    // =========================
    boolean isUsernameExists(String username);

    // =========================
    // CHECK EMAIL EXISTS
    // =========================
    boolean isEmailExists(String email);
    
    
    boolean updateUser(User user);  // for profile data updation
    
    // =========================
    // UPDATE PASSWORD (FORGOT PASSWORD)
    // =========================
    boolean updatePassword(String email, String newPassword);

    // =========================
    // USER MANAGEMENT & BLOCKING
    // =========================
    List<User> getAllUsers();

    boolean updateUserStatus(int userId, String status);

    User getUserById(int userId);
}