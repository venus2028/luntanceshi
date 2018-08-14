<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.base.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="fchar" scope="page" class="cn.js.fan.util.StrUtil"/>
<html><head>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="expires" content="wed, 26 Feb 1997 08:21:57 GMT">
<title><lt:Label res="res.label.forum.admin.forum_user_sel" key="select_user"/></title>
<link href="default.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
<!--
function setPerson(userName, userNick) {
window.opener.setPerson(userName, userNick);
window.close();
}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
body {
	margin-right: 0px;
	margin-bottom: 0px;
}
.STYLE2 {color: #000000}
-->
</style>
<body bgcolor="#FFFFFF" leftmargin='0' topmargin='0'>
<TABLE style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" 
cellSpacing=0 cellPadding=3 width="100%" align=center>
  <TBODY>
    <TR>
      <TD class=thead style="PADDING-LEFT: 10px" noWrap width="70%"><font size="-1"><b><lt:Label res="res.label.forum.admin.forum_user_sel" key="select_user"/></b></font> </TD>
    </TR>
    <TR>
      <TD height="175" align="center" bgcolor="#FFFFFF" style="PADDING-LEFT: 10px">
        <table width="90%" border="0" align="center">
          <form name="form1" method="post" action="?op=search"><tr>
            <td height="25" align="center"><lt:Label res="res.label.forum.admin.forum_user_sel" key="input_nick"/>：
              <input type="text" name="nick" style="height:18px;width:100px">
              &nbsp;
              <input type="submit" name="Submit" value="<lt:Label res="res.label.forum.admin.forum_user_sel" key="search"/>">
            </td>
            </tr></form>
        </table>
<%
		String sql;
	  	String op = ParamUtil.get(request, "op");
		sql = "select name from sq_user order by regdate asc";
		String nick = ParamUtil.get(request, "nick");
	  	if (op.equals("search")) {
			sql = "select name from sq_user where nick like " + StrUtil.sqlstr("%" + nick + "%") + " order by regdate asc";
		}
	  	
		int pagesize = 10;
		UserDb user = new UserDb();
	    int total = user.getObjectCount(sql);
		int curpage,totalpages;
		Paginator paginator = new Paginator(request, total, pagesize);
	    totalpages = paginator.getTotalPages();
		curpage	= paginator.getCurrentPage();
		if (totalpages==0)
		{
			curpage = 1;
			totalpages = 1;
		}		
%>
        <table width="90%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="right"><span class="title1"><%=paginator.getPageStatics(request)%></span></td>
          </tr>
        </table>
        <table width="98%" border="0" align="center" cellpadding="0" cellspacing="1">
          <tr align="center" bgcolor="#C4DAFF">
            <td width="20%" height="24" bgcolor="#EFEBDE" class="stable STYLE2"><lt:Label res="res.label.forum.admin.forum_user_sel" key="nick"/></td>
            <td width="42%" bgcolor="#EFEBDE" class="stable STYLE2">博客名称</td>
            <td width="20%" bgcolor="#EFEBDE" class="stable STYLE2"><lt:Label res="res.label.forum.admin.forum_user_sel" key="reg_time"/></td>
            <td width="18%" bgcolor="#EFEBDE" class="stable STYLE2"><lt:Label key="op"/></td>
          </tr>
        <%
		int start = (curpage-1)*pagesize;
		int end = curpage*pagesize;
		UserConfigDb ucd = new UserConfigDb();
        ObjectBlockIterator ir = user.getObjects(sql, start, end);		
		int i = 0;
		while (ir.hasNext()) {
			i++;
			user = (UserDb)ir.next();
			UserConfigDb uBlog = ucd.getUserConfigDbByUserName(user.getName());			
		%>
          <tr align="left">
            <td width="20%" height="22" align="center" bgcolor="#EEEDF3" class="stable"><%=user.getNick()%></td>
            <td width="42%" align="center" bgcolor="#EEEDF3" class="stable">
			<%if (uBlog!=null && uBlog.isLoaded()) {%>
			<a href="../myblog.jsp?blogId=<%=uBlog.getId()%>" target=_blank><%=uBlog.getTitle()%></a>
			<%}else{%>
			无
			<%}%>
			</td>
            <td width="20%" align="center" bgcolor="#EEEDF3" class="stable"><%=ForumSkin.formatDateTime(request, user.getRegDate())%></td>
            <td width="18%" align="center" bgcolor="#EEEDF3" class="stable"><a href="#" onClick="setPerson('<%=user.getName()%>', '<%=user.getNick()%>')"><lt:Label res="res.label.forum.admin.forum_user_sel" key="select"/></a></td>
          </tr>
        <%
	}
%>
        </table>
        <br>
        <table width="92%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
          <tr>
            <td height="23" align="right"><%
	String querystr = "op=" + op + "&nick=" + StrUtil.UrlEncode(nick);
    out.print(paginator.getCurPageBlock("blog_user_sel.jsp?"+querystr));
%></td>
          </tr>
        </table>
        <br>
      <p> </TD>
    </TR>
    <!-- Table Body End -->
    <!-- Table Foot -->
    <TR>
      <TD class=tfoot align=right><DIV align=right> </DIV></TD>
    </TR>
    <!-- Table Foot -->
  </TBODY>
</TABLE>
</body>
</html>                            
  