package com.voting.controller;

import com.voting.dao.PasswordResetTokenDAO;
import com.voting.dao.UserDAO;
import com.voting.dao.AuditLogDAO;
import com.voting.model.AuditLog;
import com.voting.model.PasswordResetToken;
import com.voting.model.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/password-reset")
public class PasswordResetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String token = request.getParameter("token");
        
        if (token != null) {
            // Show password reset form
            try {
                Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
                PasswordResetTokenDAO tokenDAO = new PasswordResetTokenDAO(conn);
                
                if (tokenDAO.validateToken(token) != null) {
                    request.setAttribute("token", token);
                    request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
                } else {
                    response.sendRedirect("forgotPassword.jsp?error=Invalid or expired token");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("forgotPassword.jsp?error=Database error");
            }
        } else {
            response.sendRedirect("forgotPassword.jsp");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("request".equals(action)) {
            processResetRequest(request, response);
        } else if ("reset".equals(action)) {
            processPasswordReset(request, response);
        } else {
            response.sendRedirect("forgotPassword.jsp");
        }
    }
    
    private void processResetRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        
        try {
            Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
            UserDAO userDAO = new UserDAO(conn);
            PasswordResetTokenDAO tokenDAO = new PasswordResetTokenDAO(conn);
            AuditLogDAO auditLogDAO = new AuditLogDAO(conn);
            
            User user = userDAO.getUserByEmail(email);
            
            if (user != null) {
                // Generate token and send email (in a real app, you would send an email here)
                String token = tokenDAO.createToken(user.getUserId());
                
                // In a real application, you would send an email with the reset link
                String resetLink = request.getRequestURL().toString() + "?token=" + token;
                System.out.println("Password reset link for " + user.getEmail() + ": " + resetLink);
                
                // Log password reset request
                AuditLog auditLog = new AuditLog();
                auditLog.setUserId(user.getUserId());
                auditLog.setActionType("PASSWORD_RESET_REQUEST");
                auditLog.setDetails("Password reset requested");
                auditLog.setIpAddress(request.getRemoteAddr());
                auditLogDAO.logAction(auditLog);
                
                response.sendRedirect("forgotPassword.jsp?message=If an account with that email exists, a reset link has been sent");
            } else {
                // For security, don't reveal whether the email exists
                response.sendRedirect("forgotPassword.jsp?message=If an account with that email exists, a reset link has been sent");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("forgotPassword.jsp?error=Database error");
        }
    }
    
    private void processPasswordReset(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        
        try {
            Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
            PasswordResetTokenDAO tokenDAO = new PasswordResetTokenDAO(conn);
            UserDAO userDAO = new UserDAO(conn);
            AuditLogDAO auditLogDAO = new AuditLogDAO(conn);
            
            PasswordResetToken resetToken = tokenDAO.validateToken(token);
            
            if (resetToken != null) {
                // Update password
                String newPasswordHash = UserDAO.hashPassword(newPassword);
                if (userDAO.updatePassword(resetToken.getUserId(), newPasswordHash)) {
                    // Mark token as used
                    tokenDAO.markTokenAsUsed(resetToken.getTokenId());
                    
                    // Log password reset
                    AuditLog auditLog = new AuditLog();
                    auditLog.setUserId(resetToken.getUserId());
                    auditLog.setActionType("PASSWORD_RESET");
                    auditLog.setDetails("Password reset via token");
                    auditLog.setIpAddress(request.getRemoteAddr());
                    auditLogDAO.logAction(auditLog);
                    
                    response.sendRedirect("login.jsp?message=Password reset successful. Please login with your new password.");
                } else {
                    response.sendRedirect("resetPassword.jsp?token=" + token + "&error=Password reset failed");
                }
            } else {
                response.sendRedirect("forgotPassword.jsp?error=Invalid or expired token");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("resetPassword.jsp?token=" + token + "&error=Database error");
        }
    }
}