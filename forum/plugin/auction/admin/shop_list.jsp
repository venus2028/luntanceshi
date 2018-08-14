<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*,
				 java.text.*,
				 com.redmoon.blog.*,
				 cn.js.fan.db.*,
				 cn.js.fan.util.*,
				 com.redmoon.forum.plugin.auction.*,
				 cn.js.fan.web.*,
				 cn.js.fan.module.pvg.*"
%>
<HTML><HEAD><TITLE>商店列表</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<link rel="stylesheet" href="../../../common.css">
<LINK href="../../../admin/default.css" type=text/css rel=stylesheet>
<META content="MSHTML 6.00.3790.259" name=GENERATOR>
<style type="text/css">
<!--
.style1 {	font-size: 14px;
	font-weight: bold;
}
-->
</style>
</HEAD>
<BODY text=#000000 bgColor=#eeeeee leftMargin=0 topMargin=0>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String privurl;
String op = ParamUtil.get(request, "op");
if (op.equals("stop")) {
	privurl = ParamUtil.get(request, "privurl");
	String userName = ParamUtil.get(request, "userName");
	AuctionShopDb asd = new AuctionShopDb();
	asd = asd.getAuctionShopDb(userName);
	int isValid = ParamUtil.getInt(request, "isValid");
	asd.setValid(isValid==1?true:false);
	if (asd.save()) {
		out.print(StrUtil.Alert_Redirect("操作成功！", privurl));
	}
	else {
		out.print(StrUtil.Alert_Redirect("操作失败！", privurl));
	}
}

if (op.equals("del")) {
	String userName = ParamUtil.get(request, "userName");
	AuctionShopDb asd = new AuctionShopDb();
	asd = asd.getAuctionShopDb(userName);
	asd.del();	
	out.print(StrUtil.Alert("删除商店成功！"));
}
if (op.equals("recommand")) {
	String userName = ParamUtil.get(request, "userName");
	AuctionShopDb asd = new AuctionShopDb();
	asd = asd.getAuctionShopDb(userName);
	boolean isRecommanded = ParamUtil.getBoolean(request, "isRecommanded", false);
	asd.setRecommanded(isRecommanded);
	if (asd.save()) {
        AuctionShopCache uc = new AuctionShopCache(asd);
		uc.refreshList();	
		out.print(StrUtil.Alert_Redirect("操作成功！", "shop_list.jsp"));
	}
	else
		out.print(StrUtil.Alert_Back("操作失败！"));
	return;
}
privurl = ParamUtil.get(request, "privurl");
%>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
  <TR>
    <TD class=head>用户的商店&nbsp;(<a href="manager.jsp">管理</a>)</TD>
  </TR></TBODY></TABLE>
<br>
<%
int pagesize = 10;
Paginator paginator = new Paginator(request);

AuctionShopDb asd = new AuctionShopDb();
String sql = "select userName from " + asd.getTableName() + " order by IS_RECOMMANDED desc, openDate desc";
String action = ParamUtil.get(request, "action");
String kind = ParamUtil.get(request, "kind");
String value = ParamUtil.get(request, "value");
if (action.equals("search")) {
	if (kind.equals("userName")) {
		com.redmoon.forum.person.UserDb ud = new com.redmoon.forum.person.UserDb();
		String nicks = ud.getNicksLike(value);
		sql = "select userName from " + asd.getTableName() + " where userName in (" + nicks + ") order by IS_RECOMMANDED desc, openDate desc";
	}
	else
		sql = "select userName from " + asd.getTableName() + " where shopName like " + StrUtil.sqlstr("%" + value + "%") + " order by IS_RECOMMANDED desc, openDate desc";
}
int total = asd.getObjectCount(sql);
paginator.init(total, pagesize);
int curpage = paginator.getCurPage();
// 设置当前页数和总页数
int totalpages = paginator.getTotalPages();
if (totalpages==0)
{
	curpage = 1;
	totalpages = 1;
}
%>
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr>
    <td height=20 align="center" class="thead style1">商店列表</td>
  </tr>
  <tr>
    <td valign="top"><table width="75%" border="0" align="center" cellpadding="0" cellspacing="0">
	<form name=formsearch action="?action=search" method="post">
      <tr>
        <td align="center">
		按
		  <select name="kind">
		<option value="shopName">商店名称</option>
		<option value="userName">用户名</option>
		</select>
		<input name="value">
		&nbsp;
		<input type="submit" value="搜索商店"></td>
      </tr>
	  </form>
    </table>
      <br>
        <table width="86%" height="24" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td align="right"><div>找到符合条件的记录 <b><%=paginator.getTotal() %></b> 条　每页显示 <b><%=paginator.getPageSize() %></b> 条　页次 <b><%=paginator.getCurrentPage() %>/<%=paginator.getTotalPages() %></b></div></td>
          </tr>
        </table>
      <table width="86%"  border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#666666">
          <tr align="center" bgcolor="#F1EDF3">
            <td width="8%">是否推荐</td>
            <td width="26%" height="22">商店名称</td>
            <td width="21%" height="22">用户</td>
            <td width="16%">开店日期</td>
            <td width="14%">状态</td>
            <td width="15%">操作</td>
          </tr>
          <%
Vector v = asd.list(sql, (curpage-1)*pagesize, curpage*pagesize-1);
Iterator ir = v.iterator();
com.redmoon.forum.person.UserMgr um = new com.redmoon.forum.person.UserMgr();
int i = 0;
while (ir.hasNext()) {
	asd = (AuctionShopDb)ir.next();
	i++;
%>
          <form id="form<%=i%>" name="form<%=i%>" action="?op=modify" method="post">
            <tr align="center">
              <td bgcolor="#FFFFFF"><span style="PADDING-LEFT: 10px">
                <input type="checkbox" name="isRecommanded" <%=asd.isRecommanded()?"checked":""%> onClick="location.href='?op=recommand&userName=<%=StrUtil.UrlEncode(asd.getUserName())%>&isRecommanded=<%=asd.isRecommanded()?"false":"true"%>'">
              </span></td>
              <td height="22" bgcolor="#FFFFFF"><a target=_blank href="../../../plugin/auction/shop.jsp?userName=<%=StrUtil.UrlEncode(asd.getUserName())%>"><%=asd.getShopName()%></a>              </td>
              <td height="22" bgcolor="#FFFFFF"><a href="../../../../userinfo.jsp?username=<%=StrUtil.UrlEncode(asd.getUserName())%>"><%=um.getUser(asd.getUserName()).getNick()%></a></td>
              <td bgcolor="#FFFFFF"><%=DateUtil.format(asd.getOpenDate(), "yy-MM-dd HH:mm:ss")%></td>
              <td bgcolor="#FFFFFF"><%if (asd.isValid()) {%>
已启用
  <%}else{%>
已禁用
<%}%></td>
              <td height="22" bgcolor="#FFFFFF">
			  <%if (asd.isValid()) {%>
			  <a title="禁用该用户的博客" href="?op=stop&userName=<%=asd.getUserName()%>&privurl=<%=privurl%>&isValid=0">禁用</a>
			  <%}else{%>			  &nbsp;&nbsp;<a title="启用该用户的博客" href="?op=stop&userName=<%=asd.getUserName()%>&privurl=<%=privurl%>&isValid=1"><font color=red>启用</font></a>
			  <%}%>
			  <a href="#" onClick="DelShop('<%=StrUtil.UrlEncode(asd.getUserName())%>')">删除</a></td>
            </tr>
          </form>
          <%}%>
      </table>
      <table width="86%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
          <tr>
            <td height="23"><div align="right">
                <%
	String querystr = "action=" + action + "&kind=" + kind + "&value=" + StrUtil.UrlEncode(value);
    out.print(paginator.getCurPageBlock("?"+querystr));
%>
            </div></td>
          </tr>
    </table></td>
  </tr>
</table>
<br>
</BODY>
<script>
function DelShop(userName) {
	if (confirm("您确定要删除么？\n删除商店时将连同用户已发布的商品一起删除！")) {
		window.location.href = "?op=del&userName=" + userName;
	}
}
</script>
</HTML>
