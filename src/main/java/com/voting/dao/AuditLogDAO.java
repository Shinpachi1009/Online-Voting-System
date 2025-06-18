package com.voting.dao;

import com.voting.model.AuditLog;
import java.sql.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

public class AuditLogDAO {
    private Connection connection;
    
    public AuditLogDAO(Connection connection) {
        this.connection = connection;
    }
    
    // Log an action
    public void logAction(AuditLog auditLog) throws SQLException {
        String sql = "INSERT INTO audit_log (user_id, action_type, resource_type, resource_id, ip_address, details) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            if (auditLog.getUserId() != null) {
                stmt.setInt(1, auditLog.getUserId());
            } else {
                stmt.setNull(1, Types.INTEGER);
            }
            
            stmt.setString(2, auditLog.getActionType());
            
            if (auditLog.getResourceType() != null) {
                stmt.setString(3, auditLog.getResourceType());
            } else {
                stmt.setNull(3, Types.VARCHAR);
            }
            
            if (auditLog.getResourceId() != null) {
                stmt.setInt(4, auditLog.getResourceId());
            } else {
                stmt.setNull(4, Types.INTEGER);
            }
            
            stmt.setString(5, auditLog.getIpAddress());
            stmt.setString(6, auditLog.getDetails());
            
            stmt.executeUpdate();
        }
    }
    
    // Get audit logs for a user
    public List<AuditLog> getAuditLogsByUser(int userId) throws SQLException {
        List<AuditLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM audit_log WHERE user_id = ? ORDER BY timestamp DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    logs.add(mapAuditLogFromResultSet(rs));
                }
            }
        }
        return logs;
    }
    
    // Get all audit logs
    public List<AuditLog> getAllAuditLogs() throws SQLException {
        List<AuditLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM audit_log ORDER BY timestamp DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    logs.add(mapAuditLogFromResultSet(rs));
                }
            }
        }
        return logs;
    }
    
    // Helper method to map ResultSet to AuditLog object
    private AuditLog mapAuditLogFromResultSet(ResultSet rs) throws SQLException {
        AuditLog log = new AuditLog();
        log.setLogId(rs.getInt("log_id"));
        
        int userId = rs.getInt("user_id");
        log.setUserId(rs.wasNull() ? null : userId);
        
        log.setActionType(rs.getString("action_type"));
        log.setResourceType(rs.getString("resource_type"));
        
        int resourceId = rs.getInt("resource_id");
        log.setResourceId(rs.wasNull() ? null : resourceId);
        
        log.setIpAddress(rs.getString("ip_address"));
        log.setTimestamp(rs.getTimestamp("timestamp"));
        log.setDetails(rs.getString("details"));
        
        return log;
    }
}