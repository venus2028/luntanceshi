<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="cn.js.fan.module.cms.plugin.software.*"%>
<%
com.redmoon.forum.Privilege pvg = new com.redmoon.forum.Privilege();
cn.js.fan.module.cms.plugin.software.Config cfg = cn.js.fan.module.cms.plugin.software.Config.getInstance();
if (cfg.getBooleanProperty("isNeedLogin")) {
	if (!pvg.isMasterLogin(request) && !pvg.isUserLogin(request)) {
		response.sendRedirect(request.getContextPath() + "/info.jsp?op=login&privurl=" + StrUtil.getUrl(request) + "&info=" + StrUtil.UrlEncode("请先登录"));
		return;
	}
}
int softId = 0;
int urlId = 0;
try {
softId = ParamUtil.getInt(request, "softId");
urlId = ParamUtil.getInt(request, "urlId");
}
catch (ErrMsgException e) {
	out.print(SkinUtil.makeErrMsg(request, "参数错误！"));
	return;
}
SoftwareDocumentDb sdd = new SoftwareDocumentDb();
sdd = sdd.getSoftwareDocumentDb(softId);
sdd.setDownloadCount(sdd.getDownloadCount() + 1);
sdd.save();

String userName = pvg.getUser(request);
SoftwareDownloadDb sfdd = new SoftwareDownloadDb();
sfdd.create(new JdbcTemplate(), new Object[]{new Long(SequenceMgr.nextID(SequenceMgr.CMS_SOFTWARE_DOWNLOAD)), new Integer(sdd.getDocId()), userName, new java.util.Date(), StrUtil.getIp(request)});

String[] ary = sdd.getUrlAry();
if (!ary[urlId].startsWith("http") && !ary[urlId].startsWith("ftp")) {
	response.sendRedirect(Global.getRootPath() + "/" + ary[urlId]);
}
else {
	response.sendRedirect(ary[urlId]);
}
%>