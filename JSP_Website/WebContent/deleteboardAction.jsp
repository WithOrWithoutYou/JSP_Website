<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
	// deleteboardAction은 게시판의 게시글을 삭제하는 액션입니다. deleteAction과 차이가 있지요!
		String userID = null;
			if (session.getAttribute("userID") != null) 
			{
				userID = (String)session.getAttribute("userID");
			}
			if ( userID == null)
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('로그인을 하세요.')");
				script.println("location.href = 'login.jsp'");
				script.println("</script>");
			}
			
			int bbsID = 0;
			// url에 bbsID가 넘어온다면 bbsID 변수에 정보 저장
			if(request.getParameter("bbsID") != null)
			{
				bbsID = Integer.parseInt(request.getParameter("bbsID"));
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('삭제가 완료됐습니다!')");
				script.println("location.href = 'board.jsp'");
				script.println("</script>");
			}
			if (bbsID == 0)
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('유효하지 않은 글입니다.')");
				script.println("location.href = 'board.jsp'");
				script.println("</script>");
			}
			
			// 
			Bbs bbs = new BbsDAO().getBbs(bbsID);
			if(!userID.equals(bbs.getUserID())){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('권한이 없습니다.')");
				script.println("location.href = 'board.jsp'");
				script.println("</script>");
			} 
			
			else
			{
				BbsDAO bbsDAO = new BbsDAO();
				int result = bbsDAO.delete(bbsID);
				if (result == -1)
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('삭제에 실패했습니다... 무엇이 오류일까요..?')");
					script.println("history.back()");
					script.println("</script>");
				} 
				else 
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = 'board.jsp'");
					script.println("</script>");
				}
			}
		
	%>
</body>
</html>