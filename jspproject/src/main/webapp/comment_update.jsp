<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
try {
    Class.forName("com.mysql.jdbc.Driver");
    String db_address = "jdbc:mysql://localhost:3306/JSP";
    String db_username = "root";
    String db_pwd = "1234";
    Connection connection = DriverManager.getConnection(db_address, db_username, db_pwd);

    request.setCharacterEncoding("UTF-8");

    String commentId = request.getParameter("id");
    String postId = request.getParameter("post_id");
    if (commentId == null || commentId.trim().isEmpty()) {
        out.println("유효하지 않은 댓글 ID입니다. 받은 id: " + commentId);
        return;
    }

    int commentIdInt;
    try {
        commentIdInt = Integer.parseInt(commentId);
    } catch (NumberFormatException e) {
        out.println("유효하지 않은 댓글 ID 형식입니다. 받은 id: " + commentId);
        return;
    }

    String content = request.getParameter("CONTENT");

    if (content == null) {
        out.println("댓글 내용은 필수 입력 사항입니다.");
        return;
    }

    String updateQuery = "UPDATE COMMENTS SET CONTENT = ? WHERE COMMENT_ID = ?";

    PreparedStatement psmt = connection.prepareStatement(updateQuery);

    psmt.setString(1, content);
    psmt.setInt(2, commentIdInt);

    int result = psmt.executeUpdate();

    if(result > 0) {
        response.sendRedirect("view_post.jsp?id=" + postId);
    } else {
        out.println("댓글 수정에 실패했습니다. COMMENT_ID: " + commentId);
    }
} catch (Exception ex) {
    out.println("오류가 발생했습니다. 오류 메시지 : " + ex.getMessage());
    ex.printStackTrace();
}
%>