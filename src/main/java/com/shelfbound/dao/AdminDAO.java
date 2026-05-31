package com.shelfbound.dao;

import com.shelfbound.model.Admin;

public interface AdminDAO {

    Admin loginAdmin(String username,
                     String password);
// dashboard information  
    int getTotalUsers();

    int getTotalBooks();

    int getTotalOrders();

    int getPendingOrders();
}