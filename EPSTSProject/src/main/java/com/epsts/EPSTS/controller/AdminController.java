package com.epsts.EPSTS.controller;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.sql.*;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;


import com.epsts.EPSTS.*;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

    @GetMapping("/admin/ministries")
    public String ministries(Model model) {
        if (adminlogcheck == 0) {
            return "redirect:/admin";
        } else {
            ArrayList<MinistryItem> ministryItems = new ArrayList<>();
            try {
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
                Statement stmt = con.createStatement();

                String query = "SELECT * FROM Ministry";
                ResultSet scheduleResult = stmt.executeQuery(query);

                while (scheduleResult.next()) {
                    String name = scheduleResult.getString("name");
                    int headOfficeID = scheduleResult.getInt("facilityId");
                    String headOfficeName = getFacilityName(headOfficeID);
                    Facility headOfficeFacility = new Facility(headOfficeName, headOfficeID);
                    ArrayList<Facility> facilities = getAllFacilitiesForMinistry(name);
                    MinistryItem ministryItem = new MinistryItem(name, headOfficeFacility, facilities);
                    ministryItems.add(ministryItem);
                }
                model.addAttribute("ministryItems", ministryItems);
            }
            catch (Exception e) {

            }
            return "ministries";
        }
    }

    @GetMapping("/admin/facilities")
    public String facilities(Model model) {
        if (adminlogcheck == 0) {
            return "redirect:/admin";
        } else {
            ArrayList<FacilityItem> facilityItems = new ArrayList<>();
            try {
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
                Statement stmt = con.createStatement();

                String query = "SELECT * FROM Facility";
                ResultSet scheduleResult = stmt.executeQuery(query);

                while (scheduleResult.next()) {
                    int facilityID = scheduleResult.getInt("facilityId");
                    String name = scheduleResult.getString("name");
                    String ministryName = getMinistryName(facilityID);
                    String province = scheduleResult.getString("province");
                    String address = scheduleResult.getString("address");
                    String city = scheduleResult.getString("city");
                    int capacity = scheduleResult.getInt("capacity");
                    String postalCode = scheduleResult.getString("postalCode");
                    String webAddress = scheduleResult.getString("webAddress");
                    String type = scheduleResult.getString("type");
                    String email = scheduleResult.getString("email");

                    FacilityItem facilityItem = new FacilityItem(facilityID, name, ministryName, province, address, city, capacity, postalCode, webAddress, type, email);
                    facilityItems.add(facilityItem);
                }
                model.addAttribute("facilityItems", facilityItems);
            }
            catch (Exception e) {

            }
            return "facilities";
        }
    }

    @GetMapping("/admin/users")
    public String users(Model model) {
        if (adminlogcheck == 0) {
            return "redirect:/admin";
        }
        else {
            ArrayList<UserItem> userItems = new ArrayList<>();
            try {
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
                Statement stmt = con.createStatement();

                String query = "SELECT * FROM User";
                ResultSet scheduleResult = stmt.executeQuery(query);

                while (scheduleResult.next()) {
                    int userID = scheduleResult.getInt("userID");
                    String firstName = scheduleResult.getString("firstName");
                    String lastName = scheduleResult.getString("lastName");
                    String username = scheduleResult.getString("username");
                    String type = scheduleResult.getString("type");
                    String workLocation = scheduleResult.getString("workLocation");
                    String address = scheduleResult.getString("address");
                    String email = scheduleResult.getString("email");
                    int medicareNumb = scheduleResult.getInt("medicareNumb");

                    UserItem userItem = new UserItem(userID, firstName, lastName, username, type, workLocation, address, email, medicareNumb);
                    userItems.add(userItem);
                }
                // Add the schedule items to the model
                model.addAttribute("userItems", userItems);
            }
            catch (Exception e) {

            }
            return "users";
        }
    }

    @GetMapping("/infected")
    public String infected(RedirectAttributes redirectAttributes, @RequestParam ("infected") int medicareNumb) {
        String type = "COVID-19";
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();

                if ("Employee".equals(UserController.getUserType(medicareNumb))) {
                    String query = "INSERT INTO Infection (medicareNumbEmployee, medicareNumbStudent, date, type) " +
                            "VALUES (" + medicareNumb + ", " + null + ", CURDATE(), '" + type + "')";
                    stmt.executeUpdate(query);
                    UserController.updateScheduledAtTableForEmployee(medicareNumb);
                } else if ("Student".equals(UserController.getUserType(medicareNumb))) {
                    String query = "INSERT INTO Infection (medicareNumbEmployee, medicareNumbStudent, date, type) " +
                            "VALUES (" + null + ", " + medicareNumb + ", CURDATE(), '" + type + "')";
                    stmt.executeUpdate(query);
                }
        }
        catch (Exception e) {

        }

        // Send email
        String recipient = "epsts438@gmail.com";
        String sender = "epsts438@gmail.com";
        String subject = "Warning";
        String body = UserController.generateEmailBody(medicareNumb, UserController.getUserType(medicareNumb));
        UserController.sendEmail(recipient, sender, subject, body);

        // Insert into Log table
        String emailBody = body.substring(0, Math.min(body.length(), 80));
        UserController.insertIntoLogTable(recipient, sender, subject, emailBody);

        redirectAttributes.addFlashAttribute("infectedMessage", "Person with medicare number: " + medicareNumb + " has been declared infected with COVID-19.");

        return "redirect:/admin/users";
    }

    @GetMapping("/vaccinated")
    public String vaccinate(RedirectAttributes redirectAttributes, @RequestParam ("vaccinated") int medicareNumb) {
        String type = "Moderna";
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();
            if ("Employee".equals(UserController.getUserType(medicareNumb))) {
                String query = "INSERT INTO Vaccine (medicareNumbEmployee, date, type)" +
                        "VALUES (" + medicareNumb + ", " + " CURDATE(), '" + type + "')";
                stmt.executeUpdate(query);
            } else if ("Student".equals(UserController.getUserType(medicareNumb))) {
                String query = "INSERT INTO Vaccine (medicareNumbStudent, date, type)" +
                        "VALUES (" + medicareNumb + ", " + "CURDATE(), '" + type + "')";
                stmt.executeUpdate(query);
            }
        }
        catch (Exception e) {

        }

        redirectAttributes.addFlashAttribute("vaccinatedMessage", "Person with medicare number: " + medicareNumb + " has been declared vaccinated.");

        return "redirect:/admin/users";
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

    private String getFacilityName(int facilityID) {
        String facilityName = null;
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();

                String query = "SELECT f.name FROM Facility f " +
                        "WHERE f.facilityId = '" + facilityID + "'";
                ResultSet resultSet = stmt.executeQuery(query);
                if (resultSet.next()) {
                    facilityName = resultSet.getString("name");
                }
                resultSet.close();
        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }
        return facilityName;
    }

    private String getMinistryName(int facilityID) {
        String ministryName = null;
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();

            String query = "SELECT h.ministryName FROM HasFacilities h " +
                    "WHERE h.facilityId = '" + facilityID + "'";
            ResultSet resultSet = stmt.executeQuery(query);
            if (resultSet.next()) {
                ministryName = resultSet.getString("ministryName");
            }
            resultSet.close();
        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }
        return ministryName;
    }

    private ArrayList<Facility> getAllFacilitiesForMinistry(String ministryName) {
        ArrayList<Facility> facilities = new ArrayList<>();
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();

            String query = "SELECT h.facilityId FROM HasFacilities h " +
                    "WHERE h.ministryName = '" + ministryName + "'";
            ResultSet resultSet = stmt.executeQuery(query);
            while (resultSet.next()) {
                int facilityID = resultSet.getInt("facilityId");
                if (facilityID == getHeadOfficeID(ministryName)) {
                    continue;
                }
                else {
                    String facilityName = getFacilityName(facilityID);
                    Facility facility = new Facility(facilityName, facilityID);
                    facilities.add(facility);
                }
            }
            resultSet.close();
        } catch (Exception e) {
            System.out.println("Exception:" + e);
        }
        return facilities;
    }

    private int getHeadOfficeID(String ministryName) {
        int headOfficeID = 0;
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EPSTS", "root", "12345678");
            Statement stmt = con.createStatement();

            String query = "SELECT h.facilityId FROM HeadOffice h " +
                    "WHERE h.ministryName = '" + ministryName + "'";
            ResultSet resultSet = stmt.executeQuery(query);
            if (resultSet.next()) {
                headOfficeID = resultSet.getInt("facilityId");
            }
        }
        catch (Exception e) {
        System.out.println("Exception:" + e);
        }
        return headOfficeID;
    }
}
