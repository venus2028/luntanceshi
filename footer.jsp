<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.ad.*"%>
<%@ taglib uri="/WEB-INF/tlds/CMSAdTag.tld" prefix="ad_footer"%>
<META http-equiv=Content-Type content="text/html;charset=utf-8">
<link rel="stylesheet" type="text/css" href="common.css">
<table width="98%" border="0" align="center">
  <tr>
    <td align="center" valign="bottom" style="font-size: 11px; font-family: Tahoma, Arial">
	<ad_footer:AdTag type="<%=cn.js.fan.module.cms.ad.AdDb.TYPE_FOOTER%>" dirCode='<%=ParamUtil.get(request, "dirCode")%>'></ad_footer:AdTag>	
	Powered by <b>CWBBS</b> <b style="COLOR: #ff9900"><%=Global.getVersion()%></b>&nbsp;    © 2005-2007&nbsp;<a href="http://www.cloudwebsoft.com" style="font-size: 11px; font-family: Tahoma, Arial" target="_blank">Cloud Web Soft</a><br>
	<%=Global.contact%>&nbsp;&nbsp;Email:<a href="mailto:<%=Global.email%>"><%=Global.email%></a><BR />
    <a href="http://www.miibeian.gov.cn"><%=Global.icp%></a><br />
    <a href="<%=Global.getRootPath()%>"><img src="<%=Global.getRootPath()%>/logo.gif" border="0" /></a></td>
  </tr>
</table>
