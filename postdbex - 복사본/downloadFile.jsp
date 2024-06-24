<%@ include file="dbconn.jsp" %>
<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    OutputStream outStream = null;
    InputStream inStream = null;
    
    try {
        int id = Integer.parseInt(request.getParameter("id"));
        pstmt = connhellodb.prepareStatement("SELECT * FROM posts WHERE id = ?");
        pstmt.setInt(1, id);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            String fileName = rs.getString("file_name");
            String filePath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + fileName;
            
            File file = new File(filePath);
            inStream = new FileInputStream(file);
            
            // MIME 타입 설정
            response.setContentType(getServletContext().getMimeType(fileName));
            response.setContentLength((int) file.length());
            
            // 다운로드할 파일 이름 설정
            String headerKey = "Content-Disposition";
            String headerValue = String.format("attachment; filename=\"%s\"", fileName);
            response.setHeader(headerKey, headerValue);
            
            // 파일 내용을 response 스트림으로 전송
            outStream = response.getOutputStream();
            byte[] buffer = new byte[4096];
            int bytesRead = -1;
            while ((bytesRead = inStream.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }
        } else {
            out.println("해당 파일을 찾을수 없습니다.");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (outStream != null) outStream.close();
            if (inStream != null) inStream.close();
            if (connhellodb != null) connhellodb.close();
        } catch (SQLException | IOException e) {
            e.printStackTrace();
        }
    }
%>
