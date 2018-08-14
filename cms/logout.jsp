<%@ page contentType="text/html;charset=utf-8"
import = "cn.js.fan.util.ErrMsgException"
%>
<%@ page import="java.util.Calendar" %>
<html>
<head>
<title>退出</title>
<LINK href="default.css" type=text/css rel=stylesheet>
<%@ include file="../inc/nocache.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="../common.css" type="text/css">
</head>
<body>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege" />
<%
if (!cn.js.fan.module.pvg.Privilege.isUserLogin(request))
	return;
boolean isForeGroundUser = false;
cn.js.fan.module.cms.Config cfgCms = new cn.js.fan.module.cms.Config();
if (cfgCms.getBooleanProperty("cms.isLoginBackgroundWhenLoginForeground")) {
	String nick = privilege.getUser(request);
	cn.js.fan.module.pvg.User backUser = new cn.js.fan.module.pvg.User();
	backUser = backUser.getUser(nick);
	if (backUser.isLoaded()) {
		if (backUser.isForegroundUser()) {
			isForeGroundUser = true;
		}
	}
}

privilege.logout(request, response);

if (isForeGroundUser)
	response.sendRedirect("../index.jsp");
else
	response.sendRedirect("index.jsp");
%>
</body>
</html>


