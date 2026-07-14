package com.shelfbound.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.shelfbound.connection.DBConnection;
import com.shelfbound.dao.BookDAO;
import com.shelfbound.model.Book;

public class BookDAOImpl implements BookDAO {

    // ==========================
    // GET ALL BOOKS
    // ==========================
    @Override
    public List<Book> getAllBooks() throws Exception {

        List<Book> list = new ArrayList<>();

        String sql = "SELECT * FROM books";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {
                list.add(mapBook(rs));
            }
        }

        return list;
    }

    // ==========================
    // GET BOOK BY ID
    // ==========================
    @Override
    public Book getBookById(int bookId) throws Exception {

        String sql = "SELECT * FROM books WHERE book_id = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, bookId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return mapBook(rs);
                }
            }
        }

        return null;
    }

    // ==========================
    // GET BOOKS BY CATEGORY
    // ==========================
    @Override
    public List<Book> getBooksByCategory(int categoryId) throws Exception {

        List<Book> list = new ArrayList<>();

        String sql =
            "SELECT * FROM books WHERE category_id = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, categoryId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    list.add(mapBook(rs));
                }
            }
        }

        return list;
    }

    // ==========================
    // NEW ARRIVALS
    // ==========================
    @Override
    public List<Book> getNewArrivals() throws Exception {

        List<Book> list = new ArrayList<>();

        String sql =
            "SELECT * FROM books WHERE is_new_arrival = TRUE";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {
                list.add(mapBook(rs));
            }
        }

        return list;
    }

    // ==========================
    // POPULAR BOOKS
    // ==========================
    @Override
    public List<Book> getPopularBooks() throws Exception {

        List<Book> list = new ArrayList<>();

        String sql =
            "SELECT * FROM books WHERE is_popular = TRUE";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {
                list.add(mapBook(rs));
            }
        }

        return list;
    }
    
 // ==========================
 // ADD BOOK
 // ==========================
 @Override
 public boolean addBook(Book book)
         throws Exception {

     String sql =
         "INSERT INTO books " +
         "(title, author, description, price, stock_quantity, image_url) " +
         "VALUES (?, ?, ?, ?, ?, ?)";

     try (
         Connection con = DBConnection.getConnection();
         PreparedStatement ps =
             con.prepareStatement(sql)
     ) {

         ps.setString(1, book.getTitle());
         ps.setString(2, book.getAuthor());
         ps.setString(3, book.getDescription());
         ps.setDouble(4, book.getPrice());
         ps.setInt(5, book.getStockQuantity());
         ps.setString(6, book.getImageUrl());

         return ps.executeUpdate() > 0;
     }
 }
 
 
//==========================
//DELETE BOOK
//==========================
@Override
public boolean deleteBook(int bookId)
      throws Exception {

  String sql =
      "DELETE FROM books WHERE book_id=?";

  try (
      Connection con = DBConnection.getConnection();
      PreparedStatement ps =
          con.prepareStatement(sql)
  ) {

      ps.setInt(1, bookId);

      return ps.executeUpdate() > 0;
  }
}


//==========================
//UPDATE STOCK
//==========================
@Override
public boolean updateStock(
     int bookId,
     int stockQuantity)
     throws Exception {

 String sql =
     "UPDATE books " +
     "SET stock_quantity=? " +
     "WHERE book_id=?";

 try (
     Connection con = DBConnection.getConnection();
     PreparedStatement ps =
         con.prepareStatement(sql)
 ) {

     ps.setInt(1, stockQuantity);
     ps.setInt(2, bookId);

     return ps.executeUpdate() > 0;
 }
}

    // ==========================
    // COMMON BOOK MAPPER
    // ==========================
// ==========================
// COMMON BOOK MAPPER
// ==========================
private Book mapBook(ResultSet rs) throws Exception {

    Book b = new Book();

    b.setBookId(rs.getInt("book_id"));
    b.setTitle(rs.getString("title"));
    b.setAuthor(rs.getString("author"));
    b.setDescription(rs.getString("description"));
    b.setPrice(rs.getDouble("price"));
    b.setStockQuantity(rs.getInt("stock_quantity"));
    b.setImageUrl(rs.getString("image_url"));
    b.setRating(rs.getDouble("rating"));
    b.setCategoryId(rs.getInt("category_id"));  // ← ADDED

    return b;
}
    @Override
    public List<Book> searchBooks(String keyword) throws Exception {

        // List to store matching books
        List<Book> list = new ArrayList<>();

     // Search books by:
     // 1. Title
     // 2. Author
     // 3. Category Name
     //
     // Example:
     // Java      -> matches title
     // Rowling   -> matches author
     // Fiction   -> matches category
        String sql =
        	    "SELECT b.* " +
        	    "FROM books b " +
        	    "LEFT JOIN categories c ON b.category_id = c.category_id " +
        	    "WHERE LOWER(b.title) LIKE ? " +
        	    "OR LOWER(b.author) LIKE ? " +
        	    "OR LOWER(c.category_name) LIKE ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            // Add % on both sides so partial matches work.
            //
            // Example:
            // Searching "java"
            // becomes "%java%"
            //
            // Matches:
            // Java
            // Core Java
            // Advanced Java
        	String search = "%" + keyword.toLowerCase() + "%";

        	ps.setString(1, search);
        	ps.setString(2, search);
        	ps.setString(3, search);

            try (ResultSet rs = ps.executeQuery()) {

                // Convert every database row
                // into a Book object.
                while (rs.next()) {

                    list.add(mapBook(rs));
                }
            }
        }

        // Return matching books to BooksServlet
        return list;
    }
    
    
 // ==========================
 // SEARCH SUGGESTIONS
 // ==========================
// @Override
// public List<String> getSearchSuggestions(String keyword) throws Exception {
//
//     List<String> suggestions = new ArrayList<>();
//
//     String sql =
//             "SELECT DISTINCT suggestion FROM ("
//
//           + "SELECT title AS suggestion "
//           + "FROM books "
//           + "WHERE LOWER(title) LIKE ? "
//
//           + "UNION "
//
//           + "SELECT author "
//           + "FROM books "
//           + "WHERE LOWER(author) LIKE ? "
//
//           + "UNION "
//
//           + "SELECT category_name "
//           + "FROM categories "
//           + "WHERE LOWER(category_name) LIKE ? "
//
//           + ") temp "
//           + "LIMIT 8";
//
//     try (
//             Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql)
//     ) {
//
//         String search = keyword.toLowerCase() + "%";
//
//         ps.setString(1, search);
//         ps.setString(2, search);
//         ps.setString(3, search);
//
//         ResultSet rs = ps.executeQuery();
//
//         while (rs.next()) {
//             suggestions.add(rs.getString("suggestion"));
//         }
//     }
//
//     return suggestions;
// }
//    

    
 // ==========================
 // TOTAL BOOKS
 // ==========================
 @Override
 public int getTotalBooks() throws Exception {

     String sql =
             "SELECT COUNT(*) FROM books";

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
}