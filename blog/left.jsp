<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.blog.link.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.MsgDb"%>
<%@ page import="com.redmoon.forum.ThreadBlockIterator "%>
<%@ page import="com.redmoon.forum.ForumDb "%>
<%@ page import="com.redmoon.forum.* "%>
<%@ page import="com.redmoon.forum.plugin.DefaultRender "%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String leftSkinPath = (String)request.getAttribute("skinPath");
// 取得显示的年月 
int leftyear,leftmonth;
try {
	leftyear = ParamUtil.getInt(request, "year");
	leftmonth = ParamUtil.getInt(request, "month");
}
catch (Exception e) {
    Calendar cal = Calendar.getInstance();
    leftyear = cal.get(cal.YEAR);
    leftmonth = cal.get(cal.MONTH) + 1;
}
if (leftmonth>12)
	leftmonth = 12;
if (leftmonth<1)
	leftmonth = 1;
	
long leftBlogId = ((Long)request.getAttribute("blogId")).longValue();

UserConfigDb leftUcd = new UserConfigDb();
leftUcd = leftUcd.getUserConfigDb(leftBlogId);
UserDb leftUser = new UserDb();
leftUser = leftUser.getUser(leftUcd.getUserName());
%>
<style type="text/css">
<!--
.STYLE2 {color: #FFFFFF}
-->
</style>
<table width="100%" border="0" class="blog_left_table">
  <tr>
    <td align="center">
	<table width="100%" border="0">
      <tr>
        <td height="5"></td>
      </tr>
    </table>
	<%if (leftUcd.getType()==UserConfigDb.TYPE_PERSON) {%>
	  <a class="blog_link_username" href="../userinfo.jsp?username=<%=StrUtil.UrlEncode(leftUcd.getUserName())%>"><%=leftUcd.getPenName()%></a>	<font color="#FF0000">
      <br />
      <br />
      <%
	  if (leftUcd.getIcon().equals("")) {
		String myface = leftUser.getMyface();
		String RealPic = leftUser.getRealPic();  
		if (myface.equals("")) {%>
			<img src="../forum/images/face/<%=RealPic%>"/>
		<%}else{%>
			<img src="<%=leftUser.getMyfaceUrl(request)%>" name="tus" id="tus" />
		<%}
	  }else{%>
	  	<img src="<%=leftUcd.getIconUrl(request)%>" />
	  <%}%>
	  </font>
	  <BR />
	  <div style="padding-top:5px"><a href="user/myfriend.jsp?op=add&friend=<%=StrUtil.UrlEncode(leftUser.getName())%>&privurl=<%=StrUtil.getUrl(request)%>">
      <lt:Label res="res.label.forum.showtopic" key="add_friend"/></a></div>
	<%}else{
	%>
     <lt:Label res="res.label.blog.user.userconfig" key="type_group"/>(<a href="<%=request.getContextPath()%>/blog/blog_group_apply.jsp?blog_id=<%=leftUcd.getId()%>">加入</a>)<br />
     <span class="titleBar">
     <lt:Label res="res.label.blog.left" key="creator"/>
     </span>：<a href="<%=request.getContextPath()%>/userinfo.jsp?username=<%=StrUtil.UrlEncode(leftUser.getName())%>"><%=leftUser.getNick()%></a>
	<%}%>
	</td>
  </tr>
  <tr>
    <td align="center" height="10"></td>
  </tr>
  <tr>
    <td align="center">
			<div id=div_cal></div>		
			  <script>
			  var blogId = "<%=leftBlogId%>";
			  </script>	  
			  <script src="inc/calendar.js">
			  </script>
			  <script>
			  newCalendar("div_cal", <%=leftyear%>, <%=leftmonth%>);
			  </script>
			  <%
			  // 取得year-month这个月中的所有日志，遍历后对日历初始化
			  UserBlog bu = new UserBlog(leftBlogId);
			  int[] dayCountAry = bu.getBlogDayCount(leftyear, leftmonth);
			  int dayLen = dayCountAry.length;
			  %>
			  <script>
			  <%
			  Calendar cal = Calendar.getInstance();
			  // int dayOfMonth = cal.get(cal.DAY_OF_MONTH);			  
			  for (int n=1; n<dayLen; n++) {
			  		if (dayCountAry[n]>0) {
						String totle_log = cn.js.fan.web.SkinUtil.LoadString(request,"res.label.blog.left", "totle_log");
						totle_log = StrUtil.format(totle_log, new Object[] {"" + dayCountAry[n]});
			  %>
						// alert(day<%=n%>.innerHTML);
						day<%=n%>.innerHTML = "<table width=100% cellSpacing=0 cellPadding=1 class=table_day><tr><td align=center><a href='listdayblog.jsp?blogId=<%=leftBlogId%>&y=<%=leftyear%>&m=<%=leftmonth%>&d=<%=n%>' title='<%=totle_log%>'>" + <%=n%> +"</a></td></tr></table>";
			  <%	}
			  }%>
			  </script>	</td>
  </tr>
  <tr>
    <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
        
        <tr>
          <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td class="blog_td_spacer_up"></td>
            </tr>
            <tr>
              <td class="blog_td_title"><li class="titleBar">&nbsp;&nbsp;&nbsp;<lt:Label res="res.label.blog.left" key="my_column"/></li></td>
            </tr>
            <tr>
              <td class="blog_td_spacer_down"></td>
            </tr>
          </table>
            <table width="100%"  border="0" align="center" cellpadding="3" cellspacing="0">
              <tr align="center">
                <td>&nbsp;</td>
                <td height="22" align="left"><a href="<%=request.getContextPath()%>/blog/myblog.jsp?blogId=<%=leftBlogId%>"><lt:Label res="res.label.blog.left" key="all_article"/></a></td>
              </tr>
              <tr align="center">
                <td>&nbsp;</td>
                <td height="22" align="left"><a href="<%=request.getContextPath()%>/blog/myblog.jsp?blogUserDir=<%=UserDirDb.DEFAULT%>&blogId=<%=leftBlogId%>"><%=UserDirDb.getDefaultName()%></a></td>
              </tr>            
            <%
UserDirDb sb1 = new UserDirDb();
Vector leftv = sb1.list(leftBlogId);
Iterator leftir = leftv.iterator();
while (leftir.hasNext()) {
	UserDirDb as = (UserDirDb)leftir.next();
%>
              <tr align="center">
                <td width="14%">&nbsp;</td>
                <td width="86%" height="22" align="left"><a href="<%=request.getContextPath()%>/blog/myblog.jsp?blogId=<%=leftBlogId%>&blogUserDir=<%=StrUtil.UrlEncode(as.getCode())%>"><%=StrUtil.toHtml(as.getDirName())%></a></td>
              </tr>
            <%}%>
          </table></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td class="blog_td_spacer_up"></td>
        </tr>
        <tr>
          <td class="blog_td_title"><li class="titleBar">&nbsp;&nbsp;&nbsp;<lt:Label res="res.label.blog.left" key="new_article"/></li> </td>
        </tr>
        <tr>
          <td class="blog_td_spacer_down"></td>
        </tr>
      </table>
	  <%
		MsgDb leftMsgDb = new MsgDb();
		String leftsql = SQLBuilder.getNewMsgOfBlog(leftBlogId);	
        ThreadBlockIterator leftirmsg = leftMsgDb.getThreads(leftsql, leftMsgDb.getVirtualBoardcodeOfBlog(leftBlogId, ""), 0, 10);
		while (leftirmsg.hasNext()) {
			leftMsgDb = (MsgDb) leftirmsg.next();%>
	<table width="100%" border="0">
      <tr>
        <td width="14%">&nbsp;</td>
        <td><a href="showblog.jsp?rootid=<%=leftMsgDb.getId()%>" title="<%=leftMsgDb.getTitle()%>"><%=DefaultRender.RenderTitle(request, leftMsgDb, 26)%></a></td>
      </tr>
    </table>
	<%}
	%>	</td>
  </tr>
  <tr>
    <td>
<%if (leftUcd.isFootprint()) {%>	
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td class="blog_td_spacer_up"></td>
      </tr>
      <tr>
        <td class="blog_td_title"><li class="titleBar">&nbsp;&nbsp;
              <lt:Label res="res.label.blog.left" key="lastVisit"/>
        </li></td>
      </tr>
      <tr>
        <td class="blog_td_spacer_down"></td>
      </tr>
    </table>
      <table width="100%" border="0">
        <tr>
          <td width="14%">&nbsp;</td>
          <td>
	<%
	UserMgr umLeft = new UserMgr();
	com.redmoon.blog.Config bleftcfg = com.redmoon.blog.Config.getInstance();
	FootprintDb leftfd = new FootprintDb();
	leftsql = "select msg_id,user_name from " + leftfd.getTable().getName() + " where blog_id=" + leftUcd.getId() + " order by add_date desc";
	cn.js.fan.db.ListResult leftlr = leftfd.listResult(leftsql, 1, bleftcfg.getIntProperty("lastVisitDisplayCount"));
	leftir = leftlr.getResult().iterator();
	int m=0;
	while (leftir.hasNext()) {
	  	leftfd = (FootprintDb)leftir.next();
		String uName = leftfd.getString("user_name");
		UserDb ud = umLeft.getUser(leftfd.getString("user_name"));
	%>
		<%if (ud.getGender().equals("M")) {%>
			<img src="../blog/<%=leftSkinPath%>/images/man.gif">
		<%}else{%>
			<img src="../blog/<%=leftSkinPath%>/images/woman.gif">
		<%}%>  
			<a href="../userinfo.jsp?username=<%=StrUtil.UrlEncode(ud.getName())%>"><%=ud.getNick()%></a>&nbsp;&nbsp;		  
      <%
	  	m++;
	  	if (m==3) {
			out.print("<BR>");
			m = 0;
		}
	}
	%>
		  </td>
        </tr>
      </table>
<%}%>	  
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td class="blog_td_spacer_up"></td>
        </tr>
        <tr>
          <td class="blog_td_title"><li class="titleBar">&nbsp;&nbsp;&nbsp;<lt:Label res="res.label.blog.left" key="new_comment"/></li> </td>
        </tr>
        <tr>
          <td class="blog_td_spacer_down"></td>
        </tr>
      </table>
	<%
	leftsql = SQLBuilder.getNewReplySqlOfBlog(leftBlogId);  // "select id from sq_message where isBlog=1 and replyRootName=" + StrUtil.sqlstr(userName) + " order by lydate desc";
	cn.js.fan.db.ListResult leftlr = leftMsgDb.list(leftsql, 1, 10);
	UserMgr leftum = new UserMgr();
	DefaultRender leftRender = new DefaultRender();
	if (leftlr!=null) {
		leftv = leftlr.getResult();
		leftir = leftv.iterator();
		while (leftir.hasNext()) {
			leftMsgDb = (MsgDb)leftir.next();
			if (leftMsgDb.getMsgDb(leftMsgDb.getRootid()).getCheckStatus()==MsgDb.CHECK_STATUS_PASS) {
			%>
			<table width="100%" border="0">
              <tr>
                <td width="14%">&nbsp;</td>
                <td>[
				<%if (leftMsgDb.getName().equals("")) {
					out.print(cn.js.fan.web.SkinUtil.LoadString(request, "res.label.forum.showtopic", "anonym"));
				} else {%>
				<a href="../userinfo.jsp?username=<%=leftMsgDb.getName()%>"><%=leftum.getUser(leftMsgDb.getName()).getNick()%></a>
				<%}%>]
				&nbsp;&nbsp;&nbsp;<a href="showblog.jsp?rootid=<%=leftMsgDb.getRootid()%>&amp;op=allcomm#<%=leftMsgDb.getId()%>"><%=DefaultRender.RenderFullTitle(request, leftMsgDb)%></a>
				</td>
              </tr>
            </table>
		<% }
		}
	}
	%>	<table width="100%" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td class="blog_td_spacer_up"></td>
          </tr>
          <tr>
            <td class="blog_td_title"><li class="titleBar">&nbsp;&nbsp;&nbsp;<lt:Label res="res.label.blog.left" key="blog_statistics"/></li></td>
          </tr>
          <tr>
            <td class="blog_td_spacer_down"></td>
          </tr>
          <tr>
            <td><table width="100%" border="0">
              <tr>
                <td width="14%">&nbsp;</td>
                <td><lt:Label res="res.label.blog.left" key="article"/><%=leftUcd.getMsgCount()%></td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td><lt:Label res="res.label.blog.left" key="comment"/><%=leftUcd.getReplyCount()%></td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td><lt:Label res="res.label.blog.left" key="visit"/><%=leftUcd.getViewCount()%></td>
              </tr>
            </table></td>
          </tr>
        </table></td>
  </tr>
  <tr>
    <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td class="blog_td_spacer_up"></td>
        </tr>
        <tr>
          <td class="blog_td_title"><li class="titleBar">&nbsp;&nbsp;&nbsp;<lt:Label res="res.label.blog.left" key="link"/></li> </td>
        </tr>
        <tr>
          <td class="blog_td_spacer_down"></td>
        </tr>
      </table>
	
	  <%
				LinkDb leftld = new LinkDb();
				String listsql = "select id from " + leftld.getTableName() + " where blog_id=" + leftBlogId + " order by sort";
				Iterator leftirlink = leftld.list(listsql).iterator();
				while (leftirlink.hasNext())
				{
					leftld = (LinkDb) leftirlink.next();
				%>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="p9">
        <tr>
          <td width="14%" height="20">&nbsp;</td>
          <td>&nbsp;<span class="dirItem">
		  <a target="_blank" href="<%=leftld.getUrl()%>" title="<%=StrUtil.toHtml(leftld.getTitle())%>">
					<%if (leftld.getImage()!=null && !leftld.getImage().equals("")) {%>
						<img src="<%=leftld.getImageUrl(request)%>" border=0>
					<%}else{%>
						<%=StrUtil.toHtml(leftld.getTitle())%>
					<%}%>
		  </a>
		  </span></td>
        </tr>
      </table>
    <%}%></td>
  </tr>
</table>
