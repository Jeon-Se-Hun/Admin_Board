package com.example.demo.context;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.example.demo.idgen.service.impl.IdgenServiceImpl;

@Configuration
public class ContextIdgen {
	@Bean(name = "boardIdgen")
	public IdgenServiceImpl boardIdgen() {
		IdgenServiceImpl idgenServiceImpl = new IdgenServiceImpl();
		idgenServiceImpl.setCipers(3);
		idgenServiceImpl.setFillChar('0');
		idgenServiceImpl.setPrefix("BOR_");
		idgenServiceImpl.setTableName("BOARD");
		return idgenServiceImpl;
	}
	
	@Bean(name = "fileIdgen")
	public IdgenServiceImpl fileIdgen() {
		IdgenServiceImpl idgenServiceImpl = new IdgenServiceImpl();
		idgenServiceImpl.setCipers(3);
		idgenServiceImpl.setFillChar('0');
		idgenServiceImpl.setPrefix("FILE_");
		idgenServiceImpl.setTableName("UPFILE");
		return idgenServiceImpl;
	}
}
