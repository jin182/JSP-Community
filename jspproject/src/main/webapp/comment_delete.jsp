<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
int commentId = Integer.parseInt(request.getParameter("id"));
int postId = Integer.parseInt(request.getParameter("post_id"));
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

    String sql = "DELETE FROM COMMENTS WHERE COMMENT_ID = ? AND AUTHOR = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, commentId);
    pstmt.setString(2, username);

    int result = pstmt.executeUpdate();

    if(result > 0) {
        response.sendRedirect("view_post.jsp?id=" + postId);
    } else {
        out.println("<script>alert('댓글 삭제에 실패했습니다.'); history.back();</script>");
    }
} catch(Exception e) {
    e.printStackTrace();
    out.println("<script>alert('오류가 발생했습니다.'); history.back();</script>");
} finally {
    if(pstmt != null) pstmt.close();
    if(conn != null) conn.close();
}
%>