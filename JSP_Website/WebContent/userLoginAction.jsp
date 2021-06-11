<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO" %>    
<%@ page import="user.UserDAO" %>    
<%@ page import="util.SHA256" %>    
<%@ page import="java.io.PrintWriter" %>    
 
<%
	//실질적으로 로그인을 처리시켜주는 액션페이지 입니다!
	request.setCharacterEncoding("UTF-8");
	String userID =null;
	String userPassword =null;
	if(request.getParameter("userID") != null)
	{
		userID=request.getParameter("userID");
	}
	
	if(request.getParameter("userPassword") != null)
	{
		userPassword=request.getParameter("userPassword");
	}
	// 입력받은 유저 아이디, 혹은 비밀번호가 널값이라면
	if(userID ==null || userPassword ==null)
	{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안된 사항이 있습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	// 정상적으로 입력이 됐다면, 객체를 생성한 뒤, 그 객체의 로그인함수를 받아온 매개변수를 통해 실행시켜줍니다.
	UserDAO userDAO = new UserDAO();
	int result = userDAO.login(userID, userPassword);
	if(result == 1)
	{	//결과 값이 1 이라면, 정상적으로 실행된 것 입니다!
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href='index.jsp'");
		script.println("</script>");
		script.close();
		return;
	} 
	else if(result ==0)
	{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('비밀번호가 틀립니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	else if(result == -1) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('존재하지 않는 아이디입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	else if(result == -2) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류가 발생했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
%>