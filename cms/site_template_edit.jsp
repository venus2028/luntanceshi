<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
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
<script src="../inc/common.js"></script>
<script>
function setPerson(userName, userNick) {
	form1.ownerNick.value = userNick;
}
</script>
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
SiteTemplateDb td = new SiteTemplateDb();
td = (SiteTemplateDb)td.getQObjectDb(new Integer(id));

String op = ParamUtil.get(request, "op");
if (op.equals("edit")) {
	String name = ParamUtil.get(request, "name");
	String author = ParamUtil.get(request, "author");
	String main_content = ParamUtil.get(request, "main_content");
	String home_content = ParamUtil.get(request, "home_content");
	String list_content = ParamUtil.get(request, "list_content");
	String doc_content = ParamUtil.get(request, "doc_content");
	String code = ParamUtil.get(request, "code");
	if (name.equals("")) {
		out.print(StrUtil.Alert_Back("名称不能为空！"));
		return;
	}
	if (main_content.equals("") || home_content.equals("")) {
		out.print(StrUtil.Alert_Back("主模板及首页模板不能为空！"));
		return;
	}
	int orders = ParamUtil.getInt(request, "orders", 1);
	String miniature = ParamUtil.get(request, "miniature");
	String common_content = ParamUtil.get(request, "common_content");
	String owner = "";
	String ownerNick = ParamUtil.get(request, "ownerNick");
	if (ownerNick.equals(""))
		owner = "";
	else {
		// 检查ownerNick是否存在
		com.redmoon.forum.person.UserDb user = new com.redmoon.forum.person.UserDb();
		user = user.getUserDbByNick(ownerNick);
		if (user!=null) {
			owner = user.getName();
		}
		else {
			out.print(StrUtil.Alert_Back("用户" + ownerNick + "不存在！"));
			return;
		}
	}
	
	String dir_code = "";
	if (td.save(new JdbcTemplate(), new Object[] {main_content,home_content,list_content,doc_content,new Integer(1),new Integer(1),dir_code,new java.util.Date(),author,miniature,new Integer(orders), code, name, owner, new Integer(id)})) {
		// 刷新缓存
		TemplateLoader.refreshTemplate(td.getCacheKey(SiteTemplateDb.TEMPL_TYPE_MAIN));
		TemplateLoader.refreshTemplate(td.getCacheKey(SiteTemplateDb.TEMPL_TYPE_HOME));
		TemplateLoader.refreshTemplate(td.getCacheKey(SiteTemplateDb.TEMPL_TYPE_LIST));
		TemplateLoader.refreshTemplate(td.getCacheKey(SiteTemplateDb.TEMPL_TYPE_DOC));
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "site_template_edit.jsp?id=" + id));
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
      <td class="head"><a href="site_template_list.jsp">子站点模板</a></td>
    </t
  ></tbody>
</table>
<br>
<br>
<pre id="divMain" name="divMain" style="display:none">
<%=td.getString("main_content")%>
</pre>
<pre id="divHome" name="divHome" style="display:none">
<%=td.getString("home_content")%>
</pre>	  
<pre id="divList" name="divList" style="display:none">
<%=StrUtil.getNullStr(td.getString("list_content"))%>
</pre>	  
<pre id="divDoc" name="divDoc" style="display:none">
<%=StrUtil.getNullStr(td.getString("doc_content"))%>
</pre>	  
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
      <td style="PADDING-LEFT: 10px">指定用户</td>
      <td colspan="2">
	  <%
	  String ownerNick = "";
	  String owner = StrUtil.getNullStr(td.getString("owner"));
	  if (!owner.equals("")) {
	  	com.redmoon.forum.person.UserDb ud = new com.redmoon.forum.person.UserDb();
		ud = ud.getUser(owner);
		if (ud.isLoaded()) {
			ownerNick = ud.getNick();
		}
	  }
	  %>
	  <input name="ownerNick" value="<%=ownerNick%>" />
	  <a href="#" onClick="openWin('../forum/admin/forum_user_sel.jsp', 480, 420)">选择</a></td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">缩略图路径</td>
      <td colspan="2"><input name="miniature" value="<%=td.getString("miniature")%>" size="60">
相对于站点根的路径</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">主模板</td>
      <td colspan="2">
<script type="text/javascript" src="../FCKeditor/fckeditor.js"></script>
<script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'main_content' ) ;
oFCKeditor.BasePath = '../FCKeditor/';
oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_cms.jsp' ;
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

oFCKeditor.Config["EditorAreaCSS"] = "<%=request.getContextPath() + "/skin/" + td.getString("code") + "/skin.css"%>";

oFCKeditor.Create();
//-->
</script></td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">副模板-首页</td>
      <td colspan="2">
<script type="text/javascript">
<!--
oFCKeditor = new FCKeditor( 'home_content' ) ;
oFCKeditor.BasePath = '../FCKeditor/';
oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_cms.jsp' ;
oFCKeditor.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor.Width = "100%";
oFCKeditor.Height = 200 ;
oFCKeditor.Value = divHome.innerHTML;

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

oFCKeditor.Config["EditorAreaCSS"] = "<%=request.getContextPath() + "/skin/" + td.getString("code") + "/skin.css"%>";

oFCKeditor.Create();
//-->
</script></td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">副模板-列表</td>
      <td colspan="2">
<script type="text/javascript">
<!--
oFCKeditor = new FCKeditor( 'list_content' ) ;
oFCKeditor.BasePath = '../FCKeditor/';
oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_cms.jsp' ;
oFCKeditor.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor.Width = "100%";
oFCKeditor.Height = 200 ;
oFCKeditor.Value = divList.innerHTML;

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

oFCKeditor.Config["EditorAreaCSS"] = "<%=request.getContextPath() + "/skin/" + td.getString("code") + "/skin.css"%>";

oFCKeditor.Create();
//-->
</script></td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">副模板-文章</td>
      <td colspan="2">
<script type="text/javascript">
<!--
oFCKeditor = new FCKeditor('doc_content') ;
oFCKeditor.BasePath = '../FCKeditor/';
oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_cms.jsp' ;
oFCKeditor.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor.Width = "100%";
oFCKeditor.Height = 200 ;
oFCKeditor.Value = divDoc.innerHTML;

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

oFCKeditor.Config["EditorAreaCSS"] = "<%=request.getContextPath() + "/skin/" + td.getString("code") + "/skin.css"%>";

oFCKeditor.Create();
//-->
</script>	  </td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">&nbsp;</td>
      <td colspan="2" align="center"><input type="submit" value=" 确定 ">
        &nbsp;&nbsp;&nbsp;
      <input type="reset" value=" 重置 "></td>
    </tr>
	</form>
</table>
<DIV style="WIDTH: 95%" align=right></DIV>
</body>
</html>