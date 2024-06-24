<%@ include file="dbconn.jsp" %>
<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    response.setContentType("application/json");

    String post_id_str = request.getParameter("post_id");
    String user_nickname = request.getParameter("user_nickname");

    if (post_id_str != null && user_nickname != null) {
        int post_id = Integer.parseInt(post_id_str);

        // Check if the user has already liked the post
        boolean alreadyLiked = false;
        PreparedStatement pstmtCheckLiked = null;
        ResultSet rsCheckLiked = null;

        try {
            pstmtCheckLiked = connhellodb.prepareStatement("SELECT * FROM likes WHERE post_id = ? AND user_nickname = ?");
            pstmtCheckLiked.setInt(1, post_id);
            pstmtCheckLiked.setString(2, user_nickname);
            rsCheckLiked = pstmtCheckLiked.executeQuery();

            if (rsCheckLiked.next()) {
                alreadyLiked = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rsCheckLiked != null) rsCheckLiked.close();
                if (pstmtCheckLiked != null) pstmtCheckLiked.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Toggle like
        if (alreadyLiked) {
            // Unlike the post
            PreparedStatement pstmtDeleteLike = null;
            try {
                pstmtDeleteLike = connhellodb.prepareStatement("DELETE FROM likes WHERE post_id = ? AND user_nickname = ?");
                pstmtDeleteLike.setInt(1, post_id);
                pstmtDeleteLike.setString(2, user_nickname);
                int rowsDeleted = pstmtDeleteLike.executeUpdate();

                if (rowsDeleted > 0) {
                    // Decrement likes count in posts table
                    PreparedStatement pstmtDecrementLikes = connhellodb.prepareStatement("UPDATE posts SET likes = likes - 1 WHERE id = ?");
                    pstmtDecrementLikes.setInt(1, post_id);
                    pstmtDecrementLikes.executeUpdate();

                    // Fetch updated likes count
                    PreparedStatement pstmtFetchLikes = connhellodb.prepareStatement("SELECT likes FROM posts WHERE id = ?");
                    pstmtFetchLikes.setInt(1, post_id);
                    ResultSet rsLikes = pstmtFetchLikes.executeQuery();
                    int updatedLikes = 0;
                    if (rsLikes.next()) {
                        updatedLikes = rsLikes.getInt("likes");
                    }

                    // JSON 응답 준비
                    String jsonResponse = "{\"success\": true, \"likes\": " + updatedLikes + "}";
                    response.getWriter().write(jsonResponse);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                try {
                    if (pstmtDeleteLike != null) pstmtDeleteLike.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            // Like the post
            PreparedStatement pstmtAddLike = null;
            try {
                pstmtAddLike = connhellodb.prepareStatement("INSERT INTO likes (post_id, user_nickname) VALUES (?, ?)");
                pstmtAddLike.setInt(1, post_id);
                pstmtAddLike.setString(2, user_nickname);
                int rowsInserted = pstmtAddLike.executeUpdate();

                if (rowsInserted > 0) {
                    // Increment likes count in posts table
                    PreparedStatement pstmtIncrementLikes = connhellodb.prepareStatement("UPDATE posts SET likes = likes + 1 WHERE id = ?");
                    pstmtIncrementLikes.setInt(1, post_id);
                    pstmtIncrementLikes.executeUpdate();

                    // Fetch updated likes count
                    PreparedStatement pstmtFetchLikes = connhellodb.prepareStatement("SELECT likes FROM posts WHERE id = ?");
                    pstmtFetchLikes.setInt(1, post_id);
                    ResultSet rsLikes = pstmtFetchLikes.executeQuery();
                    int updatedLikes = 0;
                    if (rsLikes.next()) {
                        updatedLikes = rsLikes.getInt("likes");
                    }

                    // JSON 응답 준비
                    String jsonResponse = "{\"success\": true, \"likes\": " + updatedLikes + "}";
                    response.getWriter().write(jsonResponse);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                try {
                    if (pstmtAddLike != null) pstmtAddLike.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    } else {
        // Parameters are missing
        String jsonResponse = "{\"success\": false, \"error\": \"Missing parameters\"}";
        response.getWriter().write(jsonResponse);
    }
%>
