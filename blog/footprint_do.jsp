<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.person.UserDb"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
com.redmoon.forum.Privilege privilege = new com.redmoon.forum.Privilege();
if (!privilege.isUserLogin(request)) {
	out.print(StrUtil.Alert_Back("请先登录!"));
	return;
}
long msgId = ParamUtil.getLong(request, "msgId");
long blogId = ParamUtil.getLong(request, "blogId");
String userName = privilege.getUser(request);
FootprintDb fd = new FootprintDb();
boolean re = false;
try {
	re = fd.create(new JdbcTemplate(), new Object[] {new Long(msgId), new Long(blogId), userName, new java.util.Date()} );
}
catch (ResKeyException e) {
	out.print(StrUtil.Alert_Back(e.getMessage(request)));
}
if (re)
	out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "showblog.jsp?rootid=" + msgId));
else
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));	
%>
