package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DatabaseUtil;

public class BbsDAO {
	
	private Connection conn; // ���ᰴü
	private ResultSet rs;    // ������� ������ ��ü
	
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
		String SQL = "select now()"; // ���� �ð��� ������ �ɴϴ�.
		try {
			conn = DatabaseUtil.getConnection(); // ��ƿ���� ������ Ŀ�ؼ� �Լ� ���
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			// ������ ���� pstmt ���!
			rs = pstmt.executeQuery();
			if (rs.next()) {  //��¥�� �ִٸ�, ��ȯ.
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; //�����ͺ��̽� ����
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
			return 1; //ù ��° �Խù��� ���
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //�����ͺ��̽� ����
	}
	
	// �Խñ� �ۼ� �Լ� �Դϴ�. 
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
		return -1; //�����ͺ��̽� ����
	}
	
	// Ư�� ����Ʈ�� �޾ƿͼ� ��ȯ�� �� �ְ� �մϴ�.
	public ArrayList<Bbs> getList(int pageNumber) {
		String SQL = "select * from BBS where bbsID < ? and bbsAvailable = 1 order by bbsID desc limit 10";
		// ���ƾ���� DB���� �Խñ� ��ȣ [����]�� �������µ�, ������ �Խñ����� Ȯ���ϰ� 10���� ��� �����ɴϴ�.
		
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		// ����Ʈ ��ü ����.
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
		return list; // ����Ʈ�� ��ȯ�մϴ�.
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
		return false; //�����ͺ��̽� ����
	}
	
	
	// Ư�� �Խñ� ID�� �ش��ϴ� �Խñ��� �����ɴϴ�.
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
				return bbs; // �װ� �״�� ��ȯ!
			}
		} catch (Exception e) {
			e.printStackTrace();	
		}
		return null;
	}
	
	
	// �Խñ� ���� �Լ� �Դϴ�.
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
		return -1; //�����ͺ��̽� ����
	}
	
	public int delete(int bbsID) 
	{  // ������ id���� �޽��ϴ�.
		String SQL = "update bbs set bbsAvailable = 0 where bbsID = ?";
	   // ���� �����ص� �������� ���ܳ��� ������ �༮�� ã�� �� �ְ� �մϴ�.
	   // ��, �����͸� ���� �����ϴ� ���� �ƴ� �Խ��ǿ��� �� �� ���� �ϴ� �� �Դϴ�.
		try {
			conn = DatabaseUtil.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate(); //��� ��ȯ, �������̸� 1�� ��ȯ�˴ϴ�.
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //�����ͺ��̽� ����
	}
}