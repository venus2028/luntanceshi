<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*,
				 java.text.*,
				 com.redmoon.blog.*,
				 cn.js.fan.db.*,
				 cn.js.fan.util.*,
				 com.redmoon.forum.plugin.auction.*,
				 com.redmoon.forum.person.*,
				 cn.js.fan.web.*,
				 cn.js.fan.module.pvg.*"
%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%@ page import="com.redmoon.forum.person.UserSet"%>
<%
String skinPath = SkinMgr.getSkinPath(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD><TITLE>商店列表 - <%=Global.AppName%></TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<link href="../../<%=skinPath%>/css.css" rel="stylesheet" type="text/css">
</HEAD>
<BODY>
<div id="wrapper">
<%@ include file="../../inc/header.jsp"%>
<div id="main">
<%
String privurl = ParamUtil.get(request, "privurl");
%>
<br>
<%
int pagesize = 10;
Paginator paginator = new Paginator(request);

AuctionShopDb asd = new AuctionShopDb();
String sql = asd.QUERY_LIST; // "select userName from " + asd.getTableName();
String action = ParamUtil.get(request, "action");
String kind = ParamUtil.get(request, "kind");
String value = ParamUtil.get(request, "value");
if (action.equals("search")) {
	if (kind.equals("userName")) {
		com.redmoon.forum.person.UserDb ud = new com.redmoon.forum.person.UserDb();
		String nicks = ud.getNicksLike(value);	
		sql = "select userName from " + asd.getTableName() + " where userName in (" + nicks + ")";
	}
	else
		sql = "select userName from " + asd.getTableName() + " where shopName like " + StrUtil.sqlstr("%" + value + "%");
}
int total = asd.getObjectCount(sql);
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
<div class="tableTitle">商店列表</div>

<table class="per80" width="75%" border="0" align="center" cellpadding="0" cellspacing="0">
  <form name=formsearch action="?action=search" method="post">
    <tr>
      <td align="center"> 按
        <select name="kind">
            <option value="shopName">商店名称</option>
            <option value="userName">用户名</option>
          </select>
          <input name="value">
        &nbsp;
        <input name="submit" type="submit" value="搜索商店"></td>
    </tr>
  </form>
</table>
<br>
<table width="86%" height="24" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="right">找到符合条件的记录 <b><%=paginator.getTotal() %></b> 条　每页显示 <b><%=paginator.getPageSize() %></b> 条　页次 <b><%=paginator.getCurrentPage() %>/<%=paginator.getTotalPages() %></b></td>
  </tr>
</table>
<table width="86%" border="0" align="center" cellpadding="0" cellspacing="1" class="tableCommon80">
  <thead>
    <td width="26%">商店名称</td>
    <td width="21%">用户</td>
    <td width="16%">开店日期</td>
  </thead>
  <%
com.redmoon.forum.person.UserMgr um = new com.redmoon.forum.person.UserMgr();		  
Vector v = asd.list(sql, (curpage-1)*pagesize, curpage*pagesize-1);
Iterator ir = v.iterator();
int i = 0;
while (ir.hasNext()) {
	asd = (AuctionShopDb)ir.next();
	i++;
%>
  <form id="form<%=i%>" name="form<%=i%>" action="?op=modify" method="post">
    <tr align="center">
      <td height="22" align="left" bgcolor="#FFFFFF"><a target=_blank href="../../plugin/auction/shop.jsp?userName=<%=StrUtil.UrlEncode(asd.getUserName())%>"><%=StrUtil.toHtml(asd.getShopName())%></a> </td>
      <td height="22" align="left" bgcolor="#FFFFFF"><a href="../../../userinfo.jsp?username=<%=StrUtil.UrlEncode(asd.getUserName())%>"><%=StrUtil.toHtml(um.getUser(asd.getUserName()).getNick())%></a></td>
      <td align="left" bgcolor="#FFFFFF"><%=DateUtil.format(asd.getOpenDate(), "yy-MM-dd HH:mm:ss")%></td>
    </tr>
  </form>
  <%}%>
</table>
<table width="86%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
  <tr>
    <td height="23" align="right">
    <%
	String querystr = "action=" + action + "&kind=" + kind + "&value=" + StrUtil.UrlEncode(value);
    out.print(paginator.getCurPageBlock("?"+querystr));
	%>
    </td>
  </tr>
</table>
<br>
</div>
<%@ include file="../../inc/footer.jsp"%>
</div>
</BODY>
<script>
function DelShop(userName) {
	if (confirm("您确定要删除么？\n删除商店时将连同用户已发布的商品一起删除！")) {
		window.location.href = "?op=del&userName=" + userName;
	}
}
</script>
</HTML>
