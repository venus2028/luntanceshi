<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ page import="cn.js.fan.module.cms.*" %>
<html>
<head>
<title>管理导航条</title>
<link href="../common.css" rel="stylesheet" type="text/css">
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="navmgr" scope="page" class="cn.js.fan.module.nav.NavigationMgr"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, PrivDb.PRIV_ADMIN))
{
	//out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	//return;
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">管理采集地址</td>
    </tr>
  </tbody>
</table>
<br>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="95%" align="center">
  <tbody>
    <tr>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="24%">名称</td>
      <td class="thead" noWrap width="48%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">地址</td>
      <td width="28%" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">操作</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
	<form name="addform1" action="?op=gather" method="post">
      <td style="PADDING-LEFT: 10px">
	  &nbsp;<img src="images/arrow.gif" align="absmiddle">&nbsp;采集地址<br>
        (网易)</td>
      <td>
          <input type="text" name="url" value="http://mimg.163.com/tianqi/city/58248.html" size=60>
          <input type=hidden name="source" value="163"></td>
      <td><label>
        <input type="submit" name="Submit" value="提交">
      </label></td>
	</form>
    </tr>
  </tbody>
</table>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="95%" align="center">
  <tbody>
    <tr>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="24%">名称</td>
      <td class="thead" noWrap width="48%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">地址</td>
      <td width="28%" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">操作</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <form name="addform2" action="?op=gather" method="post">
        <td style="PADDING-LEFT: 10px">&nbsp;<img src="images/arrow.gif" align="absmiddle">&nbsp;采集地址<br>
        (china.com.cn)</td>
        <td><input type="text" name="url" value="http://weather.china.com.cn/city/58248.html" size=60> <input type=hidden name="source" value="china.com.cn">       </td>
        <td><label>
          <input type="submit" name="Submit" value="提交">
        </label></td>
      </form>
    </tr>
  </tbody>
</table>
<br>
<%
String op = StrUtil.getNullString(request.getParameter("op"));
String content = "";
GatherUtil gu = new GatherUtil();
String source = ParamUtil.get(request, "source");
if (op.equals("gather")) {
	String url = ParamUtil.get(request, "url");
	content = gu.gather(url);
	// out.print(content);
}
%>
<table width="95%" border="0" align="center" cellpadding="3" cellspacing="0" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">
  <tr>
    <td colspan="3" align="center" class="thead">解析内容 </td>
  </tr>
  <tr>
    <td colspan="3" align="center"><%=gu.parseWeather(source, content)%> </td>
  </tr>
</table>
<br>
<table width="95%" border="0" align="center" cellpadding="3" cellspacing="0" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">
  <tr>
    <td colspan="3" align="center">
	<textarea cols="100" rows="10"><%=content%></textarea></td>
  </tr>
</table><br>
<HR noShade SIZE=1>
</body>
</html>