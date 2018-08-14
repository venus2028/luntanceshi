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
String userName = ParamUtil.get(request, "username");
as = as.getAuctionShopDb(userName);
if (!as.isLoaded()) {
	return;
}
String rootPath = request.getContextPath();
%>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="2" align="left" valign="top">
	<strong>店铺</strong>：
	<a target="_blank" href="<%=rootPath%>/forum/plugin/auction/shop.jsp?userName=<%=StrUtil.UrlEncode(userName)%>"><%=StrUtil.toHtml(as.getShopName())%></a>&nbsp;&nbsp;	</td>
  </tr>
</table>
