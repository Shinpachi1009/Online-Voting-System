package com.voting.dao;

import com.voting.model.Vote;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VoteDAO {
    private Connection connection;

    public VoteDAO(Connection connection) {
        this.connection = connection;
    }

    public boolean castVote(Vote vote) throws SQLException {
        // First check if user already voted for this position
        if (hasVoted(vote.getUserId(), vote.getPositionId())) {
            return false;
        }

        String sql = "INSERT INTO votes (election_id, position_id, candidate_id, user_id) VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, vote.getElectionId());
            stmt.setInt(2, vote.getPositionId());
            stmt.setInt(3, vote.getCandidateId());
            stmt.setInt(4, vote.getUserId());
            
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean hasVoted(int userId, int positionId) throws SQLException {
        String sql = "SELECT 1 FROM votes WHERE user_id = ? AND position_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, positionId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<Vote> getVotesByPosition(int positionId) throws SQLException {
        List<Vote> votes = new ArrayList<>();
        String sql = "SELECT * FROM votes WHERE position_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, positionId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Vote vote = new Vote();
                    vote.setVoteId(rs.getInt("vote_id"));
                    vote.setElectionId(rs.getInt("election_id"));
                    vote.setPositionId(rs.getInt("position_id"));
                    vote.setCandidateId(rs.getInt("candidate_id"));
                    vote.setUserId(rs.getInt("user_id"));
                    vote.setVotedAt(rs.getTimestamp("voted_at"));
                    votes.add(vote);
                }
            }
        }
        return votes;
    }
    
    public int getTotalVotesCount() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM votes";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    public int getRecentVotesCount(int hours) throws SQLException {
        String sql = "SELECT COUNT(*) as recent FROM votes WHERE voted_at >= ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            Timestamp cutoff = new Timestamp(System.currentTimeMillis() - (hours * 60 * 60 * 1000));
            stmt.setTimestamp(1, cutoff);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("recent");
                }
            }
        }
        return 0;
    }
}