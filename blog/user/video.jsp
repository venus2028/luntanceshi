<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.blog.video.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.blog.user.photo" key="title"/></title>
<link href="../../cms/default.css" rel="stylesheet" type="text/css">
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
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">视频</td>
  </tr>
</table>
<%
DirDb dd = new DirDb();
dd = dd.getDirDb("root");
DirView dv = new DirView(dd);
StringBuffer optsBuf = new StringBuffer();
dv.getDirAsOptions(optsBuf, dd, dd.getLayer());
String opts = optsBuf.toString();

long blogId = ParamUtil.getLong(request, "blogId");

UserConfigDb ucd = new UserConfigDb();
ucd = ucd.getUserConfigDb(blogId);

String user = Privilege.getUser(request);

// 检查用户权限
if (!Privilege.canUserDo(request, blogId, Privilege.PRIV_ALL)) {
	out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, SkinUtil.PVG_INVALID)));
	return;
}

VideoMgr lm = new VideoMgr();
VideoDb mud = new VideoDb();

String op = StrUtil.getNullString(request.getParameter("op"));

if (op.equals("add")) {
	try {
		if (lm.create(application, request)) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "video.jsp?blogId=" + blogId));
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}
if (op.equals("edit")) {
	try {
		if (lm.save(application, request)) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "video.jsp?blogId=" + blogId));
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}
if (op.equals("del")) {
	if (lm.del(request)) {
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "video.jsp?blogId=" + blogId));
	}
	else
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
	return;
}
%><br>
<%
String strcurpage = StrUtil.getNullString(request.getParameter("CPages"));
if (strcurpage.equals(""))
	strcurpage = "1";
if (!StrUtil.isNumeric(strcurpage)) {
	out.print(StrUtil.makeErrMsg(SkinUtil.LoadString(request, "err_id")));
	return;
}
int total = 0;
int pagesize = 10;
int curpage = StrUtil.toInt(strcurpage, 1);
	
String sql = "select id from " + mud.getTable().getName() + " where blog_id=" + blogId + " order by id desc";
ListResult lr = mud.listResult(sql, curpage, pagesize);
Paginator paginator = new Paginator(request, lr.getTotal(), pagesize);
%>
<table width="95%" border="0" align="center" class="p9">
  <tr>
    <td align="right"><%=paginator.getPageStatics(request)%>&nbsp;</td>
  </tr>
</table>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="95%" align="center">
  <tbody>
    <tr>
      <td width="18%" height="24" noWrap class="thead"><lt:Label res="res.label.blog.user.photo" key="name"/></td>
      <td width="7%" noWrap class="thead">分类</td>
      <td width="21%" noWrap class="thead">链接</td>
      <td width="4%" noWrap class="thead">评论</td>
      <td width="4%" noWrap class="thead">序号</td>
      <td width="22%" noWrap class="thead"><lt:Label res="res.label.blog.user.photo" key="operate"/></td>
      <td width="28%" noWrap class="thead">&nbsp;</td>
    </tr>
<%
Iterator ir = lr.getResult().iterator();
int i=100;
while (ir.hasNext()) {
	i++;
 	mud = (VideoDb)ir.next();
	%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
	  <form name="form<%=i%>" action="?op=edit&blogId=<%=blogId%>" method="post" enctype="MULTIPART/FORM-DATA">
      <td style="PADDING-LEFT: 10px"><input name=title value="<%=StrUtil.toHtml(mud.getString("title"))%>" size="12"></td>
      <td>
	  	<select name="dir_code">
        	<%=opts%>
      	</select>
	<script>
	  form<%=i%>.dir_code.value = "<%=mud.getString("dir_code")%>";
	</script>	  </td>
      <td>
	  <%if (StrUtil.getNullStr(mud.getString("video")).equals("")) {%>
	  <input name="link" value="<%=mud.getString("link")%>" size="30">
	  <%}else{%>
	  <input value="<%=mud.getVideoUrl(request)%>" size="30" readonly="">
	  <%}%>	  </td>
      <td><input name="is_locked" value="0" type="checkbox" <%=mud.getInt("is_locked")==1?"":"checked"%>>
      </td>
      <td><input name="sort" value="<%=mud.getInt("sort")%>" size="2"></td>
      <td>
	  [ <a href="javascript:form<%=i%>.submit()"><lt:Label res="res.label.blog.user.photo" key="modify"/></a> ] [ <a onClick="if (!confirm('<lt:Label res="res.label.blog.user.photo" key="del_confirm"/>')) return false" href="video.jsp?op=del&id=<%=mud.getLong("id")%>&blogId=<%=blogId%>"><lt:Label res="res.label.blog.user.photo" key="del"/></a> ]
	  <input name="id" value="<%=mud.getLong("id")%>" type="hidden">
	  <input name="blog_id" value="<%=blogId%>" type="hidden">
	  <input name="link2" value="<%=mud.getString("link")%>" type="hidden"></td>
	  <td><span style="PADDING-LEFT: 10px"><%=com.redmoon.forum.ForumSkin.formatDate(request, mud.getDate("add_date"))%>&nbsp;&nbsp;
		<a href="../showvideo.jsp?videoId=<%=mud.getLong("id")%>" target="_blank">
		<img src="../images/video.gif" border="0"></a>
      </span></td>
	  </form>
    </tr>
<%}%>
</tbody></table>
<table width="95%" border="0" align="center" class="p9">
  <tr>
    <td align="right"><%
				String querystr = "blogId=" + blogId;
				out.print(paginator.getPageBlock(request,"?"+querystr));
				%></td>
  </tr>
</table>
<table width="62%" border="0" align="center" cellpadding="3" cellspacing="0" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">
<form action="?op=add&blogId=<%=blogId%>" method="post" enctype="multipart/form-data" name="addform1">
  <tr>
    <td height="24" colspan="2" align="center" class="thead">上传视频</td>
    </tr>
  <tr>
    <td height="24">分类</td>
    <td>
		<select name="dir_code">
		  <%=opts%>
		</select>	</td>
  </tr>
  <tr>
    <td width="15%" height="24">
      <lt:Label res="res.label.blog.user.photo" key="name"/>    </td>
    <td width="85%">
      <input name=title value="">    </td>
  </tr>
  <tr>
    <td height="24">
      视频文件    </td>
    <td><input type="file" name="filename" style="width: 200px"></td>
  </tr>
  <tr>
    <td height="24">链接</td>
    <td>
      <input name=link value="">
      填写链接时，如果有上传的文件将被忽略    </td>
  </tr>
  <tr>
    <td height="24">允许评论</td>
    <td><input name="is_locked" value="0" type="checkbox" checked></td>
  </tr>
  <tr>
    <td height="24">序号</td>
    <td><input name="sort" size="2" value="0">
      <input name="blog_id" value="<%=blogId%>" type="hidden"></td>
  </tr>
  <tr>
    <td colspan="2" align="center"><input name="submit" type=submit value="<lt:Label res="res.label.blog.user.photo" key="add"/>" width=80 height=20></td>
  </tr></form>
</table>
</body>
</html>