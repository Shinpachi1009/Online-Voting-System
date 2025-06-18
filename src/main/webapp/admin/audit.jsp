<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Audit Logs - Online Voting System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.22/css/dataTables.bootstrap4.min.css">
</head>
<body>
    <jsp:include page="../../navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-12">
                <h2>Audit Logs</h2>
                <hr>
                
                <div class="card">
                    <div class="card-header">
                        <div class="row">
                            <div class="col-md-6">
                                <h5>System Activity</h5>
                            </div>
                            <div class="col-md-6 text-right">
                                <button class="btn btn-sm btn-primary" id="refreshBtn">Refresh</button>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <table id="auditTable" class="table table-striped table-bordered">
                            <thead>
                                <tr>
                                    <th>Timestamp</th>
                                    <th>User</th>
                                    <th>Action</th>
                                    <th>Details</th>
                                    <th>IP Address</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Sample data - in real app, fetch from database -->
                                <tr>
                                    <td>2023-05-15 10:30:45</td>
                                    <td>admin</td>
                                    <td>LOGIN_SUCCESS</td>
                                    <td>User logged in successfully</td>
                                    <td>192.168.1.1</td>
                                </tr>
                                <tr>
                                    <td>2023-05-15 09:15:22</td>
                                    <td>officer1</td>
                                    <td>USER_UPDATE</td>
                                    <td>Updated user profile</td>
                                    <td>192.168.1.2</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.22/js/dataTables.bootstrap4.min.js"></script>
    
    <script>
        $(document).ready(function() {
            var table = $('#auditTable').DataTable({
                "order": [[0, "desc"]]
            });
            
            $('#refreshBtn').click(function() {
                table.ajax.reload();
            });
        });
    </script>
</body>
</html>