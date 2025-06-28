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
    <title>Admin Dashboard - Online Voting System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        .card-hover:hover {
            transform: translateY(-5px);
            transition: transform 0.3s;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .stat-card {
            border-left: 4px solid;
        }
        .stat-card .card-body {
            padding: 1rem;
        }
        .stat-card i {
            font-size: 2rem;
            opacity: 0.7;
        }
        .quick-action-btn {
            transition: all 0.3s;
        }
        .quick-action-btn:hover {
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row mb-4">
            <div class="col-md-12">
                <h2><i class="fas fa-tachometer-alt"></i> Admin Dashboard</h2>
                <p class="text-muted">Welcome back, ${user.firstName}! Here's what's happening today.</p>
            </div>
        </div>
        
        <!-- Quick Stats Row -->
        <div class="row mb-4">
            <div class="col-md-3 mb-3">
                <div class="card stat-card border-left-primary h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="text-uppercase text-muted">Active Elections</h6>
                                <h2 class="mb-0"><%= activeElections %></h2>
                            </div>
                            <div class="text-primary">
                                <i class="fas fa-vote-yea"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card stat-card border-left-success h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="text-uppercase text-muted">Total Candidates</h6>
                                <h2 class="mb-0"><%= totalCandidates %></h2>
                            </div>
                            <div class="text-success">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card stat-card border-left-info h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="text-uppercase text-muted">Votes Cast</h6>
                                <h2 class="mb-0"><%= totalVotes %></h2>
                            </div>
                            <div class="text-info">
                                <i class="fas fa-check-circle"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card stat-card border-left-warning h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="text-uppercase text-muted">Pending Actions</h6>
                                <h2 class="mb-0">0</h2>
                            </div>
                            <div class="text-warning">
                                <i class="fas fa-exclamation-circle"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Quick Actions</h5>
                        <div class="d-flex flex-wrap">
                            <a href="electionCreate.jsp" class="btn btn-primary m-2 quick-action-btn">
                                <i class="fas fa-plus-circle mr-2"></i>Create Election
                            </a>
                            <a href="election?action=manage" class="btn btn-success m-2 quick-action-btn">
                                <i class="fas fa-edit mr-2"></i>Manage Elections
                            </a>
                            <a href="candidate?action=list" class="btn btn-info m-2 quick-action-btn">
                                <i class="fas fa-users mr-2"></i>View Candidates
                            </a>
                            <a href="votes.jsp" class="btn btn-warning m-2 quick-action-btn">
                                <i class="fas fa-poll mr-2"></i>View Votes
                            </a>
                            <a href="users.jsp" class="btn btn-dark m-2 quick-action-btn">
                                <i class="fas fa-user-cog mr-2"></i>Manage Users
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Main Cards Row -->
        <div class="row">
            <div class="col-md-6 mb-4">
                <div class="card card-hover h-100">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5><i class="fas fa-vote-yea mr-2"></i>Election Management</h5>
                        <a href="${pageContext.request.contextPath}/election?action=new" class="btn btn-light btn-sm">+ New</a>
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
            
            <div class="col-md-6 mb-4">
                <div class="card card-hover h-100">
                    <div class="card-header bg-success text-white">
                        <h5><i class="fas fa-users mr-2"></i>Candidate Management</h5>
                    </div>
                    <div class="card-body">
                        <div class="list-group">
                            <a href="candidate?action=list" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                All Candidates
                                <span class="badge badge-success badge-pill"><%= totalCandidates %></span>
                            </a>
                            <%
                                // Get first active election for example link
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
        
        <!-- Second Row -->
        <div class="row">
            <div class="col-md-6 mb-4">
                <div class="card card-hover h-100">
                    <div class="card-header bg-info text-white">
                        <h5><i class="fas fa-poll mr-2"></i>Voting Activity</h5>
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
            
            <div class="col-md-6 mb-4">
                <div class="card card-hover h-100">
                    <div class="card-header bg-dark text-white">
                        <h5><i class="fas fa-cogs mr-2"></i>System Management</h5>
                    </div>
                    <div class="card-body">
                        <div class="list-group">
                            <a href="user?action=list" class="list-group-item list-group-item-action">
                                <i class="fas fa-users-cog mr-2"></i>User Accounts
                            </a>
                            <a href="audit.jsp" class="list-group-item list-group-item-action">
                                <i class="fas fa-clipboard-list mr-2"></i>Audit Logs
                            </a>
                            <a href="settings.jsp" class="list-group-item list-group-item-action">
                                <i class="fas fa-sliders-h mr-2"></i>System Settings
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Recent Activity -->
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-secondary text-white">
                        <h5><i class="fas fa-history mr-2"></i>Recent Activity</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Time</th>
                                        <th>Activity</th>
                                        <th>User</th>
                                        <th>Details</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Sample data - in real app, fetch from database -->
                                    <tr>
                                        <td>10 min ago</td>
                                        <td>New vote cast</td>
                                        <td>john_doe</td>
                                        <td>Voted for President</td>
                                    </tr>
                                    <tr>
                                        <td>25 min ago</td>
                                        <td>New candidate</td>
                                        <td>jane_smith</td>
                                        <td>Registered for Vice President</td>
                                    </tr>
                                    <tr>
                                        <td>1 hour ago</td>
                                        <td>Election created</td>
                                        <td>admin</td>
                                        <td>Student Council Election</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>