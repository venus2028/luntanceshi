<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.plugin.sweet.*"%>
<HTML><HEAD><TITLE>菜单</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<LINK href="default.css" type=text/css rel=stylesheet>
<STYLE type=text/css>.ttl {
	CURSOR: hand; COLOR: #ffffff; PADDING-TOP: 4px
}
body {
	background-color: #9CAECE;
}
</STYLE>
<SCRIPT language=javascript>
  function showHide(obj){
    var oStyle = obj.parentElement.parentElement.parentElement.rows[1].style;
    oStyle.display == "none" ? oStyle.display = "block" : oStyle.display = "none";
  }
</SCRIPT>
<META content="MSHTML 6.00.3790.259" name=GENERATOR></HEAD>
<BODY leftMargin=0 topMargin=0>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
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

%>
<br>
<TABLE cellSpacing=0 cellPadding=0 width=159 align=center border=0>
  <TBODY>
    <TR>
      <TD width=23><IMG height=25 
      src="images/box_topleft.gif" width=23></TD>
      <TD class=ttl onclick=showHide(this) width=129 
    background="images/box_topbg.gif">菜单</TD>
      <TD width=7><IMG height=25 
      src="images/box_topright.gif" width=7></TD>
    </TR>
    <TR>
      <TD 
    style="PADDING-RIGHT: 3px; PADDING-LEFT: 3px; PADDING-BOTTOM: 3px; PADDING-TOP: 3px" 
    background="images/box_bg.gif" colSpan=3><table width="98%"  border="0" align="center" cellspacing="2" class="p9">
        <tr>
          <td height="22"><IMG height=7 hspace=5 
            src="images/arrow.gif" width=5 align=absMiddle><a href="dir_m.jsp?userName=<%=StrUtil.UrlEncode(userName)%>" target="mainFrame">我的目录</a></td>
        </tr>
        <tr>
          <td height="22"><IMG height=7 hspace=5 
            src="images/arrow.gif" width=5 align=absMiddle><a href="commodity_m.jsp?listType=listall&userName=<%=StrUtil.UrlEncode(userName)%>" target="mainFrame">全部商品</a></td>
        </tr>
        <tr>
          <td height="22"><IMG height=7 hspace=5 
            src="images/arrow.gif" width=5 align=absMiddle><a target="mainFrame" href="myorder.jsp?showType=seller&userName=<%=StrUtil.UrlEncode(userName)%>">本店订单</a></td>
        </tr>
        <tr>
          <td height="22"><IMG height=7 hspace=5 
            src="images/arrow.gif" width=5 align=absMiddle><a href="notice.jsp?userName=<%=StrUtil.UrlEncode(userName)%>" target="mainFrame">管理公告</a></td>
        </tr>
        <tr>
          <td height="22"><img height=7 hspace=5 
            src="images/arrow.gif" width=5 align=absMiddle><a target="mainFrame" href="guestbook.jsp?shopCode=<%=StrUtil.UrlEncode(userName)%>">本店留言</a></td>
        </tr>
        <tr>
          <td height="22"><img height=7 hspace=5 
            src="images/arrow.gif" width=5 align=absMiddle><a target="mainFrame" href="../../../../message/message.jsp">短&nbsp;&nbsp;消&nbsp;&nbsp;息</a></td>
        </tr>
        <tr>
          <td height="22"><img height=7 hspace=5 
            src="images/arrow.gif" width=5 align=absMiddle><a target="mainFrame" href="introduction.jsp?userName=<%=StrUtil.UrlEncode(userName)%>">店铺信息</a></td>
        </tr>
        <tr>
          <td height="22"><img height=7 hspace=5 
            src="images/arrow.gif" width=5 align=absMiddle><a target="mainFrame" href="link.jsp?userName=<%=StrUtil.UrlEncode(userName)%>">友情链接</a></td>
        </tr>
        <tr>
          <td height="22"><img height=7 hspace=5 
            src="images/arrow.gif" width=5 align=absMiddle><a target="_blank" href="../shop.jsp?userName=<%=StrUtil.UrlEncode(userName)%>">查看本店</a></td>
        </tr>
        <tr>
          <td height="22"><img height=7 hspace=5 
            src="images/arrow.gif" width=5 align=absMiddle><a target="_blank" href="../../../../forum/index.jsp">进入论坛</a></td>
        </tr>
      </table>
      </TD>
    </TR>
    <TR>
      <TD colSpan=3><IMG height=10 
      src="images/box_bottom.gif" 
width=159></TD>
    </TR>
  </TBODY>
</TABLE>
</BODY></HTML>
