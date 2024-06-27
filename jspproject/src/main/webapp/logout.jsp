<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 세션 무효화
    session.invalidate();
    
    // 로그인 페이지로 리다이렉트
    response.sendRedirect("login.jsp");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그아웃</title>
</head>
<body>
    <h1>로그아웃 중...</h1>
    <p>로그아웃되었습니다. 로그인 페이지로 이동 중...</p>
</body>
</html>
