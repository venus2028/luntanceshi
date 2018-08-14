<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.nav.*"%>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.forum.admin.link" key="link_manage"/></title>
<link href="../default.css" rel="stylesheet" type="text/css">
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
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
String siteCode = ParamUtil.get(request, "userName");
SiteDb sd = new SiteDb();
sd = sd.getSiteDb(siteCode);
if (!SitePrivilege.canManage(request, sd)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

LinkMgr lm = new LinkMgr();
LinkDb ld = new LinkDb();
String userName = siteCode;
String kind = LinkDb.KIND_CMS_SUB_SITE;
String op = StrUtil.getNullString(request.getParameter("op"));

if (op.equals("add")) {
	try {
		if (lm.add(application, request)) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "site_link.jsp?kind=" + kind + "&userName=" + StrUtil.UrlEncode(userName)));
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}
else if (op.equals("edit")) {
	try {
		if (lm.modify(application, request)) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "site_link.jsp?kind=" + kind + "&userName=" + StrUtil.UrlEncode(userName)));
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}
else if (op.equals("move")) {
	try {
		if (lm.move(request)) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "site_link.jsp?kind=" + kind + "&userName=" + StrUtil.UrlEncode(userName)));
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}
else if (op.equals("del")) {
	if (lm.del(application, request)) {
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "site_link.jsp?kind=" + kind + "&userName=" + StrUtil.UrlEncode(userName)));
	}
	else {
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_del")));
	}
	return;
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head"><lt:Label res="res.label.forum.admin.link" key="link_manage"/></td>
    </tr>
  </tbody>
</table>
<br>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="98%" align="center">
  <tbody>
    <tr>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="22%"><lt:Label res="res.label.forum.admin.link" key="name"/></td>
      <td class="thead" noWrap width="21%"><img src="../images/tl.gif" align="absMiddle" width="10" height="15">
      <lt:Label res="res.label.forum.admin.link" key="link"/></td>
      <td class="thead" noWrap width="30%"><img src="../images/tl.gif" align="absMiddle" width="10" height="15">
        <lt:Label res="res.label.forum.admin.link" key="image"/></td><td width="27%" noWrap class="thead"><img src="../images/tl.gif" align="absMiddle" width="10" height="15"><lt:Label key="op"/></td>
    </tr>
<%
String sql = ld.getListSql(LinkDb.KIND_CMS_SUB_SITE, userName);
Iterator ir = ld.list(sql).iterator();
int i=100;
while (ir.hasNext()) {
	i++;
 	ld = (LinkDb)ir.next();
	%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
	  <form name="form<%=i%>" action="?op=edit&kind=<%=kind%>&userName=<%=userName%>" method="post" enctype="MULTIPART/FORM-DATA">
      <td style="PADDING-LEFT: 10px">&nbsp;<img src="../images/arrow.gif" align="absmiddle">&nbsp;<input name=title value="<%=ld.getTitle()%>"></td>
      <td><input name=url value="<%=ld.getUrl()%>" size="30"></td>
      <td>
        <input name="filename" type="file" style="width: 200px">
		</td>
      <td>
	  [ <a href="javascript:form<%=i%>.submit()"><lt:Label key="op_edit"/></a> ] [ <a onClick="if (!confirm('<lt:Label key="confirm_del"/>')) return false" href="?op=del&id=<%=ld.getId()%>&kind=<%=kind%>&userName=<%=StrUtil.UrlEncode(userName)%>"><lt:Label key="op_del"/></a> ] [<a href="?op=move&direction=up&id=<%=ld.getId()%>&userName=<%=StrUtil.UrlEncode(userName)%>"><lt:Label res="res.label.forum.admin.link" key="move_up"/></a>] [<a href="?op=move&direction=down&id=<%=ld.getId()%>&userName=<%=StrUtil.UrlEncode(userName)%>"><lt:Label res="res.label.forum.admin.link" key="move_down"/></a>] 
	  <input name="id" value="<%=ld.getId()%>" type="hidden">
	  <input name="userName" value="<%=userName%>" type="hidden">
	  <input name="kind" value="<%=kind%>" type="hidden">
	  </td>
	  </form>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td colspan="4" style="PADDING-LEFT: 10px">
	  <%if (ld.getImage()==null || ld.getImage().equals("")) {%>
	  <%}else{
	  	if (StrUtil.getFileExt(ld.getImage()).equals("swf")) {%>
			<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="88" height="31">
            <param name="movie" value="<%=ld.getImageUrl(request)%>">
            <param name="quality" value="high">
            <embed src="<%=ld.getImageUrl(request)%>" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="88" height="31"></embed>
            </object>
		<%}else{%>
		  <img src="<%=ld.getImageUrl(request)%>" width="88" height="31">
	  <%}
	  }%>
	  </td>
    </tr>
<%}%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
	<form action="site_link.jsp?op=add&kind=<%=kind%>&userName=<%=userName%>" method="post" enctype="multipart/form-data" name="addform1">
      <td style="PADDING-LEFT: 10px">
	  &nbsp;<img src="../images/arrow.gif" align="absmiddle">
	  <input name=title value=""></td>
      <td><input name=url value="" size="30"></td>
      <td><span class="stable">
        <input type="file" name="filename" style="width: 200px">
      </span></td>
      <td><INPUT type=submit height=20 width=80 value="<lt:Label key="op_add"/>">
        <input name="userName" value="<%=userName%>" type="hidden">
        <input name="kind" value="<%=kind%>" type="hidden">
        </td>
	</form>
    </tr>
    <tr align="center" class="row" style="BACKGROUND-COLOR: #ffffff">
      <td colspan="4" style="PADDING-LEFT: 10px"><lt:Label res="res.label.forum.admin.link" key="howto_del"/></td>
    </tr>
  </tbody>
</table>
</body>
</html>