package com.epsts.EPSTS;

public class Employee {
    private int medicareNumb;
    private String firstName;
    private String lastName;
    private String email;
    private String facilityName;

    public Employee (int medicareNumb, String firstName, String lastName, String email, String facilityName) {
        this.medicareNumb = medicareNumb;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.facilityName = facilityName;
    }
    public int getMedicareNumb() {
        return medicareNumb;
    }
    public String getFirstName() {
        return firstName;
    }
    public String getLastName() {
        return lastName;
    }
    public String getFacilityName() {
        return facilityName;
    }
    public String getEmail() {
        return email;
    }

    public void setMedicareNumb(int medicareNumb) {
        this.medicareNumb = medicareNumb;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setFacilityName(String facilityName) {
        this.facilityName = facilityName;
    }
}
