<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.ui.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.cloudwebsoft.framework.base.*" %>
<%@ page import="com.cloudwebsoft.framework.db.*" %>
<%@ page import="com.cloudwebsoft.framework.template.*" %>
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

int id = ParamUtil.getInt(request, "id");
TemplateDb td = new TemplateDb();
td = (TemplateDb)td.getQObjectDb(new Integer(id));

String op = ParamUtil.get(request, "op");
if (op.equals("edit")) {
	String name = ParamUtil.get(request, "name");
	String author = ParamUtil.get(request, "author");
	String main_content = ParamUtil.get(request, "main_content");
	String sub_content = ParamUtil.get(request, "sub_content");
	String code = ParamUtil.get(request, "code");
	if (name.equals("")) {
		out.print(StrUtil.Alert_Back("名称不能为空！"));
		return;
	}
	if (main_content.equals("") || sub_content.equals("")) {
		out.print(StrUtil.Alert_Back("主模板及副模板不能为空！"));
		return;
	}
	int orders = ParamUtil.getInt(request, "orders", 1);
	String miniature = ParamUtil.get(request, "miniature");
	String common_content = ParamUtil.get(request, "common_content");
	String dir_code = "";
	if (td.save(new JdbcTemplate(), new Object[] {main_content,sub_content,new Integer(1),new Integer(1),dir_code,new java.util.Date(),author,miniature,new Integer(orders), code, common_content, name, new Integer(id)})) {
		// 刷新缓存
		TemplateLoader.refreshTemplate(td.getCacheKey(TemplateDb.TEMPL_TYPE_MAIN));
		TemplateLoader.refreshTemplate(td.getCacheKey(TemplateDb.TEMPL_TYPE_SUB));
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "template_edit.jsp?id=" + id));
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
  <form name="form1" action="?op=edit" method="post">
    <tr>
      <td colspan="3" noWrap class="thead" style="PADDING-LEFT: 10px">编辑模板</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">编码</td>
      <td colspan="2"><input name="code" size="20" value="<%=td.getString("code")%>"></td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td width="12%" style="PADDING-LEFT: 10px">名称</td>
      <td colspan="2"><input name="name" value="<%=td.getString("name")%>" size="50"></td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">作者</td>
      <td width="18%"><input name="author" value="<%=td.getString("author")%>">
	  <input name="id" type="hidden" value="<%=id%>">	  </td>
      <td width="70%">顺序号&nbsp;<input name="orders" value="<%=td.getInt("orders")%>"></td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">缩略图路径</td>
      <td colspan="2"><input name="miniature" value="<%=td.getString("miniature")%>" size="60">
相对于站点根的路径</td>
    </tr>
    
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">主模板</td>
      <td colspan="2">
<pre id="divMain" name="divMain" style="display:none">
<%=td.getString("main_content")%>
</pre>
<script type="text/javascript" src="../../FCKeditor/fckeditor.js"></script>
<script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'main_content' ) ;
oFCKeditor.BasePath = '../../FCKeditor/';
oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_forum.jsp' ;
oFCKeditor.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor.Width = "100%";
oFCKeditor.Height = 250 ;

oFCKeditor.Value = divMain.innerHTML;

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
oFCKeditor.Config["SkinPath"]="skins/office2003/";

oFCKeditor.Config["EditorAreaCSS"] = "<%=request.getContextPath() + "/blog/skin/" + td.getString("code") + "/skin.css"%>";

oFCKeditor.Create();
//-->
</script>	</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">副模板-文章</td>
      <td colspan="2">
<pre id="divSub" name="divSub" style="display:none">
<%=td.getString("sub_content")%>
</pre>	  
<script type="text/javascript">
<!--
oFCKeditor = new FCKeditor( 'sub_content' ) ;
oFCKeditor.BasePath = '../../FCKeditor/';
oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_forum.jsp' ;
oFCKeditor.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor.Width = "100%";
oFCKeditor.Height = 200 ;
oFCKeditor.Value = divSub.innerHTML;

oFCKeditor.Config["EnterMode"] = 'br' ;     // p | div | br （回车）
oFCKeditor.Config["ShiftEnterMode"] = 'p' ; // p | div | br（shift+enter)

oFCKeditor.Config["FormatOutput"]=false;
oFCKeditor.Config["FillEmptyBlocks"]=false;
oFCKeditor.Config["FormatIndentator"]=" ";
oFCKeditor.Config["FullPage"]=false;
oFCKeditor.Config["StartupFocus"]=false;
oFCKeditor.Config["EnableXHTML"]=false;
oFCKeditor.Config["FormatSource"]=false;
oFCKeditor.Config["SkinPath"] = "skins/office2003/";

oFCKeditor.Config["EditorAreaCSS"] = "<%=request.getContextPath() + "/blog/skin/" + td.getString("code") + "/skin.css"%>";

oFCKeditor.Create();
//-->
</script></td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">副模板-其它</td>
      <td colspan="2">
<pre id="divCommon" name="divCommon" style="display:none">
<%=StrUtil.getNullStr(td.getString("common_content"))%>
</pre>	  
<script type="text/javascript">
<!--
oFCKeditor = new FCKeditor( 'common_content' ) ;
oFCKeditor.BasePath = '../../FCKeditor/';
oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_forum.jsp' ;
oFCKeditor.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor.Width = "100%";
oFCKeditor.Height = 200 ;
oFCKeditor.Value = divCommon.innerHTML;

oFCKeditor.Config["EnterMode"] = 'br' ;     // p | div | br （回车）
oFCKeditor.Config["ShiftEnterMode"] = 'p' ; // p | div | br（shift+enter)

oFCKeditor.Config["FormatOutput"]=false;
oFCKeditor.Config["FillEmptyBlocks"]=false;
oFCKeditor.Config["FormatIndentator"]=" ";
oFCKeditor.Config["FullPage"]=false;
oFCKeditor.Config["StartupFocus"]=false;
oFCKeditor.Config["EnableXHTML"]=false;
oFCKeditor.Config["FormatSource"]=false;
oFCKeditor.Config["SkinPath"] = "skins/office2003/";

oFCKeditor.Config["EditorAreaCSS"] = "<%=request.getContextPath() + "/blog/skin/" + td.getString("code") + "/skin.css"%>";

oFCKeditor.Create();
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