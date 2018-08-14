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
	out.println(SkinUtil.makeErrMsg(request, privilege.MSG_INVALID));
	return;
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">管理模板 (排在首位的模板为默认模板) </td>
    </tr>
  </tbody>
</table>
<%
TemplateDb td = new TemplateDb();

int type_code = ParamUtil.getInt(request, "type_code");

String op = ParamUtil.get(request, "op");
if (op.equals("del")) {
	int id = ParamUtil.getInt(request, "id");
	td = (TemplateDb)td.getQObjectDb(new Integer(id));
	boolean re = td.del();
	if (re)
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "template_m.jsp?type_code=" + type_code));
	else
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));	
	return;
}

String sql = "select id from cms_template where type_code=" + type_code + " order by orders asc";

int total = (int)td.getQObjectCount(sql);

int pagesize = total; 	// 20;

int curpage,totalpages;
Paginator paginator = new Paginator(request, total, pagesize);
// 设置当前页数和总页数
totalpages = paginator.getTotalPages();
curpage	= paginator.getCurrentPage();
if (totalpages==0)
{
	curpage = 1;
	totalpages = 1;
}	

QObjectBlockIterator oir = td.getQObjects(sql, (curpage-1)*pagesize, curpage*pagesize);
%>
<br>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="98%" align="center">
  <tbody>
    <tr>
      <td class="thead" noWrap width="6%">序号</td>
      <td class="thead" noWrap width="25%">名称</td>
      <td class="thead" noWrap width="43%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">路径</td>
      <td width="26%" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15"><%=SkinUtil.LoadString(request,"op")%></td>
    </tr>
<%
Directory dir = new Directory();
while (oir.hasNext()) {
 	td = (TemplateDb)oir.next();
	%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td><%=td.getInt("orders")%></td>
      <td><%=td.getString("name")%></td>
      <td><%=td.getString("path")%></td>
      <td>
	  [<a href="template_modify.jsp?id=<%=td.getInt("id")%>">编辑</a>]&nbsp;[<a href="template_m.jsp?op=del&id=<%=td.getInt("id")%>&type_code=<%=type_code%>">删除</a>]&nbsp;[<a href="../<%=td.getString("path")%>" target="_blank">预览</a>]&nbsp;[<a href="template_page_edit.jsp?id=<%=td.getInt("id")%>" target="_blank">编辑模板</a>]</td>
    </tr>
<%}%>
  </tbody>
</table>
<HR noShade SIZE=1>
<DIV style="WIDTH: 95%" align=right>
  <INPUT 
onclick="javascript:location.href='template_add.jsp?type_code=<%=type_code%>';" type="button" value="<%=SkinUtil.LoadString(request,"op_add")%>">
</DIV>
</body>
</html>