package com.shelfbound.dao;

import java.util.List;

import com.shelfbound.model.Cart;

public interface CartDAO {

    boolean addToCart(
            int userId,
            int bookId,
            int quantity)
            throws Exception;

    boolean removeFromCart(
            int userId,
            int bookId)
            throws Exception;

    List<Cart> getCartByUserId(
            int userId)
            throws Exception;

    Cart getCartItem(
            int userId,
            int bookId)
            throws Exception;

    boolean updateQuantity(
            int userId,
            int bookId,
            int quantity)
            throws Exception;
}