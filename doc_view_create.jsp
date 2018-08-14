<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.util.file.*"%>
<%@ page import="com.cloudwebsoft.framework.template.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
int id = ParamUtil.getInt(request, "id");
Document doc = new Document();
doc = doc.getDocument(id);

if (Leaf.isLeafOfSubsite(doc.getDirCode())) {
	String siteCode = Leaf.getSubsiteOfLeaf(doc.getDirCode()).getCode();
	SiteDb sd = new SiteDb();
	sd = sd.getSiteDb(siteCode);
	
	request.setAttribute("SiteDb", sd);
	request.setAttribute("pageName", "doc");
	request.setAttribute("doc", doc);
%>
<LINK href="<%=sd.getCSS(request)%>" type=text/css rel=stylesheet>
<%
	TemplateLoader tl = new TemplateLoader(request, SiteTemplateImpl.getTemplateCacheKey(sd, SiteTemplateDb.TEMPL_TYPE_MAIN), SiteTemplateImpl.getTemplateContent(sd, "main_content"));
	out.print(tl.toString());
}
else {
	TemplateDb td = doc.getTemplateDb();
	
	String filePath = td.getString("path");
	
	if (filePath.equals("")) {
		filePath = "doc/template/doc_show_default.htm";
	}
	
	filePath = cn.js.fan.web.Global.realPath + filePath;
	TemplateLoader tl = new TemplateLoader(request, filePath);
	out.print(tl);
}

boolean isCreateHtml = ParamUtil.getBoolean(request, "isCreateHtml", false);
if (isCreateHtml) {
	DocumentMgr dm = new DocumentMgr();
	dm.createAllPageHtml(request, doc);
	/*
    String pageNum = (String) ParamUtil.get(request, "CPages");
    if (!StrUtil.isNumeric(pageNum)) {
	    pageNum = "1";
    }
	request.setAttribute("isCreateHtml", "true");
	tl = new TemplateLoader(request, filePath);
	FileUtil fu = new FileUtil();
	fu.WriteFile(cn.js.fan.web.Global.realPath) + doc.getDocHtmlName(Integer.parseInt(pageNum)), tl.toString(), "UTF-8");
	*/
%>	<table width="98%" border="0">
  <tr>
    <td align="center">>> <a href="<%=doc.getDocHtmlName(1)%>" target="_blank">查看生成的静态页面</a></td>
  </tr>
</table>
<%}%>
