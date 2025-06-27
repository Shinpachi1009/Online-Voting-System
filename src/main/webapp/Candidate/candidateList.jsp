<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Candidates for ${param.position}</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="container mt-4">
        <h2>Candidates for: ${param.position}</h2>
        <hr>
        
        <c:if test="${not empty candidates}">
            <div class="row">
                <c:forEach items="${candidates}" var="candidate">
                    <div class="col-md-4 mb-4">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">${candidate.fullName}</h5>
                                <h6 class="card-subtitle mb-2 text-muted">@${candidate.username}</h6>
                                <p class="card-text">${candidate.bio}</p>
                                <p class="card-text"><small class="text-muted">Registered on ${candidate.createdAt}</small></p>
                                
                                <form action="vote" method="post">
                                    <input type="hidden" name="electionId" value="1"> <!-- Hardcoded for demo -->
                                    <input type="hidden" name="positionId" value="1"> <!-- Hardcoded for demo -->
                                    <input type="hidden" name="candidateId" value="${candidate.candidateId}">
                                    <button type="submit" class="btn btn-success">Vote for this candidate</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        
        <a href="election?action=view&id=1" class="btn btn-secondary">Back to Election</a>
    </div>
</body>
</html>