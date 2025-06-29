package com.voting.controller;

import com.voting.dao.ElectionDAO;
import com.voting.dao.PositionDAO;
import com.voting.model.Election;
import com.voting.model.Position;
import com.voting.model.User;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/election")
public class ElectionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
            ElectionDAO electionDAO = new ElectionDAO(conn);
            
         // In the "view" action block of doGet() method:
            if ("view".equals(action)) {
                int electionId = Integer.parseInt(request.getParameter("id"));
                Election election = electionDAO.getElectionById(electionId);
                
                if (election != null) {
                    PositionDAO positionDAO = new PositionDAO(conn);
                    List<Position> positions = positionDAO.getPositionsByElection(electionId);
                    
                    // Set all election attributes explicitly
                    request.setAttribute("electionId", election.getElectionId());
                    request.setAttribute("title", election.getTitle());
                    request.setAttribute("description", election.getDescription());
                    request.setAttribute("startDate", election.getStartDate());
                    request.setAttribute("endDate", election.getEndDate());
                    request.setAttribute("status", election.getStatus());
                    request.setAttribute("positions", positions);
                    
                    // Forward to the correct path
                    request.getRequestDispatcher("/election/electionView.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Election not found");
                    request.getRequestDispatcher("/electionList.jsp").forward(request, response);
                }
            }
            else if ("new".equals(action)) {
                // Check admin role
                User currentUser = (User) session.getAttribute("user");
                if (!"ADMIN".equals(currentUser.getRoleName())) {
                    request.setAttribute("error", "Unauthorized access");
                    request.getRequestDispatcher("/voter/dashboard.jsp").forward(request, response);
                    return;
                }
                request.getRequestDispatcher("/admin/electionCreate.jsp").forward(request, response);
            }
            else if ("manage".equals(action)) {
                // Check admin role
                User currentUser = (User) session.getAttribute("user");
                if (!"ADMIN".equals(currentUser.getRoleName())) {
                    request.setAttribute("error", "Unauthorized access");
                    request.getRequestDispatcher("/voter/dashboard.jsp").forward(request, response);
                    return;
                }
                
                List<Election> allElections = electionDAO.getAllElections();
                request.setAttribute("elections", allElections);
                request.getRequestDispatcher("/admin/electionManagement.jsp").forward(request, response);
            }
            else if ("edit".equals(action)) {
                // Check admin role
                User currentUser = (User) session.getAttribute("user");
                if (!"ADMIN".equals(currentUser.getRoleName())) {
                    request.setAttribute("error", "Unauthorized access");
                    request.getRequestDispatcher("/voter/dashboard.jsp").forward(request, response);
                    return;
                }
                
                int electionId = Integer.parseInt(request.getParameter("id"));
                Election election = electionDAO.getElectionById(electionId);
                
                if (election != null) {
                    PositionDAO positionDAO = new PositionDAO(conn);
                    List<Position> positions = positionDAO.getPositionsByElection(electionId);
                    
                    request.setAttribute("election", election);
                    request.setAttribute("positions", positions);
                    request.getRequestDispatcher("/admin/electionEdit.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Election not found");
                    request.getRequestDispatcher("/admin/electionManagement.jsp").forward(request, response);
                }
            }
            else if ("list".equals(action)) {
                String status = request.getParameter("status");
                List<Election> elections;
                
                if (status != null) {
                    elections = electionDAO.getElectionsByStatus(status.toUpperCase());
                } else {
                    elections = electionDAO.getActiveElections();
                }
                
                request.setAttribute("elections", elections);
                request.getRequestDispatcher("/electionList.jsp").forward(request, response);
            }
            else {
                // Default to active elections
                List<Election> elections = electionDAO.getActiveElections();
                request.setAttribute("elections", elections);
                request.getRequestDispatcher("/electionList.jsp").forward(request, response);
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Server error occurred");
            request.getRequestDispatcher("/error500.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (!"ADMIN".equals(currentUser.getRoleName())) {
            request.setAttribute("error", "Unauthorized access");
            request.getRequestDispatcher("/voter/dashboard.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");
        
        try {
            Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
            
            if ("create".equals(action)) {
                createElection(request, response, conn);
            }
            else if ("update".equals(action)) {
                updateElection(request, response, conn);
            }
            else if ("delete".equals(action)) {
                deleteElection(request, response, conn);
            }
            else if ("changestatus".equals(action)) {
                changeElectionStatus(request, response, conn);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            
            if ("create".equals(action)) {
                request.getRequestDispatcher("/admin/electionCreate.jsp").forward(request, response);
            } else if ("update".equals(action)) {
                request.getRequestDispatcher("/admin/electionEdit.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/admin/electionManagement.jsp").forward(request, response);
            }
        }
    }
    
    private void createElection(HttpServletRequest request, HttpServletResponse response, Connection conn) 
            throws SQLException, ServletException, IOException {
        ElectionDAO electionDAO = new ElectionDAO(conn);
        PositionDAO positionDAO = new PositionDAO(conn);
        
        // Create election
        Election election = new Election();
        election.setTitle(request.getParameter("title"));
        election.setDescription(request.getParameter("description"));
        election.setStartDate(Timestamp.valueOf(request.getParameter("startDate").replace("T", " ") + ":00"));
        election.setEndDate(Timestamp.valueOf(request.getParameter("endDate").replace("T", " ") + ":00"));
        election.setStatus("ACTIVE"); // Default to upcoming
        
        // Start transaction
        conn.setAutoCommit(false);
        
        try {
            // Insert election
            String sql = "INSERT INTO elections (title, description, start_date, end_date, status) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, election.getTitle());
                stmt.setString(2, election.getDescription());
                stmt.setTimestamp(3, election.getStartDate());
                stmt.setTimestamp(4, election.getEndDate());
                stmt.setString(5, election.getStatus());
                
                stmt.executeUpdate();
                
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        election.setElectionId(rs.getInt(1));
                    }
                }
            }
            
            // Insert positions
            String[] positionTitles = request.getParameterValues("positionTitles");
            String[] positionDescriptions = request.getParameterValues("positionDescriptions");
            
            if (positionTitles != null) {
                for (int i = 0; i < positionTitles.length; i++) {
                    Position position = new Position();
                    position.setElectionId(election.getElectionId());
                    position.setTitle(positionTitles[i]);
                    position.setDescription(positionDescriptions[i]);
                    position.setMaxVotes(1); // Default to single selection
                    
                    positionDAO.createPosition(position);
                }
            }
            
            conn.commit();
            request.setAttribute("message", "Election created successfully!");
            response.sendRedirect(request.getContextPath() + "/election?action=manage");
        } catch (SQLException e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
        }
    }
    
    private void updateElection(HttpServletRequest request, HttpServletResponse response, Connection conn) 
            throws SQLException, ServletException, IOException {
        ElectionDAO electionDAO = new ElectionDAO(conn);
        PositionDAO positionDAO = new PositionDAO(conn);
        
        int electionId = Integer.parseInt(request.getParameter("electionId"));
        
        // Update election
        Election election = new Election();
        election.setElectionId(electionId);
        election.setTitle(request.getParameter("title"));
        election.setDescription(request.getParameter("description"));
        election.setStartDate(Timestamp.valueOf(request.getParameter("startDate").replace("T", " ") + ":00"));
        election.setEndDate(Timestamp.valueOf(request.getParameter("endDate").replace("T", " ") + ":00"));
        
        // Start transaction
        conn.setAutoCommit(false);
        
        try {
            // Update election
            String sql = "UPDATE elections SET title = ?, description = ?, start_date = ?, end_date = ? WHERE election_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, election.getTitle());
                stmt.setString(2, election.getDescription());
                stmt.setTimestamp(3, election.getStartDate());
                stmt.setTimestamp(4, election.getEndDate());
                stmt.setInt(5, election.getElectionId());
                
                stmt.executeUpdate();
            }
            
            // Delete existing positions
            positionDAO.deletePositionsByElection(electionId);
            
            // Insert updated positions
            String[] positionTitles = request.getParameterValues("positionTitles");
            String[] positionDescriptions = request.getParameterValues("positionDescriptions");
            
            if (positionTitles != null) {
                for (int i = 0; i < positionTitles.length; i++) {
                    Position position = new Position();
                    position.setElectionId(electionId);
                    position.setTitle(positionTitles[i]);
                    position.setDescription(positionDescriptions[i]);
                    position.setMaxVotes(1); // Default to single selection
                    
                    positionDAO.createPosition(position);
                }
            }
            
            conn.commit();
            request.setAttribute("message", "Election updated successfully!");
            response.sendRedirect(request.getContextPath() + "/election?action=manage");
        } catch (SQLException e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
        }
    }
    
    private void deleteElection(HttpServletRequest request, HttpServletResponse response, Connection conn) 
            throws SQLException, ServletException, IOException {
        int electionId = Integer.parseInt(request.getParameter("id"));
        ElectionDAO electionDAO = new ElectionDAO(conn);
        
        // Start transaction
        conn.setAutoCommit(false);
        
        try {
            // First delete positions
            PositionDAO positionDAO = new PositionDAO(conn);
            positionDAO.deletePositionsByElection(electionId);
            
            // Then delete election
            boolean deleted = electionDAO.deleteElection(electionId);
            
            conn.commit();
            
            if (deleted) {
                request.getSession().setAttribute("message", "Election deleted successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to delete election");
            }
        } catch (SQLException e) {
            conn.rollback();
            request.getSession().setAttribute("error", "Database error: " + e.getMessage());
        } finally {
            conn.setAutoCommit(true);
        }
        
        // Redirect back to management page
        response.sendRedirect(request.getContextPath() + "/election?action=manage");
    }
    
    private void changeElectionStatus(HttpServletRequest request, HttpServletResponse response, Connection conn) 
            throws SQLException, ServletException, IOException {
        int electionId = Integer.parseInt(request.getParameter("id"));
        String newStatus = request.getParameter("status");
        ElectionDAO electionDAO = new ElectionDAO(conn);
        
        if (electionDAO.updateElectionStatus(electionId, newStatus)) {
            request.setAttribute("message", "Election status updated successfully");
        } else {
            request.setAttribute("error", "Failed to update election status");
        }
        
        response.sendRedirect(request.getContextPath() + "/election?action=manage");
    }
}