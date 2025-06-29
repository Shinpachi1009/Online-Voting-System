<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="com.voting.model.User" %>
<%@page import="com.voting.dao.ElectionDAO" %>
<%@page import="com.voting.dao.CandidateDAO" %>
<%@page import="com.voting.dao.VoteDAO" %>
<%@page import="java.sql.Connection" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
    ElectionDAO electionDAO = new ElectionDAO(conn);
    request.setAttribute("elections", electionDAO.getActiveElections());
    
    CandidateDAO candidateDAO = new CandidateDAO(conn);
    boolean isCandidate = candidateDAO.isUserCandidate(user.getUserId());
    request.setAttribute("isCandidate", isCandidate);
    
    VoteDAO voteDAO = new VoteDAO(conn);
    request.setAttribute("voteDAO", voteDAO);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Voter Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar-style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/voter-dashboard-style.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="voter-container">
        <div class="welcome-card">
            <div class="d-flex justify-content-between align-items-center">
                <h4 class="welcome-header">
                    <i class="fas fa-user"></i> Voter Dashboard
                </h4>
                <c:if test="${not isCandidate}">
                    <a href="${pageContext.request.contextPath}/candidate?action=register" class="btn btn-primary">
                        <i class="fas fa-user-tie"></i> Become a Candidate
                    </a>
                </c:if>
            </div>
            
            <div class="alert alert-info">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h5>Welcome, ${user.firstName} ${user.lastName}</h5>
                        <p class="mb-0">Participate in active elections below</p>
                    </div>
                    <div class="text-right">
                        <p class="mb-0"><strong>Role:</strong> ${user.roleName}</p>
                        <p class="mb-0"><strong>Last Login:</strong> 
                            <c:choose>
                                <c:when test="${empty user.lastLogin}">First time</c:when>
                                <c:otherwise>${user.lastLogin}</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
            </div>
            
            <c:if test="${isCandidate}">
                <div class="alert alert-warning">
                    <h5><i class="fas fa-user-tie"></i> You are registered as a candidate</h5>
                    <p class="mb-0">You can participate in elections both as a voter and candidate.</p>
                </div>
            </c:if>
        </div>
        
        <h4 class="mb-4" style="color:  #ffffff;"><i class="fas fa-vote-yea"></i> Active Elections</h4>
        
        <c:choose>
            <c:when test="${not empty elections}">
                <div class="election-grid">
                    <c:forEach items="${elections}" var="election">
                        <div class="election-card">
                            <c:if test="${isCandidate}">
                                <span class="candidate-badge">Candidate</span>
                            </c:if>
                            <div class="election-card-header">
                                <h5 class="election-title">${election.title}</h5>
                                <span class="badge badge-success">${election.status}</span>
                            </div>
                            <div class="election-card-body">
                                <p class="election-description">${election.description}</p>
                                <p class="election-meta">
                                    <strong>Period:</strong> ${election.startDate} to ${election.endDate}
                                </p>
                                
                                <div class="election-actions">
                                    <a href="election?action=view&id=${election.electionId}" 
                                       class="btn btn-primary">
                                        <i class="fas fa-eye"></i> View Election
                                    </a>
                                    
                                    <c:set var="hasVoted" value="${voteDAO.hasVoted(user.userId, election.electionId)}" />
                                    <span class="badge ${hasVoted ? 'badge-success' : 'badge-warning'}">
                                        ${hasVoted ? 'Voted' : 'Not Voted'}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i> No active elections at this time. Please check back later.
                </div>
            </c:otherwise>
        </c:choose>
        
        <c:if test="${isCandidate}">
            <div class="welcome-card mt-4">
                <h4 class="welcome-header">
                    <i class="fas fa-user-tie"></i> Your Candidacy
                </h4>
                <div class="alert alert-info">
                    <p>As a candidate, you can:</p>
                    <ul>
                        <li>Appear in election ballots</li>
                        <li>Receive votes from other users</li>
                        <li>View election results</li>
                    </ul>
                    <a href="candidate?action=list" class="btn btn-outline-info">
                        <i class="fas fa-users"></i> View All Candidates
                    </a>
                </div>
            </div>
        </c:if>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>