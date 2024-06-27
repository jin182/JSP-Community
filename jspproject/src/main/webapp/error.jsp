<%@ page isErrorPage="true" %>
<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Error</title>
</head>
<body>
    <h2>오류가 발생했습니다:</h2>
    <p><%= exception.getMessage() %></p>
    <p>오류 추적:</p>
    <pre>
    <% exception.printStackTrace(new PrintWriter(out)); %>
    </pre>
</body>
</html>