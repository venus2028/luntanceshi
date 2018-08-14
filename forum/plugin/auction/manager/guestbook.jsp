<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.guestbook.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>留言簿</title>
<link href="default.css" rel="stylesheet" type="text/css">
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
-->
</style>
</head>
<body leftmargin="0">
<jsp:useBean id="msg" scope="page" class="cn.js.fan.module.guestbook.MessageDb"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isUserLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String shopCode = ParamUtil.get(request, "shopCode");
if (shopCode.equals("")) {
	out.print(StrUtil.Alert("用户名不能为空！"));
	return;
}
String user = privilege.getUser(request);
if (!shopCode.equals(user)) {
	if (!privilege.isMasterLogin(request)) {
		out.print(StrUtil.Alert("对不起，您无权访问！"));
		return;
	}
}
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">管理留言簿</td>
  </tr>
</table>
<br>
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr>
    <td height=20 align="left" class="thead">留言簿</td>
  </tr>
  <tr>
    <td valign="top"><br>
<%
int pagesize = 10;
Paginator paginator = new Paginator(request);

String sql = "select id from guestbook where shopCode=" + StrUtil.sqlstr(shopCode) + " order by lydate desc";
int total = msg.getObjectCount(sql);
paginator.init(total, pagesize);
int curpage = paginator.getCurPage();
//设置当前页数和总页数
int totalpages = paginator.getTotalPages();
if (totalpages==0)
{
	curpage = 1;
	totalpages = 1;
}

Iterator ri = msg.list(sql, (curpage-1)*pagesize, curpage*pagesize-1).iterator();
String querystr = "shopCode=" + StrUtil.UrlEncode(shopCode);
%>
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
            <td width="24%" height="22" valign="bottom" class="stable style4">用户：<%=StrUtil.toHtml(msg.getUserName())%>　</td>
            <td width="43%" height="22" valign="bottom" class="stable style4">留言日期：<%=DateUtil.format(msg.getLydate(), "yy-MM-dd HH:mm:ss")%></td>
            <td width="16%" valign="bottom" class="stable style4"><span class="stable"><a href="guestbook_mod.jsp?id=<%=msg.getId()%>&opType=shop&shopCode=<%=StrUtil.UrlEncode(shopCode)%>">修改/回复</a></span></td>
            <td width="17%" valign="bottom" class="stable style4"><span class="stable"><a href="guestbook_del.jsp?id=<%=msg.getId()%>&opType=shop&shopCode=<%=StrUtil.UrlEncode(shopCode)%>">删除</a></span></td>
          </tr>
          <tr valign="top">
            <td height="83" colspan="4" class="stable"><%=StrUtil.toHtml(msg.getContent())%><br>
                <%
				  String reply = StrUtil.getNullString(msg.getReply());
				  if (!reply.equals(""))
				  {
				  %>
                <font color="#F09F6F"><br>
      回复：</font><%=StrUtil.toHtml(msg.getReply())%> <br>
      回复日期：<%=DateUtil.format(msg.getRedate(), "yy-MM-dd HH:mm:ss")%>
      <%}%>
            </td>
          </tr>
        </table>
        <br>
        <%}
%>
        <br>
        <table width="87%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
          <tr>
            <td height="23"><div align="right">
                <%
    out.print(paginator.getCurPageBlock("guestbook.jsp?"+querystr));
%>
            </div></td>
          </tr>
        </table></td>
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
