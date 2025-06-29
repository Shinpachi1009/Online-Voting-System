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
    VoteDAO voteDAO = new VoteDAO(conn);
    request.setAttribute("voteDAO", voteDAO);
    request.setAttribute("currentUser", user);
%>

<html>
<head>
    <meta charset="UTF-8">
    <title>Election View</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.png" type="image/x-icon">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar-style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/election-view-style.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="election-container">
        <div class="welcome-card">
            <h4 class="welcome-header">
                <i class="fas fa-vote-yea"></i> Election: ${title}
            </h4>
            <div class="alert alert-info">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <strong><i class="fas fa-info-circle"></i> Election Details:</strong> ${description}
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
                            <i class="fas fa-arrow-left"></i> Back to Dashboard
                        </a>
                    </div>
                </div>
                <p class="mt-2 mb-0"><strong>Voting Period:</strong> ${startDate} to ${endDate}</p>
            </div>
        </div>
        
        <div class="action-card">
            <div class="card-header bg-primary">
                <i class="fas fa-list-ol"></i> Available Positions
            </div>
            <div class="card-body">
                <c:if test="${not empty positions}">
                    <div class="row">
                        <c:forEach items="${positions}" var="position">
                            <div class="col-md-6">
                                <div class="position-card">
                                    <div class="card-header position-title">
                                        <h5><i class="fas fa-user-tie"></i> ${position.title}</h5>
                                    </div>
                                    <div class="card-body">
                                        <p>${position.description}</p>
                                        <p class="text-muted"><i class="fas fa-info-circle"></i> Select up to ${position.maxVotes} candidate(s)</p>
                                        
                                        <c:set var="hasVoted" value="${voteDAO.hasVoted(currentUser.userId, position.positionId)}" />
                                        
                                        <c:choose>
                                            <c:when test="${hasVoted}">
                                                <div class="alert alert-success">
                                                    <i class="fas fa-check-circle"></i> You've already voted for this position
                                                </div>
                                                <a href="results.jsp?positionId=${position.positionId}" 
                                                   class="btn btn-outline-primary">
                                                    <i class="fas fa-chart-bar"></i> View Results
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="ballot.jsp?electionId=${electionId}&positionId=${position.positionId}" 
                                                   class="btn btn-primary">
                                                    <i class="fas fa-vote-yea"></i> Vote Now
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>