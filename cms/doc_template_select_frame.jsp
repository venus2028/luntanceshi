<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>选择模板</title>
</head>
<%
String dirCode = ParamUtil.get(request, "dirCode");
%>
<frameset rows="*" cols="30%,*" framespacing="2" border="1">
  <frame src="doc_template_select_left.jsp?dirCode=<%=StrUtil.UrlEncode(dirCode)%>" name="leftFrame" >
  <frame src="doc_template_select_main.jsp" name="mainFrame">
</frameset>
<noframes><body>
</body></noframes>
</html>
