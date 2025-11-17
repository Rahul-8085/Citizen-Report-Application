package com.rs.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.rs.entity.CitizenPlan;
import com.rs.request.SearchRequest;
import com.rs.service.ReportService;

import jakarta.servlet.http.HttpServletResponse;

@Controller
public class ReportController {
	@Autowired
	private ReportService service;
	
	
	 @GetMapping("/export/excel")
	    public void exportExcel(HttpServletResponse response) throws Exception {

	        response.setContentType("application/vnd.ms-excel");
	        response.setHeader("Content-Disposition", "attachment; filename=plans.xls");

	        service.exportExcel(response);
	    }
	


   
	@PostMapping("/search")
	public String handleSearch(SearchRequest search, Model model) {
		/* System.out.println(request); */
		List<CitizenPlan> plans=service.search(search);
		model.addAttribute("plans", plans);
		model.addAttribute("search", search);
		init(model);
		return "index";
				}
	
	@GetMapping("/")
	public String indexPage(Model model) {
		model.addAttribute("search",new SearchRequest());
		init(model);
		return "index";
	}

	private void init(Model model) {
		//model.addAttribute("search",new SearchRequest());
		model.addAttribute("names", service.getPlanNames());
		model.addAttribute("status", service.getPlanStatuses());
	}

}
