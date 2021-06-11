package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DatabaseUtil;

public class BbsDAO {
	
	private Connection conn;
	private ResultSet rs;
	
	public BbsDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/my_web";
			String dbID = "root";
			String dbPassword = "root";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public String getDate() {
		String SQL = "select now()"; // 현재 시간을 가지고 옵니다.
		try {
			conn = DatabaseUtil.getConnection();  // Db에 연결.
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			rs = pstmt.executeQuery(); // sql문 실행 후 결과값을 저장.
			if (rs.next()) {              
				return rs.getString(1);  // resultset에서 첫 번째 결과값을 가져옴, 즉 시간을 가져옴.
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; //데이터베이스 오류
	}
	
	
	// boardID를  +1 해서 가져옵니다. 
	public int getNext() {
		String SQL = "select bbsID from BBS order by bbsID desc"; 
		try {
			conn = DatabaseUtil.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; //첫 번째 게시물인 경우
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	
	// Board에서 게시글을 작성합니다.
	public int write(String bbsTitle, String userID, String bbsContent) {
		String SQL = "insert into bbs values(?, ?, ?, ?, ?, ?)";
		try {
			conn = DatabaseUtil.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext()); // 1번째로 게시글 번호 +1을 가져옵니다.
			pstmt.setString(2, bbsTitle); // 게시글 이름
			pstmt.setString(3, userID); // 작성자 ID
			pstmt.setString(4, getDate()); // 작성일자,
			pstmt.setString(5, bbsContent); // 게시글 내용
			pstmt.setInt(6, 1);             // 게시글 사용가능여부, (삭제되면 0) 
			return pstmt.executeUpdate(); 
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	// 특정 리스트를 받아와서 반환할 수 있게 합니다.
	public ArrayList<Bbs> getList(int pageNumber) {
		String SQL = "select * from BBS where bbsID < ? and bbsAvailable = 1 order by bbsID desc limit 10";
		// 블루틴보드 DB에서 게시글 번호 [변수]를 가져오는데, 가용한 게시글임을 확인하고 10개씩 끊어서 가져옵니다.
		
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		// 리스트 객체 생성.
		try {
			conn = DatabaseUtil.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10); // 페이지 넘버를 받아옵니다. 페이지 넘버가 1이라면
			// 
			rs = pstmt.executeQuery();
			while (rs.next()) 
			{
				Bbs bbs = new Bbs(); // 보드객체 생성
				bbs.setBbsID(rs.getInt(1));           //private int bbsID;
				bbs.setBbsTitle(rs.getString(2));     //private String bbsTitle;
				bbs.setUserID(rs.getString(3));       //private String userID;
				bbs.setBbsDate(rs.getString(4));      //private String bbsDate;
				bbs.setBbsContent(rs.getString(5));   //private String bbsContent;
				bbs.setBbsAvailable(rs.getInt(6));    //private int bbsAvailable;
				list.add(bbs); // 리스트에 넣어준 뒤, 오류가 없으면 return을 해줍니다.
			}
		} catch (Exception e) 
		{
			e.printStackTrace();
		}
		return list; //데이터베이스 오류
	}
	
	
	public boolean nextPage(int pageNumber)
	{
		String SQL = "select * from BBS where bbsID < ? and bbsAvailable = 1";
		try
		{
			conn = DatabaseUtil.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return true;
			}
		}
		
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return false; //데이터베이스 오류
	}
	
	
	// 특정 게시글 ID에 해당하는 게시글을 가져옵니다.
	public Bbs getBbs(int bbsID)
	{
		String SQL = "select * from bbs where bbsID = ?";
		try {
			conn = DatabaseUtil.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			if (rs.next())
			{
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				return bbs; // 그걸 그대로 반환한다고?
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();	
		}
		return null;
	}
	
	public int update(int bbsID, String bbsTitle, String bbsContent) 
	{
		String SQL = "update bbs set bbsTitle = ? , bbsContent =? where bbsID = ?";
		try 
		{
			conn = DatabaseUtil.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsTitle);       // 글 제목
			pstmt.setString(2, bbsContent);     // 글 내용
			pstmt.setInt(3, bbsID);             // 게시글 ID, 즉 1번게시글 .. 2번 .. etc
			return pstmt.executeUpdate();
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	public int delete(int bbsID) 
	{  // 삭제할 id값을 받습니다.
		String SQL = "update bbs set bbsAvailable = 0 where bbsID = ?";
	   // 글을 삭제해도 정보값을 남겨놔서 수상한 녀석을 찾을 수 있게 합니다.
		try {
			conn = DatabaseUtil.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate(); //결과 반환, 성공적이면 1이 반환됩니다.
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
}