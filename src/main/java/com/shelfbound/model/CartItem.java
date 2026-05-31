package com.shelfbound.model;

public class CartItem {
	public double getTotalPrice() {
	    return book.getPrice() * quantity;
	}

    private Book book;
    private int quantity;

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}