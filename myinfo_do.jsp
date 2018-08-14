<%@ page contentType="text/html;charset=utf-8"
import = "cn.js.fan.web.*"
import = "cn.js.fan.util.ErrMsgException"
import = "cn.js.fan.util.*"
import = "com.redmoon.forum.ucenter.*"
%>
<%@ page import="org.jdom.Element"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<html>
<head>
<title><lt:Label res="res.label.myinfo" key="myinfo"/> - <%=Global.AppName%></title>
<%@ include file="inc/nocache.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="common.css" type="text/css">
<style type="text/css">
<!--
body {
	margin-top: 0px;
}
-->
</style></head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="userservice" scope="page" class="com.redmoon.forum.person.userservice" />
<%
/*==========UCenter==========*/
	com.redmoon.forum.ucenter.UCenterConfig myconfig = com.redmoon.forum.ucenter.UCenterConfig.getInstance();
	Element uc = myconfig.getRootElement().getChild("uc");
	String isUcActive = uc.getChild("isActive").getText();
	if(isUcActive.equals("true")) {
		String userName = ParamUtil.get(request, "nick");
		String pwd = ParamUtil.get(request, "Password");
		if(!pwd.equals("")) {
			String pwdRepeat = ParamUtil.get(request, "Password2");
			if(!pwd.equals(pwdRepeat)) {
				out.println(StrUtil.Alert_Back("两次输入的密码不一致！"));
				return;
			}
		}
		String email = ParamUtil.get(request, "Email");
		try {
			com.redmoon.forum.ucenter.UC.edit(userName, pwd, email);
		} catch (ErrMsgException e) {
			out.print(SkinUtil.makeErrMsg(request, e.getMessage()));
			return;
		}
	}
/*==========UCenter==========*/

boolean re = false;
try {
	re = userservice.editmyinfo(request,response);
}
catch (ErrMsgException e) {
	out.println(StrUtil.Alert_Back(e.getMessage()));
	return;
}
if (re)
	out.println(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "myinfo.jsp?userName=" + StrUtil.UrlEncode(ParamUtil.get(request, "RegName"))));
else
	out.println(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
%>
</body>
</html>


