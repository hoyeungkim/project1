<%@ include file="dbconn.jsp" %>
<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        String username = request.getParameter("username");
        String content = request.getParameter("content");
        Part filePart = request.getPart("file");
        String fileName = filePart.getSubmittedFileName();
        
        String sql = "INSERT INTO posts (username, content, file_name) VALUES (?, ?, ?)";
        pstmt = connhellodb.prepareStatement(sql);
        pstmt.setString(1, username);
        pstmt.setString(2, content);
        pstmt.setString(3, fileName);
        pstmt.executeUpdate();
        // 파일 업로드 처리 코드
        if (filePart != null && filePart.getSize() > 0) {
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);
        }
        response.sendRedirect("board.jsp");
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (connhellodb != null) connhellodb.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
