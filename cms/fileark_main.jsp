<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.module.cms.*" %>
<%@ page import="cn.js.fan.util.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>选择模板-主窗口</title>
<LINK href="default.css" type=text/css rel=stylesheet>
</head>
<body>
<jsp:useBean id="dir" scope="page" class="cn.js.fan.module.cms.Directory"/>
<%
String dir_code = ParamUtil.get(request, "dir_code");
if (dir_code.equals(""))
	dir_code = "template";
Leaf leaf = dir.getLeaf(dir_code);
if (leaf==null) {
	out.print(StrUtil.p_center("<br>请选择目录"));
	return;
}
int type = leaf.getType();
if (leaf.getCode().equals(Leaf.ROOTCODE)|| type==Leaf.TYPE_NONE) {
	response.sendRedirect("dir_common.jsp?dir_code=" + StrUtil.UrlEncode(leaf.getCode()));
}
else {
	if (leaf.getType()==Leaf.TYPE_DOCUMENT)
		response.sendRedirect("../fckwebedit.jsp?op=editarticle&dir_code=" + StrUtil.UrlEncode(leaf.getCode()));
	else if (leaf.getType()==Leaf.TYPE_LIST) {
		response.sendRedirect("document_list_m.jsp?dir_code=" +
                      StrUtil.UrlEncode(leaf.getCode()) + "&dir_name=" +
                      StrUtil.UrlEncode(leaf.getName()));
	}
	else if (leaf.getType()==Leaf.TYPE_SUB_SITE) {
		response.sendRedirect("subsite.jsp?dir_code=" + StrUtil.UrlEncode(leaf.getCode()));
	}
	else if (leaf.getType()==Leaf.TYPE_COLUMN) {
		response.sendRedirect("column.jsp?dir_code=" + StrUtil.UrlEncode(leaf.getCode()));
	}
	else if (leaf.getType()==Leaf.TYPE_NONE) {
		response.sendRedirect("dir_type.jsp?dir_code=" + StrUtil.UrlEncode(leaf.getCode()));
	}
}
%>
</body>
</html>
