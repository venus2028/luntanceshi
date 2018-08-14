<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.pvg.Privilege"%>
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<%
Privilege privilege = new Privilege();

boolean re = false;
try {
	re = docmanager.UpdateSummary(application, request, privilege);
}
catch (ErrMsgException e) {
	out.print(e.getMessage());
}
if (re) {
	String action = ParamUtil.get(request, "action");
	if (action.equals("fckwebedit_new")) {
%>
<link href="common.css" rel="stylesheet" type="text/css"><BR />
<%	
		int id = StrUtil.toInt(docmanager.getFileUpload().getFieldValue("id"), 0);
		out.println(SkinUtil.waitJump(request, "<a href='doc_fck_abstract_new.jsp?id=" + id + "'>" + SkinUtil.LoadString(request,"info_op_success") + "</a>",3,"doc_fck_abstract_new.jsp?id=" + id));
	}
	else
		out.print(SkinUtil.LoadString(request, "info_operate_success"));
}
else
	out.print(SkinUtil.LoadString(request, "info_op_fail"));
%>