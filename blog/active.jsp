<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.cloudwebsoft.framework.template.*"%><%
String filePath = cn.js.fan.web.Global.realPath + "blog/template/common.htm";
request.setAttribute("includeUrl", "blog/active_include.jsp"); 
TemplateLoader tl = new TemplateLoader(request, filePath);
out.print(tl.toString());
%>