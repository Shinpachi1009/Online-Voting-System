<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Active Elections</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="container mt-4">
        <h2>Active Elections</h2>
        <hr>
        
        <c:if test="${not empty elections}">
            <div class="list-group">
                <c:forEach items="${elections}" var="election">
                    <a href="election?action=view&id=${election.electionId}" 
                       class="list-group-item list-group-item-action">
                        <div class="d-flex w-100 justify-content-between">
                            <h5 class="mb-1">${election.title}</h5>
                            <small>${election.status}</small>
                        </div>
                        <p class="mb-1">${election.description}</p>
                        <small>${election.startDate} to ${election.endDate}</small>
                    </a>
                </c:forEach>
            </div>
        </c:if>
        
        <c:if test="${empty elections}">
            <div class="alert alert-info">No active elections at this time.</div>
        </c:if>
    </div>
</body>
</html>