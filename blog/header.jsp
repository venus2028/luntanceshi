<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.UserConfigDb"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<script language="JavaScript">
function hopenWin(url,width,height)
{
  var newwin = window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,top=50,left=120,width="+width+",height="+height);
}
</script>
<%
UserConfigDb headerUcd = (UserConfigDb)request.getAttribute("UserConfigDb");
if (headerUcd!=null && !headerUcd.isValid()) {
	out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request,"res.label.blog.header", "blog_alert")));
	return;	
}
if (!headerUcd.isOpen()) {
	out.print(SkinUtil.makeErrMsg(request, "该博客已关闭"));
	return;	
}
%>