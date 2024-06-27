<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>게시판</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h1 class="text-center mb-4">게시판</h1>
        
        <%
        String username = (String) session.getAttribute("username");
        if (username == null) {
            out.println("<p class='text-center'><a href='login.jsp'>로그인</a> | <a href='register.jsp'>회원가입</a></p>");
        } else {
            out.println("<p class='text-center'>환영합니다, " + username + "님! <a href='logout.jsp'>로그아웃</a></p>");
        }
        %>

        <!-- 검색 폼 -->
        <form action="main.jsp" method="get" class="mb-4">
            <div class="input-group">
                <select name="searchType" class="custom-select" style="max-width: 120px;">
                    <option value="title">제목</option>
                    <option value="content">내용</option>
                    <option value="author">작성자</option>
                </select>
                <input type="text" name="searchKeyword" class="form-control" placeholder="검색어를 입력하세요">
                <div class="input-group-append">
                    <button class="btn btn-outline-secondary" type="submit">검색</button>
                </div>
            </div>
        </form>

        <table class="table table-striped">
            <thead>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                    <th>조회수</th>
                </tr>
            </thead>
            <tbody>
                <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                int pageSize = 10; // 한 페이지에 보여줄 게시글 수
                int pageNum = 1; // 기본 페이지 번호
                int totalPosts = 0;
                int totalPages = 0;

                String searchType = request.getParameter("searchType");
                String searchKeyword = request.getParameter("searchKeyword");
                String whereClause = "";

                if(request.getParameter("pageNum") != null) {
                    pageNum = Integer.parseInt(request.getParameter("pageNum"));
                }

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/JSP", "root", "1234");

                    // 검색 조건
                    if(searchType != null && searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                        whereClause = " WHERE " + searchType + " LIKE '%" + searchKeyword + "%' ";
                    }
                    
                    // 전체 게시글 수 조회
                    String countSql = "SELECT COUNT(*) FROM POSTS" + whereClause;
                    pstmt = conn.prepareStatement(countSql);
                    rs = pstmt.executeQuery();
                    if(rs.next()) {
                        totalPosts = rs.getInt(1);
                        totalPages = (int) Math.ceil((double) totalPosts / pageSize);
                    }
                    
                    // 게시글 조회
                    String sql = "SELECT * FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY POST_ID DESC) AS RNUM FROM POSTS " + whereClause + ") AS P WHERE RNUM BETWEEN ? AND ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, (pageNum - 1) * pageSize + 1);
                    pstmt.setInt(2, pageNum * pageSize);
                    rs = pstmt.executeQuery();

                    while(rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getInt("POST_ID") + "</td>");
                        out.println("<td><a href='view_post.jsp?id=" + rs.getInt("POST_ID") + "'>" + rs.getString("TITLE") + "</a></td>");
                        out.println("<td>" + rs.getString("AUTHOR") + "</td>");
                        out.println("<td>" + rs.getDate("CREATE_DATE") + "</td>");
                        out.println("<td>" + rs.getInt("VIEW_COUNT") + "</td>");
                        out.println("</tr>");
                    }
                } catch(Exception e) {
                    e.printStackTrace();
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
            </tbody>
        </table>

        <!-- 페이징 네비게이션 -->
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                <%
                String searchParams = "";
                if(searchType != null && searchKeyword != null) {
                    searchParams = "&searchType=" + searchType + "&searchKeyword=" + searchKeyword;
                }
                for(int i = 1; i <= totalPages; i++) {
                    if(i == pageNum) {
                        out.println("<li class='page-item active'><a class='page-link' href='main.jsp?pageNum=" + i + searchParams + "'>" + i + "</a></li>");
                    } else {
                        out.println("<li class='page-item'><a class='page-link' href='main.jsp?pageNum=" + i + searchParams + "'>" + i + "</a></li>");
                    }
                }
                %>
            </ul>
        </nav>

        <div class="text-right">
            <a href="write.jsp" class="btn btn-primary">글쓰기</a>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
