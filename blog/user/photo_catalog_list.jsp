<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.blog.photo.*"%>
<%@ page import="com.cloudwebsoft.framework.base.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="pragma" content="no-cache">
<link href="../../cms/default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><lt:Label res="res.label.blog.user.dir" key="title"/></title>
<script language="JavaScript">
<!--
function form1_onsubmit() {
}
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
.STYLE2 {color: #FFFFFF}
-->
</style>
<body topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<jsp:useBean id="dir" scope="page" class="com.redmoon.blog.UserDirDb"/>
<%
long blogId = ParamUtil.getLong(request, "blogId", UserConfigDb.NO_BLOG);
if (!com.redmoon.blog.Privilege.canUserDo(request, blogId, "enter")) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

UserConfigDb ucd = new UserConfigDb();
ucd = ucd.getUserConfigDb(blogId);
if (!ucd.isLoaded()) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request,"res.label.blog.list","activate_blog_fail")));
	return;	
}

String user = privilege.getUser(request);

// 检查用户权限
com.redmoon.blog.Privilege pvg = new com.redmoon.blog.Privilege();
if (!pvg.canUserDo(request, blogId, com.redmoon.blog.Privilege.PRIV_ALL)) {
	out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, SkinUtil.PVG_INVALID)));
	return;
}

String op = ParamUtil.get(request, "op");

if (op.equals("add")) {
	QObjectMgr qom = new QObjectMgr();
	PhotoCatalogDb pcd = new PhotoCatalogDb();
	try {
		if (qom.create(request, pcd, "blog_photo_catalog_create")) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "photo_catalog_list.jsp?blogId=" + blogId));
		}
		else {
			out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}

if (op.equals("modify")) {
	QObjectMgr qom = new QObjectMgr();
	PhotoCatalogDb pcd = new PhotoCatalogDb();
	pcd = (PhotoCatalogDb)pcd.getQObjectDb(new Long(ParamUtil.getLong(request, "id")));
	try {
		if (qom.save(request, pcd, "blog_photo_catalog_save")) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "photo_catalog_list.jsp?blogId=" + blogId));
		}
		else {
			out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}

if (op.equals("del")) {
	PhotoCatalogDb pcd = new PhotoCatalogDb();
	pcd = (PhotoCatalogDb)pcd.getQObjectDb(new Long(ParamUtil.getLong(request, "id")));
	if (pcd.del()) {
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "photo_catalog_list.jsp?blogId=" + blogId));
	}
	else {
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
	}
	return;
}
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">管理专辑</td>
  </tr>
</table>
<br>
</td> </tr>             
      </table>                                        
       </td>                                        
     </tr>                                        
 </table>                                        
<table width="86%"  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#666666" class="tableframe_gray">
   <tr align="center">
     <td width="48%" height="26" class="thead">名称</td>
     <td width="52%" class="thead"><lt:Label res="res.label.blog.user.dir" key="operate"/></td>
   </tr>
<%
PhotoCatalogDb sb1 = new PhotoCatalogDb();
Vector v = sb1.list(sb1.getTable().getQueryList(), new Object[] {new Long(blogId)});
Iterator ir = v.iterator();
int i = 2;
while (ir.hasNext()) {
	PhotoCatalogDb as = (PhotoCatalogDb)ir.next();
	i++;
%>
   <form id="form<%=i%>" name="form<%=i%>" action="photo_catalog_list.jsp?op=modify" method="post">
     <tr align="center" bgcolor="#FFFFFF">
       <td height="22"><input type=hidden name=id value="<%=as.getLong("id")%>">
	   <input type="hidden" name="miniature" value="<%=as.getString("miniature")%>">
	   <input type="hidden" name="photo_count" value="<%=as.getInt("photo_count")%>">
       <input name=title value="<%=StrUtil.toHtml(as.getString("title"))%>" size=22></td>
       <td height="22"><input type=hidden name="blogId" value="<%=blogId%>">
           [<a href="#" onClick="form<%=i%>.submit()"><lt:Label key="op_modify"/></a>]
           [<a href="photo.jsp?blogId=<%=blogId%>&catalog=<%=as.getLong("id")%>"><lt:Label res="res.label.blog.user.dir" key="manage"/>]</a>
		   [<a href="#" onClick="if (confirm('<lt:Label key="confirm_del"/>')) window.location.href='photo_catalog_list.jsp?op=del&catalog=<%=as.getLong("id")%>&blogId=<%=blogId%>'"><lt:Label key="op_del"/></a>]</td>
     </tr>
   </form>
<%}
%>
 </table>
 <br>
 <table width="86%" border="0" align="center" cellpadding="3" cellspacing="0" class="frame_gray">
   <form action="photo_catalog_list.jsp?op=add&blogId=<%=blogId%>" method=post id=form1 name=form1 onSubmit="return form1_onsubmit()">
     <tr>
       <td width="192" align="right">&nbsp;</td>
       <td width="636" align="left">&nbsp;
         &nbsp;
         <lt:Label res="res.label.blog.user.dir" key="list_name"/>
         <input name=title size=15>
         <input type="submit" name="Submit" value="<lt:Label key="op_add"/>">
         <input type=hidden name="blog_id" value="<%=blogId%>">
	   </td>
     </tr>
     <tr>
       <td height="22" colspan="2" align="center">(
           <lt:Label res="res.label.blog.user.dir" key="explain"/>
         )</td>
     </tr>
   </form>
 </table>
</body>                                        
</html>                            
  