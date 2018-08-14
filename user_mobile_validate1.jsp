<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.web.Global"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.person.UserSet"%>
<%
String skinPath = SkinMgr.getSkinPath(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=Global.AppName%> - 验证手机1</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="forum/<%=skinPath%>/css.css" rel="stylesheet" type="text/css">
</head>
<body>
<div id="wrapper">
<%@ include file="forum/inc/header.jsp"%>
<div id="main">
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege" />
<%
if (!privilege.isUserLogin(request)) {
	out.print(StrUtil.Alert_Redirect("请先登录！", "forum/index.jsp"));
	return;
}
com.redmoon.forum.person.UserDb user = new com.redmoon.forum.person.UserDb();
user = user.getUser(privilege.getUser(request));
%>
<br>
<br>
<br>
<Form method="POST" action="user_mobile_validate2.jsp"  name="frmAnnounce">
<table width=475 align=center cellspacing=0 cellpadding=0 border=0 class="tableframe_gray">
 <tr>
      <td width="537">&nbsp;</td>
</tr></table>
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tableCommon60">
  <thead>
  <tr>
    <td align="center">注册成为高级会员 </td>
  </tr>
  </thead>
  <tr>
    <td align="center" valign="top">用户：<%=user.getNick()%>&nbsp;您的手机号
      <input name="mobile" type="text" class="singleboarder" size="20" value="<%=user.getMobile()%>" />
        <font color="#FF0000"> * </font></td>
  </tr>
  <tr>
    <td height="25" align="center" valign="middle">按提交后确认码将会发送至您的手机，您收到的信息是免费的</td>
  </tr>
  <tr>
    <td height="25" align="center" valign="middle">　
      <input name=Write type=submit class="singleboarder" value=" 提交 " />
　
<input name=reset type=reset class="singleboarder" value="重填" /></td>
  </tr>
</table>
</form>
<br>
<br>
<br>
</div>
<%@ include file="forum/inc/footer.jsp"%>
</div>
</body>
</html>