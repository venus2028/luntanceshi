<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.plugin.reward.*"%>
<%@ page import="com.redmoon.forum.plugin.score.*"%>
<%
long msgId = ParamUtil.getLong(request, "msgId");
MsgDb md = new MsgDb();
md = md.getMsgDb(msgId);
if (md.getReplyid()!=-1) {
	// 回复贴无需编辑
	// return;
}
%>