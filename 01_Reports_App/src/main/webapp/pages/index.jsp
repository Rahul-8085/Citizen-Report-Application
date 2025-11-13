<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Citizen Report Application</title>

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>
    body {
        background: linear-gradient(135deg, #e3f2fd, #ffffff);
        min-height: 100vh;
    }
    .card {
        border-radius: 1rem;
        transition: all 0.3s ease;
    }
    .card:hover {
        transform: translateY(-4px);
        box-shadow: 0 0.75rem 1.5rem rgba(0,0,0,0.1);
    }
    .card-header {
        border-top-left-radius: 1rem !important;
        border-top-right-radius: 1rem !important;
    }
    .table thead {
        background: #0d6efd;
        color: white;
    }
    th, td {
        vertical-align: middle;
    }
</style>
</head>

<body>
<div class="container py-5">

    <!-- Header -->
    <div class="text-center mb-5">
        <h2 class="fw-bold text-primary">
            <i class="bi bi-bar-chart-fill me-2"></i> Citizen Report Application
        </h2>
        <p class="text-secondary">Search citizen plans with filters and export reports with a single click.</p>
    </div>

    <!-- Search Card -->
    <div class="card shadow-lg mb-5 border-0">
        <div class="card-header bg-primary text-white fw-semibold">
            <i class="bi bi-search me-2"></i> Search Criteria
        </div>
        <div class="card-body bg-light">
            <form:form action="search" modelAttribute="search" method="POST">
                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold text-primary">Plan Name</label>
                        <form:select path="planName" cssClass="form-select">
                            <form:option value="">-- Select --</form:option>
                            <form:options items="${names}" />
                        </form:select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold text-primary">Plan Status</label>
                        <form:select path="planStatus" cssClass="form-select">
                            <form:option value="">-- Select --</form:option>
                            <form:options items="${status}" />
                        </form:select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold text-primary">Gender</label>
                        <form:select path="gender" cssClass="form-select">
                            <form:option value="">-- Select --</form:option>
                            <form:option value="Male">Male</form:option>
                            <form:option value="Female">Female</form:option>
                        </form:select>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold text-primary">Start Date</label>
                        <form:input path="startDate" type="date" cssClass="form-control" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold text-primary">End Date</label>
                        <form:input path="endDate" type="date" cssClass="form-control" />
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100 shadow-sm">
                            <i class="bi bi-search"></i> Search
                        </button>
                         <a href="${pageContext.request.contextPath}/" class="btn btn-secondary shadow-sm w-50">
                            <i class="bi bi-arrow-counterclockwise"></i> Reset
                        </a>
                    </div>
                </div>
            </form:form>
        </div>
    </div>

    <!-- Results Table -->
    <div class="card shadow-lg border-0 mb-4">
        <div class="card-header bg-secondary text-white fw-semibold">
            <i class="bi bi-table me-2"></i> Search Results
        </div>
        <div class="card-body bg-white">
            <c:if test="${not empty plans}">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle text-center">
                        <thead>
                            <tr>
                                <th>S No.</th>
                                <th>Holder Name</th>
                                <th>Gender</th>
                                <th>Plan Name</th>
                                <th>Plan Status</th>
                                <th>Start Date</th>
                                <th>End Date</th>
                                <th>Benefit Amount</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${plans}" var="plan" varStatus="index">
                                <tr>
                                    <td>${index.count}</td>
                                    <td>${plan.citizenName}</td>
                                    <td>${plan.gender}</td>
                                    <td>${plan.planName}</td>
                                    <td>
                                        <span class="badge px-3 py-2 fs-6
                                            <c:choose>
                                                <c:when test='${plan.planStatus == "Approved"}'>bg-success</c:when>
                                                <c:when test='${plan.planStatus == "Denied"}'>bg-danger</c:when>
                                                <c:otherwise>bg-warning text-dark</c:otherwise>
                                            </c:choose>">
                                            ${plan.planStatus}
                                        </span>
                                    </td>
                                    <td>${plan.planStartDate}</td>
                                    <td>${plan.planEndDate}</td>
                                    <td class="fw-semibold text-success">₹${plan.benefitAmt}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>

            <c:if test="${empty plans}">
                <div class="text-center text-muted py-5">
                    <i class="bi bi-exclamation-circle fs-1 text-warning"></i>
                    <p class="mt-3 fs-5">No records found. Try different filters.</p>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Export Buttons -->
    <div class="text-end mt-4">
        <p class="mb-2 fw-semibold text-secondary">Export Options:</p>
        <a href="export/pdf" class="btn btn-outline-danger me-2">
            <i class="bi bi-file-earmark-pdf-fill"></i> PDF
        </a>
        <a href="export/excel" class="btn btn-outline-success">
            <i class="bi bi-file-earmark-excel-fill"></i> Excel
        </a>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
