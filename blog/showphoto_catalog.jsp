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
long catalog = ParamUtil.getLong(request, "catalog", -1);
if (catalog==-1) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "err_id")));
	return;
}

PhotoCatalogDb pcd = new PhotoCatalogDb();
pcd = (PhotoCatalogDb)pcd.getQObjectDb(new Long(catalog));

UserConfigDb ucd = new UserConfigDb();
ucd = ucd.getUserConfigDb(pcd.getLong("blog_id"));
if (!ucd.isLoaded()) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "res.label.blog.list", "activate_blog_fail")));
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
request.setAttribute("pageName", "showphoto_catalog");
%>
<html>
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