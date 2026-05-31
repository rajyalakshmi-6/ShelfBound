package com.shelfbound.daoimpl;

import java.sql.*;
import java.util.*;

import com.shelfbound.connection.DBConnection;
import com.shelfbound.dao.OrderDAO;
import com.shelfbound.model.Order;
import com.shelfbound.model.OrderItem;

public class OrderDAOImpl implements OrderDAO {

	@Override
	public List<Order> getOrdersByUser(int userId) throws Exception {

	    Map<Integer, Order> orderMap = new LinkedHashMap<>();

	    String sql =
	        "SELECT o.order_id, o.total_amount, o.order_status, o.order_date, " +
	        "b.title, b.image_url, oi.quantity, oi.price " +
	        "FROM orders o " +
	        "JOIN order_items oi ON o.order_id = oi.order_id " +
	        "JOIN books b ON oi.book_id = b.book_id " +
	        "WHERE o.user_id = ? " +
	        "ORDER BY o.order_date DESC";

	    try (
	        Connection con = DBConnection.getConnection();
	        PreparedStatement ps = con.prepareStatement(sql)
	    ) {
	        ps.setInt(1, userId);

	        try (ResultSet rs = ps.executeQuery()) {

	            while (rs.next()) {

	                int orderId = rs.getInt("order_id");

	                Order order = orderMap.get(orderId);

	                if (order == null) {

	                    order = new Order();
	                    order.setOrderId(orderId);
	                    order.setTotalAmount(rs.getDouble("total_amount"));
	                    order.setStatus(rs.getString("order_status"));
	                    order.setOrderDate(rs.getString("order_date"));

	                    order.setItems(new ArrayList<>());

	                    orderMap.put(orderId, order);
	                }

	                OrderItem item = new OrderItem();
	                item.setTitle(rs.getString("title"));
	                item.setImageUrl(rs.getString("image_url"));
	                item.setQuantity(rs.getInt("quantity"));
	                item.setPrice(rs.getDouble("price"));

	                order.getItems().add(item);
	            }
	        }
	    }

	    return new ArrayList<>(orderMap.values());
	}
	
	@Override
	public Order getOrderById(int orderId, int userId) throws Exception {

		String sql =
			    "SELECT o.order_id, o.total_amount, o.order_status, o.order_date, " +
			    "o.shipping_address, b.title, b.image_url, oi.quantity, oi.price " +
			    "FROM orders o " +
			    "JOIN order_items oi ON o.order_id = oi.order_id " +
			    "JOIN books b ON oi.book_id = b.book_id " +
			    "WHERE o.order_id = ? AND o.user_id = ?";

	    Order order = null;

	    try (
	        Connection con = DBConnection.getConnection();
	        PreparedStatement ps = con.prepareStatement(sql)
	    ) {

	        ps.setInt(1, orderId);
	        ps.setInt(2, userId);

	        try (ResultSet rs = ps.executeQuery()) {

	            while (rs.next()) {

	                if (order == null) {

	                    order = new Order();
	                    order.setOrderId(rs.getInt("order_id"));
	                    order.setTotalAmount(rs.getDouble("total_amount"));
	                    order.setStatus(rs.getString("order_status"));
	                    order.setOrderDate(rs.getString("order_date"));
	                    order.setShippingAddress(rs.getString("shipping_address"));
	                    order.setItems(new ArrayList<>());
	                }

	                OrderItem item = new OrderItem();
	                item.setTitle(rs.getString("title"));
	                item.setImageUrl(rs.getString("image_url"));
	                item.setQuantity(rs.getInt("quantity"));
	                item.setPrice(rs.getDouble("price"));

	                order.getItems().add(item);
	            }
	        }
	    }

	    return order;
	}
	
	// ==========================
	// TOTAL ORDERS
	// ==========================
	@Override
	public int getTotalOrders() throws Exception {

	    String sql =
	            "SELECT COUNT(*) FROM orders";

	    try (
	        Connection con = DBConnection.getConnection();
	        PreparedStatement ps =
	                con.prepareStatement(sql);
	        ResultSet rs =
	                ps.executeQuery()
	    ) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }
	    }

	    return 0;
	}

	// ==========================
	// PENDING ORDERS
	// ==========================
	@Override
	public int getPendingOrders() throws Exception {

	    String sql =
	            "SELECT COUNT(*) FROM orders " +
	            "WHERE order_status='Pending'";

	    try (
	        Connection con = DBConnection.getConnection();
	        PreparedStatement ps =
	                con.prepareStatement(sql);
	        ResultSet rs =
	                ps.executeQuery()
	    ) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }
	    }

	    return 0;
	}
	
	@Override
	public List<Order> getAllOrders() throws Exception {

	    Map<Integer, Order> orderMap = new LinkedHashMap<>();

	    String sql =
	    		"SELECT o.order_id, o.user_id, o.total_amount, o.order_status, o.order_date, " +
	    		"o.shipping_address, b.title, b.image_url, oi.quantity, oi.price " +
	    		"FROM orders o " +
	    		"JOIN order_items oi ON o.order_id = oi.order_id " +
	    		"JOIN books b ON oi.book_id = b.book_id " +
	    		"ORDER BY o.order_date DESC";

	    try (
	        Connection con = DBConnection.getConnection();
	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery()
	    ) {

	        while (rs.next()) {

	            int orderId = rs.getInt("order_id");

	            Order order = orderMap.get(orderId);

	            if (order == null) {
	                order = new Order();
	                order.setOrderId(orderId);
	                order.setTotalAmount(rs.getDouble("total_amount"));
	                order.setStatus(rs.getString("order_status"));
	                order.setOrderDate(rs.getString("order_date"));
	                order.setUserId(rs.getInt("user_id"));
	                order.setShippingAddress(rs.getString("shipping_address"));

	                order.setItems(new ArrayList<>());

	                orderMap.put(orderId, order);
	            }

	            OrderItem item = new OrderItem();
	            item.setTitle(rs.getString("title"));
	            item.setImageUrl(rs.getString("image_url"));
	            item.setQuantity(rs.getInt("quantity"));
	            item.setPrice(rs.getDouble("price"));

	            order.getItems().add(item);
	        }
	    }

	    return new ArrayList<>(orderMap.values());
	}
	
	
	@Override
	public boolean updateOrderStatus(int orderId, String status) throws Exception {

	    String sql =
	        "UPDATE orders SET order_status=? WHERE order_id=?";

	    try (
	        Connection con = DBConnection.getConnection();
	        PreparedStatement ps = con.prepareStatement(sql)
	    ) {

	        ps.setString(1, status);
	        ps.setInt(2, orderId);

	        return ps.executeUpdate() > 0;
	    }
	}
	
	
}