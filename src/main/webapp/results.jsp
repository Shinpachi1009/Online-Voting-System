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
    <title>Election Results - Online Voting System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        .result-card {
            border-left: 4px solid #007bff;
            margin-bottom: 15px;
        }
        .winner-card {
            border-left: 4px solid #28a745;
            background-color: #f8fff8;
        }
        .progress {
            height: 25px;
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
                        <h4>Election Results: ${position.title}</h4>
                    </div>
                    <div class="card-body">
                        <p class="lead">${position.description}</p>
                        <p><strong>Total Votes Cast:</strong> ${totalVotes}</p>
                        
                        <hr>
                        
                        <h5 class="mb-3">Candidate Results</h5>
                        
                        <c:forEach items="${results}" var="result" varStatus="loop">
                            <div class="card result-card ${loop.first ? 'winner-card' : ''} mb-3">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h5>${result.candidateName}
                                                <c:if test="${loop.first}">
                                                    <span class="badge badge-success ml-2">Winner</span>
                                                </c:if>
                                            </h5>
                                            <p class="text-muted">${result.candidateBio}</p>
                                        </div>
                                        <div class="text-right">
                                            <h4>${result.voteCount} votes</h4>
                                            <small>${result.percentage}% of total</small>
                                        </div>
                                    </div>
                                    <div class="progress mt-2">
                                        <div class="progress-bar" role="progressbar" 
                                             style="width: ${result.percentage}%" 
                                             aria-valuenow="${result.percentage}" 
                                             aria-valuemin="0" 
                                             aria-valuemax="100">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <a href="election?action=view&id=${position.electionId}" class="btn btn-secondary mt-3">
                            <i class="fas fa-arrow-left"></i> Back to Election
                        </a>
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