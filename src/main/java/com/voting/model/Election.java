package com.voting.model;

import java.sql.Timestamp;

public class Election {
    private int electionId;
    private String title;
    private String description;
    private Timestamp startDate;
    private Timestamp endDate;
    private String status;

    // Getters and Setters
    public int getElectionId() { return electionId; }
    public void setElectionId(int electionId) { this.electionId = electionId; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public Timestamp getStartDate() { return startDate; }
    public void setStartDate(Timestamp startDate) { this.startDate = startDate; }
    
    public Timestamp getEndDate() { return endDate; }
    public void setEndDate(Timestamp endDate) { this.endDate = endDate; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}