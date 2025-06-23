package com.voting.controller;

import com.voting.dao.VoterDAO;
import com.voting.model.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/voter-approval")
public class VoterApprovalServlet extends HttpServlet {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection conn = (Connection) getServletContext().getAttribute("VOTING");
            VoterDAO voterDAO = new VoterDAO(conn);
            
            request.setAttribute("pendingVoters", voterDAO.getPendingRegistrations());
            request.getRequestDispatcher("/admin/voterApproval.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading pending registrations");
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !("ADMIN".equals(user.getRoleName()) || "ELECTION_OFFICER".equals(user.getRoleName()))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        int voterId = Integer.parseInt(request.getParameter("voterId"));
        String notes = request.getParameter("notes");
        
        try {
            Connection conn = (Connection) getServletContext().getAttribute("VOTING");
            VoterDAO voterDAO = new VoterDAO(conn);
            
            if ("approve".equals(action)) {
                voterDAO.updateVoterStatus(voterId, "APPROVED", user.getUserId(), notes);
            } else if ("reject".equals(action)) {
                voterDAO.updateVoterStatus(voterId, "REJECTED", user.getUserId(), notes);
            }
            
            response.sendRedirect("voter-approval");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing approval");
            request.getRequestDispatcher("/admin/voterApproval.jsp").forward(request, response);
        }
    }
}