<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<LINK href="plugin.css" type=text/css rel=stylesheet>
<title><%=Global.AppName%> - 商家简介</title>
<style type="text/css">
<!--
body {
	margin-top: 0px;
	margin-left: 0px;
	margin-right: 0px;
}
.style1 {
	font-size: 10pt;
	font-weight: bold;
}

-->
</style></head>
<body>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<%
String userName = ParamUtil.get(request, "userName");
AuctionShopDb as = new AuctionShopDb();
as = as.getAuctionShopDb(userName);

UserDb user = new UserDb();
user = user.getUser(userName);
%>
<br>
<table width="54%"  border="0" align="center"cellspacing="1" cellpadding="5" bgcolor="#666666">
  <tr align="center" bgcolor="#F1EDF3">
    <td height="22" colspan="2">
	<a href="shop.jsp?userName=<%=StrUtil.UrlEncode(userName)%>"><%=StrUtil.toHtml(as.getShopName())%></a>
	</td>
  </tr>
  <tr align="center" bgcolor="#FFFFFF">
    <td width="20%" height="22">用户名</td>
    <td width="80%" height="22" align="left"><a href="../../../userinfo.jsp?username=<%=StrUtil.UrlEncode(userName)%>"><%=StrUtil.toHtml(user.getNick())%></a></td>
  </tr>
  <tr align="center" bgcolor="#FFFFFF">
    <td height="22">地&nbsp;&nbsp;&nbsp;&nbsp;址</td>
    <td height="22" align="left"><%=StrUtil.toHtml(as.getAddress())%></td>
  </tr>
  <tr align="center" bgcolor="#FFFFFF">
    <td height="22">电&nbsp;&nbsp;&nbsp;&nbsp;话</td>
    <td height="22" align="left"><%=StrUtil.toHtml(as.getTel())%></td>
  </tr>
  <tr align="center" bgcolor="#FFFFFF">
    <td height="22">简&nbsp;&nbsp;&nbsp;&nbsp;介</td>
    <td height="22" align="left"><%=StrUtil.toHtml(as.getDesc())%></td>
  </tr>
  <tr align="center" bgcolor="#FFFFFF">
    <td height="22">信用值</td>
    <td height="22" align="left">
	<%=user.getCredit()%>
	</td>
  </tr>
</table>
<br>
<br>
</body>
</html>
