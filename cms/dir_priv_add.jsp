<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>添加目录权限</title>
<link href="../common.css" rel="stylesheet" type="text/css">
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
<script src="../inc/common.js"></script>
<script>
function selPerson(userNames) {
	form1.name.value = userNames;
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="usergroupmgr" scope="page" class="cn.js.fan.module.pvg.UserGroupMgr"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
String dirCode = ParamUtil.get(request, "dirCode");
Leaf leaf = new Leaf();
leaf = leaf.getLeaf(dirCode);
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head"><lt:Label res="res.label.cms.dir" key="config_content"/> <a href="dir_priv_m.jsp?dirCode=<%=StrUtil.UrlEncode(dirCode)%>"><%=leaf.getName()%></a> <lt:Label res="res.label.cms.dir" key="pvg"/></td>
    </tr>
  </tbody>
</table>
<%
String code;
String desc;
UserGroup ugroup = new UserGroup();
Vector result = ugroup.list();
Iterator ir = result.iterator();
%>
<br>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="95%" align="center">
  <tbody>
    <tr>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="26%"><lt:Label res="res.label.cms.dir" key="group_name"/></td>
      <td class="thead" noWrap width="40%"><img src="images/tl.gif" align="absMiddle" width="10" height="15"><lt:Label res="res.label.cms.dir" key="desc"/></td>
      <td width="34%" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15"><lt:Label res="res.label.cms.dir" key="oper"/></td>
    </tr>
<%
while (ir.hasNext()) {
 	UserGroup ug = (UserGroup)ir.next();
	code = ug.getCode();
	desc = ug.getDesc();
	%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">&nbsp;<img src="images/arrow.gif" align="absmiddle">&nbsp;<%=code%></td>
      <td><%=desc%></td>
      <td>
	  <a href="dir_priv_m.jsp?op=add&dirCode=<%=StrUtil.UrlEncode(leaf.getCode())%>&name=<%=StrUtil.UrlEncode(code)%>&type=0">[ <lt:Label res="res.label.cms.dir" key="add"/> ]</a></td>
    </tr>
<%}%>
  </tbody>
</table>
<br>
<table width="331"  border="0" align="center" cellpadding="0" cellspacing="0"  style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">
  <tr>
    <td width="329" class="thead"><lt:Label res="res.label.cms.dir" key="add_user"/></td>
  </tr>
  <form id="form1" name="form1" action="dir_priv_m.jsp?op=add" method=post>
  <tr>
    <td height="25" align="center">
	<lt:Label res="res.label.cms.dir" key="user_name"/>
	  <input name="name" value=""><input type=hidden name=type value=1>
	  <input type=hidden name=dirCode value="<%=leaf.getCode()%>">
	  &nbsp;<input type="button" onClick="openWin('user_sel.jsp', 640, 420)" value="选择" />&nbsp;
	  <input name="button" type="submit" onClick="javascript:location.href='user_group_op.jsp';" value="<%=SkinUtil.LoadString(request, "res.label.cms.dir","subbmit")%>"></td>
  </tr></form>
</table>
</body>
<script language="javascript">
<!--
function form1_onsubmit()
{
	errmsg = "";
	if (form1.pwd.value!=form1.pwd_confirm.value)
		errmsg += "<lt:Label res="res.label.cms.dir" key="msg_check"/>\n"
	if (errmsg!="")
	{
		alert(errmsg);
		return false;
	}
}
//-->
</script>
</html>