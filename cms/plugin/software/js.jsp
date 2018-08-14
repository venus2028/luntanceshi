<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.cms.plugin.software.*"%>
<%
/*
功能：
1、显示文章从第start条至第end条，当start>=0时，显示软件下载排行的列表
2、len标题长度
3、dirCode软件所属目录
4、parentCode软件所属目录的父目录
5、count=y是否显示下载计数
*/

Document doc = new Document();
int start = ParamUtil.getInt(request, "start", 0);
int len = ParamUtil.getInt(request, "len", 20);
if (start>=0) {
	String dirCode = ParamUtil.get(request, "dirCode");
	String parentCode = ParamUtil.get(request, "parentCode");
	int end = ParamUtil.getInt(request, "end", 10);
	String sql;
	if (!dirCode.equals(""))
		sql = "select doc_id from cws_cms_software_doc where dir_code=" + StrUtil.sqlstr(dirCode) + " order by download_count desc";
	else
		sql = "select doc_id from cws_cms_software_doc where parent_code=" + StrUtil.sqlstr(parentCode) + " order by download_count desc";
	boolean isCount = ParamUtil.get(request, "count").equals("y");
	SoftwareDocumentDb sdd2 = new SoftwareDocumentDb();

	// 当缓存失效时才会刷新
   	Iterator ir = doc.getDocuments(sql, "plugin.software", start, end);
	
	out.println("document.write('<ul>');");	
	
	while (ir.hasNext()) {
		doc = (Document)ir.next();
		String t = StrUtil.getLeft(StrUtil.toHtml(doc.getTitle()), len);
		if (isCount) {
			SoftwareDocumentDb sdd = sdd2.getSoftwareDocumentDb(doc.getId());
			out.println("document.write('<span style=\"float:right\">[" + sdd.getDownloadCount()  + "]</span>');");
		}
		
		out.println("document.write('<li>');");
		%>
		document.write('<a href="<%=Global.getRootPath()%>/doc_view.jsp?id=<%=doc.getId()%>"><%=StrUtil.toHtml(t)%></a>');
		<%
		out.println("document.write('</li>');");
	}
	out.println("document.write('</ul>');");
}
%>