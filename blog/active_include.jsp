<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.blog.ui.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.setup.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isUserLogin(request)) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "err_not_login")));
	return;
}
%>
<%
String skincode = UserSet.getSkin(request);
if (skincode.equals(""))
	skincode = UserSet.defaultSkin;
com.redmoon.forum.ui.SkinMgr skm = new com.redmoon.forum.ui.SkinMgr();
com.redmoon.forum.ui.Skin skin = skm.getSkin(skincode);
if (skin==null)
	skin = skm.getSkin(UserSet.defaultSkin);
String skinPath = skin.getPath();
String userstr = SkinUtil.LoadString(request,"res.label.blog.user.userconfig", "my_blog_add");
userstr = StrUtil.format(userstr, new Object[] {Global.AppName});
%>
<html>
<head>
<title><%=userstr%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<LINK href="template/css.css" type=text/css rel=stylesheet>
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
<br>
<%
String blogType = ParamUtil.get(request, "blogType");

String userName = privilege.getUser(request);
if (blogType.equals(""))
	blogType = "" + UserConfigDb.TYPE_PERSON;

if (blogType.equals("" + UserConfigDb.TYPE_PERSON)) {
	UserConfigDb ucd = new UserConfigDb();
	long blogId = ucd.getBlogIdByUserName(userName);
	if (blogId!=UserConfigDb.NO_BLOG) {
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request,"res.label.blog.user.userconfig", "activate_blog_success")));
		return;
	}
}

com.redmoon.blog.Config cfg = com.redmoon.blog.Config.getInstance();
int level = cfg.getIntProperty("createBlogUserLevel");
UserDb ud = new UserDb();
ud = ud.getUser(privilege.getUser(request));
if (ud.getUserLevelDb().getLevel()<level) {
	UserLevelDb uld = new UserLevelDb();
	uld = uld.getUserLevelDb(level);
	out.print(SkinUtil.makeErrMsg(request, StrUtil.format(SkinUtil.LoadString(request, "res.label.blog.user.userconfig", "error_create"), new Object[] {uld.getDesc(), ud.getLevelDesc()})));
	return;
}
%>
<table width="98%" height="170" border="0" align="center" cellpadding="5" cellspacing="1" bgcolor="#F2F2F2" class="tableframe_gray">
<form id=form1 action="user/userconfig_do.jsp?op=add&blogType=<%=blogType%>" method=post enctype="multipart/form-data">
  <tr>
    <td colspan="2" align="center" class="td_title"><strong><lt:Label res="res.label.blog.user.userconfig" key="note_add"/></strong></td>
  </tr>
  <tr>
    <td width="155" height="22" bgcolor="#FFFFFF"><lt:Label res="res.label.blog.user.userconfig" key="column_title"/></td>
    <td width="561" height="22" bgcolor="#FFFFFF"><label>
      <input name="title" type="text" id="title">
	  <input name="blogType" value="<%=blogType%>" type="hidden">
	  <%if (blogType.equals("" + UserConfigDb.TYPE_GROUP)) {%>
	  	<lt:Label res="res.label.blog.user.userconfig" key="type_group"/>
	  <%}%>
    </label></td>
  </tr>
  <tr>
    <td height="22" bgcolor="#FFFFFF"><lt:Label res="res.label.blog.user.userconfig" key="deputy_title"/></td>
    <td height="22" bgcolor="#FFFFFF"><input name="subtitle" type="text" id="subtitle"></td>
  </tr>
  <tr>
    <td height="22" bgcolor="#FFFFFF"><lt:Label res="res.label.blog.user.userconfig" key="class"/></td>
    <td height="22" bgcolor="#FFFFFF"><select name="kind">
    <%
	com.redmoon.blog.LeafChildrenCacheMgr dlcm = new com.redmoon.blog.LeafChildrenCacheMgr("root");
	java.util.Vector vt = dlcm.getDirList();
	Iterator irv = vt.iterator();
	while (irv.hasNext()) {
		com.redmoon.blog.Leaf leaf = (com.redmoon.blog.Leaf) irv.next();
		String parentCode = leaf.getCode();
	%>
        <option style="BACKGROUND-COLOR: #f8f8f8" value="<%=leaf.getCode()%>"><%=leaf.getName()%></option>
        <%}%>
      </select>    </td>
  </tr>
  <tr>
    <td height="22" bgcolor="#FFFFFF"><lt:Label res="res.label.blog.user.userconfig" key="pen_name"/></td>
    <td height="22" bgcolor="#FFFFFF"><input name="penName" type="text" id="penName">
      （<lt:Label res="res.label.blog.user.userconfig" key="article_title"/>）</td>
  </tr>
  <tr>
    <td height="22" bgcolor="#FFFFFF"><lt:Label res="res.label.blog.user.userconfig" key="skin"/></td>
    <td height="22" bgcolor="#FFFFFF"><%
TemplateDb td = new TemplateDb();
Vector v = td.list();
Iterator ir = v.iterator();
String skinoptions = "";
while (ir.hasNext()) {
	td = (TemplateDb) ir.next();
	skinoptions += "<option value='" + td.getLong("id") + "'>" + td.getString("name") + "</option>";
}
%>
      <select name="skin">
        <%=skinoptions%>
      </select>
	  <a href="#" onClick="openWin('user/template_sel.jsp',800,600)">选择模板</a>
      </td></tr>
  <tr>
    <td height="22" bgcolor="#FFFFFF">Logo</td>
    <td height="22" bgcolor="#FFFFFF"><input name="filename" type="file">
      <br>
      (
      <%
            int iconWidth = cfg.getIntProperty("iconWidth");
            int iconHeight = cfg.getIntProperty("iconHeight");
            out.print(StrUtil.format(SkinUtil.LoadString(request, "res.blog.UserConfigDb", "err_logo_size"), new Object[] {""+iconWidth, ""+iconHeight}));
	  %>
      )</td>
  </tr>
  <tr>
    <td height="22" bgcolor="#FFFFFF"><lt:Label res="res.label.blog.user.userconfig" key="is_footprint"/></td>
    <td height="22" bgcolor="#FFFFFF">
	<select name="is_footprint">
	<option value="1" selected="selected"><lt:Label key="yes"/></option>
	<option value="0"><lt:Label key="no"/></option>
	</select>
	</td>
  </tr>
  <tr>
    <td height="22" valign="top" bgcolor="#FFFFFF"><lt:Label res="res.label.blog.user.userconfig" key="notice"/></td>
    <td height="22" bgcolor="#FFFFFF"><textarea name="notice" cols="40" rows="6" id="notice"></textarea></td>
  </tr>
  <tr>
    <td colspan="2" align="center" bgcolor="#FFFFFF"><label>
      <input type="submit" name="Submit" value="<lt:Label res="res.label.blog.user.userconfig" key="submit"/>">
      &nbsp;&nbsp;
      <input type="reset" name="Submit2" value="<lt:Label res="res.label.blog.user.userconfig" key="reset"/>">
    </label></td>
  </tr></form>
</table>
<p>&nbsp;</p>
</body>
</html>