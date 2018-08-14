<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>发新贴 - <%=Global.AppName%></title>
<%@ include file="../inc/nocache.jsp"%>
<meta http-equiv="content-type" content="application/vnd.wap.xhtml+xml;charset=UTF-8"/></head>
<body>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<jsp:useBean id="Topic" scope="page" class="com.redmoon.forum.MsgMgr" />
<%
String boardcode = ParamUtil.get(request, "boardcode");
Leaf lf = new Leaf();
lf = lf.getLeaf(boardcode);
if (lf==null) {
	out.print("版块不存在");
	return;
}
long id = -1;
String op = ParamUtil.get(request, "op");
if (op.equals("add")) {
	boolean isSuccess = false;
	try {
		isSuccess = Topic.AddNew(application, request);
		id = Topic.getId();
		boardcode = Topic.getCurBoardCode();
%>
		发贴成功！<br />
		<a href="list.jsp?boardcode=<%=StrUtil.UrlEncode(boardcode)%>">回到版块</a><br />
		<a href="../wap_show.jsp?rootid=<%=id%>">查看新发贴子</a><br />
		<a href="index.jsp">回到首页</a>
<%		
		return;
	}
	catch (ErrMsgException e) {
		out.println(e.getMessage() + "<BR>");
		boardcode = Topic.getCurBoardCode();
	}
}
else {
	if (boardcode.equals("")) {
		out.print("请选择某个版块");
		return;
	}
}
%>
<a href="index.jsp">首页</a> <a href="list.jsp?boardcode=<%=StrUtil.UrlEncode(boardcode)%>"><%=lf.getName()%></a>
<form method="post" action="add.jsp?op=add&boardcode=<%=StrUtil.UrlEncode(boardcode)%>" enctype="multipart/form-data">
<input name="boardcode" value="<%=boardcode%>" type="hidden" />
标题：<input name="topic" size="15" /><br />
内容：<textarea name="Content" rows="5" /></textarea><br />
文件：<input type="file" name="filename" /><br />
<input name="expression" value="25" type="hidden" />
<input value="确定" type="submit">
</form>
</body></html>