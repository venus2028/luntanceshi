<%@ page contentType="text/html;charset=utf-8"%><%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<link href="../common.css" rel="stylesheet" type="text/css">
<title><lt:Label res="res.label.login" key="login"/> - <%=Global.AppName%></title>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
}
-->
</style></head>
<body>
<%@ include file="../inc/nocache.jsp"%>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<jsp:useBean id="loginMonitor" scope="page" class="com.redmoon.forum.security.LoginMonitor"/>
<%
boolean isValid = true;
try {
	isValid = loginMonitor.canLogin(request);
}
catch (ErrMsgException e)
{
	out.print(SkinUtil.makeErrMsg(request, e.getMessage()));
	return;
}

boolean re = false;
if (isValid) {
	String msg = "";
	try{
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
	
	try {
		loginMonitor.afterLogin(request, re, true);
	}
	catch (ErrMsgException e) {
		// msg = SkinUtil.makeErrMsg(request, msg + "<BR>" + e.getMessage());
		msg += "\r\n" + e.getMessage();
	}
	if (!msg.equals("")) {
		out.print(SkinUtil.makeErrMsg(request, msg));		
		return;
	}
}
%>
<%
if (re) {
	String privurl = ParamUtil.get(request, "privurl");
	if (privurl.equals(""))
		privurl = "index.jsp";
%>
	<BR><BR>
	<ol><lt:Label res="res.label.login" key="login_success"/></ol>
<%		
	out.print(StrUtil.waitJump("<a href='"+privurl+"'>" + SkinUtil.LoadString(request,"res.label.login","return_front") + "</a>", 1, privurl));
}
%>
	<br />
	<br />
