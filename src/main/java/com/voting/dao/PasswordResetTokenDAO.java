package com.voting.dao;

import com.voting.model.PasswordResetToken;
import java.sql.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.UUID;

public class PasswordResetTokenDAO {
    private Connection connection;
    
    public PasswordResetTokenDAO(Connection connection) {
        this.connection = connection;
    }
    
    // Create a new password reset token
    public String createToken(int userId) throws SQLException {
        // Delete any existing tokens for this user
        String deleteSql = "DELETE FROM password_reset_tokens WHERE user_id = ?";
        try (PreparedStatement deleteStmt = connection.prepareStatement(deleteSql)) {
            deleteStmt.setInt(1, userId);
            deleteStmt.executeUpdate();
        }
        
        // Create new token
        String token = UUID.randomUUID().toString();
        Timestamp expiryTime = new Timestamp(System.currentTimeMillis() + (24 * 60 * 60 * 1000)); // 24 hours
        
        String insertSql = "INSERT INTO password_reset_tokens (user_id, token, expiry_time) VALUES (?, ?, ?)";
        try (PreparedStatement insertStmt = connection.prepareStatement(insertSql)) {
            insertStmt.setInt(1, userId);
            insertStmt.setString(2, token);
            insertStmt.setTimestamp(3, expiryTime);
            
            insertStmt.executeUpdate();
        }
        
        return token;
    }
    
    // Validate token
    public PasswordResetToken validateToken(String token) throws SQLException {
        String sql = "SELECT * FROM password_reset_tokens WHERE token = ? AND used = false AND expiry_time > CURRENT_TIMESTAMP";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, token);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    PasswordResetToken resetToken = new PasswordResetToken();
                    resetToken.setTokenId(rs.getInt("token_id"));
                    resetToken.setUserId(rs.getInt("user_id"));
                    resetToken.setToken(rs.getString("token"));
                    resetToken.setExpiryTime(rs.getTimestamp("expiry_time"));
                    resetToken.setUsed(rs.getBoolean("used"));
                    return resetToken;
                }
            }
        }
        return null;
    }
    
    // Mark token as used
    public boolean markTokenAsUsed(int tokenId) throws SQLException {
        String sql = "UPDATE password_reset_tokens SET used = true WHERE token_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, tokenId);
            
            return stmt.executeUpdate() > 0;
        }
    }
}