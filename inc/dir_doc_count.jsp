<%@ page contentType="text/html;charset=utf-8"%><%@ page import="cn.js.fan.module.cms.*"%><%@ page import="cn.js.fan.util.*"%><%
String dirCode = ParamUtil.get(request, "dirCode");
Leaf lf = new Leaf();
lf = lf.getLeaf(dirCode);
%>document.write("<%=lf.getDocCount()%>");