<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
Document doc = new Document();
String dirCode = ParamUtil.get(request, "dirCode");
if (dirCode.equals("")) {
%>
目录编码不能为空！
<%
	return;
}
Leaf lf = new Leaf();
lf = lf.getLeaf(dirCode);
if (lf==null) {
	out.print("目录不存在!");
	return;
}
%>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=lf.getName()%> - <%=Global.AppName%></title>
<%@ include file="../inc/nocache.jsp"%>
</head>
<body>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<a href="index.jsp">首页</a><br />
<%
int pagesize = 10;

String sql = SQLBuilder.getDirDocListSql(dirCode);
String groupKey = dirCode;
if (dirCode.equals(""))
	groupKey = DocCacheMgr.ALL;
				
int total = doc.getDocCount(sql);
		
Paginator paginator = new Paginator(request, total, pagesize);
int curpage = paginator.getCPage(request);
int totalpages = paginator.getTotalPages();
if (totalpages==0) {
	curpage = 1;
	totalpages = 1;
}
		
int start = (curpage-1)*pagesize;
int end = curpage*pagesize;

Iterator ir = doc.getDocuments(sql, groupKey, start, end);
while (ir.hasNext()) {
	doc = (Document)ir.next();
%>
<a href="../wap_show.jsp?id=<%=doc.getId()%>"><%=StrUtil.getLeft(doc.getTitle(), 26)%></a><br />
<%	
}
%>
<%if (curpage>1) {%>
<a href="list.jsp?dirCode=<%=StrUtil.UrlEncode(dirCode)%>&CPages=<%=(curpage-1)%>">上一页</a>
<%}%>
<%if (curpage<totalpages) {%>
<a href="list.jsp?dirCode=<%=StrUtil.UrlEncode(dirCode)%>&CPages=<%=(curpage+1)%>">&nbsp;下一页</a><br />
<%}%><br />
<a href="index.jsp">首页</a>
</body></html>