<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%@ page import="com.redmoon.forum.person.*"%>
<%
String skinPath = SkinMgr.getSkinPath(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../../<%=skinPath%>/css.css" rel="stylesheet" type="text/css">
<title><%=Global.AppName%> - 我要开店</title>
</head>
<body>
<div id="wrapper">
<%@ include file="../../inc/header.jsp"%>
<div id="main">
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isUserLogin(request)) {
	out.print(StrUtil.makeErrMsg("请先登录！"));
	return;
}

String shopName = "";
String desc = "";
String tel = "";
String address = "";
String contacter = "";
try {
	shopName = ParamUtil.get(request, "shopName");
	if (shopName.equals(""))
		throw new ErrMsgException("店名不能为空！");
	desc = ParamUtil.get(request, "desc");
	if (desc.equals(""))
		throw new ErrMsgException("简介不能为空！");
	tel = ParamUtil.get(request, "tel");
	if (tel.equals(""))
		throw new ErrMsgException("电话不能为空！");
	address = ParamUtil.get(request, "address");
	if (address.equals(""))
		throw new ErrMsgException("地址不能为空！");
	contacter = ParamUtil.get(request, "contacter");
}
catch (ErrMsgException e) {
	out.print(StrUtil.Alert(e.getMessage()));
	return;
}

boolean re = false;
AuctionShopDb as = new AuctionShopDb();
try {
	as = as.getAuctionShopDb(privilege.getUser(request));
	if (as.isLoaded()) {
		out.print(StrUtil.Alert_Back("您的店铺已存在,不能申请!"));
	}
	else {
		as.setShopName(shopName);
		as.setAddress(address);
		as.setTel(tel);
		as.setDesc(desc);
		as.setUserName(privilege.getUser(request));
		as.setContacter(contacter);
		re = as.create();
	}
}
catch (ResKeyException e) {
	out.print(StrUtil.Alert_Back(e.getMessage(request)));
	return;
}
if (re) {%>
<table class="tableCommon" width="98%"  border="0" align="center" cellpadding="5">
  <tr>
    <td height="36">“<%=Global.AppName%>”祝贺您建店成功！请注意交易的诚信和安全！您的每笔订单都将会保存在社区的数据库中，请收藏管理店铺的地址。<br>
    <br>      
    &gt;&gt; <a href="shop.jsp?id=<%=as.getId()%>">查看我的店铺</a><br>
    <br>
    &gt;&gt;&nbsp;<a href="manager/index.jsp?userName=<%=StrUtil.UrlEncode(privilege.getUser(request))%>">管理我的店铺</a></td>
  </tr>
</table>
<%}%>
</div>
<%@ include file="../../inc/footer.jsp"%>
</div>
</body>
</html>
