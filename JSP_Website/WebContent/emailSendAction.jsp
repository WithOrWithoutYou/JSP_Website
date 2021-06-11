<%@page import="javax.mail.Transport"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Address"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.Session"%>
<%@page import="javax.mail.Authenticator"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="user.UserDAO"%>
<%@page import="util.SHA256"%>
<%@page import="util.Gmail"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	UserDAO userDAO = new UserDAO();
	String userID = null;
	if(session.getAttribute("userID") != null)
	{
		userID = (String) session.getAttribute("userID");
	}

	if(userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = 'userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;

	}
	boolean emailChecked = userDAO.getUserEmailChecked(userID);
	if(emailChecked == true) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 인증 된 회원입니다.');");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();		
		return;
	}

	

	// 사용자에게 보낼 메시지를 기입합니다.
	String host = "http://localhost:8080/NewProject/";
	String from = "TestJun1537@gmail.com";
	String to = userDAO.getUserEmail(userID);
	String subject = "U Can Do it 입니다. 이메일 확인 메일입니다.";
	String content = "다음 링크에 접속하여 이메일 확인을 진행하세요." +
		"<a href='" + host + "emailCheckAction.jsp?code=" + new SHA256().getSHA256(to) + "'>이메일 인증하기</a>";

	

	// SMTP에 접속하기 위한 정보를 기입합니다.
	Properties p = new Properties();
	p.put("mail.smtp.user", from);
	p.put("mail.smtp.host", "smtp.googlemail.com"); // smtp도 OSI 7계층 하면서 본 기억이 난다. 나중에 정리해두자
	p.put("mail.smtp.port", "465");
	p.put("mail.smtp.starttls.enable", "true"); // TSL.. 이것도 OSI 7계층 하면서 봤는데
	p.put("mail.smtp.auth", "true");
	p.put("mail.smtp.debug", "true");
	p.put("mail.smtp.socketFactory.port", "465");
	p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	// SSL/TSL 이거 정보처리기사 하면서 본거같은데.. 
	p.put("mail.smtp.socketFactory.fallback", "false");

	 
	// email 인증을 위한 일련의 과정들, 그냥 이런게 있구나! 하는 정도로만 알아두고, 
	// DB 활용과 DTO 및 DAO를 통한 구현과정을 먼저 익힌 후, 이메일 전송 과정을 공부하기로 하자!
	try{
	    Authenticator auth = new Gmail();
	    Session ses = Session.getInstance(p, auth);
	    ses.setDebug(true);
	    MimeMessage msg = new MimeMessage(ses); 
	    msg.setSubject(subject);
	    Address fromAddr = new InternetAddress(from);
	    msg.setFrom(fromAddr);
	    Address toAddr = new InternetAddress(to);
	    msg.addRecipient(Message.RecipientType.TO, toAddr);
	    msg.setContent(content, "text/html;charset=UTF-8");
	    Transport.send(msg);
	} 
	catch(Exception e)
	{
	    e.printStackTrace();
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('오류가 발생했습니다..');");
		script.println("history.back();");
		script.println("</script>");
		script.close();		
	    return;
	}

%>
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
	if(request.getParameter("pageNumber")!=null)
	{
		try
		{
		pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
		catch(Exception e)
		{
			System.out.println("검색 페이지 번호 오류");
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
					<a class = "nav-link" href="Board.jsp">Board</a>
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
	<div class="container">
	    <div class="alert alert-success mt-4" role="alert">
		  이메일 주소 인증 메일이 전송되었습니다. 이메일에 들어가셔서 인증해주세요.
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