<%@ include file="dbconn.jsp" %>
<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String postId = request.getParameter("post_id");
    String username = request.getParameter("username");
    String content = request.getParameter("content");

    PreparedStatement pstmt = null;

    try {
        // 댓글 삽입
        pstmt = connhellodb.prepareStatement("INSERT INTO comments (post_id, username, content) VALUES (?, ?, ?)");
        pstmt.setInt(1, Integer.parseInt(postId));
        pstmt.setString(2, username);
        pstmt.setString(3, content);
        pstmt.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (connhellodb != null) connhellodb.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 댓글 작성 후 다시 게시판 페이지로 리다이렉트, 댓글 박스 ID를 쿼리 파라미터로 전달
    response.sendRedirect("board.jsp?openCommentBoxId=" + postId);
%>
