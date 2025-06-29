<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<%@page import="com.voting.model.User" %>
<%@page import="com.voting.dao.PositionDAO" %>
<%@page import="com.voting.dao.VoteDAO" %>
<%@page import="java.sql.Connection" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
    int electionId = Integer.parseInt(request.getParameter("id"));
    
    PositionDAO positionDAO = new PositionDAO(conn);
    request.setAttribute("positions", positionDAO.getPositionsByElection(electionId));
    
    VoteDAO voteDAO = new VoteDAO(conn);
    request.setAttribute("voteDAO", voteDAO);
    request.setAttribute("currentUser", user);
%>

<html>
<head>
    <meta charset="UTF-8">
    <title>Election View - Online Voting System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .position-card {
            transition: all 0.3s;
            margin-bottom: 20px;
        }
        .position-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .vote-progress {
            height: 10px;
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
                        <h4>Election: ${param.title}</h4>
                    </div>
                    <div class="card-body">
                        <p class="lead">${param.description}</p>
                        <p><strong>Voting Period:</strong> ${param.startDate} to ${param.endDate}</p>
                        
                        <hr>
                        
                        <h5 class="mb-3">Available Positions</h5>
                        
                        <c:if test="${not empty positions}">
                            <div class="row">
                                <c:forEach items="${positions}" var="position">
                                    <div class="col-md-6">
                                        <div class="card position-card">
                                            <div class="card-header">
                                                <h5>${position.title}</h5>
                                            </div>
                                            <div class="card-body">
                                                <p>${position.description}</p>
                                                <p><small class="text-muted">Select up to ${position.maxVotes} candidate(s)</small></p>
                                                
                                                <c:set var="hasVoted" value="${voteDAO.hasVoted(currentUser.userId, position.positionId)}" />
                                                
                                                <c:choose>
                                                    <c:when test="${hasVoted}">
                                                        <div class="alert alert-success">
                                                            You've already voted for this position
                                                        </div>
                                                        <a href="results.jsp?positionId=${position.positionId}" 
                                                           class="btn btn-outline-primary btn-sm">
                                                            View Results
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="ballot.jsp?electionId=${param.id}&positionId=${position.positionId}" 
                                                           class="btn btn-primary btn-sm">
                                                            Vote Now
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                        
                        <a href="voter/dashboard.jsp" class="btn btn-secondary mt-3">Back to Dashboard</a>
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