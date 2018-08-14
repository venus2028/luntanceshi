<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN">
<HTML><HEAD><TITLE><%=cn.js.fan.web.Global.AppName%> - 子站点管理</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<META content="MSHTML 6.00.3790.259" name=GENERATOR></HEAD>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
String op = ParamUtil.get(request, "op");
String siteCode = ParamUtil.get(request, "siteCode");
if (!privilege.isUserLogin(request) && !com.redmoon.forum.Privilege.isUserLogin(request)) {
	response.sendRedirect("index.jsp");
	// out.print("请先登录");
	return;
}
if (op.equals("siteManagerLogin")) {
	if (!privilege.isUserLogin(request)) {
		String userName = com.redmoon.forum.Privilege.getUser(request);
		com.redmoon.forum.person.UserDb ud = new com.redmoon.forum.person.UserDb();
		ud = ud.getUser(userName);
		
		cn.js.fan.module.pvg.User user = new cn.js.fan.module.pvg.User();
		user = user.getUser(ud.getNick());
		if (!user.isLoaded() || !user.isForegroundUser()) {
			out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
			return;
		}
		
		privilege.doLogin(request, ud.getNick(), ud.getPwdMd5());
		response.sendRedirect("frame.jsp?siteCode=" + siteCode);
		return;
	}
}

SiteDb sd = new SiteDb();
sd = sd.getSiteDb(siteCode);
if (!SitePrivilege.canManage(request, sd)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<FRAMESET border=0 
frameSpacing=0 rows=49,* frameBorder=NO cols=*><FRAME name=topFrame 
src="../top.jsp" noResize scrolling=no><FRAMESET 
border=0 frameSpacing=0 rows=* frameBorder=NO cols=198,*><FRAME name=leftFrame 
src="menu.jsp?siteCode=<%=siteCode%>" 
noResize scrolling=yes><FRAME name=mainFrame 
src="site.jsp?siteCode=<%=siteCode%>" 
scrolling=yes></FRAMESET></FRAMESET><noframes></noframes></HTML>
