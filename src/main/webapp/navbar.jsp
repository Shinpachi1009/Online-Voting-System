<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    .navbar {
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .navbar-brand {
        display: flex;
        align-items: center;
        font-weight: 600;
    }
    .navbar-brand img {
        height: 40px;
        margin-right: 20px;
    }
    .nav-link {
        padding: 0.5rem 1rem;
    }
    .dropdown-menu {
        border: none;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
    }
    .dropdown-item {
        padding: 0.5rem 1.5rem;
    }
    .btn-link {
        color: #6c757d;
        text-decoration: none;
    }
    .btn-link:hover {
        color: #343a40;
        text-decoration: none;
    }
</style>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
		        <!-- Logo and Brand Name -->
        <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard.jsp">
            <img src="${pageContext.request.contextPath}/images/logo.png" 
                 alt="Online Voting System Logo">
            Online Voting System
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                    <a class="nav-link" href="dashboard.jsp">Dashboard</a>
                </li>
                <!-- Add this new menu item -->
                <c:if test="${user.roleName == 'VOTER'}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/voter-registration">Voter Registration</a>
                    </li>
                </c:if>
                <c:if test="${user.roleName == 'ADMIN' || user.roleName == 'ELECTION_OFFICER'}">
                    <li class="nav-item">
                        <a class="nav-link" href="admin/dashboard.jsp">Admin Panel</a>
                    </li>
                </c:if>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown">
                        <c:out value="${user.firstName} ${user.lastName}" /> (${user.roleName})
                    </a>
                    <div class="dropdown-menu dropdown-menu-right">
                        <a class="dropdown-item" href="user?action=profile">My Profile</a>
                        <div class="dropdown-divider"></div>
                        <form action="auth" method="post" class="dropdown-item">
                            <input type="hidden" name="action" value="logout">
                            <button type="submit" class="btn btn-link p-0">Logout</button>
                        </form>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</nav>