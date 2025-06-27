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
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
            ElectionDAO electionDAO = new ElectionDAO(conn);
            
            if ("view".equals(action)) {
                int electionId = Integer.parseInt(request.getParameter("id"));
                Election election = electionDAO.getElectionById(electionId);
                
                if (election != null) {
                    PositionDAO positionDAO = new PositionDAO(conn);
                    List<Position> positions = positionDAO.getPositionsByElection(electionId);
                    
                    request.setAttribute("election", election);
                    request.setAttribute("positions", positions);
                    request.getRequestDispatcher("electionView.jsp").forward(request, response);
                } else {
                    response.sendRedirect("voter/dashboard.jsp?error=Election not found");
                }
            } else {
                // List active elections by default
                List<Election> elections = electionDAO.getActiveElections();
                request.setAttribute("elections", elections);
                request.getRequestDispatcher("electionList.jsp").forward(request, response);
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("error500.jsp");
        }
    }
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    HttpSession session = request.getSession(false);
	    if (session == null || session.getAttribute("user") == null) {
	        response.sendRedirect("login.jsp");
	        return;
	    }

	    User currentUser = (User) session.getAttribute("user");
	    if (!"ADMIN".equals(currentUser.getRoleName())) {
	        response.sendRedirect("voter/dashboard.jsp?error=Unauthorized access");
	        return;
	    }

	    String action = request.getParameter("action");
	    
	    try {
	        Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
	        
	        if ("create".equals(action)) {
	            createElection(request, response, conn);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	        response.sendRedirect("error500.jsp");
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
	    election.setStatus("UPCOMING");
	    
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
	        response.sendRedirect("admin/dashboard.jsp?message=Election created successfully");
	    } catch (SQLException e) {
	        conn.rollback();
	        throw e;
	    } finally {
	        conn.setAutoCommit(true);
	    }
	}
}