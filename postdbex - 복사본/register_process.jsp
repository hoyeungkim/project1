<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*,java.util.*" %>

<%
// 폼 데이터 가져오기
String username = request.getParameter("username");
String password = request.getParameter("password");
String nickname = request.getParameter("nickname");

    // 데이터베이스 연결 정보
    String url = "jdbc:mysql://localhost:3306/logindb";
    String user = "root";
    String dbPassword = "1234";

    // JDBC 변수
    Connection connlogindb = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    boolean isDuplicate = false;

    try {
        // MySQL 드라이버 로드
        Class.forName("com.mysql.jdbc.Driver");

        // 데이터베이스 연결
        connlogindb = DriverManager.getConnection(url, user, dbPassword);

        // 중복 확인을 위한 SQL 문 준비
        String checkSql = "SELECT * FROM users WHERE username = ?";
        stmt = connlogindb.prepareStatement(checkSql);
        stmt.setString(1, username);
        rs = stmt.executeQuery();

        // 중복된 아이디가 있는지 확인
        if (rs.next()) {
            isDuplicate = true;
        }

        if (isDuplicate) {
            // 중복된 아이디가 있을 때
            out.println("<script type=\"text/javascript\">");
            out.println("alert('아이디가 중복입니다. 다른 아이디를 사용해주세요.');");
            out.println("location='register.jsp';");
            out.println("</script>");
        } else {
            // SQL 문 준비하여 데이터 삽입
            String insertSql = "INSERT INTO users (username, password, nickname) VALUES (?, ?, ?)";
            stmt = connlogindb.prepareStatement(insertSql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.setString(3, nickname);

            // SQL 문 실행
            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                // 등록 성공 시 로그인 페이지로 이동
                response.sendRedirect("login.jsp");
            } else {
                // 등록 실패 시 오류 메시지 출력
                out.println("<script type=\"text/javascript\">");
                out.println("alert('계정을 생성하는데 실패했습니다. 다시 시도해주세요.');");
                out.println("location='register.jsp';");
                out.println("</script>");
            }
        }
    }finally {
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
