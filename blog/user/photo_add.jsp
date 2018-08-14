<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.blog.photo.*"%>
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
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="privilege" scope="page" class="com.redmoon.blog.Privilege"/>
<%
long blogId = ParamUtil.getLong(request, "blogId");

UserConfigDb ucd = new UserConfigDb();
ucd = ucd.getUserConfigDb(blogId);

String user = Privilege.getUser(request);

if (!Privilege.canUserDo(request, blogId, Privilege.PRIV_ALL)) {
	out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, SkinUtil.PVG_INVALID)));
	return;
}

PhotoMgr lm = new PhotoMgr();
PhotoDb ld = new PhotoDb();

String op = StrUtil.getNullString(request.getParameter("op"));

String uploadSerialNo = ParamUtil.get(request, "uploadSerialNo");

long catalog = ParamUtil.getLong(request, "catalog", 0);
PhotoCatalogDb pcd = new PhotoCatalogDb();
if (catalog!=0)
	pcd = (PhotoCatalogDb)pcd.getQObjectDb(new Long(catalog));

Vector v = pcd.list(pcd.getTable().getQueryList(), new Object[] {new Long(blogId)});
Iterator ir2 = v.iterator();
String caopts = "";
while (ir2.hasNext()) {
	PhotoCatalogDb pcd2 = (PhotoCatalogDb)ir2.next();
	caopts += "<option value=\"" + pcd2.getLong("id") + "\">" + pcd2.getString("title") + "</option>";
}
if (op.equals("add")) {
	try {
		if (lm.add(application, request)) {
			// out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "photo_add.jsp?blogId=" + blogId + "&catalog=" + catalog));
			response.sendRedirect("photo_add.jsp?blogId=" + blogId + "&catalog=" + catalog + "&uploadSerialNo=" + uploadSerialNo);
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}
%>
<br>
<%
DirDb dd = new DirDb();
dd = dd.getDirDb("root");
DirView dv = new DirView(dd);
StringBuffer optsBuf = new StringBuffer();
dv.getDirAsOptions(optsBuf, dd, dd.getLayer());
String opts = optsBuf.toString();
%>
<form action="photo_add.jsp?op=add&blogId=<%=blogId%>&catalog=<%=catalog%>&uploadSerialNo=<%=uploadSerialNo%>" method="post" enctype="multipart/form-data" id="addform1" name="addform1">
<table width="100%" align="center" cellPadding="3" cellSpacing="0" class="frame_gray" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">
  <tbody>
    <tr>
      <td height="24" colspan="2" align="center" noWrap class="thead">添加相片
	<%
	if (pcd.isLoaded()) {
		out.print("&nbsp;-&nbsp;" + pcd.getString("title"));
	}
	%>	  
	  </td>
      </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td width="13%" align="center">序号</td>
        <td width="87%"><input name="sort" value="<%=ld.getMaxOrders(blogId)+1%>" style="width:20px"></td>
      </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td align="center">
        <lt:Label res="res.label.blog.user.photo" key="name"/>      </td>
      <td><input name=title value=""></td>
      </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td align="center">
        <lt:Label res="res.label.blog.user.photo" key="pic"/>
	  </td>
      <td><input type="file" name="filename" style="width: 200px"></td>
      </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td align="center">专辑</td>
      <td><select name="catalog">
        <option value="0">无</option>
        <%=caopts%>
      </select>
        <script>
		addform1.catalog.value = "<%=catalog%>";
		</script></td>
      </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td align="center">评论</td>
      <td><input name="isLocked" value="0" type="checkbox" checked="checked">
        是否允许评论</td>
      </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td align="center">分类</td>
      <td>
	  <select id="dirCode" name="dirCode">
        <%=opts%>
      </select>
        <input name="blogId" value="<%=blogId%>" type="hidden">
		</td>
      </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td colspan="2" align="center">
	  <input type="button" onClick="submitFile()" value="确定" width=80 height=20>
	  </td>
      </tr>
</tbody></table>
</form>

</body>
<script>
function submitFile() {
	if ($("title").value.trim()=="") {
		alert("请填写名称！");
		return;
	}
	var fileName = addform1.filename.value;
	var p = fileName.lastIndexOf(".");
	if (p==-1) {
		alert("文件无扩展名！");
		return false;
	}
	else {
		var len = fileName.length;
		var ext = fileName.substring(p + 1, len).toLowerCase();
		if (ext=="gif" || ext=="jpg" || ext=="png" || ext=="bmp" || ext=="swf")
			;
		else {
			alert("文件类型非法，只允许gif、jpg、png、bmp、swf");
			return false;
		}
	}
	addform1.submit();
	window.parent.showProgress("<%=uploadSerialNo%>");
	window.parent.document.getElementById("uploadProgressTab").style.display = "";
	window.parent.document.getElementById("ifrm").style.display = "none";
}
</script>
</html>