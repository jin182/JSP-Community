<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>글 보기</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
<%
int postId = Integer.parseInt(request.getParameter("id"));
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/JSP", "root", "1234");

    // 조회수 증가
    String updateSql = "UPDATE POSTS SET VIEW_COUNT = VIEW_COUNT + 1 WHERE POST_ID = ?";
    pstmt = conn.prepareStatement(updateSql);
    pstmt.setInt(1, postId);
    pstmt.executeUpdate();

    // 게시글 조회
    String sql = "SELECT * FROM POSTS WHERE POST_ID = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, postId);
    rs = pstmt.executeQuery();

    if(rs.next()) {
        String title = rs.getString("TITLE");
        String content = rs.getString("CONTENT");
        String author = rs.getString("AUTHOR");
        Date createDate = rs.getDate("CREATE_DATE");
        int viewCount = rs.getInt("VIEW_COUNT");
%>
        <h1 class="mb-4"><%= title %></h1>
        <p>작성자: <%= author %> | 작성일: <%= createDate %> | 조회수: <%= viewCount %></p>
        <hr>
        <div class="mb-4">
            <%= content %>
        </div>
        <div>
            <a href="main.jsp" class="btn btn-secondary">목록</a>
            <% if(session.getAttribute("username") != null && session.getAttribute("username").equals(author)) { %>
                <a href="edit_post.jsp?id=<%= postId %>" class="btn btn-primary">수정</a>
                <a href="delete_post.jsp?id=<%= postId %>" class="btn btn-danger" onclick="return confirm('정말로 삭제하시겠습니까?')">삭제</a>
            <% } %>
        </div>

        <!-- 댓글 목록 -->
        <h3 class="mt-5">댓글</h3>
        <%
        String commentSql = "SELECT * FROM COMMENTS WHERE POST_ID = ? ORDER BY CREATE_DATE DESC";
        pstmt = conn.prepareStatement(commentSql);
        pstmt.setInt(1, postId);
        ResultSet commentRs = pstmt.executeQuery();

        while(commentRs.next()) {
        %>
            <div class="card mb-3">
                <div class="card-body">
                    <h6 class="card-subtitle mb-2 text-muted">
                        <%= commentRs.getString("AUTHOR") %> 
                        (<%= commentRs.getTimestamp("CREATE_DATE") %>)
                    </h6>
                    <p class="card-text"><%= commentRs.getString("CONTENT") %></p>
                    <% if(session.getAttribute("username") != null && session.getAttribute("username").equals(commentRs.getString("AUTHOR"))) { %>
                        <a href="comment_edit.jsp?id=<%= commentRs.getInt("COMMENT_ID") %>&post_id=<%= postId %>" class="card-link">수정</a>
                        <a href="comment_delete.jsp?id=<%= commentRs.getInt("COMMENT_ID") %>&post_id=<%= postId %>" class="card-link" onclick="return confirm('정말로 삭제하시겠습니까?')">삭제</a>
                    <% } %>
                </div>
            </div>
        <%
        }
        commentRs.close();
        %>

        <!-- 댓글 작성 폼 -->
        <% if(session.getAttribute("username") != null) { %>
            <form action="comment_write.jsp" method="post" class="mt-4">
                <input type="hidden" name="post_id" value="<%= postId %>">
                <div class="form-group">
                    <textarea class="form-control" name="content" rows="3" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">댓글 작성</button>
            </form>
        <% } else { %>
            <p class="mt-4">댓글을 작성하려면 <a href="login.jsp">로그인</a>하세요.</p>
        <% } %>

<%
    } else {
        out.println("<p>해당 게시글을 찾을 수 없습니다.</p>");
    }
} catch(Exception e) {
    e.printStackTrace();
    out.println("<p>오류가 발생했습니다.</p>");
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
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
