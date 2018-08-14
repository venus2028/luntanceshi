<%@ page contentType="text/html;charset=utf-8"%><%@ page import="cn.js.fan.web.*"%><%@ page import="com.redmoon.forum.person.*"%><%@ page import="com.redmoon.forum.music.*"%><%@ page import="com.redmoon.forum.ad.*"%><%@ page import="com.redmoon.forum.plugin.*"%><%@ taglib uri="/WEB-INF/tlds/AdTag.tld" prefix="ad_footer"%>
<div id="footer">
<table width="98%" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr>
    <td align="center" valign="bottom" style="font-size: 11px; font-family: Tahoma, Arial; line-height:180%">
	<%
	String fCode = com.redmoon.forum.UserSession.getBoardCode(request);
	%>
	<ad_footer:AdTag type="<%=AdDb.TYPE_FOOTER%>" boardCode="<%=fCode%>"></ad_footer:AdTag>
	Powered by <b>CWBBS</b> <b style="COLOR: #ff9900"><%=Global.getVersion()%></b>&nbsp;    © 2005-2007&nbsp;<a href="http://www.cloudwebsoft.com" style="font-size: 11px; font-family: Tahoma, Arial" target="_blank">Cloud Web Soft</a>&nbsp;&nbsp;<%=Global.isGZIPEnabled?"Gzip enabled":""%>&nbsp;&nbsp;<a href="<%=request.getContextPath()%>/forum/wap/index.jsp">wap2.0</a>	<br>
	<%=Global.contact%>&nbsp;&nbsp;Email:<a href="mailto:<%=Global.email%>"><%=Global.email%></a><BR />
    <a href="http://www.miibeian.gov.cn"><%=Global.icp%></a><br />
    <a href="<%=Global.getRootPath()%>"><img src="<%=Global.getRootPath()%>/logo.gif" border="0" /></a>	</td>
  </tr>
</table>
</div>
<%
PluginMgr pmFooter = new PluginMgr();
java.util.Iterator irPluginFooter = pmFooter.getAllPlugin().iterator();
while (irPluginFooter.hasNext()) {
	com.redmoon.forum.plugin.PluginUnit puFooter = (com.redmoon.forum.plugin.PluginUnit)irPluginFooter.next();
	com.redmoon.forum.plugin.base.IPluginUI ipuFooter = puFooter.getUI(request, response, out);
	com.redmoon.forum.plugin.base.IPluginViewCommon pvcFooter = ipuFooter.getViewCommon();
	if (pvcFooter!=null) {
		out.print(pvcFooter.render(com.redmoon.forum.plugin.base.IPluginViewCommon.POS_FOOTER));
	}
}

boolean isFooMusic = false;
com.redmoon.forum.Config foocfg = com.redmoon.forum.Config.getInstance();
if (foocfg.getBooleanProperty("forum.isBkMusic")) {
	// 判别用户等级
	int fooMusicLevel = foocfg.getIntProperty("forum.bkMusicUserLevel");
	if (fooMusicLevel>0) {
		if (com.redmoon.forum.Privilege.isUserLogin(request)) {
			UserDb fooUser = new UserDb();
			fooUser = fooUser.getUser(com.redmoon.forum.Privilege.getUser(request));
			if (fooUser.getUserLevelDb().getLevel()>=fooMusicLevel) {
				isFooMusic = true; ;
			}
		}
	}
	else
		isFooMusic = true;
}
if (isFooMusic) {
%>
<%@ include file="../../exobud/exobud.jsp"%>
<script>
<%
	MusicFileDb fmfd = new MusicFileDb();
	String fsql = "select id from " + fmfd.getTableName() + " order by upload_date desc";
	long footerCount = fmfd.getObjectCount(fsql);
	com.cloudwebsoft.framework.base.ObjectBlockIterator fobi = fmfd.getObjects(fsql, 0, (int)footerCount);
	while (fobi.hasNext()) {
		fmfd = (MusicFileDb)fobi.next();
%>
		mkList("<%=fmfd.getMusicUrl(request)%>", "<%=cn.js.fan.util.StrUtil.toHtml(fmfd.getName())%>");
<%	
	}
	String isAutoStart = "true";
	if (com.redmoon.forum.Privilege.isUserLogin(request)) {
		UserPropDb up = new UserPropDb();
		up = up.getUserPropDb(com.redmoon.forum.Privilege.getUser(request));
		if (up.getInt("is_music_autostart")==0) {
			isAutoStart = "false";
		}
	}
%>
blnAutoStart = <%=isAutoStart%>;
initExobud();
// startExobud();
</script>
<%}%>