<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">
            <i class="bi bi-star-fill"></i> PUP Online Voting System
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                        <i class="bi bi-house-fill"></i> Dashboard
                    </a>
                </li>
                <c:if test="${user.roleName == 'VOTER'}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/voter-registration">
                            <i class="fas fa-user-plus"></i> Voter Registration
                        </a>
                    </li>
                </c:if>
                <c:if test="${user.roleName == 'ADMIN' || user.roleName == 'ELECTION_OFFICER'}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                            <i class="fas fa-user-shield"></i> Admin Panel
                        </a>
                    </li>
                </c:if>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle user-menu" href="#" id="navbarDropdown" role="button" data-toggle="dropdown">
                        <i class="fas fa-user-circle"></i> <c:out value="${user.firstName} ${user.lastName}" /> (${user.roleName})
                    </a>
                    <div class="dropdown-menu dropdown-menu-right">
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/user?action=profile">
                            <i class="fas fa-user"></i> My Profile
                        </a>
                        <div class="dropdown-divider"></div>
                        <form action="${pageContext.request.contextPath}/auth" method="post" class="dropdown-item">
                            <input type="hidden" name="action" value="logout">
                            <button type="submit" class="btn btn-link p-0 logout-btn">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </button>
                        </form>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</nav>