package com.epsts.EPSTS;
import java.sql.Time;
import java.util.Date;

public class ScheduleItem {
    private String facility;
    private Date date;
    private Time startTime;
    private Time endTime;
    private int dayOfWeek;

    public ScheduleItem(String facility, Date date, Time startTime, Time endTime, int dayOfWeek) {
        this.facility = facility;
        this.date = date;
        this.startTime = startTime;
        this.endTime = endTime;
        this.dayOfWeek = dayOfWeek;
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

    public int getDayOfWeek() {
        return dayOfWeek;
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

    public void setDayOfWeek(int dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }
}