<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>    
<%@ page import="util.SHA256" %>    
<%@ page import="java.io.PrintWriter" %>    
 
<%
	request.setCharacterEncoding("UTF-8");
	String code = null;
	if(request.getParameter("code")!=null)
	{
		code=request.getParameter("code");
	}
	// 회원인증 메일을 보낸 뒤, 받아온 code값을 code에 넣어줍니다.
	UserDAO userDAO = new UserDAO();
	String userID =null;
	if(session.getAttribute("userID")!=null)
	{
		userID=(String)session.getAttribute("userID");
	}
	// 세션 및 로그인. 로그인도 안한 사람이 어떻게 인증을 받나요!
	if(userID==null)
	{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href='userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	
	String userEmail =userDAO.getUserEmail(userID);
	// userEmail 이란 문자열은 유저 이메일을 받아오는 것 입니다.
	boolean isRight = (new SHA256().getSHA256(userEmail).equals(code)) ? true : false;
	// 즉, 유저 이메일을 해쉬암호화 한 것이 이메일 인증을 통해 얻어온 code와 같다면 True를 반환하고, 아니면 false를 반환하죠
	if(isRight==true)
	{
		userDAO.setUserEmailChecked(userID);  // true라면, 유저 이메일 체크함수를 호출하여 DB의 checked를 1로 바꿔줍니다
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('인증에 성공했습니다.');");
		script.println("location.href='index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	else
	{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 코드입니다.');");
		script.println("location.href='index.jsp'");
		script.println("</script>");
		script.close();
		
	}
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>