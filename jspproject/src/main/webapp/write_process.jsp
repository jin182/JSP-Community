<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
request.setCharacterEncoding("UTF-8");

String title = request.getParameter("title");
String content = request.getParameter("content");
String author = (String) session.getAttribute("username");

if(author == null) {
    response.sendRedirect("login.jsp");
    return;
}

Connection conn = null;
PreparedStatement pstmt = null;

try {
    // MySQL 드라이버 클래스 로드
    Class.forName("com.mysql.cj.jdbc.Driver");
    
    // MySQL 데이터베이스 연결
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/JSP", "root", "1234");
    
    // INSERT 쿼리 작성
    String sql = "INSERT INTO POSTS (TITLE, CONTENT, AUTHOR, CREATE_DATE, VIEW_COUNT) VALUES (?, ?, ?, NOW(), 0)";
    
    // PreparedStatement 생성
    pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
    pstmt.setString(1, title);
    pstmt.setString(2, content);
    pstmt.setString(3, author);
    
    // 쿼리 실행
    int result = pstmt.executeUpdate();
    
    // 결과 확인 후 리다이렉트
    if(result > 0) {
        response.sendRedirect("main.jsp");
    } else {
        out.println("<script>alert('글 작성에 실패했습니다.'); history.back();</script>");
    }
} catch(Exception e) {
    e.printStackTrace();
    out.println("<script>alert('오류가 발생했습니다.'); history.back();</script>");
} finally {
    // 리소스 해제
    try {
        if(pstmt != null) pstmt.close();
        if(conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>
