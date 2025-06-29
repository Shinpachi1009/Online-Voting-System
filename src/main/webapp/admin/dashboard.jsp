<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="com.voting.model.User" %>
<%@page import="com.voting.dao.ElectionDAO" %>
<%@page import="com.voting.dao.CandidateDAO" %>
<%@page import="com.voting.dao.VoteDAO" %>
<%@page import="java.sql.Connection" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
    ElectionDAO electionDAO = new ElectionDAO(conn);
    CandidateDAO candidateDAO = new CandidateDAO(conn);
    VoteDAO voteDAO = new VoteDAO(conn);
    
    // Get counts for dashboard
    int activeElections = electionDAO.getActiveElections().size();
    int totalCandidates = candidateDAO.getAllCandidates().size();
    int totalVotes = voteDAO.getTotalVotesCount();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.png" type="image/x-icon">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar-style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-dashboard-style.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="admin-container">
        <div class="welcome-card">
            <h4 class="welcome-header">
                <i class="fas fa-user-shield"></i> Admin Officer
            </h4>
            <div class="alert alert-info">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <strong><i class="fas fa-user"></i> Welcome:</strong> ${user.firstName} ${user.lastName}<br>
                        <strong><i class="fas fa-clock"></i> Last Login:</strong> 
                        <c:choose>
                            <c:when test="${empty user.lastLogin}">Never</c:when>
                            <c:otherwise>${user.lastLogin}</c:otherwise>
                        </c:choose>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/election?action=new" class="btn btn-primary">
                            <i class="fas fa-plus-circle"></i> Create Election
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Quick Stats -->
        <div class="stats-grid">
            <div class="stat-card" style="border-left-color: #0062cc;">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="stat-label">Active Elections</div>
                        <div class="stat-value text-primary"><%= activeElections %></div>
                    </div>
                    <i class="fas fa-vote-yea text-primary"></i>
                </div>
            </div>
            
            <div class="stat-card" style="border-left-color: #28a745;">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="stat-label">Total Candidates</div>
                        <div class="stat-value text-success"><%= totalCandidates %></div>
                    </div>
                    <i class="fas fa-users text-success"></i>
                </div>
            </div>
            
            <div class="stat-card" style="border-left-color: #17a2b8;">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="stat-label">Votes Cast</div>
                        <div class="stat-value text-info"><%= totalVotes %></div>
                    </div>
                    <i class="fas fa-check-circle text-info"></i>
                </div>
            </div>
            
            <div class="stat-card" style="border-left-color: #ffc107;">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="stat-label">Pending Actions</div>
                        <div class="stat-value text-warning">0</div>
                    </div>
                    <i class="fas fa-exclamation-circle text-warning"></i>
                </div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="action-card">
            <div class="card-header bg-primary">
                <i class="fas fa-bolt"></i> Quick Actions
            </div>
            <div class="card-body">
                <a href="election?action=manage" class="btn btn-success">
                    <i class="fas fa-edit"></i> Manage Elections
                </a>
                <a href="candidate?action=list" class="btn btn-info">
                    <i class="fas fa-users"></i> View Candidates
                </a>
                <a href="votes.jsp" class="btn btn-warning">
                    <i class="fas fa-poll"></i> View Votes
                </a>
            </div>
        </div>
        
        <!-- Main Sections -->
        <div class="row">
            <div class="col-md-6">
                <div class="action-card">
                    <div class="card-header bg-success">
                        <i class="fas fa-vote-yea"></i> Election Management
                    </div>
                    <div class="card-body">
                        <div class="list-group">
                            <a href="election?action=list&status=active" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                Active Elections
                                <span class="badge badge-primary badge-pill"><%= activeElections %></span>
                            </a>
                            <a href="election?action=list&status=upcoming" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                Upcoming Elections
                                <span class="badge badge-info badge-pill"><%= electionDAO.getElectionsByStatus("UPCOMING").size() %></span>
                            </a>
                            <a href="election?action=list&status=completed" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                Completed Elections
                                <span class="badge badge-secondary badge-pill"><%= electionDAO.getElectionsByStatus("COMPLETED").size() %></span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="action-card">
                    <div class="card-header bg-info">
                        <i class="fas fa-users"></i> Candidate Management
                    </div>
                    <div class="card-body">
                        <div class="list-group">
                            <a href="candidate?action=list" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                All Candidates
                                <span class="badge badge-success badge-pill"><%= totalCandidates %></span>
                            </a>
                            <%
                                if (activeElections > 0) {
                                    int firstElectionId = electionDAO.getActiveElections().get(0).getElectionId();
                            %>
                            <a href="candidate?action=list&election=<%= firstElectionId %>" class="list-group-item list-group-item-action">
                                <%= electionDAO.getElectionById(firstElectionId).getTitle() %> Candidates
                            </a>
                            <%
                                }
                            %>
                            <a href="candidate?action=pending" class="list-group-item list-group-item-action">
                                New Candidate Applications
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-md-6">
                <div class="action-card">
                    <div class="card-header bg-warning">
                        <i class="fas fa-poll"></i> Voting Activity
                    </div>
                    <div class="card-body">
                        <div class="list-group">
                            <a href="vote?action=recent" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                Recent Votes
                                <span class="badge badge-info badge-pill"><%= voteDAO.getRecentVotesCount(24) %></span>
                            </a>
                            <%
                                if (activeElections > 0) {
                                    int firstElectionId = electionDAO.getActiveElections().get(0).getElectionId();
                            %>
                            <a href="vote?action=list&election=<%= firstElectionId %>" class="list-group-item list-group-item-action">
                                <%= electionDAO.getElectionById(firstElectionId).getTitle() %> Votes
                            </a>
                            <%
                                }
                            %>
                            <a href="results.jsp" class="list-group-item list-group-item-action">
                                <i class="fas fa-chart-bar mr-2"></i>View Results
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>