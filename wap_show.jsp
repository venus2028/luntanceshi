<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="com.cloudwebsoft.framework.base.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>看文章 - <%=Global.AppRealName%></title>
<%@ include file="../inc/nocache.jsp"%>
</head>
<body>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
int id = ParamUtil.getInt(request, "id");
Document doc = new Document();
doc = doc.getDocument(id);
if (!doc.isLoaded()) {
	out.print("文章不存在！");
	return;
}

Leaf lf = new Leaf();
lf = lf.getLeaf(doc.getDirCode());

String op = ParamUtil.get(request, "op");
CommentMgr cm = new CommentMgr();
if (op.equals("addcomment")) {
	boolean re = false;
	try {
		re = cm.create(request);
	}
	catch (ErrMsgException e) {
		out.print(e.getMessage());
	}
	if (re) {
		out.print("评论成功！<BR>");
	}
%>
<a href="wap_show.jsp?id=<%=id%>">返回</a><br />
<a href="wap/index.jsp">首页</a>&nbsp;&nbsp;<a href="wap/list.jsp?dirCode=<%=StrUtil.UrlEncode(lf.getCode())%>"><%=lf.getName()%></a>
<%
	return;	
}
%>
<a href="wap/index.jsp">首页</a>&nbsp;&nbsp;<a href="wap/list.jsp?dirCode=<%=StrUtil.UrlEncode(lf.getCode())%>"><%=lf.getName()%></a>
<br /><br />
标题：<%=doc.getTitle()%><br />
作者：<%=doc.getAuthor()%><br />
日期：<%=DateUtil.format(doc.getCreateDate(), "yyyy-MM-dd HH:mm")%><br />
内容：<%=doc.getContent(1)%><br />

<%
if (doc.isCanComment()) {
%>
评论：<br />
<%
CommentDb cd = new CommentDb();
String sql = "select id from " + cd.getTableName() + " where doc_id=" + id + " order by add_date desc";
ObjectBlockIterator oi = cd.getObjects(sql, "" + id, 0, 50);
while (oi.hasNext()) {
		CommentDb cmt = (CommentDb) oi.next();
	%>
	<a href="<%=cmt.getLink()%>"><%=cmt.getNick()%></a>&nbsp;发表于&nbsp;<%=cmt.getAddDate()%><br />
	<%=cmt.getContent()%><br />
	<%
	}%>
	<table width="25%" >
      <form action="?op=addcomment" method="post" id="form1">
        <tr align="left">
          <td height="24" colspan="2">发表评论</td>
        </tr>
        <tr>
          <td width="10%" height="24" align="left">姓&nbsp;名          </td>
          <td width="90%" align="left"><input type="text" name="nick" size="15" />
            <input type="hidden" name="doc_id" value="<%=doc.getID()%>" />
            <input type="hidden" name="id" value="<%=doc.getID()%>" /></td>
        </tr>
        <tr>
          <td height="24" align="left">来&nbsp;自</td>
          <td align="left"><input name="link" type="text" size="15" /></td>
        </tr>
        <tr>
          <td align="left">内&nbsp;容          </td>
          <td align="left"><textarea name="content" rows="5" /></textarea></td>
        </tr>
        <tr>
          <td colspan="2" align="center"><input name="Submit" type="submit" class="singleboarder" value="提交" />
            &nbsp;&nbsp;&nbsp;&nbsp;
            <input name="Submit" type="reset" class="singleboarder" value="重置" /></td>
        </tr>
      </form>
</table>
<%}
%>
<br />
<a href="wap/index.jsp">首页</a>&nbsp;&nbsp;<a href="wap/list.jsp?dirCode=<%=StrUtil.UrlEncode(lf.getCode())%>"><%=lf.getName()%></a>
</body></html>