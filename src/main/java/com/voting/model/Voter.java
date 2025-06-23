package com.voting.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Voter {
    private int voterId;
    private int userId;
    private String voterIdNumber;
    private Date dateOfBirth;
    private String address;
    private String district;
    private Timestamp registrationDate;
    private String status;
    private Integer approvedBy;
    private Timestamp approvalDate;
    private String documentPath;
    
    // Getters and Setters
    public int getVoterId() { return voterId; }
    public void setVoterId(int voterId) { this.voterId = voterId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getVoterIdNumber() { return voterIdNumber; }
    public void setVoterIdNumber(String voterIdNumber) { this.voterIdNumber = voterIdNumber; }
    
    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    
    public Timestamp getRegistrationDate() { return registrationDate; }
    public void setRegistrationDate(Timestamp registrationDate) { this.registrationDate = registrationDate; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Integer getApprovedBy() { return approvedBy; }
    public void setApprovedBy(Integer approvedBy) { this.approvedBy = approvedBy; }
    
    public Timestamp getApprovalDate() { return approvalDate; }
    public void setApprovalDate(Timestamp approvalDate) { this.approvalDate = approvalDate; }
    
    public String getDocumentPath() { return documentPath; }
    public void setDocumentPath(String documentPath) { this.documentPath = documentPath; }
}