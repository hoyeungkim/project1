<%@ page import="java.sql.*"%>
<% Connection connlogindb = null;
    String url1 = "jdbc:mysql://localhost:3306/logindb";
    String user1 = "root";
    String password1 = "1234";
    Class.forName("com.mysql.jdbc.Driver");
    connlogindb = DriverManager.getConnection(url1, user1, password1);

    Connection connhellodb = null;
    String url2 = "jdbc:mysql://localhost:3306/hellodb";
    String user2 = "root";
    String password2 = "1234";
    Class.forName("com.mysql.jdbc.Driver");
    connhellodb = DriverManager.getConnection(url2, user2, password2);
%>