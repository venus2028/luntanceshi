<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.redmoon.forum.setup.*"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
String siteCode = ParamUtil.get(request, "siteCode");
%>
<TABLE class="searchTab" width="80%" align="center" cellPadding=2 cellSpacing=1 bgcolor="#ECEEF2" id=AutoNumber1 style="PADDING-RIGHT: 0px; margin-top: 10px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; BORDER-LEFT: 1px; PADDING-TOP: 0px; BORDER-BOTTOM: 1px; BORDER-COLLAPSE: collapse; BORDER-RIGHT-WIDTH: 1px">
  <FORM name=form1 action="site_search.jsp" method=get>
      <thead>
	  <TR>
        <TD height=26 colSpan=2 bgcolor="#ECEEF2"><P align=center><SPAN class="text_title"><strong>全文搜索</strong></SPAN> </P></TD>
      </TR>
      </thead>
    <TBODY>
      <TR>
        <TD height=23 align="right" bgcolor="#FFFFFF"><lt:Label res="res.label.forum.search" key="search_content"/>
          &nbsp;&nbsp;</TD>
        <TD width="78%" height=23 align="left" vAlign=top bgcolor="#FFFFFF">&nbsp;
        <input size=40 name="queryString">
        <input name="siteCode" value="<%=siteCode%>" type="hidden">
        <input name="op" value="search" type="hidden">		</TD>
      </TR>
      <TR>
        <TD width=22% height=24 bgcolor="#FFFFFF"><P align=right><FONT style="FONT-SIZE: 9pt">
          <lt:Label res="res.label.forum.search" key="search_keywords"/>
        </FONT>&nbsp;&nbsp; </P></TD>
        <TD height=24 align="left" vAlign=top bgcolor="#FFFFFF">&nbsp;
            <SELECT size=1 name="fieldName">
              <OPTION value="content" selected>内容</OPTION>
              <OPTION value="title">标题</OPTION>
          </SELECT></TD>
      </TR>
      <TR>
        <TD height=26 colspan="2" align=center bgcolor="#FFFFFF"><input type=submit value=<lt:Label res="res.label.forum.search" key="begin_search"/> name=submit1></TD>
      </TR>
    </TBODY>
  </FORM>
</TABLE>
