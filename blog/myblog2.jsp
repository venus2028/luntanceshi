<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.forum.SQLBuilder"%>
<%@ page import="com.redmoon.forum.MsgUtil"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
String blogUserName = ParamUtil.get(request, "blogUserName");
long blogId = UserConfigDb.NO_BLOG;
UserConfigDb ucd = new UserConfigDb();
if (!blogUserName.equals("")) {
	ucd = ucd.getUserConfigDbByUserName(blogUserName);
	if (ucd!=null)
		blogId = ucd.getId();
}
else {
	blogId = ParamUtil.getLong(request, "blogId", UserConfigDb.NO_BLOG);
	ucd = ucd.getUserConfigDb(blogId);
}
if (ucd==null || !ucd.isLoaded()) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "res.label.blog.myblog", "myblog_alert")));
	return;
}
else {
	ucd.setViewCount(ucd.getViewCount() + 1);
	ucd.save();
}

request.setAttribute("blogId", new Long(blogId));

String blogUserDir = ParamUtil.get(request, "blogUserDir");
UserDirDb udd = new UserDirDb();
udd = udd.getUserDirDb(blogId, blogUserDir);
String skinPath = "skin/" + ucd.getSkin();
request.setAttribute("skinPath", skinPath);
%>
<html>
<head>
<title><%=ucd.getTitle()%> - <%=ucd.getPenName()%> - <%=Global.AppName%></title>
<LINK href="<%=ucd.getCSS(request)%>" type=text/css rel=stylesheet>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script tyle="text/javascript" language="javascript" src="../spwhitepad/createShapes.js"></script>
</head>
<body>
<%@ include file="header.jsp"%>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class=blog_table_main>
  <tr>
    <td width="220" valign="top"><%@ include file="left.jsp"%></td>
    <td valign="top" width=1></td>
    <td align="left" valign="top" class="blog_td_main"><%		
		String strcurpage = StrUtil.getNullString(request.getParameter("CPages"));
		if (strcurpage.equals(""))
			strcurpage = "1";
		if (!StrUtil.isNumeric(strcurpage)) {
			out.print(StrUtil.makeErrMsg(SkinUtil.LoadString(request, "err_id")));
			return;
		}
		
		String sql = SQLBuilder.getMyblogSql(blogUserDir, blogId);
		
		MsgDb msgdb = new MsgDb();
	    int total = msgdb.getThreadsCount(sql, msgdb.getVirtualBoardcodeOfBlog(blogId, blogUserDir));

		int pagesize = 20;
		int curpage = Integer.parseInt(strcurpage);
		
		Paginator paginator = new Paginator(request, total, pagesize);
		//设置当前页数和总页数
		int totalpages = paginator.getTotalPages();
		if (totalpages==0)
		{
			curpage = 1;
			totalpages = 1;
		}
		
		long start = (curpage-1)*pagesize;
		long end = curpage*pagesize;
		
        ThreadBlockIterator irmsg = msgdb.getThreads(sql, msgdb.getVirtualBoardcodeOfBlog(blogId, blogUserDir), start, end);
%>
      <TABLE borderColor=#edeced cellSpacing=0 cellPadding=0 width="100%" align=center border=0 class="blog_table_list_header">
        <TBODY>
          <TR height=25>
            <TD height="26" align=right noWrap>&nbsp;&nbsp;<a href="../forum/rss.jsp?op=blog&blogId=<%=blogId%>&blogUserDir=<%=blogUserDir%>"><img src="../images/rss.gif" border="0" align="absmiddle"></a>&nbsp;</TD>
          </TR>
        </TBODY>
      </TABLE>
      <%		
String id="",topic = "",name="",lydate="",rename="",redate="";
int level=0,iselite=0,islocked=0,expression=0;
int i = 0,recount=0,hit=0,type=0;
ForumDb forum = new ForumDb();
while (irmsg.hasNext()) {
	 	  msgdb = (MsgDb) irmsg.next(); 
		  i++;
		  id = ""+msgdb.getId();
		  topic = msgdb.getTitle();
		  name = msgdb.getName();
		  lydate = com.redmoon.forum.ForumSkin.formatDateTime(request, msgdb.getAddDate());
		  recount = msgdb.getRecount();
		  hit = msgdb.getHit();
		  expression = msgdb.getExpression();
		  type = msgdb.getType();
		  iselite = msgdb.getIsElite();
		  islocked = msgdb.getIsLocked();
		  level = msgdb.getLevel();
		  rename = msgdb.getRename();
		  redate = DateUtil.format(msgdb.getRedate(), "yy-MM-dd HH:mm");
	  %>
<table width="100%" cellspacing="0" style="TABLE-LAYOUT: fixed; WORD-BREAK: break-all">
  <tr>
    <td width="79%" align="left" class="showblog_td_author">&nbsp;<img src='<%=skinPath%>/images/article.gif' align="absmiddle">&nbsp;<a href="showblog.jsp?rootid=<%=msgdb.getId()%>"><%=DefaultRender.RenderFullTitle(request, msgdb)%></a></td>
    <td width="21%" align="right" class="showblog_td_author"><%=lydate%></td>
  </tr>
  <tr>
    <td colspan="2">
      <table cellSpacing="0" cellPadding="0" align="center" border="0">
        <tbody>
          <tr>
            <td></td>
          </tr>
        </tbody>
      </table>
      <table width="100%" border="0" align="center" cellPadding="0" cellSpacing="0">
        <tbody>
          <tr>
            <td>
              <div>
                <%=StrUtil.ubbWithoutAutoLink(request, MsgUtil.getAbstract(request, msgdb, 2000))%><br>
                <br>
                <a style="FONT-STYLE: italic" href="showblog.jsp?rootid=<%=msgdb.getId()%>"><lt:Label res="res.label.blog.myblog" key="click_view"/></a>              </div>            </td>
          </tr>
        </tbody>
      </table>
      <table cellSpacing="0" cellPadding="0" align="center" border="0">
        <tbody>
          <tr>
            <td></td>
          </tr>
        </tbody>
      </table>
      <table cellSpacing="0" cellPadding="0" align="right" border="0">
        <tbody>
          <tr>
            <td><a href="showblog.jsp?rootid=<%=msgdb.getId()%>#comment" target="_blank">
              <lt:Label res="res.label.blog.myblog" key="comment"/>
            </a><a href="showblog.jsp?rootid=<%=msgdb.getId()%>#comment" target="_blank">(<%=msgdb.getRecount()%>)</a>┆ 
              
              <a href="showblog.jsp?rootid=<%=msgdb.getId()%>" target="_blank"><lt:Label res="res.label.blog.myblog" key="view"/>(<font class="blog_font_hit"><%=hit%></font>)</a></td></tr>
        </tbody>
      </table>    </td>
  </tr>
</table>   
    <%}%>
    <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
      <tr>
        <td height="23" align="right"><%=paginator.getPageStatics(request)%>&nbsp;&nbsp;
          <%
				String querystr = "";
				out.print(paginator.getPageBlock(request,"myblog.jsp?blogId=" + blogId + querystr));
				%>
          &nbsp;&nbsp;</td></tr>
    </table></td>
  </tr>
</table>
<%@ include file="footer.jsp"%>
</body>
</html>