<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.blog.ui.*"%>
<%@ page import="com.redmoon.blog.template.*"%>
<%@ page import="com.redmoon.forum.SQLBuilder"%>
<%@ page import="com.redmoon.forum.MsgUtil"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.util.file.*"%>
<%@ page import="com.cloudwebsoft.framework.template.*"%>
<%
String blogUserName = ParamUtil.get(request, "blogUserName");
long blogId = UserConfigDb.NO_BLOG;
UserConfigDb ucd = new UserConfigDb();
if (!blogUserName.equals("")) {
	ucd = ucd.getUserConfigDbByUserName(blogUserName);
	if (ucd!=null)
		blogId = ucd.getId();
}
else {
	blogId = ParamUtil.getLong(request, "blogId", UserConfigDb.NO_BLOG);
	ucd = ucd.getUserConfigDb(blogId);
}
if (ucd==null || !ucd.isLoaded()) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "res.label.blog.myblog", "myblog_alert")));
	return;
}
else {
	if (ucd.isOpen()) {
		ucd.setViewCount(ucd.getViewCount() + 1);
		ucd.save();
	}
}

TemplateDb td = new TemplateDb();
td = td.getTemplateDb(StrUtil.toInt(ucd.getSkin()));
if (td==null) {
	td = new TemplateDb();
	td = td.getDefaultTemplateDb();
}

request.setAttribute("UserConfigDb", ucd);
request.setAttribute("template", td);
request.setAttribute("pageName", "myblog");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=ucd.getTitle()%> - <%=ucd.getPenName()%> - <%=Global.AppName%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script tyle="text/javascript" language="javascript" src="../spwhitepad/createShapes.js"></script>
<LINK href="<%=ucd.getCSS(request)%>" type=text/css rel=stylesheet>
</head>
<body>
<%@ include file="header.jsp"%>
<%
TemplateLoader tl = new TemplateLoader(request, BokeTemplateImpl.getTemplateCacheKey(ucd, TemplateDb.TEMPL_TYPE_MAIN), BokeTemplateImpl.getTemplateContent(ucd, "main_content"));
out.print(tl.toString());
%>
<%@ include file="footer.jsp"%>
</body>
</html>