<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="user.UserDAO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="likey.likeyDAO"%>
<%@ page import="java.io.PrintWriter"%>

<%!
	public static String getClientIP(HttpServletRequest request)
	{
		String ip = request.getHeader("X-FORWARDED-FOR");
		/* 프록시서버를 사용한 사용자라도 아이피를 갖고올수 있게 해줌. */
		if (ip == null || ip.length() == 0)
		{
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0)
		{
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0)
		{
			ip = request.getRemoteAddr();
		}
		return ip;
	}
%>

<%
	// 세션검사
	String userID = null;
	if (session.getAttribute("userID") != null)
	{
		userID = (String) session.getAttribute("userID");
	}
	if (userID == null) 
	{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href='userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	
	
	request.setCharacterEncoding("UTF-8");
	String evaluationID = null;
	
	if (request.getParameter("evaluationID") != null)
	{
		evaluationID = request.getParameter("evaluationID");
	}
	EvaluationDAO evaluationDAO = new EvaluationDAO();
	likeyDAO likeyyDAO = new likeyDAO(); // DAO만들 때 대문자로 해야하는데 실수해서 소문자 넣었네요... likeyy <- y가 2개입니다.
	int result = likeyyDAO.like(userID,evaluationID, getClientIP(request));
	// like 함수를 실행,
		if (result == 1) 
		{
			result = evaluationDAO.like(evaluationID);
			if(result == 1 )
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('추천이 완료되었습니다.');");
				script.println("location.href='index.jsp'");
				script.println("</script>");
				script.close();
				return;
			} 
			else
			{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('추천이 완료됐습니다');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
			}
		} 
		// if( result != 1 ) 즉, Like 함수에서 1이 반환되지 않은 경우는 실패한 경우를 뜻합니다.
		else 
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 추천을 누른 글입니다.');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
		}
	
%>