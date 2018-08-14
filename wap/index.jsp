<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=Global.AppRealName%></title>
<%@ include file="../inc/nocache.jsp"%>
</head>
<body>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<a href="index.jsp"><%=Global.AppRealName%></a><br /><br />
<%
	String parentCode = ParamUtil.get(request, "parentCode");
	if (parentCode.equals(""))
		parentCode = Leaf.ROOTCODE;
	LeafChildrenCacheMgr dlcm = new LeafChildrenCacheMgr(parentCode);
	java.util.Vector vt = dlcm.getDirList();
	Iterator ir = vt.iterator();
	boolean isDisplay = false;
	boolean isFounded = false;
	while (ir.hasNext()) {
		Leaf leaf = (Leaf) ir.next();
		if (leaf.getIsHome()) {
			if (leaf.getType()==Leaf.TYPE_LIST) {%>
				<a href="list.jsp?dirCode=<%=StrUtil.UrlEncode(leaf.getCode())%>"><%=leaf.getName()%></a><BR />
			<%}else if (leaf.getType()==Leaf.TYPE_DOCUMENT) {%>
				<a href="wap_show.jsp?dirCode=<%=StrUtil.UrlEncode(leaf.getCode())%>"><%=leaf.getName()%></a><BR />
			<%}else{%>
				<a href="index.jsp?parentCode=<%=StrUtil.UrlEncode(leaf.getCode())%>"><%=leaf.getName()%></a><BR />				
			<%}
		}
	}
%>
</body></html>