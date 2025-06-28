<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

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
    
    // Get database connection
    Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
    
    // Get active elections
    ElectionDAO electionDAO = new ElectionDAO(conn);
    request.setAttribute("elections", electionDAO.getActiveElections());
    
    // Check if user is a candidate
    CandidateDAO candidateDAO = new CandidateDAO(conn);
    boolean isCandidate = candidateDAO.isUserCandidate(user.getUserId());
    request.setAttribute("isCandidate", isCandidate);
    
    // Get vote status for each election
    VoteDAO voteDAO = new VoteDAO(conn);
    request.setAttribute("voteDAO", voteDAO);
%>

<html>
<head>
    <meta charset="UTF-8">
    <title>Voter Dashboard - Online Voting System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .election-card {
            transition: transform 0.2s;
            margin-bottom: 20px;
        }
        .election-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .candidate-badge {
            position: absolute;
            top: 10px;
            right: 10px;
        }
    </style>
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-12">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <div class="d-flex justify-content-between align-items-center">
                            <h4 class="mb-0">Voter Dashboard</h4>
                            <c:if test="${not isCandidate}">
                                <a href="${pageContext.request.contextPath}/candidate?action=register" class="btn btn-light btn-sm">Become a Candidate</a>
                            </c:if>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-info">
                            <div class="d-flex justify-content-between">
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
                            <div class="alert alert-warning mb-4">
                                <h5><i class="fas fa-user-tie"></i> You are registered as a candidate</h5>
                                <p class="mb-0">You can participate in elections both as a voter and candidate.</p>
                            </div>
                        </c:if>
                        
                        <h4 class="mb-3">Active Elections</h4>
                        
                        <c:choose>
                            <c:when test="${not empty elections}">
                                <div class="row">
                                    <c:forEach items="${elections}" var="election">
                                        <div class="col-md-6">
                                            <div class="card election-card">
                                                <div class="card-header">
                                                    <div class="d-flex justify-content-between">
                                                        <h5>${election.title}</h5>
                                                        <span class="badge badge-success">${election.status}</span>
                                                    </div>
                                                </div>
                                                <div class="card-body">
                                                    <p class="card-text">${election.description}</p>
                                                    <p class="card-text">
                                                        <small class="text-muted">
                                                            <strong>Period:</strong> ${election.startDate} to ${election.endDate}
                                                        </small>
                                                    </p>
                                                    
                                                    <div class="d-flex justify-content-between align-items-center mt-3">
                                                        <a href="election?action=view&id=${election.electionId}" 
                                                           class="btn btn-primary btn-sm">
                                                            View Election
                                                        </a>
                                                        
                                                        <c:set var="hasVoted" value="${voteDAO.hasVoted(user.userId, election.electionId)}" />
                                                        <span class="badge ${hasVoted ? 'badge-success' : 'badge-warning'}">
                                                            ${hasVoted ? 'Voted' : 'Not Voted'}
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    No active elections at this time. Please check back later.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <c:if test="${isCandidate}">
                    <div class="card">
                        <div class="card-header bg-info text-white">
                            <h5 class="mb-0">Your Candidacy</h5>
                        </div>
                        <div class="card-body">
                            <p>As a candidate, you can:</p>
                            <ul>
                                <li>Appear in election ballots</li>
                                <li>Receive votes from other users</li>
                                <li>View election results</li>
                            </ul>
                            <a href="candidate?action=list" class="btn btn-outline-info">
                                View All Candidates
                            </a>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</body>
</html>