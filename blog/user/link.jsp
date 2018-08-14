<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.blog.link.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.blog.user.link" key="title"/></title>
<link href="../../cms/default.css" rel="stylesheet" type="text/css">
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
<%
long blogId = ParamUtil.getLong(request, "blogId");

LinkMgr lm = new LinkMgr();
LinkDb ld = new LinkDb();

String op = StrUtil.getNullString(request.getParameter("op"));

if (op.equals("add")) {
	try {
		if (lm.add(application, request)) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_success"), "link.jsp?blogId=" + blogId));
			return;
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
}
if (op.equals("edit")) {
	try {
		if (lm.modify(application, request))
			out.print(StrUtil.Alert(SkinUtil.LoadString(request,"res.common", "info_op_success")));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
}
if (op.equals("move")) {
	try {
		if (lm.move(request))
			out.print(StrUtil.Alert(SkinUtil.LoadString(request,"res.common", "info_op_success")));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
}
if (op.equals("del")) {
	if (lm.del(application, request))
		out.print(StrUtil.Alert(SkinUtil.LoadString(request,"res.common", "info_op_success")));
	else
		out.print(StrUtil.Alert(SkinUtil.LoadString(request,"res.common", "info_op_fail")));
}

String user = Privilege.getUser(request);

// 检查用户权限
if (!Privilege.canUserDo(request, blogId, Privilege.PRIV_ALL)) {
	out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, SkinUtil.PVG_INVALID)));
	return;
}
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head"><lt:Label res="res.label.blog.user.frame" key="link"/></td>
  </tr>
</table>
<br>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="95%" align="center">
  <tbody>
    <tr>
      <td width="22%" height="24" noWrap class="thead"><lt:Label res="res.label.blog.user.link" key="name"/></td>
      <td width="21%" noWrap class="thead"><lt:Label res="res.label.blog.user.link" key="link"/></td>
      <td width="25%" noWrap class="thead"><lt:Label res="res.label.blog.user.link" key="pic"/></td>
      <td width="32%" noWrap class="thead"><lt:Label res="res.label.blog.user.link" key="operate"/></td>
    </tr>
<%
String sql = "select id from " + ld.getTableName() + " where blog_id=" + blogId + " order by sort";
Iterator ir = ld.list(sql).iterator();
int i=100;
while (ir.hasNext()) {
	i++;
 	ld = (LinkDb)ir.next();
	%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
	  <form name="form<%=i%>" action="?op=edit&blogId=<%=blogId%>" method="post" enctype="MULTIPART/FORM-DATA">
      <td style="PADDING-LEFT: 10px">&nbsp;<img src="../../forum/images/readme.gif" align="absmiddle">&nbsp;<input name=title value="<%=ld.getTitle()%>"></td>
      <td><input name=url value="<%=ld.getUrl()%>" size="30"></td>
      <td>
        <input name="filename" type="file" style="width: 180px">		</td>
      <td>
	  [ <a href="javascript:form<%=i%>.submit()"><lt:Label res="res.label.blog.user.link" key="modify"/></a> ] [ <a onClick="if (!confirm('<lt:Label res="res.label.blog.user.link" key="del_confirm"/>')) return false" href="?op=del&id=<%=ld.getId()%>&blogId=<%=blogId%>"><lt:Label res="res.label.blog.user.link" key="del"/></a> ] [<a href="?op=move&direction=up&id=<%=ld.getId()%>&blogId=<%=blogId%>"><lt:Label res="res.label.blog.user.link" key="move_up"/></a>] [<a href="?op=move&direction=down&id=<%=ld.getId()%>&blogId=<%=blogId%>"><lt:Label res="res.label.blog.user.link" key="move_down"/></a>] 
	  <input name="id" value="<%=ld.getId()%>" type="hidden">
	  <input name="blogId" value="<%=blogId%>" type="hidden">
	  </td>
	  </form>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td colspan="4" style="PADDING-LEFT: 10px">
	  <%if (ld.getImage()==null || ld.getImage().equals("")) {%>
	  <%}else{%>
	  <img src="<%=ld.getImageUrl(request)%>">
	  <%}%>	  </td>
    </tr>
<%}%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
	<form action="?op=add&blogId=<%=blogId%>" method="post" enctype="multipart/form-data" name="addform1">
      <td style="PADDING-LEFT: 10px">
	  &nbsp;<img src="../../forum/images/readme.gif" align="absmiddle">
	  <input name=title value=""></td>
      <td><input name=url value="" size="30"></td>
      <td><span class="stable">
        <input type="file" name="filename" style="width: 180px">
      </span></td>
      <td><INPUT type=submit height=20 width=80 value="<lt:Label res="res.label.blog.user.link" key="add"/>">
        <input name="blogId" value="<%=blogId%>" type="hidden">
      </td>
	</form>
    </tr>
    <tr align="center" class="row" style="BACKGROUND-COLOR: #ffffff">
      <td colspan="4" style="PADDING-LEFT: 10px">(<lt:Label res="res.label.blog.user.link" key="modify_pic_description"/>)</td>
    </tr>
  </tbody>
</table>
</body>
</html>