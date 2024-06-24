<%@ include file="dbconn.jsp" %>
<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String nickname = (String) session.getAttribute("nickname");

    PreparedStatement pstmtPosts = null;
    PreparedStatement pstmtComments = null;
    PreparedStatement pstmtFollows = null;
    ResultSet rsPosts = null;
    ResultSet rsComments = null;
    ResultSet rsFollows = null;
    boolean isEmpty = true; // 데이터베이스 조회 결과가 비어있는지 여부를 확인하기 위한 변수

    try {
        // 게시물 조회
        pstmtPosts = connhellodb.prepareStatement("SELECT * FROM posts");
        rsPosts = pstmtPosts.executeQuery();

        // 팔로우한 사용자 목록 조회
        pstmtFollows = connhellodb.prepareStatement("SELECT username FROM follows WHERE whofollow = ?");
        pstmtFollows.setString(1, nickname);
        rsFollows = pstmtFollows.executeQuery();

        // rs에 데이터가 있는지 확인
        if (rsPosts.next()) {
            isEmpty = false; // 데이터가 있으면 isEmpty를 false로 설정
            rsPosts = pstmtPosts.executeQuery(); // rs를 다시 첫 번째 레코드로 이동시킴
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    // 요청에서 openCommentBoxId를 가져옴
    String openCommentBoxId = request.getParameter("openCommentBoxId");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시판</title>
    <link rel="stylesheet" href="mystyle.css">
    <script>
        function toggleCommentBox(postId) {
            var commentBox = document.getElementById('comment-box-' + postId);
            
            if (commentBox.style.display === 'block') {
                commentBox.style.display = 'none';
            } else {
                commentBox.style.display = 'block';
            }
        }

        function likePost(postId, nickname) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "likePost.jsp", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText);
                    if (response.success) {
                        document.getElementById('likes-count-' + postId).innerText = response.likes;
                    } else {
                        alert("좋아요 처리 중 오류가 발생했습니다.");
                    }
                }
            };
            xhr.send("post_id=" + postId + "&user_nickname=" + encodeURIComponent(nickname));
        }
        window.onload = function() {
            var openCommentBoxId = '<%= openCommentBoxId %>';
            if (openCommentBoxId) {
                toggleCommentBox(openCommentBoxId);
            }
        }

        function setOpenCommentBoxId(postId) {
            window.location.href = "board.jsp?openCommentBoxId=" + postId;
        }
    </script>
</head>
<body>
    <div class="header">
        <h1><a href="board.jsp"><img src="instagram-logo.png" alt="Instagram">Hostagram</a></h1>
        <div class="search-link">
            <a href="search.jsp" class="search-link"><img src="search.png" alt="검색"></a>
        </div>
        <div class="user-section">
            <a href="post.jsp?username=<%= nickname %>">환영합니다, <%= nickname %>님!</a>
            <a href="login.jsp">로그아웃</a>
        </div>
    </div>

    <div class="main-content">
        <div class="new-post">
            <% if (isEmpty) { %>
                <p>새로운 게시글을 작성해주세요.</p>
            <% } else { %>
                <table>
                    <% while(rsPosts.next()) { %>
                        <tr>
                            <td colspan="2">
                                <b>이름:</b> <a href="post.jsp?username=<%= rsPosts.getString("username") %>"><%= rsPosts.getString("username") %></a>
                                <% if (nickname.equals(rsPosts.getString("username"))) { %>
                                    <a href="deletePost.jsp?id=<%= rsPosts.getInt("id") %>">삭제</a>
                                <% } %>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2"><b>첨부 파일:</b> <a href="downloadFile.jsp?id=<%= rsPosts.getInt("id") %>"><%= rsPosts.getString("file_name") %></a></td>
                        </tr>
                        <tr>
                            <td colspan="2"><b>내용:</b> <%= rsPosts.getString("content") %></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <button type="button" onclick="likePost(<%= rsPosts.getInt("id") %>, '<%= nickname %>')">좋아요</button>
                                좋아요 수: <span id="likes-count-<%= rsPosts.getInt("id") %>"><%= rsPosts.getInt("likes") %></span>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <button type="button" onclick="toggleCommentBox('<%= rsPosts.getInt("id") %>')">댓글 보기</button>
                                <div id="comment-box-<%= rsPosts.getInt("id") %>" class="comment-box">
                                    <div class="comments">
                                        <% 
                                            pstmtComments = connhellodb.prepareStatement("SELECT * FROM comments WHERE post_id = ?");
                                            pstmtComments.setInt(1, rsPosts.getInt("id"));
                                            rsComments = pstmtComments.executeQuery();
                                            while (rsComments.next()) {
                                        %>
                                        <div class="comment">
                                            <b><%= rsComments.getString("username") %></b>: <%= rsComments.getString("content") %>
                                        </div>
                                        <% } %>
                                    </div>
                                    <form action="addComment.jsp" method="post">
                                        <input type="hidden" name="post_id" value="<%= rsPosts.getInt("id") %>">
                                        <input type="hidden" name="username" value="<%= nickname %>">
                                        <textarea name="content" rows="3" cols="50"></textarea><br>
                                        <input type="submit" value="댓글 작성">
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                </table>
            <% } %>
        </div>

        <div class="sidebar">
            <h3>팔로우한 사용자 목록</h3>
            <table>
                <% 
                    try {
                        while (rsFollows.next()) {
                %>
                <tr>
                    <td><a href="post.jsp?username=<%= rsFollows.getString("username") %>"><%= rsFollows.getString("username") %></a></td>
                </tr>
                <% 
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        try {
                            if (rsFollows != null) rsFollows.close();
                            if (pstmtFollows != null) pstmtFollows.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %>
            </table>
        </div>
    </div>
</body>
</html>

<%
    try {
        if (rsPosts != null) rsPosts.close();
        if (pstmtPosts != null) pstmtPosts.close();
        if (rsComments != null) rsComments.close();
        if (pstmtComments != null) pstmtComments.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
