<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Election</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.png" type="image/x-icon">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar-style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/election-create-style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="admin-container">
        <div class="welcome-card">
            <h4 class="welcome-header">
                <i class="fas fa-plus-circle"></i> Create New Election
            </h4>
            <div class="alert alert-info">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <strong><i class="fas fa-user"></i> Admin:</strong> ${user.firstName} ${user.lastName}
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/election?action=list" class="btn btn-primary">
                            <i class="fas fa-arrow-left"></i> Back to Elections
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="action-card">
            <div class="card-header bg-primary">
                <i class="fas fa-vote-yea"></i> Election Details
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
                
                <form id="electionForm" action="${pageContext.request.contextPath}/election" method="post">
                    <input type="hidden" name="action" value="create">
                    
                    <div class="form-group">
                        <label for="title">Election Title</label>
                        <input type="text" class="form-control" id="title" name="title">
                        <small class="form-text text-muted">Alphabetical characters only</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="startDate">Start Date & Time</label>
                            <input type="datetime-local" class="form-control" id="startDate" name="startDate">
                        </div>
                        <div class="form-group col-md-6">
                            <label for="endDate">End Date & Time</label>
                            <input type="datetime-local" class="form-control" id="endDate" name="endDate">
                        </div>
                    </div>
                    
                    <h5 class="mt-4"><i class="fas fa-users-cog"></i> Positions</h5>
                    <div id="positionsContainer">
                        <div class="position-group mb-3">
                            <div class="form-row">
                                <div class="form-group col-md-5">
                                    <select class="form-control" name="positionTitles">
                                        <option value="">Select Position</option>
                                        <option value="President">President</option>
                                        <option value="Vice President">Vice President</option>
                                        <option value="Secretary">Secretary</option>
                                        <option value="Auditor">Auditor</option>
                                        <option value="Treasurer">Treasurer</option>
                                        <option value="PIO">PIO</option>
                                    </select>
                                </div>
                                <div class="form-group col-md-5">
                                    <input type="text" class="form-control" name="positionDescriptions" placeholder="Description">
                                </div>
                                <div class="form-group col-md-2">
                                    <button type="button" class="btn btn-danger remove-position">
                                        <i class="fas fa-trash"></i> Remove
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-between mt-3">
                        <button type="button" id="addPosition" class="btn btn-success">
                            <i class="fas fa-plus"></i> Add Position
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Create Election
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
            // Add position field
            $('#addPosition').click(function() {
                const newPosition = `
                    <div class="position-group mb-3">
                        <div class="form-row">
                            <div class="form-group col-md-5">
                                <select class="form-control" name="positionTitles" required>
                                    <option value="">Select Position</option>
                                    <option value="President">President</option>
                                    <option value="Vice President">Vice President</option>
                                    <option value="Secretary">Secretary</option>
                                    <option value="Auditor">Auditor</option>
                                    <option value="Treasurer">Treasurer</option>
                                    <option value="PIO">PIO</option>
                                </select>
                            </div>
                            <div class="form-group col-md-5">
                                <input type="text" class="form-control" name="positionDescriptions" placeholder="Description" required>
                            </div>
                            <div class="form-group col-md-2">
                                <button type="button" class="btn btn-danger remove-position">
                                    <i class="fas fa-trash"></i> Remove
                                </button>
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
                    Swal.fire({
                        icon: 'warning',
                        title: 'Cannot remove',
                        text: 'At least one position is required',
                        confirmButtonColor: '#3085d6'
                    });
                }
            });
            
            // Form validation
            $('#electionForm').submit(function(e) {
                e.preventDefault(); // Always prevent default first
                
                let isValid = true;
                let errorMessage = '';
                
                // Validate Election Title (alphabetical only)
                const title = $('#title').val().trim();
                if (!title) {
                    errorMessage = 'Election Title is required';
                    isValid = false;
                } else if (!/^[a-zA-Z\s]+$/.test(title)) {
                    errorMessage = 'Election Title should contain only alphabetical characters';
                    isValid = false;
                }
                
                // Validate Description
                else if (!$('#description').val().trim()) {
                    errorMessage = 'Description is required';
                    isValid = false;
                }
                
                // Validate Dates
                else {
                    const startDateVal = $('#startDate').val();
                    const endDateVal = $('#endDate').val();
                    
                    if (!startDateVal) {
                        errorMessage = 'Start Date is required';
                        isValid = false;
                    } 
                    else if (!endDateVal) {
                        errorMessage = 'End Date is required';
                        isValid = false;
                    }
                    else {
                        // Check if dates are valid
                        const startDate = new Date(startDateVal);
                        const endDate = new Date(endDateVal);
                        
                        // Check for invalid dates (like 23/04/0004)
                        if (isNaN(startDate.getTime())) {
                            errorMessage = 'Start Date is invalid';
                            isValid = false;
                        }
                        else if (isNaN(endDate.getTime())) {
                            errorMessage = 'End Date is invalid';
                            isValid = false;
                        }
                        // Check if start date is in the past
                        else if (startDate < new Date()) {
                            errorMessage = 'Start Date cannot be in the past';
                            isValid = false;
                        }
                        // Check if end date is before start date
                        else if (startDate >= endDate) {
                            errorMessage = 'End Date must be after Start Date';
                            isValid = false;
                        }
                    }
                }
                
                // Validate Positions
                if (isValid) {
                    let positionTitlesValid = true;
                    let positionDescriptionsValid = true;
                    
                    $('select[name="positionTitles"]').each(function() {
                        if (!$(this).val()) {
                            positionTitlesValid = false;
                            return false; // break out of loop
                        }
                    });
                    
                    if (!positionTitlesValid) {
                        errorMessage = 'All Position Titles are required';
                        isValid = false;
                    } else {
                        $('input[name="positionDescriptions"]').each(function() {
                            if (!$(this).val().trim()) {
                                positionDescriptionsValid = false;
                                return false; // break out of loop
                            }
                        });
                        
                        if (!positionDescriptionsValid) {
                            errorMessage = 'All Position Descriptions are required';
                            isValid = false;
                        }
                    }
                }
                
                if (!isValid) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Validation Error',
                        text: errorMessage,
                        confirmButtonColor: '#3085d6'
                    });
                } else {
                    // Show success message before submitting
                    Swal.fire({
                        icon: 'success',
                        title: 'Success!',
                        text: 'Election created successfully',
                        confirmButtonColor: '#3085d6',
                        timer: 2000,
                        timerProgressBar: true,
                        willClose: () => {
                            // Submit the form after the success message is shown
                            document.getElementById('electionForm').submit();
                        }
                    });
                }
            });

            // Additional validation for datetime-local inputs
            $('#startDate, #endDate').on('change', function() {
                const value = $(this).val();
                if (value) {
                    const date = new Date(value);
                    if (isNaN(date.getTime())) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Invalid Date',
                            text: 'Please enter a valid date and time',
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