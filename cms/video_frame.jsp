<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>选择模板</title>
</head>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserLogin(request)) {
	out.println(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String action = cn.js.fan.util.ParamUtil.get(request, "action");
String dir = ParamUtil.get(request, "dir");
%>
<frameset rows="*" cols="180,*" framespacing="0" border="0">
  <frame src="video_left.jsp?action=<%=action%>&dir=<%=StrUtil.UrlEncode(dir)%>" name="leftFileFrame" >
  <frame src="video_list.jsp?action=<%=action%>&dir=<%=StrUtil.UrlEncode(dir)%>" name="mainFileFrame">
</frameset>
<noframes><body>
</body></noframes>
</html>
