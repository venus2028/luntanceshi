<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="cn.js.fan.web.*" %>
<%@ page import="java.util.*" %>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ page import="cn.js.fan.util.*" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
User user = new User();
user = user.getUser(privilege.getUser(request));
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE>title</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8"><LINK 
href="images/default.css" type=text/css rel=stylesheet>
<style type="text/css">
<!--
.style1 {color: #FFFFFF}
.style2 {font-family: "宋体"}
-->
</style>
</HEAD>
<BODY leftMargin=0 topMargin=0>
<TABLE cellSpacing=0 cellPadding=0 width="100%" 
background="images/top_bg.png" border=0>
  <TBODY>
  <TR>
    <TD><IMG height=49 src="images/us_logo.gif" 
    width=182></TD>
    <TD style="PADDING-RIGHT: 20px">
      <TABLE width="100%" align=right class=wht>
        <TBODY>
        <TR>
          <TD align="right"><span class="style1"><span class="style2"><%=user.getRealName()%>，最后登录：<%=DateUtil.format(user.getEnterLast(), "yy-MM-dd HH:mm")%>
            <jsp:useBean id="cfg" scope="page" class="cn.js.fan.web.Config"/>
                &nbsp;</span>&nbsp;&nbsp;&nbsp;</span><IMG height=7 hspace=5 
            src="images/arrow_white.gif" width=6 
            algin="absmiddle"><A href="javascript:location.reload();" 
            target=mainFrame>
              <lt:Label res="res.label.blog.admin.top" key="current_page"/></A> <IMG height=7 hspace=5 
            src="images/arrow_white.gif" width=6 
            algin="absmiddle"><A 
            href="main.jsp" 
            target=mainFrame><lt:Label res="res.label.blog.admin.top" key="control_panel_page"/></A> <IMG height=7 hspace=5 
            src="images/arrow_white.gif" width=6 
            algin="absmiddle"><A 
            href="../index.jsp" 
            target=_blank><lt:Label res="res.label.blog.admin.top" key="browse_web"/></A> <IMG height=7 hspace=5 
            src="images/arrow_white.gif" width=6 
            algin="absmiddle"><A 
            href="<%=request.getContextPath()%>/cms/logout.jsp" 
            target=_top><lt:Label res="res.label.blog.admin.top" key="quit_system"/></A> </TD>
        </TR>
        </TBODY></TABLE></TD></TR></TBODY></TABLE></BODY></HTML>
