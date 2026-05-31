package com.shelfbound.dao;

import java.util.List;
import com.shelfbound.model.Order;

public interface OrderDAO {
    List<Order> getOrdersByUser(int userId) throws Exception;
    Order getOrderById(int orderId, int userId) throws Exception;
    
    
 // ==========================
 // TOTAL ORDERS
 // ==========================
 int getTotalOrders() throws Exception;

 // ==========================
 // TOTAL PENDING ORDERS
 // ==========================
 int getPendingOrders() throws Exception;
 
 List<Order> getAllOrders() throws Exception;

 boolean updateOrderStatus(int orderId, String status) throws Exception;
}