package com.epsts.EPSTS.controller;

import java.sql.*;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;


import com.epsts.EPSTS.Employee;
import com.epsts.EPSTS.ScheduleItem;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.scheduling.annotation.Scheduled;
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

    @GetMapping("/admin/users")
    public String infected(Model model) {
        if (adminlogcheck == 0) {
            return "redirect:/admin";
        }
        else {
            return "users";
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

    @EnableScheduling
    @Configuration
    public class SchedulingConfig {
    }

    @Scheduled(cron = "0 0 0 ? * SUN") // Runs every Sunday at midnight
    private void sendWeeklyScheduleEmails() {
        System.out.println("Sending weekly schedule emails now");
        List<Employee> employees = getEmployeesFromWorksAt();
        for (Employee employee : employees) {
            String recipient = employee.getEmail();
            String subject = generateWeeklyScheduleEmailSubject(employee);
            String body = generateWeeklyScheduleEmailBody(employee);
            UserController.sendEmail("epsts438@gmail.com", "epsts438@gmail.com", subject, body);
            UserController.insertIntoLogTable(recipient, "epsts438@gmail.com", subject, body);
        }
    }

    private String generateWeeklyScheduleEmailBody(Employee employee) {
        StringBuilder bodyBuilder = new StringBuilder();
        bodyBuilder.append("Dear ").append(employee.getFirstName()).append(",\n\n");
        bodyBuilder.append("Here is your schedule for the upcoming week at ").append(employee.getFacilityName()).append(":\n\n");

        List<ScheduleItem> scheduleItems = fetchScheduleForComingWeek(employee);

        if (!scheduleItems.isEmpty()) {
            SimpleDateFormat dayFormat = new SimpleDateFormat("EEEE");
            SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
            Calendar calendar = Calendar.getInstance();

            for (int dayOfWeek = Calendar.SUNDAY; dayOfWeek <= Calendar.SATURDAY; dayOfWeek++) {
                calendar.set(Calendar.DAY_OF_WEEK, dayOfWeek);
                String dayName = dayFormat.format(calendar.getTime());

                boolean hasAssignments = false;
                StringBuilder assignmentsBuilder = new StringBuilder();

                for (ScheduleItem scheduleItem : scheduleItems) {
                    if (scheduleItem.getDayOfWeek() == dayOfWeek) {
                        hasAssignments = true;
                        assignmentsBuilder.append(timeFormat.format(scheduleItem.getStartTime())).append(" - ").append(timeFormat.format(scheduleItem.getEndTime())).append("\n");
                    }
                }

                if (!hasAssignments) {
                    assignmentsBuilder.append("No Assignments\n");
                }

                bodyBuilder.append(dayName).append(":\n").append(assignmentsBuilder.toString()).append("\n");
            }
        } else {
            bodyBuilder.append("No assignments scheduled for the coming week.\n");
        }


        bodyBuilder.append("\nBest regards,\nThe EPSTS Team");

        return bodyBuilder.toString();
    }

    private List<ScheduleItem> fetchScheduleForComingWeek(Employee employee) {
        List<ScheduleItem> scheduleItems = new ArrayList<>();

        Date startDate = getStartDateOfComingWeek();
        Date endDate = getEndDateOfComingWeek();

        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();

            String query = "SELECT * FROM ScheduledAt " +
                    "WHERE medicareNumb = " + employee.getMedicareNumb() + " AND " +
                    "date BETWEEN '" + new SimpleDateFormat("yyyy-MM-dd").format(startDate) + "' AND '" + new SimpleDateFormat("yyyy-MM-dd").format(endDate) + "'";
            ResultSet resultSet = stmt.executeQuery(query);

            while (resultSet.next()) {
                Date date = resultSet.getDate("date");
                Time startTime = resultSet.getTime("startTime");
                Time endTime = resultSet.getTime("endTime");

                ScheduleItem scheduleItem = new ScheduleItem(employee.getFacilityName() ,date, startTime, endTime, UserController.getDayOfWeekFromDate(date));
                scheduleItems.add(scheduleItem);
            }

            resultSet.close();
            stmt.close();
            con.close();
        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }

        return scheduleItems;
    }

    private String generateWeeklyScheduleEmailSubject(Employee employee) {
        String subject = employee.getFacilityName() + " Schedule for " +
                getStartDateOfComingWeek() + " to " + getEndDateOfComingWeek();
        return subject;
    }

    public Date getEndDateOfComingWeek() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY); // Set to the first day of the week
        calendar.add(Calendar.WEEK_OF_YEAR, 2); // Move to the week after the coming week
        calendar.add(Calendar.DAY_OF_YEAR, -1); // Move to the last day of the coming week
        return calendar.getTime();
    }

    public Date getStartDateOfComingWeek() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY); // Set to the first day of the week
        calendar.add(Calendar.WEEK_OF_YEAR, 1); // Move to the next week
        return calendar.getTime();
    }

    private List<Employee> getEmployeesFromWorksAt() {
        List<Employee> employees = new ArrayList<>();

        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();

            String query = "SELECT u.*, f.name AS facilityName " +
                    "FROM WorksAt wa " +
                    "JOIN User u ON wa.medicareNumb = u.medicareNumb " +
                    "JOIN Facility f ON wa.facilityID = f.facilityId";
            ResultSet resultSet = stmt.executeQuery(query);

            while (resultSet.next()) {
                // Create Employee object and populate data
                Employee employee = new Employee(
                        resultSet.getInt("medicareNumb"),
                        resultSet.getString("firstName"),
                        resultSet.getString("lastName"),
                        resultSet.getString("email"),
                        resultSet.getString("facilityName")
                );
                employees.add(employee);
            }

            resultSet.close();
        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }

        return employees;
    }

}
