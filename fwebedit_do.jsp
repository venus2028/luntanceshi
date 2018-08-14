<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<%
String op = ParamUtil.get(request, "op");
if (op.equals("changeattachname")) {
	if (!privilege.isUserLogin(request)) {
		out.print(SkinUtil.LoadString(request, "err_not_login"));
		return;
	}
	
	int doc_id = ParamUtil.getInt(request, "doc_id");
	int attach_id = ParamUtil.getInt(request, "attach_id");
	int page_num = ParamUtil.getInt(request, "page_num");
	String newname = ParamUtil.get(request, "newname");
	Document doc = new Document();
	doc = doc.getDocument(doc_id);
	DocContent dc = doc.getDocContent(page_num);
	boolean re = dc.updateAttachmentName(attach_id, newname);
	
	if (re) {
        // 生成静态页面
        cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
        boolean isCreateHtml = cfg.getBooleanProperty("cms.html_auto");
        if (isCreateHtml) {	
			docmanager.createHtml(request, doc, page_num);
		}
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request,"info_op_success")));
		%>
		<script>
		// window.parent.location.reload(true);
		</script>
		<%
	}
	else
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
	
	return;
}
else if (op.equals("delAttach")) {
	if (!privilege.isUserLogin(request)) {
		out.print(SkinUtil.LoadString(request, "err_not_login"));
		return;
	}

	int doc_id = ParamUtil.getInt(request, "doc_id");
	int attach_id = ParamUtil.getInt(request, "attach_id");
	int page_num = ParamUtil.getInt(request, "page_num");
	Document doc = new Document();
	doc = doc.getDocument(doc_id);
	DocContent dc = doc.getDocContent(page_num);
	boolean re = dc.delAttachment(attach_id);
	if (re) {
		%>
		<script>
		if (window.confirm("<%=cn.js.fan.web.SkinUtil.LoadString(request, "res.label.webedit","del_success_refresh_page")%>"))
			window.parent.location.reload(true);
		</script>
		<%
	}
	else
		out.print(StrUtil.Alert(SkinUtil.LoadString(request, "info_op_fail")));
	
	return;
}

boolean re = false;
String action = ParamUtil.get(request, "action");
//String isuploadfile = StrUtil.getNullString(request.getParameter("isuploadfile"));
try {
	//if (isuploadfile.equals("false"))
		//re = docmanager.UpdateWithoutFile(request);
	//else
		re = docmanager.Operate(application, request, privilege);
}
catch(ErrMsgException e) {
	//if (isuploadfile.equals("false")) {
	//	out.print(StrUtil.Alert(e.getMessage()));
	//}
	//else
		out.print(e.getMessage());
	e.printStackTrace();
	if (action.equals("fckwebedit_new")) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}
if (re) {
	if (action.equals("fckwebedit_new")) {
		com.redmoon.kit.util.FileUpload fu = docmanager.getFileUpload();
		op = fu.getFieldValue("op");
		int id = StrUtil.toInt(fu.getFieldValue("id"), 0);
%>
<link href="common.css" rel="stylesheet" type="text/css"><BR />
<%	
		Leaf lf = new Leaf();
		lf = lf.getLeaf(docmanager.getDirCode());
		if (op.equals("edit")) {
			String dirLink = "";
			if (lf.getType()==Leaf.TYPE_LIST) {
				dirLink = "<font style='font-family:宋体'>>></font>&nbsp;&nbsp;<a href=\"cms/document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(lf.getCode()) + "\">" + lf.getName() + "</a><BR><BR>";
			}
			out.println(SkinUtil.waitJump(request, dirLink + "<a href='fckwebedit_new.jsp?op=edit&id=" + id + "&dir_code=" + StrUtil.UrlEncode(docmanager.getDirCode()) + "'>" + SkinUtil.LoadString(request,"info_op_success") + "点击此处返回</a>",3,"fckwebedit_new.jsp?op=edit&id=" + id + "&dir_code=" + StrUtil.UrlEncode(docmanager.getDirCode())));			
		}
		else {
			out.print(SkinUtil.waitJump(request, ">>&nbsp;<a href='cms/document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(docmanager.getDirCode()) + "'>" + lf.getName() + "</a>",3,"cms/document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(docmanager.getDirCode())));
			out.print("<ol><a href='" + DocumentMgr.getWebEditPage() + "?op=add&dir_code=" + docmanager.getDirCode() + "'>" + SkinUtil.LoadString(request,"info_op_success") + "继续添加！</a></ol>");		
		}
	} 
	else if (action.equals("post")) {
		out.print(SkinUtil.waitJump(request, "<a href='fckwebedit_post.jsp?dir_code=" + StrUtil.UrlEncode(docmanager.getDirCode()) + "'>" + SkinUtil.LoadString(request,"info_op_success") + "</a>",3,"fckwebedit_post.jsp?dir_code=" + StrUtil.UrlEncode(docmanager.getDirCode())));
	}
	else {
	//if (isuploadfile.equals("false")) {
	//	out.print(StrUtil.Alert_Back(privilege.getUser(request) + "is修改成功！"));
	//}
	//else 
		out.print(SkinUtil.LoadString(request,"info_op_success"));
	}
}
%>