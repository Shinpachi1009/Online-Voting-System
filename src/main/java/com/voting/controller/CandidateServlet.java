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
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
            CandidateDAO candidateDAO = new CandidateDAO(conn);
            UserDAO userDAO = new UserDAO(conn);
            
            User currentUser = (User) session.getAttribute("user");
            
            if ("register".equals(action)) {
                // Check if user is already a candidate
                if (candidateDAO.isUserCandidate(currentUser.getUserId())) {
                    request.setAttribute("error", "You are already registered as a candidate");
                    request.getRequestDispatcher("/candidate/candidateRegistration.jsp").forward(request, response);
                    return;
                }
                
                request.getRequestDispatcher("/candidate/candidateRegistration.jsp").forward(request, response);
            } else if ("list".equals(action)) {
                String position = request.getParameter("position");
                request.setAttribute("candidates", candidateDAO.getCandidatesByPosition(position));
                request.getRequestDispatcher("/candidate/candidateList.jsp").forward(request, response);
            }
        } catch (SQLException e) {
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

        try {
            Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
            CandidateDAO candidateDAO = new CandidateDAO(conn);
            
            User currentUser = (User) session.getAttribute("user");
            
            Candidate candidate = new Candidate();
            candidate.setUserId(currentUser.getUserId());
            candidate.setPosition(request.getParameter("position"));
            candidate.setBio(request.getParameter("bio"));
            
            if (candidateDAO.createCandidate(candidate)) {
                response.sendRedirect("voter/dashboard.jsp?message=Candidate registration successful");
            } else {
                request.setAttribute("error", "Failed to register as candidate");
                request.getRequestDispatcher("/candidate/candidateRegistration.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error500.jsp");
        }
    }
}