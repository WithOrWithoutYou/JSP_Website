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
		String SQL = "select now()"; // ���� �ð��� ������ �ɴϴ�.
		try {
			conn = DatabaseUtil.getConnection();  // Db�� ����.
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			rs = pstmt.executeQuery(); // sql�� ���� �� ������� ����.
			if (rs.next()) {              
				return rs.getString(1);  // resultset���� ù ��° ������� ������, �� �ð��� ������.
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; //�����ͺ��̽� ����
	}
	
	
	// boardID��  +1 �ؼ� �����ɴϴ�. 
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
	
	
	// Board���� �Խñ��� �ۼ��մϴ�.
	public int write(String bbsTitle, String userID, String bbsContent) {
		String SQL = "insert into bbs values(?, ?, ?, ?, ?, ?)";
		try {
			conn = DatabaseUtil.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext()); // 1��°�� �Խñ� ��ȣ +1�� �����ɴϴ�.
			pstmt.setString(2, bbsTitle); // �Խñ� �̸�
			pstmt.setString(3, userID); // �ۼ��� ID
			pstmt.setString(4, getDate()); // �ۼ�����,
			pstmt.setString(5, bbsContent); // �Խñ� ����
			pstmt.setInt(6, 1);             // �Խñ� ��밡�ɿ���, (�����Ǹ� 0) 
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
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10); // ������ �ѹ��� �޾ƿɴϴ�. ������ �ѹ��� 1�̶��
			// 
			rs = pstmt.executeQuery();
			while (rs.next()) 
			{
				Bbs bbs = new Bbs(); // ���尴ü ����
				bbs.setBbsID(rs.getInt(1));           //private int bbsID;
				bbs.setBbsTitle(rs.getString(2));     //private String bbsTitle;
				bbs.setUserID(rs.getString(3));       //private String userID;
				bbs.setBbsDate(rs.getString(4));      //private String bbsDate;
				bbs.setBbsContent(rs.getString(5));   //private String bbsContent;
				bbs.setBbsAvailable(rs.getInt(6));    //private int bbsAvailable;
				list.add(bbs); // ����Ʈ�� �־��� ��, ������ ������ return�� ���ݴϴ�.
			}
		} catch (Exception e) 
		{
			e.printStackTrace();
		}
		return list; //�����ͺ��̽� ����
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
		return false; //�����ͺ��̽� ����
	}
	
	
	// Ư�� �Խñ� ID�� �ش��ϴ� �Խñ��� �����ɴϴ�.
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
				return bbs; // �װ� �״�� ��ȯ�Ѵٰ�?
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
			pstmt.setString(1, bbsTitle);       // �� ����
			pstmt.setString(2, bbsContent);     // �� ����
			pstmt.setInt(3, bbsID);             // �Խñ� ID, �� 1���Խñ� .. 2�� .. etc
			return pstmt.executeUpdate();
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return -1; //�����ͺ��̽� ����
	}
	
	public int delete(int bbsID) 
	{  // ������ id���� �޽��ϴ�.
		String SQL = "update bbs set bbsAvailable = 0 where bbsID = ?";
	   // ���� �����ص� �������� ���ܳ��� ������ �༮�� ã�� �� �ְ� �մϴ�.
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