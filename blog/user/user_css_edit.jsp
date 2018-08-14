<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.net.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.file.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.blog.ui.*"%>
<%@ page import="com.redmoon.blog.template.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*" %>
<%@ page import="com.cloudwebsoft.framework.template.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<html>
<head>
<title><lt:Label res="res.label.blog.user.photo" key="title"/></title>
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
.STYLE5 {color: #FFFFFF}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<%
long blogId = ParamUtil.getLong(request, "blogId");

UserConfigDb ucd = new UserConfigDb();
ucd = ucd.getUserConfigDb(blogId);

String user = Privilege.getUser(request);

// 检查用户权限
if (!Privilege.canUserDo(request, blogId, Privilege.PRIV_ALL)) {
	out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, SkinUtil.PVG_INVALID)));
	return;
}

String css = ucd.getCSSContent(request);

String op = ParamUtil.get(request, "op");
if (op.equals("edit")) {
	ucd.modifyCSSFile(request);
	out.print(StrUtil.Alert_Redirect("操作成功！", "user_css_edit.jsp?blogId=" + blogId));
	return;
}
if (op.equals("resume")) {
	ucd.createDefaultCSSFile(request);
	out.print(StrUtil.Alert_Redirect("操作成功！", "user_css_edit.jsp?blogId=" + blogId));
	return;
}
%>
<table width="100%" border="0" align="center" cellpadding="3" cellspacing="0" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">
<form action="?op=edit&blogId=<%=blogId%>" method="post" name="addform1">
  <tr>
    <td width="88%" height="24" align="center">
	<textarea name="content" cols="120" rows="30" style="height:420px"><%=StrUtil.HtmlEncode(css)%></textarea>	</td>
  </tr>
  <tr>
    <td align="center"><input type=submit value="<lt:Label key="ok"/>" width=80 height=20>
      &nbsp;&nbsp;
      <input type=button value="恢复为原始文件" width=80 height=20 onClick="window.location.href='user_css_edit.jsp?op=resume&blogId=<%=blogId%>'"></td>
  </tr></form>
</table>
</body>
</html>