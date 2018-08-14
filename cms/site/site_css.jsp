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
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">模板/CSS管理(<a href="help_site_tag.jsp" target="_blank">模板标签说明</a>)</td>
    </tr>
  </tbody>
</table>
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

SiteUserTemplateDb sutd = new SiteUserTemplateDb();
sutd = sutd.getSiteUserTemplateDb(siteCode);
if (op.equals("editTemplate")) {
	String main_content = ParamUtil.get(request, "main_content");
	sutd.set("main_content", main_content);
	if (sutd.save()) {
		// 刷新缓存
		TemplateLoader.refreshTemplate(SiteUserTemplateDb.getTemplateCacheKey(sd, SiteTemplateDb.TEMPL_TYPE_MAIN));
		out.print(StrUtil.Alert_Redirect("操作成功！", "site_css.jsp?siteCode=" + siteCode));
	}
	else {
		out.print(StrUtil.Alert_Redirect("操作失败！", "site_css.jsp?siteCode=" + siteCode));
	}
	return;
}
if (op.equals("resumeTemplate")) {
	// 重建模板
	if (sutd.resumeAll()) {
		out.print(StrUtil.Alert_Redirect("操作成功！", "site_css.jsp?siteCode=" + siteCode));
	}
	else {
		out.print(StrUtil.Alert_Redirect("操作失败！", "site_css.jsp?siteCode=" + siteCode));
	}
	return;
}

if (op.equals("resumeContent")) {
	if (sutd.resume("main_content")) {
		out.print(StrUtil.Alert_Redirect("操作成功！", "site_css.jsp?siteCode=" + siteCode));
	}
	else {
		out.print(StrUtil.Alert_Redirect("操作失败！", "site_css.jsp?siteCode=" + siteCode));
	}
	return;
}
%>
<br>
<script type="text/javascript" src="../../inc/ajaxtabs/ajaxtabs.jsp"></script><br>
<div id="tabMenu" class="tabMenuCss">
  <div class="tabMenuBar">
    <ul id="tabItems" class="tabMenuItemsCss">
      <li class="selected"><a href="#default" rel="contentArea">主模板</a></li>
      <li><a href="../iframe.jsp?url=<%=StrUtil.UrlEncode("site_template_edit.jsp?siteCode=" + siteCode + "&contentType=home_content")%>" rel="contentArea">副模板-首页</a></li>
      <li><a href="../iframe.jsp?url=<%=StrUtil.UrlEncode("site_template_edit.jsp?siteCode=" + siteCode + "&contentType=list_content")%>" rel="contentArea">副模板-列表</a></li>
      <li><a href="../iframe.jsp?url=<%=StrUtil.UrlEncode("site_template_edit.jsp?siteCode=" + siteCode + "&contentType=doc_content")%>" rel="contentArea">副模板-文章</a></li>
      <li><a href="../iframe.jsp?url=site_css_edit.jsp?siteCode=<%=siteCode%>" rel="contentArea">CSS</a></li>
    </ul>
    <div class="clear"></div>
  </div>
<div id="contentArea" class="tabContentAreaCss">
  <table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="100%" align="center">
    <tbody>
    <form name="form1" action="?op=editTemplate" method="post">
      <tr>
        <td align="center" noWrap class="thead" style="PADDING-LEFT: 10px">编辑模板&nbsp;</td>
      </tr>
      <tr class="row" style="BACKGROUND-COLOR: #ffffff">
        <td style="PADDING-LEFT: 10px" height=10><pre id="divMain" name="divMain" style="display:none">
<%=sutd.getString("main_content")%>
        </pre>
            <script type="text/javascript" src="../../FCKeditor/fckeditor.js"></script>
            <script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'main_content' ) ;
oFCKeditor.BasePath = '../../FCKeditor/';
oFCKeditor.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor.Width = "100%";
oFCKeditor.Height = 420;
oFCKeditor.Value = divMain.innerHTML;
oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_cms.jsp' ;

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

oFCKeditor.Config["EditorAreaCSS"] = "<%=sd.getUserDefinedCSSUrl(request)%>";

oFCKeditor.Create();
//-->
            </script>
	        <textarea name="home_content" style="display:none"><%=sutd.getString("home_content")%></textarea>
	        <textarea name="list_content" style="display:none"><%=sutd.getString("list_content")%></textarea>
	        <textarea name="doc_content" style="display:none"><%=sutd.getString("doc_content")%></textarea></td>
        </tr>
      <tr class="row" style="BACKGROUND-COLOR: #ffffff">
        <td align="center" style="PADDING-LEFT: 10px"><input name="submit" type="submit" value=" 确定 ">
&nbsp;
<input name="reset2" type="button" value="恢复主模板" onClick="window.location.href='site_css.jsp?op=resumeContent&siteCode=<%=siteCode%>'">
&nbsp;&nbsp;
<input name="reset" type="button" value="主副模板都恢复为原始模板" onClick="window.location.href='site_css.jsp?op=resumeTemplate&siteCode=<%=siteCode%>'">
          <input name="siteCode" value="<%=siteCode%>" type="hidden">        </td>
        </tr>
    </form>
  </table>
</div>
<script type="text/javascript">
//Start Ajax tabs script for UL with id="tabItems" Separate multiple ids each with a comma.
startajaxtabs("tabItems")
</script>
</div>
</body>
</html>