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

TemplateCatalogDb tcd = new TemplateCatalogDb();

String op = ParamUtil.get(request, "op");
if (op.equals("del")) {
	String code = ParamUtil.get(request, "code");
	tcd = (TemplateCatalogDb)tcd.getTemplateCatalogDb(code);
	boolean re = tcd.del();
	if (re)
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "template_catalog_list.jsp"));
	else
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
	return;
}

%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">管理模板组 (排在首位的模板组为默认组) </td>
    </tr>
  </tbody>
</table>
<%
String sql = "select code from cms_template_catalog order by orders asc";

int total = (int)tcd.getQObjectCount(sql);

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

QObjectBlockIterator oir = tcd.getQObjects(sql, (curpage-1)*pagesize, curpage*pagesize);

sql = "select id from cms_template where type_code=" + TemplateDb.TYPE_CODE_COLUMN + " order by orders asc";
TemplateDb td = new TemplateDb();
java.util.Iterator ir = td.list(sql).iterator();
String opts_column = "";
while (ir.hasNext()) {
	td = (TemplateDb)ir.next();
	opts_column += "<option value='" + td.getInt("id") + "'>" + td.getString("name") + "</option>";
}

sql = "select id from cms_template where type_code=" + TemplateDb.TYPE_CODE_LIST + " order by orders asc";
ir = td.list(sql).iterator();
String opts_list = "";
while (ir.hasNext()) {
	td = (TemplateDb)ir.next();
	opts_list += "<option value='" + td.getInt("id") + "'>" + td.getString("name") + "</option>";
}

sql = "select id from cms_template where type_code=" + TemplateDb.TYPE_CODE_DOC + " order by orders asc";
ir = td.list(sql).iterator();
String opts_doc = "";
while (ir.hasNext()) {
	td = (TemplateDb)ir.next();
	opts_doc += "<option value='" + td.getInt("id") + "'>" + td.getString("name") + "</option>";
}
%>
<br>
<DIV style="WIDTH: 95%" align=right>
  <INPUT name="button" type="button" 
onclick="javascript:location.href='template_catalog_add.jsp';" value="<%=SkinUtil.LoadString(request,"op_add")%>">
</DIV>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="98%" align="center">
    <tr>
      <td class="thead" noWrap width="6%">序号</td>
      <td class="thead" noWrap width="19%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">名称</td>
      <td class="thead" noWrap width="21%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">栏目模板</td>
      <td class="thead" noWrap width="21%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">列表模板</td>
      <td class="thead" noWrap width="21%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">文章模板</td>
      <td width="12%" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15"><%=SkinUtil.LoadString(request,"op")%></td>
    </tr>
<%
Directory dir = new Directory();
int k = 0;
while (oir.hasNext()) {
 	tcd = (TemplateCatalogDb)oir.next();
	%>
	<form name=form<%=k%>>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td><%=tcd.getInt("orders")%></td>
      <td><%=tcd.getString("name")%></td>
      <td><select name="doc_column" id="doc_column">
        <option value="-1">无</option>
        <%=opts_column%>
      </select>
<script>
form<%=k%>.doc_column.value = "<%=tcd.getString("doc_column")%>";
</script>	  
	  </td>
      <td><select name="doc_list">
        <option value="-1">无</option>
        <%=opts_list%>
      </select>
<script>
form<%=k%>.doc_list.value = "<%=tcd.getString("doc_list")%>";
</script>	  
	  </td>
      <td><select name="doc">
        <option value="-1">无</option>
        <%=opts_doc%>
      </select>
<script>
form<%=k%>.doc.value = "<%=tcd.getString("doc")%>";
</script>	  
	  </td>
      <td>
	  [<a href="template_catalog_modify.jsp?code=<%=tcd.getString("code")%>">编辑</a>]&nbsp;[<a href="#" onClick="if (confirm('您确定要删除吗？')) window.location.href='template_catalog_list.jsp?op=del&code=<%=StrUtil.UrlEncode(tcd.getString("code"))%>'">删除</a>]</td>
    </tr>
	</form>
<%
k++;
}%>
</table>
<HR noShade SIZE=1>
<DIV style="WIDTH: 95%" align=right>
  <INPUT 
onclick="javascript:location.href='template_catalog_add.jsp';" type="button" value="<%=SkinUtil.LoadString(request,"op_add")%>">
</DIV>
</body>
</html>