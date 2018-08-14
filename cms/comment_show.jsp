<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
int id = ParamUtil.getInt(request, "id");
CommentDb cd = new CommentDb();
cd = cd.getCommentDb(id);

Document doc = new Document();

doc = doc.getDocument(cd.getDocId());
String docTitle = "";
if (doc!=null) {
	docTitle = doc.getTitle();
}
else
	doc = new Document();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>管理评论</title>
<link href="../common.css" rel="stylesheet" type="text/css">
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}
.style1 {
	font-size: 14px;
	font-weight: bold;
}
-->
</style>
<script src="../inc/common.js"></script>
<script>
function window_onload() {

}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onload="window_onload()">
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">查看评论</td>
    </tr>
  </tbody>
</table>
<br>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="98%" align="center">
  <tbody>
    <tr>
      <td width="9%" align="center" noWrap class="thead"><a href="../doc_view.jsp?id=<%=doc.getId()%>" target=_blank><%=docTitle%></a></td>
    </tr>

    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td colspan="3" align="left" style="line-height:1.5">
	  <strong>发布者：</strong><%=cd.getNick()%><br>
	  <strong>IP：</strong><%=cd.getIp()%><br>
	  <strong>时间：</strong><%=DateUtil.format(cd.getAddDate(), "yy-MM-dd HH:mm")%><br>
	  <%=StrUtil.toHtml(cd.getContent())%>
	  </td>
    </tr>
  </tbody>
</table>
</body>
</html>