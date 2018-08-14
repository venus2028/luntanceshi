<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import = "cn.js.fan.util.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE>删除留言</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<META content="MSHTML 6.00.2600.0" name=GENERATOR></HEAD>
<BODY bgColor=#ffffff leftMargin=0 topMargin=3 marginheight="3" marginwidth="0">
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isUserLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String id = request.getParameter("id");
if (id==null || !StrUtil.isNumeric(id))
{
	out.println(StrUtil.Alert_Redirect("未选择留言标识！","guestbookm.jsp"));
	return;
}

String opType = ParamUtil.get(request, "opType");
if (!opType.equals("shop")) {
	out.print(StrUtil.Alert_Back("缺少类型！"));
}
%>
<jsp:useBean id="msg" scope="page" class="cn.js.fan.module.guestbook.MessageDb"/>
<%
boolean re = false;
try {
	msg = msg.getMessageDb(Integer.parseInt(id));
	if (!msg.getShopCode().equals(privilege.getUser(request))) {
		out.print(StrUtil.Alert_Back("非法删除！"));
	}
		
	re = msg.del();
}
catch (ErrMsgException e) {
	out.print(StrUtil.Alert_Back(e.getMessage()));
}
if (re)
{
	out.println(StrUtil.Alert_Redirect("删除留言成功！", "guestbook.jsp"));
}
%>
</BODY></HTML>
