package com.voting.model;

import java.sql.Timestamp;

public class PasswordResetToken {
    private int tokenId;
    private int userId;
    private String token;
    private Timestamp expiryTime;
    private boolean used;
    
    // Getters and Setters
    public int getTokenId() { return tokenId; }
    public void setTokenId(int tokenId) { this.tokenId = tokenId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }
    
    public Timestamp getExpiryTime() { return expiryTime; }
    public void setExpiryTime(Timestamp expiryTime) { this.expiryTime = expiryTime; }
    
    public boolean isUsed() { return used; }
    public void setUsed(boolean used) { this.used = used; }
}