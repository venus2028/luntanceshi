<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN">
<%
String str = SkinUtil.LoadString(request,"res.label.blog.user.frame", "title");
str = StrUtil.format(str, new Object[] {Global.AppName});
%>
<HTML><HEAD><TITLE><%=str%></TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<META content="MSHTML 6.00.3790.259" name=GENERATOR></HEAD>
<jsp:useBean id="strutil" scope="page" class="cn.js.fan.util.StrUtil"/>
<%
long blogId = ParamUtil.getLong(request, "blogId");
// if (userName.equals("")) {
//	out.print(StrUtil.Alert(SkinUtil.LoadString(request,"res.label.blog.user.userconfig", "not_name_frame")));
//	return;
//}
try {
	if (!Privilege.canUserDo(request, blogId, Privilege.PRIV_ENTER)) {
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, SkinUtil.PVG_INVALID)));
		return;
	}
}
catch (ErrMsgException e) {
	out.print(StrUtil.Alert_Back(e.getMessage()));
	return;
}
%>
<FRAMESET border=0 
frameSpacing=0 rows=49,* frameBorder=NO cols=*><FRAME name=topFrame 
src="top.jsp?blogId=<%=blogId%>" noResize scrolling=no><FRAMESET 
border=0 frameSpacing=0 rows=* frameBorder=NO cols=158,*><FRAME name=leftFrame 
src="menu.jsp?blogId=<%=blogId%>" 
noResize scrolling=yes><FRAME name=mainFrame 
src="listtopic.jsp?blogId=<%=blogId%>" 
scrolling=yes></FRAMESET></FRAMESET><noframes></noframes></HTML>
