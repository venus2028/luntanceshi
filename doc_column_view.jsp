<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.cloudwebsoft.framework.template.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %><%
String dirCode = ParamUtil.get(request, "dirCode");
Leaf lf = new Leaf();
lf = lf.getLeaf(dirCode);
if (lf==null) {
	out.print(SkinUtil.makeErrMsg(request, "栏目" + dirCode + "不存在!"));
	return;
}
TemplateDb td = lf.getTemplateDb();
String filePath = Global.realPath + td.getString("path");
// System.out.println(getClass() + " filePath=" + filePath);
TemplateLoader tl = new TemplateLoader(request, filePath);
out.print(tl.toString());
%>