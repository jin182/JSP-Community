<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>글 수정</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h1 class="text-center mb-4">글 수정</h1>
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
            out.println("<div class='alert alert-danger'>유효하지 않은 게시글 ID입니다. 받은 id: " + postId + "</div>");
            return;
        }
        
        int postIdInt;
        try {
            postIdInt = Integer.parseInt(postId);
        } catch (NumberFormatException e) {
            out.println("<div class='alert alert-danger'>유효하지 않은 게시글 ID 형식입니다. 받은 id: " + postId + "</div>");
            return;
        }
        
        String selectQuery = "SELECT * FROM POSTS WHERE POST_ID = ?";
        
        PreparedStatement psmt = connection.prepareStatement(selectQuery);
        psmt.setInt(1, postIdInt);
        
        ResultSet result = psmt.executeQuery();
        
        if(result.next())
        {
    %>
            <form action="post_modify_send.jsp" method="post">
            <input type="hidden" name="id" value="<%=result.getInt("POST_ID")%>">
            <div class="form-group">
                <label for="AUTHOR">작성자</label>
                <input type="text" class="form-control" id="AUTHOR" name="AUTHOR" value="<%=result.getString("AUTHOR")%>" readonly>
            </div>
            <div class="form-group">
                <label for="TITLE">제목</label>
                <input type="text" class="form-control" id="TITLE" name="TITLE" value="<%=result.getString("TITLE")%>" required>
            </div>
            <div class="form-group">
                <label for="CONTENT">내용</label>
                <textarea class="form-control" id="CONTENT" name="CONTENT" rows="5" required><%=result.getString("CONTENT")%></textarea>
            </div>
            <button type="submit" class="btn btn-primary">수정</button>
            <button type="button" class="btn btn-secondary" onclick="location.href='main.jsp'">목록으로</button>
            <button type="reset" class="btn btn-warning">원상복구</button>
            </form>
    <%
        }
        else
        {
            out.println("<div class='alert alert-danger'>해당 게시글을 찾을 수 없습니다. POST_ID: " + postId + "</div>");
        }
    }
    catch (Exception ex)
    {
        out.println("<div class='alert alert-danger'>오류가 발생했습니다. 오류 메시지 : " + ex.getMessage() + "</div>");
        ex.printStackTrace(); // 서버 로그에 스택 트레이스 출력
    }
    %>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>