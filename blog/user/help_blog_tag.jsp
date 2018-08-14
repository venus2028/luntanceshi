<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.net.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.file.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*" %>
<%@ page import="com.cloudwebsoft.framework.template.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>子站点模板标签说明</title>
<link href="../admin/default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
body {
	margin-top: 0px;
	margin-left: 0px;
	margin-right: 0px;
}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">模板说明</td>
    </tr>
  </tbody>
</table>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="95%" align="center">
  <tbody>
  <form name="form1" action="?op=editTemplate" method="post">
    <tr>
      <td colspan="2" align="center" noWrap class="thead" style="PADDING-LEFT: 10px">标签说明</td>
    </tr>
    
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td width="13%" height="22" style="PADDING-LEFT: 10px">{$boke.title}</td>
      <td width="87%" style="PADDING-LEFT: 10px"> 博客标题 </td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$boke.subtitle}</td>
      <td style="PADDING-LEFT: 10px">博客副标题</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$boke.rss}</td>
      <td style="PADDING-LEFT: 10px">RSS订阅</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">
        {$boke.nav}
      </td>
      <td style="PADDING-LEFT: 10px">导航条</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$boke.main}</td>
      <td style="PADDING-LEFT: 10px">主区域，在文章页和视频、歌曲显示页中将会分别被替代为副模板-文章和副模板-其它</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$boke.user} </td>
      <td style="PADDING-LEFT: 10px">博客用户信息</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$boke.notice} </td>
      <td style="PADDING-LEFT: 10px">公告</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$boke.calendar} </td>
      <td style="PADDING-LEFT: 10px">日历</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$boke.newArticle} </td>
      <td style="PADDING-LEFT: 10px">最新日志</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$boke.comment} </td>
      <td style="PADDING-LEFT: 10px">最新评论</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$boke.dir} </td>
      <td style="PADDING-LEFT: 10px">博客文章目录</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$boke.photo} </td>
      <td style="PADDING-LEFT: 10px">博客相册</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$boke.friend}</td>
      <td style="PADDING-LEFT: 10px">博客好友</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$boke.link} </td>
      <td style="PADDING-LEFT: 10px">友情连接</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$boke.info} </td>
      <td style="PADDING-LEFT: 10px">博客统计</td>
    </tr>
  </form>
</table>
</body>
</html>