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
<title>回复 - <%=Global.AppRealName%></title>
<%@ include file="../inc/nocache.jsp"%>
</head>
<body>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
long replyid = ParamUtil.getLong(request, "replyid");
MsgDb replyMsgDb = new MsgDb();
replyMsgDb = replyMsgDb.getMsgDb(replyid);
if (!replyMsgDb.isLoaded()) {
	out.print("贴子不存在！");
	return;
}

if (!privilege.canAddQuickReply(request, replyMsgDb.getboardcode(), replyMsgDb)) {
     out.print(SkinUtil.LoadString(request, SkinUtil.PVG_INVALID));
	 return;
}

String op = ParamUtil.get(request, "op");
if (op.equals("add")) {
	boolean isSuccess = false;
	String boardcode="";
	try {
		MsgDb md = new MsgDb();
		isSuccess = md.AddQuickReply(application, request, privilege.getUser(request));
%>
回复成功！<br />
<a href="list.jsp?boardcode=<%=StrUtil.UrlEncode(replyMsgDb.getboardcode())%>">回到版块</a><br />
<a href="../wap_show.jsp?rootid=<%=replyid%>">回到贴子</a><br />
<a href="index.jsp">回到首页</a>
<%		
		return;
	}
	catch (ErrMsgException e) {
		out.println(e.getMessage() + "<BR>");
%>
		<a href="reply.jsp?replyid=<%=replyid%>">返回继续</a>
<%		
		return;
	}
}
%>
<%
Leaf lf = new Leaf();
lf = lf.getLeaf(replyMsgDb.getboardcode());
%>
<a href="index.jsp">首页</a> <a href="list.jsp?boardcode=<%=StrUtil.UrlEncode(lf.getCode())%>"><%=lf.getName()%></a><br /><br />
回复：<a href="../wap_show.jsp?rootid=<%=replyid%>"><%=replyMsgDb.getTitle()%></a><br />
<form action="reply.jsp">
<textarea name="Content" rows="5" />
</textarea>
<br />
<input name="replyid" value="<%=replyid%>" type="hidden" />
<input name="op" value="add" type="hidden" />
<input name="expression" value="25" type="hidden" />
<input name="topic" value="回复：<%=replyMsgDb.getTitle()%>" type="hidden" />
<input value="确定" type="submit"  />
</form>
<a href="index.jsp">首页</a> <a href="list.jsp?boardcode=<%=StrUtil.UrlEncode(lf.getCode())%>"><%=lf.getName()%></a>
</body></html>