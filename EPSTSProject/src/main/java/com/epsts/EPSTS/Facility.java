package com.epsts.EPSTS;

public class Facility {
    private String facilityName;
    private int facilityID;

    public Facility(String facilityName, int facilityID) {
        this.facilityName = facilityName;
        this.facilityID = facilityID;
    }

    public String getFacilityName() {
        return facilityName;
    }

    public void setFacilityName(String facilityName) {
        this.facilityName = facilityName;
    }

    public int getFacilityID() {
        return facilityID;
    }

    public void setFacilityID(int facilityID) {
        this.facilityID = facilityID;
    }
}
