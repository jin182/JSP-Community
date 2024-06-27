<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.security.MessageDigest" %>
<%
request.setCharacterEncoding("UTF-8");

String username = request.getParameter("username");
String email = request.getParameter("email");
String password = request.getParameter("password");
String birthdate = request.getParameter("birthdate");
String gender = request.getParameter("gender");

// 비밀번호 해시 처리 (SHA-256 예시)
String hashedPassword = null;
try {
    MessageDigest md = MessageDigest.getInstance("SHA-256");
    byte[] hash = md.digest(password.getBytes("UTF-8"));
    StringBuilder sb = new StringBuilder();
    for (byte b : hash) {
        sb.append(String.format("%02x", b));
    }
    hashedPassword = sb.toString();
} catch (Exception e) {
    e.printStackTrace();
    out.println("<script>alert('비밀번호 해시 처리 중 오류가 발생했습니다.'); history.back();</script>");
    return;
}

Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL 드라이버 클래스명
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/JSP", "root", "1234"); // MySQL 연결 정보

    String sql = "INSERT INTO USERS (USERNAME, EMAIL, PASSWORD, BIRTHDATE, GENDER) VALUES (?, ?, ?, ?, ?)";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, username);
    pstmt.setString(2, email);
    pstmt.setString(3, hashedPassword);
    pstmt.setString(4, birthdate);
    pstmt.setString(5, gender);

    int result = pstmt.executeUpdate();

    if(result > 0) {
        response.sendRedirect("login.jsp");
    } else {
        out.println("<script>alert('회원가입에 실패했습니다.'); history.back();</script>");
    }
} catch(Exception e) {
    e.printStackTrace();
    out.println("<script>alert('오류가 발생했습니다: " + e.getMessage() + "'); history.back();</script>");
} finally {
    try {
        if(pstmt != null) pstmt.close();
        if(conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>

