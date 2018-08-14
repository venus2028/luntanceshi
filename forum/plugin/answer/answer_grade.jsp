<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="org.jdom.*"%>
<%@ page import="org.jdom.output.*"%>
<%@ page import="org.jdom.input.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.plugin.answer.*"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String skincode = UserSet.getSkin(request);
if (skincode.equals(""))
	skincode = UserSet.defaultSkin;
SkinMgr skm = new SkinMgr();
Skin skin = skm.getSkin(skincode);
if (skin==null)
	skin = skm.getSkin(UserSet.defaultSkin);
String skinPath = skin.getPath();
%>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
	String op = ParamUtil.get(request, "op");
	long msgId = ParamUtil.getLong(request, "msgId");

	if (op.equals("userGrade")) {
		boolean re = false;
		try {
			MsgDb md = new MsgDb();
			md = md.getMsgDb(msgId);
			if (!md.getName().equals(privilege.getUser(request))) {
				out.print(StrUtil.Alert("您不是楼主，只有楼主才能评分！"));
				%>
			<script>
			window.close();
			</script>				
				<%
				return;
			}
%><%			
			AnswerDb ad = new AnswerDb();
			ad = (AnswerDb)ad.getQObjectDb(msgId);
			
			if (ad.getInt("score_user")>0) {
				out.print(StrUtil.Alert("您已经评过分了！"));
			%>
			<script>
			window.close();
			</script>
			<%
				return;
			}
			
			int score = ParamUtil.getInt(request, "score");
			ad.set("score_user", new Integer(score));
			
			AnswerConfig ac =AnswerConfig.getInstance();
			int expireDay = ac.getIntProperty("answer.expireDay");			
			int d = DateUtil.datediff(new java.util.Date(), ad.getDate("reply_date"));
			// 置过期天数
			if (d>expireDay)
				ad.set("expire_days", new Integer(Math.abs(d-expireDay)));
			else
				ad.set("expire_days", new Integer(0));
			
			re = ad.save();
			if (re) {
				out.println(StrUtil.Alert(SkinUtil.LoadString(request,"info_operate_success")));
			}
			else {
				out.println(StrUtil.Alert(SkinUtil.LoadString(request,"info_operate_fail")));
			}
		}
		catch (ErrMsgException e) {
			out.print(StrUtil.Alert(e.getMessage()));
		}
		%>
		<script>
		window.opener.location.reload();
		window.close();
		</script>
		<%
		return;
	}
	else if (op.equals("masterGrade")) {
		if (!privilege.isMasterLogin(request)) {
			out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, "pvg_invalid")));
			return;
		}
		boolean re = false;
		try {
			AnswerDb ad = new AnswerDb();
			ad = (AnswerDb)ad.getQObjectDb(msgId);
			int score_master = ParamUtil.getInt(request, "score");
			ad.set("score_master", new Integer(score_master));
			
			AnswerConfig ac =AnswerConfig.getInstance();
			int expireDay = ac.getIntProperty("answer.expireDay");
			int scoreReply = ac.getIntProperty("answer.scoreReply");	
            int scoreDeductDay = ac.getIntProperty("answer.scoreDeductDay");
					
			int score = scoreReply;
			if (ad.getInt("score_user")!=-1)
				score += ad.getInt("score_user");
			score += score_master;
			int d = DateUtil.datediff(new java.util.Date(), ad.getDate("reply_date"));

			if (d>expireDay) {
	            int dlt = scoreDeductDay*(d-expireDay);		
				score -= dlt;
			}
			ad.set("score_all", new Integer(score));
			
			re = ad.save();
			if (re) {
				out.println(StrUtil.Alert(SkinUtil.LoadString(request,"info_operate_success")));
			}
			else {
				out.println(StrUtil.Alert(SkinUtil.LoadString(request,"info_operate_fail")));
			}
		}
		catch (ErrMsgException e) {
			out.print(StrUtil.Alert(e.getMessage()));
		}
		%>
		<script>
		window.opener.location.reload();
		window.close();
		</script>
		<%
		return;	
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE>答复贴子 - <%=Global.AppName%></TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<link href="../../<%=skinPath%>/skin.css" rel="stylesheet" type="text/css">
<META content="MSHTML 6.00.2600.0" name=GENERATOR></HEAD>
<BODY topMargin=0>
<br>
<br>
</BODY></HTML>
