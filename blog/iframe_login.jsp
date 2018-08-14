<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.forum.MsgDb"%>
<%@ page import="com.redmoon.forum.person.UserDb"%>
<%@ page import="com.redmoon.forum.Privilege.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<script src="../inc/common.js"></script>
<script src="inc/blog.js"></script>
<link href="template/css.css" type="text/css" rel="stylesheet" />
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%if (!privilege.isUserLogin(request)) {%>
<div class="login">
  <div class="login_top"><a href="regist.jsp" target="_top" style="font-size:12px; color:#FF6002;">申请博客</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
    <form target="_parent" action="login.jsp" method="post" name="formLogin" id="formLogin">
  <div class="login_middle">
    <div class="login_row">用户名:&nbsp;&nbsp;&nbsp;&nbsp;
        <input name="name" size="16" style="width:130px" />
        <input name="privurl" value="index.jsp" type="hidden" />
    </div>
    <div class="login_row">密&nbsp;&nbsp;&nbsp;&nbsp;码:&nbsp;&nbsp;&nbsp;&nbsp;
        <input name="pwd" type="password" size="16" style="width:130px" />
    </div>
    <div class="login_row">验证码:&nbsp;&nbsp;&nbsp;&nbsp;
        <input name="validateCode" size="6" />
    <img id="imgValidateCode" src="../validatecode.jsp" width="58" height="20" align="absmiddle" border="0" style="cursor:hand" onclick="this.src='../validatecode.jsp?' + 'xxx=' + new Date().getTime();"/>    </div>
    <div class="login_row">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <input title="保存登陆一年" name="loginSaveDate" type="checkbox" value="<%=com.redmoon.forum.Privilege.LOGIN_SAVE_YEAR%>" />
      保存登陆&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="../findpwd1.jsp" target="_top" style="color:#0066FF">找回密码</a></div>
  </div>
  <div class="login_line"></div>
  <div class="login_bottom">
    <div class="bottom_login"><input type="image" src="template/images/bottom_login.png" /></div>
    <div class="bottom_register" onclick="window.top.location.href='regist.jsp'"></div>
  </div>
  	</form>
</div>
<%}else{%>
<div class="login">
  <div class="login_top"></div>
  <%
		  String userName = privilege.getUser(request);
		  UserDb me = new UserDb();
		  me = me.getUser(userName);
		  %>
  <jsp:useBean id="Msg" scope="page" class="com.redmoon.forum.message.MessageMgr"/>
  
  <%
		  int msgcount = 0;
		  msgcount = Msg.getNewMsgCount(request);
		  String welcome_you = SkinUtil.LoadString(request,"res.label.blog.frame", "welcome_you");
		  welcome_you = StrUtil.format(welcome_you, new Object[] {Global.AppName});
		  UserConfigDb ucd = new UserConfigDb();
		  long blogId = ucd.getBlogIdByUserName(userName);
		  %>
  <table width="100%" border="0" cellspacing="0" cellpadding="5">
    <tr>
      <td height="22"><%=welcome_you%></td>
    </tr>
    <tr>
      <td height="22"><lt:Label res="res.label.blog.frame" key="user"/>
          <%=me.getNick()%></td>
    </tr>
    <tr>
      <td height="22"><lt:Label res="res.label.blog.frame" key="before_login"/>
          <%=DateUtil.format(me.getLastTime(), "yyyy-MM-dd")%></td>
    </tr>
    <tr>
      <td height="22"><font style="font-family:'宋体'">>></font>
	  	<%if (blogId!=UserConfigDb.NO_BLOG) {%>
		<a target="_parent" href="myblog.jsp?blogId=<%=blogId%>"><lt:Label res="res.label.blog.frame" key="my_blog"/></a>
		(<a target="_parent" href="user/frame.jsp?blogId=<%=blogId%>">管理</a>)
		<%}else{%>
		<a target="_parent" href="active.jsp">
		激活博客
		</a>
		<%}%>
        <%
		cn.js.fan.base.ObjectBlockIterator oi = ucd.getGroupBlogsOwnedByUser(userName);
		while (oi.hasNext()) {
			ucd = (UserConfigDb)oi.next();
			out.print("&nbsp;<a target=_blank href='myblog.jsp?blogId=" + ucd.getId() + "'>" + ucd.getTitle() + "</a>");		
		}
		BlogGroupUserDb bgu = new BlogGroupUserDb();
		Iterator qoi = bgu.getBlogGroupUserAttend(userName);
		UserConfigDb gucd = new UserConfigDb();
		while (qoi.hasNext()) {
			bgu = (BlogGroupUserDb)qoi.next();
			gucd = ucd.getUserConfigDb(bgu.getLong("blog_id"));
			if (gucd.isLoaded()) {
				out.print("&nbsp;<a target=_parent href='myblog.jsp?blogId=" + gucd.getId() + "'>" + gucd.getTitle() + "</a>");
			}
		}%>
		</td>
    </tr>
    <tr>
      <td height="22"><a href="javascript:msgOpenWin('<%=Global.getRootPath()%>/message/message.jsp',320,260)">
		<lt:Label res="res.label.blog.frame" key="message"/></a>
		(<font class="redfont"><%=msgcount%></font>)&nbsp;&nbsp;&nbsp;&nbsp;
		<a target="_parent" href="exit.jsp"><lt:Label res="res.label.blog.frame" key="exit_blog"/></a>
	  </td>
    </tr>
  </table>
</div>
<%}%>