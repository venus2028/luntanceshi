<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
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
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<link href="../../<%=skinPath%>/skin.css" rel="stylesheet" type="text/css">
<title>出价</title>
<style type="text/css">
<!--
body {
	margin-top: 0px;
	margin-left: 0px;
	margin-right: 0px;
}
.style1 {
	color: #525252;
	font-weight: bold;
}
-->
</style></head>
<body>
<%@ include file="../../inc/header.jsp"%>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isUserLogin(request)) {
	out.print(StrUtil.Alert_Back("请先登录！"));
	return;
}

int worthId = 0;
int count = 0;
try {
	worthId = ParamUtil.getInt(request, "worthId");
	count = ParamUtil.getInt(request, "count");
	if (count<=0)
		throw new ErrMsgException("数量必须大于0！");
}
catch (ErrMsgException e) {
	out.print(StrUtil.Alert_Back("数据格式错误！")); // StrUtil.Alert_Back(e.getMessage()));
	return;
}
AuctionWorthDb aw = new AuctionWorthDb();
aw = aw.getAuctionWorthDb(worthId);

AuctionDb ad = new AuctionDb();
ad = ad.getAuctionDb(aw.getMsgRootId());

if (ad.getCount()<count) {
	out.print(SkinUtil.makeErrMsg(request, "对不起，你要买的数量超过了销售数量！"));
	return;
}

if (ad.getUserName().equals(privilege.getUser(request))) {
	out.print(StrUtil.Alert_Back("对不起，您自己不能购买！"));
	return;
}

boolean re = false;
AuctionOrderDb ao = new AuctionOrderDb();
try {
	re = ao.makeOrderForSell(aw, privilege.getUser(request), count);
}
catch (ErrMsgException e) {
	out.print(StrUtil.Alert_Back(e.getMessage()));
}
catch (ResKeyException e1) {
	out.print(StrUtil.Alert_Back(e1.getMessage(request)));
}
if (re)
	out.print(StrUtil.Alert_Redirect("购买完成，点击查看生成的订单！", "showorder.jsp?orderId=" + ao.getId()));
%>
</body>
</html>
