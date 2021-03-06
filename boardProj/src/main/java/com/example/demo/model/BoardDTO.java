package com.example.demo.model;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class BoardDTO {
	String bor_key_id, title, content, del_YN; 
	Integer view_cnt, bor_order;
	Date reg_date, up_date;
}
