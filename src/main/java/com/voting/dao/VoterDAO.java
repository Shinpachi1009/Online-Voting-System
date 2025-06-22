package com.voting.dao;

import com.voting.model.Voter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VoterDAO {
    private Connection connection;
    
    public VoterDAO(Connection connection) {
        this.connection = connection;
    }
    
    public boolean registerVoter(Voter voter) throws SQLException {
        String sql = "INSERT INTO voters (user_id, voter_id_number, date_of_birth, address, district, document_path) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, voter.getUserId());
            stmt.setString(2, voter.getVoterIdNumber());
            stmt.setDate(3, voter.getDateOfBirth());
            stmt.setString(4, voter.getAddress());
            stmt.setString(5, voter.getDistrict());
            stmt.setString(6, voter.getDocumentPath());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public Voter getVoterByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM voters WHERE user_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapVoterFromResultSet(rs);
                }
            }
        }
        return null;
    }
    
    public List<Voter> getPendingRegistrations() throws SQLException {
        List<Voter> voters = new ArrayList<>();
        String sql = "SELECT v.*, u.username FROM voters v JOIN users u ON v.user_id = u.user_id " +
                     "WHERE v.status = 'PENDING' ORDER BY v.registration_date";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                voters.add(mapVoterFromResultSet(rs));
            }
        }
        return voters;
    }
    
    public boolean updateVoterStatus(int voterId, String status, int approvedBy, String notes) throws SQLException {
        connection.setAutoCommit(false);
        try {
            // Get current status
            String currentStatus = getVoterStatus(voterId);
            
            // Update voter status
            String updateSql = "UPDATE voters SET status = ?, approved_by = ?, approval_date = CURRENT_TIMESTAMP " +
                              "WHERE voter_id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(updateSql)) {
                stmt.setString(1, status);
                stmt.setInt(2, approvedBy);
                stmt.setInt(3, voterId);
                
                int affected = stmt.executeUpdate();
                if (affected == 0) {
                    return false;
                }
            }
            
            // Add to audit log
            String auditSql = "INSERT INTO voter_audit (voter_id, changed_by, previous_status, new_status, notes) " +
                             "VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = connection.prepareStatement(auditSql)) {
                stmt.setInt(1, voterId);
                stmt.setInt(2, approvedBy);
                stmt.setString(3, currentStatus);
                stmt.setString(4, status);
                stmt.setString(5, notes);
                stmt.executeUpdate();
            }
            
            connection.commit();
            return true;
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }
    
    private String getVoterStatus(int voterId) throws SQLException {
        String sql = "SELECT status FROM voters WHERE voter_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, voterId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("status");
                }
            }
        }
        return null;
    }
    
    private Voter mapVoterFromResultSet(ResultSet rs) throws SQLException {
        Voter voter = new Voter();
        voter.setVoterId(rs.getInt("voter_id"));
        voter.setUserId(rs.getInt("user_id"));
        voter.setVoterIdNumber(rs.getString("voter_id_number"));
        voter.setDateOfBirth(rs.getDate("date_of_birth"));
        voter.setAddress(rs.getString("address"));
        voter.setDistrict(rs.getString("district"));
        voter.setRegistrationDate(rs.getTimestamp("registration_date"));
        voter.setStatus(rs.getString("status"));
        voter.setApprovedBy(rs.getInt("approved_by"));
        voter.setApprovalDate(rs.getTimestamp("approval_date"));
        voter.setDocumentPath(rs.getString("document_path"));
        return voter;
    }
}