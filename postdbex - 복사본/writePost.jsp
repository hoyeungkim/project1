<%@ include file="dbconn.jsp" %>
<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String nickname = (String) session.getAttribute("nickname");
%>
<!DOCTYPE html>
<html>
<head>
    <title>글 쓰기</title>
    <script type="text/javascript">
        function validateForm() {
            var content = document.getElementsByName("content")[0].value;
            var file = document.getElementsByName("file")[0].value;
            
            if (content.trim() === "" || file.trim() === "") {
                alert("내용과 파일을 모두 입력해주세요.");
                return false; // 폼 제출 취소
            }
            
            return true; // 폼 제출 허용
        }
    </script>
</head>
<body>
    <h1>글 쓰기</h1>
    <form action="uploadFile.jsp" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
        <input type="hidden" name="username" value="<%= nickname %>">
        파일 선택: <input type="file" name="file"><br><!--file을 서버로 보내고 db에서 filename을 저장-->
        내용: <textarea name="content"></textarea><br>
        <input type="submit" value="업로드">
    </form>
    <!-- 게시판 목록으로 돌아가는 링크 -->
    <a href="board.jsp">목록으로</a>
</body>
</html>
