package com.jtspringproject.JtSpringProject;

public class CartItem {
    private String productName;
    private int quantity;
    private float totalPrice;
    private int productID;

    public CartItem(String productName, int quantity, float totalPrice, int productID) {
        this.productName = productName;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
        this.productID = productID;
    }

    public String getProductName() {
        return productName;
    }

    public int getQuantity() {
        return quantity;
    }

    public float getTotalPrice() {
        return totalPrice;
    }

    public int getProductID() {
        return productID;
    }
}