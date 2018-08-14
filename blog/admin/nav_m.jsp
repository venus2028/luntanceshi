<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ page import="cn.js.fan.module.nav.*" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.cms.nav_m" key="nav_mgr"/></title>
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}
body {
	margin-left: 0px;
	margin-top: 0px;
}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="navmgr" scope="page" class="cn.js.fan.module.nav.NavigationMgr"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<%
String op = StrUtil.getNullString(request.getParameter("op"));
if (op.equals("add")) {
	try {
		if (navmgr.add(request))
			out.print(StrUtil.Alert(SkinUtil.LoadString(request,"info_op_success")));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
}
if (op.equals("edit")) {
	try {
		if (navmgr.update(request))
			out.print(StrUtil.Alert(SkinUtil.LoadString(request,"info_op_success")));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
}
if (op.equals("move")) {
	try {
		if (navmgr.move(request))
			out.print(StrUtil.Alert(SkinUtil.LoadString(request,"info_op_success")));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
}
if (op.equals("del")) {
	if (navmgr.del(request))
			out.print(StrUtil.Alert(SkinUtil.LoadString(request,"info_op_success")));
	else
			out.print(StrUtil.Alert(SkinUtil.LoadString(request,"info_op_fail")));
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head"><lt:Label res="res.label.cms.nav_m" key="nav_mgr"/>
      &nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
  </tbody>
</table>
<%
String sql = "select name,link,color,target,nav_type,code from cws_cms_nav where nav_type=" + StrUtil.sqlstr(Navigation.TYPE_BLOG) + " order by orders";
JdbcTemplate jt = new JdbcTemplate();
ResultIterator ri = jt.executeQuery(sql);
ResultRecord rr = null;
String name;
String link,color,target,code;
int type;
%>
<br>
<table width="490" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="77" align="center"><a href="nav_m.jsp">导航条</a> </td>
    <td width="77" align="center"><a href="home.jsp#hot">博客聚焦</a></td>
    <td width="101" align="center"><a href="home.jsp#flash">Flash图片设置</a></td>
    <td width="81" align="center"><a href="ad.jsp">广告</a></td>
  </tr>
</table>
<br>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="95%" align="center">
  <tbody>
    <tr>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="24%"><lt:Label res="res.label.cms.nav_m" key="name"/></td>
      <td class="thead" noWrap width="19%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
      <lt:Label res="res.label.cms.nav_m" key="link"/></td>
      <td class="thead" noWrap width="14%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
        <lt:Label res="res.label.cms.nav_m" key="color"/></td>
      <td class="thead" noWrap width="14%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
        <lt:Label res="res.label.cms.nav_m" key="target"/></td>
      <td width="29%" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
        <lt:Label res="res.label.cms.nav_m" key="oper"/></td></tr>
<%
int i=100;
while (ri.hasNext()) {
	i++;
 	rr = (ResultRecord)ri.next();
	name = rr.getString(1);
	link = rr.getString(2);
	color = StrUtil.getNullString(rr.getString(3));
	target = StrUtil.getNullString(rr.getString(4));
	type = rr.getInt(5);
	code = rr.getString(6);
	%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
	<form name="form<%=i%>" action="?op=edit" method="post">
      <td style="PADDING-LEFT: 10px">&nbsp;<img src="images/arrow.gif" align="absmiddle">&nbsp;<input name=newname value="<%=name%>"></td>
      <td><input name=link value="<%=link%>" size="30"><input name="name" value="<%=name%>" type="hidden">
        <input name="type" value="<%=type%>" type="hidden">
        <input name="code" value="<%=code%>" type="hidden">		
		</td>
      <td><span class="stable">
      <select name="color" >
        <option value="" style="COLOR: black" selected><lt:Label res="res.label.cms.nav_m" key="color_no"/></option>
        <option style="BACKGROUND: #000088" value="#000088"></option>
        <option style="BACKGROUND: #0000ff" value="#0000ff"></option>
        <option style="BACKGROUND: #008800" value="#008800"></option>
        <option style="BACKGROUND: #008888" value="#008888"></option>
        <option style="BACKGROUND: #0088ff" value="#0088ff"></option>
        <option style="BACKGROUND: #00a010" value="#00a010"></option>
        <option style="BACKGROUND: #1100ff" value="#1100ff"></option>
        <option style="BACKGROUND: #111111" value="#111111"></option>
        <option style="BACKGROUND: #333333" value="#333333"></option>
        <option style="BACKGROUND: #50b000" value="#50b000"></option>
        <option style="BACKGROUND: #880000" value="#880000"></option>
        <option style="BACKGROUND: #8800ff" value="#8800ff"></option>
        <option style="BACKGROUND: #888800" value="#888800"></option>
        <option style="BACKGROUND: #888888" value="#888888"></option>
        <option style="BACKGROUND: #8888ff" value="#8888ff"></option>
        <option style="BACKGROUND: #aa00cc" value="#aa00cc"></option>
        <option style="BACKGROUND: #aaaa00" value="#aaaa00"></option>
        <option style="BACKGROUND: #ccaa00" value="#ccaa00"></option>
        <option style="BACKGROUND: #ff0000" value="#ff0000"></option>
        <option style="BACKGROUND: #ff0088" value="#ff0088"></option>
        <option style="BACKGROUND: #ff00ff" value="#ff00ff"></option>
        <option style="BACKGROUND: #ff8800" value="#ff8800"></option>
        <option style="BACKGROUND: #ff0005" value="#ff0005"></option>
        <option style="BACKGROUND: #ff88ff" value="#ff88ff"></option>
        <option style="BACKGROUND: #ee0005" value="#ee0005"></option>
        <option style="BACKGROUND: #ee01ff" value="#ee01ff"></option>
        <option style="BACKGROUND: #3388aa" value="#3388aa"></option>
        <option style="BACKGROUND: #000000" value="#000000"></option>
      </select>
	  <script>
	  form<%=i%>.color.value = "<%=color%>";
	  </script>
</span></td>
      <td><select name="target">
          <option value="_self"><lt:Label res="res.label.cms.nav_m" key="default"/></option>
          <option value="_blank"><lt:Label res="res.label.cms.nav_m" key="new_window"/></option>
          <option value="_parent"><lt:Label res="res.label.cms.nav_m" key="parent_window"/></option>
          <option value="_top"><lt:Label res="res.label.cms.nav_m" key="top_window"/></option>
        </select>
          <script>
	  form<%=i%>.target.value = "<%=target%>";
	    </script>
      </td>
      <td>
	  [ <a href="javascript:form<%=i%>.submit()"><%=SkinUtil.LoadString(request,"op_edit")%></a> ] [ <a onClick="if (!confirm('<lt:Label res="res.label.cms.nav_m" key="confirm_del"/>')) return false" href="nav_m.jsp?op=del&code=<%=StrUtil.UrlEncode(code)%>&type=<%=Navigation.TYPE_BLOG%>"><%=SkinUtil.LoadString(request,"op_del")%></a> ] [<a href="nav_m.jsp?op=move&direction=up&code=<%=StrUtil.UrlEncode(code)%>&type=<%=Navigation.TYPE_BLOG%>"><lt:Label res="res.label.cms.nav_m" key="move_up"/></a>] [<a href="nav_m.jsp?op=move&direction=down&code=<%=StrUtil.UrlEncode(code)%>&type=<%=Navigation.TYPE_BLOG%>"><lt:Label res="res.label.cms.nav_m" key="move_down"/></a>] </td>
	  </form>
    </tr>
<%}%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
	<form name="addform1" action="?op=add" method="post">
      <td style="PADDING-LEFT: 10px">
	  &nbsp;<img src="images/arrow.gif" align="absmiddle">
	  <input name=name value=""></td>
      <td><input name=link value="" size="30">
        <input name="type" value="<%=Navigation.TYPE_BLOG%>" type="hidden"></td>
      <td><span class="stable">
        <SELECT name="color">
          <option value="" STYLE="COLOR: black" selected><lt:Label res="res.label.cms.nav_m" key="color_no"/></option>
          <option style="BACKGROUND: #000088" value="#000088"></option>
          <option style="BACKGROUND: #0000ff" value="#0000ff"></option>
          <option style="BACKGROUND: #008800" value="#008800"></option>
          <option style="BACKGROUND: #008888" value="#008888"></option>
          <option style="BACKGROUND: #0088ff" value="#0088ff"></option>
          <option style="BACKGROUND: #00a010" value="#00a010"></option>
          <option style="BACKGROUND: #1100ff" value="#1100ff"></option>
          <option style="BACKGROUND: #111111" value="#111111"></option>
          <option style="BACKGROUND: #333333" value="#333333"></option>
          <option style="BACKGROUND: #50b000" value="#50b000"></option>
          <option style="BACKGROUND: #880000" value="#880000"></option>
          <option style="BACKGROUND: #8800ff" value="#8800ff"></option>
          <option style="BACKGROUND: #888800" value="#888800"></option>
          <option style="BACKGROUND: #888888" value="#888888"></option>
          <option style="BACKGROUND: #8888ff" value="#8888ff"></option>
          <option style="BACKGROUND: #aa00cc" value="#aa00cc"></option>
          <option style="BACKGROUND: #aaaa00" value="#aaaa00"></option>
          <option style="BACKGROUND: #ccaa00" value="#ccaa00"></option>
          <option style="BACKGROUND: #ff0000" value="#ff0000"></option>
          <option style="BACKGROUND: #ff0088" value="#ff0088"></option>
          <option style="BACKGROUND: #ff00ff" value="#ff00ff"></option>
          <option style="BACKGROUND: #ff8800" value="#ff8800"></option>
          <option style="BACKGROUND: #ff0005" value="#ff0005"></option>
          <option style="BACKGROUND: #ff88ff" value="#ff88ff"></option>
          <option style="BACKGROUND: #ee0005" value="#ee0005"></option>
          <option style="BACKGROUND: #ee01ff" value="#ee01ff"></option>
          <option style="BACKGROUND: #3388aa" value="#3388aa"></option>
          <option style="BACKGROUND: #000000" value="#000000"></option>
        </SELECT>
      </span></td>
      <td><select name="target">
          <option value="_self" selected><lt:Label res="res.label.cms.nav_m" key="default"/></option>
          <option value="_blank"><lt:Label res="res.label.cms.nav_m" key="new_window"/></option>
          <option value="_parent"><lt:Label res="res.label.cms.nav_m" key="parent_window"/></option>
          <option value="_top"><lt:Label res="res.label.cms.nav_m" key="top_window"/></option>
      </select></td>
      <td><INPUT 
onclick="return addform1.submit()" type="button" value="<%=SkinUtil.LoadString(request,"op_add")%>"> </td>
	</form>
    </tr>
  </tbody>
</table>
</body>
</html>