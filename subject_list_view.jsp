<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.file.*"%>
<%@ page import="com.cloudwebsoft.framework.template.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %><%
String dirCode = ParamUtil.get(request, "dirCode");
SubjectDb sd = new SubjectDb();
sd = sd.getSubjectDb(dirCode);
if (sd==null) {
	out.print(SkinUtil.makeErrMsg(request, "目录" + dirCode + "不存在!"));
	return;
}
TemplateDb td = sd.getTemplateDb();
String filePath = Global.realPath + td.getString("path");

TemplateLoader tl = new TemplateLoader(request, filePath);
out.print(tl.toString());
%>