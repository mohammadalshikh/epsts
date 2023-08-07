package com.epsts.EPSTS.controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.*;

import com.epsts.EPSTS.CartItem;
import com.epsts.EPSTS.ShopItem;
import com.epsts.EPSTS.CustomCartItem;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.web.bind.annotation.*;

import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class UserController {

    int userlogcheck = 0;
    public static String usernameforclass = "";

    public static void setUsername(String usernameforclass) {
        UserController.usernameforclass = usernameforclass;
    }


    @RequestMapping(value = "/logoutUser", method = RequestMethod.POST)
    public String returnIndex() {
        userlogcheck = 0;
        usernameforclass = "";
        UserController.setUsername("");
        AdminController.setUsername("");
        return "redirect:/";
    }

    @GetMapping("/")
    public String userLogin(Model model) {
        return "userLogin";
    }

    @RequestMapping(value = "/", method = RequestMethod.POST)
    public String userCheck(@RequestParam("username") String username, @RequestParam("password") String pass, Model model) {
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();
            ResultSet rst = stmt.executeQuery("select * from users where username = '" + username + "' and password = '" + pass + "' ;");
            if (rst.next()) {
                usernameforclass = rst.getString(2);
                UserController.setUsername(usernameforclass);
                AdminController.setUsername(usernameforclass);
                userlogcheck = 1;
                return "redirect:/home";
            } else {
                model.addAttribute("failMessage", "Invalid Username or Password");
                return "userLogin";
            }
        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }
        return "userLogin";
    }

    @GetMapping("/home")
    public String home(Model model) {
        if (usernameforclass.equalsIgnoreCase(""))
            return "redirect:/";
        else {
            model.addAttribute("username", usernameforclass);
            UserController.setUsername(usernameforclass);
            return "userHome";
        }
    }

    @GetMapping("/contact")
    public String contact() {
        if(userlogcheck == 0) {
            return "redirect:/";
        }
        else {
            return "contact";
        }
    }

    @RequestMapping(value = "submitContact", method = RequestMethod.POST)
    public String submitContact(@RequestParam("name") String name,
                                @RequestParam("email") String email,
                                @RequestParam("subject") String subject,
                                @RequestParam("message") String message,
                                @RequestParam("inquiry-type") String inquiryType,
                                Model model,
                                RedirectAttributes redirectAttributes) {

        // Code to send the first email to the user
        String userMessage = "Dear " + name + ",\n\nThank you for contacting us. Your request has been received. " +
                "Here is a summary of your message:\n\n" +
                "Name: " + name + "\n" +
                "Email: " + email + "\n" +
                "Subject: " + subject + "\n" +
                "Message: " + message + "\n" +
                "Inquiry Type: " + inquiryType + "\n\n" +
                "We will get back to you as soon as possible.\n\nBest regards,\nThe EPSTS Team";

        sendEmail(email, "bestfood438@gmail.com", "Your Contact Request", userMessage);

        // Code to send the second email to the admin email
        String adminMessage = "A new contact request has been submitted:\n\n" +
                "Name: " + name + "\n" +
                "Email: " + email + "\n" +
                "Subject: " + subject + "\n" +
                "Message: " + message + "\n" +
                "Inquiry Type: " + inquiryType + "\n";

        sendEmail("bestfood438@gmail.com", email, "New Contact Request", adminMessage);

        redirectAttributes.addFlashAttribute("successMessage", "Your contact request has been submitted successfully!");

        return "redirect:/contact";
    }

    // Helper method to send emails using JavaMail API
    private void sendEmail(String recipient, String sender, String subject, String body) {
        // SMTP server configuration
        String host = "smtp.gmail.com";
        String port = "587";
        String username = "bestfood438@gmail.com";
        String password = "niwmagtnrxcdcehq";


        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            Message message = new MimeMessage(session);

            // The sender and recipient addresses
            message.setFrom(new InternetAddress(sender));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));

            // The email subject and body
            message.setSubject(subject);
            message.setText(body);

            // Send the email
            Transport.send(message);

            System.out.println("Email sent successfully to " + recipient);
        } catch (MessagingException e) {
            e.printStackTrace();
            System.err.println("Failed to send email to " + recipient);
        }
    }

    @GetMapping("profile")
    public String profile(Model model) {
        if(userlogcheck == 0) {
            return "redirect:/";
        }
        else {
            String displayusername, displaypassword, displayemail, displayaddress, displaytotal;
            int displaycoupons;
            try {
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
                Statement stmt = con.createStatement();
                ResultSet rst = stmt.executeQuery("select * from users where username = '" + usernameforclass + "';");

                if (rst.next()) {
                    int userid = rst.getInt(1);
                    displayusername = rst.getString(2);
                    displayemail = rst.getString(6);
                    displaypassword = rst.getString(3);
                    displayaddress = rst.getString(5);
                    displaycoupons = rst.getInt("coupons");
                    displaytotal = new DecimalFormat("0.00").format(rst.getFloat("cumulativeTotal"));
                    model.addAttribute("userid", userid);
                    model.addAttribute("username", displayusername);
                    model.addAttribute("email", displayemail);
                    model.addAttribute("password", displaypassword);
                    model.addAttribute("address", displayaddress);
                    model.addAttribute("userCoupons", displaycoupons);
                    model.addAttribute("cumulativeTotal", displaytotal);
                }
            } catch (Exception e) {
                System.out.println("Exception:" + e);
            }
            return "profile";
        }
    }


    @GetMapping("/user/products")
    public String getproduct(Model model) {
        return "uproduct";
    }

    @ResponseBody
    @GetMapping("/checkUsernameAvailability")
    public Map<String, Boolean> checkUsernameAvailability(@RequestParam("username") String username) {
        Map<String, Boolean> response = new HashMap<>();
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            PreparedStatement pst = con.prepareStatement("SELECT COUNT(*) FROM users WHERE username = ?;");
            pst.setString(1, username);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                response.put("exists", count > 0);
            } else {
                response.put("exists", false);
            }
        } catch (Exception e) {
            System.out.println("Exception:" + e);
            response.put("exists", false);
        }
        return response;
    }

    @ResponseBody
    @GetMapping("/checkEmailAvailability")
    public Map<String, Boolean> checkEmailAvailability(@RequestParam("email") String email) {
        Map<String, Boolean> response = new HashMap<>();
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            PreparedStatement pst = con.prepareStatement("SELECT COUNT(*) FROM users WHERE email = ?;");
            pst.setString(1, email);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                response.put("exists", count > 0);
            } else {
                response.put("exists", false);
            }
        } catch (Exception e) {
            System.out.println("Exception:" + e);
            response.put("exists", false);
        }
        return response;
    }

    @RequestMapping(value = "newuserregister", method = RequestMethod.POST)
    public String newUseRegister(@RequestParam("username") String username, @RequestParam("password") String password, @RequestParam("email") String email, @RequestParam("address") String address) {
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            PreparedStatement pst = con.prepareStatement("insert into users(username,password,email,address) values(?,?,?,?);");
            pst.setString(1, username);
            pst.setString(2, password);
            pst.setString(3, email);
            pst.setString(4, address);

            //pst.setString(4, address);
            int i = pst.executeUpdate();
            System.out.println("data base updated" + i);

        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }
        return "redirect:/";
    }

    @GetMapping("clearcart")
    public static String clearcart() {
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();
            ResultSet rst = stmt.executeQuery("SELECT * from Cart where userID = (select user_id from users where username = '" + usernameforclass + "');");

            if (rst.next()) {
                int userID = rst.getInt("userID");
                stmt.executeUpdate("DELETE FROM Cart WHERE userID = " + userID + ";");
            }

        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }
        return "redirect:/schedule";
    }

    @GetMapping("clearcustomcart")
    public String clearCustomCart() {
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();
            ResultSet rst = stmt.executeQuery("SELECT * from CustomCart where userID = (select user_id from users where username = '" + usernameforclass + "');");

            if (rst.next()) {
                int userID = rst.getInt("userID");
                stmt.executeUpdate("DELETE FROM CustomCart WHERE userID = " + userID + ";");
            }

        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }
        return "redirect:/customCart";
    }


    @GetMapping("movecustomtocart")
    public String moveCustomToCart(Model model) {
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();

            // Fetch existing items and quantities from Cart
            Map<String, Integer> cartIts = new HashMap<>();
            ResultSet cartRs = stmt.executeQuery("SELECT productID, quantity FROM Cart WHERE userID = (SELECT user_id FROM users WHERE username = '" + usernameforclass + "');");
            while (cartRs.next()) {
                String productID = cartRs.getString("productID");
                int quantity = cartRs.getInt("quantity");
                cartIts.put(productID, quantity);
            }


            ResultSet customCartRs = stmt.executeQuery("SELECT productID, quantity FROM CustomCart WHERE userID = (SELECT user_id FROM users WHERE username = '" + usernameforclass + "');");

            while (customCartRs.next()) {
                String productID = customCartRs.getString("productID");
                int quantity = customCartRs.getInt("quantity");

                // Check if the product is already in the cart
                if (cartIts.containsKey(productID)) {
                    int currentQuantity = cartIts.get(productID);
                    int newQuantity = currentQuantity + quantity;
                    // Update the quantity in the Cart table
                    Statement stmt2 = con.createStatement();
                    stmt2.executeUpdate("update Cart set quantity = " + newQuantity + " where userID = (select user_id from users where username = '" + usernameforclass + "') and productID = '" + productID + "';");
                } else {
                    Statement stmt3 = con.createStatement();
                    stmt3.executeUpdate("insert into Cart (userID, productID, quantity) values ((select user_id FROM users where username = '" + usernameforclass + "'), '" + productID + "', " + quantity + ");");
                }
            }

        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }
        return "redirect:/schedule";
    }

    @GetMapping("deleteitem")
    public String deleteItemFromCart(@RequestParam("productID") int productID) {
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();

            ResultSet userResultSet = stmt.executeQuery("select user_id from users where username = '" + usernameforclass + "';");
            if (userResultSet.next()) {
                int userID = userResultSet.getInt("user_id");
                stmt.executeUpdate("delete from Cart where userID = " + userID + " and productID = " + productID + ";");
            }
        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }
        return "redirect:/schedule";
    }

    @GetMapping("deletecustom")
    public String deleteFromCustomCart(@RequestParam("productID") int productID) {
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();

            ResultSet userResultSet = stmt.executeQuery("select user_id from users where username = '" + usernameforclass + "';");
            if (userResultSet.next()) {
                int userID = userResultSet.getInt("user_id");
                stmt.executeUpdate("delete from CustomCart where userID = " + userID + " and productID = " + productID + ";");
            }
        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }
        return "redirect:/custom-cart";
    }

    @GetMapping("addtocart")
    public static String addItemToCart(@RequestParam("productID") int productID, @RequestParam("quantity") int quantity) {
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();
            ResultSet userResultSet = stmt.executeQuery("select user_id from users where username = '" + usernameforclass + "';");
            if (userResultSet.next()) {
                int userID = userResultSet.getInt("user_id");
                ResultSet cartItemResultSet = stmt.executeQuery("select * from Cart where userID = " + userID + " and productID = " + productID + ";");
                if (cartItemResultSet.next()) {
                    int existingQuantity = cartItemResultSet.getInt("quantity");
                    quantity += existingQuantity;
                    stmt.executeUpdate("update Cart set quantity = " + quantity + " where userID = " + userID + " and productID = " + productID + ";");
                } else {
                    stmt.executeUpdate("insert into Cart (userID, productID, quantity) values (" + userID + ", " + productID + ", " + quantity + ");");
                }
            }
        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }
        return "redirect:/schedule";
    }

    @GetMapping("addtocustomcart")
    public static String addItemToCustomCart(@RequestParam("productID") int productID, @RequestParam("quantity") int quantity) {
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();
            ResultSet userResultSet = stmt.executeQuery("select user_id from users where username = '" + usernameforclass + "';");
            if (userResultSet.next()) {
                int userID = userResultSet.getInt("user_id");
                ResultSet cartItemResultSet = stmt.executeQuery("select * from CustomCart where userID = " + userID + " and productID = " + productID + ";");
                if (cartItemResultSet.next()) {
                    int existingQuantity = cartItemResultSet.getInt("quantity");
                    quantity += existingQuantity;
                    stmt.executeUpdate("update CustomCart set quantity = " + quantity + " where userID = " + userID + " and productID = " + productID + ";");
                } else {
                    stmt.executeUpdate("insert into CustomCart (userID, productID, quantity) values (" + userID + ", " + productID + ", " + quantity + ");");
                }
            }
        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }
        return "redirect:/custom-cart";
    }

    @GetMapping("/schedule")
    public String viewSchedule(Model model) {

        if(userlogcheck == 0) {
            return "redirect:/";
        }
        else {
            ArrayList<CartItem> cartItems = new ArrayList<>();
            try {
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
                Statement stmt = con.createStatement();
                ResultSet cartResult = stmt.executeQuery("SELECT p.name, c.quantity, p.price, c.productID FROM Cart c " +
                        "JOIN products p ON c.productID = p.id " +
                        "WHERE c.userID = " + AdminController.getUserID() + ";");

                while (cartResult.next()) {
                    int quantity = cartResult.getInt("quantity");
                    String productName = cartResult.getString("name");
                    float productPrice = cartResult.getFloat("price");
                    int productID = cartResult.getInt("productID");
                    float totalPrice = AdminController.getProductPrice(productID, quantity);

                    if (productID != 0) {
                        cartItems.add(new CartItem(productName, quantity, totalPrice, productID));
                    }
                }
            } catch (Exception e) {
                System.out.println("Exception:" + e);
            }

            model.addAttribute("cartItems", cartItems);
            model.addAttribute("total", AdminController.getCartPrice(usernameforclass));

            return "schedule";
        }
    }

    @GetMapping("updateCartItemQuantity")
    public String updateCartItemQuantity(@RequestParam MultiValueMap<String, String> params) {
        for (String key : params.keySet()) {
            if (key.matches(".+\\|quantity")) {
                String productIDString = key.substring(0, key.indexOf('|'));
                String quantityString = params.getFirst(key);
                int productID;
                int quantity;
                productID = Integer.parseInt(productIDString);
                quantity = Integer.parseInt(quantityString);

                try {
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
                    Statement stmt = con.createStatement();
                    if (quantity != 0) {
                        PreparedStatement pst = con.prepareStatement("UPDATE Cart SET quantity = ? WHERE productID = ? AND userID = ?;");
                        pst.setInt(1, quantity);
                        pst.setInt(2, productID);
                        pst.setInt(3, AdminController.getUserID());
                        pst.executeUpdate();
                    } else {
                        UserController.addItemToCart(productID, quantity);
                    }
                } catch (Exception e) {
                    System.out.println(e);
                }
            }
        }

        return "redirect:/schedule";
    }

    @GetMapping("/custom-cart")
    public String viewCustomCart(Model model) {
        ArrayList<CustomCartItem> customCartItems = new ArrayList<>();
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();
            ResultSet cartResult = stmt.executeQuery("SELECT p.name, c.quantity, p.price, c.productID FROM CustomCart c " +
                    "JOIN products p ON c.productID = p.id " +
                    "WHERE c.userID = " + AdminController.getUserID() + ";");

            double subTotal = 0;

            while (cartResult.next()) {
                int quantity = cartResult.getInt("quantity");
                String productName = cartResult.getString("name");
                float productPrice = cartResult.getFloat("price");
                int productID = cartResult.getInt("productID");
                float totalPrice = AdminController.getProductPrice(productID, quantity);

                if (productID != 0) {
                    customCartItems.add(new CustomCartItem(productName, quantity, totalPrice, productID));
                }
            }
        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }

        model.addAttribute("customCartItems", customCartItems);
        model.addAttribute("total", AdminController.getCustomCartPrice(usernameforclass));

        return "custom-cart";
    }

    @GetMapping("updateCustomCartItemQuantity")
    public String updateCustomCartItemQuantity(@RequestParam MultiValueMap<String, String> params) {
        for (String key : params.keySet()) {
            if (key.matches(".+\\|quantity")) {
                String productIDString = key.substring(0, key.indexOf('|'));
                String quantityString = params.getFirst(key);
                int productID;
                int quantity;
                productID = Integer.parseInt(productIDString);
                quantity = Integer.parseInt(quantityString);

                try {
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
                    Statement stmt = con.createStatement();
                    if (quantity != 0) {
                        PreparedStatement pst = con.prepareStatement("UPDATE CustomCart SET quantity = ? WHERE productID = ? AND userID = ?;");
                        pst.setInt(1, quantity);
                        pst.setInt(2, productID);
                        pst.setInt(3, AdminController.getUserID());
                        pst.executeUpdate();
                    } else {
                        UserController.addItemToCustomCart(productID, quantity);
                    }
                } catch (Exception e) {
                    System.out.println(e);
                }
            }
        }

        return "redirect:/custom-cart";
    }

}
