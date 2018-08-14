<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.blog.ui.*"%>
<%@ page import="com.redmoon.forum.setup.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>模版选择</title>
<style type="text/css">
#template_sel {
padding:0px;
margin:auto;
font-size:12px;
}

.title {
width:110px;
padding:5px;
text-align:center;
}

ul {
margin:0px;
padding:0px;
}

li {
width:120px;
height:185px;
margin:16px;
float:left;
display:inline;
}

a:link {
font-size:12px;
color:#000000;
text-decoration:none;
}

a:hover {
font-size:12px;
color:#000000;
text-decoration:none;
}

a:visited {
font-size:12px;
color:#000000;
text-decoration:none;
}
</style>
</head>
<body>
<%
TemplateDb td = new TemplateDb();
Vector v = td.list();
Iterator ir = v.iterator();
String skinoptions = "";
String miniature = "";
String divPrint = "";
while (ir.hasNext()) {
	td = (TemplateDb) ir.next();
	miniature = StrUtil.getNullStr(td.getString("miniature"));
%>
<div id="template_sel">
	<ul>
		<li>
		    <%if(!miniature.equals("")) {%>
			<img style="cursor:hand" src="<%=request.getContextPath()%>/<%=td.getString("miniature")%>" onclick="window.opener.sel('<%=td.getLong("id")%>');window.close()" width="120" height="160"/><br />
			<%} else {%>
			<img style="cursor:hand" src="../template/images/defaultMiniature.png" onclick="window.opener.sel('<%=td.getLong("id")%>');window.close()" /><br />
			<%}%>
			<div class="title"><a href="#" onclick="window.opener.sel('<%=td.getLong("id")%>');window.close()"><%=td.getString("Name")%></a></div>
		</li>
	</ul>
<%}%>
</div>
</body>
</html>
