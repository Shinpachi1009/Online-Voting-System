<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<%@page import="com.voting.dao.ResultDAO" %>
<%@page import="com.voting.dao.PositionDAO" %>
<%@page import="java.sql.Connection" %>
<%@page import="com.voting.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    int positionId = Integer.parseInt(request.getParameter("positionId"));
    
    Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
    PositionDAO positionDAO = new PositionDAO(conn);
    ResultDAO resultDAO = new ResultDAO(conn);
    
    request.setAttribute("position", positionDAO.getPositionById(positionId));
    request.setAttribute("results", resultDAO.getResultsByPosition(positionId));
    request.setAttribute("totalVotes", resultDAO.getTotalVotesForPosition(positionId));
%>

<html>
<head>
    <meta charset="UTF-8">
    <title>Election Results</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.png" type="image/x-icon">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar-style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/results-style.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="results-container">
        <div class="welcome-card">
            <h4 class="welcome-header">
                <i class="fas fa-chart-bar"></i> Election Results: ${position.title}
            </h4>
            <div class="alert alert-info">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <strong><i class="fas fa-info-circle"></i> Position Details:</strong> ${position.description}
                    </div>
                    <div>
                        <a href="election?action=view&id=${position.electionId}" class="btn btn-primary">
                            <i class="fas fa-arrow-left"></i> Back to Election
                        </a>
                    </div>
                </div>
                <p class="mt-2 mb-0"><strong>Total Votes Cast:</strong> ${totalVotes}</p>
            </div>
        </div>
        
        <div class="action-card">
            <div class="card-header bg-primary">
                <i class="fas fa-poll"></i> Candidate Results
            </div>
            <div class="card-body">
                <c:forEach items="${results}" var="result" varStatus="loop">
                    <div class="result-card ${loop.first ? 'winner-card' : ''}">
                        <div class="card-header position-title">
                            <h5>
                                <i class="fas fa-user-tie"></i> ${result.candidateName}
                                <c:if test="${loop.first}">
                                    <span class="badge badge-success ml-2"><i class="fas fa-trophy"></i> Winner</span>
                                </c:if>
                            </h5>
                        </div>
                        <div class="card-body">
                            <p class="candidate-bio">${result.candidateBio}</p>
                            
                            <div class="vote-info">
                                <div class="vote-count">
                                    <h4>${result.voteCount} votes</h4>
                                    <small>${result.percentage}% of total</small>
                                </div>
                                <div class="progress-container">
                                    <div class="progress">
                                        <div class="progress-bar" role="progressbar" 
                                             style="width: ${result.percentage}%" 
                                             aria-valuenow="${result.percentage}" 
                                             aria-valuemin="0" 
                                             aria-valuemax="100">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>