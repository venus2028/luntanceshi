<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE>删除留言</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<META content="MSHTML 6.00.2600.0" name=GENERATOR></HEAD>
<BODY bgColor=#ffffff leftMargin=0 topMargin=3 marginheight="3" marginwidth="0">
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, "admin")) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String id = request.getParameter("id");
if (id==null || !StrUtil.isNumeric(id)) {
	out.println(StrUtil.Alert_Redirect("未选择留言标识！","guestbook_list.jsp"));
	return;
}

cn.js.fan.module.guestbook.MessageDb msg = new cn.js.fan.module.guestbook.MessageDb();
msg = msg.getMessageDb(StrUtil.toInt(id));
String shopCode = ParamUtil.get(request, "shopCode");
boolean re = false;
try {	
	re = msg.del();
}
catch (ErrMsgException e) {
	out.print(StrUtil.Alert_Back(e.getMessage()));
}
if (re) {
	out.println(StrUtil.Alert_Redirect("删除留言成功！", "guestbook_list.jsp?shopCode=" + shopCode));
}
%>
</BODY></HTML>
