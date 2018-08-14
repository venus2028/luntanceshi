<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.guestbook.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>留言簿</title>
<link href="shopskin/default/skin.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.style1 {font-size: 16px}
.style2 {
	color: #FFFFFF;
	font-weight: bold;
}
.style4 {color: #000000}
-->
</style>
</head>
<body leftmargin="0" topmargin="5">
<jsp:useBean id="msg" scope="page" class="cn.js.fan.module.guestbook.MessageDb"/>
<jsp:useBean id="form" scope="page" class="cn.js.fan.security.Form"/>
<%
String content = ParamUtil.get(request, "content");
String shopCode = ParamUtil.get(request, "shopCode");
if (shopCode.equals("")) {
	out.print(SkinUtil.makeErrMsg(request, "编码不能为空！"));
	return;
}
AuctionShopDb as = new AuctionShopDb();
as = as.getAuctionShopDb(shopCode);
%>
<table width="550" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="550" height="52" align="center"><strong><span class="guestbook_title"><a href="shop.jsp?userName=<%=StrUtil.UrlEncode(as.getUserName())%>"><%=StrUtil.toHtml(as.getShopName())%></a>的留言簿</span></strong></td>
  </tr>
  <tr>
    <td valign="top">
<%
if (!content.equals(""))
{
	boolean cansubmit = false;
	try {
		cansubmit = form.cansubmit(request,"guestbook");//防止重复刷新	
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
	if (cansubmit) {

		String ip = request.getRemoteAddr();
		String username = ParamUtil.get(request, "username");
		if (username.trim().equals(""))
			username = "匿名";
		try {
			// 检查验证码
			cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
			if (cfg.getBooleanProperty("cms.site_guestbook_validate_code")) {
			   cn.js.fan.security.ValidateCodeCreator.validate(request);
			}
			msg.setContent(content);
			msg.setUserName(username);
			msg.setIp(ip);
			msg.setShopCode(shopCode);
			msg.create();
		}
		catch (ErrMsgException e) {
			out.print(StrUtil.Alert_Back(e.getMessage()));
			return;
		}
	}
}

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
<% if(paginator.getTotal()>0){ %>
                <table width="91%" border="0" cellspacing="0" cellpadding="0" align="center" class="p9" height="24">
                  <tr>
                    <td width="100%" height="24" valign="bottom"><div align="right">共 <b><%=paginator.getTotal() %></b> 条　每页<b><%=paginator.getPageSize() %></b> 条　<b><%=curpage %>/<%=totalpages %></b>
                          <%
 	  out.print(paginator.getCurPageBlock("?"+querystr));
	  %>
                    </div></td>
                  </tr>
                </table>
                <%}%>
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr bgcolor="#4A7D00">
                    <td height="4" colspan="2"></td>
                  </tr>
                  <tr>
                    <td width="153" height="24" background="shopskin/default/images/guestbookbar.gif">&nbsp;&nbsp;<span class="text_white_bold">本店最新留言</span></td>
                    <td align="right">&nbsp;&nbsp;</td>
                  </tr>
                </table>
        <%
while (ri.hasNext()) {
 	MessageDb md = (MessageDb)ri.next(); %>
        <table width="98%" border="0" align="center" cellpadding="5" cellspacing="0" class="tableframe">
          <tr>
            <td width="27%" height="22" valign="bottom" class="stable style4">用户：<%=StrUtil.toHtml(md.getUserName())%>　</td>
            <td width="73%" height="22" valign="bottom" class="stable style4">留言日期：<%=DateUtil.format(md.getLydate(), "yy-MM-dd HH:mm:ss")%></td>
          </tr>
          <tr valign="top">
            <td height="83" colspan="2" class="stable"><%=StrUtil.toHtml(md.getContent())%><br>
                <%
				  String reply = StrUtil.getNullString(md.getReply());
				  if (!reply.equals(""))
				  {
				  %>
                <br>
                <font color="#F09F6F">回复：</font><%=StrUtil.toHtml(reply)%> <br>
            	日期：<%=DateUtil.format(md.getLydate(), "yy-MM-dd HH:mm:ss")%>
            <% } %>
            </td>
          </tr>
          <tr valign="top">
            <td height="1" colspan="2" bgcolor="#666666"></td>
          </tr>
        </table>
        <br>
        <%}
%>
        <% if(paginator.getTotal()>0){ %>
        <table width="91%" border="0" cellspacing="0" cellpadding="0" align="center" class="p9" height="24">
          <tr>
            <td width="100%" height="24" valign="bottom"><div align="right">共 <b><%=paginator.getTotal() %></b> 条　每页<b><%=paginator.getPageSize() %></b> 条　<b><%=curpage %>/<%=totalpages %></b>
                    <%
 	  out.print(paginator.getCurPageBlock("?"+querystr));
	  %>
            </div></td>
          </tr>
        </table>
<%}%>
        <br>
        <table width="76%" height="150" border="0" align="center" cellpadding="1" cellspacing="0" class="table_frame_gray">
		<form action="?" method="post">
          <tr align="center" bgcolor="#4A7D00">
            <td height="24" colspan="3"><span class="style2">请 您 留 言</span></td>
          </tr>
          <tr>
            <td align="center">用户</td>
            <td width="89%" colspan="2"><input name=username size="15">
                <input name=shopCode type=hidden value="<%=shopCode%>">
			验证码&nbsp;
			<%
			cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
			if (cfg.getBooleanProperty("cms.site_guestbook_validate_code")) {
			%>				
                <input name="validateCode" type="text" size="1">
                <img src='<%=request.getContextPath()%>/validatecode.jsp' border=0 align="absmiddle" style="cursor:hand" onClick="this.src='<%=request.getContextPath()%>/validatecode.jsp'" alt="<lt:Label res="res.label.forum.index" key="refresh_validatecode"/>">
			<%}%>				
			</td>
          </tr>
          <tr>
            <td width="11%" align="center">留言<br>
      内容</td>
            <td colspan="2"><textarea name="content" cols="45" rows="8"></textarea>
            </td>
          </tr>
          <tr>
            <td colspan="3" align="center"><div align="left"> </div>
                <input name="submit" type="submit" class="stable" value="发送留言"></td>
          </tr></form>
        </table></td>
  </tr>
  <tr>
    <td height="9">&nbsp;</td>
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
