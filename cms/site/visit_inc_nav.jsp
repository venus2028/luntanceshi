<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ page import="cn.js.fan.module.nav.*" %>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%
String siteCodeNav = ParamUtil.get(request, "siteCode");
%>
<DIV id="tabBar">
  <div class="tabs">
    <ul>
      <li id="menu1"><a href="<%=request.getContextPath()%>/cms/counter/showcount_site.jsp?siteCode=<%=StrUtil.UrlEncode(siteCodeNav)%>">首页访问统计</a></li>
      <li id="menu3"><a href="<%=request.getContextPath()%>/cms/site/visit_dir_statistic.jsp?siteCode=<%=StrUtil.UrlEncode(siteCodeNav)%>">目录访问统计</a></li>
      <li id="menu4"><a href="<%=request.getContextPath()%>/cms/site/visit_doc_statistic.jsp?siteCode=<%=StrUtil.UrlEncode(siteCodeNav)%>">文章访问统计</a></li>
      <li id="menu5"><a href="<%=request.getContextPath()%>/cms/site/visit_ip_statistic.jsp?siteCode=<%=StrUtil.UrlEncode(siteCodeNav)%>">来访者位置</a></li>	  
    </ul>
  </div>
</DIV>