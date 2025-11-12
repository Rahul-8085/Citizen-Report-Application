<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Report Application</title>

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
</head>

<body class="bg-light">
<div class="container py-4">

    <!-- Header -->
    <div class="text-center mb-4">
        <h2 class="fw-bold text-primary">
            <i class="bi bi-file-earmark-bar-graph"></i> Citizen Report Application
        </h2>
        <p class="text-muted">Search citizen plans by filters and export reports easily.</p>
    </div>

    <!-- Search Card -->
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-header bg-primary text-white fw-semibold">
            <i class="bi bi-search"></i> Search Criteria
        </div>
        <div class="card-body bg-white">
            <form:form action="search" modelAttribute="search" method="POST">
                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label">Plan Name</label>
                        <form:select path="planName" cssClass="form-select">
                            <form:option value="">-- Select --</form:option>
                            <form:options items="${names}" />
                        </form:select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Plan Status</label>
                        <form:select path="planStatus" cssClass="form-select">
                            <form:option value="">-- Select --</form:option>
                            <form:options items="${status}" />
                        </form:select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Gender</label>
                        <form:select path="gender" cssClass="form-select">
                            <form:option value="">-- Select --</form:option>
                            <form:option value="Male">Male</form:option>
                            <form:option value="Female">Female</form:option>
                        </form:select>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label">Start Date</label>
                        <form:input path="startDate" type="date" cssClass="form-control" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">End Date</label>
                        <form:input path="endDate" type="date" cssClass="form-control" />
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-search"></i> Search
                        </button>
                    </div>
                </div>
            </form:form>
        </div>
    </div>

    <!-- Results Table -->
    <div class="card shadow-sm border-0">
        <div class="card-header bg-secondary text-white fw-semibold">
            <i class="bi bi-table"></i> Search Results
        </div>
        <div class="card-body bg-white">
            <c:if test="${not empty plans}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-primary text-center">
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
                                    <td class="text-center">${index.count}</td>
                                    <td>${plan.citizenName}</td>
                                    <td>${plan.gender}</td>
                                    <td>${plan.planName}</td>
                                    <td>
                                        <span class="badge 
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
                                    <td>₹${plan.benefitAmt}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>

            <c:if test="${empty plans}">
                <div class="text-center text-muted py-4">
                    <i class="bi bi-exclamation-circle fs-3 text-warning"></i>
                    <p class="mt-2">No records found. Please modify your search filters.</p>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Export Buttons -->
    <div class="text-end mt-4">
        <p class="mb-1 fw-semibold">Export:</p>
        <a href="export/pdf" class="btn btn-outline-danger me-2">
            <i class="bi bi-file-earmark-pdf"></i> PDF
        </a>
        <a href="export/excel" class="btn btn-outline-success">
            <i class="bi bi-file-earmark-spreadsheet"></i> Excel
        </a>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
