package com.epsts.EPSTS;

public class UserItem {
    private int userID;
    private String firstName;
    private String lastName;
    private String username;
    private String type;
    private String workLocation;
    private String address;
    private String email;
    private int medicareNumb;

    public UserItem(int userID, String firstName, String lastName, String username, String type, String workLocation, String address, String email, int medicareNumb) {
        this.userID = userID;
        this.firstName = firstName;
        this.lastName = lastName;
        this.username = username;
        this.type = type;
        this.workLocation = workLocation;
        this.address = address;
        this.email = email;
        this.medicareNumb = medicareNumb;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getWorkLocation() {
        return workLocation;
    }

    public void setWorkLocation(String workLocation) {
        this.workLocation = workLocation;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getMedicareNumb() {
        return medicareNumb;
    }

    public void setMedicareNumb(int medicareNumb) {
        this.medicareNumb = medicareNumb;
    }
}