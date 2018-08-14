<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.nav.*"%>
<%@ page import="cn.js.fan.module.pvg.*" %>
<html>
<head>
<title>管理链接</title>
<link href="../common.css" rel="stylesheet" type="text/css">
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}
body {
	margin-top: 0px;
	margin-left: 0px;
	margin-right: 0px;
}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
String userName = ParamUtil.get(request, "userName");

LinkMgr lm = new LinkMgr();
LinkDb ld = new LinkDb();

String op = StrUtil.getNullString(request.getParameter("op"));

if (op.equals("add")) {
	try {
		if (lm.add(application, request))
			out.print(StrUtil.Alert("添加成功！"));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
}
if (op.equals("edit")) {
	try {
		if (lm.modify(application, request))
			out.print(StrUtil.Alert("修改成功！"));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
}
if (op.equals("move")) {
	try {
		if (lm.move(request))
			out.print(StrUtil.Alert("移动成功！"));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
}
if (op.equals("del")) {
	if (lm.del(application, request))
		out.print(StrUtil.Alert("删除成功！"));
	else
		out.print(StrUtil.Alert("删除失败！"));
}

if (userName.equals("")) {
	userName = StrUtil.getNullString(lm.getUserName());
	if (userName.equals("")) {
		out.print(StrUtil.Alert("用户名不能为空！"));
		return;
	}
}

String user = privilege.getUser(request);
if (!userName.equals(user)) {
	if (!privilege.isMasterLogin(request)) {
		out.print(StrUtil.Alert("对不起，您无权访问！"));
		return;
	}
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">管理链接</td>
    </tr>
  </tbody>
</table>
<br>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="95%" align="center">
  <tbody>
    <tr>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="21%">名称</td>
      <td class="thead" noWrap width="22%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">链接</td>
      <td class="thead" noWrap width="25%">图片</td>
      <td width="32%" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">操作</td>
    </tr>
<%
String sql = ld.getListSql(LinkDb.KIND_SHOP, userName);
Iterator ir = ld.list(sql).iterator();
int i=100;
while (ir.hasNext()) {
	i++;
 	ld = (LinkDb)ir.next();
	%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
	  <form name="form<%=i%>" action="?op=edit" method="post" enctype="MULTIPART/FORM-DATA">
      <td style="PADDING-LEFT: 10px">&nbsp;<img src="images/arrow.gif" align="absmiddle">&nbsp;<input name=title value="<%=ld.getTitle()%>"></td>
      <td><input name=url value="<%=ld.getUrl()%>" size="30"></td>
      <td>
        <input name="filename" type="file" style="width: 80px">
		</td>
      <td>
	  [ <a href="javascript:form<%=i%>.submit()">编辑</a> ] [ <a onClick="if (!confirm('您确定要删除吗？')) return false" href="?op=del&id=<%=ld.getId()%>&kind=<%=ld.KIND_SHOP%>&userName=<%=StrUtil.UrlEncode(userName)%>">删除</a> ] [<a href="?op=move&direction=up&id=<%=ld.getId()%>&userName=<%=StrUtil.UrlEncode(userName)%>">上移</a>] [<a href="?op=move&direction=down&id=<%=ld.getId()%>&userName=<%=StrUtil.UrlEncode(userName)%>">下移</a>] 
	  <input name="id" value="<%=ld.getId()%>" type="hidden">
	  <input name="userName" value="<%=userName%>" type="hidden">
	  <input name="kind" value="<%=ld.KIND_SHOP%>" type="hidden">
	  </td>
	  </form>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td colspan="4" style="PADDING-LEFT: 10px">
	  <%if (ld.getImage()==null || ld.getImage().equals("")) {%>
	  <%}else{%>
	  <img src="<%=ld.getImageUrl(request)%>">
	  <%}%>
	  </td>
    </tr>
<%}%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
	<form action="?op=add" method="post" enctype="multipart/form-data" name="addform1">
      <td style="PADDING-LEFT: 10px">
	  &nbsp;<img src="images/arrow.gif" align="absmiddle">&nbsp;
	  <input name=title value="" size="15"></td>
      <td><input name=url value="" size="30"></td>
      <td><span class="stable">
        <input type="file" name="filename" style="width: 80px">
      </span></td>
      <td><INPUT type=submit height=20 width=80 value="添加">
        <input name="userName" value="<%=userName%>" type="hidden">
        <input name="kind" value="<%=ld.KIND_SHOP%>" type="hidden">
        </td>
	</form>
    </tr>
    <tr align="center" class="row" style="BACKGROUND-COLOR: #ffffff">
      <td colspan="4" style="PADDING-LEFT: 10px">( 如果没有上传图片，点击编辑将删除原来的图片)</td>
    </tr>
  </tbody>
</table>
<HR noShade SIZE=1>
</body>
</html>