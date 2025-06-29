package com.voting.dao;

import com.voting.model.Election;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ElectionDAO {
    private Connection connection;

    public ElectionDAO(Connection connection) {
        this.connection = connection;
    }
    
    public List<Election> getActiveElections() throws SQLException {
        return getElectionsByStatus("ACTIVE");
    }

    public List<Election> getElectionsByStatus(String status) throws SQLException {
        List<Election> elections = new ArrayList<>();
        String sql = "SELECT * FROM elections WHERE status = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    elections.add(mapElectionFromResultSet(rs));
                }
            }
        }
        return elections;
    }

    private Election mapElectionFromResultSet(ResultSet rs) throws SQLException {
        Election election = new Election();
        election.setElectionId(rs.getInt("election_id"));
        election.setTitle(rs.getString("title"));
        election.setDescription(rs.getString("description"));
        election.setStartDate(rs.getTimestamp("start_date"));
        election.setEndDate(rs.getTimestamp("end_date"));
        election.setStatus(rs.getString("status"));
        return election;
    }
    
    public List<Election> getAllElections() throws SQLException {
        List<Election> elections = new ArrayList<>();
        String sql = "SELECT * FROM elections";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                elections.add(mapElectionFromResultSet(rs));
            }
        }
        return elections;
    }

    public Election getElectionById(int electionId) throws SQLException {
        String sql = "SELECT * FROM elections WHERE election_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, electionId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Election election = new Election();
                    election.setElectionId(rs.getInt("election_id"));
                    election.setTitle(rs.getString("title"));
                    election.setDescription(rs.getString("description"));
                    election.setStartDate(rs.getTimestamp("start_date"));
                    election.setEndDate(rs.getTimestamp("end_date"));
                    election.setStatus(rs.getString("status"));
                    return election;
                }
            }
        }
        return null;
    }
    
    public boolean createElection(Election election) throws SQLException {
        String sql = "INSERT INTO elections (title, description, start_date, end_date, status) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, election.getTitle());
            stmt.setString(2, election.getDescription());
            stmt.setTimestamp(3, election.getStartDate());
            stmt.setTimestamp(4, election.getEndDate());
            stmt.setString(5, election.getStatus());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean updateElectionStatus(int electionId, String status) throws SQLException {
        String sql = "UPDATE elections SET status = ? WHERE election_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, electionId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteElection(int electionId) throws SQLException {
        String sql = "DELETE FROM elections WHERE election_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, electionId);
            return stmt.executeUpdate() > 0;
        }
    }
}