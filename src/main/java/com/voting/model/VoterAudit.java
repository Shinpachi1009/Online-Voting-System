package com.voting.model;

import java.sql.Timestamp;

public class VoterAudit {
    private int auditId;
    private int voterId;
    private Integer changedBy;
    private Timestamp changeDate;
    private String previousStatus;
    private String newStatus;
    private String notes;
    
    // Getters and Setters
    public int getAuditId() { return auditId; }
    public void setAuditId(int auditId) { this.auditId = auditId; }
    
    public int getVoterId() { return voterId; }
    public void setVoterId(int voterId) { this.voterId = voterId; }
    
    public Integer getChangedBy() { return changedBy; }
    public void setChangedBy(Integer changedBy) { this.changedBy = changedBy; }
    
    public Timestamp getChangeDate() { return changeDate; }
    public void setChangeDate(Timestamp changeDate) { this.changeDate = changeDate; }
    
    public String getPreviousStatus() { return previousStatus; }
    public void setPreviousStatus(String previousStatus) { this.previousStatus = previousStatus; }
    
    public String getNewStatus() { return newStatus; }
    public void setNewStatus(String newStatus) { this.newStatus = newStatus; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}