<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="cn.js.fan.util.*"%>
<jsp:useBean id="strutil" scope="page" class="cn.js.fan.util.StrUtil"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>manageList</title>
</head>
<%
String root_code = ParamUtil.get(request, "root_code");
%>
<frameset rows="*,150" cols="*">
  <frame src="dir_top.jsp?root_code=<%=StrUtil.UrlEncode(root_code)%>" name="dirmainFrame">
  <frame src="dir_bottom.jsp" name="dirbottomFrame">
</frameset>
<noframes><body>
</body></noframes>
</html>
