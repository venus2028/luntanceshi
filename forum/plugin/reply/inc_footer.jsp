<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="org.jdom.*"%>
<%@ page import="org.jdom.output.*"%>
<%@ page import="org.jdom.input.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.redmoon.forum.OnlineInfo"%>
<%@ page import="com.redmoon.forum.plugin.reply.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.Global"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/><jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/><%
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

if (count==0)
	return;

String msgStr = "<a target=_blank href=\"" + request.getContextPath() + "/forum/plugin/reply/reply_list.jsp\">政务问答待回复数：" + count + "</a>";
com.redmoon.forum.Config cfgPop = com.redmoon.forum.Config.getInstance();
%>
<script>
function msgPopupReply(){
	var msgPop=document.getElementById("winpopReply");
	var popH=parseInt(msgPop.style.height);
	if (popH==0){
		msgPop.style.display="block";
		show=setInterval("changeHReply('up')",2);
	}
	else {
		hide=setInterval("changeHReply('down')",2);
	}
}
function changeHReply(str) {
	var msgPop=document.getElementById("winpopReply");
	var popH=parseInt(msgPop.style.height);
	if(str=="up"){
		if (popH<=100){
			msgPop.style.height=(popH+4).toString()+"px";
		}
		else{  
			clearInterval(show);
		}
	}
	if(str=="down"){ 
		if (popH>=4){
		   msgPop.style.height=(popH-4).toString()+"px";
		}
		else{
		   clearInterval(hide);
		   msgPop.style.display="none";
		}
	}
}
window.onload=function(){
document.getElementById('winpopReply').style.height='0px';
setTimeout("msgPopupReply()",80);
}
</script>
<style>
#winpopReply {
width:200px; height:0px; position:absolute; right:0; bottom:0; 
background-color:#DAE6FC;
BORDER-RIGHT: #455690 1px solid;
BORDER-TOP: #a6b4cf 1px solid;
BORDER-LEFT: #a6b4cf 1px solid;
BORDER-BOTTOM: #455690 1px solid;
margin:0; padding:1px; overflow:hidden; display:none;
}
#winpopReply .title {
width:100%; height:20px; line-height:20px;
background: #5FABCF;
font-weight:bold; text-align:center; font-size:12px; color:#ffffff; }
#winpopReply .con {
width:100%; height:80px; line-height:80px; font-weight:bold; font-size:12px; text-align:center}
#winpopReply .con a:link,#winpop .con a:visited{ color:#F00; text-decoration:none;}
#winpopReply .con a:hover{ color:#09F;}
#winpopReply .close { position:absolute; right:4px; top:-1px; color:#FFFFFF; cursor:pointer}
</style>
<div id="winpopReply">
  <div class="title">提示<span class="close" onClick="msgPopupReply()">×</span></div>
  <div class="con">
    <%if (cfgPop.getBooleanProperty("forum.isNewMsgPlaySound")) {%>
    <object NAME='player' classid=clsid:22d6f312-b0f6-11d0-94ab-0080c74c7e95 width=350 height=70 style="display:none">
      <param name=showstatusbar value=1>
      <param name=filename value='<%=request.getContextPath()%>/message/msg.wav'>
      <param name="AUTOSTART" value="true" />
      <embed src='<%=request.getContextPath()%>/message/msg.wav'> </embed>
    </object>
    <%}%>
    <%=msgStr%>
  </div>
</div>
