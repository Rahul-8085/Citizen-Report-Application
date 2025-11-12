package com.rs.service;

import java.util.List;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.stereotype.Service;

import com.rs.entity.CitizenPlan;
import com.rs.repo.CitizenPlanRepository;
import com.rs.request.SearchRequest;
@Service
public class ReportServiceImpl implements ReportService {
	@Autowired
	private CitizenPlanRepository planRepo;

	@Override
	public List<String> getPlanNames() {

		return planRepo.getPlanName();
	}

	@Override
	public List<String> getPlanStatuses() {

		return planRepo.getPlanStatus();
	}

	@Override
	public List<CitizenPlan> search(SearchRequest request) {
         CitizenPlan entity=new CitizenPlan();
         if(null!=request.getPlanName() && !"".equals(request.getPlanName()) ) {
         entity.setPlanName(request.getPlanName());
         }
         if(null!=request.getPlanStatus() && !"".equals(request.getPlanStatus()) ) {
            entity.setPlanStatus(request.getPlanStatus());
             }
         if(null!=request.getGender() && !"".equals(request.getGender()) ) {
           entity.setGender(request.getGender());
             }
		return planRepo.findAll(Example.of(entity));
	}


	@Override
	public boolean exportPDF() {
		
		return false;
	}

	@Override
	public boolean exportExcel() {
	
		return false;
	}

}
