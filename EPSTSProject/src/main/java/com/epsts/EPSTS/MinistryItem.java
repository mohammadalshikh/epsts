package com.epsts.EPSTS;

import java.util.ArrayList;

public class MinistryItem {

    private String name;
    private Facility headOfficeFacility;
    private ArrayList<Facility> facilities;

    public MinistryItem(String name, Facility headOfficeFacility, ArrayList<Facility> facilities) {
        this.name = name;
        this.headOfficeFacility = headOfficeFacility;
        this.facilities = facilities;
    }

    public ArrayList<Facility> getFacilities() {
        return facilities;
    }

    public void setFacilities(ArrayList<Facility> facilities) {
        this.facilities = facilities;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Facility getHeadOfficeFacility() {
        return headOfficeFacility;
    }

    public void setHeadOfficeFacility(Facility headOfficeFacility) {
        this.headOfficeFacility = headOfficeFacility;
    }
}
