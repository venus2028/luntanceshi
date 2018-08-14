<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="cn.js.fan.security.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.pvg.Privilege"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="java.util.Calendar" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../common.css" rel="stylesheet" type="text/css">
<link href="default.css" rel="stylesheet" type="text/css">
<jsp:useBean id="strutil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<%
Privilege privilege = new Privilege();
if (!privilege.isUserPrivValid(request, "admin"))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

int id = ParamUtil.getInt(request, "id");
String dirCode = ParamUtil.get(request, "dir_code");
String value = ParamUtil.get(request, "value");
try {
	if (docmanager.UpdateIsHome(request, id, privilege)) {
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), "document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(dirCode)));
	}
	else
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_operate_fail")));
}
catch (ErrMsgException e) {
	out.print(e.getMessage());
}
%>
</body>
</html>