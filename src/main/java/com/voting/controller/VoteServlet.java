package com.voting.controller;

import com.voting.dao.VoteDAO;
import com.voting.model.User;
import com.voting.model.Vote;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/vote")
public class VoteServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        if ("cast".equals(action)) {
            try {
                Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
                VoteDAO voteDAO = new VoteDAO(conn);
                User user = (User) session.getAttribute("user");
                
                Vote vote = new Vote();
                vote.setElectionId(Integer.parseInt(request.getParameter("electionId")));
                vote.setPositionId(Integer.parseInt(request.getParameter("positionId")));
                vote.setCandidateId(Integer.parseInt(request.getParameter("candidateId")));
                vote.setUserId(user.getUserId());
                
                if (voteDAO.castVote(vote)) {
                    response.sendRedirect("voter/dashboard.jsp?message=Vote cast successfully");
                } else {
                    response.sendRedirect("voter/dashboard.jsp?error=Failed to cast vote (maybe already voted)");
                }
            } catch (SQLException | NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect("error500.jsp");
            }
        }
    }
}