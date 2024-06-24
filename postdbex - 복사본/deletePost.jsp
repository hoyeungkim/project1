<%@ include file="dbconn.jsp" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    PreparedStatement pstmt = null;
    try {
        int id = Integer.parseInt(request.getParameter("id"));
        pstmt = connhellodb.prepareStatement("DELETE FROM posts WHERE id = ?");
        pstmt.setInt(1, id);
        pstmt.executeUpdate();
        response.sendRedirect("board.jsp");
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (connhellodb != null) connhellodb.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>