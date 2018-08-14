<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*" %>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.cms.doc" key="mgr_login"/></title>
<link href="../common.css" rel="stylesheet" type="text/css">
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
<script>
function selTemplate(id)
{
	window.parent.dialogArguments.selTemplate(id);
	window.close();	
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<jsp:useBean id="dir" scope="page" class="cn.js.fan.module.cms.Directory"/>
<%
if (!privilege.isUserLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<%
String sql = "select class1,title,id,isHome,examine from document";
String op = StrUtil.getNullString(request.getParameter("op"));
String dir_code = ParamUtil.get(request, "dir_code");
String dir_name = ParamUtil.get(request, "dir_name");
Leaf leaf = dir.getLeaf(dir_code);
if (op.equals("del")) {
	int id = ParamUtil.getInt(request, "id");
	if (docmanager.del(request, id, privilege, true))
		out.print(StrUtil.Alert(SkinUtil.LoadString(request, "res.label.cms.doc","success_del")));
	else
		out.print(StrUtil.Alert(SkinUtil.LoadString(request, "res.label.cms.doc","failure_del")));
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head"><%=dir_name.equals("")?SkinUtil.LoadString(request, "res.label.cms.doc","search_result"):dir_name%>&nbsp;</td>
    </tr>
  </tbody>
</table>
<%
String what = "";
if (op.equals("search")) {
	what = StrUtil.UnicodeToUTF8(StrUtil.getNullString(request.getParameter("what")));
	sql += " where title like "+StrUtil.sqlstr("%"+what+"%")+" or content like "+StrUtil.sqlstr("%"+what+"%"); 
}
else {
	if (!dir_code.equals(""))
		sql += " where class1=" + StrUtil.sqlstr(dir_code);
}
sql += " order by examine asc, isHome desc, modifiedDate desc";
String strcurpage = StrUtil.getNullString(request.getParameter("CPages"));
if (strcurpage.equals(""))
	strcurpage = "1";
if (!StrUtil.isNumeric(strcurpage)) {
	out.print(StrUtil.makeErrMsg(SkinUtil.LoadString(request, "res.label.cms.doc","id_illegal")));
	return;
}
int pagesize = 15;
int curpage = Integer.parseInt(strcurpage);
PageConn pageconn = new PageConn(Global.defaultDB, Integer.parseInt(strcurpage), pagesize);
ResultIterator ri = pageconn.getResultIterator(sql);
ResultRecord rr = null;

Paginator paginator = new Paginator(request, pageconn.getTotal(), pagesize);
//设置当前页数和总页数
int totalpages = paginator.getTotalPages();
if (totalpages==0)
{
	curpage = 1;
	totalpages = 1;
}
%>
<br>
<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" class="p9">
  <form name="form1" action="document_list_m.jsp?op=search" method="post">
    <tr>
      <td align="center"><lt:Label res="res.label.cms.doc" key="search_artical"/>&nbsp;
          <input name=what class="singleboarder" size=20>
          <input type=submit class="singleboarder" value="<%=SkinUtil.LoadString(request, "res.label.cms.doc","search")%>">
      (<lt:Label res="res.label.cms.doc" key="search_key_words"/>)</td>
    </tr>
  </form>
</table>
<br>
<table width="92%" border="0" align="center" class="p9">
  <tr>
    <td height="24" align="right"><lt:Label res="res.label.cms.doc" key="found_right_list"/> <b><%=paginator.getTotal() %></b><lt:Label res="res.label.cms.doc" key="page_list"/><b><%=paginator.getPageSize() %></b><lt:Label res="res.label.cms.doc" key="page"/><b><%=paginator.getCurrentPage() %>/<%=paginator.getTotalPages() %></b></td>
  </tr>
</table>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="95%" align="center">
  <tbody>
    <tr>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="11%"><lt:Label res="res.label.cms.doc" key="num"/></td>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="39%"><lt:Label res="res.label.cms.doc" key="title"/></td>
      <td class="thead" noWrap width="20%"><img src="images/tl.gif" align="absMiddle" width="10" height="15"><lt:Label res="res.label.cms.doc" key="type"/></td>
      <td class="thead" noWrap width="20%"><img src="images/tl.gif" align="absMiddle" width="10" height="15"><lt:Label res="res.label.cms.doc" key="mgr"/></td>
    </tr>
    <%
while (ri.hasNext()) {
 	rr = (ResultRecord)ri.next(); 
	boolean isHome = rr.getBoolean("isHome");
	%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">      <%=rr.getInt("id")%></td>
      <td style="PADDING-LEFT: 10px">&nbsp;<img src="images/arrow.gif" align="absmiddle">&nbsp;<a href="../fckwebedit.jsp?op=edit&id=<%=rr.getInt("id")%>&dir_code=<%=StrUtil.UrlEncode((String)rr.get(1))%>&dir_name=<%=StrUtil.UrlEncode(dir_name)%>"><%=(String)rr.get(2)%></a></td>
      <td><%=rr.getString("class1")%></td>
      <td><a href="../fckwebedit.jsp?op=edit&id=<%=rr.getInt("id")%>&dir_code=<%=StrUtil.UrlEncode((String)rr.get(1))%>&dir_name=<%=StrUtil.UrlEncode(dir_name)%>">[ <lt:Label res="res.label.cms.doc" key="edit"/> 
      ]</a> <a onClick="return confirm('<lt:Label res="res.label.cms.doc" key="msg"/>')" href="document_list_m.jsp?op=del&id=<%=rr.getString(3)%>&dir_code=<%=dir_code%>&dir_name=<%=StrUtil.UrlEncode(dir_name)%>">[ <lt:Label res="res.label.cms.doc" key="del"/> ]</a> <a href="doc_template_show.jsp?id=<%=rr.getInt("id")%>">[ <lt:Label res="res.label.cms.doc" key="view"/> ]</a> <a href="javascript:selTemplate(<%=rr.getInt("id")%>)">[ <lt:Label res="res.label.cms.doc" key="choose"/> ]</a> </td>
    </tr>
    <%}%>
  </tbody>
</table>
<table width="96%"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="right">&nbsp;</td>
  </tr>
  <tr>
    <td align="right"><%
	String querystr = "op="+op+"&what="+StrUtil.UrlEncode(what, "utf-8");
    out.print(paginator.getCurPageBlock("document_list_m.jsp?"+querystr));
%></td>
  </tr>
</table>
<HR noShade SIZE=1>
<%if (!dir_code.equals("") && leaf.getType()==2) {%>
<DIV style="WIDTH: 95%" align=right>
  <INPUT 
onclick="javascript:location.href='<%=cn.js.fan.web.Global.getRootPath()%>/fckwebedit.jsp?op=add&dir_code=<%=StrUtil.UrlEncode(dir_code)%>&dir_name=<%=StrUtil.UrlEncode(dir_name, "utf-8")%>';"type="button" value="<%=SkinUtil.LoadString(request,"op_add")%>">
</DIV>
<%}%>
</body>
<script language="javascript">
<!--
function form1_onsubmit()
{
	errmsg = "";
	if (form1.pwd.value!=form1.pwd_confirm.value)
		errmsg += "<lt:Label res="res.label.cms.doc" key="msg_mima"/>"
	if (errmsg!="")
	{
		alert(errmsg);
		return false;
	}
}
//-->
</script>
</html>