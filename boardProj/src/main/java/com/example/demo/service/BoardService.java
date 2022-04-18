package com.example.demo.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.example.demo.idgen.service.IdgenService;
import com.example.demo.mapper.BoardMapper;
import com.example.demo.model.BoardDTO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class BoardService {
	
	@Resource
	BoardMapper board;
	
	@Resource(name = "boardIdgen")
	private IdgenService boardIdgen;
	
	public List<BoardDTO> BoardTotalListAjax(HashMap<String, Object> map) throws Exception {
		List<BoardDTO> list = board.list(map);
		return list;
	}
	
	public int BoardTotalCnt() throws Exception {
        return board.boardTotalCnt();
    }
	
	public HashMap<String, Object> BoardDetail(HashMap<String, Object> map) throws Exception {
		return board.boardDetail(map);
	}
	
	public void IncrementNttRdCnt(String bor_key_id){
		board.incrementNttRdCnt(bor_key_id);
	}
	
	public boolean BoardListUp(String bor_key_id) throws Exception{
		boolean chk = true;
		
		int cnt = board.boardListUp(bor_key_id); 
		if(cnt < 1) {
			chk = false;
		}
		
		return chk;
	}
	
	public boolean BoardListDown(String bor_key_id) throws Exception{
		boolean chk = true;
		
		int cnt = board.boardListDown(bor_key_id); 
		if(cnt < 1) {
			chk = false;
		}
		
		return chk;
	}
	
	public void BoardDelete(HashMap<String, Object> map) throws Exception {
		board.boardOrder(map);
		board.boardDelete(map);
	}
	
	public HashMap<String, Object> BoardInsert(HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> insert = new HashMap<String, Object>();
		
		boolean chk = true;
		String bor_key_id = boardIdgen.getNextStringId();
		map.put("bor_key_id", bor_key_id);
		int cnt = board.boardInsert(map);
		
		if(cnt < 1)
			chk = false;
		
		insert.put("chk", chk);
		insert.put("bor_key_id", bor_key_id);
		
		return insert;
	}
	
	public HashMap<String, Object> BoardModify(HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> modfiy = new HashMap<String, Object>();
		
		boolean chk = true;
		
		int cnt = board.boardModify(map);
		
		if(cnt < 1)
			chk = false;
		
		modfiy.put("chk", chk);
		modfiy.put("bor_key_id", String.valueOf(map.get("bor_key_id")));
		
		return modfiy;
	}
	
}
