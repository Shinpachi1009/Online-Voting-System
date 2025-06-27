package com.voting.dao;

import com.voting.model.Candidate;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CandidateDAO {
    private Connection connection;

    public CandidateDAO(Connection connection) {
        this.connection = connection;
    }

    public boolean createCandidate(Candidate candidate) throws SQLException {
        String sql = "INSERT INTO candidates (user_id, position, bio) VALUES (?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, candidate.getUserId());
            stmt.setString(2, candidate.getPosition());
            stmt.setString(3, candidate.getBio());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                return false;
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    candidate.setCandidateId(generatedKeys.getInt(1));
                }
            }
            return true;
        }
    }

    public List<Candidate> getCandidatesByPosition(String position) throws SQLException {
        List<Candidate> candidates = new ArrayList<>();
        String sql = "SELECT c.*, u.username, u.first_name || ' ' || u.last_name as full_name " +
                     "FROM candidates c JOIN users u ON c.user_id = u.user_id " +
                     "WHERE c.position = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, position);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Candidate candidate = new Candidate();
                    candidate.setCandidateId(rs.getInt("candidate_id"));
                    candidate.setUserId(rs.getInt("user_id"));
                    candidate.setPosition(rs.getString("position"));
                    candidate.setBio(rs.getString("bio"));
                    candidate.setCreatedAt(rs.getTimestamp("created_at"));
                    candidate.setUsername(rs.getString("username"));
                    candidate.setFullName(rs.getString("full_name"));
                    candidates.add(candidate);
                }
            }
        }
        return candidates;
    }

    public boolean isUserCandidate(int userId) throws SQLException {
        String sql = "SELECT 1 FROM candidates WHERE user_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }
    
    public List<Candidate> getAllCandidates() throws SQLException {
        List<Candidate> candidates = new ArrayList<>();
        String sql = "SELECT c.*, u.username, u.first_name || ' ' || u.last_name as full_name " +
                     "FROM candidates c JOIN users u ON c.user_id = u.user_id";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                candidates.add(mapCandidateFromResultSet(rs));
            }
        }
        return candidates;
    }

    private Candidate mapCandidateFromResultSet(ResultSet rs) throws SQLException {
        Candidate candidate = new Candidate();
        candidate.setCandidateId(rs.getInt("candidate_id"));
        candidate.setUserId(rs.getInt("user_id"));
        candidate.setPosition(rs.getString("position"));
        candidate.setBio(rs.getString("bio"));
        candidate.setCreatedAt(rs.getTimestamp("created_at"));
        candidate.setUsername(rs.getString("username"));
        candidate.setFullName(rs.getString("full_name"));
        return candidate;
    }
}