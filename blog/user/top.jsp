<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE>title</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8"><LINK 
href="../admin/default.css" type=text/css rel=stylesheet>
<META content="MSHTML 6.00.3790.259" name=GENERATOR>
<style type="text/css">
<!--
.style1 {color: #FFFFFF}
.style2 {font-family: "宋体"}
-->
</style>
</HEAD>
<BODY leftMargin=0 topMargin=0>
<TABLE cellSpacing=0 cellPadding=0 width="100%" 
background="../../forum/admin/images/top_bg.png" border=0>
  <TBODY>
  <TR>
    <TD width="20%"><IMG height=49 src="../../forum/admin/images/us_logo.gif" 
    width=182></TD>
    <TD width="80%" style="PADDING-RIGHT: 20px">
      <TABLE width="100%" align=right class=wht>
        <TBODY>
        <TR>
          <TD width="66%" rowspan="2" align="center">
			<%
			long blogId = ParamUtil.getLong(request, "blogId");
			// if (userName.equals("")) {
			// 	out.print(StrUtil.Alert(SkinUtil.LoadString(request,"res.label.blog.user.frame", "not_name")));
			//	return;
			//}
			UserConfigDb ucd = new UserConfigDb();
			ucd = ucd.getUserConfigDb(blogId);
			String str = SkinUtil.LoadString(request,"res.label.blog.user.frame", "column");
			str = StrUtil.format(str, new Object[] {ucd.getPenName()});
			%>
			<font color=white style="font-size:20px"><%=str%></a>
		  </TD>
          <TD width="34%" align="right"><span class="style1"><span class="style2">&nbsp;</span>&nbsp;&nbsp;&nbsp;</span><IMG height=7 hspace=5 
            src="../../forum/admin/images/arrow_white.gif" width=6 
            algin="absmiddle"><A href="javascript:location.reload();" 
            target=mainFrame><lt:Label res="res.label.blog.user.frame" key="reflash_page"/></A><IMG height=7 hspace=5 
            src="../../forum/admin/images/arrow_white.gif" width=6 
            algin="absmiddle"><A 
            href="../../index.jsp" 
            target=_blank><lt:Label res="res.label.blog.user.frame" key="browse_web"/></A> <IMG height=7 hspace=5 
            src="../../forum/admin/images/arrow_white.gif" width=6 
            algin="absmiddle"><A 
            href="javascript:window.close()" 
            target=_top><lt:Label res="res.label.blog.user.frame" key="exit_system"/></A> </TD>
        </TR>
        <TR>
          <TD align=right class=wht>
<jsp:useBean id="cfg" scope="page" class="cn.js.fan.web.Config"/>
<font color=white><%=cfg.getProperty("Application.name")%><lt:Label res="res.label.blog.user.frame" key="blog_manage_system"/></font>
		  </TD>
      </TR></TBODY></TABLE></TD></TR></TBODY></TABLE></BODY></HTML>
