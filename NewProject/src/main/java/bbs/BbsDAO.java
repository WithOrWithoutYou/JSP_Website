package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DatabaseUtil;

public class BbsDAO {
	
	private Connection conn; // 연결객체
	private ResultSet rs;    // 결과물을 전달할 객체
	
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
			conn = DatabaseUtil.getConnection(); // 유틸에서 정의한 커넥션 함수 사용
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			// 보안을 위해 pstmt 사용!
			rs = pstmt.executeQuery();
			if (rs.next()) {  //날짜가 있다면, 반환.
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; //데이터베이스 오류
	}
	
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
	
	// 게시글 작성 함수 입니다. 
	public int write(String bbsTitle, String userID, String bbsContent) {
		String SQL = "insert into bbs values(?, ?, ?, ?, ?, ?)";
		try {
			conn = DatabaseUtil.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);
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
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			//
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list; // 리스트를 반환합니다.
	}
	
	public boolean nextPage(int pageNumber) {
		String SQL = "select * from BBS where bbsID < ? and bbsAvailable = 1";
		try {
			conn = DatabaseUtil.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false; //데이터베이스 오류
	}
	
	
	// 특정 게시글 ID에 해당하는 게시글을 가져옵니다.
	public Bbs getBbs(int bbsID) {
		String SQL = "select * from bbs where bbsID = ?";
		try {
			conn = DatabaseUtil.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				return bbs; // 그걸 그대로 반환!
			}
		} catch (Exception e) {
			e.printStackTrace();	
		}
		return null;
	}
	
	
	// 게시글 수정 함수 입니다.
	public int update(int bbsID, String bbsTitle, String bbsContent) {
		String SQL = "update bbs set bbsTitle = ? , bbsContent =? where bbsID = ?";
		try {
			conn = DatabaseUtil.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	public int delete(int bbsID) 
	{  // 삭제할 id값을 받습니다.
		String SQL = "update bbs set bbsAvailable = 0 where bbsID = ?";
	   // 글을 삭제해도 정보값을 남겨놔서 수상한 녀석을 찾을 수 있게 합니다.
	   // 즉, 데이터를 완전 삭제하는 것이 아닌 게시판에서 볼 수 없게 하는 것 입니다.
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