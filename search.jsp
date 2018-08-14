<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.Date"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>搜索 - <%=Global.AppName%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="template/css.css" type="text/css" rel="stylesheet" />
</head>
<body bgcolor="#FFFFFF" text="#000000">
<div class="content">
<%@ include file="header.jsp"%>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<br>
<TABLE width="760" align="center" cellPadding=2 cellSpacing=1 bgcolor="#ECEEF2" id=AutoNumber1 style="PADDING-RIGHT: 0px; BORDER-TOP: 1px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; BORDER-LEFT: 1px; PADDING-TOP: 0px; BORDER-BOTTOM: 1px; BORDER-COLLAPSE: collapse; BORDER-RIGHT-WIDTH: 1px">
  <FORM name=form1 action=search_full_text_do.jsp method=get>
    <TBODY>
      <TR> 
        <TD height=26 colSpan=2 bgcolor="#ECEEF2"> <P align=center><SPAN class="text_title"><strong>全文搜索</strong></SPAN> </P></TD>
      </TR>
      <TR> 
        <TD height=23 align="right" bgcolor="#FFFFFF"><lt:Label res="res.label.forum.search" key="search_content"/>&nbsp;&nbsp;</TD>
        <TD width="587" height=23 align="left" vAlign=top bgcolor="#FFFFFF">&nbsp; 
        <input size=40 name="queryString"></TD>
      </TR>
      <TR> 
        <TD width=171 height=24 bgcolor="#FFFFFF"> <P align=right><FONT style="FONT-SIZE: 9pt"><lt:Label res="res.label.forum.search" key="search_keywords"/></FONT>&nbsp;&nbsp; </P></TD>
        <TD height=24 align="left" vAlign=top bgcolor="#FFFFFF">&nbsp; 
		  <SELECT size=1 name="fieldName">
		    <OPTION value="content" selected>内容</OPTION>
            <OPTION value="title">标题</OPTION>
        </SELECT></TD>
      </TR>
      <TR> 
        <TD width=171 height=26 align=right bgcolor="#FFFFFF"></TD>
        <TD height=26 align="left" vAlign=center bgcolor="#FFFFFF"><input type=submit value=<lt:Label res="res.label.forum.search" key="begin_search"/> name=submit1></TD>
      </TR></TBODY>
  </FORM>
</TABLE>
</div><br>
<%@ include file="footer.jsp"%>
</body>
</html>