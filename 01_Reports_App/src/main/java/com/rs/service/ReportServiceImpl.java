package com.rs.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.stereotype.Service;

import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.rs.entity.CitizenPlan;
import com.rs.repo.CitizenPlanRepository;
import com.rs.request.SearchRequest;

import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServletResponse;

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
		CitizenPlan entity = new CitizenPlan();
		if (null != request.getPlanName() && !"".equals(request.getPlanName())) {
			entity.setPlanName(request.getPlanName());
		}
		if (null != request.getPlanStatus() && !"".equals(request.getPlanStatus())) {
			entity.setPlanStatus(request.getPlanStatus());
		}
		if (null != request.getGender() && !"".equals(request.getGender())) {
			entity.setGender(request.getGender());
		}
		if (null != request.getStartDate() && !"".equals(request.getStartDate())) {
			String startDate = request.getStartDate();
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
			LocalDate localDate = LocalDate.parse(startDate, formatter);
			entity.setPlanStartDate(localDate);
		}
		if (null != request.getEndDate() && !"".equals(request.getEndDate())) {
			String endDate = request.getEndDate();
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
			LocalDate localDate = LocalDate.parse(endDate, formatter);
			entity.setPlanEndDate(localDate);
		}
		return planRepo.findAll(Example.of(entity));
	}

	@Override
	public boolean exportExcel(HttpServletResponse response) throws Exception {
		Workbook workbook = new HSSFWorkbook();
		Sheet sheet = workbook.createSheet("plans-data");
		Row headerrow = sheet.createRow(0);

		headerrow.createCell(0).setCellValue("Id");
		headerrow.createCell(1).setCellValue("Gender");
		headerrow.createCell(2).setCellValue("Citizen Name");
		headerrow.createCell(3).setCellValue("Plan Name");
		headerrow.createCell(4).setCellValue("Plan Status");
		headerrow.createCell(5).setCellValue("Plan Start Date");
		headerrow.createCell(6).setCellValue("Plan End Date");
		headerrow.createCell(7).setCellValue("Benefit Amount");

		List<CitizenPlan> records = planRepo.findAll();
		int dataRowIndex = 1;
		for (CitizenPlan plan : records) {

			Row dataRow = sheet.createRow(dataRowIndex);
			dataRow.createCell(0).setCellValue(plan.getCitizenId());
			dataRow.createCell(1).setCellValue(plan.getGender());
			dataRow.createCell(2).setCellValue(plan.getCitizenName());
			dataRow.createCell(3).setCellValue(plan.getPlanName());
			dataRow.createCell(4).setCellValue(plan.getPlanStatus());
			if (null != plan.getPlanStartDate()) {
				dataRow.createCell(5).setCellValue(plan.getPlanStartDate());
			} else {
				dataRow.createCell(5).setCellValue("N/A");
			}
			if (null != plan.getPlanEndDate()) {
				dataRow.createCell(6).setCellValue(plan.getPlanEndDate());
			} else {
				dataRow.createCell(6).setCellValue("N/A");
			}
			if (null != plan.getBenefitAmt()) {
				dataRow.createCell(7).setCellValue(plan.getBenefitAmt());
			} else {
				dataRow.createCell(7).setCellValue("N/A");
			}
			dataRowIndex++;

		}
		ServletOutputStream outputstream = response.getOutputStream();
		workbook.write(outputstream);
		workbook.close();
		return true;
	}

	@Override
	public boolean exportPDF(HttpServletResponse response) throws Exception {

	    response.setContentType("application/pdf");
	    response.setHeader("Content-Disposition", "attachment; filename=CitizenPlans.pdf");

	    Document document = new Document(PageSize.A4, 20, 20, 20, 20);
	    PdfWriter.getInstance(document, response.getOutputStream());

	    document.open();

	    // ===== Title =====
	    Font titleFont = new Font(Font.HELVETICA, 18, Font.BOLD);
	    Paragraph title = new Paragraph("Citizen Plan Information Report", titleFont);
	    title.setAlignment(Element.ALIGN_CENTER);
	    title.setSpacingAfter(20);
	    document.add(title);

	    // ===== Table =====
	    PdfPTable table = new PdfPTable(8);
	    table.setWidthPercentage(100);
	    table.setSpacingBefore(10);
	    table.setSpacingAfter(10);

	    // ===== Header Font =====
	    Font headerFont = new Font(Font.HELVETICA, 11, Font.BOLD);

	    String[] headers = {
	        "ID", "Gender", "Citizen Name", "Plan Name",
	        "Plan Status", "Plan Start Date", "Plan End Date", "Benefit Amount"
	    };

	    for (String h : headers) {
	        PdfPCell header = new PdfPCell(new Phrase(h, headerFont));
	        header.setHorizontalAlignment(Element.ALIGN_CENTER);
	        header.setPadding(8);
	        table.addCell(header);
	    }

	    // ===== Body Font =====
	    Font bodyFont = new Font(Font.HELVETICA, 10);

	    // ===== Add Rows =====
	    List<CitizenPlan> plans = planRepo.findAll();

	    for (CitizenPlan plan : plans) {
	        table.addCell(createCell(String.valueOf(plan.getCitizenId()), bodyFont));
	        table.addCell(createCell(plan.getGender(), bodyFont));
	        table.addCell(createCell(plan.getCitizenName(), bodyFont));
	        table.addCell(createCell(plan.getPlanName(), bodyFont));
	        table.addCell(createCell(plan.getPlanStatus(), bodyFont));
	        table.addCell(createCell(String.valueOf(plan.getPlanStartDate()), bodyFont));
	        table.addCell(createCell(String.valueOf(plan.getPlanEndDate()), bodyFont));
	        table.addCell(createCell(String.valueOf(plan.getBenefitAmt()), bodyFont));
	    }

	    document.add(table);
	    document.close();

	    return true;
	}


	// ===== Helper Method =====
	private PdfPCell createCell(String text, Font font) {
	    PdfPCell cell = new PdfPCell(new Phrase(
	            text != null ? text : "N/A",
	            font
	    ));
	    cell.setPadding(6);
	    cell.setHorizontalAlignment(Element.ALIGN_CENTER);
	    cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	    return cell;
	}


}
