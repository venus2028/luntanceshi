<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.util.file.*"%>
<%@ page import="com.cloudwebsoft.framework.template.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %><%
int id = ParamUtil.getInt(request, "id");
String dirCode = ParamUtil.get(request, "dirCode");

SubjectDb sd = new SubjectDb();
sd = sd.getSubjectDb(dirCode);

TemplateDb td = new TemplateDb();
if (sd.getPageTemplateId()!=SubjectDb.NOTEMPLATE) {
	td = td.getTemplateDb(sd.getPageTemplateId());
}
else {
	Document doc = new Document();
	doc = doc.getDocument(id);
	td = doc.getTemplateDb();
}

String filePath = td.getString("path");

// System.out.println(getClass() + " " + doc.getTitle() + " filePath=" + filePath);

filePath = cn.js.fan.web.Global.realPath + filePath;
TemplateLoader tl = new TemplateLoader(request, filePath);
out.print(tl.toString());
%>