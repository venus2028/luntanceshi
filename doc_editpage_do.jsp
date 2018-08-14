<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<%
Privilege privilege = new Privilege();
String op = ParamUtil.get(request, "op");
if (op.equals("del")) {
	int docId = ParamUtil.getInt(request, "docId");
	int pageNum = ParamUtil.getInt(request, "pageNum");
	Document doc = new Document();
	doc = doc.getDocument(docId);
	DocContent dc = doc.getDocContent(pageNum);
	if (dc.del()) {
%>
<link href="common.css" rel="stylesheet" type="text/css">
<link href="admin/default.css" rel="stylesheet" type="text/css">
<table align="left" width="200"><tr><td align="left">
<%	
		String op_success = SkinUtil.LoadString(request, "info_op_success");
		out.print(StrUtil.waitJump(op_success + "<br><BR><a href='fckwebedit.jsp?op=edit&dir_code=" + StrUtil.UrlEncode(doc.getDirCode()) + "&id=" + doc.getID() + "'>点击此处返回</a>", 3, "fckwebedit.jsp?op=edit&dir_code=" + StrUtil.UrlEncode(doc.getDirCode()) + "&id=" + doc.getID()));
%>
</td></tr></table>
<%		
	}
	else {
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
	}
	return;
}

boolean re = false;
try {
	re = docmanager.OperatePage(application, request, privilege);
}
catch(ErrMsgException e) {
	out.print(e.getMessage());
}
if (re) {
	out.print(SkinUtil.LoadString(request, "info_operate_success")) ;
}
%>