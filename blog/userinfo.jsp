<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.util.file.*"%>
<%@ page import="com.cloudwebsoft.framework.template.*"%><%
String filePath = cn.js.fan.web.Global.realPath + "blog/template/common.htm";
String username = ParamUtil.get(request, "username");
request.setAttribute("includeUrl", "blog/userinfo_include.jsp?username=" + StrUtil.UrlEncode(username)); 
TemplateLoader tl = new TemplateLoader(request, filePath);
out.print(tl.toString());
%>