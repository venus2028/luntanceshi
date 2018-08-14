<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ page import="com.cloudwebsoft.framework.web.*" %>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>子站点管理</title>
<link href="../common.css" rel="stylesheet" type="text/css">
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}

.noborder
{
    BORDER-BOTTOM: 0px solid;
    BORDER-LEFT: 0px solid;
    BORDER-RIGHT: 0px solid;
    BORDER-TOP: 0px solid;
    FONT-SIZE: 9pt
}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, "admin")) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
String orderBy = ParamUtil.get(request, "orderBy");
String sort = ParamUtil.get(request, "sort");
if (orderBy.equals(""))
	orderBy = "create_date";
if (sort.equals(""))
	sort = "desc";

String op = ParamUtil.get(request, "op");
if (op.equals("pass")) {
	String codes = ParamUtil.get(request, "codes");
	String[] ary = StrUtil.split(codes, ",");
	if (ary==null) {
		out.print(StrUtil.Alert_Back("请选择站点！"));
		return;
	}
	SiteDb sd = new SiteDb();
	for (int i=0; i<ary.length; i++) {
		sd = sd.getSiteDb(ary[i]);
		sd.set("site_status", new Integer(1));
		sd.save();
	}
	out.print(StrUtil.Alert_Redirect("操作成功！", "site_list.jsp?orderBy=" + orderBy + "&sort=" + sort));
	return;
}
else if (op.equals("del")) {
	String codes = ParamUtil.get(request, "codes");
	String[] ary = StrUtil.split(codes, ",");
	if (ary==null) {
		out.print(StrUtil.Alert_Back("请选择站点！"));
		return;
	}
	Directory dir = new Directory();
	for (int i=0; i<ary.length; i++) {
		dir.del(ary[i]);
	}
	out.print(StrUtil.Alert_Redirect("操作成功！", "site_list.jsp?orderBy=" + orderBy + "&sort=" + sort));
	return;
}

String sql = "select code from cms_site ";

String what = "";
if (op.equals("search")) {
	what = ParamUtil.get(request, "what");
	sql += " where name like "+StrUtil.sqlstr("%"+what+"%");
}

sql += " order by " + orderBy + " " + sort;
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">子站点管理</td>
    </tr>
  </tbody>
</table>
<br>
<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" class="p9">
  <form name="form1" action="site_list.jsp?op=search" method="post">
    <tr>
      <td align="center"><input name=what size=20 value="<%=what%>">
        &nbsp;
        <input name="Submit" type="submit" value=<%=SkinUtil.LoadString(request, "res.label.cms.doc","search")%>>
	  </td>
    </tr>
  </form>
</table>
<%
String strcurpage = StrUtil.getNullString(request.getParameter("CPages"));
if (strcurpage.equals(""))
	strcurpage = "1";
if (!StrUtil.isNumeric(strcurpage)) {
	out.print(StrUtil.makeErrMsg(StrUtil.Alert_Back(SkinUtil.LoadString(request, "err_id"))));
	return;
}
int pagesize = 20;
int curpage = Integer.parseInt(strcurpage);

SiteDb sd = new SiteDb();
ListResult lr = sd.listResult(sql, curpage, pagesize);

Paginator paginator = new Paginator(request, lr.getTotal(), pagesize);
//设置当前页数和总页数
int totalpages = paginator.getTotalPages();
if (totalpages==0) {
	curpage = 1;
	totalpages = 1;
}
%>
<table width="92%" border="0" align="center" class="p9">
  <tr>
    <td height="24" align="right"><lt:Label res="res.label.cms.doc" key="found_right_list"/><b><%=paginator.getTotal() %></b><lt:Label res="res.label.cms.doc" key="page_list"/><b><%=paginator.getPageSize() %></b><lt:Label res="res.label.cms.doc" key="page"/><b><%=paginator.getCurrentPage() %>/<%=paginator.getTotalPages() %></b></td>
  </tr>
</table>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellspacing="1" cellpadding="3" width="98%" align="center">
  <tbody>
    <tr>
      <td width="4%" align="center" nowrap class="thead" style="PADDING-LEFT: 10px">编号</td>
      <td width="30%" align="center" nowrap class="thead" style="PADDING-LEFT: 10px;cursor:hand" onClick="doSort('name')">名称
        <%if (orderBy.equals("name")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%>
      </td>
      <td width="11%" align="center" nowrap class="thead" style="PADDING-LEFT: 10px;cursor:hand" onClick="doSort('site_status')">开放状态
        <%if (orderBy.equals("site_status")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%>
      </td>
      <td width="16%" align="center" nowrap class="thead" style="PADDING-LEFT: 10px;cursor:hand" onClick="doSort('kind')">类别
        <%if (orderBy.equals("kind")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%>
      </td>
      <td width="8%" align="center" nowrap class="thead">创建者</td>
      <td width="14%" align="center" nowrap class="thead" style="cursor:hand" onClick="doSort('create_date')">创建日期
        <%if (orderBy.equals("create_date")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
			}%></td>
      <td width="17%" align="center" nowrap class="thead">操作</td>
    </tr>
    <%
int k = 100;
com.redmoon.forum.person.UserMgr um = new com.redmoon.forum.person.UserMgr();
Iterator ir = lr.getResult().iterator();
Directory dir = new Directory();
while (ir.hasNext()) {
 	sd = (SiteDb)ir.next();
	String owner = StrUtil.getNullStr(sd.getString("owner"));
	String nick = "";
	String userName = "";
	if (!owner.equals("")) {
		com.redmoon.forum.person.UserDb user = um.getUser(sd.getString("owner"));
		nick = user.getNick();
		userName = user.getName();
	}
	Leaf lf = dir.getLeaf(sd.getString("kind"));
	String dirName = "";
	if (lf!=null)
		dirName = lf.getName();
	k++;
	%>
  <form name="form<%=k%>" action="site_list.jsp" method="post">
    <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1" style="padding-left:5px">
      <td><input name="codes" type="checkbox" value="<%=sd.getString("code")%>"></td>
      <td style="PADDING-LEFT: 10px"><%if (Global.isSubDomainSupported) {%>
          <a href="http://<%=sd.getString("code")%>.<%=DomainDispatcher.getBaseDomain(request)%>" target="_blank"><%=sd.getString("name")%></a>
          <%}else{%>
          <a href="../site.jsp?siteCode=<%=sd.getString("code")%>" target="_blank"><%=sd.getString("name")%></a>
          <%}%>
      </td>
      <td style="PADDING-LEFT: 10px"><select name="site_status">
        <option value="1">是</option>
        <option value="0">否</option>
        <%if (privilege.isUserPrivValid(request, "admin")) {%>
        <option value="<%=SiteDb.STATUS_FORBID%>">强制关闭</option>
        <option value="<%=SiteDb.STATUS_NOT_CHECKED%>">未审核</option>
        <%}%>
      </select>
          <script>
		form<%=k%>.site_status.value = "<%=sd.getInt("site_status")%>";
		</script>
      </td>
      <td style="PADDING-LEFT: 10px"><%=dirName%></td>
      <td style="PADDING-LEFT: 10px"><a href="../userinfo.jsp?username=<%=StrUtil.UrlEncode(userName)%>" target="_blank" ><%=nick%></a></td>
      <td align="center"><%=DateUtil.format(sd.getDate("create_date"), "yy-MM-dd HH:mm")%> </td>
      <td align="center"><a href="site/frame.jsp?siteCode=<%=sd.getString("code")%>" target="_blank">管理站点</a> &nbsp;<a href="site/site.jsp?siteCode=<%=sd.getString("code")%>" target="_blank">站点属性</a> </td>
    </tr>
  </form>
  <%}%>
</table>
<table width="96%"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="2" align="right">&nbsp;</td>
  </tr>
  <tr>
    <td width="42%" align="left"><input name="button3" type="button" onClick="selAllCheckBox('codes')" value="<lt:Label res="res.label.forum.topic_m" key="sel_all"/>">
      &nbsp;&nbsp;<input name="button3" type="button" onClick="clearAllCheckBox('codes')" value="<lt:Label res="res.label.forum.topic_m" key="clear_all"/>">
      &nbsp;&nbsp;<input name="button32" type="button" onClick="doPass()" value="通过">
      &nbsp;&nbsp;<input name="button32" type="button" onClick="doDel()" value="删除">
    </td>
    <td width="58%" align="right"><%
	String querystr = "op=" + op + "&what=" + StrUtil.UrlEncode(what) + "&orderBy=" + orderBy + "&sort=" + sort;
    out.print(paginator.getCurPageBlock("site_list.jsp?"+querystr));
%></td>
  </tr>
</table>
</body>
<script src="../inc/common.js"></script>
<script>
function doPass() {
	var codes = getCheckboxValue("codes");
	if (codes=="") {
		alert("请选择文件！");
		return;
	}
	window.location.href = "site_list.jsp?op=pass&codes=" + codes;
}

function doDel() {
	if (!confirm("您确定要删除么？"))
		return;
	var codes = getCheckboxValue("codes");
	if (codes=="") {
		alert("请选择文件！");
		return;
	}
	window.location.href = "site_list.jsp?op=del&codes=" + codes;
}

function selAllCheckBox(checkboxname) {
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

function SubmitWithFileThread() {
	loadDataToWebeditCtrl(formWebedit, formWebedit.webedit);
	formWebedit.webedit.Upload();
	// 因为Upload()中启用了线程的，所以函数在执行后，会立即反回，使得下句中得不到ReturnMessage的值
	// 原因是此时服务器的返回信息还没收到
	// alert("ReturnMessage=" + addform.webedit.ReturnMessage);
}

function SubmitWithFile(){
	loadDataToWebeditCtrl(formWebedit, formWebedit.webedit);
	formWebedit.webedit.UploadArticle();
	if (formWebedit.webedit.ReturnMessage.indexOf("成功")!=-1) {
		alert("上传成功！");
		window.location.reload();
	}
	else
		doAfter(formWebedit.webedit.ReturnMessage);
}

var curOrderBy = "<%=orderBy%>";
var sort = "<%=sort%>";	
function doSort(orderBy) {
	if (orderBy==curOrderBy)
		if (sort=="asc")
			sort = "desc";
		else
			sort = "asc";
	window.location.href = "site_list.jsp?op=<%=op%>&orderBy=" + orderBy + "&sort=" + sort;
}	
</script>
</html>