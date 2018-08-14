<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="cn.js.fan.util.*"%>
<jsp:useBean id="strutil" scope="page" class="cn.js.fan.util.StrUtil"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>管理目录</title>
<script>
var shen = "*,258,0";
var suo = "*,0,0";
function shensuo() {
	/*
	if (allFrame.rows==suo)
		allFrame.rows = shen;
	else
		allFrame.rows = suo;
	*/
	var rows = document.getElementById("allFrame").getAttribute('rows');
	if (rows==suo)
		document.getElementById("allFrame").setAttribute('rows',shen);	
	else
		document.getElementById("allFrame").setAttribute('rows',suo);	
}
</script>
</head>
<%
String root_code = ParamUtil.get(request, "root_code");
%>
<frameset id="allFrame" rows="*,0,0" cols="*">
  <frame src="dir_top_ajax.jsp?root_code=<%=StrUtil.UrlEncode(root_code)%>" name="dirmainFrame">
  <frame src="dir_bottom.jsp?parent_code=<%=root_code%>" name="dirbottomFrame">
  <frame src="dir_do.jsp" name="dirhidFrame">
</frameset>
<noframes><body>
</body></noframes>
</html>
