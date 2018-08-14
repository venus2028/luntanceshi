<%@ page contentType="text/html;charset=utf-8"
import = "cn.js.fan.util.*"
%>
<%@ page import="org.jdom.*"%>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege" />
<%
/*==========UCenter==========*/
	com.redmoon.forum.ucenter.UCenterConfig myconfig = com.redmoon.forum.ucenter.UCenterConfig.getInstance();
	Element uc = myconfig.getRootElement().getChild("uc");
	String isUcActive = uc.getChild("isActive").getText();
	if(isUcActive.equals("true")) {
		out.print(com.redmoon.forum.ucenter.UC.logout());
	}
/*==========UCenter==========*/

privilege.logout(request, response);
// System.out.print(getClass() + " " + StrUtil.p_center("您已安全退出"));
String privurl = ParamUtil.get(request, "privurl");
if (!privurl.equals(""))
	response.sendRedirect(privurl);
else
	response.sendRedirect("forum/index.jsp");
%>
