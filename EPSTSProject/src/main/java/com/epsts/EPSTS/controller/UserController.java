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
    public String userCheck(@RequestParam("username") String username, @RequestParam("password") String password, Model model) {
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();
            ResultSet rst = stmt.executeQuery("select * from User where username = '" + username + "' and password = '" + password + "' ;");
            if (rst.next()) {
                usernameforclass = rst.getString(4);
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
            return "userHome";
        }
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
                ResultSet cartResult = stmt.executeQuery("");
            } catch (Exception e) {
                System.out.println("Exception:" + e);
            }

            return "schedule";
        }
    }

    @GetMapping("profile")
    public String profile(Model model) {
        if(userlogcheck == 0) {
            return "redirect:/";
        }
        else {
            int displayUserID;
            String displayFirstName, displayLastName, displayUsername, displayPassword, displayType, displayWorkLocation, displayAddress, displayEmail;
            try {
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
                Statement stmt = con.createStatement();
                ResultSet rst = stmt.executeQuery("select * from User where username = '" + usernameforclass + "';");
                if (rst.next()) {
                    displayUserID = rst.getInt(1);
                    displayFirstName = rst.getString(2);
                    displayLastName = rst.getString(3);
                    displayUsername = rst.getString(4);
                    displayPassword = rst.getString(5);
                    displayType = rst.getString(6);
                    displayWorkLocation = rst.getString(7);
                    displayAddress = rst.getString(8);
                    displayEmail = rst.getString(9);

                    model.addAttribute("userID", displayUserID);
                    model.addAttribute("firstName", displayFirstName);
                    model.addAttribute("lastName", displayLastName);
                    model.addAttribute("username", displayUsername);
                    model.addAttribute("password", displayPassword);
                    model.addAttribute("type", displayType);
                    model.addAttribute("workLocation", displayWorkLocation);
                    model.addAttribute("address", displayAddress);
                    model.addAttribute("email", displayEmail);
                }
            } catch (Exception e) {
                System.out.println("Exception:" + e);
            }
            return "profile";
        }
    }

    @RequestMapping(value = "updateUser", method = RequestMethod.POST)
    public String updateUserProfile(@RequestParam("username") String username, @RequestParam("email") String email, @RequestParam("password") String password, @RequestParam("address") String address) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            PreparedStatement pst = con.prepareStatement("update User set username= ?,email = ?,password= ?, address= ? where userID = '" + AdminController.getUserID() + "';");
            pst.setString(1, username);
            pst.setString(2, email);
            pst.setString(3, password);
            pst.setString(4, address);
            int i = pst.executeUpdate();
            usernameforclass = username;
        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }
        return "redirect:/home";
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

        sendEmail(email, "epsts438@gmail.com", "Your Contact Request", userMessage);

        // Code to send the second email to the admin email
        String adminMessage = "A new contact request has been submitted:\n\n" +
                "Name: " + name + "\n" +
                "Email: " + email + "\n" +
                "Subject: " + subject + "\n" +
                "Message: " + message + "\n" +
                "Inquiry Type: " + inquiryType + "\n";

        sendEmail("epsts438@gmail.com", email, "New Contact Request", adminMessage);

        redirectAttributes.addFlashAttribute("successMessage", "Your contact request has been submitted successfully!");

        return "redirect:/contact";
    }

    // Helper method to send emails using JavaMail API
    private void sendEmail(String recipient, String sender, String subject, String body) {
        // SMTP server configuration
        String host = "smtp.gmail.com";
        String port = "587";
        String username = "epsts438@gmail.com";
        String password = "pltftmnfcgqrptxu";


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
}
