<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "user.UserDAO" %>
<%@ page import = "user.UserDTO" %>
<%@ page import = "evaluation.EvaluationDTO" %>
<%@ page import = "evaluation.EvaluationDAO" %>
<%@ page import = "java.util.ArrayList" %>
<%@ page import = "java.net.URLEncoder" %>
<%@ page import = "bbs.BbsDAO" %>
<%@ page import = "bbs.Bbs" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name = "viewport" content = "width=device-width, initial-scale =1, shrink-to-fit=no">
	<!-- 반응형 웹을 위한 설정 입니다. 창의 크기를 줄이면 그에 맞게끔 작아지거나 커집니다. -->
	
	
	<title>웹사이트</title>
	<style type="text/css">
		a, a:hover{
			color: #000000;
			text-decoration : none;
		}
		
	</style>
	<!-- CSS 추가하기 -->
	<link rel ="stylesheet" href="./css/bootstrap.min.css">
	<link rel ="stylesheet" href="./css/custom.min.css">
	<!-- CSS 추가하기 -->
		
</head>
<body>
<%
	// 게시글 목록을 추가하기 위한 것.
	int boardPageNumber = 1;
	
	if(request.getParameter("boardPageNumber") != null)
	{
		boardPageNumber = Integer.parseInt(request.getParameter("boardPageNumber"));
	}
	// 게시글 목록을 추가하기 위한 것.
	
	
	request.setCharacterEncoding("UTF-8");
	String lectureDivide = "전체";
	String searchType = "최신순";
	String search = "";
	
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
			<a class="btn btn-primary mx-1 mt-2"  href="./write.jsp"> 게시글 </a>
			<a class="btn btn-danger mx-1 mt-2" data-toggle="modal" href="#reportModal"> 신고하기 </a>
		
		<!-- 크기를 등록 창과 같게 해주고 싶습니다. 따라서 섹션 안에 넣어줘야 해요 -->
		<!-- 하나의 카드 섹션 입니다 -->
		</form>

	
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
	</section>
	<!-- 게시글을 보이게 합시다. -->
	
	<div class = "container">
		<div class = "row">
			<table class = "table table-striped" style = "text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th style = "background-color: #eeeeee; text-align: center;">번호</th>
						<th style = "background-color: #eeeeee; text-align: center;">제목</th>
						<th style = "background-color: #eeeeee; text-align: center;">작성자</th>
						<th style = "background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
		
				<tbody>
				<%
				BbsDAO bbsDAO = new BbsDAO();
				ArrayList<Bbs> list = bbsDAO.getList(pageNumber);
				for(int i=0; i<list.size(); i++)
				{
				%>
				<tr>
					<td><%= list.get(i).getBbsID()%></td>
					<td><a href = "view.jsp?bbsID=<%= list.get(i).getBbsID() %>"> <%=list.get(i).getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt").replaceAll("\n","<br>") %> </a></td>
					<td><%= list.get(i).getUserID()%></td>
					<td><%= list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11, 13) + "시 " + list.get(i).getBbsDate().substring(14,16) + "분 " %></td>
				</tr>
				<%
				}
				%>
				
				</tbody>
			</table>
			<%
				if (boardPageNumber != 1)
				{
			%>
				<a href="board.jsp?boardPageNumber=<%= boardPageNumber -1 %>" class="btn btn-success btn-arraw-left"> 이전 </a>
			<%
				} if(bbsDAO.nextPage(boardPageNumber + 1)) { // 다음페이지가 존재하나요?
			%>
				<a href="board.jsp?boardPageNumber=<%= boardPageNumber +1 %>" class="btn btn-success btn-arraw-left"> 다음 </a>
			<%
				}
			%>	
		
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