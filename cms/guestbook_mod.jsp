<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.guestbook.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
<%
String shopCode = ParamUtil.get(request, "shopCode");
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head"><a href="guestbook_list.jsp?shopCode=<%=shopCode%>">留言簿</a></td>
  </tr>
</table>
<br>
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr>
    <td height=20 align="left" class="thead">修改内容</td>
  </tr>
  <tr>
    <td valign="top" bgcolor="#FFFFFF"><table width="79%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td width="100%" height="23" align="center" valign="bottom">&nbsp;</td>
      </tr>
      <tr>
        <td valign="top" background="../images/tab-b-back.gif"><jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, "admin"))
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
%>
<%
MessageDb msg = new MessageDb();
String dowhat = ParamUtil.get(request, "dowhat");
msg = msg.getMessageDb(Integer.parseInt(id));
if (dowhat.equals("modify"))
{
	String content = ParamUtil.get(request, "content");
	if (content.equals("")) {
		out.println(StrUtil.Alert_Back("留言内容不能为空！"));
	}
	else
	{
		String reply = ParamUtil.get(request, "reply");
		if (reply.equals(""))
			reply = " "; // 防止SQLSERVER的text字段问题		
		boolean isScret = ParamUtil.getInt(request, "isScret", 0)==1;		
		boolean re = false;
		try {
			msg.setContent(content);
			msg.setReply(reply);
			msg.setScret(isScret);			
			re = msg.save();
		}
		catch (ErrMsgException e) {
			out.print(StrUtil.Alert_Back(e.getMessage()));
		}
		if (re) {
			out.print(StrUtil.Alert_Redirect("更新留言成功！", "guestbook_mod.jsp?shopCode=" + shopCode + "&id=" + id));
		}
	}
	return;
}
%>
            <br>
            <table width="94%" border="0" align="center" cellpadding="0" cellspacing="0" class="frame_gray">
              <form name="form1" action="guestbook_mod.jsp" method="post" onSubmit="">
                <tr bgcolor="#D5DADB">
                  <td width="15%" height="24" align="center" bgcolor="#EFEBDE" class="stable">用&nbsp;户&nbsp;名</td>
                  <td width="20%" height="21" bgcolor="#EFEBDE" class="stable"><%=StrUtil.toHtml(msg.getUserName())%></td>
                  <td width="65%" height="21" bgcolor="#EFEBDE" class="stable">留言时间 <%=DateUtil.format(msg.getLydate(), "yy-MM-dd HH:mm:ss")%>
                  <input type=hidden name="id" value="<%=id%>">
                  <input type=hidden name=dowhat value="modify">
                  <input type=hidden name="shopCode" value="<%=shopCode%>">
				  </td>
                </tr>
                <tr>
                  <td width="15%" height="17" align="center" class="stable">内容</td>
                  <td height="17" colspan="2" class="stable"><textarea name=content rows=10 cols="65"><%=StrUtil.HtmlEncode(msg.getContent())%></textarea>
                      <br>                  </td>
                </tr>
                <tr>
                  <td width="15%" height="58" align="center" class="stable">回复</td>
                  <td height="58" colspan="2" class="stable"><textarea name=reply rows=10 cols="65"><%=StrUtil.getNullStr(msg.getReply())%></textarea>                  </td>
                </tr>
                <tr>
                  <td height="22" align="center" class="stable">回复时间</td>
                  <td height="22" align="left" class="stable"><%
			if (msg.getRedate()!=null) {
				out.print(DateUtil.format(msg.getRedate(), "yy-MM-dd HH:mm:ss"));
			}%>
&nbsp;</td>
                  <td height="22" align="left" class="stable"><input name="isScret" type="checkbox" value="1" <%=msg.isScret()?"checked":""%>>
是否私密 </td>
                </tr>
                <tr>
                  <td height="30" colspan="3" align="center"><input type=submit value="发送" name="submit">
&nbsp;&nbsp;
              <input type=reset value="取消" name="reset">                  </td>
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
