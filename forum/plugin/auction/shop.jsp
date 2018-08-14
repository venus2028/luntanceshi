<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.nav.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ page import="com.redmoon.forum.plugin.info.*"%>
<%@ page import="com.redmoon.forum.MsgDb"%>
<%@ page import="com.redmoon.forum.person.UserDb"%>
<%@ page import="cn.js.fan.module.guestbook.*"%>
<%
int id = -1;
try {
	id = ParamUtil.getInt(request, "id");
}
catch (Exception e) {
}
AuctionShopDb as = new AuctionShopDb();
String userName = "";
if (id!=-1)
	userName = StrUtil.getNullString(as.getShopUserNameById(id));

if (userName.equals(""))
	userName = ParamUtil.get(request, "userName");
if (userName.equals("")) {
	out.print(SkinUtil.makeErrMsg(request, "该店铺已不存在！"));
	return;
}

as = as.getAuctionShopDb(userName);
if (as==null || !as.isLoaded()) {
	out.print(cn.js.fan.web.SkinUtil.makeInfo(request, AuctionSkin.LoadString(request, "info_not_exist")));
	return;
}
if (!as.isValid()) {
	out.print(cn.js.fan.web.SkinUtil.makeInfo(request, AuctionSkin.LoadString(request, "info_invalid")));
	return;
}
MsgDb md = new MsgDb();

UserDb user = new UserDb();
user = user.getUser(userName);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE><%=as.getShopName()%>-<%=Global.AppName%>社区专卖店</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<script language="JavaScript">
function openWin(url,width,height)
{
  var newwin = window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,top=50,left=120,width="+width+",height="+height);
}
</script>
<META content="MSHTML 6.00.2600.0" name=GENERATOR>
</HEAD>
<LINK href="shopskin/<%=as.getSkinCode()%>/skin.css" type=text/css rel=stylesheet>
<BODY>
<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" class="banner">
  <tr>
    <td height="23" colspan="2" valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="topnav_table">
        <tr>
          <td width="7%" height="23">&nbsp;</td>
          <td width="21%" align="center" class="topnav_td"><%=StrUtil.toHtml(as.getShopName())%></td>
          <td width="17%" align="center"><a href="shopdesc.jsp?userName=<%=StrUtil.UrlEncode(userName)%>" class="link_topnav">【店铺介绍】</a></td>
          <td width="55%">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td width="50%"><div class="shopInfo">
        <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td width="45%" rowspan="7" align="center"><%
				String logo = StrUtil.getNullStr(as.getLogo());
				if (!logo.equals("")) {
					String w = "";
					if (as.getLogoWidth()>as.LOGO_NO_WIDTH)
						w = "width=" + as.getLogoWidth();
						
					com.redmoon.forum.Config cfg = com.redmoon.forum.Config.getInstance();
					String attachmentBasePath = request.getContextPath() + "/" + cfg.getAttachmentPath() + "/";
					boolean isFtpUsed = cfg.getBooleanProperty("forum.ftpUsed");
					if (isFtpUsed) {
						attachmentBasePath = cfg.getProperty("forum.ftpUrl");
						if (attachmentBasePath.lastIndexOf("/")!=attachmentBasePath.length()-1)
							attachmentBasePath += "/";
					}
			     	%>
              <img src="<%=attachmentBasePath + logo%>" <%=w%>>
              <%}
				%>
            </td>
            <td width="20%"><span>店&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;长:</span></td>
            <td width="35%"><a href="../../../userinfo.jsp?username=<%=StrUtil.UrlEncode(userName)%>"><%=StrUtil.toHtml(user.getNick())%></a></td>
          </tr>
          <tr>
            <td><span>信&nbsp;&nbsp;用&nbsp;&nbsp;值:</span></td>
            <td><%=user.getCredit()%></td>
          </tr>
          <tr>
            <td><span>开店时间:</span></td>
            <td><%=DateUtil.format(as.getOpenDate(), "yyyy-MM-dd")%></td>
          </tr>
          <tr>
            <td><span>地&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;址:</span></td>
            <td><%=as.getAddress()%></td>
          </tr>
          <tr>
            <td><span>点&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;击:</span></td>
            <td><%=as.getHit()%></td>
          </tr>
          <%if (Global.isSubDomainSupported) {%>
          <tr>
            <td><span>域&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;名:</span></td>
            <td><%
            String serverName = request.getServerName();
            String[] domainParts = StrUtil.split(serverName, "\\.");
			int dlen = domainParts.length;
			if (dlen>1) {
				if (StrUtil.isNumeric(domainParts[dlen - 1])) {
					// 如果是IP地址
				}             
				else {
					String baseDomain = domainParts[dlen - 2] + "." + domainParts[dlen - 1];
				%>
              <a href="http://<%=as.getId()%>.shop.<%=baseDomain%>">http://<%=as.getId()%>.shop.<%=baseDomain%></a>
              <%}
			}%>
            </td>
          </tr>
          <%}
		  as.setHit(as.getHit() + 1);
		  as.save();
		  %>
          <tr>
            <td>&nbsp;</td>
            <td><a href="javascript:openWin('<%=request.getContextPath()%>/message/send.jsp?receiver=<%=userName%>',320,260)">站内消息</a>&nbsp;&nbsp;<a href="manager/index.jsp?userName=<%=StrUtil.UrlEncode(userName)%>">管理店铺</a> </td>
          </tr>
        </table>
      </div></td>
    <td width="50%" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="1" class="announce_bg">
        <tr>
          <td width="100%" colspan="2" class="">&nbsp;</td>
        </tr>
      </table>
      <table width="100%" border="0" cellpadding="0" cellspacing="1">
        <tr>
          <td height="21" colspan="2" valign="middle" class="notice_title_td"><span class="text_14_bold">本店消息</span></td>
        </tr>
        <tr>
          <td height="13" colspan="2"><hr size="1" class="notice_hr"></td>
        </tr>
        <%
					InfoDb idb = new InfoDb();
					Iterator idbir = idb.list(0, 4, userName).iterator();
					while (idbir.hasNext()) {
						idb = (InfoDb)idbir.next();
						md = md.getMsgDb(idb.getId());
					%>
        <tr>
          <td width="83%" height="22">【<%=idb.getTypeName()%>】<span class="dirItem"><a href="../../showtopic.jsp?rootid=<%=md.getId()%>" target=_blank><%=StrUtil.toHtml(md.getTitle())%></a></span></td>
          <td width="17%" height="22"><%=DateUtil.format(idb.getAddDate(), "yy-MM-dd")%></td>
        </tr>
        <%}%>
      </table></td>
  </tr>
</table>
<table width="98%"  border="0" align="center" class="recommand">
  <tr>
    <td><%
	com.redmoon.forum.Config cfg = com.redmoon.forum.Config.getInstance();
	boolean isFtpUsed = cfg.getBooleanProperty("forum.ftpUsed");
	String basePath = cfg.getProperty("forum.ftpUrl");
	
	AuctionDb ad = new AuctionDb();
	Iterator rcir = ad.listRecommand(userName).iterator();
	while (rcir.hasNext()) {
	%>
      <table border="0" align="left">
        <tr>
          <td width="139" height="106" align="center" valign="bottom"><%
		ad = (AuctionDb) rcir.next();
		String fileName = StrUtil.getNullString(ad.getImage());
		if (!fileName.equals("")) {
			if (isFtpUsed)
				fileName = basePath + "/" + fileName;
			else
				fileName = "../../" + fileName;
		%>
            <img src="../../upfile/<%=fileName%>" width=80>
            <%}else{%>
            <img src="shopskin/default/images/noimg.jpg" width="80" height="105">
            <%}%>
          </td>
        </tr>
        <tr>
          <td height="22" align="center"><a href="../../showtopic.jsp?rootid=<%=ad.getMsgRootId()%>" class="link_commodity"><%=StrUtil.toHtml(ad.getName())%></a></td>
        </tr>
        <tr>
          <td align="center"><%=ad.getSellTypeDesc(request)%>&nbsp;
            <%
	AuctionWorthDb aw = new AuctionWorthDb();
	long[] ary = aw.getWorthOfAuction(ad.getMsgRootId());
	if (ad.getSellType()==ad.SELL_TYPE_AUCTION) {
		aw = aw.getAuctionWorthDb((int)ary[0]);
	%>
            <span class="text_price"><%=aw.getMoneyName()%><%=aw.getPrice()%>&nbsp;<%=aw.getMoneyDanWei()%></span>
            <%} else {
		int len = ary.length;
		for (int i=0; i<len; i++) {
			aw = aw.getAuctionWorthDb((int)ary[i]);
		%>
            &nbsp;<span class="text_price"><%=aw.getMoneyName()%><%=aw.getPrice()%>&nbsp;<%=aw.getMoneyDanWei()%></span><br>
            <%}
	}%>
          </td>
        </tr>
      </table>
      <%}%>
    </td>
  </tr>
</table>
<TABLE width=98% border=0 align="center" cellPadding=0 cellSpacing=0 class="main_table_bg">
  <TBODY>
    <TR>
      <TD width="19%" align=middle vAlign=top><TABLE cellSpacing=0 cellPadding=0 width=100% border=0 class="dir_frame">
          <TBODY>
            <TR>
              <TD height=33 valign="top" class=p3><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="dir_title">
                  <tr>
                    <td><span id=dir_title class="text_white_bold">商品目录</span></td>
                  </tr>
                </table>
                <table width="99%" height="29"  border="0" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="11%" class="text_dir_all">&nbsp;</td>
                    <td align="left" class="text_dir_all"><img src="images/default/arrow.gif" width="13" height="12" border="0" align="absmiddle">&nbsp;<span class="dirItem"><a href="shop.jsp?userName=<%=StrUtil.UrlEncode(userName)%>">全部商品</a></span></td>
                  </tr>
                </table>
                <%
				AuctionShopDirDb asd = new AuctionShopDirDb();
				Iterator irdir = asd.list(userName).iterator();
				while (irdir.hasNext())
				{
					asd = (AuctionShopDirDb) irdir.next();
				%>
                <table width=100% border=0 cellspacing=0 cellpadding=0 class="p9">
                  <tr>
                    <td width=11% height=20>&nbsp;</td>
                    <td width=89%><img src="images/default/arrow.gif" width="13" height="12" border="0" align="absmiddle">&nbsp;<span class="dirItem"><a href="?userName=<%=StrUtil.UrlEncode(userName)%>&dirCode=<%=StrUtil.UrlEncode(asd.getCode())%>"><%=StrUtil.toHtml(asd.getDirName())%></a></span></td>
                  </tr>
                </table>
                <% }%>
                <table width="99%" height="29"  border="0" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="11%" class="text_dir_all">&nbsp;</td>
                    <td align="left" class="text_dir_all"><img src="images/default/arrow.gif" width="13" height="12" border="0" align="absmiddle">&nbsp;<span class="dirItem"><a href="shop_alipay.jsp?userName=<%=StrUtil.UrlEncode(userName)%>">支付宝交易</a></span></td>
                  </tr>
                </table></TD>
            </TR>
          </TBODY>
        </TABLE>
        <br>
        <TABLE cellSpacing=0 cellPadding=0 width=100% border=0 class="link_frame">
          <TBODY>
            <TR>
              <TD height=161 valign="top" class=p3><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="dir_title">
                  <tr>
                    <td><span id=dir_title class="text_white_bold">友情链接</span></td>
                  </tr>
                </table>
                <%
				LinkDb ld = new LinkDb();
				String listsql = "select id from " + ld.getTableName() + " where userName=" + StrUtil.sqlstr(userName) + " and kind=" + StrUtil.sqlstr(ld.KIND_SHOP) + " order by sort";
				Iterator irlink = ld.list(listsql).iterator();
				while (irlink.hasNext())
				{
					ld = (LinkDb) irlink.next();
				%>
                <table width=100% border=0 cellspacing=0 cellpadding=0 class="p9">
                  <tr>
                    <td width=11% height=20>&nbsp;</td>
                    <td width=89%>&nbsp;<span class="dirItem">
                      <%if (ld.getImage()==null || ld.getImage().equals("")) {%>
                      <a target="_blank" href="<%=ld.getUrl()%>" title="<%=StrUtil.toHtml(ld.getTitle())%>"><%=StrUtil.toHtml(ld.getTitle())%></a>
                      <%}else{%>
                      <a target="_blank" href="<%=ld.getUrl()%>" title="<%=StrUtil.toHtml(ld.getTitle())%>"><img src="<%=ld.getImageUrl(request)%>" border="0"></a>
                      <%}%>
                      </span></td>
                  </tr>
                </table>
                <%}%>
              </TD>
            </TR>
          </TBODY>
        </TABLE></TD>
      <TD vAlign=top width=1%>&nbsp;</TD>
      <TD width="80%" vAlign=top><TABLE cellSpacing=0 cellPadding=0 width="100%" border=0 class="p9">
          <TBODY>
            <TR>
              <TD width="431">
            <TR vAlign=top>
              <TD height="251" colspan="2"><table width="100%"  border="0" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="97" height="22" class="commodity_bar">&nbsp;&nbsp;
                      <%
					String dirCode = ParamUtil.get(request, "dirCode");
					String dirName = "全部商品";
					if (!dirCode.equals("")) {
						asd = asd.getAuctionShopDirDb(userName, dirCode);
						if (asd!=null && asd.isLoaded()) {
							dirName = asd.getDirName();
						}
					}
					%>
                      <span class="commodity_title_text"><%=dirName%></span> </td>
                    <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="p9">
                        <form name="form_search" method="post" action="search.jsp" onSubmit="">
                          <tr>
                            <td width="57%" align="center">&nbsp;</td>
                            <td width="43%" height="22" align="center"><input value="" name="what" onFocus="" onBlur="" type="text" class="singleboarder" size=16 style="height: 18">
                              <input type="image" value="images/default/search.gif" src="images/default/search.gif" align="middle" width="57" height="16"></td>
                          </tr>
                        </form>
                      </table></td>
                  </tr>
                  <tr>
                    <td height="4" colspan="2" class="commodity_bar_tr"></td>
                  </tr>
                </table>
                <%
String sql = "";
if (dirCode.equals(""))
	sql = "select msgRootId from " + ad.getTableName() + " where userName="+StrUtil.sqlstr(userName) + " order by beginDate desc";
else
	sql = "select msgRootId from " + ad.getTableName() + " where userName="+StrUtil.sqlstr(userName) + " and shopDir=" + StrUtil.sqlstr(dirCode) + " order by beginDate desc";
	
int pagesize = 20;
Paginator paginator = new Paginator(request);

int total = ad.getObjectCount(sql);
paginator.init(total, pagesize);
int curpage = paginator.getCurPage();
//设置当前页数和总页数
int totalpages = paginator.getTotalPages();
if (totalpages==0)
{
	curpage = 1;
	totalpages = 1;
}
%>
                <% if(paginator.getTotal()>0){ %>
                <table width="91%" border="0" cellspacing="0" cellpadding="0" align="center" class="p9" height="24">
                  <tr>
                    <td width="100%" height="24" valign="bottom"><div align="right">共 <b><%=paginator.getTotal() %></b> 条　每页<b><%=paginator.getPageSize() %></b> 条　<b><%=curpage %>/<%=totalpages %></b> &nbsp;&nbsp;
                        <%
	  String querystr = "userName=" + StrUtil.UrlEncode(userName) + "&dirCode=" + StrUtil.UrlEncode(dirCode);
 	  out.print(paginator.getCurPageBlock("?"+querystr));
	  %>
                      </div></td>
                  </tr>
                </table>
                <%}%>
                <table width="100%"  border="0" cellspacing="8">
                  <%
Iterator ir = ad.list(sql, (curpage-1)*pagesize, curpage*pagesize-1).iterator();
int k = 0;
while (ir.hasNext()) {
	ad = (AuctionDb) ir.next();
	k++;
	if (k==1) {%>
                  <tr>
                    <td bgcolor="#FFFFFF"><%}
%>
                      <table width="120" border=0 align="left" class="p9">
                        <tr>
                          <td height=100 align=center valign=bottom><%
						  String fileName = StrUtil.getNullString(ad.getImage());
						  if (!fileName.equals("")) {
							if (isFtpUsed)
								fileName = basePath + "/" + fileName;
							else
								fileName = "../../upfile/" + fileName;
						  %>
                            <img src="<%=fileName%>" width="80">
                            <%}else{%>
                            <img src="shopskin/default/images/noimg.jpg" width="80" height="105">
                            <%}%>
                          </td>
                        </tr>
                        <tr>
                          <td width="154" height="20" align="center" valign="top">&nbsp; <a href="../../showtopic.jsp?rootid=<%=ad.getMsgRootId()%>" class="link_commodity"><%=StrUtil.toHtml(ad.getName())%></a></td>
                        </tr>
                        <tr>
                          <td height="40" align="center" valign="top"><%
	AuctionWorthDb aw = new AuctionWorthDb();
	long[] ary = aw.getWorthOfAuction(ad.getMsgRootId());
	if (ad.getSellType()==ad.SELL_TYPE_AUCTION) {
		// System.out.println("msgRootId=" + ad.getMsgRootId());
		if (ary.length!=0)
			aw = aw.getAuctionWorthDb((int)ary[0]);
	%>
                            拍卖&nbsp;<%=aw.getMoneyName()%><%=aw.getPrice()%>&nbsp;<%=aw.getMoneyDanWei()%>
                            <%} else {
			int len = ary.length;
			for (int m=0; m<len; m++) {
				aw = aw.getAuctionWorthDb((int)ary[m]);
				%>
                            一口价&nbsp;<%=aw.getMoneyName()%><%=aw.getPrice()%>&nbsp;<%=aw.getMoneyDanWei()%><br>
                            <%}
	}%>
                          </td>
                        </tr>
                      </table>
                      <%
	  	if (k==5) {
			out.print("</td></tr>");
			k = 0;
		}
	  }%>
                      <%if (k!=0) {%>
                    </td>
                  </tr>
                  <%}%>
                </table>
                <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                </table>
                <jsp:useBean id="msg" scope="page" class="cn.js.fan.module.guestbook.MessageDb"/>
                
                <table width="100%"  border="0" cellpadding="8">
                  <tr>
                    <td><table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td height="2" colspan="2" class="guestbook_bar_tr"></td>
                        </tr>
                        <tr>
                          <td width="153" height="24" class="guestbook_bar">&nbsp;&nbsp;<span class="text_white_bold">本店最新留言</span></td>
                          <td align="right"><a href="guestbook.jsp?shopCode=<%=StrUtil.UrlEncode(userName)%>" class="nav_guestbook">更多留言</a>&nbsp;&nbsp;<a href="guestbook.jsp?shopCode=<%=StrUtil.UrlEncode(userName)%>" class="nav_guestbook">我要留言</a>&nbsp;&nbsp;</td>
                        </tr>
                      </table>
                      <%
sql = "select id from guestbook where shopCode=" + StrUtil.sqlstr(userName) + " order by lydate desc";
Iterator ri = msg.list(sql, 0, 2).iterator();
while (ri.hasNext()) {
 	msg = (MessageDb)ri.next();
%>
                      <table width="100%" border="0" align="center" cellpadding="6" cellspacing="0" bgcolor="#FFFFFF" class="tableframe">
                        <tr>
                          <td width="27%" height="22" valign="bottom" class="stable style4">用户：<%=StrUtil.toHtml(msg.getUserName())%>　</td>
                          <td width="73%" height="22" valign="bottom" class="stable style4">留言日期：<%=DateUtil.format(msg.getLydate(), "yy-MM-dd HH:mm:ss")%></td>
                        </tr>
                        <tr valign="top">
                          <td height="83" colspan="2" class="stable"><%=StrUtil.toHtml(msg.getContent())%><br>
                            <%
				  String reply = StrUtil.getNullString(msg.getReply());
				  if (!reply.equals(""))
				  {
				  %>
                            <br>
                            <font color="#F09F6F">回复：</font><%=StrUtil.toHtml(reply)%> <br>
                            日期：<%=DateUtil.format(msg.getLydate(), "yy-MM-dd HH:mm:ss")%>
                            <% } %>
                          </td>
                        </tr>
                        <tr valign="top">
                          <td height="1" colspan="2"  bgcolor="#999999"></td>
                        </tr>
                      </table>
                      <%}%></td>
                  </tr>
                </table>
                <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td align="right"></td>
                  </tr>
                </table></TD>
            </TR>
          </TBODY>
        </TABLE></TD>
    </TR>
  </TBODY>
</TABLE>
<table width="98%"  border="0" align="center">
  <tr>
    <td height="34" align="center"><HR style="height:1px; color:"#999999">
      Copyright 2005 版权所有：<a href="<%=Global.getRootPath()%>" class="link_commodity"><%=Global.AppName%></a><br>
      联系人：<%=as.getContacter()%></td>
  </tr>
</table>
</BODY>
</HTML>
