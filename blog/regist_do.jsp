<%@ page contentType="text/html;charset=utf-8"
import = "java.io.File"
import = "cn.js.fan.util.*"
%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="com.redmoon.forum.message.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String skincode = UserSet.getSkin(request);
if (skincode.equals(""))
	skincode = UserSet.defaultSkin;
SkinMgr skm = new SkinMgr();
Skin skin = skm.getSkin(skincode);
if (skin==null)
	skin = skm.getSkin(UserSet.defaultSkin);
String skinPath = skin.getPath();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.regist" key="regist"/> - <%=Global.AppName%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="template/css.css" rel="stylesheet" type="text/css">
</head>
<body>
<br>
<br>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil" />
<jsp:useBean id="userservice" scope="page" class="com.redmoon.forum.person.userservice" />
<jsp:useBean id="form" scope="page" class="cn.js.fan.security.Form" />
<%
com.redmoon.forum.RegConfig cfg = new com.redmoon.forum.RegConfig();
boolean usevcode = cfg.getBooleanProperty("registUseValidateCode");
if (usevcode) {
	String sessionCode = StrUtil.getNullStr((String) session.getAttribute("validateCode"));
	String validateCode = ParamUtil.get(request, "validateCode");
	if (!validateCode.equals(sessionCode)) {
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "res.label.regist", "err_validate_code")));
		return;
	}
}

boolean cansubmit = false;
int interval = cfg.getIntProperty("registInterval");
int maxtimespan = interval;
try {
	cansubmit = form.cansubmit(request, "regist", maxtimespan); // 防止重复刷新	
}
catch (ErrMsgException e) {
	out.println(StrUtil.Alert_Back(e.getMessage()));
	return;
}

boolean isSuccess = false;
try {
	isSuccess = userservice.regist(request, response);
}
catch (ErrMsgException e) {
	out.print(StrUtil.Alert_Back(e.getMessage()));
	return;
}
if (isSuccess) {
	String nick = ParamUtil.get(request, "RegName");
	UserDb ud = new UserDb();
	ud = ud.getUserDbByNick(nick);
	String info = "";
	if (ud.getCheckStatus()==ud.CHECK_STATUS_NOT) {
		RegConfig rc = new RegConfig();
        int regVerify = rc.getIntProperty("regVerify");
		String email = ParamUtil.get(request, "Email");
        if (regVerify==rc.REGIST_VERIFY_EMAIL)
			info = SkinUtil.LoadString(request, "res.forum.Privilege", "info_need_check_email") + " " + email;
        else
			info = SkinUtil.LoadString(request, "res.forum.Privilege", "info_need_check_manual");
	}
	else {
		info = SkinUtil.LoadString(request, "res.label.regist", "regist_success");
	}
	out.println(StrUtil.Alert_Redirect(info, "active.jsp"));
}
else
	out.println(StrUtil.Alert_Back(SkinUtil.LoadString(request, "res.label.regist", "regist_fail")));
%><br>
<br>
</body>
</html>


