package com.voting.model;

public class Result {
    private int candidateId;
    private String candidateName;
    private String candidateBio;
    private int voteCount;
    private double percentage;
    
    // Getters and Setters
    public int getCandidateId() { return candidateId; }
    public void setCandidateId(int candidateId) { this.candidateId = candidateId; }
    
    public String getCandidateName() { return candidateName; }
    public void setCandidateName(String candidateName) { this.candidateName = candidateName; }
    
    public String getCandidateBio() { return candidateBio; }
    public void setCandidateBio(String candidateBio) { this.candidateBio = candidateBio; }
    
    public int getVoteCount() { return voteCount; }
    public void setVoteCount(int voteCount) { this.voteCount = voteCount; }
    
    public double getPercentage() { return percentage; }
    public void setPercentage(double percentage) { this.percentage = percentage; }
}