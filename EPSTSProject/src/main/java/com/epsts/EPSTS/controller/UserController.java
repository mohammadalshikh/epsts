package com.epsts.EPSTS.controller;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Calendar;
import java.text.SimpleDateFormat;

import com.epsts.EPSTS.ScheduleItem;
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
    public String schedule(Model model) {

        if(userlogcheck == 0) {
            return "redirect:/";
        }
        else {
            ArrayList<ScheduleItem> scheduleItems = new ArrayList<>();
            try {
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
                Statement stmt = con.createStatement();

                String query = "SELECT sa.*, f.name " +
                        "FROM ScheduledAt sa " +
                        "JOIN User u ON sa.medicareNumb = u.medicareNumb " +
                        "JOIN Facility f ON sa.facilityID = f.facilityID " +
                        "WHERE u.username = '" + usernameforclass + "'";
                ResultSet scheduleResult = stmt.executeQuery(query);

                while (scheduleResult.next()) {
                    String name = scheduleResult.getString("name");
                    Date date = scheduleResult.getDate("date");
                    Time startTime = scheduleResult.getTime("startTime");
                    Time endTime = scheduleResult.getTime("endTime");
                    int dayOfWeek = getDayOfWeekFromDate(date);

                    ScheduleItem scheduleItem = new ScheduleItem(name, date, startTime, endTime, dayOfWeek);
                    // Add schedule item to the list
                    scheduleItems.add(scheduleItem);
                }
                // Add the schedule items to the model
                model.addAttribute("scheduleItems", scheduleItems);

                scheduleResult.close();
            } catch (Exception e) {
                System.out.println("Exception:" + e);
            }

            return "schedule";
        }
    }

    @GetMapping("/report")
    public String report(RedirectAttributes redirectAttributes) {
        int medicareNumb = getMedicareNumber();
        String userType = getUserType(medicareNumb);

        // Insert into Infection table
        if ("Employee".equals(userType)) {
            insertIntoInfectionTable(String.valueOf(medicareNumb), null, "COVID-19");
            // Update ScheduledAt table for employees
            updateScheduledAtTableForEmployee(medicareNumb);
        } else if ("Student".equals(userType)) {
            insertIntoInfectionTable(null, String.valueOf(medicareNumb), "COVID-19");
        }

        // Send email
        String recipient = "epsts438@gmail.com";
        String sender = "epsts438@gmail.com";
        String subject = "Warning";
        String body = generateEmailBody(medicareNumb, userType);
        sendEmail(recipient, sender, subject, body);

        // Insert into Log table
        String emailBody = body.substring(0, Math.min(body.length(), 80));
        insertIntoLogTable(recipient, sender, subject, emailBody);

        redirectAttributes.addFlashAttribute("reportMessage",
                "Thank you for reporting symptoms, we hope you feel better soon. All the assignments scheduled for you in the next 14 days have been canceled.");

        return "redirect:/schedule";
    }

    // Method to generate email body
    static String generateEmailBody(int medicareNumb, String userType) {
        String facilityName = getFacilityName(medicareNumb);
        String message = "";

        if ("Employee".equals(userType)) {
            message = "who works at " + facilityName + " has been infected with COVID-19 on ";
        } else if ("Student".equals(userType)) {
            message = "who studies at " + facilityName + " has been infected with COVID-19 on ";
        }

        String currentDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        return getFullName(medicareNumb) + " (Medicare Number: " + medicareNumb + ") " + message + currentDate + ".";
    }

    // Method to insert into Infection table
    private void insertIntoInfectionTable(String medicareNumbEmployee, String medicareNumbStudent, String type) {
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();
            if ("Employee".equals(getUserType(getMedicareNumber()))) {
                String query = "INSERT INTO Infection (medicareNumbEmployee, medicareNumbStudent, date, type) " +
                        "VALUES (" + Integer.parseInt(medicareNumbEmployee) + ", " + null + ", CURDATE(), '" + type + "')";
                stmt.executeUpdate(query);
            } else if ("Student".equals(getUserType(getMedicareNumber()))) {
                String query = "INSERT INTO Infection (medicareNumbEmployee, medicareNumbStudent, date, type) " +
                        "VALUES (" + null + ", " + Integer.parseInt(medicareNumbStudent) + ", CURDATE(), '" + type + "')";
                stmt.executeUpdate(query);
            }

            stmt.close();
            con.close();
        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }
    }

    static void insertIntoLogTable(String recipient, String sender, String subject, String body) {
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();

            String query = "INSERT INTO Log (date, sender, receiver, subject, body) " +
                    "VALUES (CURDATE(), '" + sender + "', '" + recipient + "', '" + subject + "', '" + body + "')";
            stmt.executeUpdate(query);

            stmt.close();
            con.close();
        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }
    }

    // Method to update ScheduledAt table for employees
    static void updateScheduledAtTableForEmployee(int medicareNumb) {
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();

            String query = "DELETE FROM ScheduledAt " +
                    "WHERE medicareNumb = " + medicareNumb + " AND " +
                    "date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 14 DAY)";
            stmt.executeUpdate(query);

            stmt.close();
            con.close();
        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }
    }


    private int getMedicareNumber() {
        int medicareNumber = 0;
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();

            String query = "SELECT medicareNumb FROM User WHERE username = '" + usernameforclass + "'";
            ResultSet resultSet = stmt.executeQuery(query);

            if (resultSet.next()) {
                medicareNumber = resultSet.getInt("medicareNumb");
            }

            resultSet.close();
        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }

        return medicareNumber;
    }

   static String getUserType(int medicareNumb) {
        String userType = null;
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();

            String query = "SELECT type FROM User WHERE medicareNumb = '" + medicareNumb + "'";
            ResultSet resultSet = stmt.executeQuery(query);

            if (resultSet.next()) {
                userType = resultSet.getString("type");
            }

            resultSet.close();
        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }

        return userType;
    }

    private static String getFacilityName(int medicareNumb) {
        String facilityName = null;
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();

            if(getUserType(medicareNumb).equalsIgnoreCase("Employee")) {
                String query = "SELECT f.name FROM Facility f " +
                        "JOIN WorksAt wa ON wa.facilityId = f.facilityId " +
                        "WHERE wa.medicareNumb = '" + medicareNumb + "'";
                ResultSet resultSet = stmt.executeQuery(query);
                if (resultSet.next()) {
                    facilityName = resultSet.getString("name");
                }
                resultSet.close();
            }
            else if (getUserType(medicareNumb).equalsIgnoreCase("Student")) {
                String query = "SELECT f.name FROM Facility f " +
                        "JOIN StudiesAt sa ON sa.facilityId = f.facilityId " +
                        "WHERE sa.medicareNumb = '" + medicareNumb + "'";
                ResultSet resultSet = stmt.executeQuery(query);
                if (resultSet.next()) {
                    facilityName = resultSet.getString("name");
                }
                resultSet.close();
            }

        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }

        return facilityName;
    }

    private static String getFullName(int medicareNumb) {
        String fullName = null;
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();

            String query = "SELECT CONCAT(firstName, ' ', lastName) AS fullName FROM User WHERE medicareNumb = '" + medicareNumb + "'";
            ResultSet resultSet = stmt.executeQuery(query);

            if (resultSet.next()) {
                fullName = resultSet.getString("fullName");
            }

            resultSet.close();
            stmt.close();
            con.close();
        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }

        return fullName;
    }

    static int getDayOfWeekFromDate(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        // Calendar.DAY_OF_WEEK returns values from 1 (Sunday) to 7 (Saturday)
        return calendar.get(Calendar.DAY_OF_WEEK);
    }

    @GetMapping("/profile")
    public String profile(Model model) {
        if(userlogcheck == 0) {
            return "redirect:/";
        }
        else {
            int displayUserID, displayMedicareNumb;
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
                    displayMedicareNumb = rst.getInt(10);

                    model.addAttribute("userID", displayUserID);
                    model.addAttribute("firstName", displayFirstName);
                    model.addAttribute("lastName", displayLastName);
                    model.addAttribute("username", displayUsername);
                    model.addAttribute("password", displayPassword);
                    model.addAttribute("type", displayType);
                    model.addAttribute("workLocation", displayWorkLocation);
                    model.addAttribute("address", displayAddress);
                    model.addAttribute("email", displayEmail);
                    model.addAttribute("medicareNumb", displayMedicareNumb);
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
        insertIntoLogTable(email, "epsts438@gmail.com", "Your Contact Request", userMessage);

        // Code to send the second email to the admin email
        String adminMessage = "A new contact request has been submitted:\n\n" +
                "Name: " + name + "\n" +
                "Email: " + email + "\n" +
                "Subject: " + subject + "\n" +
                "Message: " + message + "\n" +
                "Inquiry Type: " + inquiryType + "\n";

        sendEmail("epsts438@gmail.com", email, "New Contact Request", adminMessage);
        insertIntoLogTable("epsts438@gmail.com", email, "New Contact Request", adminMessage);

        redirectAttributes.addFlashAttribute("successMessage", "Your contact request has been submitted successfully!");

        return "redirect:/contact";
    }

    // Helper method to send emails using JavaMail API
    static void sendEmail(String recipient, String sender, String subject, String body) {
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

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
