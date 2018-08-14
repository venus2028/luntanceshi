<%@ page contentType="text/html; charset=utf-8" %>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
response.setHeader("Pragma","No-cache");
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);
%>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
String priv="read";
if (!privilege.isUserPrivValid(request,priv))
{
	//out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	//return;
}

//String department_id = privilege.getDepartmentID(request);
//String document_id = request.getParameter("document_id");
//String priv = "department";//部门管理
//String user = fchar.UnicodeToGB(request.getParameter("user"));
//String pwd = request.getParameter("pwd");
//if (!document.canModifyDoc(document_id,department_id) && !privilege.isUserPrivValid(user,pwd,priv))
//{
//	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
//	return;
//}

int docId = ParamUtil.getInt(request, "doc_id");
int fileId = ParamUtil.getInt(request, "file_id");

DocumentMgr dm = new DocumentMgr();
Document doc = dm.getDocument(docId);
Attachment att = doc.getAttachment(1, fileId);
if (att==null) {
	out.println(SkinUtil.LoadString(request,"res.label.word","catch_file") + docId + SkinUtil.LoadString(request,"res.label.word","attatch") + fileId + SkinUtil.LoadString(request,"res.label.word","can_not_found"));
	return;
}

String diskName = att.getDiskName();
int len = diskName.length();
String ext = diskName.substring( len-3, len );
if (ext.equals("doc"))
	response.setContentType("application/msword");
else if (ext.equals("xls"))
	response.setContentType("application/vnd.ms-excel");
else {
	out.println(SkinUtil.LoadString(request,"res.label.word","file_format") + ext + SkinUtil.LoadString(request,"res.label.word","error"));
	return;
}

// 载前询问（是打开文件还是保存到计算机）
response.setHeader("Content-disposition","attachment; filename="+att.getDiskName());
// System.out.println("word_get.jsp:" + "Content-disposition=attachment; filename=" + att.getDiskName());
// 通过IE浏览器直接选择相关应用程序插件打开两种方式
// response.setHeader("Content-disposition", "filename="+att.getName());

BufferedInputStream bis = null;
BufferedOutputStream bos = null;

try {
	bis = new BufferedInputStream(new FileInputStream(att.getFullPath()));
	bos = new BufferedOutputStream(response.getOutputStream());
	
	byte[] buff = new byte[2048];
	int bytesRead;
	
	while(-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
		bos.write(buff,0,bytesRead);
	}
} catch(final IOException e) {
	System.out.println ( SkinUtil.LoadString(request,"res.label.word","found") + "IOException." + e + "---" + att.getFullPath());
} finally {
	if (bis != null)
		bis.close();
	if (bos != null)
		bos.close();
}
%>



