<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<%@page import="com.voting.model.User" %>
<%@page import="com.voting.dao.CandidateDAO" %>
<%@page import="java.sql.Connection" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    int electionId = Integer.parseInt(request.getParameter("electionId"));
    int positionId = Integer.parseInt(request.getParameter("positionId"));
    
    Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
    CandidateDAO candidateDAO = new CandidateDAO(conn);
    request.setAttribute("candidates", candidateDAO.getCandidatesByPositionId(positionId));
    request.setAttribute("electionId", electionId);
    request.setAttribute("positionId", positionId);
%>

<html>
<head>
    <meta charset="UTF-8">
    <title>Cast Your Vote - Online Voting System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .candidate-card {
            transition: all 0.3s;
            margin-bottom: 20px;
            cursor: pointer;
        }
        .candidate-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .candidate-card.selected {
            border: 2px solid #007bff;
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h4>Cast Your Vote</h4>
                    </div>
                    <div class="card-body">
                        <h5>Select your candidate:</h5>
                        
                        <form action="vote" method="post">
                            <input type="hidden" name="action" value="cast">
                            <input type="hidden" name="electionId" value="${electionId}">
                            <input type="hidden" name="positionId" value="${positionId}">
                            
                            <div class="row">
                                <c:forEach items="${candidates}" var="candidate">
                                    <div class="col-md-6">
                                        <div class="card candidate-card" onclick="selectCandidate(this, ${candidate.candidateId})">
                                            <div class="card-body">
                                                <h5 class="card-title">${candidate.fullName}</h5>
                                                <h6 class="card-subtitle mb-2 text-muted">${candidate.username}</h6>
                                                <p class="card-text">${candidate.bio}</p>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" 
                                                           name="candidateId" id="candidate-${candidate.candidateId}" 
                                                           value="${candidate.candidateId}" required>
                                                    <label class="form-check-label" for="candidate-${candidate.candidateId}">
                                                        Select this candidate
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            
                            <div class="mt-4">
                                <button type="submit" class="btn btn-primary btn-lg btn-block">Submit Vote</button>
                                <a href="election?action=view&id=${electionId}" class="btn btn-secondary btn-block mt-2">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function selectCandidate(cardElement, candidateId) {
            // Unselect all cards first
            document.querySelectorAll('.candidate-card').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Select the clicked card
            cardElement.classList.add('selected');
            
            // Check the radio button
            document.getElementById('candidate-' + candidateId).checked = true;
        }
    </script>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>