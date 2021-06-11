package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class UserDAO {
	
	// �α��� �Լ� �Դϴ�.
	// ID�� Password�� �Է¹ް� ���̵� ��ġ�ϴ� password�� �ҷ��� Ȯ���մϴ�.
	public int login(String userID, String userPassword) {
		String SQL="SELECT userPassword FROM USER WHERE userID= ?";
		Connection conn =null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt= conn.prepareStatement(SQL); // sql �����ϰ�.
			pstmt.setString(1,userID); 	// setString(1,userID)
			rs=pstmt.executeQuery();// �� �������� ������ ������ 
			if(rs.next()) {
			//���� ������� �ְ�, �� ������� ������ �Է��� Password�� ���ٸ�
				if(rs.getString(1).equals(userPassword)) {
					return 1;//�α��� ����
				} else {
					return 0; //��й�ȣ Ʋ��
				}
			}
			return -1; //���̵� ����
			// �翬�� userPassword�� ������ �ȵ����� ���̵� ��ü�� ���ٴ� �� �̴ϱ�!
		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {if(rs !=null) rs.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt !=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(conn !=null) conn.close();} catch(Exception e) {e.printStackTrace();}
		}
		return -2;//�����ͺ��̽� ����
	}
	
	
	//ȸ������ ���μ���
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
		return -1;//ȸ������ ����
	}
	
	// �̸��� �����ɴϴ�
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
		return null;// �����ͺ��̽� ����
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
		return false;// �����ͺ��̽� ����
	}
	
	// �̸��� ������ �Ϸ��ߴ��� üũ�մϴ�!
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
		return false;//�����ͺ��̽� ����
	}
}