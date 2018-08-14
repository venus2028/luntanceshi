<%@ page contentType="text/html;charset=utf-8"
import = "cn.js.fan.util.*"
%>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege" />
<%
privilege.logout(request, response);
//out.print(StrUtil.p_center("您已安全退出"));
String privurl = ParamUtil.get(request, "privurl");
if (!privurl.equals(""))
	response.sendRedirect(privurl);
else
	response.sendRedirect("index.jsp");
%>
