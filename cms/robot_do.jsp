<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.cloudwebsoft.framework.base.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.cms.robot.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HEAD><TITLE>Robot do</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<link href="default.css" rel="stylesheet" type="text/css">
<script>
function addDocUrl(url) {
	divDocUrls.innerHTML += "<BR>" + url;
}
</script>
</HEAD>
<BODY>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, cn.js.fan.module.pvg.PrivDb.PRIV_ADMIN)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

// 注意request传值为来时，不能用id，否则会与模板中从request中取id造成混淆
int id = ParamUtil.getInt(request, "robotId");

RobotDb rd = new RobotDb();
rd = (RobotDb)rd.getQObjectDb(new Integer(id));

// 清空session中存储的采集信息
session.removeAttribute(RobotInfo.SESSION_VAR_GATHER_INFO);
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td width="64%" class="head">采集机器人</td>
      <td width="36%" class="head"><TABLE width="312" border=0 align=right cellPadding=0 cellSpacing=0 summary="">
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
<TABLE id=pagehead cellSpacing=0 cellPadding=0 width="100%" summary="" border=0><TBODY>
  <TR>
    <TD width="16%">&nbsp;</TD>
    <TD width="84%" class=actions>&nbsp;</TD>
  </TR></TBODY></TABLE>
  <br>
  <TABLE width="98%" align="center" cellPadding=3 cellSpacing=1 class=maintable style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">
  <TBODY>
  <TR>
    <TD align="left" class="thead"><%=rd.getString("name")%>&nbsp;采集</TD>
    </TR>
  <TR>
    <TD bgcolor="#FFFFFF">
	  采集：<%=rd.getString("list_url_link")%>
	  &nbsp;&nbsp;
	  <input name="button" type="button" onClick="spanFrame.innerHTML=''" value="停止采集">
	  &nbsp;
	  <input name="button2" type="button" onClick="window.location.href='robot_edit.jsp?robotId=<%=id%>'" value="修改">
	  <br>
	<br>
	文章：<BR>
	<%
	/*
	// 一次采集全部
	Roboter rt = new Roboter();
	try {
		rt.gatherList(request, rd);
		Vector v = rt.getResult();
		Iterator ir = v.iterator();
		while (ir.hasNext()) {
			String url = (String)ir.next();
			out.print("<li>" + url + "</url>");
		}
	}
	catch (ErrMsgException e) {
		out.print(SkinUtil.makeErrMsg(request, e.getMessage()));
	}
	*/
	%>
	<div id="divDocUrls"></div>
	<span id=spanFrame>
	<iframe id="hidFrame" frameborder="0" width="100%" height="0" src="robot_do_refresh.jsp?robotId=<%=id%>"/>    
	</span></TD>
    </TR>
  <TBODY id=type_manual style="DISPLAY: none"></TBODY>
  <TBODY id=type_auto></TBODY>
  <TBODY></TBODY></TABLE>
  <br>
  <br>
</BODY></HTML>
