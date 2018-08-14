<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.ui.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.cloudwebsoft.framework.base.*" %>
<%@ page import="com.cloudwebsoft.framework.db.*" %>
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
body {
	margin-left: 0px;
	margin-top: 0px;
}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String op = ParamUtil.get(request, "op");
if (op.equals("add")) {
	TemplateDb td = new TemplateDb();
	String name = ParamUtil.get(request, "name");
	String author = ParamUtil.get(request, "author");
	String main_content = ParamUtil.get(request, "main_content");
	String sub_content = ParamUtil.get(request, "sub_content");
	int orders = ParamUtil.getInt(request, "orders", 1);
	String code = ParamUtil.get(request, "code");
	if (name.equals("")) {
		out.print(StrUtil.Alert_Back("名称不能为空！"));
		return;
	}
	if (main_content.equals("") || sub_content.equals("")) {
		out.print(StrUtil.Alert_Back("主模板及副模板不能为空！"));
		return;
	}
	String miniature = ParamUtil.get(request, "miniature");
	String common_content = ParamUtil.get(request, "common_content");
	
	String dir_code = "";
	if (td.create(new JdbcTemplate(), new Object[] {new Long(SequenceMgr.nextID(SequenceMgr.PLUGIN_BLOG_TEMPLATE)), name,new Integer(0),main_content,sub_content,new Integer(1),dir_code,new java.util.Date(),author,miniature,new Integer(orders),code,common_content})) {
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "template_list.jsp"));
		return;
	}
	else {
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
		return;
	}
}	
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">管理模板 <a href="template_list.jsp">模板列表</a></td>
    </tr>
  </tbody>
</table>
<br>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="95%" align="center">
  <tbody>
  <form name="form1" action="?op=add" method="post">
    <tr>
      <td colspan="3" noWrap class="thead" style="PADDING-LEFT: 10px">添加模板</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">编码</td>
      <td colspan="2"><input name="code" size="20"></td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td width="12%" style="PADDING-LEFT: 10px">名称</td>
      <td colspan="2"><input name="name" size="50"></td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">作者</td>
      <td width="22%"><input name="author"></td>
      <td width="66%">顺序号&nbsp;<input name=orders value="1"></td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">缩略图路径</td>
      <td colspan="2"><input name="orders" size="60">
相对于站点根的路径</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">主模板</td>
      <td colspan="2">
<script type="text/javascript" src="../../FCKeditor/fckeditor.js"></script>
<script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'main_content' ) ;
oFCKeditor.BasePath = '../../FCKeditor/';
oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_forum.jsp' ;
oFCKeditor.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor.Width = "100%";
oFCKeditor.Height = 250 ;

// 解决自动首尾加<p></p>的问题
oFCKeditor.Config["EnterMode"] = 'br' ;     // p | div | br （回车）
oFCKeditor.Config["ShiftEnterMode"] = 'p' ; // p | div | br（shift+enter)

oFCKeditor.Config["FormatOutput"]=false;
oFCKeditor.Config["FillEmptyBlocks"]=false;
oFCKeditor.Config["FormatIndentator"]=" ";
oFCKeditor.Config["FullPage"]=false;
oFCKeditor.Config["StartupFocus"]=true;
oFCKeditor.Config["EnableXHTML"]=false;
oFCKeditor.Config["FormatSource"]=false;
oFCKeditor.Config["SkinPath"] = "skins/office2003/";

oFCKeditor.Create() ;
//-->
</script>	  </td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">副模板-文章</td>
      <td colspan="2">
<script type="text/javascript">
<!--
oFCKeditor = new FCKeditor( 'sub_content' ) ;
oFCKeditor.BasePath = '../../FCKeditor/';
oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_forum.jsp' ;
oFCKeditor.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor.Width = "100%";
oFCKeditor.Height = 150 ;

// 解决自动首尾加<p></p>的问题
oFCKeditor.Config["EnterMode"] = 'br' ;     // p | div | br （回车）
oFCKeditor.Config["ShiftEnterMode"] = 'p' ; // p | div | br（shift+enter)

oFCKeditor.Config["FormatOutput"]=false;
oFCKeditor.Config["FillEmptyBlocks"]=false;
oFCKeditor.Config["FormatIndentator"]=" ";
oFCKeditor.Config["FullPage"]=false;
oFCKeditor.Config["StartupFocus"]=true;
oFCKeditor.Config["EnableXHTML"]=false;
oFCKeditor.Config["FormatSource"]=false;
oFCKeditor.Config["SkinPath"] = "skins/office2003/";

oFCKeditor.Create() ;
//-->
</script>	  </td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">副模板-其它</td>
      <td colspan="2">
<script type="text/javascript">
<!--
oFCKeditor = new FCKeditor( 'common_content' ) ;
oFCKeditor.BasePath = '../../FCKeditor/';
oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_forum.jsp' ;
oFCKeditor.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor.Width = "100%";
oFCKeditor.Height = 150 ;

// 解决自动首尾加<p></p>的问题
oFCKeditor.Config["EnterMode"] = 'br' ;     // p | div | br （回车）
oFCKeditor.Config["ShiftEnterMode"] = 'p' ; // p | div | br（shift+enter)

oFCKeditor.Config["FormatOutput"]=false;
oFCKeditor.Config["FillEmptyBlocks"]=false;
oFCKeditor.Config["FormatIndentator"]=" ";
oFCKeditor.Config["FullPage"]=false;
oFCKeditor.Config["StartupFocus"]=true;
oFCKeditor.Config["EnableXHTML"]=false;
oFCKeditor.Config["FormatSource"]=false;
oFCKeditor.Config["SkinPath"] = "skins/office2003/";

oFCKeditor.Create() ;
//-->
</script>	  </td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">&nbsp;</td>
      <td colspan="2"><input type="submit" value="确定">
        &nbsp;&nbsp;&nbsp;
        <input type="reset" value="重置"></td>
    </tr>
	</form>
</table>
<DIV style="WIDTH: 95%" align=right></DIV>
</body>
</html>