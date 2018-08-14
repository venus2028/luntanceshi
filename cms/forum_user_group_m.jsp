<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.forum.admin.user_group_m" key="user_group_manage"/></title>
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}
body {
	margin-left: 0px;
	margin-top: 0px;
}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="usergroupmgr" scope="page" class="com.redmoon.forum.person.UserGroupMgr"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head"><lt:Label res="res.label.forum.admin.user_group_m" key="user_group_manage"/></td>
    </tr>
  </tbody>
</table>
<%
if (!privilege.isMasterLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String code;
String desc;
UserGroupDb ugroup = new UserGroupDb();
Vector result = ugroup.list();
Iterator ir = result.iterator();
%>
<br>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="95%" align="center">
  <tbody>
    <tr>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="21%"><lt:Label res="res.label.forum.admin.user_group_m" key="code"/></td>
      <td class="thead" noWrap width="17%"><img src="images/tl.gif" align="absMiddle" width="10" height="15"><lt:Label res="res.label.forum.admin.user_group_m" key="desc"/></td>
      <td class="thead" noWrap width="14%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
      <lt:Label res="res.label.forum.admin.user_group_m" key="display_order"/></td>
      <td class="thead" noWrap width="29%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
      <lt:Label res="res.label.forum.admin.user_group_m" key="system"/></td><td width="19%" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
        <lt:Label key="op"/></td>
    </tr>
<tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">&nbsp;<img src="images/arrow.gif" align="absmiddle">&nbsp;<%=UserGroupDb.ALL%></td>
      <td>全部用户</td>
      <td>&nbsp;</td>
      <td>是</td>
      <td>[ <a href="forum_user_group_priv_frame.jsp?groupCode=<%=UserGroupDb.ALL%>" target="_blank">权限</a> ] </td>
    </tr>    
<%
while (ir.hasNext()) {
 	UserGroupDb ug = (UserGroupDb)ir.next();
	code = ug.getCode();
	desc = ug.getDesc();
	%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">&nbsp;<img src="images/arrow.gif" align="absmiddle">&nbsp;<a href="../forum/admin/user_group_op.jsp?op=edit&code=<%=StrUtil.UrlEncode(code)%>"><%=code%></a></td>
      <td><%=desc%></td>
      <td><%=ug.getDisplayOrder()%></td>
      <td><%=ug.isSystem()?SkinUtil.LoadString(request, "yes"):SkinUtil.LoadString(request, "no")%></td>
      <td>[ <a href="forum_user_group_priv_frame.jsp?groupCode=<%=StrUtil.UrlEncode(code)%>" target="_blank">权限</a> ] </td>
    </tr>
<%}%>
  </tbody>
</table>
</body>
</html>