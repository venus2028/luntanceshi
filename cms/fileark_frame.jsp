<%@ page contentType="text/html; charset=utf-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>选择模板</title>
</head>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
String priv="read";
if (!privilege.isUserPrivValid(request,priv)) {
	out.println(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<frameset rows="*" cols="180,*" framespacing="0" border="0">
  <frame src="fileark_left.jsp" name="leftFileFrame" >
  <frame src="fileark_main.jsp" name="mainFileFrame">
</frameset>
<noframes><body>
</body></noframes>
</html>
