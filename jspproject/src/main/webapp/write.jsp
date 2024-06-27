	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<!DOCTYPE html>
	<html lang="ko">
	<head>
	    <meta charset="UTF-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	    <title>글쓰기</title>
	    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	</head>
	<body>
	    <div class="container mt-5">
	        <h1 class="text-center mb-4">글쓰기</h1>
	        <form action="write_process.jsp" method="post">
	            <div class="form-group">
	                <label for="title">제목</label>
	                <input type="text" class="form-control" id="title" name="title" required>
	            </div>
	            <div class="form-group">
	                <label for="content">내용</label>
	                <textarea class="form-control" id="content" name="content" rows="5" required></textarea>
	            </div>
	            <button type="submit" class="btn btn-primary">작성</button>
	            <a href="main.jsp" class="btn btn-secondary">취소</a>
	        </form>
	    </div>
	
	    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
	    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
	    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	</body>
	</html>