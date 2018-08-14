<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../inc/nocache.jsp"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="cn.js.fan.util.ErrMsgException"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isUserLogin(request))
{ %>
<table width="320" border="0" cellspacing="0" cellpadding="0" align="center" class="9black">
  <tr> 
    <td><li><%=SkinUtil.LoadString(request,"res.label.message.message","msg")%></td>
  </tr>
</table>
<% 
return;
} %>

<jsp:useBean id="Msg" scope="page" class="com.redmoon.forum.message.MessageMgr"/>
<%
boolean isSuccess = false;
try {
	isSuccess = Msg.delMsg(request);
}
catch (ErrMsgException e) {
	out.println(StrUtil.Alert_Back(SkinUtil.LoadString(request,"res.label.message.message","fail_msg") + e.getMessage()));
	return;
}
if (isSuccess) {
	out.println(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.label.message.message","success_msg"), "message.jsp"));
}
else {
	out.println(StrUtil.Alert_Back(SkinUtil.LoadString(request,"res.label.message.message","fail_msg")));
}
%>
