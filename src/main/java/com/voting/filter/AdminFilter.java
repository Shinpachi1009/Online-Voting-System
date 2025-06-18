package com.voting.filter;

import com.voting.model.User;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/admin/*")
public class AdminFilter implements Filter {
    
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Bypass filter for specific pages
        if (httpRequest.getRequestURI().endsWith("login.jsp") || 
            httpRequest.getRequestURI().contains("/resources/")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check session and user
        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equalsIgnoreCase(user.getRoleName())) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/accessDenied.jsp");
            return;
        }
        
        // Add cache control headers
        httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        httpResponse.setHeader("Pragma", "no-cache");
        httpResponse.setDateHeader("Expires", 0);
        
        chain.doFilter(request, response);
    }

    public void init(FilterConfig filterConfig) throws ServletException {}
    public void destroy() {}
}