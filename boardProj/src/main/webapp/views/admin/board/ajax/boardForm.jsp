<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" href='<c:url value="/resources/css/admin/board/ajax/boardForm.css" />'>
<link rel="stylesheet" href='<c:url value="/resources/css/ckeditor5.css" />'>

<div class="wd_80 tm_c">
	<form id="borForm">
		<!-- <div>제목</div> -->
		<div class="writeTitle">
			<input type="text" id="title" name="title" placeholder="제목을 입력하세요" value="${detail.TITLE}"/>
		</div>
		
		<c:if test="${board.type eq 'detail' }">
			<div align="right">
				<span>등록일 : ${detail.REG_DATE}</span>
				<span>조회수 : ${detail.VIEW_CNT}</span>
			</div>
		</c:if>
		
		<textarea rows="10" cols="30" id="content" name="content">${detail.CONTENT}</textarea>
		
			<!-- <div>파일</div> -->
		<div class="createFile">
			<c:if test="${board.type eq 'insert' || board.type eq 'modify'}">
				<button id="btn-upload" type="button">파일 추가</button>
		  		<input id="input_file" multiple="multiple" type="file">
		  		<span style="font-size:10px; color: gray;">※첨부파일은 최대 3개까지 등록이 가능합니다.</span>
			</c:if>
		  		<div class="data_file_txt" id="data_file_txt">
					<span>첨부 파일</span>
					<br />
					<c:choose>
						<c:when test="${board.type eq 'detail' && !empty files}">
							<ul>
								<c:forEach items="${files}" var="file">
									<li><span>${file.ORIGINAL_FILE_NAME}</span> 
		             				<a href="#" onclick="fnFileDown('${file.ORIGINAL_FILE_NAME}','${file.SAVED_FILE_NAME}'); return false;">[download]</a>
								</c:forEach>
							</ul>
						</c:when>
						<c:otherwise>
							<div id="articlefileChange">
								<c:forEach items="${files}" var="file">
									<div id="${file.FILE_KEY_ID}" onclick="deleteFile('${file.FILE_KEY_ID}')">
										<font style="font-size:12px">${file.ORIGINAL_FILE_NAME}</font>
										<img src="/resources/img/icon_minus.png" class="minus_icon"/>
									</div>
								</c:forEach>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
		</div>
		
		<input type="hidden" name="bor_key_id" id="bor_key_id">
		<input type="hidden" name="type" id="type">
		<input type="hidden" value="${board.cntPerPage}" name="cntPerPage">
		<input type="hidden" value="${board.pageSize}" name="pageSize">
		<input type="hidden" value="${board.currentPage}" name="currentPage">
	</form>
	
	<div class="move" align="right">
		<c:if test="${board.type eq 'insert'}">
			<button onclick="fn_Type('insert')">등록</button>
		</c:if>
		
		<c:if test="${board.type eq 'detail'}">
			<button onclick="fn_Type('modifyForm')">수정</button>
			<button onclick="fn_Type('delete')">삭제</button>
		</c:if>
		
		<c:if test="${board.type eq 'modify'}">
			<button onclick="fn_Type('modify')">수정</button>
		</c:if>
		
		<button onclick="fn_ListGo()">목록</button>
	</div>
</div>

<script>
function deleteFile(file_key_id) { 
	$("#"+file_key_id).remove(); 
	if (!deleteFileList.includes(file_key_id)) { 
		deleteFileList.push(file_key_id);
		fileCount --;
	} 
}

fnFileDown = function(originalName, saveName) {
	location.href = "/fileDownload?originalName=" + originalName + "&saveName=" + saveName;
}

var msg = "등록 성공";

$(function() {
	var _type = '${board.type}';
	
	if(_type == 'detail') {
		$("#title").attr("disabled", true);
		ckeditor.isReadOnly = true;
	}else if(_type == 'modify') {
		msg = "수정 성공";
	}

});
var ckeditor;
ClassicEditor 
.create( document.querySelector( '#content' ), {
	ckfinder: {
		uploadUrl : 'http://localhost:8088/ckeditor/file_upload.do',
	}
}).then(
    newEditor => {
        ckeditor = newEditor;
      }
    ).catch(error=> {
      console.error(error);
});

fn_Type = function(type) {
	var url = "/admin/board/ajax/boardType";
	
	if(type =='modifyForm') {
		fn_ListType("modifyForm", '${board.bor_key_id}');
		return;
	}
	
	if(type == 'insert' || type == 'modify') {
		var content = ckeditor.getData();
		$('#content').val(content);
		
		if($("#title").val() == '') {
			alert("제목을 입력해주세요.");
			$("#title").focus();
			return;
		}
		if(content == '') {
			alert("내용을 입력해주세요.");
			ckeditor.focus();
			return;
		}
	}
	
	$("#type").val(type);
	$("#bor_key_id").val('${board.bor_key_id}');
	var form = $("#borForm").serialize();
	
	$.ajax({
   	      type: "POST",
   	      url: url,
       	  data : form,
   	      success: function (data) {
   	     	if(data.chk) {
   	    		if(type == 'insert') {
   	    			if(fileCount > 0) {
		   	    		fileUpload(data.bor_key_id);
   	    			}else {
	   	    			alert(msg);
	   	    			fn_ListType("detail", data.bor_key_id);
   	    			}
   	    		}else if(type == 'delete') {
   	    			fn_ListGo();
   	    		}else if(type == 'modify') {
   	    			if(${fn:length(files)} == fileCount && deleteFileList.length == 0) { // 파일수정이 없다.
	   	    			alert(msg);
	   	    			fn_ListType("detail", data.bor_key_id);
   	    			}else {
   	    				fileUpload(data.bor_key_id);
   	    			}
   	    		}
   	    	 }else {
	   	    	alert("서버오류로 지연되고있습니다. 잠시 후 다시 시도해주시기 바랍니다.");
   	    	 }
   	      },error: function (xhr, status, error) {
   	    	alert("서버오류로 지연되고있습니다. 잠시 후 다시 시도해주시기 바랍니다.");
   	      }
   	    });
}
var deleteFileList = new Array();

function fileUpload(bor_key_id) {
	var form = $("form")[0];        
 	var formData = new FormData(form);
 	
	for (var x = 0; x < content_files.length; x++) {
		// 삭제 안한것만 담아 준다. 
		if(!content_files[x].is_delete){
			formData.append("multipartFile", content_files[x]);
		}
	}
	
	formData.append("borKeyId", bor_key_id);
	formData.append("deleteFiles", deleteFileList);

	$.ajax({
   	      type: "POST",
   	   	  enctype: "multipart/form-data",
   	      url: "/admin/board/FileUpload",
       	  data : formData,
       	  processData: false,
   	      contentType: false,
   	      success: function (data) {
   	    	if(!data){
				alert("서버내 오류로 처리가 지연되고있습니다. 잠시 후 다시 시도해주세요");
			}else {
				alert(msg);
				fn_ListType("detail", bor_key_id);
			}
   	      },error: function (xhr, status, error) {
   	    	alert("서버오류로 지연되고있습니다. 잠시 후 다시 시도해주시기 바랍니다.");
   	      }
   	});
}

$(function() {
	// input file 파일 첨부시 fileCheck 함수 실행
	$("#input_file").on("change", fileCheck);
	
	$('#btn-upload').click(function (e) {
        e.preventDefault();
        $('#input_file').click();
    });
});

//파일 현재 필드 숫자 totalCount랑 비교값
var fileCount = ${fn:length(files)};
// 해당 숫자를 수정하여 전체 업로드 갯수를 정한다.
var totalCount = 3;
// 파일 고유넘버
var fileNum = 0;
// 첨부파일 배열
var content_files = new Array();

function fileCheck(e) {
    var files = e.target.files;
    
    // 파일 배열 담기
    var filesArr = Array.prototype.slice.call(files);
    // 파일 개수 확인 및 제한
    if (fileCount + filesArr.length > totalCount) {
      alert('파일은 최대 '+totalCount+'개까지 업로드 할 수 있습니다.');
      return;
    } else {
    	 fileCount = fileCount + filesArr.length;
    }
    
    // 각각의 파일 배열담기 및 기타
    filesArr.forEach(function (f) {
      var reader = new FileReader();
      reader.onload = function (e) {
        content_files.push(f);
        $('#articlefileChange').append(
       		'<div id="file' + fileNum + '" onclick="fileDelete(\'file' + fileNum + '\')">'
       		+ '<font style="font-size:12px">' + f.name + '</font>'  
       		+ '<img src="/resources/img/icon_minus.png" class="minus_icon"/>' 
       		+ '<div/>'
		);
        fileNum ++;
      };
      reader.readAsDataURL(f);
    });
    //초기화 한다.
    $("#input_file").val("");
  }

// 파일 부분 삭제 함수
function fileDelete(fileNum){
    var no = fileNum.replace(/[^0-9]/g, "");
    content_files[no].is_delete = true;
	$('#' + fileNum).remove();
	fileCount --;
}

fn_ListGo = function() {
	searchList('${board.currentPage}', '${board.cntPerPage}', '${board.pageSize}');
}

</script>    



