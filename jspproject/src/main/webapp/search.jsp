<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String searchType = request.getParameter("searchType");
    String searchKeyword = request.getParameter("searchKeyword");
    int pageNum = 1;
    int pageSize = 10;

    if(request.getParameter("pageNum") != null) {
        pageNum = Integer.parseInt(request.getParameter("pageNum"));
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    List<Map<String, Object>> searchResults = new ArrayList<>();
    int totalPosts = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL 드라이버 클래스명
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydatabase", "JSP", "1234"); // MySQL 연결 정보

        String whereClause = "";
        if(searchType != null && searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            whereClause = " WHERE " + searchType + " LIKE ? ";
        }

        // 전체 게시글 수 조회
        String countSql = "SELECT COUNT(*) FROM POSTS" + whereClause;
        pstmt = conn.prepareStatement(countSql);
        if(!whereClause.isEmpty()) {
            pstmt.setString(1, "%" + searchKeyword + "%");
        }
        rs = pstmt.executeQuery();
        if(rs.next()) {
            totalPosts = rs.getInt(1);
        }

        // 게시글 조회
        String sql = "SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY POST_ID DESC) AS RNUM, P.* FROM POSTS P " + whereClause + ") AS PAGING WHERE RNUM BETWEEN ? AND ?";
        pstmt = conn.prepareStatement(sql);
        int paramIndex = 1;
        if(!whereClause.isEmpty()) {
            pstmt.setString(paramIndex++, "%" + searchKeyword + "%");
        }
        pstmt.setInt(paramIndex++, (pageNum - 1) * pageSize + 1);
        pstmt.setInt(paramIndex, pageNum * pageSize);
        rs = pstmt.executeQuery();

        while(rs.next()) {
            Map<String, Object> post = new HashMap<>();
            post.put("POST_ID", rs.getInt("POST_ID"));
            post.put("TITLE", rs.getString("TITLE"));
            post.put("AUTHOR", rs.getString("AUTHOR"));
            post.put("CREATE_DATE", rs.getDate("CREATE_DATE"));
            post.put("VIEW_COUNT", rs.getInt("VIEW_COUNT"));
            searchResults.add(post);
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

    request.setAttribute("searchResults", searchResults);
    request.setAttribute("totalPosts", totalPosts);
    request.setAttribute("pageNum", pageNum);
    request.setAttribute("pageSize", pageSize);
    request.setAttribute("searchType", searchType);
    request.setAttribute("searchKeyword", searchKeyword);

    RequestDispatcher dispatcher = request.getRequestDispatcher("main.jsp");
    dispatcher.forward(request, response);
%>
