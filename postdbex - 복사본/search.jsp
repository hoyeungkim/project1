<%@ include file="dbconn.jsp" %>
<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>닉네임 검색</title>
    <link rel="stylesheet" href="searchstyle.css">
</head>
<body>
    <h2>Find User</h2>
    <form action="search.jsp" method="get">
        <input type="text" name="nickname" value="<%= request.getParameter("nickname") %>">
        <input type="submit" value="검색">
    </form>

    <% 
        String searchNickname = request.getParameter("nickname");
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean hasResults = false;

        try {
            String sql = "SELECT * FROM users WHERE nickname LIKE ?";
            pstmt = connlogindb.prepareStatement(sql);
            pstmt.setString(1, "%" + searchNickname + "%");

            rs = pstmt.executeQuery();

            if (!rs.isBeforeFirst()) {
    %>
                <p>검색결과 없음</p>
    <%
            } else {
                hasResults = true;
    %>
                <ul>
                <% while (rs.next()) { %>
                    <li>
                        <a href="post.jsp?username=<%= rs.getString("username") %>"><%= rs.getString("nickname") %></a>
                    </li>
                <% } %>
                </ul>
    <%
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (connlogindb != null) connlogindb.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</body>
</html>
