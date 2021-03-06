<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.photo.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.blog.ui.*"%>
<%@ page import="com.cloudwebsoft.framework.template.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
long id = ParamUtil.getLong(request, "photoId", -1);
if (id==-1) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "err_id")));
	return;
}

PhotoDb pd = new PhotoDb();
pd = pd.getPhotoDb(id);

UserConfigDb ucd = new UserConfigDb();
ucd = ucd.getUserConfigDb(pd.getBlogId());
if (!ucd.isLoaded()) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "res.label.blog.list", "activate_blog_fail")));
	return;
}

String op = ParamUtil.get(request, "op");
if (op.equals("add")) {
	QObjectMgr qom = new QObjectMgr();
	PhotoCommentDb pcd = new PhotoCommentDb();
	try {
		if (qom.create(request, pcd, "blog_photo_comment_create")) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "showphoto.jsp?photoId=" + id));
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

if (op.equals("delComment")) {
	boolean canDel = false;
	com.redmoon.blog.Privilege blogPvg = new com.redmoon.blog.Privilege();
	try {
		if (blogPvg.canUserDo(request, ucd.getId(),
								com.redmoon.blog.Privilege.PRIV_ALL)) {
			canDel = true;
		}
	} catch (ErrMsgException e) {
		out.print(SkinUtil.makeErrMsg(request, e.getMessage()));
		return;
	}
	if (!canDel) {
		out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, "pvg_invalid")));
		return;
	}
	long cmtId = ParamUtil.getLong(request, "cmtId");
	PhotoCommentDb pcd = new PhotoCommentDb();
	pcd = (PhotoCommentDb)pcd.getQObjectDb(new Long(cmtId));
	if (pcd.del()) {
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "showphoto.jsp?photoId=" + id));
	}
	else {
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
	}
	return;
}

TemplateDb td = new TemplateDb();
td = td.getTemplateDb(StrUtil.toInt(ucd.getSkin()));
if (td==null) {
	td = new TemplateDb();
	td = td.getDefaultTemplateDb();
}

request.setAttribute("UserConfigDb", ucd);
request.setAttribute("template", td);
request.setAttribute("pageName", "showphoto");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=ucd.getPenName()%> - <%=Global.AppName%></title>
<LINK href="<%=ucd.getCSS(request)%>" type=text/css rel=stylesheet>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script>
function openWin(url,width,height){
	var newwin = window.open(url,"_blank","scrollbars=yes,resizable=yes,toolbar=no,location=no,directories=no,status=no,menubar=no,top=50,left=120,width="+width+",height="+height);
}
</script>
</head>
<body>
<%@ include file="header.jsp"%>
<%
TemplateLoader tl = new TemplateLoader(request, td.getCacheKey(TemplateDb.TEMPL_TYPE_MAIN), td.getString("main_content"));
out.print(tl.toString());
%>
<%@ include file="footer.jsp"%>
</body>
</html>