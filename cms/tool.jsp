<%@ page contentType="text/html; charset=utf-8"%><%@ page import="java.util.*"%><%@ page import="cn.js.fan.util.*"%><%@ page import="cn.js.fan.db.*"%><%@ page import="cn.js.fan.web.*"%><%@ page import="cn.js.fan.module.cms.*" %><%@ page import="cn.js.fan.module.pvg.*" %><%
String op = ParamUtil.get(request, "op");
if (op.equals("getPingYin")) {
	String str = ParamUtil.get(request, "str");
	String parentCode = ParamUtil.get(request, "parentCode");
	response.setContentType("text/xml;charset=UTF-8");
	String r = "";
	r = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
	r += "<ret>\n";
	r += "<pingYin>";
	if (parentCode.equals(cn.js.fan.module.cms.Leaf.ROOTCODE))
		r += com.cloudwebsoft.framework.util.Cn2Spell.converterToFirstSpell(str);
	else
		r += parentCode + "_" + com.cloudwebsoft.framework.util.Cn2Spell.converterToFirstSpell(str);
	
	r += "</pingYin>\n";
	r += "</ret>";
	out.print(r);
}
else if (op.equals("getChildren")) {
	String parentCode = ParamUtil.get(request, "parentCode");
	Directory dir = new Directory();
	Leaf lf = dir.getLeaf(parentCode);
	if (lf==null)
		lf = dir.getLeaf(Leaf.ROOTCODE);
	DirectoryView dv = new DirectoryView(lf);
	%>
	<select name="fDirCode">
	<%
	dv.ShowDirectoryAsOptions(out, lf, lf.getLayer());
	%>
	</select>
	<%
}
%>