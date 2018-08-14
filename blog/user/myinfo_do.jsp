<%@ page contentType="text/html;charset=utf-8"
import = "java.io.File"
import = "cn.js.fan.web.*"
import = "cn.js.fan.util.ErrMsgException"
%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.Calendar" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<html>
<head>
<title><lt:Label res="res.label.myinfo" key="myinfo"/> - <%=Global.AppName%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil" />
<jsp:useBean id="userservice" scope="page" class="com.redmoon.forum.person.userservice" />
<%
boolean re = false;
try {
	re = userservice.editmyinfo(request,response);
}
catch (ErrMsgException e) {
	out.println(StrUtil.Alert_Back(e.getMessage()));
	return;
}
if (re)
	out.println(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "myinfo.jsp?"));
else
	out.println(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
%>
</body>
</html>


