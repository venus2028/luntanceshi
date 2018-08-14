<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="com.cloudwebsoft.framework.base.*" %>
<%@ page import="cn.js.fan.module.cms.robot.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Robot List</title>
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
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, cn.js.fan.module.pvg.PrivDb.PRIV_ADMIN)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td width="56%" class="head">采集机器人</td>
      <td width="44%" class="head"><TABLE width="312" border=0 align=right cellPadding=0 cellSpacing=0 summary="">
        <TBODY>
          <TR>
            <TD><A class=view 
            href="robot_list.jsp">浏览机器人</A></TD>
            <TD><A class=add 
            href="robot_add.jsp">添加新机器人</A></TD>
            <TD><A class=other 
            href="robot_import.jsp">导入机器人</A></TD>
          </TR>
        </TBODY>
      </TABLE></td>
    </tr>
  </tbody>
</table>
<%
RobotDb rd = new RobotDb();

String op = ParamUtil.get(request, "op");
if (op.equals("del")) {
	int id = ParamUtil.getInt(request, "id");
	rd = (RobotDb)rd.getQObjectDb(new Integer(id));
	boolean re = rd.del();
	if (re)
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "robot_list.jsp"));
	else
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));	
}

if (op.equals("copy")) {
	int id = ParamUtil.getInt(request, "id");
	rd = (RobotDb)rd.getQObjectDb(new Integer(id));
	boolean re = rd.copy();
	if (re)
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "robot_list.jsp"));
	else
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));	
}

String sql = rd.getTable().getQueryList();

int total = (int)rd.getQObjectCount(sql);

int pagesize = total; 	// 20;

int curpage,totalpages;
Paginator paginator = new Paginator(request, total, pagesize);
// 设置当前页数和总页数
totalpages = paginator.getTotalPages();
curpage	= paginator.getCurrentPage();
if (totalpages==0) {
	curpage = 1;
	totalpages = 1;
}	

QObjectBlockIterator oir = rd.getQObjects(sql, (curpage-1)*pagesize, curpage*pagesize);
%>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="1" cellPadding="3" width="95%" align="center">
  <tbody>
    <tr>
      <td class="thead" noWrap width="44%">名称</td>
      <td class="thead" noWrap width="13%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">采集个数</td>
      <td class="thead" noWrap width="13%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">页面编码</td>
      <td width="30%" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">操作</td>
    </tr>
<%
while (oir.hasNext()) {
 	rd = (RobotDb)oir.next();
	%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td><%=rd.getString("name")%></td>
      <td><%=rd.getInt("gather_count")%></td>
      <td><%=rd.getString("charset")%> </td>
      <td>
	  [<a href="robot_edit.jsp?robotId=<%=rd.getInt("id")%>"><lt:Label res="res.label.cms.dir" key="modify"/></a>]&nbsp;[<a href="#" onClick="if (confirm('您确定要删除吗？')) window.location.href='robot_list.jsp?op=del&id=<%=rd.getInt("id")%>'"><lt:Label res="res.label.cms.dir" key="del"/></a>]&nbsp;[<a href="robot_do.jsp?op=gather&robotId=<%=rd.getInt("id")%>">采集</a>]&nbsp;[<a href="robot_list.jsp?op=copy&id=<%=rd.getInt("id")%>">复制</a>]&nbsp;[<a href="robot_export.jsp?op=export&id=<%=rd.getInt("id")%>">导出</a>]</td>
    </tr>
<%}%>
  </tbody>
</table>
</body>
</html>