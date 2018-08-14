<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><lt:Label res="res.label.login" key="login"/> - </title>
<%@ include file="../inc/nocache.jsp"%>
</head>
<body>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<jsp:useBean id="loginMonitor" scope="page" class="com.redmoon.forum.security.LoginMonitor"/>
<%
boolean re = false;

	String msg = "";
	try {
		// 不检测验证码
		re = privilege.login(request, response);
	}
	catch(WrongPasswordException e){
		msg = e.getMessage();
	}
	catch (InvalidNameException e) {
		msg = e.getMessage();
	}
	catch (ErrMsgException e) {
		msg = e.getMessage();
	}
	
	if (!msg.equals("")) {
		out.print("<a href='door.jsp'>" + msg + "</a>");
		return;
	}


if (re) {
	String privurl = ParamUtil.get(request, "privurl");
	if (privurl.equals(""))
		privurl = "door.jsp?";
	response.sendRedirect("index.jsp");
	// out.print("<a href='door.jsp'>回到首页</a><BR>");
	// out.print("<a href='../index.jsp'>login success</a><BR>");
	// out.print("<a href='../forum/index.jsp'>login success</a>");
}
%>
</body></html>