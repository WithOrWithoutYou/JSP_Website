<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="evaluation.EvaluationDTO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%>

<%

	// 실질적인 평가 등록을 처리하는 과정입니다.
	
	
	
	// 세션/로그인 처리
	request.setCharacterEncoding("UTF-8");
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
		script.println("location.href='userLogin.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	
	String lectureName = null;
	String professorName = null;
	int lectureYear = 0;
	String semesterDivide = null;
	String lectureDivide = null;
	String evaluationTitle = null;
	String evaluationContent = null;
	String totalScore = null;
	String creditScore = null;
	String comfortableScore = null;
	String lectureScore = null;
	
	
	if (request.getParameter("lectureName") != null)
	{
		lectureName = request.getParameter("lectureName");
	}
	if (request.getParameter("professorName") != null)
	{
		professorName = request.getParameter("professorName");
	}
	if (request.getParameter("lectureYear") != null) 
	{ // 이름(제목), 교수명(부제목) 연도 (계절) -> 바꿈
	  // getParameter로 받아들인 후,
		try
		{
			lectureYear = Integer.parseInt(request.getParameter("lectureYear"));
		}	// 년도를 인티저로 파싱하여 받아줍니다.
		catch(Exception e)
		{
			System.out.println("데이터 오류");
		}
	}
	if (request.getParameter("semesterDivide") != null) 
	{
		semesterDivide = request.getParameter("semesterDivide");
	}
	if (request.getParameter("lectureDivide") != null) 
	{
		lectureDivide = request.getParameter("lectureDivide");
	}
	if (request.getParameter("evaluationTitle") != null)
	{
		evaluationTitle = request.getParameter("evaluationTitle");
	}
	if (request.getParameter("evaluationContent") != null)
	{
		evaluationContent = request.getParameter("evaluationContent");
	}
	if (request.getParameter("totalScore") != null) 
	{
		totalScore = request.getParameter("totalScore");
	}
	if (request.getParameter("creditScore") != null) 
	{
		creditScore = request.getParameter("creditScore");
	}
	if (request.getParameter("comfortableScore") != null)
	{
		comfortableScore = request.getParameter("comfortableScore");
	}
	if (request.getParameter("lectureScore") != null) 
	{
		lectureScore = request.getParameter("lectureScore");
	}
	// 다음,, 계속해서 전달받은 내용들을 변수에 넣어줍니다.
	
	if (lectureName == null || professorName == null || lectureYear == 0 || semesterDivide == null || lectureDivide == null || evaluationTitle == null 
			|| evaluationContent == null || totalScore == null 	|| creditScore == null || comfortableScore == null || lectureScore == null 
			|| evaluationTitle.equals("")||evaluationContent.equals("")) 
	{ // 그리고 변수에 모든 내용들이 잘 들어갔는지 확인해줘야죠.
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안된 사항이 있습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	EvaluationDAO evaluationDAO = new EvaluationDAO();

	int result = evaluationDAO.write(new EvaluationDTO(0,userID,lectureName,professorName,
			lectureYear, semesterDivide, lectureDivide, evaluationTitle, evaluationContent,
			totalScore,creditScore,comfortableScore,lectureScore,0 ));
	// 변수에 다들 잘 들어갔으면, write 함수를 통해 실질적으로 DB화 시켜줍니다.
	
	if (result == -1) 
	{	//결과가 -1이라면, write함수에서 등록에 실패한 것을 뜻하죠.
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert(' 등록 실패했습니다........');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	else
	{
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href='index.jsp'");
		script.println("</script>");
		script.close();
	}
%>
