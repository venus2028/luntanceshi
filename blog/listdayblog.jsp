<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.blog.ui.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.blog.template.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.cloudwebsoft.framework.template.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
long blogId = ParamUtil.getLong(request, "blogId", UserConfigDb.NO_BLOG);
UserConfigDb ucd = new UserConfigDb();
ucd = ucd.getUserConfigDb(blogId);
if (!ucd.isLoaded()) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request,"res.label.blog.list","activate_blog_fail")));
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
request.setAttribute("pageName", "listdayblog");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=ucd.getTitle()%> - <%=ucd.getPenName()%> - <%=Global.AppName%></title>
<LINK href="<%=ucd.getCSS(request)%>" type=text/css rel=stylesheet>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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