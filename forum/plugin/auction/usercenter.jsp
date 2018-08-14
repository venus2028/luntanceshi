<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.cloudwebsoft.framework.base.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
AuctionShopDb as = new AuctionShopDb();
as = as.getAuctionShopDb(privilege.getUser(request));
if (!as.isLoaded()) {
	return;
}
String rootPath = request.getContextPath();
String userName = privilege.getUser(request);
%>
<table width="100%" border="0" cellpadding="5" cellspacing="1">
  <tr>
    <td colspan="2" align="left" valign="top">
	<strong>店铺管理</strong>：
	<a target="_blank" href="<%=rootPath%>/forum/plugin/auction/shop.jsp?userName=<%=StrUtil.UrlEncode(userName)%>">查看店铺</a>&nbsp;&nbsp;
	<a target="_blank" href="<%=rootPath%>/forum/plugin/auction/manager/index.jsp?userName=<%=StrUtil.UrlEncode(userName)%>">管理我的店铺</a>&nbsp;&nbsp;
	<a target="_blank" href="<%=rootPath%>/forum/plugin/auction/manager/myorder.jsp?showType=buyer&userName=<%=StrUtil.UrlEncode(userName)%>">我购买的订单</a>&nbsp;&nbsp;
	<a target="_blank" href="<%=rootPath%>/forum/plugin/auction/manager/myorder.jsp?showType=seller&userName=<%=StrUtil.UrlEncode(userName)%>">我销售的订单</a>  </tr>
</table>
