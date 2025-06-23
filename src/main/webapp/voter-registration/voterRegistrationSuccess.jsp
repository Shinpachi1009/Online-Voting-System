<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registration Submitted</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h4>Registration Submitted</h4>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-success">
                            <h5>Thank you for registering!</h5>
                            <p>Your voter registration has been submitted for verification. You will receive an email notification once your registration is approved.</p>
                        </div>
                        <a href="dashboard.jsp" class="btn btn-primary">Return to Dashboard</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>