<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
MsgDb md = new MsgDb();
String boardcode = ParamUtil.get(request, "boardcode");
if (boardcode.equals("")) {
%>
版块编码不能为空！
<%
	return;
}
Leaf lf = new Leaf();
lf = lf.getLeaf(boardcode);
if (lf==null) {
	out.print("版块不存在!");
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
<a href="index.jsp">首页</a>&nbsp;&nbsp;
<a href="add.jsp?boardcode=<%=StrUtil.UrlEncode(boardcode)%>">发贴</a><BR />
<%=lf.getName()%><br />
<%
try {
	privilege.checkCanEnterBoard(request, boardcode);
}
catch (ErrMsgException e) {
	out.print(e.getMessage());
	out.print("<div><a href=\"index.jsp\">返回首页</a></div>");
	// e.printStackTrace();
	return;
}

int pagesize = 10;

String sql = "select id from sq_thread where boardcode="+StrUtil.sqlstr(boardcode)+" and check_status=" + MsgDb.CHECK_STATUS_PASS + " and msg_level<=" + MsgDb.LEVEL_TOP_BOARD + " ORDER BY msg_level desc,redate desc";
int total = md.getThreadsCount(sql, boardcode);
		
Paginator paginator = new Paginator(request, total, pagesize);
int curpage = paginator.getCPage(request);
int totalpages = paginator.getTotalPages();
if (totalpages==0) {
	curpage = 1;
	totalpages = 1;
}
		
long start = (curpage-1)*pagesize;
long end = curpage*pagesize;

ThreadBlockIterator irmsg = md.getThreads(sql, boardcode, start, end);
while (irmsg.hasNext()) {
	md = (MsgDb)irmsg.next();
%>
<a href="../wap_show.jsp?rootid=<%=md.getId()%>"><%=StrUtil.getLeft(md.getTitle(), 16)%></a><br />
<%	
}
%>
<%if (curpage>1) {%>
<a href="list.jsp?boardcode=<%=StrUtil.UrlEncode(boardcode)%>&CPages=<%=(curpage-1)%>">上一页</a>
<%}%>
<%if (curpage<totalpages) {%>
<a href="list.jsp?boardcode=<%=StrUtil.UrlEncode(boardcode)%>&CPages=<%=(curpage+1)%>">&nbsp;下一页</a><br />
<%}%><br />
<a href="index.jsp">首页</a>&nbsp;&nbsp;
<a href="add.jsp?boardcode=<%=StrUtil.UrlEncode(boardcode)%>">发贴</a><br />
</body></html>