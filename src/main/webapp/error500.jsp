<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Server Error</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header bg-danger text-white">
                        <h3>500 - Internal Server Error</h3>
                    </div>
                    <div class="card-body">
                        <p>An unexpected error occurred while processing your request.</p>
                        
                        <c:if test="${not empty exception}">
                            <div class="alert alert-warning">
                                <strong>Error Details:</strong>
                                <p>${exception.message}</p>
                            </div>
                        </c:if>
                        
                        <a href="dashboard.jsp" class="btn btn-primary">Return to Dashboard</a>
                        <button onclick="history.back()" class="btn btn-secondary ml-2">Go Back</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>