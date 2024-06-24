<%@ include file="dbconn.jsp" %>
<%@ page import="java.io.*, java.sql.*, java.util.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>

<%
    String searchNickname = request.getParameter("nickname");

    // JDBC 변수
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    List<Map<String, String>> results = new ArrayList<>();

    try {
        // SQL 문 준비하여 데이터베이스 조회
        String sql = "SELECT username, nickname FROM users WHERE nickname LIKE ?";
        pstmt = connlogindb.prepareStatement(sql);
        pstmt.setString(1, "%" + searchNickname + "%"); // 닉네임 부분 일치 검색

        // SQL 문 실행 및 결과 가져오기
        rs = pstmt.executeQuery();

        // 결과를 JSON 형태로 만들어 반환
        while (rs.next()) {
            Map<String, String> result = new HashMap<>();
            result.put("username", rs.getString("username"));
            result.put("nickname", rs.getString("nickname"));
            results.add(result);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        // 리소스 닫기
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (connlogindb != null) connlogindb.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // JSON 형태로 결과 반환
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    PrintWriter out = response.getWriter();
    out.print(new Gson().toJson(results));
    out.flush();
    out.close();
%>
