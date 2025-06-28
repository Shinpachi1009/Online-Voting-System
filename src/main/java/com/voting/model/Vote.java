package com.voting.model;

import java.sql.Timestamp;

public class Vote {
    private int voteId;
    private int electionId;
    private int positionId;
    private int candidateId;
    private int userId;
    private Timestamp votedAt;

    // Getters and Setters
    public int getVoteId() { return voteId; }
    public void setVoteId(int voteId) { this.voteId = voteId; }
    
    public int getElectionId() { return electionId; }
    public void setElectionId(int electionId) { this.electionId = electionId; }
    
    public int getPositionId() { return positionId; }
    public void setPositionId(int positionId) { this.positionId = positionId; }
    
    public int getCandidateId() { return candidateId; }
    public void setCandidateId(int candidateId) { this.candidateId = candidateId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public Timestamp getVotedAt() { return votedAt; }
    public void setVotedAt(Timestamp votedAt) { this.votedAt = votedAt; }
}