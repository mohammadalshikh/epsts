package com.epsts.EPSTS;

public class UserItem {
    private String productName;
    private int quantity;
    private float totalPrice;
    private int productID;

    public UserItem(String productName, int quantity, float totalPrice, int productID) {
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