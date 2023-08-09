package com.epsts.EPSTS;

public class FacilityItem {
    private int facilityID;
    private String name;
    private String ministryName;
    private String province;
    private String address;
    private String city;
    private int capacity;
    private String postalCode;
    private String webAddress;
    private String type;
    private String email;

    public FacilityItem(int facilityID, String name, String ministryName, String province, String address, String city, int capacity, String postalCode, String webAddress, String type, String email) {
        this.facilityID = facilityID;
        this.name = name;
        this.ministryName = ministryName;
        this.province = province;
        this.address = address;
        this.city = city;
        this.capacity = capacity;
        this.postalCode = postalCode;
        this.webAddress = webAddress;
        this.type = type;
        this.email = email;
    }

    public int getFacilityID() {
        return facilityID;
    }

    public void setFacilityID(int facilityID) {
        this.facilityID = facilityID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMinistryName() {
        return ministryName;
    }

    public void setMinistryName(String ministryName) {
        this.ministryName = ministryName;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public String getWebAddress() {
        return webAddress;
    }

    public void setWebAddress(String webAddress) {
        this.webAddress = webAddress;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}

