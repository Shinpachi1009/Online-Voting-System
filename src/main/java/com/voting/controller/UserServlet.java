package com.voting.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.voting.dao.AuditLogDAO;
import com.voting.dao.UserDAO;
import com.voting.model.AuditLog;
import com.voting.model.User;

@WebServlet("/user")
public class UserServlet extends HttpServlet{
	private static final long serialVersionUID = 1L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    String action = request.getParameter("action");
	    
	    HttpSession session = request.getSession(false);
	    if (session == null || session.getAttribute("user") == null) {
	        response.sendRedirect(request.getContextPath() + "/login.jsp");
	        return;
	    }
	    
	    if ("profile".equals(action)) {
	        request.getRequestDispatcher("/profile.jsp").forward(request, response);
	    } else {
	        // Redirect to role-specific dashboard
	        User user = (User) session.getAttribute("user");
	        if ("ADMIN".equalsIgnoreCase(user.getRoleName())) {
	            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
	        } else if ("ELECTION_OFFICER".equalsIgnoreCase(user.getRoleName())) {
	            response.sendRedirect(request.getContextPath() + "/officer/dashboard.jsp");
	        } else {
	            response.sendRedirect(request.getContextPath() + "/voter/dashboard.jsp");
	        }
	    }
	}
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	String action = request.getParameter("action");
    	
    	if ("register".equals(action)) {
    		processRegistration(request, response);
    	} else if ("update".equals(action)) {
    		processUpdate(request, response);
    	} else if ("changepassword".equals(action)) {
    		processChangePassword(request, response);
    	} else {
    		response.sendRedirect("dashboard.jsp");
    	}
    }
    
    private void showProfile(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;  // Important: Add return to stop further execution
        }
        
        // Forward to profile page if session is valid
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
    
    private void processRegistration(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	String username = request.getParameter("username");
    	String email = request.getParameter("email");
    	String password = request.getParameter("password");
    	String firstName = request.getParameter("firstName");
    	String lastName = request.getParameter("lastName");
    	String phone = request.getParameter("phone");
    	
    	try {
    		Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
    		UserDAO userDAO = new UserDAO(conn);
    		AuditLogDAO auditLogDAO = new AuditLogDAO(conn);
    		
    		if (userDAO.usernameExists(username)) {
    			response.sendRedirect("register.jsp?error=Username already exists");
                return;
    		}
    		
    		if (userDAO.emailExists(username)) {
    			response.sendRedirect("Regiester.jsp?error=Username already exist");
    		}
    		
    		User user = new User(username, email, UserDAO.hashPassword(password), firstName, lastName, 3);
    		user.setPhone(phone);
    		
    		if (userDAO.createUser(user)) {
    			AuditLog auditLog = new AuditLog();
                auditLog.setUserId(user.getUserId());
                auditLog.setActionType("REGISTRATION");
                auditLog.setDetails("New user registered");
                auditLog.setIpAddress(request.getRemoteAddr());
                auditLogDAO.logAction(auditLog);
                //lagay nyo after nung jsp string for future debugging
                //?message=Registration successful. Please login.
                response.sendRedirect("login.jsp?message=Registration successful. Please login.");
    		} else {
    			//?error=Registration failed
    			response.sendRedirect("register.jsp?error=Registration failed");
    		}
    	} catch(SQLException e) {
    		e.printStackTrace();
    		//?error=Database error
    		response.sendRedirect("register.jsp?error=Database error");
    	}
    }
    
    private void processUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	HttpSession session = request.getSession(false);
    	if (session == null || session.getAttribute("user") == null) {
    		response.sendRedirect("login.jsp");
    		return;
    	 }
    	 
    	 User currentUser = (User) session.getAttribute("user");
    	 
    	 String email = request.getParameter("email");
    	 String firstName = request.getParameter("firstName");
    	 String lastName = request.getParameter("lastName");
    	 String phone = request.getParameter("phone");
    	 
    	 try {
    		 Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
    		 UserDAO userDAO = new UserDAO(conn);
    		 AuditLogDAO auditLogDAO = new AuditLogDAO(conn);
    		 
    		 if (!email.equals(currentUser.getEmail())) {
    			 if (userDAO.emailExists(email)) {
    				 //?error=Email already exists
    				 response.sendRedirect("profile.jsp?error=Email already exists");
    				 return;
    			 }
    		 }
    		 
    		 currentUser.setEmail(email);
             currentUser.setFirstName(firstName);
             currentUser.setLastName(lastName);
             currentUser.setPhone(phone);
             
             if (userDAO.updateUser(currentUser)) {
                 // Update session
                 session.setAttribute("user", currentUser);
                 
                 // Log profile update
                 AuditLog auditLog = new AuditLog();
                 auditLog.setUserId(currentUser.getUserId());
                 auditLog.setActionType("PROFILE_UPDATE");
                 auditLog.setDetails("User updated profile");
                 auditLog.setIpAddress(request.getRemoteAddr());
                 auditLogDAO.logAction(auditLog);
                 
                 //?message=Profile updated successfully
                 response.sendRedirect("profile.jsp?message=Profile updated successfully");
             } else {
            	 //?error=Profile update failed
                 response.sendRedirect("profile.jsp?error=Profile update failed");
             }
             
    	 } catch(SQLException e) {
    		 e.printStackTrace();
    		 //?error=Database error
    		 response.sendRedirect("profile.jsp");
    	 }
    }
    
    private void processChangePassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        
        try {
            Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
            UserDAO userDAO = new UserDAO(conn);
            
            // Debug output
            System.out.println("Attempting password change for user: " + currentUser.getUsername());
            
            if (!UserDAO.verifyPassword(currentPassword, currentUser.getPasswordHash())) {
                System.out.println("Current password verification failed");
                response.sendRedirect(request.getContextPath() + "/profile.jsp?error=Current+password+incorrect");
                return;
            }
            
            // Update password
            String newPasswordHash = UserDAO.hashPassword(newPassword);
            if (userDAO.updatePassword(currentUser.getUserId(), newPasswordHash)) {
                // Update session
                currentUser.setPasswordHash(newPasswordHash);
                session.setAttribute("user", currentUser);
                
                // Debug
                System.out.println("Password changed successfully, redirecting to profile");
                
                // Explicit redirect to profile.jsp
                response.sendRedirect(request.getContextPath() + "/profile.jsp?message=Password+changed+successfully");
            } else {
                System.out.println("Password update failed in database");
                response.sendRedirect(request.getContextPath() + "/profile.jsp?error=Password+update+failed");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Database error during password change: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/profile.jsp?error=Database+error");
        }
    }
}
