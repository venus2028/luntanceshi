<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.cloudwebsoft.framework.base.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.plugin.reply.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
// 检查用户是否属于政务问答组
if (!privilege.isUserLogin(request))
	return;
UserDb ud = new UserDb();
ud = ud.getUser(privilege.getUser(request));
if (!ud.getUserGroupDb().getCode().equals(ReplyUnit.code)) {
	return;
}
String sql = "select count(*) from sq_message m, plugin_reply r where r.msg_id=m.id and r.manager=" + StrUtil.sqlstr(privilege.getUser(request)) + " and r.is_replied=0";
JdbcTemplate jt = new JdbcTemplate();
ResultIterator ri = jt.executeQuery(sql);
int count = 0;
if (ri.hasNext()) {
	ResultRecord rr = (ResultRecord)ri.next();
	count = rr.getInt(1);
}
%>
<table width="100%" border="0" align="center" cellpadding="5" cellspacing="1">
  <tbody>
    <tr>
      <td height="23" align="left"><a href="<%=request.getContextPath()%>/forum/plugin/reply/reply_list.jsp" target="_blank"><strong>政务问答待回复数：<%=count%></strong></a>
</td></tr></table>