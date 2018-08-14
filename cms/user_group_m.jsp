<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String op = StrUtil.getNullString(request.getParameter("op"));
String orderBy = ParamUtil.get(request, "orderBy");
String sort = ParamUtil.get(request, "sort");
if (orderBy.equals(""))
	orderBy = "code";
if (sort.equals(""))
	sort = "asc";
String searchType = ParamUtil.get(request, "searchType");
if (searchType.equals(""))
	searchType = "code";
String what = ParamUtil.get(request, "what");	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.cms.user" key="mgr_user_group"/></title>
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
var curOrderBy = "<%=orderBy%>";
var sort = "<%=sort%>";	
function doSort(orderBy) {
	if (orderBy==curOrderBy)
		if (sort=="asc")
			sort = "desc";
		else
			sort = "asc";
	window.location.href = "user_group_m.jsp?op=<%=op%>&searchType=<%=searchType%>&what=<%=StrUtil.UrlEncode(what)%>&orderBy=" + orderBy + "&sort=" + sort;
}	
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="usergroupmgr" scope="page" class="cn.js.fan.module.pvg.UserGroupMgr"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, PrivDb.PRIV_ADMIN)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

%>
<%
if (op.equals("add")) {
	try {
		if (usergroupmgr.add(request))
			out.print(StrUtil.Alert(SkinUtil.LoadString(request,"info_op_success")));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
}
if (op.equals("del")) {
	if (usergroupmgr.del(request))
			out.print(StrUtil.Alert(SkinUtil.LoadString(request,"info_op_success")));
	else
			out.print(StrUtil.Alert(SkinUtil.LoadString(request,"info_op_fail")));
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head"><lt:Label res="res.label.cms.user" key="mgr_user_group"/></td>
    </tr>
  </tbody>
</table>
<br>
<form name="formSearch" action="user_group_m.jsp" method="get">	
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="frame_gray">
  <tr>
    <td height="30" align="center"> 按
      <select name="searchType">
          <option value="code">按编码</option>
          <option value="desc">按描述</option>
        </select>
        <input name="what" size="10" value="<%=what%>">
        <input name="op" value="search" type="hidden">
        <input name="orderBy" value="<%=orderBy%>" type="hidden">
        <input name="sort" value="<%=sort%>" type="hidden">
        <input name="submit" type="submit" value="搜索">
        <script>
	  formSearch.searchType.value = "<%=searchType%>";
	  </script>
    </td>
  </tr>
</table>
</form>
<%
String code;
String desc;
UserGroup ugroup = new UserGroup();

String sql = "select code from user_group";
if (op.equals("search")) {
	if (searchType.equals("desc")) {
		sql += " where description like " + StrUtil.sqlstr("%" + what + "%");
	}
	else if (searchType.equals("code")) {
		sql += " where code like " + StrUtil.sqlstr("%" + what + "%");
	}
}

sql += " order by " + orderBy + " " + sort;

Vector result = ugroup.list(sql);
Iterator ir = result.iterator();
%>
<br>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="98%" align="center">
  <tbody>
    <tr>
      <td width="16%" class="thead" style="cursor:hand" onClick="doSort('code')"><lt:Label res="res.label.cms.user" key="name"/>
		<%if (orderBy.equals("code")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%>	  </td>
      <td class="thead" noWrap width="20%" style="cursor:hand" onClick="doSort('description')"><img src="images/tl.gif" align="absMiddle" width="10" height="15"><lt:Label res="res.label.cms.user" key="desc"/>
		<%if (orderBy.equals("description")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%>	  </td>
      <td class="thead" noWrap width="13%" style="cursor:hand" onClick="doSort('isSystem')"><lt:Label res="res.label.cms.user" key="sys_reserve"/>
		<%if (orderBy.equals("isSystem")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%>
		</td>
      <td class="thead" noWrap width="15%" style="cursor:hand" onClick="doSort('enter_count')">登录数
		<%if (orderBy.equals("enter_count")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%>	  
	  </td>
      <td class="thead" noWrap width="15%" style="cursor:hand" onClick="doSort('doc_count')">文章数
		<%if (orderBy.equals("doc_count")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%>	
	  </td>
      <td width="21%" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15"><%=SkinUtil.LoadString(request,"op")%></td>
    </tr>
<%
while (ir.hasNext()) {
 	UserGroup ug = (UserGroup)ir.next();
	code = ug.getCode();
	desc = ug.getDesc();
	%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">&nbsp;<img src="images/arrow.gif" align="absmiddle">&nbsp;<a href="user_group_op.jsp?op=edit&code=<%=StrUtil.UrlEncode(code)%>"><%=code%></a></td>
      <td><a href="user_group_op.jsp?op=edit&code=<%=StrUtil.UrlEncode(code)%>"><%=desc%></a></td>
      <td><%=ug.isSystem()?SkinUtil.LoadString(request,"yes"):SkinUtil.LoadString(request,"no")%></td>
      <td><%=ug.getEnterCount()%></td>
      <td><%=ug.getDocCount()%></td>
      <td>
	  <a href="user_group_op.jsp?op=edit&code=<%=StrUtil.UrlEncode(code)%>">[ <%=SkinUtil.LoadString(request,"op_edit")%> ]</a> 
	  [ <a href="user_group_priv.jsp?group_code=<%=StrUtil.UrlEncode(code)%>&desc=<%=StrUtil.UrlEncode(desc)%>"><lt:Label res="res.label.cms.user" key="priv"/></a> ] [ <a href="user_m.jsp?group_code=<%=StrUtil.UrlEncode(code)%>"><lt:Label res="res.label.cms.user" key="user"/></a> ]
	  <%if (!ug.isSystem()) {%>
[ <a onClick="if (!confirm('<lt:Label res="res.label.cms.user" key="group_m_msg"/>')) return false" href="user_group_m.jsp?op=del&code=<%=StrUtil.UrlEncode(code)%>"><%=SkinUtil.LoadString(request,"op_del")%></a> ]
<%}%></td>
    </tr>
<%}%>
  </tbody>
</table>
<HR noShade SIZE=1>
<DIV style="WIDTH: 95%" align=right>
  <INPUT 
onclick="javascript:location.href='user_group_op.jsp';" type="button" value="<%=SkinUtil.LoadString(request,"op_add")%>">
</DIV>
</body>
<script language="javascript">
<!--
function form1_onsubmit()
{
	errmsg = "";
	if (form1.pwd.value!=form1.pwd_confirm.value)
		errmsg += "<lt:Label res="res.label.cms.user" key="mima_check"/>"
	if (errmsg!="")
	{
		alert(errmsg);
		return false;
	}
}
//-->
</script>
</html>