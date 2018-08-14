<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.person.UserDb"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<link href='template/css.css' rel='stylesheet' type='text/css'>
<script src="inc/common.js"></script>
<%if (!com.redmoon.forum.Privilege.isUserLogin(request)) {%>
<div class="login">
  <form target="_parent" action="login.jsp" method="post" name="formLogin" id="formLogin" style="margin:0px; padding:0px;">
    用户名：&nbsp;
    <input class="inputText" id="name" tabindex="2" name="name" type="text" />
    <input name="privurl" type="hidden" value="index.jsp"/>
    <br />
    密&nbsp;&nbsp;码：&nbsp;
    <input id="pwd" tabindex="3" name="pwd" type="password" class="inputText" />
    <br />
    验证码：&nbsp;
    <input class="validateCode" id="validateCode" tabindex="4" size="4" name="validateCode" type="text" />
    <img id="imgValidateCode" src="validatecode.jsp" width="58" height="20" align="absmiddle" border="0" style="cursor:hand" onclick="this.src='validatecode.jsp?' + 'xxx=' + new Date().getTime();"/>
	<div style="padding-top:5px; text-align:center">
      <input tabindex="5" type="image" src="template/images/btn_login.gif" name="B22" value="提交" />
	</div>
  </form>
  <div style="padding-top:5px; font-size:1px; width:200px; margin-bottom:0px; height:1px; border-bottom:1px red solid; text-align:center"></div>
  <div style="text-align:center; margin:0px; padding-top:5px">
  <a target="_parent" class="loginword" href="regist.jsp">注&nbsp;册</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a target="_parent" class="loginword" href="findpwd1.jsp">找回密码</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a target="_parent" class="loginword" href="forum/index.jsp">游&nbsp;客</a></div>
</div>
<%}else{%>
<table class="login">
  <tr>
    <td width="260"><%
		  String userName = com.redmoon.forum.Privilege.getUser(request);
		  UserDb me = new UserDb();
		  me = me.getUser(userName);
		  %>
      <jsp:useBean id="Msg" scope="page" class="com.redmoon.forum.message.MessageMgr"/>
      <%
		  int msgcount = 0;
		  msgcount = Msg.getNewMsgCount(request);
		  String welcome_you = SkinUtil.LoadString(request,"res.label.blog.frame", "welcome_you");
		  welcome_you = StrUtil.format(welcome_you, new Object[] {Global.AppName});
		  User user = new User();
		  user = user.getUser(userName);
		  %>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
          <td height="22"><a href="usercenter.jsp" target="_parent">用户中心</a>
		  	<a href="javascript:openWin('message/message.jsp',320,260)"><lt:Label res="res.label.blog.frame" key="message"/></a>(<font class="redfont"><%=msgcount%></font>)&nbsp;
			<%
			cn.js.fan.module.cms.Config cfgCms = new cn.js.fan.module.cms.Config();
			if (cfgCms.getBooleanProperty("cms.isLoginBackgroundWhenLoginForeground")) {
				cn.js.fan.module.pvg.Privilege backPvg = new cn.js.fan.module.pvg.Privilege();
				if (backPvg.isUserLogin(request)) {
				%>
				<a href="<%=request.getContextPath()%>/cms/frame.jsp" target="_top">后台管理</a>
				<%
				}
			}
			%>
			<a target="_parent" href="exit.jsp?privurl=index.jsp"><lt:Label res="res.label.blog.frame" key="exit_blog"/></a>
			</td>
        </tr>
      </table></td>
  </tr>
</table>
<%}%>
