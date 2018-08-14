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

String contentType = ParamUtil.get(request, "contentType");
String[] contentAry = new String[] {"main_content", "home_content", "list_content", "doc_content"};

SiteUserTemplateDb sutd = new SiteUserTemplateDb();
sutd = sutd.getSiteUserTemplateDb(siteCode);
if (op.equals("editTemplate")) {
	String content = ParamUtil.get(request, "content");
	sutd.set(contentType, content);
	if (sutd.save()) {
		// 刷新缓存
		if (contentType.equals("main_content")) {
			TemplateLoader.refreshTemplate(SiteUserTemplateDb.getTemplateCacheKey(sd,SiteTemplateDb.TEMPL_TYPE_MAIN));
		} else if (contentType.equals("home_content")) {
			TemplateLoader.refreshTemplate(SiteUserTemplateDb.
										   getTemplateCacheKey(sd,SiteTemplateDb.TEMPL_TYPE_HOME));
		} else if (contentType.equals("list_content")) {
			TemplateLoader.refreshTemplate(SiteUserTemplateDb.
										   getTemplateCacheKey(sd,SiteTemplateDb.TEMPL_TYPE_LIST));
		} else if (contentType.equals("doc_content")) {
			TemplateLoader.refreshTemplate(SiteUserTemplateDb.
										   getTemplateCacheKey(sd,SiteTemplateDb.TEMPL_TYPE_DOC));
		}
		out.print(StrUtil.Alert_Redirect("操作成功！", "site_template_edit.jsp?siteCode=" + siteCode + "&contentType=" + contentType));
	}
	else {
		out.print(StrUtil.Alert_Redirect("操作失败！", "site_template_edit.jsp?siteCode=" + siteCode + "&contentType=" + contentType));
	}
	return;
}
if (op.equals("resumeContent")) {
	if (sutd.resume(contentType)) {
		out.print(StrUtil.Alert_Redirect("操作成功！", "site_template_edit.jsp?contentType=" + contentType + "&siteCode=" + siteCode));
	}
	else {
		out.print(StrUtil.Alert_Redirect("操作失败！", "site_template_edit.jsp?contentType=" + contentType + "&siteCode=" + siteCode));
	}
	return;
}
%>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="100%" align="center">
  <tbody>
  <form name="form1" action="?op=editTemplate" method="post">
    <tr>
      <td colspan="2" align="center" noWrap class="thead" style="PADDING-LEFT: 10px">编辑模板&nbsp;</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td width="88%" colspan="2"><pre id="divMain" name="divMain" style="display:none">
<%=sutd.getString(contentType)%>
  </pre>
          <script type="text/javascript" src="../../FCKeditor/fckeditor.js"></script>
          <script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'content' ) ;
oFCKeditor.BasePath = '../../FCKeditor/';
oFCKeditor.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor.Width = "100%";
oFCKeditor.Height = 400;
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
          <%
int len = contentAry.length;
for(int i=0; i<len; i++) {
	if (!contentAry[i].equals(contentType)) {
%>
          <textarea name="<%=contentAry[i]%>" style="display:none"><%=sutd.getString(contentAry[i])%></textarea>
          <%	
	}
}
%></td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td colspan="2" align="center"><input name="submit" type="submit" value="确定">
        &nbsp;&nbsp;<span style="PADDING-LEFT: 10px">
        <input name="reset2" type="button" value="恢复" onClick="window.location.href='site_template_edit.jsp?op=resumeContent&contentType=<%=contentType%>&siteCode=<%=siteCode%>'">
        </span>&nbsp;
        <input name="siteCode" value="<%=siteCode%>" type="hidden">
        <input name="contentType" value="<%=contentType%>" type="hidden">
      </td>
    </tr>
  </form>
</table>
</body>
</html>