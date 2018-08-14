<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.plugin.witkey.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.setup.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%
Privilege privilege = new Privilege();
if (!privilege.isUserLogin(request)) {
	out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, "err_not_login")));
	return;
}

String msgId = ParamUtil.get(request, "msgId");
if (msgId.equals("")) {
	out.print(SkinUtil.makeErrMsg(request, "缺少文章编号！"));
	return;
}	

String op = ParamUtil.get(request, "op");

if(op.equals("addUserInfo")){
	WitkeyUserMgr wum = new WitkeyUserMgr();
	try {	
		if(wum.add(request)){
		    WitkeyDb wd = new WitkeyDb();
			wd = wd.getWitkeyDb(Long.parseLong(msgId)); 
			wd.setUserCount(wd.getUserCount() + 1);
			wd.save();
			out.print(StrUtil.Alert_Redirect("报名成功！", "userinfo_list.jsp?msgId=" + msgId));
			return;
		}else{
			out.print(StrUtil.Alert_Back("报名失败！"));
			return;
		}
	} catch (ErrMsgException e) {
        out.print(StrUtil.Alert_Back(e.getMessage()));
    } 
}


if(op.equals("evaluation")){
	String boardcode = ParamUtil.get(request, "boardCode");

	String content = ParamUtil.get(request, "content");
	if (content.equals("")) {
		out.print(SkinUtil.makeErrMsg(request, "缺少点评内容！"));
		return;
	}	

	WitkeyEvaluationDb wed = new WitkeyEvaluationDb();
	wed.setMsgId(Long.parseLong(msgId));
	wed.setUserName(privilege.getUser(request));
	wed.setContent(content);
	if(wed.create()){
		out.print(StrUtil.Alert_Redirect("点评成功！", "evaluation.jsp?msgId=" + msgId + "&boardCode=" + StrUtil.UrlEncode(boardcode)));
		return;
	}else{
		out.print(StrUtil.Alert_Back("点评失败！"));
		return;
	}
}

if(op.equals("check")){	
	
	MsgMgr mm = new MsgMgr();
	MsgDb md = mm.getMsgDb(Long.parseLong(msgId));
	
	WitkeyDb wd = new WitkeyDb();
	wd = wd.getWitkeyDb(md.getRootid());
	
	wd.setStatus(WitkeyDb.WITKEY_STATUS_OVER);
	wd.setMsgId(Long.parseLong(msgId));
	
	if(wd.save()){
		out.print(StrUtil.Alert_Redirect("任务中标成功！", "../../showtopic.jsp?rootid=" + md.getRootid()));
		return;
	}else{
		out.print(StrUtil.Alert_Back("任务中标失败！"));
		return;
	}	
}
%>