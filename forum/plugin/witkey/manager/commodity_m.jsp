<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.db.Conn"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<html><head>
<meta http-equiv="pragma" content="no-cache">
<LINK href="default.css" type=text/css rel=stylesheet>
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>商品目录管理</title>
<script language="JavaScript">
<!--

//-->
</script>
<body bgcolor="#FFFFFF" topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<jsp:useBean id="dir" scope="page" class="com.redmoon.forum.plugin.auction.Directory"/>
<%
if (!privilege.isUserLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String userName = ParamUtil.get(request, "userName");
if (userName.equals("")) {
	out.print(StrUtil.Alert("用户名不能为空！"));
	return;
}
String user = privilege.getUser(request);
if (!userName.equals(user)) {
	if (!privilege.isMasterLogin(request)) {
		out.print(StrUtil.Alert("对不起，您无权访问！"));
		return;
	}
}

String op = ParamUtil.get(request, "op");
String code = ParamUtil.get(request, "code");
AuctionShopDirDb asd = new AuctionShopDirDb();
asd = asd.getAuctionShopDirDb(userName, code);
if (code.equals("")) {
	code = asd.DEFAULT;
}

if (op.equals("modify")) {
	long msgRootId = ParamUtil.getLong(request, "msgRootId");
	String shopDir = ParamUtil.get(request, "shopDir");
	String strrecommand = ParamUtil.get(request, "recommand");
	
	AuctionDb ad = new AuctionDb();
	ad = ad.getAuctionDb(msgRootId);
	
	// 如果是一口价
	if (ad.getSellType()==ad.SELL_TYPE_SELL) {
		boolean isShow = ParamUtil.getBoolean(request, "isShow", false);
		ad.setShow(isShow);
	}
	
	boolean isValid = true;
	if (strrecommand.equals(""))
		ad.setRecommand(false);
	else {
		// 如果已是被推荐，则可能是在修改其它设置，如果还没被推荐，则检查是否超过了最大推荐数
		if (!ad.isRecommand()) {
			// 检查推荐位是否已有6个
			if (ad.getRecommandCount(userName)>=ad.DEFAULT_RECOMMAND_MAX) {
				out.print(StrUtil.Alert("对不起，最多只能最荐" + ad.DEFAULT_RECOMMAND_MAX + "个"));
				isValid = false;
			}
			else
				ad.setRecommand(true);
		}
	}
	if (isValid) {
		// 如果为一口价，如果被设为出售中，则检查数量是否大于0
		if (ad.getSellType()==ad.SELL_TYPE_SELL) {
			int count = ParamUtil.getInt(request, "count");
			int state = ParamUtil.getInt(request, "state");
			if (state==ad.STATE_SELLING) {
				if (count<=0) {
					out.print(StrUtil.Alert("您不能将状态置为出售中，请把商品的数量设为大于0！"));
					isValid = false;
				}
				else {
					ad.setState(state);
					ad.setCount(count);
				}
			}
			else
				ad.setState(state);
		}
		if (isValid) {
			// 是否更改了目录
			String oldShopDir = ad.getShopDir();
			if (!oldShopDir.equals(shopDir)) {
				// 如果不是改至系统目录
				if (!shopDir.equals(AuctionShopDirDb.DEFAULT)) {
					AuctionShopDirDb asd2 = new AuctionShopDirDb();
					asd2 = asd2.getAuctionShopDirDb(userName, shopDir);
					ad.setCatalogCode(asd2.getCatalogCode());
				}
				ad.setShopDir(shopDir);
			}
			
			if (ad.save())
				out.print(StrUtil.Alert("操作成功！"));
			else
				out.print(StrUtil.Alert("操作失败！"));
		}
	}
}

String dname = asd.getDirName();
if (code.equals(asd.DEFAULT))
	dname = "系统默认目录";
	
String listType = ParamUtil.get(request, "listType");
String showType = ParamUtil.get(request, "showType");
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">管理商品</td>
  </tr>
</table>
<br>
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr> 
    <td height=20 align="left" class="thead">
	<%if (listType.equals("listall")) {%>
	<a href="?showType=&userName=<%=StrUtil.UrlEncode(userName)%>&listType=listall">全部商品</a>
	<%}else{%>
	<a href="?showType=&userName=<%=StrUtil.UrlEncode(userName)%>&code=<%=StrUtil.UrlEncode(code)%>"><%=dname%></a>
	<%}%>
&nbsp;&nbsp;<a href="?showType=sellout&userName=<%=StrUtil.UrlEncode(userName)%>&code=<%=StrUtil.UrlEncode(code)%>">已售完商品</a>	</td>
  </tr>
<%
int pagesize = 10;
Paginator paginator = new Paginator(request);

AuctionDb ad = new AuctionDb();
String sql = "";
if (listType.equals("listall")) {
	if (showType.equals("sellout"))
		sql = "select msgRootId from " + ad.getTableName() + " where state=" + ad.STATE_SELLOUT + " and userName=" + StrUtil.sqlstr(userName) + " order by recommand desc, beginDate desc";	
	else
		sql = "select msgRootId from " + ad.getTableName() + " where userName=" + StrUtil.sqlstr(userName) + " order by recommand desc, beginDate desc";
}
else {
	if (showType.equals("sellout"))
		sql = "select msgRootId from " + ad.getTableName() + " where state=" + ad.STATE_SELLOUT + " and userName=" + StrUtil.sqlstr(userName) + " and shopDir=" + StrUtil.sqlstr(code) + " order by recommand desc, beginDate desc";
	else
		sql = "select msgRootId from " + ad.getTableName() + " where userName=" + StrUtil.sqlstr(userName) + " and shopDir=" + StrUtil.sqlstr(code) + " order by recommand desc, beginDate desc";
}
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
  <tr> 
    <td valign="top"><br>
      <table width="95%" height="24" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td align="right"><div>找到符合条件的记录 <b><%=paginator.getTotal() %></b> 条　每页显示 <b><%=paginator.getPageSize() %></b> 条　页次 <b><%=paginator.getCurrentPage() %>/<%=paginator.getTotalPages() %></b></div></td>
        </tr>
      </table>
      <table width="876"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFBFF" class="tableframe_gray">
      <tr align="center">
        <td width="27">推荐</td>
        <td width="74" height="22">商品名称</td>
      <td width="113" height="22">所属目录</td>
        <td width="91">数量</td>
        <td width="104">状态</td>
        <td width="135" height="22">销售类型</td>
      <td width="87">销售日期</td>
        <td width="80">截止日期</td>
        <td width="98">操作</td>
      </tr>
<%
String querystr = "code=" + StrUtil.UrlEncode(code) + "&listType=" + listType + "&userName=" + StrUtil.UrlEncode(userName) + "&showType=" + showType;

Vector v = ad.list(sql, (curpage-1)*pagesize, curpage*pagesize-1);
Iterator ir = v.iterator();
int i = 0;
while (ir.hasNext()) {
	ad = (AuctionDb)ir.next();
	i++;
%>
	<form id="form<%=i%>" name="form<%=i%>" action="?op=modify" method="post">
      <tr align="center">
        <td>
		<input name=recommand value=1 type=checkbox <%=ad.isRecommand()?"checked":""%>></td>
        <td height="22"><%=ad.getName()%><input type=hidden name=msgRootId value="<%=ad.getMsgRootId()%>">
		  <input type=hidden name=code value="<%=code%>">
		  <input type=hidden name=listType value="<%=listType%>">
          <input type=hidden name=userName value="<%=userName%>"></td>
        <td height="22">
		<select name=shopDir>
		<option value="<%=asd.DEFAULT%>">系统默认</option>
		<%=asd.toOptions(userName)%>
		</select>
		<script>
		form<%=i%>.shopDir.value = "<%=ad.getShopDir()%>";
		</script>		</td>
        <td><input name=count value="<%=ad.getCount()%>" size=1></td>
        <td>
		<%if (ad.getSellType()==ad.SELL_TYPE_SELL) {%>
			<select name="state">
			<option value="<%=ad.STATE_SELLING%>"><%=ad.getStateDesc(request, ad.STATE_SELLING)%></option>
			<option value="<%=ad.STATE_SELLOUT%>" style="BACKGROUND: #cccccc; color: #ff0000"><%=ad.getStateDesc(request, ad.STATE_SELLOUT)%></option>
			</select>
			<script>
			form<%=i%>.state.value = "<%=ad.getState()%>";
			</script>
		<%}else {%>
				<%if (DateUtil.compare(new java.util.Date(), ad.getEndDate())==1 && ad.getOrderId()==ad.NONE_ORDER) {%>
                    <%=AuctionSkin.LoadString(request, "bid_state_end")%>
				<%}else{%>
					<%=ad.getStateDesc(request)%>
				<%}%>
			<input name="state" type="hidden" value="<%=ad.getState()%>">
		<%}%>		</td>
        <td height="22">
		<%=ad.getSellTypeDesc(request)%>&nbsp;
		<%if (ad.getSellType()==ad.SELL_TYPE_SELL) {
			String checked = "";
			if (ad.isShow())
				checked = "checked";
		%>
			<input type=checkbox name=isShow value="true" <%=checked%>>仅供展示
		<%}%>		</td>
      <td>
	  <%=DateUtil.format(ad.getBeginDate(), "yy-MM-dd HH:mm:ss")%>	  </td>
        <td>
		<%if (ad.getSellType()==ad.SELL_TYPE_AUCTION) {%>
			<%=DateUtil.format(ad.getEndDate(), "yy-MM-dd HH:mm:ss")%>
		<%}%>
		</td>
        <td height="28"><input type="submit" name="Submit" value="修改">
&nbsp;&nbsp;        <a href="../../../showtopic.jsp?rootid=<%=ad.getMsgRootId()%>">查看</a></td>
      </tr></form>
<%}%>	  
    </table>
      <table width="87%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
        <tr>
          <td height="23"><div align="right">
              <%
    out.print(paginator.getCurPageBlock("?"+querystr));
%>
          </div></td>
        </tr>
      </table>
      <br>
    </td>
  </tr>
</table>
</td> </tr>             
      </table>                                        
       </td>                                        
     </tr>                                        
 </table>                                        
                               
</body>                                        
</html>                            
  