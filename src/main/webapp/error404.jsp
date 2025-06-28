<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Page Not Found</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-6 offset-md-3 text-center">
                <div class="card">
                    <div class="card-header bg-danger text-white">
                        <h3>404 - Page Not Found</h3>
                    </div>
                    <div class="card-body">
                        <p>The page you requested could not be found.</p>
                        <img src="https://http.cat/404" alt="404 Cat" class="img-fluid mb-3">
                        <a href="${pageContext.request.contextPath}/dashboard	" class="btn btn-primary">Return to Dashboard</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>