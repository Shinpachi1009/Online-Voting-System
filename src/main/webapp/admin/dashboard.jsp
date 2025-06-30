<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="com.voting.model.User" %>
<%@page import="com.voting.dao.ElectionDAO" %>
<%@page import="com.voting.dao.CandidateDAO" %>
<%@page import="com.voting.dao.VoteDAO" %>
<%@page import="com.voting.dao.VoterDAO" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.util.List" %>
<%@page import="com.voting.model.Candidate" %>
<%@page import="com.voting.model.Voter" %>
<%@page import="java.util.Map" %>

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
    VoterDAO voterDAO = new VoterDAO(conn);
    
    // Get counts for dashboard
    int activeElections = electionDAO.getActiveElections().size();
    int totalCandidates = candidateDAO.getAllCandidates().size();
    int totalVotes = voteDAO.getTotalVotesCount();
    
    // Get all candidates and voters
    List<Map<String, Object>> candidates = candidateDAO.getAllCandidatesWithUserDetails();
    List<Voter> voters = voterDAO.getAllVoters();
    
    // Handle delete actions
    if ("deleteCandidate".equals(request.getParameter("action"))) {
        int candidateId = Integer.parseInt(request.getParameter("id"));
        candidateDAO.deleteCandidate(candidateId);
        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        return;
    }
    
    if ("deleteVoter".equals(request.getParameter("action"))) {
        int voterId = Integer.parseInt(request.getParameter("id"));
        voterDAO.deleteVoter(voterId);
        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        return;
    }
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
    <style>
        .data-table {
            margin-top: 30px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
        }
        .data-table h4 {
            margin-bottom: 20px;
            color: #333;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .table-responsive {
            margin-top: 15px;
        }
        .action-btn {
            padding: 5px 10px;
            font-size: 14px;
        }
    </style>
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
        
        <!-- Voters Table -->
		<div class="data-table">
		    <h4><i class="fas fa-user-check"></i> Voters</h4>
		    <div class="table-responsive">
		        <table class="table table-striped table-hover">
		            <thead class="thead-dark">
		                <tr>
		                    <th>ID</th>
		                    <th>Voter ID</th>
		                    <th>First Name</th>
		                    <th>Last Name</th>
		                    <th>Username</th>
		                    <th>District</th>
		                    <th>Actions</th>
		                </tr>
		            </thead>
		            <tbody>
		                <% for (Voter voter : voters) { %>
		                <tr>
		                    <td><%= voter.getVoterId() %></td>
		                    <td><%= voter.getVoterIdNumber() %></td>
		                    <td><%= voter.getFirstName() %></td>
		                    <td><%= voter.getLastName() %></td>
		                    <td><%= voter.getUsername() %></td>
		                    <td><%= voter.getDistrict() %></td>
		                    <td>
		                        <form action="${pageContext.request.contextPath}/admin/dashboard.jsp" method="post" style="display: inline;">
		                            <input type="hidden" name="action" value="deleteVoter">
		                            <input type="hidden" name="id" value="<%= voter.getVoterId() %>">
		                            <button type="submit" class="btn btn-danger btn-sm action-btn" 
		                                    onclick="return confirm('Are you sure you want to delete this voter?')">
		                                <i class="fas fa-trash-alt"></i> Delete
		                            </button>
		                        </form>
		                    </td>
		                </tr>
		                <% } %>
		            </tbody>
		        </table>
		    </div>
		</div>
		<!-- Candidates Table -->
		<div class="data-table">
		    <h4><i class="fas fa-user-tie"></i> Candidates</h4>
		    <div class="table-responsive">
		        <table class="table table-striped table-hover">
		            <thead class="thead-dark">
		                <tr>
		                    <th>ID</th>
		                    <th>Username</th>
		                    <th>First Name</th>
		                    <th>Last Name</th>
		                    <th>Position</th>
		                    <th>Actions</th>
		                </tr>
		            </thead>
		            <tbody>
		                <% for (Map<String, Object> candidate : candidates) { %>
		                <tr>
		                    <td><%= candidate.get("candidateId") %></td>
		                    <td><%= candidate.get("username") %></td>
		                    <td><%= candidate.get("firstName") %></td>
		                    <td><%= candidate.get("lastName") %></td>
		                    <td><%= candidate.get("position") %></td>
		                    <td>
		                        <form action="${pageContext.request.contextPath}/admin/dashboard.jsp" method="post" style="display: inline;">
		                            <input type="hidden" name="action" value="deleteCandidate">
		                            <input type="hidden" name="id" value="<%= candidate.get("candidateId") %>">
		                            <button type="submit" class="btn btn-danger btn-sm action-btn" 
		                                    onclick="return confirm('Are you sure you want to delete this candidate?')">
		                                <i class="fas fa-trash-alt"></i> Delete
		                            </button>
		                        </form>
		                    </td>
		                </tr>
		                <% } %>
		            </tbody>
		        </table>
		    </div>
		</div>
	</div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>