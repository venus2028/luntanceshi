<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>login</title> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../inc/nocache.jsp"%>
</head>
<body>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
欢迎访问&nbsp;<%=Global.AppName%><br />
<%if (privilege.isUserLogin(request)) {
	UserMgr um = new UserMgr();
	UserDb user = um.getUser(privilege.getUser(request));
	out.print(user.getNick());
%>
<%}else{%>
<form action="login.jsp" method="get">
  用户名
  <input name="name" size="10" />
  <br />
密&nbsp;&nbsp;码
<input name="pwd" size="10" />
<br />
<div align="center"><input type="submit" value="登录" /></div>
</form>
<%}%>
</body>
</html>
