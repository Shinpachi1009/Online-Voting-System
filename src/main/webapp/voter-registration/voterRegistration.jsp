<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Voter Registration</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header">
                        <h4>Voter Registration</h4>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        
                        <form action="voter-registration" method="post" enctype="multipart/form-data">
                            <div class="form-group">
                                <label for="voterIdNumber">Voter ID Number</label>
                                <input type="text" class="form-control" id="voterIdNumber" name="voterIdNumber" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="dateOfBirth">Date of Birth</label>
                                <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="address">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="3" required></textarea>
                            </div>
                            
                            <div class="form-group">
                                <label for="district">District</label>
                                <input type="text" class="form-control" id="district" name="district" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="idDocument">ID Document (Photo ID)</label>
                                <input type="file" class="form-control-file" id="idDocument" name="idDocument" accept="image/*,.pdf" required>
                                <small class="form-text text-muted">Upload a clear photo of your government-issued ID (Max 10MB)</small>
                            </div>
                            
                            <div class="form-group form-check">
                                <input type="checkbox" class="form-check-input" id="terms" required>
                                <label class="form-check-label" for="terms">I certify that the information provided is accurate</label>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">Submit Registration</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>