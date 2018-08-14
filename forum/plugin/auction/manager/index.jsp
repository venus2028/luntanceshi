<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.db.Conn"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN">
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<META content="MSHTML 6.00.3790.259" name=GENERATOR></HEAD>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isUserLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
String userName = ParamUtil.get(request, "userName");
if (userName.equals("")) {
	out.print(StrUtil.Alert("用户名不能为空！"));
	return;
}
AuctionShopDb as = new AuctionShopDb();
as = as.getAuctionShopDb(userName);
String user = privilege.getUser(request);
if (!userName.equals(user)) {
	if (!privilege.isMasterLogin(request)) {
		out.print(StrUtil.Alert_Back("对不起，您无权访问！"));
		return;
	}
}
%>
<TITLE><%=as.getShopName()%> - 后台管理</TITLE>
<%
if (!as.isLoaded()) {
	out.print(SkinUtil.makeErrMsg(request, "对不起，您还没有开店或您的店铺已被关闭！"));
	return;
}
%>
<FRAMESET border=0 
frameSpacing=0 rows=0,* frameBorder=NO cols=*><FRAME name=topFrame 
src="top.htm" noResize scrolling=no><FRAMESET 
border=0 frameSpacing=0 rows=* frameBorder=NO cols=198,*><FRAME name=leftFrame 
src="menu.jsp?userName=<%=StrUtil.UrlEncode(userName)%>" 
noResize scrolling=yes><FRAME name=mainFrame 
src="myorder.jsp?userName=<%=StrUtil.UrlEncode(userName)%>" 
scrolling=yes></FRAMESET></FRAMESET><noframes></noframes></HTML>
