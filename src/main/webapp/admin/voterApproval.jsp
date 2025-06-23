<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Voter Approval</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="../../navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-12">
                <h2>Voter Registration Approval</h2>
                <hr>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                
                <div class="card">
                    <div class="card-header">
                        <h5>Pending Registrations</h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Username</th>
                                    <th>Voter ID</th>
                                    <th>Date of Birth</th>
                                    <th>District</th>
                                    <th>Registered On</th>
                                    <th>ID Document</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${pendingVoters}" var="voter">
                                    <tr>
                                        <td>${voter.username}</td>
                                        <td>${voter.voterIdNumber}</td>
                                        <td>${voter.dateOfBirth}</td>
                                        <td>${voter.district}</td>
                                        <td>${voter.registrationDate}</td>
                                        <td>
                                            <a href="${voter.documentPath}" target="_blank" class="btn btn-sm btn-info">View</a>
                                        </td>
                                        <td>
                                            <form action="voter-approval" method="post" style="display:inline;">
                                                <input type="hidden" name="voterId" value="${voter.voterId}">
                                                <input type="hidden" name="action" value="approve">
                                                <button type="submit" class="btn btn-sm btn-success">Approve</button>
                                            </form>
                                            <button class="btn btn-sm btn-danger ml-1" data-toggle="modal" 
                                                    data-target="#rejectModal${voter.voterId}">Reject</button>
                                            
                                            <!-- Reject Modal -->
                                            <div class="modal fade" id="rejectModal${voter.voterId}" tabindex="-1">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title">Reject Registration</h5>
                                                            <button type="button" class="close" data-dismiss="modal">
                                                                <span>&times;</span>
                                                            </button>
                                                        </div>
                                                        <form action="voter-approval" method="post">
                                                            <div class="modal-body">
                                                                <input type="hidden" name="voterId" value="${voter.voterId}">
                                                                <input type="hidden" name="action" value="reject">
                                                                <div class="form-group">
                                                                    <label>Reason for Rejection</label>
                                                                    <textarea name="notes" class="form-control" rows="3" required></textarea>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                                                <button type="submit" class="btn btn-danger">Confirm Rejection</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
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