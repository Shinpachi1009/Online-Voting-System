package com.voting.controller;

import com.voting.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String dashboardPath = determineDashboardPath(user.getRoleName());
        
        // Forward to the appropriate dashboard
        request.getRequestDispatcher(dashboardPath).forward(request, response);
    }
    
    private String determineDashboardPath(String roleName) {
        if (roleName == null) return "/voter/dashboard.jsp";
        
        switch (roleName.toUpperCase()) {
            case "ADMIN": return "/admin/dashboard.jsp";
            case "ELECTION_OFFICER": return "/officer/dashboard.jsp";
            default: return "/voter/dashboard.jsp";
        }
    }
}