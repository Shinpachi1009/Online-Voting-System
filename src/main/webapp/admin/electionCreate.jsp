<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Election</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-datepicker@1.9.0/dist/css/bootstrap-datepicker.min.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header">
                        <h4>Create New Election</h4>
                    </div>
                    <div class="card-body">
						<c:if test="${not empty sessionScope.message}">
					        <div class="alert alert-success">${sessionScope.message}</div>
					        <c:remove var="message" scope="session"/>
					    </c:if>
					    <c:if test="${not empty sessionScope.error}">
					        <div class="alert alert-danger">${sessionScope.error}</div>
					        <c:remove var="error" scope="session"/>
					    </c:if>
                        
                        <form action="${pageContext.request.contextPath}/election" method="post">
                            <input type="hidden" name="action" value="create">
                            
                            <div class="form-group">
                                <label for="title">Election Title</label>
                                <input type="text" class="form-control" id="title" name="title" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="description">Description</label>
                                <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="startDate">Start Date & Time</label>
                                    <input type="datetime-local" class="form-control" id="startDate" name="startDate" required>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="endDate">End Date & Time</label>
                                    <input type="datetime-local" class="form-control" id="endDate" name="endDate" required>
                                </div>
                            </div>
                            
                            <h5 class="mt-4">Positions</h5>
                            <div id="positionsContainer">
                                <div class="position-group mb-3">
                                    <div class="form-row">
                                        <div class="form-group col-md-5">
                                            <input type="text" class="form-control" name="positionTitles" placeholder="Position title" required>
                                        </div>
                                        <div class="form-group col-md-5">
                                            <input type="text" class="form-control" name="positionDescriptions" placeholder="Description">
                                        </div>
                                        <div class="form-group col-md-2">
                                            <button type="button" class="btn btn-danger remove-position">Remove</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <button type="button" id="addPosition" class="btn btn-secondary mb-3">Add Another Position</button>
                            <button type="submit" class="btn btn-primary btn-block">Create Election</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        $(document).ready(function() {
            // Add position field
            $('#addPosition').click(function() {
                const newPosition = `
                    <div class="position-group mb-3">
                        <div class="form-row">
                            <div class="form-group col-md-5">
                                <input type="text" class="form-control" name="positionTitles" placeholder="Position title" required>
                            </div>
                            <div class="form-group col-md-5">
                                <input type="text" class="form-control" name="positionDescriptions" placeholder="Description">
                            </div>
                            <div class="form-group col-md-2">
                                <button type="button" class="btn btn-danger remove-position">Remove</button>
                            </div>
                        </div>
                    </div>
                `;
                $('#positionsContainer').append(newPosition);
            });
            
            // Remove position field
            $(document).on('click', '.remove-position', function() {
                if($('.position-group').length > 1) {
                    $(this).closest('.position-group').remove();
                } else {
                    alert("At least one position is required");
                }
            });
        });
    </script>
</body>
</html>