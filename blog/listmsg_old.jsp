<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.forum.MsgDb"%>
<%@ page import="com.redmoon.forum.person.UserMgr"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<html>
<head>
<%
String title = SkinUtil.LoadString(request,"res.label.blog.list", "listmsg_title");
title = StrUtil.format(title, new Object[] {Global.AppName});
%>
<title><%=title%></title>
<LINK href="common.css" type=text/css rel=stylesheet>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style1 {font-size: 14px;
	font-weight: bold;
}
-->
</style>
</head>
<body>
<%@ include file="blog_header.jsp"%>
<table width="892" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td bgcolor="#F7F7F7" class="line4t" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><%		
		String searchType = ParamUtil.get(request, "searchType");
		String keyword = ParamUtil.get(request, "keyword");
		if (!searchType.equals("") || !keyword.equals("")) {
			if (!SQLFilter.isValidSqlParam(keyword)) {
				out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, SkinUtil.ERR_SQL)));
				return;
			}
		}
		
		String sql;
		if (searchType.equals("msgTitle"))
			sql = "select id from sq_message where isBlog=1 and replyid=-1 and title like '%" + keyword + "%' ORDER BY lydate desc";
		else if (searchType.equals("msgContent"))
			sql = "select id from sq_message where isBlog=1 and replyid=-1 and content like '%" + keyword + "%' ORDER BY lydate desc";
		else {
			sql = "select id from sq_thread where isBlog=1 ORDER BY lydate desc";
		}
		
		String strcurpage = StrUtil.getNullString(request.getParameter("CPages"));
		if (strcurpage.equals(""))
			strcurpage = "1";
		if (!StrUtil.isNumeric(strcurpage)) {
			out.print(StrUtil.makeErrMsg(SkinUtil.LoadString(request, "err_id")));
			return;
		}

	    int total = 0;
		int pagesize = 20;
		int curpage = Integer.parseInt(strcurpage);
		
		UserMgr um = new UserMgr();
		MsgDb md = new MsgDb();
		ListResult lr = md.list(sql, curpage, pagesize);
		total = lr.getTotal();
		
		Paginator paginator = new Paginator(request, total, pagesize);
		// 设置当前页数和总页数
		int totalpages = paginator.getTotalPages();
		if (totalpages==0)
		{
			curpage = 1;
			totalpages = 1;
		}
		
        Iterator ir = lr.getResult().iterator();
%>
            <table width="98%" border="0" class="p9">
              <tr>
                <td width="44%" align="left"></td>
                <td width="56%" align="right"><%=paginator.getPageStatics(request)%></td>
              </tr>
            </table>
          <%
		while (ir.hasNext()) {
	 	  md = (MsgDb) ir.next(); 
	  %>
            <table bordercolor=#edeced cellspacing=0 cellpadding=5 width="98%" align=center border=0>
              <tbody>
                <tr>
                  <td width="47%" align=left bgcolor=#f8f8f8><a href="showblog.jsp?rootid=<%=md.getId()%>"><%=md.getTitle()%></a></td>
                  <td width="30%" align=left bgcolor=#f8f8f8><a href="../userinfo.jsp?username=<%=md.getName()%>"><%=um.getUser(md.getName()).getNick()%></a></td>
                  <td width="23%" align=left bgcolor=#f8f8f8><%=DateUtil.format(md.getAddDate(), "yy-MM-dd HH:mm")%></td>
                </tr>
                <tr>
                  <td height=1 colspan="3" align=left background="../images/comm_dot.gif"></td>
                </tr>
              </tbody>
            </table>
          <%}%>
            <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
              <tr>
                <td height="23" align="right"><%
				String querystr = "searchType=" + searchType + "&keyword=" + StrUtil.UrlEncode(keyword);
				out.print(paginator.getPageBlock(request,"?"+querystr));
				%>
                  &nbsp;&nbsp;</td>
              </tr>
          </table></td>
      </tr>
    </table></td>
    <td width="2"></td>
    <td width="260" valign="top" bgcolor="#F7F7F7" class="line4t"><%@ include file="blog_left.jsp"%></td>
  </tr>
  <tr>
    <td height="10"></td>
  </tr>
</table>
<%@ include file="footer.jsp"%>
</body>
</html>