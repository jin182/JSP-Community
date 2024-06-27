<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.security.MessageDigest, java.util.*" %>
<%
request.setCharacterEncoding("UTF-8");

String username = request.getParameter("username");
String password = request.getParameter("password");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL 드라이버 클래스명
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/JSP", "root", "1234"); // MySQL 연결 정보

    // 입력된 패스워드를 SHA-256으로 해시
    MessageDigest md = MessageDigest.getInstance("SHA-256");
    byte[] hashBytes = md.digest(password.getBytes("UTF-8"));
    StringBuilder hashedPassword = new StringBuilder();
    for (byte b : hashBytes) {
        hashedPassword.append(String.format("%02x", b));
    }

    String sql = "SELECT * FROM USERS WHERE USERNAME = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, username);

    rs = pstmt.executeQuery();

    if(rs.next()) {
        String storedPasswordHash = rs.getString("PASSWORD");
        
        // 데이터베이스에 저장된 해시된 패스워드와 입력한 패스워드의 해시값 비교
        if (storedPasswordHash.equals(hashedPassword.toString())) {
            session.setAttribute("username", username);
            response.sendRedirect("main.jsp");
        } else {
            out.println("<script>alert('패스워드가 일치하지 않습니다.'); history.back();</script>");
        }
    } else {
        out.println("<script>alert('사용자가 존재하지 않습니다.'); history.back();</script>");
    }
} catch(Exception e) {
    e.printStackTrace();
    out.println("<script>alert('오류가 발생했습니다.'); history.back();</script>");
} finally {
    try {
        if(rs != null) rs.close();
        if(pstmt != null) pstmt.close();
        if(conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>
