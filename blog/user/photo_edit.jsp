<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.blog.photo.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.blog.user.photo" key="title"/></title>
<link href="../../cms/default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script src="../../inc/common.js"></script>
<style type="text/css">
/*Tooltips*/
.tooltips{
position:relative; /*这个是关键*/
z-index:2;
}
.tooltips:hover{
z-index:3;
background:none; /*没有这个在IE中不可用*/
}
.tooltips span{
display: none;
}
.tooltips span img {
width:100px;
}
.tooltips:hover span{ /*span 标签仅在 :hover 状态时显示*/
display:block;
position:absolute;
top:21px;
left:9px;
width:5px;
border:0px solid black;
background-color: #FFFFFF;
padding: 3px;
color:black;
}
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="privilege" scope="page" class="com.redmoon.blog.Privilege"/>
<%
String user = privilege.getUser(request);

PhotoMgr lm = new PhotoMgr();
PhotoDb ld = new PhotoDb();
 
long id = ParamUtil.getLong(request, "id");
ld = ld.getPhotoDb(id);
long blogId = ld.getBlogId();
if (!Privilege.canUserDo(request, blogId, Privilege.PRIV_ALL)) {
	out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, SkinUtil.PVG_INVALID)));
	return;
}

String uploadSerialNo = ParamUtil.get(request, "uploadSerialNo");

UserConfigDb ucd = new UserConfigDb();
ucd = ucd.getUserConfigDb(blogId);

String op = StrUtil.getNullString(request.getParameter("op"));
int curpage = ParamUtil.getInt(request, "CPages", 1);

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

if (op.equals("edit")) {
	try {
		if (lm.modify(application, request)) {
			// out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "photo_edit.jsp?blogId=" + blogId + "&id=" + id));
			response.sendRedirect("photo_edit.jsp?blogId=" + blogId + "&id=" + id + "&uploadSerialNo=" + uploadSerialNo);
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}

DirDb dd = new DirDb();
dd = dd.getDirDb("root");
DirView dv = new DirView(dd);
StringBuffer optsBuf = new StringBuffer();
dv.getDirAsOptions(optsBuf, dd, dd.getLayer());
String opts = optsBuf.toString();
%>
<form name="addform1" action="photo_edit.jsp?op=edit&blogId=<%=blogId%>&id=<%=id%>&uploadSerialNo=<%=uploadSerialNo%>" method="post" enctype="MULTIPART/FORM-DATA">
<table width="100%" align="center" cellPadding="3" cellSpacing="0" class="frame_gray" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">
  <tbody>
    <tr>
      <td height="24" colspan="2" align="center" noWrap class="thead">编辑相片
        <%
	if (pcd.isLoaded()) {
		out.print("&nbsp;-&nbsp;" + pcd.getString("title"));
	}
	%></td>
      </tr>
    <tr>
      <td width="15%" align="center" noWrap>序号</td>
      <td width="85%" height="24" noWrap><input name="sort" value="<%=ld.getSort()%>" style="width:20px"></td>
      </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td align="center">
        <lt:Label res="res.label.blog.user.photo" key="name"/>
	  </td>
      <td>
	  <a class="tooltips" href="#">        
		<input name=title value="<%=StrUtil.toHtml(ld.getTitle())%>">
	    <%
		String photoUrl = "";
		if (ld.getImage()==null || ld.getImage().equals("")) {%>
        <%}else{
			com.redmoon.forum.Config cfg = com.redmoon.forum.Config.getInstance();
			String attachmentBasePath = request.getContextPath() + "/upfile/" + ld.photoBasePath + "/";
			if (ld.isRemote()) {
				boolean isFtpUsed = cfg.getBooleanProperty("forum.ftpUsed");
				if (isFtpUsed) {
					attachmentBasePath = cfg.getProperty("forum.ftpUrl");
					if (attachmentBasePath.lastIndexOf("/")!=attachmentBasePath.length()-1)
						attachmentBasePath += "/";
					attachmentBasePath += ld.photoBasePath + "/";
				}
			}
			photoUrl = "../showphoto.jsp?photoId=" + ld.getId();
		%>
			<span><img src="<%=attachmentBasePath+"/"+ld.getImage()%>" border="0" align="absmiddle"></span>	
        <%}%>
		</a></td>
      </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td align="center">
        <lt:Label res="res.label.blog.user.photo" key="pic"/>      </td>
      <td><input name="filename" type="file" style="width: 200px"></td>
      </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td align="center">专辑</td>
      <td><select name="catalog">
        <option value="0">无</option>
        <%=caopts%>
      </select>
        <script>
	  addform1.catalog.value = "<%=ld.getCatalog()%>";
	    </script></td>
      </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td align="center">评论</td>
      <td><input name="isLocked" value="0" type="checkbox" <%=ld.isLocked()?"":"checked"%>></td>
      </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td align="center">分类</td>
      <td><select name="dirCode">
        <%=opts%>
      </select>
        <script>
	  addform1.dirCode.value = "<%=ld.getDirCode()%>";
	    </script></td>
      </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td align="center">日期</td>
      <td><a href="<%=photoUrl%>" target="_blank"><%=com.redmoon.forum.ForumSkin.formatDate(request, ld.getAddDate())%></a>
        <input name="id" value="<%=ld.getId()%>" type="hidden">
        <input name="blogId" value="<%=blogId%>" type="hidden"></td>
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
		//alert("文件无扩展名！");
		//return false;
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