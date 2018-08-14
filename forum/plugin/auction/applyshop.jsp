<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isUserLogin(request)) {
	response.sendRedirect("../../../info.jsp?op=login&privurl=" + StrUtil.getUrl(request) + "&info=" + StrUtil.UrlEncode(SkinUtil.LoadString(request, "err_not_login")));
	return;
}
String skinPath = SkinMgr.getSkinPath(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../../<%=skinPath%>/css.css" rel="stylesheet" type="text/css">
<title>我要开店 - <%=Global.AppName%></title>
</head>
<body>
<div id="wrapper">
<%@ include file="../../inc/header.jsp"%>
<div id="main">
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<form name="form1" method="post" action="applyshop_do.jsp">
<table class="tableCommon60" width="67%"  border="0" align="center">
  <thead>
  <tr align="center">
    <td height="22" colspan="2" class="td_title">我 要 开 店</td>
  </tr>
  </thead>
  <tr align="center">
    <td width="20%" height="22">店名</td>
    <td width="80%" align="left"><input name=shopName size=20></td>
  </tr>
  <tr align="center">
    <td height="22">地址</td>
    <td height="22" align="left"><input name=address size=40></td>
  </tr>
  <tr align="center">
    <td height="22">联系人</td>
    <td height="22" align="left"><input name=contacter size=16></td>
  </tr>
  <tr align="center">
    <td height="22">电话</td>
    <td height="22" align="left"><input name=tel size=16></td>
  </tr>
  <tr align="center">
    <td height="22">简介</td>
    <td height="22" align="left"><textarea name="desc" cols="36" rows="8"></textarea></td>
  </tr>
  <tr align="center">
    <td height="22" colspan="2"><input type="submit" name="Submit" value="提交">
      &nbsp;&nbsp;&nbsp;&nbsp;
      <input type="reset" name="Submit" value="重置"></td>
  </tr>
</table></form>
</div>
<%@ include file="../../inc/footer.jsp"%>
</div>
</body>
</html>
