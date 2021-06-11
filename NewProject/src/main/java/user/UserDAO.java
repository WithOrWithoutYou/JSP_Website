package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class UserDAO {
	
	// 로그인 함수 입니다.
	// ID와 Password를 입력받고 아이디가 일치하는 password를 불러와 확인합니다.
	public int login(String userID, String userPassword) {
		String SQL="SELECT userPassword FROM USER WHERE userID= ?";
		Connection conn =null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt= conn.prepareStatement(SQL); // sql 실행하고.
			pstmt.setString(1,userID); 	// setString(1,userID)
			rs=pstmt.executeQuery();// 그 쿼리문을 실행한 다음에 
			if(rs.next()) {
			//실행 결과값이 있고, 그 결과값이 유저가 입력한 Password와 같다면
				if(rs.getString(1).equals(userPassword)) {
					return 1;//로그인 성공
				} else {
					return 0; //비밀번호 틀림
				}
			}
			return -1; //아이디 없음
			// 당연히 userPassword가 리턴이 안됐으면 아이디 자체가 없다는 뜻 이니까!
		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {if(rs !=null) rs.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt !=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(conn !=null) conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		return -2;//데이터베이스 오류
	}
	
	
	//회원가입 프로세스
	public int join(UserDTO user) {
		String SQL="INSERT INTO USER VALUES(?,?,?,?,false)";
								//         id ,pw, Email, EmailHash
		Connection conn =null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt= conn.prepareStatement(SQL);
			pstmt.setString(1,user.getUserID());
			pstmt.setString(2,user.getUserPassword());
			pstmt.setString(3,user.getUserEmail());
			pstmt.setString(4,user.getUserEmailHash());
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {if(rs !=null) rs.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt !=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(conn !=null) conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		return -1;//회원가입 실패
	}
	
	// 이메일 가져옵니다
	public String getUserEmail(String userID) {
		String SQL="SELECT userEmail FROM USER WHERE userID=?";
		Connection conn =null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt= conn.prepareStatement(SQL);
			pstmt.setString(1,userID);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {if(rs !=null) rs.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt !=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(conn !=null) conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		return null;// 데이터베이스 오류
	}
	
	public boolean getUserEmailChecked(String userID) {
		String SQL="SELECT userEmailChecked FROM USER WHERE userID=?";
		Connection conn =null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt= conn.prepareStatement(SQL);
			pstmt.setString(1,userID);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				return rs.getBoolean(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {if(rs !=null) rs.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt !=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(conn !=null) conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		return false;// 데이터베이스 오류
	}
	
	// 이메일 인증을 완료했는지 체크합니다!
	public boolean setUserEmailChecked(String userID) {
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
		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {if(rs !=null) rs.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt !=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(conn !=null) conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		return false;//데이터베이스 오류
	}
}