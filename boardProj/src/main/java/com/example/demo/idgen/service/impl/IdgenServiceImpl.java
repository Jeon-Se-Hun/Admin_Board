package com.example.demo.idgen.service.impl;

import javax.annotation.Resource;

import com.example.demo.idgen.domain.IdgenVO;
import com.example.demo.idgen.repository.IdgenRepository;
import com.example.demo.idgen.service.IdgenService;

public class IdgenServiceImpl implements IdgenService{
	private String prefix; // 아이디 앞에 고정적으로 붙이고자 하는 값
	private int cipers; // prefix를 제외한 아이디의 길이지정
	private char fillChar; // 0을 대신하여 표현됨
	private String tableName; // 테이블명
	
	@Resource(name = "idgenRepository")
	private IdgenRepository idgenRepository;
	
	public String getNextStringId() {
		IdgenVO idgenVO = idgenRepository.findByTableName(tableName);
		boolean firstFlag = false;
		if(idgenVO == null) {
			idgenVO = new IdgenVO();
			idgenVO.setNextId(1);
			idgenVO.setTableName(tableName);
			firstFlag = true;
		}
		
		// 1. 아이디변수 생성(String)
		// 2. 아이디 변수 prefix를 넣고 + fillChar를 cipers-prefix.legnth-id.length 만큼 넣고 + (id+1)를 넣는다.
		String nextId = "";
		nextId = prefix;
		int fillCharSize = cipers - (int)Math.log10(idgenVO.getNextId()+1);
		for(int i = 0; i < fillCharSize; i++) {
			nextId = nextId+fillChar;
		}
		if(!firstFlag) {
			idgenVO.setNextId(idgenVO.getNextId()+1);
		}
		idgenRepository.save(idgenVO);
		nextId = nextId + String.valueOf(idgenVO.getNextId());
		return nextId;
	}

	public String getPrefix() {
		return prefix;
	}

	public void setPrefix(String prefix) {
		this.prefix = prefix;
	}

	public int getCipers() {
		return cipers;
	}

	public void setCipers(int cipers) {
		this.cipers = cipers;
	}

	public char getFillChar() {
		return fillChar;
	}

	public void setFillChar(char fillChar) {
		this.fillChar = fillChar;
	}

	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public IdgenRepository getIdgenRepository() {
		return idgenRepository;
	}

	public void setIdgenRepository(IdgenRepository idgenRepository) {
		this.idgenRepository = idgenRepository;
	}
}
