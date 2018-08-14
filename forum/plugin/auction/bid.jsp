<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isUserLogin(request)) {
	out.print(StrUtil.Alert_Back("请先登录！"));
	return;
}

long msgRootId = 0;
String name = "";
double price;
try {
	msgRootId = ParamUtil.getLong(request, "msgRootId");
	name = privilege.getUser(request);
	price = ParamUtil.getDouble(request, "bitPrice");
}
catch (ErrMsgException e) {
	out.print(StrUtil.Alert_Back("数据格式错误！")); // StrUtil.Alert_Back(e.getMessage()));
	return;
}
AuctionDb ad = new AuctionDb();
ad = ad.getAuctionDb(msgRootId);

if (ad.getUserName().equals(name)) {
	out.print(StrUtil.Alert_Back("对不起，您自己不能出价！"));
	return;
}

// 判别是否已到截止日期
java.util.Date endDate = ad.getEndDate();
java.util.Date curDate = new java.util.Date();
curDate.setTime(System.currentTimeMillis());
if (DateUtil.compare(endDate, curDate)!=1) {
	out.print(StrUtil.Alert_Back("对不起，拍卖已结束！"));
	return;
}

AuctionWorthDb aw = new AuctionWorthDb();
Vector awv = aw.list(msgRootId);
aw = (AuctionWorthDb)awv.get(0);

double dlt = aw.getDlt();

double curBidPrice = ad.getCurBidPrice();
// 检查出价是否小于 最后价格 + 最小加价
if (curBidPrice==0) {
	if (price<aw.getPrice()+dlt) {
		out.print(StrUtil.Alert_Back("出价太低了，必须大于或等于底价加最小加价！"));	
		return;
	}
}
else {
	if (price<curBidPrice+dlt) {
		out.print(StrUtil.Alert_Back("出价太低了，必须大于或等于当前价格加最小加价！"));	
		return;
	}
}

AuctionBidDb ab = new AuctionBidDb();
ab = ab.getLastBid(msgRootId);
// 检查本人是否已是最后一个出价
if (ab!=null && ab.getName().equals(name)) {
	out.print(StrUtil.Alert_Back("您已是出价最高者！"));
	return;
}
	
boolean re = false;
try {
	ab = new AuctionBidDb();
	ab.setMsgRootId(msgRootId);
	ab.setName(name);
	ab.setPrice(price);
	re = ab.create();
}
catch (ErrMsgException e) {
	out.print(StrUtil.Alert_Back(e.getMessage()));
}
catch (ResKeyException e1) {
	out.print(StrUtil.Alert_Back(e1.getMessage(request)));
}
if (re)
	out.print(StrUtil.Alert_Redirect("出价成功！", "../../showtopic.jsp?rootid=" + msgRootId));
%> 
