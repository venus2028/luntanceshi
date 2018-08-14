<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.module.cms.*" %>
<%@ page import="cn.js.fan.util.*" %>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><lt:Label res="res.label.cms.doc" key="select_template_main_window"/></title>
</head>
<body>
<jsp:useBean id="dir" scope="page" class="cn.js.fan.module.cms.Directory"/>
<%
String dir_code = ParamUtil.get(request, "dir_code");
if (dir_code.equals(""))
	dir_code = "template";
Leaf leaf = dir.getLeaf(dir_code);
int type = leaf.getType();
if (type==0) {
	out.print(StrUtil.p_center(SkinUtil.LoadString(request, "res.label.cms.doc", "no_template")));
}
else {
	response.sendRedirect("doc_template_list_m.jsp?dir_code=" +
                      StrUtil.UrlEncode(leaf.getCode()) + "&dir_name=" +
                      StrUtil.UrlEncode(leaf.getName()));
}
%>
</body>
</html>
