<%@ include file="dbconn.jsp" %>
<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    response.setContentType("application/json");

    String username = request.getParameter("username"); // 게시물 작성자의 username
    String whofollow = request.getParameter("whofollow"); // 현재 사용자의 nickname

    if (username != null && whofollow != null) {
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 팔로우 관계 확인
            pstmt = connhellodb.prepareStatement("SELECT * FROM follows WHERE username = ? AND whofollow = ?");
            pstmt.setString(1, username);
            pstmt.setString(2, whofollow);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // 이미 팔로우 중인 경우 -> 팔로우 취소
                pstmt.close(); // 이전에 사용한 pstmt를 닫고 새로운 pstmt를 열기 위해 추가
                pstmt = connhellodb.prepareStatement("DELETE FROM follows WHERE username = ? AND whofollow = ?");
                pstmt.setString(1, username);
                pstmt.setString(2, whofollow);
                int rowsDeleted = pstmt.executeUpdate();

                if (rowsDeleted > 0) {
                    String jsonResponse = "{\"success\": true, \"message\": \"Unfollowed successfully\"}";
                    response.getWriter().write(jsonResponse);
                } else {
                    String jsonResponse = "{\"success\": false, \"message\": \"Failed to unfollow\"}";
                    response.getWriter().write(jsonResponse);
                }
            } else {
                // 팔로우하지 않은 경우 -> 팔로우 추가
                pstmt.close(); // 이전에 사용한 pstmt를 닫고 새로운 pstmt를 열기 위해 추가
                pstmt = connhellodb.prepareStatement("INSERT INTO follows (username, whofollow) VALUES (?, ?)");
                pstmt.setString(1, username);
                pstmt.setString(2, whofollow);
                int rowsInserted = pstmt.executeUpdate();

                if (rowsInserted > 0) {
                    String jsonResponse = "{\"success\": true, \"message\": \"Followed successfully\"}";
                    response.getWriter().write(jsonResponse);
                } else {
                    String jsonResponse = "{\"success\": false, \"message\": \"Failed to follow\"}";
                    response.getWriter().write(jsonResponse);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            String jsonResponse = "{\"success\": false, \"message\": \"Database error\"}";
            response.getWriter().write(jsonResponse);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    } else {
        String jsonResponse = "{\"success\": false, \"message\": \"Missing parameters\"}";
        response.getWriter().write(jsonResponse);
    }
%>
