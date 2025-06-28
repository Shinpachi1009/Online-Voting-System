package com.voting.controller;

import com.voting.dao.CandidateDAO;
import com.voting.dao.UserDAO;
import com.voting.model.Candidate;
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

@WebServlet("/candidate")
public class CandidateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
		
		System.out.println("DEBUG: CandidateServlet reached!");
		
		
	    HttpSession session = request.getSession(false);
	    if (session == null || session.getAttribute("user") == null) {
	        response.sendRedirect(request.getContextPath() + "/login.jsp");
	        return;
	    }

	    String action = request.getParameter("action");
	    System.out.println("DEBUG: Action parameter = " + action); // Debug line
	    
	    try {
	        Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
	        CandidateDAO candidateDAO = new CandidateDAO(conn);
	        User currentUser = (User) session.getAttribute("user");
	        
	        if ("register".equals(action)) {
	        	
	        	System.out.println("DEBUG: Processing registration request"); // Debug line
	        	
	            if (candidateDAO.isUserCandidate(currentUser.getUserId())) {
	                request.setAttribute("error", "You are already registered as a candidate");
	            }
	            
	            String jspPath = "/candidate/candidateRegistration.jsp";
                System.out.println("DEBUG: Forwarding to: " + jspPath); // Debug line
                
                // Get the real path for debugging
                String realPath = getServletContext().getRealPath(jspPath);
                System.out.println("DEBUG: Real path: " + realPath);
	            
	            // Make sure this path matches your actual JSP location
	            request.getRequestDispatcher("/candidate/candidateRegistration.jsp").forward(request, response);
	            return;  // Important to return after forward
	        } else if ("list".equals(action)) {
	            String position = request.getParameter("position");
	            request.setAttribute("candidates", candidateDAO.getCandidatesByPosition(position));
	            request.getRequestDispatcher("/candidate/candidateList.jsp").forward(request, response);
	            return;  // Important to return after forward
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	        response.sendRedirect(request.getContextPath() + "/error500.jsp");
	    }
	    
	    // If no action matches, redirect to dashboard
	    response.sendRedirect(request.getContextPath() + "/voter/dashboard.jsp");
	}
}