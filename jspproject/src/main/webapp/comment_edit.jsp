<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>댓글 수정</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h1 class="text-center mb-4">댓글 수정</h1>
    <%
    try {
        Class.forName("com.mysql.jdbc.Driver");
        String db_address = "jdbc:mysql://localhost:3306/JSP";
        String db_username = "root";
        String db_pwd = "1234";
        Connection connection = DriverManager.getConnection(db_address, db_username, db_pwd);

        request.setCharacterEncoding("UTF-8");

        String commentId = request.getParameter("id");
        if (commentId == null || commentId.trim().isEmpty()) {
            out.println("<div class='alert alert-danger'>유효하지 않은 댓글 ID입니다. 받은 id: " + commentId + "</div>");
            return;
        }

        int commentIdInt;
        try {
            commentIdInt = Integer.parseInt(commentId);
        } catch (NumberFormatException e) {
            out.println("<div class='alert alert-danger'>유효하지 않은 댓글 ID 형식입니다. 받은 id: " + commentId + "</div>");
            return;
        }

        String selectQuery = "SELECT * FROM COMMENTS WHERE COMMENT_ID = ?";

        PreparedStatement psmt = connection.prepareStatement(selectQuery);
        psmt.setInt(1, commentIdInt);

        ResultSet result = psmt.executeQuery();

        if(result.next()) {
    %>
    <form action="comment_update.jsp" method="post">
        <input type="hidden" name="id" value="<%=result.getInt("COMMENT_ID")%>">
        <input type="hidden" name="post_id" value="<%=result.getInt("POST_ID")%>">
        <div class="form-group">
            <label for="AUTHOR">작성자</label>
            <input type="text" class="form-control" id="AUTHOR" name="AUTHOR" value="<%=result.getString("AUTHOR")%>" readonly>
        </div>
        <div class="form-group">
            <label for="CONTENT">내용</label>
            <textarea class="form-control" id="CONTENT" name="CONTENT" rows="3" required><%=result.getString("CONTENT")%></textarea>
        </div>
        <button type="submit" class="btn btn-primary">수정</button>
        <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
    </form>
    <%
        } else {
            out.println("<div class='alert alert-danger'>해당 댓글을 찾을 수 없습니다. COMMENT_ID: " + commentId + "</div>");
        }
    } catch (Exception ex) {
        out.println("<div class='alert alert-danger'>오류가 발생했습니다. 오류 메시지 : " + ex.getMessage() + "</div>");
        ex.printStackTrace();
    }
    %>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>