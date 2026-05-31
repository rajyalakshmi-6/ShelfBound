package com.shelfbound.dao;

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
}