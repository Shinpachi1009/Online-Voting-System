package com.voting.controller;

import com.voting.dao.AuditLogDAO;
import com.voting.dao.UserDAO;
import com.voting.model.AuditLog;
import com.voting.model.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("login".equals(action)) {
            processLogin(request, response);
        } else if ("logout".equals(action)) {
            processLogout(request, response);
        } else {
            response.sendRedirect("login.jsp?error=Invalid action");
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRememberMeLogin(request, response);
    }
    
    private void processLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");
        
        try {
            Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
            UserDAO userDAO = new UserDAO(conn);
            AuditLogDAO auditLogDAO = new AuditLogDAO(conn);
            
            User user = userDAO.getUserByUsername(username);
            
            if (user == null || !UserDAO.verifyPassword(password, user.getPasswordHash())) {
                auditLogDAO.logAction(createAuditLog(
                    user != null ? user.getUserId() : null,
                    "LOGIN_FAILED",
                    "Failed login for: " + username,
                    request.getRemoteAddr()
                ));
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Invalid username or password");
                return;
            }
            
            if (!"ACTIVE".equals(user.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Your account is not active");
                return;
            }
            
            // Update last login
            userDAO.updateLastLogin(user.getUserId());
            
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            
            // Handle remember me
            handleRememberMe(request, response, user, userDAO);
            
            // Log success
            auditLogDAO.logAction(createAuditLog(
                user.getUserId(),
                "LOGIN_SUCCESS",
                "User logged in successfully",
                request.getRemoteAddr()
            ));
            
            // Use forward instead of redirect for initial testing
            String dashboardPath = determineDashboardPath(user.getRoleName());
            request.getRequestDispatcher(dashboardPath).forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Database error");
        }
    }

    private String determineDashboardPath(String roleName) {
        if (roleName == null) return "/voter/dashboard.jsp";
        
        switch (roleName.toUpperCase()) {
            case "ADMIN": return "/admin/dashboard.jsp";
            case "ELECTION_OFFICER": return "/officer/dashboard.jsp";
            default: return "/voter/dashboard.jsp";
        }
    }
    
    
    private void processRememberMeLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    } 
    
    private void handleRememberMe(HttpServletRequest request, HttpServletResponse response, 
            User user, UserDAO userDAO) throws SQLException {
        String rememberMe = request.getParameter("rememberMe");
        
        if ("on".equals(rememberMe)) {
            String rememberToken = UUID.randomUUID().toString();
            userDAO.storeRememberMeToken(user.getUserId(), rememberToken);
            
            createSecureCookie(response, "rememberToken", rememberToken, 
                30 * 24 * 60 * 60, request.getContextPath(), request.isSecure());
            createSecureCookie(response, "userID", String.valueOf(user.getUserId()), 
                30 * 24 * 60 * 60, request.getContextPath(), request.isSecure());
        }
    }
    
    private void createSecureCookie(HttpServletResponse response, String name, 
            String value, int maxAge, String path, boolean secure) {
        Cookie cookie = new Cookie(name, value);
        cookie.setMaxAge(maxAge);
        cookie.setPath(path);
        cookie.setHttpOnly(true);
        cookie.setSecure(secure);
        response.addCookie(cookie);
    }
    
    private AuditLog createAuditLog(Integer userId, String actionType, 
            String details, String ipAddress) {
        AuditLog auditLog = new AuditLog();
        auditLog.setUserId(userId);
        auditLog.setActionType(actionType);
        auditLog.setDetails(details);
        auditLog.setIpAddress(ipAddress);
        return auditLog;
    }
    
    private void processLogout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            User user = (User) session.getAttribute("user");
            
            if (user != null) {
                try {
                    Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
                    UserDAO userDAO = new UserDAO(conn);
                    userDAO.clearRememberToken(user.getUserId());
                    
                    AuditLogDAO auditLogDAO = new AuditLogDAO(conn);
                    auditLogDAO.logAction(createAuditLog(
                        user.getUserId(),
                        "LOGOUT",
                        "User logged out",
                        request.getRemoteAddr()
                    ));
                } catch (SQLException e) {
                    System.err.println("[LOGOUT ERROR] " + e.getMessage());
                }
            }
            
            session.invalidate();
        }
        
        clearCookie(response, "rememberToken", request.getContextPath());
        clearCookie(response, "userID", request.getContextPath());
        
        response.sendRedirect(request.getContextPath() + "/login.jsp?message=You have been logged out");
    }
    
    private void clearCookie(HttpServletResponse response, String cookieName, String path) {
        Cookie cookie = new Cookie(cookieName, "");
        cookie.setMaxAge(0);
        cookie.setPath(path);
        response.addCookie(cookie);
    }
}