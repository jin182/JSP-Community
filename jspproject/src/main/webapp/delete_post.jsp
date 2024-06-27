<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
request.setCharacterEncoding("UTF-8");

int postId = Integer.parseInt(request.getParameter("id"));
String username = (String) session.getAttribute("username");

if(username == null) {
    response.sendRedirect("login.jsp");
    return;
}

Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    String jdbcUrl = "jdbc:mysql://localhost:3306/JSP?useSSL=false&serverTimezone=UTC";
    String dbId = "root";
    String dbPwd = "1234";
    conn = DriverManager.getConnection(jdbcUrl, dbId, dbPwd);
    
    // 작성자 확인
    String checkSql = "SELECT AUTHOR FROM POSTS WHERE POST_ID = ?";
    pstmt = conn.prepareStatement(checkSql);
    pstmt.setInt(1, postId);
    ResultSet rs = pstmt.executeQuery();
    
    if(rs.next() && rs.getString("AUTHOR").equals(username)) {
        String sql = "DELETE FROM POSTS WHERE POST_ID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, postId);
        
        int result = pstmt.executeUpdate();
        
        if(result > 0) {
            response.sendRedirect("main.jsp");
        } else {
            out.println("<script>alert('글 삭제에 실패했습니다.'); history.back();</script>");
        }
    } else {
        out.println("<script>alert('삭제 권한이 없습니다.'); history.back();</script>");
    }
} catch(Exception e) {
    e.printStackTrace();
    out.println("<script>alert('댓글이 없는 글만 삭제 가능합니다.(오류발생)'); history.back();</script>");
} finally {
    try {
        if(pstmt != null) pstmt.close();
        if(conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>
 