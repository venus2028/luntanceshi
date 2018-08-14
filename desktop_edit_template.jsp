<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="cn.js.fan.module.cms.Config"%>
<%@ page import="cn.js.fan.util.file.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.cloudwebsoft.framework.template.TemplateLoader" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="pragma" content="no-cache">
<LINK href="cms/default.css" type=text/css rel=stylesheet>
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>首页模板管理</title>
<style>
.btn {
border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;
}
</style>
<script language="JavaScript">
<!--
function openWin(url,width,height)
{
	var newwin = window.open(url,"_blank","scrollbars=yes,resizable=yes,toolbar=no,location=no,directories=no,status=no,menubar=no,top=50,left=120,width="+width+",height="+height);
}

function formFck_onsubmit() {
	var oEditor = FCKeditorAPI.GetInstance('FCKeditor1') ;
	var htmlcode = oEditor.GetXHTML( true );
	formFck.content.value = htmlcode;
}
//-->
</script>
<body bgcolor="#FFFFFF" topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, "admin"))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String op = ParamUtil.get(request, "op");

String filePath = Global.realPath + "template/index.htm";
if (op.equals("edit")) {
	String content = ParamUtil.get(request, "content");
	content = com.cloudwebsoft.framework.template.TemplateUtil.format(content);
	FileUtil.WriteFileUTF8(filePath, content);
	out.print(StrUtil.Alert_Redirect("操作成功！", "desktop_edit_template.jsp"));
	return;
}

if (op.equals("createHtml")) {
	TemplateLoader tl = new TemplateLoader(request, filePath);
    Config cfg = new Config();	
    FileUtil.WriteFile(Global.getRealPath() +
                  "index." + cfg.getProperty("cms.html_ext"),
                 tl.toString(), "UTF-8");
	out.print(StrUtil.Alert_Redirect("操作成功！", "desktop_edit_template.jsp"));	
	return;			 
}
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">编辑首页模板 (首页模板位置：template/index.htm，可以手工编辑该文件) [<a href="desktop_edit_template.jsp?op=createHtml">生成首页</a>]&nbsp;
	<%
	cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
	%>	
	[<a href="index.<%=cfg.getProperty("cms.html_ext")%>" target="_blank">查看首页</a>]</td>
  </tr>
</table>
<table width="100%" align="center">
  <form id=formFck name=formFck action="?op=edit" method=post onSubmit="return formFck_onsubmit()">
    <tr>
      <td height="22">
<%
String s = FileUtil.ReadFile(filePath);
%>
<textarea id="content" name="content" style="display:none" rows="50" cols="200"><%=s%></textarea>

<script type="text/javascript" src="FCKeditor/fckeditor.js"></script>
<script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'FCKeditor1' ) ;
oFCKeditor.BasePath = 'FCKeditor/';
oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_forum.jsp' ;
// oFCKeditor.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor.Width = "100%";
oFCKeditor.Height = 555 ;
oFCKeditor.Value = formFck.content.value;

// oFCKeditor.Config["BaseHref"]="<%=cn.js.fan.web.Global.getRootPath()%>/";
oFCKeditor.Config["FormatOutput"]=false;
oFCKeditor.Config["FormatSource"]=false;
oFCKeditor.Config["FillEmptyBlocks"]=false;
oFCKeditor.Config["FormatIndentator"]="";
oFCKeditor.Config["FullPage"]=true;
oFCKeditor.Config["StartupFocus"]=true;
oFCKeditor.Config["EnableXHTML"]=false;
// oFCKeditor.Config["ProtectedTags"]='\r\n<!--';

oFCKeditor.Config["LinkBrowser"]=false;//文件
oFCKeditor.Config["ImageBrowser"]=true;
oFCKeditor.Config["FlashBrowser"]=true;

oFCKeditor.Config["LinkUpload"]=false;
oFCKeditor.Config["ImageUpload"]=false;
oFCKeditor.Config["FlashUpload"]=false;

oFCKeditor.Config["SkinPath"] = "skins/<%=cfg.getProperty("cms.fckeditorSkin")%>/";

oFCKeditor.Create() ;

// formFck.content.value = "";
//-->
  </script> 
  </td>
    </tr>
    <tr>
      <td height="22" align="center"><input name="submit2" type="submit" value="确 定">
      &nbsp;&nbsp;&nbsp;&nbsp;
      <input name="submit22" type="button" value="预 览" onClick="window.open('index.jsp')"></td>
    </tr>
  </form>
</table>
</body>                                        
</html>                            
  