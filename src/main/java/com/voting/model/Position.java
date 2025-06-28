package com.voting.model;

public class Position {
    private int positionId;
    private int electionId;
    private String title;
    private String description;
    private int maxVotes;

    // Getters and Setters
    public int getPositionId() { return positionId; }
    public void setPositionId(int positionId) { this.positionId = positionId; }
    
    public int getElectionId() { return electionId; }
    public void setElectionId(int electionId) { this.electionId = electionId; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public int getMaxVotes() { return maxVotes; }
    public void setMaxVotes(int maxVotes) { this.maxVotes = maxVotes; }
}