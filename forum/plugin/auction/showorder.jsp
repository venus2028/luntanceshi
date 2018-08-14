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
<LINK href="manager/default.css" type=text/css rel=stylesheet>
<title><%=Global.AppName%> - 查看订单</title>
<style type="text/css">
<!--
body {
	margin-top: 0px;
	margin-left: 0px;
	margin-right: 0px;
}
.style1 {
	font-size: 10pt;
	font-weight: bold;
}
.style2 {
	color: #FF0000;
	font-weight: bold;
}
.style3 {
	color: #0000FF;
	font-weight: bold;
}
.style6 {color: #FF6633}
-->
</style>
<script>
function getradio(myitem)
{
     var radioboxs = document.all.item(myitem);
     if (radioboxs!=null)
     {
	   //如果只有一个radio
	   if (radioboxs.length==null) {
		if (radioboxs.type=="radio" && radioboxs.checked)
			return radioboxs.value;
		else
			return "";
	   }
	   for (i=0; i<radioboxs.length; i++)
       {
            if (radioboxs[i].type=="radio" && radioboxs[i].checked)
            {
                 return radioboxs[i].value;
            }
       }
     }
	 return "";
}

function setRadioChecked(myitem, val)
{
     var radioboxs = document.all.item(myitem);
     if (radioboxs!=null)
     {
	   //如果只有一个radio
	   if (radioboxs.length==null) {
			if (radioboxs.type=="radio") {
            	if (radioboxs[i].value==val) {
			 	radioboxs[i].checked = true;
				return
			 	}
			}
	   }
	   for (i=0; i<radioboxs.length; i++)
       {
            if (radioboxs[i].type=="radio")
            {
                 if (radioboxs[i].value==val) {
				 	radioboxs[i].checked = true;
					return
				 }
            }
       }
     }
	 return "";
}

function openWin(url,width,height)
{
  var newwin = window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,top=50,left=120,width="+width+",height="+height);
}
</script>
</head>
<body>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<jsp:useBean id="pvg" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserLogin(request) && !privilege.isMasterLogin(request)) {
	out.print(StrUtil.makeErrMsg("请先登录！"));
	return;
}

int orderId = ParamUtil.getInt(request, "orderId");

AuctionOrderDb ao = new AuctionOrderDb();
ao = ao.getAuctionOrderDb(orderId);
if (!ao.isLoaded()) {
	out.print(StrUtil.Alert_Back("该订单不存在！"));
	return;
}

String op = ParamUtil.get(request, "op");
String user = privilege.getUser(request);

// 能看订单的人包括：买家、卖家、管理员
boolean isValid = false;
if (user.equals(ao.getSeller()))
	isValid = true;
else if (user.equals(ao.getBuyer()))
	isValid = true;
// 检查是否为管理员
if (!isValid) {
	if (privilege.isMasterLogin(request))
		isValid = true;
}
if (!isValid) {
	out.print("对不起，您无权查看此订单！");
	return;
}
if (op.equals("pay")) {
	if (ao.getBuyer().equals(user)) {
		int st = ao.getState();
		st = st | ao.STATE_PAY;
		ao.setState(st);
		ao.setPayTime(new java.util.Date(System.currentTimeMillis()));
		if (ao.save())
			out.print(StrUtil.Alert("设置成功！"));
	}
	else
		out.print(StrUtil.Alert("对不起，您不是买家！"));
	
}
if (op.equals("delivery")) {
	if (ao.getSeller().equals(user)) {
		int st = ao.getState();
		st = st | ao.STATE_DELIVERY;
		ao.setState(st);
		ao.setDeliverTime(new java.util.Date(System.currentTimeMillis()));		
		if (ao.save()) {
			out.print(StrUtil.Alert("设置成功！"));
            if (ao.getAuctionSellType()==AuctionDb.SELL_TYPE_SELL) {
                  // 减少商品的数量
				  AuctionDb ad = new AuctionDb();
				  ad = ad.getAuctionDb(ao.getAuctionId());
				  ad.setCount(ad.getCount()-ao.getAmount());
				  ad.save();
            }			
		}
	}
	else
		out.print(StrUtil.Alert("对不起，您不是卖家！"));
}

AuctionConfig ac = new AuctionConfig();

String userName = privilege.getUser(request);
if (op.equals("sellerScore")) {
	AuctionOrderMgr aom = new AuctionOrderMgr();
	try {
		if (aom.judgeSellerScore(request, ao))
			out.print(StrUtil.Alert("评分成功！"));
		else
			out.print(StrUtil.Alert("评分失败！"));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
}

if (op.equals("buyerScore")) {
	AuctionOrderMgr aom = new AuctionOrderMgr();
	try {
		if (aom.judgeBuyerScore(request, ao))
			out.print(StrUtil.Alert("评分成功！"));
		else
			out.print(StrUtil.Alert("评分失败！"));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
}

UserMgr um = new UserMgr();
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">查看订单</td>
  </tr>
</table>
<table width="100%"  border="0" align="center">
  <tr>
    <td height="31" align="center"><span class="style1"><a href="manager/myorder.jsp?showType=seller">查看我销售的订单</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="manager/myorder.jsp?showType=buyer">查看我购买的订单</a> </span></td>
  </tr>
</table>
<table width="98%"  border="0" align="center"cellspacing="1" cellpadding="5" bgcolor="#666666">
  <tr align="center" bgcolor="#F1EDF3">
    <td width="7%" height="22">流水号</td>
    <td width="12%" height="22">卖家</td>
  <td width="14%"> 买家</td>
    <td width="17%" bgcolor="#F1EDF3">成交价格</td>
    <td width="8%">成交数量</td>
    <td width="9%">总价</td>
    <td width="7%">状态</td>
    <td width="7%">币种</td>
    <td width="19%">成交时间</td>
  </tr>
  <tr align="center" bgcolor="#FFFFFF">
    <td height="22"><%=ao.getId()%></td>
    <td height="22"><%=um.getUser(ao.getSeller()).getNick()%></td>
  <td height="22"><%=um.getUser(ao.getBuyer()).getNick()%></td>
    <td height="22"><%=ao.getPrice()%></td>
    <td height="22"><%=ao.getAmount()%></td>
    <td height="22"><%=ao.getTotalPrice()%></td>
    <td height="22"><%=ao.getStateDesc(request, ao.getState())%></td>
    <td height="22">
	<%
	ScoreMgr sm = new ScoreMgr();
	ScoreUnit su = sm.getScoreUnit(ao.getMoneyCode());
	out.print(su.getName());
	%>
	</td>
    <td height="22"><%=DateUtil.format(ao.getOrderDate(), "yy-MM-dd HH:mm:ss")%></td>
  </tr>
  <tr align="left" bgcolor="#FFFFFF">
    <td height="22" colspan="2" align="center" bgcolor="#F7EFF7">付款时间</td>
  <td height="22"><%
	// 如果已支付
	if ((ao.getState()|ao.STATE_PAY)==ao.getState())
		out.print(DateUtil.format(ao.getPayTime(), "yy-MM-dd HH:mm:ss"));
	%></td>
    <td height="22" align="center" bgcolor="#F7EFF7">交货时间</td>
    <td height="22" colspan="5" bgcolor="#FFFFFF"><%
	// 如果已交货
	if ((ao.getState()|ao.STATE_DELIVERY)==ao.getState())
		out.print(DateUtil.format(ao.getDeliverTime(), "yy-MM-dd HH:mm:ss"));
	%></td>
  </tr>
  <tr align="center">
    <td height="22" colspan="2" bgcolor="#F1EDF3">物品名称</td>
    <td align="left" bgcolor="#FFFFFF"><%=StrUtil.toHtml(ao.getCommodityName())%></td>
    <td align="center" bgcolor="#F1EDF3">购买方式</td>
    <td colspan="5" align="left" bgcolor="#FFFFFF"><%
	AuctionDb ad = new AuctionDb();
	out.print(ad.getSellTypeDesc(request));
	%>
    </td>
  </tr>
  <tr align="center" bgcolor="#FFFFFF">
    <td height="22" colspan="2" bgcolor="#F7EFF7">给卖家评分</td>
  <td height="22" colspan="7" bgcolor="#FFFFFF">
  <table width="100%"  border="0">
    <tr>
      <td><form name="form1" method="post" action="?op=sellerScore&orderId=<%=orderId%>">
        <input type="radio" name="score" value="<%=ao.JUDGE_GOOD%>">
        <span class="style2">好</span>        
        <input type="radio" name="score" value="<%=ao.JUDGE_COMMON%>">
        <strong>中</strong>        <input type="radio" name="score" value="<%=ao.JUDGE_BAD%>">
        <span class="style3">差</span> &nbsp;
        <input type="submit" name="Submit" value="确定"> 
        ( 提交以后将不可更改 )
      </form>
	  <script>
	  <%if (ao.getSellerScore()!=ao.SCORE_NONE) {%>
	  setRadioChecked("score", "<%=ao.getSellerScore()%>");
	  <%}%>
	  </script>
	  <a href="javascript:openWin('<%=request.getContextPath()%>/message/send.jsp?receiver=<%=ao.getSeller()%>',320,260)">给卖家发消息</a>	  </td>
    </tr>
  </table>
    </td>
  </tr>
  <tr align="center" bgcolor="#FFFFFF">
    <td height="22" colspan="2" bgcolor="#F7EFF7">给买家评分</td>
  <td height="22" colspan="7"><table width="100%"  border="0">
    <tr>
      <td><form name="form1" method="post" action="?op=buyerScore&orderId=<%=orderId%>">
          <input type="radio" name="score1" value="<%=ao.JUDGE_GOOD%>">
          <span class="style2">好</span>
          <input type="radio" name="score1" value="<%=ao.JUDGE_COMMON%>">
          <strong>中</strong>
          <input type="radio" name="score1" value="<%=ao.JUDGE_BAD%>">
          <span class="style3">差</span> &nbsp;
          <input type="submit" name="Submit" value="确定">
        ( 提交以后将不可更改 )
        </form>
          <script>
	  <%if (ao.getBuyerScore()!=ao.SCORE_NONE) {%>
		  setRadioChecked("score1", "<%=ao.getBuyerScore()%>");
	  <%}%>
	  </script>
          <a href="javascript:openWin('<%=request.getContextPath()%>/message/send.jsp?receiver=<%=ao.getBuyer()%>',320,260)">给买家发消息</a>      </td>
    </tr>
  </table></td>
  </tr>
  <tr align="center" bgcolor="#FFFFFF">
    <td height="22" colspan="2" bgcolor="#F7EFF7">卖家联系方式</td>
    <td height="22" colspan="7" align="left">
	<%
	UserDb userDb = new UserDb();
	userDb = userDb.getUser(ao.getSeller()); 
	%>
	地址：<%=userDb.getAddress()%><br>
	电话：<%=userDb.getPhone()%>&nbsp;&nbsp;&nbsp;手机：<%=userDb.getMobile()%><br>
    邮编：<%=userDb.getPostCode()%>
    <br>
    邮箱：<a href="mailto:<%=userDb.getEmail()%>"><%=userDb.getEmail()%></a>
	</td>
  </tr>
  <tr align="center" bgcolor="#FFFFFF">
    <td height="22" colspan="2" bgcolor="#F7EFF7">买家联系方式</td>
    <td height="22" colspan="7" align="left">
	<%
	userDb = userDb.getUser(ao.getBuyer()); 
	%>
	地址：<%=userDb.getAddress()%><br>
	电话：<%=userDb.getPhone()%>&nbsp;&nbsp;&nbsp;手机：<%=userDb.getMobile()%><br>
    邮编：<%=userDb.getPostCode()%>
    <br>
    邮箱：<a href="mailto:<%=userDb.getEmail()%>"><%=userDb.getEmail()%></a>
	</td>
  </tr>
  <tr align="center" bgcolor="#FFFFFF">
    <td height="22" colspan="9">
<%if (!((ao.getState()|ao.STATE_PAY)==ao.getState()) && ao.getBuyer().equals(user)) {%>
买家如果已付款则设置： <a href="?op=pay&orderId=<%=orderId%>">已付款</a>&nbsp;注意：只有买家才可点击已付款&nbsp;
<%}%>
<%if (!((ao.getState()|ao.STATE_DELIVERY)==ao.getState()) && ao.getSeller().equals(user)) {%>
卖家如果已交货则设置： <a href="?op=delivery&orderId=<%=orderId%>">已交货</a> &nbsp;注意：只有卖家才可点击已交货
<%}%>&nbsp;&nbsp;<a target="_blank" href="../../showtopic.jsp?rootid=<%=ao.getAuctionId()%>">查看交易贴</a></td>
  </tr>
</table>

<table width="98%"  border="0" align="center">
  <tr>
    <td align="center"><br>
    ( 好评得分 <%=ao.JUDGE_GOOD%> 中评得<%=ao.JUDGE_COMMON%>分 差评得 <%=ao.JUDGE_BAD%> ) <br>
    如果用户<span class="style6">不诚信</span>，可向“<%=Global.AppName%>”投诉，如经核实，将视情节扣除该用户的信用值！</td>
  </tr>
</table>
</body>
</html>
