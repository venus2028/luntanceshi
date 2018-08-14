<%@ page contentType="text/html;charset=utf-8"%><%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="com.redmoon.forum.Config"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.redmoon.forum.security.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String skinPath = SkinMgr.getSkinPath(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<LINK href="forum/<%=skinPath%>/css.css" type=text/css rel=stylesheet>
<title><lt:Label res="res.label.login" key="login"/> - <%=Global.AppName%></title>
</head>
<body>
<div id="wrapper">
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
boolean isValid = true;
try {
	isValid = LoginMonitor.canLogin(request);
}
catch (ErrMsgException e)
{
	out.print(SkinUtil.makeErrMsg(request, e.getMessage()));
	return;
}

boolean re = false;
if (isValid) {
/*==========UCenter==========*/
	com.redmoon.forum.ucenter.UCenterConfig myconfig = com.redmoon.forum.ucenter.UCenterConfig.getInstance();
	Element uc = myconfig.getRootElement().getChild("uc");
	boolean isUcActive = myconfig.getBooleanProperty("uc.isActive");
	if(isUcActive) {
		try {
			String userName = ParamUtil.get(request, "name");
			String pwd = ParamUtil.get(request, "pwd");
			out.print(com.redmoon.forum.ucenter.UC.login(userName, pwd));
		} catch (ErrMsgException e) {
			out.print(SkinUtil.makeErrMsg(request, e.getMessage()));
			return;
		}
	}
/*==========UCenter==========*/
	String msg = "";
	try{
		if(isUcActive) {
			String userName = ParamUtil.get(request, "name");
			UserDb ud = new UserDb();
			ud = ud.getUserDbByNick(userName);
			if(ud!=null){
				Config cfg = Config.getInstance();
				if (cfg.getBooleanProperty("forum.loginUseValidateCode")) {
					if (!privilege.isValidateCodeRight(request)) {
						throw new ErrMsgException(privilege.LoadString(request, "err_validate_code"));
					}
				}
				IPMonitor im = new IPMonitor();
        		if (!im.isValid(request, StrUtil.getIp(request))) {
            		throw new ErrMsgException(im.getMessage());
        		}
				re = privilege.doLogin(request, response, ud);	
			}//ucenter如果登陆失败不会进行到这，所以不需要验证密码
		} else {
			re = privilege.login(request, response);
		}
	}
	catch(WrongPasswordException e){
		msg = e.getMessage();
	}
	catch (InvalidNameException e) {
		msg = e.getMessage();
	}
	catch (ErrMsgException e) {
		msg = e.getMessage();
	}
	
	try {
		LoginMonitor.afterLogin(request, re, true);
	}
	catch (ErrMsgException e) {
		// msg = SkinUtil.makeErrMsg(request, msg + "<BR>" + e.getMessage());
		msg += "\r\n" + e.getMessage();
	}
	if (!msg.equals("")) {
		response.sendRedirect("info.jsp?op=login&info=" + StrUtil.UrlEncode(msg));
		return;
	}
}
%>
<%@ include file="forum/inc/header.jsp"%>
<div id="main">
<%
if (re) {
	String privurl = ParamUtil.get(request, "privurl");
	if (privurl.equals(""))
		privurl = "forum/index.jsp";
%>
	<ol><lt:Label res="res.label.login" key="login_success"/></ol>
<%		
	out.print(StrUtil.waitJump("<a href='"+privurl+"'>" + SkinUtil.LoadString(request,"res.label.login","return_front") + "</a>", 1, privurl));
}
%>
	<br />
	<br />
</div>	
<%@ include file="forum/inc/footer.jsp"%>
</div>
</body>
</html>
