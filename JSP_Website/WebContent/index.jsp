<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "user.UserDAO" %>
<%@ page import = "user.UserDTO" %>

<%@ page import = "evaluation.EvaluationDTO" %>
<%@ page import = "evaluation.EvaluationDAO" %>
<%@ page import = "java.util.ArrayList" %>
<%@ page import = "java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name = "viewport" content = "width=device-width, initial-scale =1, shrink-to-fit=no">
	<!-- 반응형 웹을 위한 설정 입니다. 창의 크기를 줄이면 그에 맞게끔 작아지거나 커집니다. -->
	
	
	<title>웹사이트</title>
	
	<!-- CSS 추가하기 -->
	<link rel ="stylesheet" href="./css/bootstrap.min.css">
	<link rel ="stylesheet" href="./css/custom.min.css">
	<!-- CSS 추가하기 -->
		
</head>
<body>
<%

	request.setCharacterEncoding("UTF-8");
	String lectureDivide = "전체";
	String searchType = "최신순";
	String search = "";
	UserDTO user = new UserDTO();
	int pageNumber = 0;
	if (request.getParameter("lectureDivide") != null)
	{
		lectureDivide = request.getParameter("lectureDivide");
	}
	if (request.getParameter("searchType") != null)
	{
		searchType = request.getParameter("searchType");
	}
	if (request.getParameter("search") != null)
	{
		search = request.getParameter("search");
	}
	if(request.getParameter("pageNumber")!=null){
		try{
		pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		} catch(Exception e){
			System.out.println("검색 페이지 번호 오류");
		}
	}
	
	
	String userID = null; //
	if (session.getAttribute("userID") != null) // 세션 값이 있다면
	{
		userID = (String) session.getAttribute("userID");
	}
	if (userID == null)
	{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요!');");
		script.println("location.href = 'userLogin.jsp';");
		script.println("</script>");
		script.close();		
	}
	
	boolean emailChecked = new UserDAO().getUserEmailChecked(userID);
	{
		if(emailChecked == false)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'emailSendConfirm.jsp'");
			script.println("</script>");
			script.close();		

		}
	}
%>

	<nav class ="navbar navbar-expand-lg navbar-light bg-light">
		<a class = "navbar-brand" href ="index.jsp">U CAN DO IT !</a>
		<button class="navbar-toggler" type="button" data-toggle = "collapse" data-target="#navbar">
			<span class ="navbar-toggler-icon"></span>
		</button>
		<div id = "navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class = "nav-item active">
					<a class = "nav-link" href="index.jsp">Main</a>
				</li>
				<li class = "nav-item active">
					<a class = "nav-link" href="board.jsp">Board</a>
				</li>
				
				
				
				<li class = "nav-item dropdown">
					<a class = "nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">
						Manage
					</a>
					
					<div class = "dropdown-menu" aria-labelledby="dropdown">
				<%  // 복잡해보이지만 별거 아니다. 로그인 안했으면 로그인 및 회원가입이 보이고, 로그인을 했으면 로그아웃만 보인다!
					if(userID == null) {
				%>
					
					<a class = "dropdown-item" href="userLogin.jsp"> Login </a>
					<a class = "dropdown-item" href="userJoin.jsp"> Register </a>
<%
					} else {
%>	
						
						<a class = "dropdown-item" href="userLogout.jsp"> Logout </a>
<%
	}
%>
					</div>
					
				</li>
				
				
			</ul>
			<form action = "./index.jsp" method = "get"  class= "form-inline my-2 my-lg-0">
				<input type = "text" name = "search" class ="form-control mr-sm-2" type = "search" placeholder = "Type here!">
				<button class = "btn btn-outline-success my-2 my-sm-0" type="submit"> Search </button>		
			</form>
			
		</div>
						
	</nav>
	
	<section class = "container">
		<form method = "get" action ="./index.jsp" class = "form-inline mt-3">
			<select name = "lectureDivide" class = "form-control mx-1 mt-2">
				<option value ="전체"> 전체 </option>
				<option value ="공부" <% if(lectureDivide.equals("공부")) out.println("selected"); %>> 공부 </option>
				<option value ="운동" <% if(lectureDivide.equals("운동")) out.println("selected"); %>> 운동 </option>
				<option value ="기타" <% if(lectureDivide.equals("기타")) out.println("selected"); %>> 기타 </option>
			</select>
			
			<select name = "searchType" class = "form-control mx-1 mt-2">
				<option value ="최신순"> 최신순 </option>
				<option value ="추천순" <% if(searchType.equals("추천순")) out.println("selected"); %>> 추천순 </option>
			</select>
			
			<input type="text" name ="search" class="form-control mx mt-2" placeholder="Type here">
			<button type="submit" class="btn btn-primary mx-1 mt-2"> Search </button>
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#registerModal"> 등록하기 </a>
			<a class="btn btn-danger mx-1 mt-2" data-toggle="modal" href="#reportModal"> 신고하기 </a>
		
		<!-- 크기를 등록 창과 같게 해주고 싶습니다. 따라서 섹션 안에 넣어줘야 해요 -->
		<!-- 하나의 카드 섹션 입니다 -->
		</form>
		
<%
	// 
	ArrayList<EvaluationDTO> evaluationList = new ArrayList<EvaluationDTO>(); // 반환리스트 생성. 
	evaluationList = new EvaluationDAO().getList(lectureDivide, searchType, search, pageNumber);
	
	if (evaluationList != null)
	{
		for (int i = 0; i<evaluationList.size(); i++)
		{
			if (i==5) break;
			EvaluationDTO evaluation = evaluationList.get(i);
			
	
%>		
		
		<div class="card bg-light mt-3">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-8 text-left"><%= evaluation.getLectureName() %>
						&nbsp;<small><%= evaluation.getProfessorName() %></small>
						
					
					</div>
					
				
					<div class="col-2 text-right">		
						종합<span style="color: red;"><%= evaluation.getTotalScore() %></span>		
					</div>
				</div>
			</div>
			<div class="card-body">
				<h5 class="card-title">
					<%= evaluation.getEvaluationTitle() %> &nbsp;<small>(<%= evaluation.getLectureYear() %>년 <%= evaluation.getSemesterDivide() %>)</small>
				</h5>
				<p class="card-text"><%= evaluation.getEvaluationContent() %></p>
				<div class="row">
					<div class="col-9 text-left">
						집중력<span style="color: red;"><%= evaluation.getCreditScore() %></span> 
						목표치<span style="color: red;"><%= evaluation.getComfortableScore() %></span>
						만족도<span style="color: red;"><%= evaluation.getLectureScore() %></span> 
						<span style="color: green;">(추천:<%= evaluation.getLikeCount() %>)</span>
					</div>
					<div class="col-3 text-right">
						<a onclick="return confirm('추천하시겠습니까?')" href="./likeAction.jsp?evaluationID=<%= evaluation.getEvaluationID() %>">추천</a> 
						<a onclick="return confirm('삭제하시겠습니까?')"	href="./deleteAction.jsp?evaluationID=<%= evaluation.getEvaluationID() %>">삭제</a>
					</div>
				</div>
			</div>
		</div>
		<!-- 하나의 카드 섹션 입니다 -->
		
<%
		}
	}
%>		
		
		
	<ul class="pagination justify-content-center mt-3">
		<li class="page-item">
		
<%
		if(pageNumber<=0){
%>
		<!-- pageNumber가 첫 페이지 일때 그 전페이지로 못가게 하기위해 disabled를 쓴다. -->
		<a class="page-link disabled">이전</a>
<%
		} else{
%>
		<!-- 특정한 URL로 이동할때 URLEncoder를 이용한다. LectureDivide값은 유지한채로 다음 페이지로 이동한다. -->
		<a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide,"UTF-8") %>&searchType=
		<%=URLEncoder.encode(searchType,"UTF-8") %>&search=<%=URLEncoder.encode(search,"UTF-8") %>&pageNumber=
		<%= pageNumber-1 %>">이전</a>
<%
		}
%>
		</li>
		<li>
<%
	if(evaluationList.size()<6){
%>
		<!-- pageNumber가 첫 페이지 일때 그 전페이지로 못가게 하기위해 disabled를 쓴다. -->
		<a class="page-link disabled">다음</a>
<%
		} else{
%>
		<!-- 특정한 URL로 이동할때 URLEncoder를 이용한다. LectureDivide값은 유지한채로 다음 페이지로 이동한다. -->
		<a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide,"UTF-8") %>&searchType=
		<%=URLEncoder.encode(searchType,"UTF-8") %>&search=<%=URLEncoder.encode(search,"UTF-8") %>&pageNumber=
		<%= pageNumber+1 %>">다음</a>
<%
	}
%>
		</li>
	</ul>
	
	
	<!-- 등록하기를 누르면 폼이 뜨게 해주는 것 입니다 -->
	<div class = "modal fade" id = "registerModal" tabindex = "-1" role ="dialog" aria-labelledby = "modal">
		<div class = "modal-dialog">
			<div class ="modal-content">
				<div class = "modal-header">
					<h5 class = "modal-title" id ="modal"> 평가 등록 </h5>
					<button type ="button" class= "close" data-dismiss="modal" aria-lable ="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<!-- 모달 바디내용  등등-->
				<div class = "modal-body">
					<form action = "./EvaluationRegisterAction.jsp" method = "post"> 
					<div class = "form-row">
						<div class = "form-group col-sm-6">
							<label> 게시글 </label>
							<input type = "text" name = "lectureName" class ="form-control" maxlength="20">
						</div>
						
						<div class = "form-group col-sm-6">
							<label> 부제목 </label>
							<input type = "text" name = "professorName" class ="form-control" maxlength="20">
						</div>
					</div>
					
					<div class = "form-row">
						<div class = "form-group col-sm-4">
							<label> 년도 </label>
							<select name ="lectureYear" class = "form-control">
								<option value ="2011"> 2011 </option>
								<option value ="2012"> 2012 </option>
								<option value ="2013"> 2013 </option>
								<option value ="2014"> 2014 </option>
								<option value ="2015"> 2015 </option>
								<option value ="2016"> 2016 </option>
								<option value ="2017"> 2017 </option>
								<option value ="2018"> 2018 </option>
								<option value ="2019"> 2019 </option>
								<option value ="2020"> 2020 </option>
								<option value ="2021" selected> 2021 </option>
								<option value ="2022"> 2022 </option>
								<option value ="2023"> 2023 </option>
							</select>
						</div>
						<div class = "form-group col-sm-4">
							<label> 계절 </label>
							<select name = "semesterDivide" class = "form-control">
								<option value = "봄" selected> 봄 </option>
								<option value = "여름" selected> 여름 </option>
								<option value = "가을" selected> 가을 </option>
								<option value = "겨울" selected> 겨울 </option>
							</select>
						</div>
						<div class = "form-group col-sm-4">
							<label> 게시글 타입 </label>
							<select name = "lectureDivide" class = "form-control">
								<option value = "공부" selected> 공부 </option>
								<option value = "운동" selected> 운동 </option>
								<option value = "기타" selected> 기타 </option>
							</select>
						</div>						
					</div>
					
					<!-- 내용 등록하기  -->
					<div class = "form-group">
						<label> 제목 </label>
						<input type="text" name = "evaluationTitle" class ="form-control" maxlength="30">
					</div>
					<div class = "form-group">
						<label> 내용 </label>
						<textarea name ="evaluationContent" class = "form-control" maxlength="2048" style= "height : 180px;"></textarea>
					</div>
					
					<div class = "form-row">
						<div class = "form-group col-sm-3">
							<label> 종합점수 </label>
							<select name = "totalScore" class = "form-control">
								<option value = "A" selected> A </option>
								<option value = "B" > B </option>
								<option value = "C" > C </option>
								<option value = "D" > D </option>
								<option value = "F" > F </option>
							</select>
						</div>
					
					
					
						<div class = "form-group col-sm-3">
							<label> 집중력 </label>
							<select name = "comfortableScore" class = "form-control">
								<option value = "A" selected> A </option>
								<option value = "B" > B </option>
								<option value = "C" > C </option>
								<option value = "D" > D </option>
								<option value = "F" > F </option>
							</select>
						</div>
					
					
					
						<div class = "form-group col-sm-3">
							<label> 목표달성치 </label>
							<select name = "creditScore" class = "form-control">
								<option value = "A" selected> A </option>
								<option value = "B" > B </option>
								<option value = "C" > C </option>
								<option value = "D" > D </option>
								<option value = "F" > F </option>
							</select>
						</div>
					
					
					
						<div class = "form-group col-sm-3">
							<label> 만족도 </label>
							<select name = "lectureScore" class = "form-control">
								<option value = "A" selected> A </option>
								<option value = "B" > B </option>
								<option value = "C" > C </option>
								<option value = "D" > D </option>
								<option value = "F" > F </option>
							</select>
						</div>
					</div>
					
					<div class = "modal-footer">
						<button type = "submit" class = "btn btn-primary"> 등록하기 </button>
						<button type = "button" class = "btn btn-danger" data-dismiss="modal"> 취소 </button>
					</div>
					
					
				</form>	
				</div>
			</div>
		</div>
	</div>
	
	<!-- 신고내용 모달! -->
	<div class = "modal fade" id = "reportModal" tabindex = "-1" role ="dialog" aria-labelledby = "modal">
		<div class = "modal-dialog">
			<div class ="modal-content">
				<div class = "modal-header">
					<h5 class = "modal-title" id ="modal"> 신고하기 </h5>
					<button type ="button" class= "close" data-dismiss="modal" aria-lable ="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<!-- 모달 바디내용-->
				<div class = "modal-body">
					<form action = "./reportAction.jsp" method = "post">
				
					<!-- 내용 등록하기  -->
					<div class = "form-group">
						<label> 신고 제목 </label>
						<input type="text" name = "reportTitle" class ="form-control" maxlength="30">
					</div>
					<div class = "form-group">
						<label> 신고 내용 </label>
						<textarea name ="reportContent" class = "form-control" maxlength="2048" style= "height : 180px;"></textarea>
					</div>
					
					<div class = "modal-footer">
						<button type = "submit" class = "btn btn-primary"> 신고하기 </button>
						<button type = "button" class = "btn btn-danger" data-dismiss="modal"> 취소 </button>
					</div>
					 </form>
				</div>
			</div>
		</div>
	</div>
	
	
	<footer class = "bg-dark mt-4 p-5 text-center" style = "color: #FFFFFF;">
		Copyright &copy; 2021 Iot 216기
	</footer>
	<!--  Jquery 자바스크립트 추가 -->
	<script src = "./js/jquery.min.js"></script>
	<script src = "./js/popper.min.js"></script>
	<script src = "./js/bootstrap.min.js"></script>
</body>
</html>