package com.jtspringproject.JtSpringProject.unit_tests;
import org.junit.Test;
import static org.junit.Assert.assertEquals;
import com.jtspringproject.JtSpringProject.CartItem;

public class CartItemTest {

    @Test
    public void testCartItem() {
        String productName = "Product 1";
        int quantity = 2;
        float totalPrice = 50.0f;
        int productID = 101;

        CartItem cartItem = new CartItem(productName, quantity, totalPrice, productID);

        assertEquals(productName, cartItem.getProductName());
        assertEquals(quantity, cartItem.getQuantity());
        assertEquals(totalPrice, cartItem.getTotalPrice(), 0.001); // Using delta to handle float comparison
        assertEquals(productID, cartItem.getProductID());
    }

    @Test
    public void testGettersWithDifferentValues() {
        String productName = "Product 2";
        int quantity = 5;
        float totalPrice = 20.0f;
        int productID = 102;

        CartItem cartItem = new CartItem(productName, quantity, totalPrice, productID);

        assertEquals(productName, cartItem.getProductName());
        assertEquals(quantity, cartItem.getQuantity());
        assertEquals(totalPrice, cartItem.getTotalPrice(), 0.001); // Using delta to handle float comparison
        assertEquals(productID, cartItem.getProductID());
    }
}