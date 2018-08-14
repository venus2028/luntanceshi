<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.blog.photo.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><lt:Label res="res.label.blog.user.photo" key="title"/></title>
<link href="../../cms/default.css" rel="stylesheet" type="text/css">
<script src="../../inc/common.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}
body {
	margin-top: 0px;
	margin-left: 0px;
	margin-right: 0px;
}
-->
</style>
<script src="../../inc/common.js"></script>
<script src="../../inc/map.js"></script>
<script src="../../inc/upload_ajax.js"></script>
<Script>
urlUploadProgress = "../../ajax_upload_progress.jsp";

function onUploadFinish() {
	$("ifrm").style.display = "";
	$("uploadProgressTab").style.display = "none";
	showPrompt("../../images/home/focus.gif", "上传完毕，请继续！", 5000);
}

function showPrompt(img, title, time) {
	$("spanPrompt").innerHTML = "<table border='0' cellpadding='0' cellspacing='0'><tr><td><img style='margin-right:8px' src='" + img + "' /></td><td>" + title + "</td></tr></table>";
	$("spanPrompt").style.display = "";
	if(time > 0) {
		window.setTimeout("delPrompt()", time);
	}
}

function delPrompt() {
	$('spanPrompt').style.display = 'none';
	$('spanPrompt').innerHTML='';
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="privilege" scope="page" class="com.redmoon.blog.Privilege"/>
<%
long blogId = ParamUtil.getLong(request, "blogId");

UserConfigDb ucd = new UserConfigDb();
ucd = ucd.getUserConfigDb(blogId);

String user = privilege.getUser(request);

if (!Privilege.canUserDo(request, blogId, Privilege.PRIV_ALL)) {
	out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, SkinUtil.PVG_INVALID)));
	return;
}

String uploadSerialNo = RandomSecquenceCreator.getId(20);

PhotoMgr lm = new PhotoMgr();
PhotoDb ld = new PhotoDb();

String op = StrUtil.getNullString(request.getParameter("op"));
%>
<%@ include file="photo_nav.jsp"%>
<script>
$("menu2").className="active";
</script>
<br>
<br>
<table width="60%" align="center">
<tr><td><span id="spanPrompt"></span></td></tr></table>
<div style="text-align:center;clear:both"><iframe id="ifrm" frameborder="0" src="photo_add.jsp?blogId=<%=blogId%>&uploadSerialNo=<%=uploadSerialNo%>" width="60%" height="260px"></iframe></div>

<table id="uploadProgressTab" style="display:none" width="60%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="78">上传进度：</td>
    <td width="509" valign="middle"><table width="300px" border="0" cellpadding="0" cellspacing="0" style="float:left;margin-left:5px;background-color:#dddddd;height:10px;margin-top:7px">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" id="uploadStatusProgress_<%=uploadSerialNo%>" style="background-color:#00CC66;height:10px;width:0px">
          <tr>
            <td></td>
          </tr>
        </table></td>
      </tr>
    </table>
    <div style="float:left;height:20px;margin-top:5px" id="uploadStatus_<%=uploadSerialNo%>">&nbsp;</div></td>
  </tr>
</table>
</body>
</html>