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
        System.out.println("DEBUG: CandidateServlet GET request received");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        System.out.println("DEBUG: Action parameter = " + action);
        
        try {
            Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
            CandidateDAO candidateDAO = new CandidateDAO(conn);
            User currentUser = (User) session.getAttribute("user");
            
            if ("register".equals(action)) {
                System.out.println("DEBUG: Processing registration GET request");
                
                if (candidateDAO.isUserCandidate(currentUser.getUserId())) {
                    request.setAttribute("error", "You are already registered as a candidate");
                }
                
                String jspPath = "/candidate/candidateRegistration.jsp";
                System.out.println("DEBUG: Forwarding to: " + jspPath);
                
                request.getRequestDispatcher(jspPath).forward(request, response);
                return;
            } else if ("list".equals(action)) {
                String position = request.getParameter("position");
                request.setAttribute("candidates", candidateDAO.getCandidatesByPosition(position));
                request.getRequestDispatcher("/candidate/candidateList.jsp").forward(request, response);
                return;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error500.jsp");
        }
        
        response.sendRedirect(request.getContextPath() + "/voter/dashboard.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("DEBUG: CandidateServlet POST request received");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        System.out.println("DEBUG: POST Action parameter = " + action);
        
        if (!"register".equals(action)) {
            response.sendRedirect(request.getContextPath() + "/voter/dashboard.jsp");
            return;
        }

        try {
            Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
            CandidateDAO candidateDAO = new CandidateDAO(conn);
            User currentUser = (User) session.getAttribute("user");
            
            // Check if user is already a candidate
            if (candidateDAO.isUserCandidate(currentUser.getUserId())) {
                request.setAttribute("error", "You are already registered as a candidate");
                request.getRequestDispatcher("/candidate/candidateRegistration.jsp").forward(request, response);
                return;
            }
            
            // Create new candidate
            Candidate candidate = new Candidate();
            candidate.setUserId(currentUser.getUserId());
            candidate.setPosition(request.getParameter("position"));
            candidate.setBio(request.getParameter("bio"));
            
            if (candidateDAO.createCandidate(candidate)) {
                // Success - stay on page with success message
                request.setAttribute("success", "Candidate registration successful!");
                request.getRequestDispatcher("/candidate/candidateRegistration.jsp").forward(request, response);
            } else {
                // Failure - show error on registration page
                request.setAttribute("error", "Failed to register as candidate");
                request.getRequestDispatcher("/candidate/candidateRegistration.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred: " + e.getMessage());
            request.getRequestDispatcher("/candidate/candidateRegistration.jsp").forward(request, response);
        }
    }
}