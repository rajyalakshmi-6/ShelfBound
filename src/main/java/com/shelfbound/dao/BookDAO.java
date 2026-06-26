package com.shelfbound.dao;

import java.util.List;
import com.shelfbound.model.Book;

public interface BookDAO {

    // Get all books
    List<Book> getAllBooks() throws Exception;

    // Get books by category
    List<Book> getBooksByCategory(int categoryId) throws Exception;
    List<Book> getNewArrivals() throws Exception;

    List<Book> getPopularBooks() throws Exception;
    
 
    // Get single book by ID
    Book getBookById(int bookId) throws Exception;
    
    // ==========================
    // TOTAL BOOKS
    // ==========================
    int getTotalBooks() throws Exception;
    
 // ==========================
 // ADMIN OPERATIONS
 // ==========================

 boolean addBook(Book book) throws Exception;

 boolean deleteBook(int bookId) throws Exception;

 boolean updateStock(
         int bookId,
         int stockQuantity) throws Exception;
 
//==========================
//SEARCH BOOKS
//==========================
List<Book> searchBooks(String keyword) throws Exception;

//Returns matching titles, authors and categories for autocomplete
//List<String> getSearchSuggestions(String keyword) throws Exception;
    
}