<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.cloudwebsoft.framework.web.*"%>
<%@ page import="com.cloudwebsoft.framework.template.*"%><%
if (Global.isSubDomainSupported) {
	if (DomainDispatcher.dispatch(request, response)==1) {
		return;
	}
}

String filePath = cn.js.fan.web.Global.realPath + "template/index.htm";	
TemplateLoader tl = new TemplateLoader(request, filePath);
out.print(tl.toString());
%>