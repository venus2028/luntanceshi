<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.db.Paginator"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.security.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.cms.search.Indexer"%>
<%@ page import="org.apache.lucene.search.*,org.apache.lucene.document.*" %>
<%
	String queryString = ParamUtil.get(request, "queryString");
	if(queryString.equals("")){
		out.print(StrUtil.Alert_Redirect("请填写关键字！","search.jsp"));
		return;
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>全文检索 - <%=Global.AppName%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="template/css.css" type="text/css" rel="stylesheet" />
<style type="text/css">
<!--
.STYLE2 {color: #FFFFFF}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="fchar" scope="page" class="cn.js.fan.util.StrUtil"/>
<div class="content">
<%@ include file="header.jsp"%>
<%
	String fieldName = ParamUtil.get(request, "fieldName");
	Indexer indexer = new Indexer();
	Hits hits = indexer.seacher(queryString, fieldName);
	if (hits==null || hits.length()==0) {
		out.print(SkinUtil.makeInfo(request, "未找到符合条件的记录！"));
		return;
	}	
%>
<table width="100%" height="577" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top">
<%
	int pagesize = 10;
	Paginator paginator = new Paginator(request);
	int curpage = paginator.getCurPage();
	paginator.init(hits.length(), pagesize);
	
	// 设置当前页数和总页数
	int totalpages = paginator.getTotalPages();
	if (totalpages==0) {
		curpage = 1;
		totalpages = 1;
	}
%>
      <table width="92%" border="0" align="center" class="p9">
        <tr>
          <td height="24" align="right">找到符合条件的记录 <b><%=paginator.getTotal() %></b> 条　每页显示 <b><%=paginator.getPageSize() %></b> 条　页次 <b><%=paginator.getCurrentPage() %>/<%=paginator.getTotalPages() %></b></td>
        </tr>
      </table>
      <table width="96%"  border="0" align="center" cellpadding="1" cellspacing="1">
        <tr>
          <td width="71%" height="21" align="center" bgcolor="#F3F7FA" class="line6">标&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 题</td>
          <td width="19%" align="center" bgcolor="#F3F7FA" class="line6">日 期</td>
          <td width="10%" align="center" bgcolor="#F3F7FA" class="line6">点击率</td>
        </tr>
      </table>
      <table width=96% height="28" border=0 align="center" cellpadding="0" cellspacing="1" class="p9">
<%
	String title = "", modifiedDate="";
	int id = -1;
	int hit=0, i=0;
	int j = (curpage-1)*pagesize;
	
	if (j>hits.length()-1)
		j = hits.length() - 1;
	int end = curpage*pagesize;
	
	if (end>hits.length())
		end = hits.length();
	
	cn.js.fan.module.cms.Document document = null;
	cn.js.fan.module.cms.DocumentMgr dm = new cn.js.fan.module.cms.DocumentMgr();
	while (j < end) {
		org.apache.lucene.document.Document doc = hits.doc(j);
		id = Integer.parseInt(doc.get("id"));
		document = dm.getDocument(id);
		if (document==null || !document.isLoaded()) {
			j++;
			continue;
		}
		title = document.getTitle();
		hit = document.getHit();
		modifiedDate = DateUtil.format(document.getModifiedDate(), "yyyy-MM-dd");		
		String bgcolor = "";
		if (i==1)
			bgcolor = "#F2F2F2";
		else if (i==0)
			bgcolor = "";
		i++;
		if (i==2)
			i = 0;
		%>
		<tr>
          <td width="71%" height=23 align="left" bgcolor="<%=bgcolor%>">&nbsp;
			  <a href="doc_view.jsp?id=<%=id%>"><%=title%></a>
          </td>
          <td width="19%" align="center" bgcolor="<%=bgcolor%>">[<%=modifiedDate%>]</td>
		  <td width="10%" align="center" bgcolor="<%=bgcolor%>"><%=hit%></td>
		</tr>
<%
		j++;
	}
%>
      </table>      <table width="92%"  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td height="26" align="right">
<%
	String querystr = "queryString=" + StrUtil.UrlEncode(queryString) + "&fieldName=" + StrUtil.UrlEncode(fieldName);
    out.print(paginator.getCurPageBlock("search_full_text_do.jsp?"+querystr));
%>       </td>
        </tr>
      </table></td>
  </tr>
</table>
</div>
<%@ include file="footer.jsp"%>
</body>
</html>