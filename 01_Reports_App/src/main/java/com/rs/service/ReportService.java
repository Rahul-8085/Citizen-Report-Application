package com.rs.service;

import java.util.List;

import com.rs.entity.CitizenPlan;
import com.rs.request.SearchRequest;

public interface ReportService {
public List<String> getPlanNames();
public List<String> getPlanStatuses();
public List<CitizenPlan> search(SearchRequest request);
public boolean exportExcel();
public boolean exportPDF();
}
