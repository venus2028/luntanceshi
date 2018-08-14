<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.person.UserSet"%>
<%@ page import="com.redmoon.forum.security.*"%>
<%@ page import="com.redmoon.forum.setup.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.jdom.Element"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
PassportConfig pc = PassportConfig.getInstance();
if (!pc.getBooleanProperty("passport.isUsed")) {
	out.print(StrUtil.Alert_Back("Passport is not used!"));
	return;
}

Passport pp = new Passport();
boolean re = false;
try {
	re = pp.doAction(request, response);
}
catch (ErrMsgException e) {
	out.print(SkinUtil.makeErrMsg(request, e.getMessage()));
	return;
}
if (!re) {
	out.print(StrUtil.Alert_Back("Action failed."));
	return;
}
String forward = ParamUtil.get(request, "forward");
if (!forward.equals("")) {
	response.sendRedirect(forward);
}
else {
	response.sendRedirect("index.jsp");
}
%>