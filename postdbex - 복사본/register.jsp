<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사용자 등록</title>
    <link rel="stylesheet" href="registyle.css">
</head>
<body>
    <div class="container">
        <div class="content">
            <h2>사용자 등록</h2>
            <form action="register_process.jsp" method="post" class="register-form">
                <label for="username">사용자명:</label>
                <input type="text" id="username" name="username" required><br><br>
                
                <label for="password">비밀번호:</label>
                <input type="password" id="password" name="password" required><br><br>
                
                <label for="nickname">닉네임:</label>
                <input type="text" id="nickname" name="nickname" required><br><br>
                
                <button type="submit">등록</button>
            </form>
        </div>
    </div>
</body>
</html>
