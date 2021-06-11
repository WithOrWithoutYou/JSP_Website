package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class UserDAO {
	
	
	
	public int login(String userID, String userPassword) 
	{
		String SQL="SELECT userPassword FROM USER WHERE userID= ?";
		Connection conn =null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try 
		{
			conn = DatabaseUtil.getConnection();
			pstmt= conn.prepareStatement(SQL); // 간결한 코드, 빠른 실행, 그리고 보안성을 위해 pstmt를 사용합니다.
			pstmt.setString(1,userID);
			rs=pstmt.executeQuery();
			if(rs.next()) 
			{
				if(rs.getString(1).equals(userPassword))
				{
					return 1;//로그인 성공
				} 
				else 
				{
					return 0; //비밀번호 틀림
				}
			}
			return -1; 
			//아이디 없음
		}
		catch(Exception e)
		{
			e.printStackTrace();
		} 
		finally
		{
			try {if(rs !=null) rs.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt !=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(conn !=null) conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		return -2;//데이터베이스 오류
	}
	
	public int join(UserDTO user) 
	{
		String SQL="INSERT INTO USER VALUES(?,?,?,?,false)";
		Connection conn =null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try 
		{
			conn = DatabaseUtil.getConnection();
			pstmt= conn.prepareStatement(SQL); // 간결한 코드, 빠른 실행, 그리고 보안성을 위해 pstmt를 사용합니다.
			pstmt.setString(1,user.getUserID());
			pstmt.setString(2,user.getUserPassword());
			pstmt.setString(3,user.getUserEmail());
			pstmt.setString(4,user.getUserEmailHash());
			return pstmt.executeUpdate();
		}
		catch(Exception e) 
		{
			e.printStackTrace();
		} 
		finally
		{
			try {if(rs !=null) rs.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt !=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(conn !=null) conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		return -1;//회원가입 실패
	}
	
	public String getUserEmail(String userID) 
	{
		String SQL="SELECT userEmail FROM USER WHERE userID=?";
		Connection conn =null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt= conn.prepareStatement(SQL);
			pstmt.setString(1,userID); // 매개변수를 통해 입력된 유저 아이디를 넣습니다
			rs=pstmt.executeQuery();	// 그리고 쿼리를 실행했을 때
			if(rs.next())			   // 결과값이 있다면 반환해주세요 
			{
				return rs.getString(1);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally 
		{
			try {if(rs !=null) rs.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt !=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(conn !=null) conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		return null;// 데이터베이스 오류
	}
	
	public boolean getUserEmailChecked(String userID)
	{
		String SQL="SELECT userEmailChecked FROM USER WHERE userID=?";
		Connection conn =null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try 
		{
			conn = DatabaseUtil.getConnection();
			pstmt= conn.prepareStatement(SQL);
			pstmt.setString(1,userID);
			rs=pstmt.executeQuery();
			if(rs.next()) 
			{
				return rs.getBoolean(1);
			}
		}catch(Exception e) 
		{
			e.printStackTrace();
		} 
		finally 
		{ 	//자원 해제
			try {if(rs !=null) rs.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt !=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(conn !=null) conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		return false;// 데이터베이스 오류
	}
	
	public boolean setUserEmailChecked(String userID) 
	{	// 이메일 체크과정입니다.
		String SQL="UPDATE USER SET userEmailChecked = true WHERE userID =?";
		Connection conn =null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt= conn.prepareStatement(SQL);
			pstmt.setString(1,userID);
			pstmt.executeUpdate();
			return true;
		}catch(Exception e) 
		{
			e.printStackTrace();
		} finally 
		{
			try {if(rs !=null) rs.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt !=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(conn !=null) conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		return false;//데이터베이스 오류
	}
}