<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "user.UserDAO" %>
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
	String userID = null; //
	if (session.getAttribute("userID") != null) // 세션 값이 있다면
	{
		userID = (String) session.getAttribute("userID");
	}
	if (userID != null)
	{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인이 된 상태입니다.');");
		script.println("location.href = 'index.jsp';");
		script.println("</script>");
		script.close();	
		return;
	
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
	
	<!-- section : 본문역할 -->
	<section class="container mt-3"  style="max-width:560px;">
		<form method="post" action="./userLoginAction.jsp">
			<div class="form-group">
			<label>아이디</label>
			<input type="text" name="userID" class="form-control"> 
			</div>
			<div class="form-group">
				<label>비밀번호</label>
				<input type="password" name="userPassword" class="form-control">
			</div>
			<button type="submit" class="btn btn-primary">로그인</button>
		</form>
		
		
	</section>
	
	
	
	<footer class = "bg-dark mt-4 p-5 text-center" style = "color: #FFFFFF;">
		Copyright &copy; 2021 Iot 216기
	</footer>
	<!--  Jquery 자바스크립트 추가 -->
	<script src = "./js/jquery.min.js"></script>
	<script src = "./js/popper.min.js"></script>
	<script src = "./js/bootstrap.min.js"></script>
</body>
</html>