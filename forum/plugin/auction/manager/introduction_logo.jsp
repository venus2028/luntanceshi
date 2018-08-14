<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<LINK href="default.css" type=text/css rel=stylesheet>
<title>修改简介</title>
</head>
<body>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
	if (!privilege.isUserLogin(request)) {
		out.print(StrUtil.makeErrMsg("请先登录！"));
		return;
	}

	AuctionShopMgr asm = new AuctionShopMgr();
	try {
		if (asm.modifyLogo(application, request))
			out.print(StrUtil.Alert_Redirect("Logo修改成功！", "introduction.jsp?userName=" + StrUtil.UrlEncode(asm.getUserName())));
		else
			out.print(StrUtil.Alert_Back("Logo修改失败！"));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
%>
</body>
</html>
