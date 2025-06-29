<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register as Candidate</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.png" type="image/x-icon">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar-style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/candidate-registration-style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="registration-container">
        <div class="welcome-card">
            <h4 class="welcome-header">
                <i class="fas fa-user-plus"></i> Candidate Registration
            </h4>
            <div class="alert alert-info">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <strong><i class="fas fa-info-circle"></i> Important:</strong> Please fill all fields accurately
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
                            <i class="fas fa-arrow-left"></i> Back to Home
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="action-card">
            <div class="card-header bg-primary">
                <i class="fas fa-id-card"></i> Registration Form
            </div>
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                
                <form id="candidateForm" action="${pageContext.request.contextPath}/candidate" method="POST">
                    <input type="hidden" name="action" value="register">
                    
                    <div class="form-group">
                        <label for="position"><i class="fas fa-user-tie"></i> Position</label>
                        <select class="form-control" id="position" name="position" required>
                            <option value="">Select Position</option>
                            <option value="President">President</option>
                            <option value="Vice President">Vice President</option>
                            <option value="Secretary">Secretary</option>
                            <option value="Auditor">Auditor</option>
                            <option value="Treasurer">Treasurer</option>
                            <option value="PIO">PIO</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="bio"><i class="fas fa-file-alt"></i> Bio/Manifesto</label>
                        <textarea class="form-control" id="bio" name="bio" rows="4" required></textarea>
                    </div>
                    
                    <div class="d-flex justify-content-between mt-4">
                        <button type="reset" class="btn btn-danger">
                            <i class="fas fa-eraser"></i> Clear Form
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Register
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        $(document).ready(function() {
            // Form validation
            $('#candidateForm').submit(function(e) {
                e.preventDefault();
                
                let isValid = true;
                let errorMessage = '';
                
                // Validate Position
                const position = $('#position').val();
                if (!position) {
                    errorMessage = 'Position is required';
                    isValid = false;
                }
                
                // Validate Bio
                const bio = $('#bio').val().trim();
                if (!bio) {
                    errorMessage = 'Bio/Manifesto is required';
                    isValid = false;
                } else if (bio.length < 10) {
                    errorMessage = 'Bio/Manifesto should be at least 10 characters';
                    isValid = false;
                }
                
                if (!isValid) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Validation Error',
                        text: errorMessage,
                        confirmButtonColor: '#3085d6'
                    });
                    return false;
                } else {
                    // Show success message before submitting
                    Swal.fire({
                        icon: 'success',
                        title: 'Processing Registration',
                        text: 'Your candidate registration is being processed',
                        confirmButtonColor: '#3085d6',
                        timer: 2000,
                        timerProgressBar: true,
                        willClose: () => {
                            // Submit the form after the success message is shown
                            this.submit();
                        }
                    });
                }
            });
        });
    </script>
</body>
</html>