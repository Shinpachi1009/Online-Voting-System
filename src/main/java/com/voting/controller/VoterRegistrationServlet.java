package com.voting.controller;

import com.voting.dao.VoterDAO;
import com.voting.model.User;
import com.voting.model.Voter;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/voter-registration")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class VoterRegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        request.getRequestDispatcher("/voter-registration/voterRegistration.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        
        try {
            // Validate form data
            String voterIdNumber = validateVoterId(request.getParameter("voterIdNumber"));
            Date dateOfBirth = validateDateOfBirth(request.getParameter("dateOfBirth"));
            String address = validateAddress(request.getParameter("address"));
            String district = validateDistrict(request.getParameter("district"));
            Part filePart = validateFilePart(request.getPart("idDocument"));

            // Handle file upload
            String fileName = processFileUpload(filePart, request);
            
            // Register voter
            Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
            VoterDAO voterDAO = new VoterDAO(conn);
            
            if (voterDAO.getVoterByUserId(user.getUserId()) != null) {
                throw new ServletException("You are already registered as a voter");
            }

            Voter voter = createVoter(user.getUserId(), voterIdNumber, dateOfBirth, address, district, fileName);
            
            if (!voterDAO.registerVoter(voter)) {
                throw new ServletException("Failed to register voter");
            }

            // Success - redirect to confirmation page
            response.sendRedirect(request.getContextPath() + "/voter-registration/voterRegistrationSuccess.jsp");
            
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/voter-registration/voterRegistration.jsp").forward(request, response);
        }
    }

    // Helper methods
    private String validateVoterId(String voterId) throws ServletException {
        if (voterId == null || voterId.trim().isEmpty()) {
            throw new ServletException("Voter ID is required");
        }
        // Add additional validation if needed
        return voterId.trim();
    }

    private Date validateDateOfBirth(String dobString) throws ServletException {
        if (dobString == null || dobString.trim().isEmpty()) {
            throw new ServletException("Date of birth is required");
        }
        try {
            return Date.valueOf(dobString);
        } catch (IllegalArgumentException e) {
            throw new ServletException("Invalid date format");
        }
    }

    private String validateAddress(String address) throws ServletException {
        if (address == null || address.trim().isEmpty()) {
            throw new ServletException("Address is required");
        }
        return address.trim();
    }

    private String validateDistrict(String district) throws ServletException {
        if (district == null || district.trim().isEmpty()) {
            throw new ServletException("District is required");
        }
        return district.trim();
    }

    private Part validateFilePart(Part filePart) throws ServletException {
        if (filePart == null || filePart.getSize() == 0) {
            throw new ServletException("ID document is required");
        }
        
        // Validate file type
        String contentType = filePart.getContentType();
        if (!contentType.startsWith("image/") && !contentType.equals("application/pdf")) {
            throw new ServletException("Only images and PDF files are allowed");
        }
        
        return filePart;
    }

    private String processFileUpload(Part filePart, HttpServletRequest request) 
            throws IOException, ServletException {
        // Create uploads directory if it doesn't exist
        String uploadDir = getServletContext().getRealPath("/uploads");
        File uploadDirFile = new File(uploadDir);
        if (!uploadDirFile.exists()) {
            uploadDirFile.mkdirs();
        }

        // Generate unique filename
        String fileName = System.currentTimeMillis() + "_" + getFileName(filePart);
        String filePath = uploadDir + File.separator + fileName;
        
        // Save file
        filePart.write(filePath);
        
        return "uploads/" + fileName;
    }

    private Voter createVoter(int userId, String voterIdNumber, Date dateOfBirth, 
                            String address, String district, String documentPath) {
        Voter voter = new Voter();
        voter.setUserId(userId);
        voter.setVoterIdNumber(voterIdNumber);
        voter.setDateOfBirth(dateOfBirth);
        voter.setAddress(address);
        voter.setDistrict(district);
        voter.setDocumentPath(documentPath);
        return voter;
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                // Extract filename and sanitize it
                String fileName = token.substring(token.indexOf("=") + 2, token.length()-1);
                return fileName.replaceAll("[^a-zA-Z0-9.-]", "_");
            }
        }
        return "unknown";
    }
}