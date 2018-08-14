<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.sms.*"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.plugin.reply.*"%>
<%@ page import="com.redmoon.forum.plugin.score.*"%>
<TABLE width="100%" border=0 align=center cellPadding=2 cellSpacing=1 bgcolor="#CCCCCC">
<TBODY>
    <TR>
  <TD height="23" align="left" bgcolor="#F9FAF3">
  请输入您需要提出的问题
  <%
  if (SMSFactory.isUseSMS() && Privilege.isUserLogin(request)) {
	  UserDb ud = new UserDb();
	  ud = ud.getUser(Privilege.getUser(request));
	  if (ud.isMobileValid()) {
	  %>
	  ，您的手机号为：<%=ud.getMobile()%>，问题在回复后将会短信提醒您！
	  <%}
	  else {
	  %>
	  ，您的手机号还没有通过验证，请进入用户中心-><a href="<%=Global.getRootPath()%>/myinfo.jsp">修改用户资料</a>，手机号在验证后，将可以收到回复提醒，回复提醒是免费的。
	  <%
	  }
  }%>
    <input type="hidden" name="pluginCode" value="<%=ReplyUnit.code%>" />
	</TD>
  </TR>
  </TBODY>
</TABLE>
