<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Election</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .form-container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
            background: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    
    <div class="container">
        <div class="form-container">
            <h2 class="mb-4">Create New Election</h2>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/election" method="post">
			    <input type="hidden" name="action" value="create">
			    
			    <div class="form-group">
			        <label for="title">Election Title*</label>
			        <input type="text" class="form-control" id="title" name="title" required>
			    </div>
			    
			    <div class="form-group">
			        <label for="description">Description*</label>
			        <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
			    </div>
			    
			    <div class="row">
			        <div class="col-md-6">
			            <div class="form-group">
			                <label for="startDate">Start Date & Time*</label>
			                <input type="datetime-local" class="form-control" id="startDate" name="startDate" required>
			            </div>
			        </div>
			        <div class="col-md-6">
			            <div class="form-group">
			                <label for="endDate">End Date & Time*</label>
			                <input type="datetime-local" class="form-control" id="endDate" name="endDate" required>
			            </div>
			        </div>
			    </div>
			    
			    <button type="submit" class="btn btn-primary">Create Election</button>
			    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">Cancel</a>
			</form>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    <script>
        // Set minimum end date to be after start date
        document.getElementById('startDate').addEventListener('change', function() {
            document.getElementById('endDate').min = this.value;
        });
        
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
		    const startDate = new Date(document.getElementById('startDate').value);
		    const endDate = new Date(document.getElementById('endDate').value);
		    
		    if (endDate <= startDate) {
		        e.preventDefault();
		        alert('End date must be after start date');
		        return false;
		    }
		    
		    if (document.getElementById('title').value.trim() === '') {
		        e.preventDefault();
		        alert('Title is required');
		        return false;
		    }
		    
		    return true;
		});
    </script>
</body>
</html>