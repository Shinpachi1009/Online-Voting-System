package com.voting.dao;

import com.voting.model.Position;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PositionDAO {
    private Connection connection;

    public PositionDAO(Connection connection) {
        this.connection = connection;
    }

    public List<Position> getPositionsByElection(int electionId) throws SQLException {
        List<Position> positions = new ArrayList<>();
        String sql = "SELECT * FROM positions WHERE election_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, electionId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Position position = new Position();
                    position.setPositionId(rs.getInt("position_id"));
                    position.setElectionId(rs.getInt("election_id"));
                    position.setTitle(rs.getString("title"));
                    position.setDescription(rs.getString("description"));
                    position.setMaxVotes(rs.getInt("max_votes"));
                    positions.add(position);
                }
            }
        }
        return positions;
    }
    
    public boolean createPosition(Position position) throws SQLException {
        String sql = "INSERT INTO positions (election_id, title, description, max_votes) VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, position.getElectionId());
            stmt.setString(2, position.getTitle());
            stmt.setString(3, position.getDescription());
            stmt.setInt(4, position.getMaxVotes());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean deletePositionsByElection(int electionId) throws SQLException {
        String sql = "DELETE FROM positions WHERE election_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, electionId);
            return stmt.executeUpdate() > 0;
        }
    }
    public Position getPositionById(int positionId) throws SQLException {
        String sql = "SELECT * FROM positions WHERE position_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, positionId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Position position = new Position();
                    position.setPositionId(rs.getInt("position_id"));
                    position.setElectionId(rs.getInt("election_id"));
                    position.setTitle(rs.getString("title"));
                    position.setDescription(rs.getString("description"));
                    position.setMaxVotes(rs.getInt("max_votes"));
                    return position;
                }
            }
        }
        return null;
    }
}