package com.epsts.EPSTS;
import java.sql.Time;
import java.sql.Date;

public class ScheduleItem {

    private String facility;
    private Date date;
    private Time startTime;
    private Time endTime;

    public ScheduleItem(String facility, Date date, Time startTime, Time endTime) {
        this.facility = facility;
        this.date = date;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    public String getFacility() {
        return facility;
    }

    public Date getDate() {
        return date;
    }

    public Time getEndTime() {
        return endTime;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setFacility(String facility) {
        this.facility = facility;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }
}