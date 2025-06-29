package com.voting.dao;

import com.voting.model.Result;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ResultDAO {
    private Connection connection;
    
    public ResultDAO(Connection connection) {
        this.connection = connection;
    }
    
    public List<Result> getResultsByPosition(int positionId) throws SQLException {
        List<Result> results = new ArrayList<>();
        String sql = "SELECT c.candidate_id, u.first_name || ' ' || u.last_name as candidate_name, " +
                     "c.bio as candidate_bio, COUNT(v.vote_id) as vote_count " +
                     "FROM votes v " +
                     "JOIN candidates c ON v.candidate_id = c.candidate_id " +
                     "JOIN users u ON c.user_id = u.user_id " +
                     "WHERE v.position_id = ? " +
                     "GROUP BY c.candidate_id, u.first_name, u.last_name, c.bio " +
                     "ORDER BY vote_count DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, positionId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                int totalVotes = getTotalVotesForPosition(positionId);
                
                while (rs.next()) {
                    Result result = new Result();
                    result.setCandidateId(rs.getInt("candidate_id"));
                    result.setCandidateName(rs.getString("candidate_name"));
                    result.setCandidateBio(rs.getString("candidate_bio"));
                    result.setVoteCount(rs.getInt("vote_count"));
                    
                    if (totalVotes > 0) {
                        double percentage = (result.getVoteCount() * 100.0) / totalVotes;
                        result.setPercentage(Math.round(percentage * 10) / 10.0); // Round to 1 decimal
                    } else {
                        result.setPercentage(0);
                    }
                    
                    results.add(result);
                }
            }
        }
        return results;
    }
    
    public int getTotalVotesForPosition(int positionId) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM votes WHERE position_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, positionId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }
}