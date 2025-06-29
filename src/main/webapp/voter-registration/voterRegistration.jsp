<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Voter Registration</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.png" type="image/x-icon">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar-style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/voter-registration-style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="registration-container">
        <div class="welcome-card">
            <h4 class="welcome-header">
                <i class="fas fa-user-plus"></i> Voter Registration
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
                <form id="voterForm" action="voter-registration" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="voterIdNumber"><i class="fas fa-id-badge"></i> Voter ID Number</label>
                        <input type="text" class="form-control" id="voterIdNumber" name="voterIdNumber" placeholder="Enter your voter ID number">
                        <small class="form-text text-muted">Numerical characters only</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="dateOfBirth"><i class="fas fa-calendar-alt"></i> Date of Birth</label>
                        <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth">
                        <small class="form-text text-muted">Format: DD/MM/YYYY</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="address"><i class="fas fa-map-marker-alt"></i> Address</label>
                        <textarea class="form-control" id="address" name="address" rows="3" placeholder="Enter your full address"></textarea>
                        <small class="form-text text-muted">Alphanumeric characters only (no special symbols)</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="district"><i class="fas fa-map-pin"></i> District</label>
                        <input type="text" class="form-control" id="district" name="district" placeholder="Enter your district number">
                        <small class="form-text text-muted">Numerical characters only</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="idDocument"><i class="fas fa-file-upload"></i> ID Document (Photo ID)</label>
                        <div class="custom-file">
                            <input type="file" class="custom-file-input" id="idDocument" name="idDocument" accept="image/*,.pdf">
                            <label class="custom-file-label" for="idDocument">Choose file...</label>
                        </div>
                        <small class="form-text text-muted file-upload-text">Upload a clear photo of your government-issued ID (Max 10MB)</small>
                    </div>
                    
                    <div class="form-group form-check checkbox-container">
                        <input type="checkbox" class="form-check-input" id="terms" name="terms">
                        <label class="form-check-label" for="terms">&nbsp;&nbsp;I certify that the information provided is accurate</label>
                    </div>
                    
                    <div class="d-flex justify-content-between mt-4">
                        <button type="reset" class="btn btn-danger">
                            <i class="fas fa-undo"></i> Reset Form
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane"></i> Submit Registration
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
            // Show file name when file is selected
            $('.custom-file-input').on('change', function() {
                let fileName = $(this).val().split('\\').pop();
                $(this).next('.custom-file-label').addClass("selected").html(fileName);
            });
            
            // Form validation
            $('#voterForm').submit(function(e) {
                e.preventDefault();
                
                let isValid = true;
                let errorMessage = '';
                
                // Validate Voter ID (numerical only)
                const voterId = $('#voterIdNumber').val().trim();
                if (!voterId) {
                    errorMessage = 'Voter ID Number is required';
                    isValid = false;
                } else if (!/^\d+$/.test(voterId)) {
                    errorMessage = 'Voter ID should contain only numerical characters';
                    isValid = false;
                }
                
                // Validate Date of Birth
                const dobVal = $('#dateOfBirth').val();
                if (!dobVal) {
                    errorMessage = 'Date of Birth is required';
                    isValid = false;
                } else {
                    const dob = new Date(dobVal);
                    const today = new Date();
                    
                    if (isNaN(dob.getTime())) {
                        errorMessage = 'Date of Birth is invalid';
                        isValid = false;
                    }
                    // Check if date is in the future
                    else if (dob > today) {
                        errorMessage = 'Date of Birth cannot be in the future';
                        isValid = false;
                    }
                    // Check if age is at least 18 years
                    else {
                        let ageDiff = today.getFullYear() - dob.getFullYear();
                        const monthDiff = today.getMonth() - dob.getMonth();
                        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < dob.getDate())) {
                            ageDiff--;
                        }
                        if (ageDiff < 18) {
                            errorMessage = 'You must be at least 18 years old to register';
                            isValid = false;
                        }
                    }
                }
                
                // Validate Address (alphanumeric only)
                const address = $('#address').val().trim();
                if (!address) {
                    errorMessage = 'Address is required';
                    isValid = false;
                } else if (!/^[a-zA-Z0-9\s,.-]+$/.test(address)) {
                    errorMessage = 'Address should contain only alphanumeric characters and basic punctuation (comma, period, hyphen)';
                    isValid = false;
                }
                
                // Validate District (numerical only)
                const district = $('#district').val().trim();
                if (!district) {
                    errorMessage = 'District is required';
                    isValid = false;
                } else if (!/^\d+$/.test(district)) {
                    errorMessage = 'District should contain only numerical characters';
                    isValid = false;
                }
                
                // Validate ID Document
                const idDocument = $('#idDocument').val();
                if (!idDocument) {
                    errorMessage = 'ID Document is required - Please upload a valid photo ID';
                    isValid = false;
                } else {
                    // Validate file type
                    const fileName = idDocument.toLowerCase();
                    const validExtensions = ['.jpg', '.jpeg', '.png', '.pdf'];
                    const isValidFile = validExtensions.some(ext => fileName.endsWith(ext));
                    
                    if (!isValidFile) {
                        errorMessage = 'Only JPG, PNG, or PDF files are allowed';
                        isValid = false;
                    }
                }
                
                // Validate Terms checkbox
                if (!$('#terms').is(':checked')) {
                    errorMessage = 'You must certify that the information is accurate by checking the box';
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
                        text: 'Your voter registration is being processed',
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

            // Additional validation for date input
            $('#dateOfBirth').on('change', function() {
                const value = $(this).val();
                if (value) {
                    const date = new Date(value);
                    const today = new Date();
                    
                    if (isNaN(date.getTime())) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Invalid Date',
                            text: 'Please enter a valid date of birth (DD/MM/YYYY)',
                            confirmButtonColor: '#3085d6'
                        });
                        $(this).val('');
                    } else if (date > today) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Invalid Date',
                            text: 'Date of birth cannot be in the future',
                            confirmButtonColor: '#3085d6'
                        });
                        $(this).val('');
                    }
                }
            });
        });
    </script>
</body>
</html>