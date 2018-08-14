<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String orderBy = ParamUtil.get(request, "orderBy");
String sort = ParamUtil.get(request, "sort");
if (orderBy.equals(""))
	orderBy = "name";
if (sort.equals(""))
	sort = "asc";
String op = StrUtil.getNullString(request.getParameter("op"));
String searchType = ParamUtil.get(request, "searchType");
if (searchType.equals(""))
	searchType = "name";
String what = ParamUtil.get(request, "what");

String groupCode = ParamUtil.get(request, "group_code").trim();
String groupName = "";
if (!groupCode.equals("")) {
	UserGroup ug = new UserGroup();
	ug = ug.getUserGroup(groupCode);
	groupName = ug.getDesc();
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.cms.user" key="mgr_login"/></title>
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
<script src="../inc/common.js"></script>
<script>
var curOrderBy = "<%=orderBy%>";
var sort = "<%=sort%>";	
function doSort(orderBy) {
	if (orderBy==curOrderBy)
		if (sort=="asc")
			sort = "desc";
		else
			sort = "asc";
	window.location.href = "user_m.jsp?op=<%=op%>&searchType=<%=searchType%>&what=<%=StrUtil.UrlEncode(what)%>&orderBy=" + orderBy + "&sort=" + sort;
}	

function selPerson(userNames) {
	window.location.href = "user_m.jsp?op=addGroupUser&group_code=<%=StrUtil.UrlEncode(groupCode)%>&userNames=" + userNames;
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="usermgr" scope="page" class="cn.js.fan.module.pvg.UserMgr"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, PrivDb.PRIV_ADMIN))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<%
if (op.equals("add")) {
	try {
		if (usermgr.create(request))
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"info_op_success"), "user_m.jsp"));
		else
			out.print(StrUtil.Alert_Back("相同用户名的用户可能已存在！"));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}
else if (op.equals("del")) {
	try {
		if (usermgr.del(request))
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"info_op_success"), "user_m.jsp"));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
	return;
}
else if (op.equals("addGroupUser")) {
	String userNames = ParamUtil.get(request, "userNames");
	String[] ary = StrUtil.split(userNames, ",");
	if (ary==null) {
		out.print(StrUtil.Alert_Back("请选择用户！"));
		return;
	}
	User user = new User();
	for (int i=0; i<ary.length; i++) {
		user = user.getUser(ary[i]);
		user.setGroup(groupCode);
	}
	out.print(StrUtil.Alert_Redirect("操作成功！", "user_m.jsp?group_code=" + StrUtil.UrlEncode(groupCode)));
	return;
}
else if (op.equals("delFromGroup")) {
	String userName = ParamUtil.get(request, "userName");
	User user = new User();
	user = user.getUser(userName);
	user.delFromGroup(groupCode);
	out.print(StrUtil.Alert_Redirect("操作成功！", "user_m.jsp?group_code=" + StrUtil.UrlEncode(groupCode)));
	return;
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">
	  <%if (groupName.equals("")) {%>
	  <lt:Label res="res.label.cms.user" key="mgr_user"/>
	  <%}else{%>
	  &nbsp;<%=groupName%>
	  <%}%>
	  </td>
    </tr>
  </tbody>
</table>
<br>
<%if (groupCode.equals("")) {%>
<form name="formSearch" action="user_m.jsp" method="get">	
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="frame_gray">
  <tr>
    <td height="30" align="center"> 按
	<select name="searchType">
	<option value="name">按用户名</option>
	<option value="realname">按真实姓名</option>
	</select>
	<input name="what" size="10" value="<%=what%>">
	<input name="submit" type="submit" value="搜索">
	<input name="op" value="search" type="hidden">
	<input name="group_code" value="<%=groupCode%>" type="hidden">
	<input name="orderBy" value="<%=orderBy%>" type="hidden">
	<input name="sort" value="<%=sort%>" type="hidden">
	<script>
	formSearch.searchType.value = "<%=searchType%>";
	</script>
	&nbsp;
	<INPUT name="button" type="button" onclick="javascript:location.href='user_op.jsp';" value="<%=SkinUtil.LoadString(request,"op_add")%>">
	</td>
  </tr>
</table>
</form>
<%}%>
<%if (!groupCode.equals("")) {%>
<table width="98%" align="center">
<tr><td align="right">
<input value="选择用户" type="button" onClick="openWin('user_sel.jsp?mode=multi', 640, 420)">
</td>
</tr></table>
<%}%>
<%
String sql = "select name,realname,description,is_foreground_user from users";
if (!groupCode.equals("")) {
	sql = "select u.name,u.realname,u.description,is_foreground_user from users u,user_of_group g where g.group_code=" + StrUtil.sqlstr(groupCode) + " and g.user_name=u.name";
}
if (op.equals("search")) {
	if (groupCode.equals("")) {
		sql = "select name,realname,description,is_foreground_user from users";
		if (searchType.equals("name")) {
			sql += " where name like " + StrUtil.sqlstr("%" + what + "%");
		}
		else if (searchType.equals("realname")) {
			sql += " where realname like " + StrUtil.sqlstr("%" + what + "%");
		}
	}
	else {
		sql = "select u.name,u.realname,u.description,is_foreground_user from users u,user_of_group g where g.group_code=" + StrUtil.sqlstr(groupCode) + " and g.user_name=u.name";
		if (searchType.equals("name")) {
			sql += " and name like " + StrUtil.sqlstr("%" + what + "%");
		}
		else if (searchType.equals("realname")) {
			sql += " and realname like " + StrUtil.sqlstr("%" + what + "%");
		}
	}
}

sql += " order by " + orderBy + " " + sort;
RMConn rmconn = new RMConn(Global.defaultDB);
ResultIterator ri = rmconn.executeQuery(sql);
ResultRecord rr = null;
String name;
String realname;
String desc;
%>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="98%" align="center">
  <tbody>
    <tr>
      <td class="thead" style="PADDING-LEFT: 10px; cursor:hand" noWrap width="18%" onClick="doSort('name')"><lt:Label res="res.label.cms.user" key="user_name"/>
        <%if (orderBy.equals("name")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%>
      </td>
      <td class="thead" style="PADDING-LEFT: 10px; cursor:hand" noWrap width="26%" onClick="doSort('realname')"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
      <lt:Label res="res.label.cms.user" key="real_name"/>&nbsp;<%if (orderBy.equals("realname")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%></td>
      <td class="thead" noWrap width="25%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
      <lt:Label res="res.label.cms.user" key="desc"/></td>
      <td class="thead" noWrap width="15%" style="cursor:hand" onClick="doSort('is_foreground_user')"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
        <lt:Label res="res.label.cms.user" key="is_foreground_user"/>
		<%if (orderBy.equals("is_foreground_user")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%>	  
	  </td>
      <td width="16%" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15"><%=SkinUtil.LoadString(request,"op")%></td>
    </tr>
    <%
while (ri.hasNext()) {
 	rr = (ResultRecord)ri.next();
	name = rr.getString(1);
	realname = rr.getString(2);
	desc = rr.getString(3);
	%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">&nbsp;<img src="images/arrow.gif" align="absmiddle">&nbsp;<a href="user_op.jsp?op=edit&name=<%=StrUtil.UrlEncode(name)%>"><%=name%></a></td>
      <td style="PADDING-LEFT: 10px"><a href="user_op.jsp?op=edit&name=<%=StrUtil.UrlEncode(name)%>"><%=realname%></a></td>
      <td><a href="user_op.jsp?op=edit&name=<%=StrUtil.UrlEncode(name)%>"><%=desc%></a></td>
      <td>
	  <%if (rr.getInt(4)==1) {%>
	  <lt:Label key="yes"/>
	  <%}else{%>
	  <lt:Label key="no"/>
	  <%}%>
	  </td>
      <td>
	  <%if (groupCode.equals("")) {%>
	  [ <a href="user_op.jsp?op=edit&name=<%=StrUtil.UrlEncode(name)%>"><%=SkinUtil.LoadString(request,"op_edit")%></a> ] [ <a onClick="if (!confirm('<lt:Label res="res.label.cms.user" key="del_confirm"/>')) return false" href="user_m.jsp?op=del&name=<%=StrUtil.UrlEncode(name)%>"><%=SkinUtil.LoadString(request,"op_del")%></a> ]
	  <%}else{%>
	  [ <a onclick="return confirm('您确定要删除么？')" href="user_m.jsp?op=delFromGroup&group_code=<%=StrUtil.UrlEncode(groupCode)%>&userName=<%=StrUtil.UrlEncode(name)%>">从用户组删除</a> ]
	  <%}%>
	  </td>
    </tr>
    <%}%>
  </tbody>
</table>
</body>
</html>