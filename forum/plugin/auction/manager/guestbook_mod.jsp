<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.guestbook.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE>留言簿管理</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<link rel="stylesheet" href="default.css" type="text/css">
<META content="MSHTML 6.00.2600.0" name=GENERATOR>
<style type="text/css">
<!--
.style1 {
	font-size: 16px;
	font-weight: bold;
}
body {
	margin-top: 0px;
}
-->
</style>
</HEAD>
<BODY bgColor=#ffffff leftMargin=0 marginwidth="0">
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">管理<a href="guestbook.jsp">留言簿</a></td>
  </tr>
</table>
<br>
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr>
    <td height=20 align="left" class="thead">修改内容</td>
  </tr>
  <tr>
    <td valign="top"><table width="79%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td width="100%" height="23" align="center" valign="bottom">&nbsp;</td>
      </tr>
      <tr>
        <td valign="top" background="../images/tab-b-back.gif"><jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
          
            <%
if (!privilege.isUserLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String id = request.getParameter("id");
if (id==null || !StrUtil.isNumeric(id))
{
	out.println(StrUtil.makeErrMsg("未选择留言标识！"));
	return;
}

String opType = ParamUtil.get(request, "opType");
if (!opType.equals("shop")) {
	out.print(StrUtil.Alert_Back("缺少类型！"));
}
%>
<%
MessageDb msg = new MessageDb();
String dowhat = ParamUtil.get(request, "dowhat");
msg = msg.getMessageDb(Integer.parseInt(id));
if (dowhat.equals("modify"))
{
	String content = ParamUtil.get(request, "content");
	if (content.equals(""))
	{
		out.println(StrUtil.Alert("留言内容不能为空！"));
	}
	else
	{
		String reply = ParamUtil.get(request, "reply");
		boolean re = false;
		try {
			msg.setContent(content);
			msg.setReply(reply);
			re = msg.save();
		}
		catch (ErrMsgException e) {
			out.print(StrUtil.makeErrMsg(e.getMessage()));
		}
		if (re)
			out.print(StrUtil.Alert("更新留言成功！"));
	}
}
%>
            <br>
            <table width="94%" border="0" align="center" cellpadding="0" cellspacing="0" class="frame_gray">
              <form name="form1" action="guestbook_mod.jsp" method="post" onSubmit="">
                <tr bgcolor="#D5DADB">
                  <td width="15%" height="21" align="center" class="stable">用&nbsp;户&nbsp;名</td>
                  <td width="20%" height="21" class="stable"><%=StrUtil.toHtml(msg.getUserName())%></td>
                  <td width="65%" height="21" class="stable">留言时间 <%=DateUtil.format(msg.getLydate(), "yy-MM-dd HH:mm:ss")%>
                      <input name="opType" type=hidden id="opType" value="<%=opType%>">
                      <input type=hidden name="id" value="<%=id%>">
                      <input type=hidden name=dowhat value="modify"></td>
                </tr>
                <tr>
                  <td width="15%" height="17" align="center" bgcolor="#eeeeee" class="stable">内&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;容</td>
                  <td height="17" colspan="2" bgcolor="#eeeeee" class="stable"><textarea name=content rows=10 cols="65"><%=StrUtil.toHtml(msg.getContent())%></textarea>
                      <br>
                  </td>
                </tr>
                <tr>
                  <td width="15%" height="58" align="center" bgcolor="#eeeeee" class="stable">回&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;复</td>
                  <td height="58" colspan="2" bgcolor="#eeeeee" class="stable"><textarea name=reply rows=10 cols="65"><%=msg.getReply()%></textarea>
                  </td>
                </tr>
                <tr>
                  <td height="22" align="center" bgcolor="#eeeeee" class="stable">回复时间</td>
                  <td height="22" colspan="2" align="left" bgcolor="#eeeeee" class="stable"><%
			if (msg.getRedate()!=null) {
				out.print(DateUtil.format(msg.getRedate(), "yy-MM-dd HH:mm:ss"));
			}%>
&nbsp;</td>
                </tr>
                <tr>
                  <td colspan="3" align="center"><input type=submit value="发送" name="submit">
&nbsp;&nbsp;
              <input type=reset value="取消" name="reset">
                  </td>
                </tr>
              </form>
          </table></td>
      </tr>
      <tr>
        <td height="9">&nbsp;</td>
      </tr>
    </table></td>
  </tr>
</table>
</BODY></HTML>
