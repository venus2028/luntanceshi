<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="com.cloudwebsoft.framework.base.*" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.cms.priv_m" key="mgr_login"/></title>
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
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, PrivDb.PRIV_ADMIN)) {
	out.println(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

int type_code = ParamUtil.getInt(request, "type_code");

String op = ParamUtil.get(request, "op");
if (op.equals("add")) {
	QObjectMgr qom = new QObjectMgr();
	TemplateDb td = new TemplateDb();
	try {
		if (qom.create(request, td, "cms_template_create")) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "template_m.jsp?type_code=" + type_code));
			return;
		}
		else {
			out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
			return;
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
}	
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">管理模板 <a href="template_m.jsp?type_code=<%=type_code%>">模板列表</a></td>
    </tr>
  </tbody>
</table>
<br>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="95%" align="center">
  <tbody>
  <form name="form1" action="?op=add" method="post">
    <tr>
      <td colspan="2" noWrap class="thead" style="PADDING-LEFT: 10px">添加模板</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td width="12%" style="PADDING-LEFT: 10px">名称</td>
      <td width="88%"><input name="name"></td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">路径</td>
      <td><input name="path" size="50">
	  <input name="type_code" value="<%=type_code%>" type="hidden">	  </td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">序号</td>
      <td><input name="orders" value="1"></td>
    </tr>
    
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">&nbsp;</td>
      <td><input type="submit" value="确定">
        &nbsp;&nbsp;&nbsp;
        <input type="reset" value="重置"></td>
    </tr>
	</form>
</table>
<DIV style="WIDTH: 95%" align=right></DIV>
</body>
</html>