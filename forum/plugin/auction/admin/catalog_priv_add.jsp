<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="cn.js.fan.web.*"%>
<html>
<head>
<title>管理登录</title>
<link href="../../../../common.css" rel="stylesheet" type="text/css">
<link href="../manager/default.css" rel="stylesheet" type="text/css">
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
	margin-right: 0px;
}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String dirCode = ParamUtil.get(request, "dirCode");
Leaf leaf = new Leaf();
leaf = leaf.getLeaf(dirCode);
%>

<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">设置目录 <%=leaf.getName()%> 权限</td>
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
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="26%">名称</td>
      <td class="thead" noWrap width="40%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">描述</td>
      <td width="34%" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">操作</td>
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
	  <a href="catalog_priv_m.jsp?op=add&dirCode=<%=StrUtil.UrlEncode(leaf.getCode())%>&name=<%=StrUtil.UrlEncode(code)%>&type=0">[ 添加 ]</a></td>
    </tr>
<%}%>
  </tbody>
</table>
<br>
<table width="331"  border="0" align="center" cellpadding="0" cellspacing="0"  style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">
  <tr>
    <td width="329" class="thead">添加用户</td>
  </tr>
  <form action="catalog_priv_m.jsp?op=add" method=post>
  <tr>
    <td height="25" align="center">
	用户名：
	  <input name="name" value=""><input type=hidden name=type value=1>
	  <input type=hidden name=dirCode value="<%=leaf.getCode()%>">
	  &nbsp;
	<INPUT type=image 
onclick="javascript:location.href='user_group_op.jsp';" src="images/btn_add.gif" align="middle" width=80 
height=20></td>
  </tr></form>
</table>
</body>
<script language="javascript">
<!--
function form1_onsubmit()
{
	errmsg = "";
	if (form1.pwd.value!=form1.pwd_confirm.value)
		errmsg += "密码与确认密码不致，请检查！\n"
	if (errmsg!="")
	{
		alert(errmsg);
		return false;
	}
}
//-->
</script>
</html>