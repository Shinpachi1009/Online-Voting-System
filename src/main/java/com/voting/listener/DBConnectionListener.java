package com.voting.listener;

import com.voting.dao.UserDAO;
import com.voting.model.User;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class DBConnectionListener implements ServletContextListener {
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            // Load Derby driver
            Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
            
            // Create connection - using absolute path with create=true
            Connection conn = DriverManager.getConnection("jdbc:derby:C:\\Users\\uriur\\VotingDB;create=true");
            
            // Initialize database tables and admin account
            initializeDatabase(conn);
            
            // Store connection in application scope
            ServletContext ctx = sce.getServletContext();
            ctx.setAttribute("DBConnection", conn);
            
            System.out.println("Database connection initialized for Online Voting System");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize database connection", e);
        }
    }
    
    private void initializeDatabase(Connection conn) throws SQLException {
        // Create tables if they don't exist
        createTables(conn);
        
        // Ensure admin account exists with correct password
        ensureAdminAccount(conn);
    }
    
    private void createTables(Connection conn) throws SQLException {
        try (Statement stmt = conn.createStatement()) {
            // Create roles table if it doesn't exist
            stmt.executeUpdate("CREATE TABLE roles ("
                + "role_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,"
                + "role_name VARCHAR(20) NOT NULL UNIQUE)");
            
            // Create users table if it doesn't exist
            stmt.executeUpdate("CREATE TABLE users ("
                + "user_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,"
                + "username VARCHAR(50) NOT NULL UNIQUE,"
                + "email VARCHAR(100) NOT NULL UNIQUE,"
                + "password_hash VARCHAR(100) NOT NULL,"
                + "first_name VARCHAR(50) NOT NULL,"
                + "last_name VARCHAR(50) NOT NULL,"
                + "phone VARCHAR(20),"
                + "role_id INT NOT NULL REFERENCES roles(role_id),"
                + "status VARCHAR(20) DEFAULT 'ACTIVE',"
                + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
                + "last_login TIMESTAMP)");
            
            System.out.println("Tables created or already existed");
        } catch (SQLException e) {
            // Ignore if tables already exist
            if (!e.getSQLState().equals("X0Y32")) {
                throw e;
            }
        }
    }
    
    private void ensureAdminAccount(Connection conn) throws SQLException {
        // Insert default roles if they don't exist
        insertDefaultRoles(conn);
        
        // Check if admin exists
        boolean adminExists = false;
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT 1 FROM users WHERE username = 'admin'")) {
            adminExists = rs.next();
        }
        
        String hashedPassword = UserDAO.hashPassword("admin123");
        
        if (!adminExists) {
            // Create admin account
            try (PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO users (username, email, password_hash, first_name, last_name, role_id) "
                    + "VALUES ('admin', 'admin@voting.com', ?, 'System', 'Administrator', 1)")) {
                pstmt.setString(1, hashedPassword);
                pstmt.executeUpdate();
                System.out.println("Admin account created with password: admin123");
            }
        } else {
            // Update admin password to ensure it's correct
            try (PreparedStatement pstmt = conn.prepareStatement(
                    "UPDATE users SET password_hash = ? WHERE username = 'admin'")) {
                pstmt.setString(1, hashedPassword);
                pstmt.executeUpdate();
                System.out.println("Admin password reset to: admin123");
            }
        }
    }
    
    private void insertDefaultRoles(Connection conn) throws SQLException {
        try (Statement stmt = conn.createStatement()) {
            // Check if roles exist first
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM roles");
            rs.next();
            if (rs.getInt(1) == 0) {
                stmt.executeUpdate("INSERT INTO roles (role_name) VALUES ('ADMIN')");
                stmt.executeUpdate("INSERT INTO roles (role_name) VALUES ('ELECTION_OFFICER')");
                stmt.executeUpdate("INSERT INTO roles (role_name) VALUES ('VOTER')");
                System.out.println("Default roles inserted");
            }
        }
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        Connection conn = (Connection) sce.getServletContext().getAttribute("DBConnection");
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
                System.out.println("Database connection closed");
                
                // Shutdown Derby
                try {
                    DriverManager.getConnection("jdbc:derby:C:\\Users\\uriur\\VotingDB;create=true");
                } catch (SQLException e) {
                    // Expected exception on shutdown
                    if (!"XJ015".equals(e.getSQLState())) {
                        throw e;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}