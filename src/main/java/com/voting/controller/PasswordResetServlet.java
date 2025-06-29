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
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/password-reset")
public class PasswordResetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Email configuration - should be in config file in production
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_USERNAME = "your-email@gmail.com";
    private static final String EMAIL_PASSWORD = "your-email-password";
    private static final String EMAIL_FROM = "your-email@gmail.com";
    private static final String APP_BASE_URL = "http://localhost:8080/Online-Voting-System";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String token = request.getParameter("token");
        
        if (token != null) {
            try {
                Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
                PasswordResetTokenDAO tokenDAO = new PasswordResetTokenDAO(conn);
                
                if (tokenDAO.validateToken(token) != null) {
                    request.setAttribute("token", token);
                    request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Invalid or expired token");
                    request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Database error");
                request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
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
                // Generate token
                String token = tokenDAO.createToken(user.getUserId());
                
                // Send email
                sendPasswordResetEmail(user.getEmail(), token);
                
                // Log password reset request
                AuditLog auditLog = new AuditLog();
                auditLog.setUserId(user.getUserId());
                auditLog.setActionType("PASSWORD_RESET_REQUEST");
                auditLog.setDetails("Password reset requested");
                auditLog.setIpAddress(request.getRemoteAddr());
                auditLogDAO.logAction(auditLog);
                
                request.setAttribute("message", "If an account with that email exists, a reset link has been sent");
            } else {
                // For security, don't reveal whether the email exists
                request.setAttribute("message", "If an account with that email exists, a reset link has been sent");
            }
            request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error");
            request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
        } catch (MessagingException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to send reset email");
            request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
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
                    
                    request.setAttribute("message", "Password reset successful. Please login with your new password.");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Password reset failed");
                    request.setAttribute("token", token);
                    request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Invalid or expired token");
                request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error");
            request.setAttribute("token", token);
            request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
        }
    }
    
    private void sendPasswordResetEmail(String toEmail, String token) throws MessagingException {
        // Email properties
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        
        // Create session
        Session session = Session.getInstance(props,
            new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
                }
            });
        
        try {
            // Create message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Password Reset Request - Online Voting System");
            
            // Create reset link
            String resetLink = APP_BASE_URL + "/password-reset?token=" + token;
            
            // Email content
            String content = "<h3>Password Reset Request</h3>"
                + "<p>You have requested to reset your password for the Online Voting System.</p>"
                + "<p>Please click the link below to reset your password:</p>"
                + "<p><a href=\"" + resetLink + "\">Reset Password</a></p>"
                + "<p>This link will expire in 24 hours.</p>"
                + "<p>If you didn't request this, please ignore this email.</p>";
            
            message.setContent(content, "text/html");
            
            // Send message
            Transport.send(message);
        } catch (MessagingException e) {
            throw new MessagingException("Failed to send password reset email", e);
        }
    }
}