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
<title> </title>
</head>
<body>
	<%
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
			if(request.getParameter("bbsID") != null){
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
			// 정보를 얻어와서, 아이디가 맞는지 확인합니다. 
			if(!userID.equals(bbs.getUserID())){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('권한이 없습니다.')");
				script.println("location.href = 'board.jsp'");
				script.println("</script>");
			} 
			else {
		
				BbsDAO bbsDAO = new BbsDAO();
				int result = bbsDAO.delete(bbsID);
				if (result == -1) // -1은 db 오류 입니다. 거의 일어날 일이 없죠
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