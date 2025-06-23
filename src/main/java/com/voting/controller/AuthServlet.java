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
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Invalid action");
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRememberMeLogin(request, response);
    }
    
    private void processLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();
        
        try {
            Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
            UserDAO userDAO = new UserDAO(conn);
            AuditLogDAO auditLogDAO = new AuditLogDAO(conn);
            
            User user = userDAO.getUserByUsername(username);
            if (user == null) {
                auditLogDAO.logAction(createAuditLog(null, "LOGIN_FAILED", 
                    "Failed login attempt for username: " + username, request.getRemoteAddr()));
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Invalid username or password");
                return;
            }
            
            if (!UserDAO.verifyPassword(password, user.getPasswordHash())) {
                auditLogDAO.logAction(createAuditLog(user.getUserId(), "LOGIN_FAILED", 
                    "Failed login attempt for user ID: " + user.getUserId(), request.getRemoteAddr()));
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Invalid username or password");
                return;
            }
            
            if (!"ACTIVE".equals(user.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Your account is not active");
                return;
            }
            
            // Update last login time
            userDAO.updateLastLogin(user.getUserId());
            
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            // Handle "Remember Me" if selected
            handleRememberMe(request, response, user, userDAO);
            
            // Log successful login
            auditLogDAO.logAction(createAuditLog(
                user.getUserId(),
                "LOGIN_SUCCESS",
                "User logged in successfully",
                request.getRemoteAddr()
            ));
            
            // NEW: Use forward instead of redirect to maintain request context
            String dashboardPath = getDashboardPath(user.getRoleName());
            request.getRequestDispatcher(dashboardPath).forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Database error");
        }
    }
    
    private String getDashboardPath(String roleName) {
        if (roleName == null) return "/voter/dashboard.jsp";
        
        switch (roleName.toUpperCase()) {
            case "ADMIN": return "/admin/dashboard.jsp";
            case "ELECTION_OFFICER": return "/officer/dashboard.jsp";
            default: return "/voter/dashboard.jsp";
        }
    }
    
    private void processRememberMeLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        Cookie[] cookies = request.getCookies();
        String rememberToken = null;
        String userId = null;
        
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberToken".equals(cookie.getName())) {
                    rememberToken = cookie.getValue();
                } else if ("userID".equals(cookie.getName())) {
                    userId = cookie.getValue();
                }
            }
        }
        
        if (rememberToken != null && userId != null) {
            try {
                Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
                UserDAO userDAO = new UserDAO(conn);
                
                // First try to validate the token
                User user = userDAO.validateRememberMeToken(Integer.parseInt(userId), rememberToken);
                
                if (user != null) {
                    // Create new session
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    
                    // Update last login time
                    userDAO.updateLastLogin(user.getUserId());
                    
                    // Log successful remember me login
                    AuditLogDAO auditLogDAO = new AuditLogDAO(conn);
                    auditLogDAO.logAction(createAuditLog(
                        user.getUserId(),
                        "REMEMBER_ME_LOGIN",
                        "User logged in via remember me",
                        request.getRemoteAddr()
                    ));
                    
                    // Forward to dashboard
                    request.getRequestDispatcher(getDashboardPath(user.getRoleName())).forward(request, response);
                    return;
                } else {
                    // Token validation failed - clear cookies
                    clearCookie(response, "rememberToken", request.getContextPath());
                    clearCookie(response, "userID", request.getContextPath());
                }
            } catch (SQLException | NumberFormatException e) {
                System.err.println("Remember me token validation failed: " + e.getMessage());
                // Clear invalid cookies on error
                clearCookie(response, "rememberToken", request.getContextPath());
                clearCookie(response, "userID", request.getContextPath());
            }
        }
        
        // Fall through to regular login page if no valid token
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