package com.rs.service;

import java.util.List;

import com.rs.entity.CitizenPlan;
import com.rs.request.SearchRequest;

import jakarta.servlet.http.HttpServletResponse;

public interface ReportService {
public List<String> getPlanNames();
public List<String> getPlanStatuses();
public List<CitizenPlan> search(SearchRequest request);
public boolean exportExcel(HttpServletResponse response)throws Exception;
public boolean exportPDF() ;
}
