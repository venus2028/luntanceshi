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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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

String op = ParamUtil.get(request, "op");

BlogUserTemplateDb but = new BlogUserTemplateDb();
but = but.getBlogUserTemplateDb(blogId);
if (op.equals("editTemplate")) {
	String main_content = ParamUtil.get(request, "main_content");
	but.set("main_content", main_content);
	if (but.save()) {
		// 刷新缓存
		TemplateLoader.refreshTemplate(BlogUserTemplateDb.getTemplateCacheKey(ucd, TemplateDb.TEMPL_TYPE_MAIN));
		out.print(StrUtil.Alert_Redirect("操作成功！", "usercss.jsp?blogId=" + blogId));
	}
	else {
		out.print(StrUtil.Alert_Redirect("操作失败！", "usercss.jsp?blogId=" + blogId));
	}
	return;
}
if (op.equals("resumeTemplate")) {
	// 删除自定义模板
	but.del();
	// 重建模板
	if (but.init(blogId)) {
		// 刷新缓存
		TemplateLoader.refreshTemplate(BlogUserTemplateDb.getTemplateCacheKey(ucd, TemplateDb.TEMPL_TYPE_MAIN));
		TemplateLoader.refreshTemplate(BlogUserTemplateDb.getTemplateCacheKey(ucd, TemplateDb.TEMPL_TYPE_SUB));		
		out.print(StrUtil.Alert_Redirect("操作成功！", "usercss.jsp?blogId=" + blogId));
	}
	else {
		out.print(StrUtil.Alert_Redirect("操作失败！", "usercss.jsp?blogId=" + blogId));
	}
	return;
}

if (op.equals("resumeContent")) {
	// 重建模板
	if (but.resumeContent("main_content")) {
		out.print(StrUtil.Alert_Redirect("操作成功！", "usercss.jsp?blogId=" + blogId));
	}
	else {
		out.print(StrUtil.Alert_Redirect("操作失败！", "usercss.jsp?blogId=" + blogId));
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
      <li><a href="../../cms/iframe.jsp?url=<%=Global.getRootPath()%>/blog/user/<%=StrUtil.UrlEncode("template_edit.jsp?&contentType=sub_content&blogId=" + blogId)%>" rel="contentArea">副模板-文章</a></li>
      <li><a href="../../cms/iframe.jsp?url=<%=Global.getRootPath()%>/blog/user/<%=StrUtil.UrlEncode("template_edit.jsp?&contentType=common_content&blogId=" + blogId)%>" rel="contentArea">副模板-其它</a></li>
      <li><a href="../../cms/iframe.jsp?url=<%=Global.getRootPath()%>/blog/user/user_css_edit.jsp?blogId=<%=blogId%>" rel="contentArea">CSS</a></li>
    </ul>
    <div class="clear"></div>
  </div>
  <div id="contentArea" class="tabContentAreaCss">
    <table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="100%" align="center">
      <tbody>
      <form name="form1" action="?op=editTemplate" method="post">
        <tr class="row" style="BACKGROUND-COLOR: #ffffff">
          <td width="88%" height="22" colspan="2"><pre id="divMain" name="divMain" style="display:none">
<%=but.getString("main_content")%>
    </pre>
              <script type="text/javascript" src="../../FCKeditor/fckeditor.js"></script>
              <script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'main_content' ) ;
oFCKeditor.BasePath = '../../FCKeditor/';
oFCKeditor.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor.Width = "100%";
oFCKeditor.Height = 450;
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

oFCKeditor.Config["EditorAreaCSS"] = "<%=ucd.getUserDefinedCSSUrl(request)%>";

oFCKeditor.Create();
//-->
      </script>          </td>
        </tr>
        
        <tr class="row" style="BACKGROUND-COLOR: #ffffff">
          <td colspan="2" align="center"><input name="submit" type="submit" value="确定">
            &nbsp;<span style="PADDING-LEFT: 10px">
              <input name="reset22" type="button" value="恢复主模板" onClick="window.location.href='usercss.jsp?op=resumeContent&blogId=<%=blogId%>'">
              </span>&nbsp;&nbsp;
            <input name="reset" type="button" value="恢复主副模板为原始模板" onClick="window.location.href='usercss.jsp?op=resumeTemplate&blogId=<%=blogId%>'">
            <input name="blogId" value="<%=blogId%>" type="hidden">          (<a href="help_blog_tag.jsp" target="_blank">模板标签说明</a>)</td>
        </tr>
      </form>
    </table>
  </div>
<script type="text/javascript">
startajaxtabs("tabItems")
</script>
</div>
<br>
</body>
</html>