<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
try
{
    Class.forName("com.mysql.jdbc.Driver");
    String db_address = "jdbc:mysql://localhost:3306/JSP";
    String db_username = "root";
    String db_pwd = "1234";
    Connection connection = DriverManager.getConnection(db_address, db_username, db_pwd);
    
    request.setCharacterEncoding("UTF-8");
    
    String postId = request.getParameter("id");
    if (postId == null || postId.trim().isEmpty()) {
        out.println("유효하지 않은 게시글 ID입니다. 받은 id: " + postId);
        return;
    }

    int postIdInt;
    try {
        postIdInt = Integer.parseInt(postId);
    } catch (NumberFormatException e) {
        out.println("유효하지 않은 게시글 ID 형식입니다. 받은 id: " + postId);
        return;
    }

    String title = request.getParameter("TITLE");
    String content = request.getParameter("CONTENT");

    if (title == null || content == null) {
        out.println("제목과 내용은 필수 입력 사항입니다.");
        return;
    }
    
    String updateQuery = "UPDATE POSTS SET TITLE = ?, CONTENT = ? WHERE POST_ID = ?";
    
    PreparedStatement psmt = connection.prepareStatement(updateQuery);
    
    psmt.setString(1, title);
    psmt.setString(2, content);
    psmt.setInt(3, postIdInt);
    
    int result = psmt.executeUpdate();
    
    if(result > 0) {
        response.sendRedirect("main.jsp");
    } else {
        out.println("게시글 수정에 실패했습니다. POST_ID: " + postId);
    }
}
catch (Exception ex)
{
    out.println("오류가 발생했습니다. 오류 메시지 : " + ex.getMessage());
    ex.printStackTrace(); // 서버 로그에 스택 트레이스 출력
}
%>