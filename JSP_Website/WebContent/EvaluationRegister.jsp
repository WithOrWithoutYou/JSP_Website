<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%>

<%

	request.setCharacterEncoding("UTF-8");
	String userID = null;
	String userPassword = null;
	String userEmail = null;
	
	if(request.getParameter("userID") != null) 
	{
		userID = (String) request.getParameter("userID");
	}

	if(request.getParameter("userPassword") != null) 
	{
		userPassword = (String) request.getParameter("userPassword");
	}

	if(request.getParameter("userEmail") != null) 
	{
		userEmail = (String) request.getParameter("userEmail");
	}
	
	if (userID == null || userPassword == null || userEmail == null) 
	{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
	}
	// 평가 등록 과정 입니다. 아이디,비밀번호,이메일이 인증된 회원만 
	else 
	{
		UserDAO userDAO = new UserDAO();
		int result = userDAO.join(new UserDTO(userID, userPassword, userEmail, SHA256.getSHA256(userEmail), false));
		if (result == -1) 
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 존재하는 아이디입니다.');"); // 당연히 Join에 실패하여 -1을 반환 받은 경우에는
			script.println("history.back();");	// 이미 존재하는 아이디 임으로.
			script.println("</script>");
			script.close();
		}
		else 
		{
			session.setAttribute("userID", userID);
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'emailSendAction.jsp';");
			script.println("</script>");
			script.close();
		}
	}
%>

