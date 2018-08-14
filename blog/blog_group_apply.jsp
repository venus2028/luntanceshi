<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.cloudwebsoft.framework.base.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String skincode = UserSet.getSkin(request);
if (skincode.equals(""))
	skincode = UserSet.defaultSkin;
SkinMgr skm = new SkinMgr();
Skin skin = skm.getSkin(skincode);
if (skin==null) 
	skin = skm.getSkin(UserSet.defaultSkin);
String skinPath = skin.getPath();
String userstr = SkinUtil.LoadString(request,"res.label.blog.user.userconfig", "my_blog_add");
userstr = StrUtil.format(userstr, new Object[] {Global.AppName});
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=userstr%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<LINK href="../forum/<%=skinPath%>/css.css" type=text/css rel=stylesheet></head>
<body>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isUserLogin(request)) {
	out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, "err_not_login")));
	return;
}

long blogId = ParamUtil.getLong(request, "blog_id");

UserConfigDb ucd = new UserConfigDb();
ucd = ucd.getUserConfigDb(blogId);
if (!ucd.isLoaded()) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request,"res.label.blog.user.userconfig", "activate_blog_fail")));
	return;
}

BlogGroupUserDb bgu = new BlogGroupUserDb();
BlogGroupUserDb tmpbgu = bgu.getBlogGroupUserDb(blogId, privilege.getUser(request));
if ((tmpbgu!=null && tmpbgu.isLoaded()) || ucd.getUserName().equals(privilege.getUser(request))) {
	out.print(StrUtil.Alert_Back("您已申请或已加入了该团队博客!"));
	return;
}
%>
<%@ include file="../forum/inc/header.jsp"%>
<%
String op = ParamUtil.get(request, "op");
if (op.equals("add")) {
	QObjectMgr qom = new QObjectMgr();
	try {
		if (qom.create(request, bgu, "blog_group_user_create")) {
			out.print("<BR>");
			out.print("<BR>");
			out.print(StrUtil.waitJump(SkinUtil.LoadString(request, "info_op_success"), 3, "myblog.jsp?blogId=" + blogId));
			return;
		}
		else {
			out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
			return;
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}
%>
<table width="482" height="170" border="0" align="center" cellpadding="5" cellspacing="0" class="tableframe_gray">
<form id=form1 action="?op=add" method=post>
  <tr>
    <td colspan="2" align="center" class="td_title"><strong><lt:Label res="res.label.blog.blog_group_apply" key="blog_group_apply"/>&nbsp;-&nbsp;<%=ucd.getTitle()%></strong></td>
  </tr>
  <tr>
    <td width="109" height="22" bgcolor="#F2F2F2"><lt:Label res="res.label.blog.blog_group_apply" key="apply_reason"/></td>
    <td width="353" height="22" bgcolor="#F2F2F2">
	<textarea name="apply_reason" cols="45" id="apply_reason" rows="5"></textarea>
	<input name="blog_id" value="<%=blogId%>" type="hidden">
	<input name="user_name" value="<%=privilege.getUser(request)%>" type="hidden"></td>
  </tr>
  <tr>
    <td colspan="2" align="center" bgcolor="#F2F2F2"><label>
      <input type="submit" name="Submit" value="<lt:Label key="submit"/>">
      &nbsp;&nbsp;
      <input type="reset" name="Submit2" value="<lt:Label key="reset"/>">
    </label></td>
  </tr></form>
</table>
<p>&nbsp;</p>
<%@ include file="../forum/inc/footer.jsp"%>
</body>
</html>