package com.epsts.EPSTS.controller;

import java.sql.*;
import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.Map;


import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class AdminController {
    int adminlogcheck = 0;
    public static String usernameforclass = "";

    public static void setUsername(String usernameforclass) {
        AdminController.usernameforclass = usernameforclass;
    }

    public static int getUserID() {
        int userID = 0;
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();
            ResultSet rst = stmt.executeQuery("select * from User where username = '" + usernameforclass + "';");
            if (rst.next()) {
                userID = rst.getInt(1);
            }
        } catch (Exception e) {

        }
        return userID;
    }

    @RequestMapping(value = "/logoutAdmin", method = RequestMethod.POST)
    public String returnIndex() {
        adminlogcheck = 0;
        usernameforclass = "";
        UserController.setUsername("");
        AdminController.setUsername("");
        return "redirect:/admin";
    }

    @GetMapping("/admin")
    public String adminLogin(Model model) {
        return "adminLogin";
    }


    @RequestMapping(value = "/admin", method = RequestMethod.POST)
    public String adminCheck(@RequestParam("username") String username, @RequestParam("password") String pass, Model model) {
        if (username.equalsIgnoreCase("admin") && pass.equalsIgnoreCase("123")) {
            adminlogcheck = 1;
            return "redirect:/admin/home";
        } else {
            model.addAttribute("message", "Invalid Username or Password");
            return "adminLogin";
        }
    }

    @GetMapping("/admin/home")
    public String adminHome(Model model) {
        if (adminlogcheck == 0)
            return "redirect:/admin";
        else
            return "adminHome";
    }

    @GetMapping("/admin/vaccinated")
    public String vaccinated() {
        if (adminlogcheck == 0) {
            return "redirect:/admin";
        }
        else {
            return "vaccinated";
        }
    }

    @GetMapping("/admin/infected")
    public String infected(Model model) {
        if (adminlogcheck == 0) {
            return "redirect:/admin";
        }
        else {
            return "infected";
        }
    }

    @GetMapping("/admin/all")
    public String getCustomerDetail() {
        if (adminlogcheck == 0) {
            return "redirect:/admin";
        }
        else {
            return "all";
        }
    }

    @ResponseBody
    @GetMapping("/checkUsernameAvailability")
    public Map<String, Boolean> checkUsernameAvailability(@RequestParam("username") String username) {
        Map<String, Boolean> response = new HashMap<>();
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            PreparedStatement pst = con.prepareStatement("SELECT COUNT(*) FROM User WHERE username = ?;");
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
            PreparedStatement pst = con.prepareStatement("SELECT COUNT(*) FROM User WHERE email = ?;");
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
}
