<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%
String what = ParamUtil.get(request, "what");
String action = ParamUtil.get(request, "action");
String kind = ParamUtil.get(request, "kind");
int checkStatus = ParamUtil.getInt(request, "checkStatus", -1);

int doc_id = ParamUtil.getInt(request, "doc_id");
Document doc = new Document();
doc = doc.getDocument(doc_id);

String orderBy = ParamUtil.get(request, "orderBy");
if (orderBy.equals(""))
	orderBy = "add_date";
String sort = ParamUtil.get(request, "sort");
if (sort.equals(""))
	sort = "desc";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>管理评论</title>
<link href="../common.css" rel="stylesheet" type="text/css">
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}
.style1 {
	font-size: 14px;
	font-weight: bold;
}
-->
</style>
<script src="../inc/common.js"></script>
<script>
function selAllCheckBox(checkboxname){
	var checkboxboxs = document.all.item(checkboxname);
	if (checkboxboxs!=null)
	{
		// 如果只有一个元素
		if (checkboxboxs.length==null) {
			checkboxboxs.checked = true;
		}
		for (i=0; i<checkboxboxs.length; i++)
		{
			checkboxboxs[i].checked = true;
		}
	}
}

function clearAllCheckBox(checkboxname) {
	var checkboxboxs = document.all.item(checkboxname);
	if (checkboxboxs!=null)
	{
		// 如果只有一个元素
		if (checkboxboxs.length==null) {
			checkboxboxs.checked = false;
		}
		for (i=0; i<checkboxboxs.length; i++)
		{
			checkboxboxs[i].checked = false;
		}
	}
}

var curOrderBy = "<%=orderBy%>";
var sort = "<%=sort%>";
function doSort(orderBy) {
	if (orderBy==curOrderBy)
		if (sort=="asc")
			sort = "desc";
		else
			sort = "asc";
	window.location.href = "comment_m.jsp?action=<%=action%>&what=<%=what%>&checkStatus=<%=checkStatus%>&kind=<%=kind%>&orderBy=" + orderBy + "&sort=" + sort + "&doc_id=<%=doc_id%>";
}

function pass(isPass) {
	var ids = getCheckboxValue("ids");
	if (ids=="") {
		alert("请选择评论！");
		return;
	}
	window.location.href = "comment_m.jsp?op=check&isPass=" + isPass + "&ids=" + ids + "&action=<%=action%>&what=<%=what%>&checkStatus=<%=checkStatus%>&kind=<%=kind%>&orderBy=<%=orderBy%>&sort=<%=sort%>&doc_id=<%=doc_id%>";
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, PrivDb.PRIV_ADMIN))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String op = ParamUtil.get(request, "op");

CommentMgr cm = new CommentMgr();
if (op.equals("del")) {
	try {
		if (cm.del(request, privilege))
			out.print(StrUtil.Alert("删除成功！"));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
}
else if (op.equals("delall")) {
	try {
		cm.delAll(request, privilege);
		out.print(StrUtil.Alert("删除成功！"));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
}
else if (op.equals("check")) {
	boolean isPass = ParamUtil.get(request, "isPass").equals("true");
	String ids = ParamUtil.get(request, "ids");
	String[] ary = StrUtil.split(ids, ",");
	if (ary!=null) {
		for (int i=0; i<ary.length; i++) {
			CommentDb cd = cm.getCommentDb(StrUtil.toInt(ary[i]));
			cd.setCheckStatus(isPass?CommentDb.STATUS_PASS:CommentDb.STATUS_NOT);
			cd.save(new JdbcTemplate());
		}
	}
	out.print(StrUtil.Alert_Redirect("操作完成！", "comment_m.jsp?action=" + action + "&kind=" + kind + "&what=" + StrUtil.UrlEncode(what) + "&checkStatus=" + checkStatus + "&orderBy=" + orderBy + "&sort=" + sort + "&doc_id=" + doc_id));
	return;
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">管理评论&nbsp;-&nbsp;<%=doc.getTitle()%></td>
    </tr>
  </tbody>
</table>
<br>
<table width="98%" align="center" class="p9">
  <tr>
    <td><a target="_blank" href="../doc_view.jsp?id=<%=doc_id%>">查看文章</a>
    ┆&nbsp;<a href="../<%=DocumentMgr.getWebEditPage()%>?op=edit&id=<%=doc_id%>&dir_code=<%=StrUtil.UrlEncode(doc.getDirCode())%>">编辑文章</a></td>
  </tr>
</table>
<%
String sql = "select id from cms_comment where doc_id=" + doc_id;

if (action.equals("search")) {
	if (kind.equals("content"))
		sql += " and content like " + StrUtil.sqlstr("%" + what + "%");
	else
		sql += " and nick like " + StrUtil.sqlstr("%" + what + "%");

	if (checkStatus!=-1) {
		sql += " and check_status=" + checkStatus;
	}
}

sql += " order by " + orderBy + " " + sort;

// out.print(sql);

String strcurpage = StrUtil.getNullString(request.getParameter("CPages"));
if (strcurpage.equals(""))
	strcurpage = "1";
if (!StrUtil.isNumeric(strcurpage)) {
	out.print(StrUtil.makeErrMsg("标识非法！"));
	return;
}

int pagesize = 20;
int curpage = 1;
try {
	curpage = Integer.parseInt(strcurpage);
}
catch (Exception e) {
}

CommentDb cmt = new CommentDb();
ListResult lr = cmt.listResult(sql, curpage, pagesize);		

Paginator paginator = new Paginator(request, lr.getTotal(), pagesize);
// 设置当前页数和总页数
int totalpages = paginator.getTotalPages();
if (totalpages==0)
{
	curpage = 1;
	totalpages = 1;
}
%>
<br>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <form name="formSearch" method="get" action="comment_m.jsp">
    <tr>
      <td align="center">  
	  审核状态
	  <select name="checkStatus">
	  <option value="-1">不限</option>
	  <option value="<%=CommentDb.STATUS_PASS%>">通过</option>
	  <option value="<%=CommentDb.STATUS_NOT%>">未通过</option>
	  <option value="<%=CommentDb.STATUS_WAIT%>">待审核</option>
	  </select>	  
	  <select name="kind">
	  <option value="content">内容</option>
	  <option value="nick">发布者</option>
	  </select>
	  <%if (action.equals("search")) {%>
	  <script>
	  formSearch.checkStatus.value = "<%=checkStatus%>";
	  formSearch.kind.value = "<%=kind%>";
	  </script>
	  <%}%>
	  <input name="what" value="<%=what%>">
          <input name="submit" type="submit" value="搜索">
      <input name="action" value="search" type="hidden">
      <input name="doc_id" value="<%=doc_id%>" type="hidden">
	  
	  </td>
    </tr>
  </form>
</table>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="98%" align="center">
  <tbody>
    <tr>
      <td width="4%" noWrap class="thead" style="PADDING-LEFT: 10px"><input name="checkbox" type="checkbox" onClick="if (this.checked) selAllCheckBox('ids'); else clearAllCheckBox('ids')" /></td>
      <td width="32%" noWrap class="thead" style="PADDING-LEFT: 10px">评论</td>
      <td width="7%" noWrap class="thead" style="PADDING-LEFT: 10px;cursor:pointer" onClick="doSort('check_status')"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
	  审核
		<%if (orderBy.equals("check_status")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%>	  </td>
      <td width="10%" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="images/tl.gif" align="absMiddle" width="10" height="15">发布者</td>
      <td width="14%" noWrap class="thead" style="PADDING-LEFT: 10px;cursor:pointer" onClick="doSort('add_date')"><img src="images/tl.gif" align="absMiddle" width="10" height="15">发表时间
		<%if (orderBy.equals("add_date")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%>	  </td>
      <td width="9%" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">操作</td>
    </tr>
<%
Iterator ir = lr.getResult().iterator();
while (ir.hasNext()) {
 	cmt = (CommentDb)ir.next();
%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px"><input name="ids" type="checkbox" value="<%=cmt.getId()%>" /></td>    
      <td style="PADDING-LEFT: 10px" title="<%=StrUtil.toHtml(cmt.getContent())%>">
	  <%=StrUtil.toHtml(StrUtil.getLeft(cmt.getContent(), 50))%>      
      <td style="PADDING-LEFT: 10px"><%=CommentDb.getCheckStatusDesc(cmt.getCheckStatus())%></td>
      <td style="PADDING-LEFT: 10px" title="IP：<%=cmt.getIp()%>"><%=cmt.getNick()%></td>
      <td style="PADDING-LEFT: 10px"><%=DateUtil.format(cmt.getAddDate(), "yy-MM-dd HH:mm")%></td>
      <td colspan="3" align="left"><span>[ <a onClick="if (!confirm('您确定要删除吗？')) return false" href="?op=del&doc_id=<%=doc_id%>&id=<%=cmt.getId()%>&action=<%=action%>&what=<%=what%>&checkStatus=<%=checkStatus%>&kind=<%=kind%>&orderBy=<%=orderBy%>&sort=<%=sort%>">删除</a> ] </span></td>
    </tr>
<%}%>
  </tbody>
</table>
<table width="98%" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr>
    <td width="49%" align="left">
	<input name="button" type="button" onClick="pass(true)" value="通过" >
	&nbsp;&nbsp;
	<input name="button" type="button" onClick="pass(false)" value="不通过" >
	</td>
    <td width="51%" align="right"><%
	String querystr = "action=" + action + "&what=" + what + "&kind=" + kind + "&checkStatus=" + checkStatus + "&orderBy=" + orderBy + "&sort=" + sort + "&doc_id=" + doc_id;
    out.print(paginator.getCurPageBlock("?"+querystr));
%></td>
  </tr>
</table>
</body>
</html>