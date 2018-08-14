<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=Global.AppRealName%></title>
<%@ include file="../inc/nocache.jsp"%>
</head>
<body>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
UserMgr um = new UserMgr();
if (privilege.isUserLogin(request)) {
	UserDb user = um.getUser(privilege.getUser(request));
%>
欢迎您！<%=user.getNick()%><br />
<a href="exit.jsp">退出</a><br />
<%	
}else{%>
<a href="door.jsp">登录</a><br />
<%}%><br />
<%
	LeafChildrenCacheMgr dlcm = new LeafChildrenCacheMgr(Leaf.CODE_ROOT);
	java.util.Vector vt = dlcm.getChildren();
	Iterator ir = vt.iterator();
	boolean isDisplay = false;
	boolean isFounded = false;
	while (ir.hasNext()) {
		Leaf leaf = (Leaf) ir.next();
		String parentCode = leaf.getCode();
		if (leaf.isDisplay(request, privilege)) {
%>		
			<%=leaf.getName()%><BR />
<%
			LeafChildrenCacheMgr dl = new LeafChildrenCacheMgr(parentCode);
			java.util.Vector v = dl.getChildren();
			Iterator ir1 = v.iterator();
			while (ir1.hasNext()) {
				Leaf lf = (Leaf) ir1.next();
				if (lf.isDisplay(request, privilege)) {
					if (!lf.isLocked()) {
					%>
						<a href="list.jsp?boardcode=<%=StrUtil.UrlEncode(lf.getCode())%>"><%=lf.getName()%></a><BR />
					<%}
				}
			}
		}
	}
%>
</body></html>