<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${election.title}</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="container mt-4">
        <h2>${election.title}</h2>
        <p>${election.description}</p>
        <p><strong>Period:</strong> ${election.startDate} to ${election.endDate}</p>
        <hr>
        
        <h4>Positions</h4>
        
        <c:if test="${not empty positions}">
            <div class="row">
                <c:forEach items="${positions}" var="position">
                    <div class="col-md-6 mb-4">
                        <div class="card">
                            <div class="card-header">
                                <h5>${position.title}</h5>
                            </div>
                            <div class="card-body">
                                <p>${position.description}</p>
                                <p><small>Vote for up to ${position.maxVotes} candidate(s)</small></p>
                                <a href="candidate?action=list&position=${position.title}" 
                                   class="btn btn-sm btn-primary">View Candidates</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        
        <a href="election" class="btn btn-secondary">Back to Elections</a>
    </div>
</body>
</html>