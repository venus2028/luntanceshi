<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.guestbook.*"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>留言簿</title>
<link href="../default.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.style1 {font-size: 16px}
.style2 {
	color: #FFFFFF;
	font-weight: bold;
}
.style4 {color: #000000}
.style5 {color: #FF0000}
body {
	margin-top: 0px;
}
.STYLE6 {color: #FF6600}
-->
</style>
</head>
<body leftmargin="0">
<jsp:useBean id="msg" scope="page" class="cn.js.fan.module.guestbook.MessageDb"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String siteCode = ParamUtil.get(request, "siteCode");
SiteDb sd = new SiteDb();
sd = sd.getSiteDb(siteCode);
if (sd==null) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, "站点不存在！"));	
	return;
}
String shopCode = sd.getVisualGuestbookCode();
// 权限检查
if (!SitePrivilege.canManage(request, sd)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">管理留言簿</td>
  </tr>
</table>
<br>
<table width="98%" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr>
    <td height=20 align="left" class="thead">留言簿</td>
  </tr>
  <tr>
    <td valign="top" bgcolor="#FFFFFF"><br>
<%
int pagesize = 10;
Paginator paginator = new Paginator(request);

String action = ParamUtil.get(request, "op");
String sql = "select id from guestbook where shopCode=" + StrUtil.sqlstr(shopCode) + " order by lydate desc";
String what = ParamUtil.get(request, "what");
if (action.equals("search")) {
	sql = "select id from guestbook where shopCode=" + StrUtil.sqlstr(shopCode) + " and content like " + StrUtil.sqlstr("%" + what + "%") + " order by lydate desc";
}
int total = msg.getObjectCount(sql);
paginator.init(total, pagesize);
int curpage = paginator.getCurPage();
int totalpages = paginator.getTotalPages();
if (totalpages==0)
{
	curpage = 1;
	totalpages = 1;
}

Iterator ri = msg.list(sql, (curpage-1)*pagesize, curpage*pagesize-1).iterator();
String querystr = "shopCode=" + StrUtil.UrlEncode(shopCode) + "&action=" + action + "&what=" + what;
%>
        <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
		<form name=formSearch method=post action="site_guestbook.jsp">
          <tr>
            <td align="center">
			<input name="what" value="<%=what%>"><input type="submit" value="搜索">
			<input name="action" value="search" type="hidden">
			<input name="siteCode" value="<%=siteCode%>" type="hidden">
			</td>
          </tr>
		</form>
        </table>
        <table width="95%" height="24" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td align="right"><div>找到符合条件的记录 <b><%=paginator.getTotal() %></b> 条　每页显示 <b><%=paginator.getPageSize() %></b> 条　页次 <b><%=paginator.getCurrentPage() %>/<%=paginator.getTotalPages() %></b></div></td>
          </tr>
        </table>
        <%
while (ri.hasNext()) {
 	msg = (MessageDb)ri.next(); %>
        <table width="98%" border="0" align="center" cellpadding="5" cellspacing="0" class="frame_gray">
          <tr bgcolor="#DDE0E6">
            <td width="24%" height="22" valign="bottom" bgcolor="#EFEBDE" class="stable style4">用户：<%=StrUtil.toHtml(msg.getUserName())%>
			&nbsp;
			<%if (msg.isScret()) {%>
			<span class="STYLE6">(私密留言)</span>
			<%}%>
			</td>
            <td width="43%" valign="bottom" bgcolor="#EFEBDE" class="stable style4">留言日期：<%=DateUtil.format(msg.getLydate(), "yy-MM-dd HH:mm:ss")%></td>
            <td width="16%" valign="bottom" bgcolor="#EFEBDE" class="stable style4"><span class="stable"><a href="site_guestbook_mod.jsp?siteCode=<%=siteCode%>&id=<%=msg.getId()%>">修改/回复</a></span></td>
            <td width="17%" valign="bottom" bgcolor="#EFEBDE" class="stable style4"><span class="stable"><a href="#" onClick="if (confirm('您确定要删除吗？')) window.location.href='site_guestbook_del.jsp?siteCode=<%=siteCode%>&id=<%=msg.getId()%>'">删除</a></span></td>
          </tr>
          <tr valign="top">
            <td colspan="4" class="stable"><%=StrUtil.toHtml(msg.getContent())%><br>
                <%
				  String reply = StrUtil.getNullString(msg.getReply());
				  if (!reply.equals(""))
				  {
				  %>
                <font color="#F09F6F"><br>
      回复内容：</font><%=StrUtil.toHtml(msg.getReply())%> <br>
      回复日期：<%=DateUtil.format(msg.getRedate(), "yy-MM-dd HH:mm:ss")%>
      <%}%>
            </td>
          </tr>
      </table>
        <br>
        <%}
%>
        <br>
<div align="right" style="padding-right:50px">
<%
    out.print(paginator.getCurPageBlock("site_guestbook.jsp?"+querystr));
%>
</div></td>
  </tr>
</table>
</body>
<SCRIPT language=javascript id=clientEventHandlersJS>
<!--
function form1_onsubmit()
{
	if (form1.content.value=="")
	{
		alert("留言内容不能为空！");
		return false;
	}
}
//-->
</SCRIPT>
</html>
