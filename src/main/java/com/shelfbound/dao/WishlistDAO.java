package com.shelfbound.dao;

import com.shelfbound.model.Book;
import java.util.List;

public interface WishlistDAO {

    // Add a book to user's wishlist (ignore if already exists)
    void addToWishlist(int userId, int bookId);

    // Remove a book from user's wishlist
    void removeFromWishlist(int userId, int bookId);

    // Get all books in a user's wishlist
    List<Book> getWishlistByUserId(int userId);

    // Check if a specific book is already in user's wishlist
    boolean isInWishlist(int userId, int bookId);
    
 // In WishlistDAO.java
    List<Integer> getWishlistBookIds(String username);
}