<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Instagram 로그인</title>
    <link rel="stylesheet" href="logstyle.css">
</head>
<body>
    <div class="container">
        <div class="content">
            <div class="logo">
                <img src="instagram-logo.png" alt="Instagram">
            </div>
            <div class="login-container">
                <h2>로그인</h2>
                <form action="login_process.jsp" method="post" class="login-form">
                    <input type="text" id="username" name="username" placeholder="사용자명 또는 이메일" required>
                    <input type="password" id="password" name="password" placeholder="비밀번호" required>
                    <button type="submit">로그인</button>
                </form>
                <div class="signup-link">
                    <p>계정이 없으신가요? <a href="register.jsp">가입하기</a></p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
