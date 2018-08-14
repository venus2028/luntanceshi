<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.util.file.*"%>
<%@ page import="com.cloudwebsoft.framework.template.*"%>
<%
String siteCode = ParamUtil.get(request, "siteCode");
SiteDb sd = new SiteDb();
sd = sd.getSiteDb(siteCode);

if (sd==null) {
	out.print(StrUtil.Alert_Back("该站点不存在"));
	return;
}

if (sd.getInt("site_status")==SiteDb.STATUS_NOT_CHECKED) {
	out.print(StrUtil.Alert_Back("该站点正在等待审核通过中..."));
	return;
}
else if (sd.getInt("site_status")==SiteDb.STATUS_CLOSE) {
	out.print(StrUtil.Alert_Back("该站点已关闭"));
	return;
}
if (sd.getInt("site_status")==SiteDb.STATUS_FORBID) {
	out.print(StrUtil.Alert_Back("该站点已被禁止"));
	return;
}

Leaf lf = new Leaf();
lf = lf.getLeaf(siteCode);

SiteTemplateDb std = new SiteTemplateDb();
std = std.getSiteTemplateDb(sd.getInt("skin"));
if (std==null) {
	std = new SiteTemplateDb();
	std = std.getDefaultSiteTemplateDb();
}


int docId = ParamUtil.getInt(request, "docId", -1);
if (docId==-1) {
	String dirCode = ParamUtil.get(request, "dirCode");
	if (!dirCode.equals("")) {
		Leaf leaf = new Leaf();
		leaf = leaf.getLeaf(dirCode);
		if (leaf!=null && leaf.getType()==Leaf.TYPE_DOCUMENT) {
			docId = leaf.getDocID();
		}
	}
	if (docId==-1) {
		out.print(StrUtil.Alert_Back("标识非法！"));
		return;
	}
}

Document doc = new Document();
doc = doc.getDocument(docId);
if (doc==null || !doc.isLoaded()) {
	out.print(SkinUtil.makeErrMsg(request, "文章不存在！"));
	return;
}

request.setAttribute("SiteDb", sd);
request.setAttribute("pageName", "doc");
request.setAttribute("doc", doc);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=lf.getName()%> - <%=Global.AppName%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<LINK href="<%=sd.getCSS(request)%>" type=text/css rel=stylesheet>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
</head>
<body>
<%
TemplateLoader tl = new TemplateLoader(request, SiteTemplateImpl.getTemplateCacheKey(sd, SiteTemplateDb.TEMPL_TYPE_MAIN), SiteTemplateImpl.getTemplateContent(sd, "main_content"));
out.print(tl.toString());
%>
</body>
</html>