<%@ page contentType="text/html;charset=utf-8"%><%@ page import="com.cloudwebsoft.framework.base.*"%><%@ page import="cn.js.fan.module.cms.site.*"%><%@ page import="cn.js.fan.web.*"%><%@ page import="cn.js.fan.util.*"%><%@ page import="com.redmoon.forum.person.*"%><%@ page import="com.redmoon.forum.music.*"%><%@ page import="com.redmoon.forum.ad.*"%><%@ page import="com.redmoon.blog.*"%><%@ page import="com.cloudwebsoft.framework.servlet.*"%><%@ taglib uri="/WEB-INF/tlds/AdTag.tld" prefix="ad_footer"%>
<%
String siteCode = ParamUtil.get(request, "siteCode");
SiteDb sd = new SiteDb();
sd = sd.getSiteDb(siteCode);
String isAutoStart = ParamUtil.get(request, "isAutoStart");
if (isAutoStart.equals(""))
	isAutoStart = "true";
String style = ParamUtil.get(request, "style");
if (style.equals(""))
	style = "default";
request.setAttribute("style", style);	
JspIncluder.include(request, response, out, "../../exobud/" + style + "/exobud.jsp");
%>
<script>
<%
	long blogId = UserConfigMgr.getOrCreateForUser(sd.getString("owner"), false);
	UserConfigDb ucd = new UserConfigDb();
	ucd = ucd.getUserConfigDb(blogId);

	MusicDb mud = new MusicDb();
	String sql = "select id from " + mud.getTable().getName() + " where blog_id=" +
		  ucd.getId() + " and is_bk_music=1 ORDER BY sort asc, add_date desc";

	int pagesize = 20;
	int curpage = 1;

	QObjectBlockIterator obi = mud.getQObjects(sql, "" + ucd.getId(),
			(curpage - 1) * pagesize, curpage * pagesize);

	while (obi.hasNext()) {
		mud = (MusicDb) obi.next();
				
		String link = StrUtil.getNullStr(mud.getString("link"));
		String url = link.equals("") ? mud.getMusicUrl(request) : link;
%>
		mkList("<%=url%>", "<%=cn.js.fan.util.StrUtil.toHtml(mud.getString("title"))%>");
<%	
	}
%>
blnAutoStart = <%=isAutoStart%>;
initExobud();
// startExobud();
</script>