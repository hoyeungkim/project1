<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*,java.util.*" %>

<%
// 폼 데이터 가져오기
String username = request.getParameter("username");
String password = request.getParameter("password");

// 데이터베이스 연결 정보
String url = "jdbc:mysql://localhost:3306/logindb";
String user = "root";
String dbPassword = "1234";

// JDBC 변수
Connection connlogindb = null;
PreparedStatement stmt = null;
ResultSet rs = null;
boolean loggedIn = false;

try {
    // MySQL 드라이버 로드
    Class.forName("com.mysql.jdbc.Driver");

    // 데이터베이스 연결
    connlogindb = DriverManager.getConnection(url, user, dbPassword);

    // SQL 문 준비하여 사용자 검색
    String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
    stmt = connlogindb.prepareStatement(sql);
    stmt.setString(1, username);
    stmt.setString(2, password);

    // SQL 문 실행 및 결과 가져오기
    rs = stmt.executeQuery();

    // 결과가 있으면 로그인 성공 처리
    if (rs.next()) {
        loggedIn = true;
        String nickname = rs.getString("nickname");
        session.setAttribute("username", username);
        session.setAttribute("nickname", nickname);
        response.sendRedirect("board.jsp"); // 로그인 성공 시 환영 페이지로 이동
    } else {
        // 로그인 실패 처리
        out.println("<script type=\"text/javascript\">");
        out.println("alert('사용자명 또는 비밀번호가 일치하지 않습니다.');");
        out.println("location='login.jsp';");
        out.println("</script>");
    }
} finally {
    // 리소스 닫기
    try {
        if (rs != null) {
            rs.close();
        }
        if (stmt != null) {
            stmt.close();
        }
        if (connlogindb != null) {
            connlogindb.close();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

%>
