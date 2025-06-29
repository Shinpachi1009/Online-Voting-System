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
    <title>Cast Your Vote</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.png" type="image/x-icon">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar-style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ballot-style.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="ballot-container">
        <div class="welcome-card">
            <h4 class="welcome-header">
                <i class="fas fa-vote-yea"></i> Cast Your Vote
            </h4>
            <div class="alert alert-info">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <strong><i class="fas fa-info-circle"></i> Please select your candidate:</strong> 
                        Your vote is confidential and cannot be changed once submitted
                    </div>
                    <div>
                        <a href="election?action=view&id=${electionId}" class="btn btn-primary">
                            <i class="fas fa-arrow-left"></i> Back to Election
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="action-card">
            <div class="card-header bg-primary">
                <i class="fas fa-users"></i> Candidates
            </div>
            <div class="card-body">
                <form action="vote" method="post">
                    <input type="hidden" name="action" value="cast">
                    <input type="hidden" name="electionId" value="${electionId}">
                    <input type="hidden" name="positionId" value="${positionId}">
                    
                    <div class="row">
                        <c:forEach items="${candidates}" var="candidate">
                            <div class="col-md-6">
                                <div class="candidate-card" onclick="selectCandidate(this, ${candidate.candidateId})">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center">
                                            <div class="candidate-avatar">
                                                <i class="fas fa-user-circle"></i>
                                            </div>
                                            <div class="ml-3">
                                                <h5 class="card-title mb-1">${candidate.fullName}</h5>
                                                <h6 class="card-subtitle text-muted">@${candidate.username}</h6>
                                            </div>
                                        </div>
                                        <p class="card-text mt-3">${candidate.bio}</p>
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
                    
                    <div class="mt-4 d-flex justify-content-between">
                        <button type="submit" class="btn btn-success btn-lg">
                            <i class="fas fa-check-circle"></i> Submit Vote
                        </button>
                        <a href="election?action=view&id=${electionId}" class="btn btn-secondary btn-lg">
                            <i class="fas fa-times-circle"></i> Cancel
                        </a>
                    </div>
                </form>
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