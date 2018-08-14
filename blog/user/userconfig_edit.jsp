<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.blog.ui.*"%>
<%@ page import="com.redmoon.forum.setup.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.blog.user.userconfig" key="title"/></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../../cms/default.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.STYLE1 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
<script>
function openWin(url,width,height){
	var newwin = window.open(url,"_blank","scrollbars=yes,resizable=yes,toolbar=no,location=no,directories=no,status=no,menubar=no,top=50,left=120,width="+width+",height="+height);
}

function sel(id) {
	form1.skin.value = id;
}
</script>
</head>
<body>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request)) {
	if (!privilege.isUserLogin(request)) {
		out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, "err_not_login")));
		return;
	}
}
long blogId = ParamUtil.getLong(request, "blogId");
UserConfigDb ucd = new UserConfigDb();
ucd = ucd.getUserConfigDb(blogId);
if (!ucd.isLoaded()) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request,"res.label.blog.user.userconfig", "activate_blog_fail")));
	return;
}

String op = ParamUtil.get(request, "op");
if (op.equals("delIcon")) {
	ucd.delIcon();
	out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "userconfig_edit.jsp?blogId=" + blogId));
	return;
}

String user = privilege.getUser(request);
// 检查用户权限
if (!Privilege.canUserDo(request, blogId, Privilege.PRIV_ALL)) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, SkinUtil.PVG_INVALID)));
	return;
}
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head"><lt:Label res="res.label.blog.user.frame" key="config_info"/></td>
  </tr>
</table>
<br>
<table width="86%" height="170" border="0" align="center" cellpadding="5" cellspacing="0" class="frame_gray">
<form id=form1 action="userconfig_do.jsp?op=modify&blogId=<%=blogId%>" method=post enctype="multipart/form-data">
  <tr>
    <td height="24" colspan="4" align="center" class="thead">      <lt:Label res="res.label.blog.user.userconfig" key="note_edit"/></td>
  </tr>
  <tr>
    <td width="18%" height="22"><lt:Label res="res.label.blog.user.userconfig" key="column_title"/></td>
    <td height="22"><label>
      <input name="title" type="text" id="title" value="<%=ucd.getTitle()%>">
    </label></td>
    <td height="22"><lt:Label res="res.label.blog.user.userconfig" key="deputy_title"/></td>
    <td height="22"><input name="subtitle" type="text" id="subtitle" value="<%=ucd.getSubtitle()%>"></td>
  </tr>
  <tr>
    <td height="22"><lt:Label res="res.label.blog.user.userconfig" key="class"/></td>
    <td height="22"><select name="kind">
    <%
	LeafChildrenCacheMgr dlcm = new LeafChildrenCacheMgr("root");
	java.util.Vector vt = dlcm.getDirList();
	Iterator irv = vt.iterator();
	while (irv.hasNext()) {
		Leaf leaf = (Leaf) irv.next();
	%>
        <option style="BACKGROUND-COLOR: #f8f8f8" value="<%=leaf.getCode()%>"><%=leaf.getName()%></option>
        <%}%>
      </select>
     <script>
	 form1.kind.value = "<%=ucd.getKind()%>";
	 </script></td>
    <td height="22"><lt:Label res="res.label.blog.user.userconfig" key="pen_name"/></td>
    <td height="22"><input name="penName" type="text" id="penName" value="<%=ucd.getPenName()%>">
      <input name="id" id="id" value="<%=blogId%>" type=hidden>
      (
      <lt:Label res="res.label.blog.user.userconfig" key="article_title"/>
)</td>
  </tr>
  
<%
com.redmoon.blog.Config cfg = com.redmoon.blog.Config.getInstance();
if (Global.isSubDomainSupported || cfg.getBooleanProperty("isDomainMapToPath")) {
%>
<%}else{%>
<input name="domain" id="domain" value="<%=ucd.getDomain()%>" type="hidden">
<%}%>   
  <tr>
    <td height="22"><lt:Label res="res.label.blog.user.userconfig" key="skin"/></td>
    <td height="22">
<%
TemplateDb td = new TemplateDb();
Vector v = td.list();
Iterator ir = v.iterator();
String skinoptions = "";
String miniature = "";
String divPrint = "";
while (ir.hasNext()) {
	td = (TemplateDb) ir.next();
	skinoptions += "<option value='" + td.getLong("id") + "'>" + td.getString("name") + "</option>";
}
%>
<select name="skin">
<%=skinoptions%>
</select>
<a href="#" onClick="openWin('template_sel.jsp',800,600)">选择模板</a>
<script>
form1.skin.value = "<%=ucd.getSkin()%>";
</script></td>
    <td height="22"><lt:Label res="res.label.blog.user.userconfig" key="is_footprint"/></td>
    <td height="22"><select name="is_footprint">
      <option value="1" selected="selected">
      <lt:Label key="yes"/>
      </option>
      <option value="0">
      <lt:Label key="no"/>
      </option>
    </select>
      <script>
	  form1.is_footprint.value = "<%=ucd.isFootprint()?1:0%>";
	  </script></td>
  </tr>
  
  <tr>
    <td height="22"><lt:Label res="res.label.blog.user.userconfig" key="is_bk_music"/></td>
    <td width="29%" height="22">
	<select name="isBkMusic">
	<option value="1"><lt:Label key="yes"/></option>
	<option value="0"><lt:Label key="no"/></option>
	</select>
	  <script>
	  form1.isBkMusic.value = "<%=ucd.isBkMusic()?1:0%>";
	  </script>	</td>
    <td width="17%">照片是否允许评分</td>
    <td width="36%"><select name="isPhotoDig">
      <option value="1">
      <lt:Label key="yes"/>
      </option>
      <option value="0">
      <lt:Label key="no"/>
      </option>
    </select>
      <script>
	  form1.isPhotoDig.value = "<%=ucd.isPhotoDig()?1:0%>";
	  </script></td>
  </tr>
  <tr>
    <td height="22"><lt:Label res="res.label.blog.user.userconfig" key="is_user_css"/></td>
    <td height="22" colspan="3">
  <%
	int level = cfg.getIntProperty("modifyTemplateUserLevel");
	UserDb ud = new UserDb();
	ud = ud.getUser(user);
	if (ud.getUserLevelDb().getLevel()>=level) {  
  %>
	<select name="isUserCss">
      <option value="1">
        <lt:Label key="yes"/>
        </option>
      <option value="0">
        <lt:Label key="no"/>
        </option>
    </select>
	  <script>
	  form1.isUserCss.value = "<%=ucd.isUserCss()?1:0%>";
	  </script>
  <%}else{
	UserLevelDb uld = new UserLevelDb();
	uld = uld.getUserLevelDbByLevel(level);  
  %>
	<select name="isUserCssTmp" disabled>
      <option value="1">
        <lt:Label key="yes"/>
        </option>
      <option value="0">
        <lt:Label key="no"/>
        </option>
    </select>
  <input name="isUserCss" value="0" type="hidden">
  等级在<%=uld.getDesc()%>以上者可以启用自定义模板
  <%}%>	  </td>
  </tr>
  <tr>
    <td height="22"><lt:Label res="res.label.blog.user.userconfig" key="notice"/></td>
    <td height="22" colspan="3"><textarea name="notice" cols="50" rows="6" id="notice"><%=ucd.getNotice()%></textarea></td>
  </tr>
  <tr>
    <td height="22"><lt:Label res="res.label.blog.user.userconfig" key="domain"/></td>
    <td height="22" colspan="3"><input name="domain" type="text" id="domain" value="<%=ucd.getDomain()%>">
      (
      <lt:Label res="res.label.blog.user.userconfig" key="domain_desc"/>
      )&nbsp;&nbsp;blogId=<%=ucd.getId()%>
      <%if (cfg.getBooleanProperty("isDomainMapToPath")) {%>
      <BR>
      <a href="<%=Global.getFullRootPath()%>/blog/<%=ucd.getDomain().equals("")?""+ucd.getId():ucd.getDomain()%>" target="_blank"><%=Global.getFullRootPath()%>/blog/<%=ucd.getDomain().equals("")?""+ucd.getId():ucd.getDomain()%></a>
      <%}%>
      <%if (Global.isSubDomainSupported) {
	String serverName = request.getServerName();
	String baseDomain = "";
	// 取得本站主机名
	String[] domainParts = StrUtil.split(serverName, "\\.");
	int len = domainParts.length;
	if (len == 1 || StrUtil.isNumeric(domainParts[len - 1])) {
		// 如果是IP地址或localhost
		baseDomain = serverName;	
	} else {
		// 取得一级域名，如 zjrj.cn
		if (domainParts[len - 2].equalsIgnoreCase("gov") && domainParts[len - 1].equalsIgnoreCase("cn")) {
			baseDomain = domainParts[len - 3] + "." + domainParts[len - 2] + "." + domainParts[len - 1];
		}
		else if (domainParts[len - 2].equalsIgnoreCase("com") &&
			domainParts[len - 1].equalsIgnoreCase("cn")) {
			baseDomain = domainParts[len - 3] + "." +
						 domainParts[len - 2] + "." +
						 domainParts[len - 1];
		} 				
		else
			baseDomain = domainParts[len - 2] + "." + domainParts[len - 1];
%>
      <BR>
      <a target="_blank" href="http://<%=ucd.getDomain().equals("")?""+ucd.getId():ucd.getDomain()%>.blog.<%=baseDomain%>">http://<%=ucd.getDomain().equals("")?""+ucd.getId():ucd.getDomain()%>.blog.<%=baseDomain%></a>
      <%					 
	}
}%>
      <br></td>
  </tr>
  
  <tr>
    <td height="22">LOGO</td>
    <td height="22" colspan="3"><input name="filename" type="file">
        <br>
      (
      <%
            int iconWidth = cfg.getIntProperty("iconWidth");
            int iconHeight = cfg.getIntProperty("iconHeight");
            out.print(StrUtil.format(SkinUtil.LoadString(request, "res.blog.UserConfigDb", "err_logo_size"), new Object[] {""+iconWidth, ""+iconHeight}));
	  %>
      )
      <%if (!ucd.getIcon().equals("")) {%>
      <br>
      <img src="<%=ucd.getIconUrl(request)%>"><br>
      <BR>
      [<a href="userconfig_edit.jsp?op=delIcon&blogId=<%=blogId%>">
        <lt:Label key="op_del"/>
        </a>] <br>
      <%}%>    </td>
  </tr>
  <tr>
    <td height="22">是否启用</td>
    <td height="22" colspan="3">
	<select name="isOpen">
	<option value="1">是</option>
	<option value="0">否</option>
	</select>
	  <script>
	  form1.isOpen.value = "<%=ucd.isOpen()?1:0%>";
	  </script>	
	</td>
  </tr>
  
  <tr>
    <td colspan="4" align="center"><label>
      <input type="submit" name="Submit" value="<lt:Label res="res.label.blog.user.userconfig" key="modify"/>">
      &nbsp;&nbsp;
      <input type="reset" name="Submit2" value="<lt:Label res="res.label.blog.user.userconfig" key="reset"/>">
    </label></td>
  </tr></form>
</table>
<br>
<p>&nbsp;</p>
</body>
</html>