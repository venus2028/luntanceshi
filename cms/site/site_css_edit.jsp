<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.net.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.file.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*" %>
<%@ page import="com.cloudwebsoft.framework.template.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>管理子站点模板/CSS</title>
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
.STYLE5 {color: #FFFFFF}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<%
String siteCode = ParamUtil.get(request, "siteCode");

SiteDb sd = new SiteDb();
sd = sd.getSiteDb(siteCode);

// 检查用户权限
if (!SitePrivilege.canManage(request, sd)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String css = sd.getCSSContent(request);

String op = ParamUtil.get(request, "op");
if (op.equals("edit")) {
	sd.modifyCSSFile(request);
	out.print(StrUtil.Alert_Redirect("操作成功！", "site_css_edit.jsp?siteCode=" + siteCode));
	return;
}
if (op.equals("resume")) {
	sd.createDefaultCSSFile(request);
	out.print(StrUtil.Alert_Redirect("操作成功！", "site_css_edit.jsp?siteCode=" + siteCode));
	return;
}
%>
<table width="100%" height="100%" border="0" align="center" cellpadding="3" cellspacing="0" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">
<form action="?op=edit&siteCode=<%=siteCode%>" method="post" name="addform1">
  <tr>
    <td height="24" colspan="2" align="center" class="thead">修改CSS</td>
    </tr>
  <tr>
    <td width="12%" height="400">
      CSS</td>
    <td width="88%">
	<textarea name="content" cols="100" rows="26"><%=StrUtil.HtmlEncode(css)%></textarea>
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type=submit value=" <lt:Label key="ok"/> " width=80 height=20>
      &nbsp;&nbsp;
      <input type=button value="恢复为原始文件" width=80 height=20 onClick="window.location.href='site_css_edit.jsp?op=resume&siteCode=<%=siteCode%>'"></td>
  </tr></form>
</table>
<br>
</body>
</html>