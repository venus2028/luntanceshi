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

PhotoMgr lm = new PhotoMgr();
PhotoDb ld = new PhotoDb();

String op = StrUtil.getNullString(request.getParameter("op"));
int curpage = ParamUtil.getInt(request, "CPages", 1);

PhotoCatalogDb pcd = new PhotoCatalogDb();

if (op.equals("del")) {
	if (lm.del(application, request)) {
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "photo.jsp?CPages=" + curpage + "&blogId=" + blogId));
	}
	else
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
	return;
}
else if (op.equals("delImg")) {
	long photoId = ParamUtil.getLong(request, "photoId");
	ld = ld.getPhotoDb(photoId);
	ld.delImage(Global.getRealPath());
	ld.setImage("");
	if (ld.save(new JdbcTemplate())) {
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "photo.jsp?CPages=" + curpage + "&blogId=" + blogId));
	}
	else
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
	return;
}
%>
<%@ include file="photo_nav.jsp"%>
<script>
$("menu1").className="active";
</script>
<br>
<%
DirDb dd = new DirDb();

int total = 0;
int pagesize = 10;

long catalog = ParamUtil.getLong(request, "catalog", 0);
String sql = "select id from " + ld.getTableName() + " where blog_id=" + blogId + " order by sort desc";
if (catalog!=0)
	sql = "select id from " + ld.getTableName() + " where blog_id=" + blogId + " and catalog=" + catalog + " order by sort desc";

ListResult lr = ld.listResult(sql, curpage, pagesize);
Paginator paginator = new Paginator(request, lr.getTotal(), pagesize);
%>
<table width="98%" border="0" align="center" class="p9">
  <tr>
    <td width="42%" align="left">
	<%
	if (pcd.isLoaded()) {
		out.print("&nbsp;-&nbsp;" + pcd.getString("title"));
	}
	%>	
	</td>
    <td width="58%" align="right"><%=paginator.getPageStatics(request)%></td>
  </tr>
</table>
<table width="98%" align="center" cellPadding="3" cellSpacing="0" class="frame_gray" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">
  <tbody>
    <tr>
      <td width="6%" noWrap class="thead">序号</td>
      <td width="39%" height="24" noWrap class="thead"><lt:Label res="res.label.blog.user.photo" key="name"/></td>
      <td width="12%" noWrap class="thead">专辑</td>
      <td width="5%" noWrap class="thead">评论</td>
      <td width="12%" noWrap class="thead">分类</td>
      <td width="12%" noWrap class="thead">日期</td>
      <td width="14%" noWrap class="thead"><lt:Label res="res.label.blog.user.photo" key="operate"/></td>
    </tr>
<%
PhotoCatalogDb pcd2 = new PhotoCatalogDb();
Iterator ir = lr.getResult().iterator();
int i=100;
while (ir.hasNext()) {
	i++;
 	ld = (PhotoDb)ir.next();
	%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td><%=ld.getSort()%></td>
      <td>
	  <%
		String photoUrl = "";
		String attachmentBasePath = request.getContextPath() + "/upfile/" + ld.photoBasePath + "/";
		if (ld.getImage()==null || ld.getImage().equals(""))
			;
		else{
			com.redmoon.forum.Config cfg = com.redmoon.forum.Config.getInstance();
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
		}
	  %>
	  <a class="tooltips" href="<%=photoUrl%>" target="_blank">        
		<%=StrUtil.toHtml(ld.getTitle())%>
	    <%
		if (!photoUrl.equals("")) {
		%>
			<span><img src="<%=attachmentBasePath+"/"+ld.getImage()%>" border="0" align="absmiddle"></span>	
        <%}%>
		</a></td>
      <td>
	  <%
	  	String cata = "无";
		if (ld.getCatalog()!=0) {
			pcd = (PhotoCatalogDb)pcd2.getQObjectDb(new Long(ld.getCatalog()));
			cata = pcd.getString("title");
		}
	  %>
	  <%=cata%>	  </td>
      <td>
	  <%=ld.isLocked()?"否":"是"%></td>
      <td>
	  <%=dd.getDirDb(ld.getDirCode()).getName()%>
	  </td>
      <td><a href="<%=photoUrl%>" target="_blank"><%=com.redmoon.forum.ForumSkin.formatDate(request, ld.getAddDate())%></a></td>
	  <td>
	  <a href="photo_edit_iframe.jsp?id=<%=ld.getId()%>&blogId=<%=ld.getBlogId()%>"><lt:Label res="res.label.blog.user.photo" key="modify"/></a>&nbsp;
	  <a onClick="if (!confirm('<lt:Label res="res.label.blog.user.photo" key="del_confirm"/>')) return false" href="?op=del&id=<%=ld.getId()%>&blogId=<%=blogId%>">
	  <lt:Label res="res.label.blog.user.photo" key="del"/></a>&nbsp;
	  <a href="photo_comment.jsp?blogId=<%=ld.getBlogId()%>&photoId=<%=ld.getId()%>">评论</a>
      <input name="id" value="<%=ld.getId()%>" type="hidden">
      <input name="blogId" value="<%=blogId%>" type="hidden">	  </td>
    </tr>
<%}%>
</tbody></table>
<table width="98%" border="0" align="center" class="p9">
  <tr>
    <td align="right">&nbsp;
        <%
				String querystr = "blogId=" + blogId + "&catalog=" + catalog;
				out.print(paginator.getPageBlock(request,"?"+querystr));
		%></td>
  </tr>
</table>
</body>
</html>