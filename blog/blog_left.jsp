<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.blog.UserBlog"%>
<%@ page import="com.redmoon.blog.UserDirDb"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.person.UserDb"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<script src="../inc/common.js"></script>
<jsp:useBean id="leftprivilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
String leftprivurl = StrUtil.getUrl(request);
UserConfigDb leftucd = new UserConfigDb();
%>
<table width="100%" border="0" class="blog_left_table">
  <tr>
    <td align="center" valign="top">
      <table width="240" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td height="10"></td>
        </tr>
        <tr>
          <td height="25" background="images/button-bg-01.gif" class="line4t" ><div style="PADDING-left:18px;padding-top:3px; "><img src="images/subj.gif" width="16" height="15" align="absmiddle" /> &nbsp;<lt:Label res="res.label.blog.frame" key="user_login"/></div></td>
        </tr>
        <tr>
          <td height="10"></td>
        </tr>
        <%if (!leftprivilege.isUserLogin(request)) {%>
        <tr>
          <td height="13" bgcolor="#FFFFFF" class="line4t" style="padding-top:6px; padding-left:15px; padding-right:15px;"><table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
              <form action="../login.jsp" method="post" name="form1" id="form1">
                <tr>
                  <td><lt:Label res="res.label.blog.frame" key="name"/></td>
                  <td><input name="name" id="name" size="14" />                  </td>
                </tr>
                <tr>
                  <td><lt:Label res="res.label.blog.frame" key="pwd"/></td>
                  <td><input name="pwd" type="password" id="pwd" size="14" />
                      <input type="hidden" name="privurl" value="<%=leftprivurl%>" /></td>
                </tr>
                <tr>
                  <td><lt:Label res="res.label.blog.frame" key="test_code"/></td>
                  <td><input name="validateCode" type="text" id="validateCode" size="4" style="width:50" />
                      <a href="#" onClick="$('imgValidateCode').src='../validatecode.jsp?' + 'xxx=' + new Date().getTime();"><img id="imgValidateCode" src="../validatecode.jsp" width="58" height="20" align="absmiddle" border=0/></a></td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td height="28"><input type="button" name="register" value="<lt:Label res="res.label.blog.frame" key="register"/>" onclick="window.location.href='../regist.jsp'"/>
				      &nbsp;&nbsp;
                      <input name="login" type="submit" value="<lt:Label res="res.label.blog.frame" key="login"/>"/>
                  &nbsp;</td>
                </tr>
              </form>
          </table></td>
        </tr>
        <%}else{%>
        <tr>
          <td height="13" bgcolor="#FFFFFF" class="line4t" style="padding-top:6px; padding-left:15px; padding-right:15px;"><%
			String userName = leftprivilege.getUser(request);
			UserDb me = new UserDb();
			me = me.getUser(userName);
			String myface = me.getMyface();
		  %>
          <jsp:useBean id="Msg" scope="page" class="com.redmoon.forum.message.MessageMgr"/>
          <%
			int msgcount = 0;
			msgcount = Msg.getNewMsgCount(request);
			String welcome_you = SkinUtil.LoadString(request,"res.label.blog.frame", "welcome_you");
			welcome_you = StrUtil.format(welcome_you, new Object[] {Global.AppName});
		  %>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td height="22"><%=welcome_you%></td>
                </tr>
                <tr>
                  <td height="22"><lt:Label res="res.label.blog.frame" key="user"/><%=me.getNick()%></td>
                </tr>
                <tr>
                  <td height="22"><lt:Label res="res.label.blog.frame" key="before_login"/><%=DateUtil.format(me.getLastTime(), "yyyy-MM-dd")%></td>
                </tr>
                <tr>
                  <td height="22"><a href="../usercenter.jsp"><lt:Label res="res.label.blog.frame" key="user_center"/></a>
				  <%
				  UserConfigDb leftMyBlog = leftucd.getUserConfigDbByUserName(userName);
				  if (leftMyBlog!=null) {
				  %>
				  <a href="myblog.jsp?blogId=<%=leftMyBlog.getId()%>">
				  <lt:Label res="res.label.blog.frame" key="my_blog"/></a>
				  <%}%>
				  </td>
                </tr>
                <tr>
                  <td height="22"><a href="../message/message.jsp"><lt:Label res="res.label.blog.frame" key="message"/></a>(<font class="redfont"><%=msgcount%></font>)&nbsp;<a href="../exit.jsp?privurl=<%=leftprivurl%>"><u><lt:Label res="res.label.blog.frame" key="exit_blog"/></u></a></td>
                </tr>
            </table></td>
        </tr>
    </table>
	  <%}%>
	  <table width="240" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td height="10"></td>
        </tr>
        <tr>
          <td height="25" background="images/button-bg-01.gif" class="line4t" ><div style="PADDING-left:18px;padding-top:3px; "><img src="images/subj.gif" width="16" height="15" align="absmiddle" /> &nbsp;<lt:Label res="res.label.blog.frame" key="blog_star"/></div></td>
        </tr>
        <tr>
          <td height="10"></td>
        </tr>
        <tr>
          <td height="186" valign="top" bgcolor="#FFFFFF" class="line4t"><%
	BlogDb bd = new BlogDb();
	bd = bd.getBlogDb();
	String star = StrUtil.getNullString(bd.getStar());
    UserConfigDb starucd = new UserConfigDb();
	starucd = starucd.getUserConfigDbByUserName(star);	
	if (!star.equals("") && starucd!=null) {
	%>
              <table width="80%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td align="center">&nbsp;</td>
                </tr>
                <tr>
                  <td align="center" bgcolor="#F7F7F7"><%

		UserDb user = new UserDb();
		user = user.getUser(star);
		String myface = user.getMyface();
		String RealPic = user.getRealPic();
		String subTitle = "";
	    if (myface.equals("")) {%>
                      <img src="../forum/images/face/<%=RealPic%>"/>
                      <%}else{%>
                      <img src="<%=user.getMyfaceUrl(request)%>" name="tus" id="tus" />
                      <%}%>
                  </td>
                </tr>
                <tr>
                  <td height="5" bgcolor="#F7F7F7"></td>
                </tr>
                <tr>
                  <td bgcolor="#F7F7F7" >&nbsp;<lt:Label res="res.label.blog.frame" key="blog_left"/>
				  <a href="myblog.jsp?blogId=<%=starucd.getId()%>" target="_blank">
				  <%=starucd.getTitle()%>
				  </a>
				  </td>
                </tr>
                <tr>
                  <td bgcolor="#F7F7F7">&nbsp;<lt:Label res="res.label.blog.frame" key="introduction"/><%=starucd.getSubtitle()%></td>
                </tr>
                <tr>
                  <td bgcolor="#F7F7F7">&nbsp;<lt:Label res="res.label.blog.frame" key="article"/><%=starucd.getMsgCount()%></td>
                </tr>
                <tr>
                  <td bgcolor="#F7F7F7">&nbsp;<lt:Label res="res.label.blog.frame" key="comment"/><%=starucd.getReplyCount()%></td>
                </tr>
                <tr>
                  <td bgcolor="#F7F7F7">&nbsp;<lt:Label res="res.label.blog.frame" key="visit"/><%=starucd.getViewCount()%></td>
                </tr>
              </table>
            <%
	}
	%>
          </td>
        </tr>
        <tr>
          <td height="8"></td>
        </tr>
      </table>
      <table width="240" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td height="10"></td>
        </tr>
        <tr>
          <td height="25" background="images/button-bg-01.gif" class="line4t" ><div style="PADDING-left:18px;padding-top:3px; "><img src="images/subj.gif" width="16" height="15" align="absmiddle" /> &nbsp;<lt:Label res="res.label.blog.frame" key="new_add"/></div></td>
        </tr>
        <tr>
          <td height="10"></td>
        </tr>
        <tr>
          <td height="27" bgcolor="#FFFFFF" class="line4t" style="padding-top:6px; padding-left:15px; padding-right:15px;" valign="top"><div class="test">
              <%
			long[] newBlogs = bd.getNewBlogs(9);
			int newBlogsLen = newBlogs.length;
			for (int i=0; i<newBlogsLen; i++) {
				leftucd = leftucd.getUserConfigDb(newBlogs[i]);
			%>
              <li><a href="myblog.jsp?blogId=<%=leftucd.getId()%>" title="<%=leftucd.getTitle()%>(<%=leftucd.getUserName()%>)"><%=StrUtil.getLeft(leftucd.getTitle(), 20)%></a></li>
            <%}%>
          </div></td>
        </tr>
        <tr>
          <td height="10"></td>
        </tr>
      </table>
      <table width="240" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td height="10"></td>
        </tr>
        <tr>
          <td height="25" background="images/button-bg-01.gif" class="line4t" ><div style="PADDING-left:18px;padding-top:3px; "><img src="images/subj.gif" width="16" height="15" align="absmiddle" /> &nbsp;<lt:Label res="res.label.blog.frame" key="web_statistics"/></div></td>
        </tr>
        <tr>
          <td height="10"></td>
        </tr>
        <tr>
          <td height="170" bgcolor="#FFFFFF" class="line4t"><table width="80%"  border="0" align="center" cellpadding="0" cellspacing="0">
              <tr>
                <td height="25"><img src="images/tu_newgroup.gif" width="15" height="12" align="absmiddle" />&nbsp;<lt:Label res="res.label.blog.frame" key="blog_left"/><%=bd.getBlogCount()%> </td>
              </tr>
              <tr>
                <td height="25"><img src="images/tu_newgroup.gif" width="15" height="12" align="absmiddle" />&nbsp;<lt:Label res="res.label.blog.frame" key="log_left"/><%=bd.getTopicCount()%> </td>
              </tr>
              <tr>
                <td height="25"><img src="images/tu_newgroup.gif" width="15" height="12" align="absmiddle" />&nbsp;<lt:Label res="res.label.blog.frame" key="web_statistics_comment"/><%=bd.getPostCount()-bd.getTopicCount()%> </td>
              </tr>
<%
			long newBlogId = bd.getNewBlogId();
			UserConfigMgr ucm = new UserConfigMgr();
			UserConfigDb newUcd = ucm.getUserConfigDb(newBlogId);
			String newBlogTitle = "";
			if (newUcd.isLoaded())
				newBlogTitle = newUcd.getTitle();
%>
              <tr>
                <td height="25"><img src="images/tu_newgroup.gif" width="15" height="12" align="absmiddle" />&nbsp;<lt:Label res="res.label.blog.frame" key="add"/><a href="myblog.jsp?blogId=<%=newBlogId%>"><%=newBlogTitle%></a> </td>
              </tr>
              <tr>
                <td height="25"><img src="images/tu_newgroup.gif" width="15" height="12" align="absmiddle" />&nbsp;<lt:Label res="res.label.blog.frame" key="yesterday"/><%=bd.getYestodayCount()%> </td>
              </tr>
              <tr>
                <td height="25"><img src="images/tu_newgroup.gif" width="15" height="12" align="absmiddle" />&nbsp;<lt:Label res="res.label.blog.frame" key="today"/><%=bd.getTodayCount()%></td>
              </tr>
          </table></td>
        </tr>
        <tr>
          <td height="10"></td>
        </tr>
      </table></td>
  </tr>
</table>
