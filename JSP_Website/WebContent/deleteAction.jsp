<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<!-- 속성을 정의할 때 사용하는 라이브러리 (유용) -->
<%@ page import="java.util.Properties" %>
<%@ page import="util.Gmail" %>
<%@ page import="user.UserDAO" %>    
<%@ page import="util.SHA256" %>    
<%@ page import="java.io.PrintWriter" %>    


<%@ page import="user.UserDAO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="likey.likeyDTO"%>
<%@ page import="java.io.PrintWriter"%>

<%
	// 그냥 deleteAction은 index 페이지에 있는 카드를 삭제하는 액션 입니다.
	String userID = null;
	if (session.getAttribute("userID") != null) 
	{
		userID = (String) session.getAttribute("userID");
	}
	if (userID == null) {
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
	if (request.getParameter("evaluationID") != null) {
		evaluationID = request.getParameter("evaluationID");
	}
	
	
	EvaluationDAO evaluationDAO = new EvaluationDAO();
	if (userID.equals(evaluationDAO.getUserID(evaluationID)))
	{	// 실제 게시자만 삭제 가능하도록 하려고 합니다.  따라서 현재 접속한 ID가 게시글 작성자 ID라면,
		int result = evaluationDAO.delete(evaluationID);
		// 삭제 함수 실행 후
		if (result == 1) 
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('삭제가 완료되었습니다.');");
			script.println("location.href='index.jsp'");
			script.println("</script>");
			script.close();
			return;
		} 
		else
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
		}
	} 
	else 
	{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('자신이 쓴 글만 삭제 가능합니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
	}
%>
