package com.voting.filter;

import com.voting.dao.UserDAO;
import com.voting.model.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/*")
public class AutoLoginFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Check if user is not already logged in
        if (session == null || session.getAttribute("user") == null) {
            // Check for remember me cookies
            Cookie[] cookies = httpRequest.getCookies();
            String rememberToken = null;
            String userID = null;
            
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("rememberToken".equals(cookie.getName())) {
                        rememberToken = cookie.getValue();
                    } else if ("userID".equals(cookie.getName())) {
                        userID = cookie.getValue();
                    }
                }
            }
            
            // If both cookies exist, try to auto-login
            if (rememberToken != null && userID != null) {
                try {
                    Connection conn = (Connection) httpRequest.getServletContext().getAttribute("DBConnection");
                    UserDAO userDAO = new UserDAO(conn);
                    
                    // Verify the token
                    User user = userDAO.getUserByRememberToken(rememberToken);
                    if (user != null && String.valueOf(user.getUserId()).equals(userID)) {
                        // Token is valid - create session
                        HttpSession newSession = httpRequest.getSession();
                        newSession.setAttribute("user", user);
                        
                        // Update last login time
                        userDAO.updateLastLogin(user.getUserId());
                    } else {
                        // Invalid token - clear cookies
                        clearRememberCookies(httpResponse, httpRequest.getContextPath());
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    clearRememberCookies(httpResponse, httpRequest.getContextPath());
                }
            }
        }
        
        chain.doFilter(request, response);
    }
    
    private void clearRememberCookies(HttpServletResponse response, String contextPath) {
        Cookie tokenCookie = new Cookie("rememberToken", "");
        tokenCookie.setMaxAge(0);
        tokenCookie.setPath(contextPath);
        response.addCookie(tokenCookie);
        
        Cookie userCookie = new Cookie("userID", "");
        userCookie.setMaxAge(0);
        userCookie.setPath(contextPath);
        response.addCookie(userCookie);
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}