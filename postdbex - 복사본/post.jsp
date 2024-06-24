<%@ include file="dbconn.jsp" %>
<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // 사용자명(GET 파라미터로 전달받음)
    String username = request.getParameter("username");
    // 세션에서 사용자명과 닉네임 가져오기
    String nickname = (String) session.getAttribute("nickname");

    // JDBC 변수
    PreparedStatement pstmt = null;
    PreparedStatement pstmtFollowCheck = null;
    ResultSet rs = null;
    ResultSet rsFollowCheck = null;
    boolean isFollowing = false;

    try {
        // 팔로우 상태 확인 쿼리
        String followCheckSql = "SELECT COUNT(*) AS follow_count FROM follows WHERE username = ? AND whofollow = ?";
        pstmtFollowCheck = connhellodb.prepareStatement(followCheckSql);
        pstmtFollowCheck.setString(1, username);
        pstmtFollowCheck.setString(2, nickname);
        rsFollowCheck = pstmtFollowCheck.executeQuery();

        if (rsFollowCheck.next()) {
            isFollowing = rsFollowCheck.getInt("follow_count") > 0;
        }

        // SQL 문 준비하여 데이터베이스 조회
        String sql = "SELECT * FROM posts WHERE username = ?";
        pstmt = connhellodb.prepareStatement(sql);
        pstmt.setString(1, username); // 게시물을 작성한 사용자명으로 조회

        // SQL 문 실행 및 결과 가져오기
        rs = pstmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title><%= username %>의 게시물</title>
    <link rel="stylesheet" type="text/css" href="poststyle.css">
    <script>
        function followUser(username, whofollow) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "followUser.jsp", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText);
                    if (response.success) {
                        var followButton = document.getElementById('follow-button');
                        if (followButton.innerText === '팔로우') {
                            followButton.innerText = '팔로우 취소';
                        } else {
                            followButton.innerText = '팔로우';
                        }
                        alert(response.message);
                    } else {
                        alert("팔로우 처리 중 오류가 발생했습니다.");
                    }
                }
            };
            xhr.send("username=" + encodeURIComponent(username) + "&whofollow=" + encodeURIComponent(whofollow));
        }
    </script>
</head>
<body>
    <div class="post-container"> <!-- 게시물 컨테이너 -->
        <h2><%= username %>의 게시물</h2>
        <% if (!nickname.equals(username)) { %>
            <button id="follow-button" onclick="followUser('<%= username %>', '<%= nickname %>')">
                <%= isFollowing ? "팔로우 취소" : "팔로우" %>
            </button>
        <% } %>
        <a href="board.jsp">게시판으로 돌아가기</a>
        <% while(rs.next()) { %>
            <p>내용: <%= rs.getString("content") %></p>
            <p>첨부 파일:
                <a href="downloadFile.jsp?id=<%= rs.getInt("id") %>">
                    <%= rs.getString("file_name") %>
                </a>
            </p>
            <%-- 현재 사용자와 게시물 작성자가 일치할 경우에만 삭제 링크 표시 --%>
            <% if (nickname.equals(username)) { %>
                <p><a href="editPost.jsp?id=<%= rs.getInt("id") %>">수정</a></p>
                <p><a href="deletePost.jsp?id=<%= rs.getInt("id") %>">삭제</a></p>
            <% } %>
            <hr> <!-- 게시물 간 구분선 -->
        <% } %>
    </div>
</body>
</html>
<%
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        // 리소스 닫기
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (rsFollowCheck != null) rsFollowCheck.close();
            if (pstmtFollowCheck != null) pstmtFollowCheck.close();
            if (connhellodb != null) connhellodb.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
