<%@ page contentType="text/html;charset=utf-8"%><%@ page import="cn.js.fan.module.cms.util.*"%><%@ page import="com.redmoon.forum.*"%><%@ page import="cn.js.fan.module.cms.*"%><%@ page import="cn.js.fan.util.*"%><%
String siteCode = ParamUtil.get(request, "siteCode");
String pageName = ParamUtil.get(request, "pageName");
out.print(HomeStatistic.renderSite(request, "", siteCode, 6));
%>