<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.plugin.witkey.*"%>
<%@ page import="com.redmoon.forum.plugin.score.*"%>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<script language="javascript">
function changeReplyType(){
	if(frmAnnounce.replyType.value == "<%=WitkeyReplyDb.REPLY_TYPE_CONTRIBUTION%>"){
		viewTypeTable.style.display = "";
	}else{
		viewTypeTable.style.display = "none";
	}
}
</script>
<%
	String replyType = ParamUtil.get(request, "replytype");
		
	String replyId = ParamUtil.get(request, "replyid");	
	
	String rootId = ParamUtil.get(request, "rootid");	
	
    String userName = privilege.getUser(request);	

	WitkeyUserDb wud = new WitkeyUserDb();
	if(!replyId.equals("")){
    	wud = wud.getWitkeyUserDb(Long.parseLong(replyId), userName);
	}else{
		wud = wud.getWitkeyUserDb(Long.parseLong(rootId), userName);
	}
%>
<table width="98%">
  <tr>
    <td>选择回复类型：
	  <select name="replyType" onchange="changeReplyType()">
<%
	if(wud != null && wud.isLoaded()){
		if(replyType.equals("")){
%>
	    <option value="<%=WitkeyReplyDb.REPLY_TYPE_CONTRIBUTION%>" selected>我要投稿</option>
        <option value="<%=WitkeyReplyDb.REPLY_TYPE_COMMUNICATION%>" >任务交流</option>
<%
		}else{
			if(Integer.parseInt(replyType) == WitkeyReplyDb.REPLY_TYPE_CONTRIBUTION){
%>
				<option value="<%=WitkeyReplyDb.REPLY_TYPE_CONTRIBUTION%>">我要投稿</option>
<%
			}else{
%>
				<option value="<%=WitkeyReplyDb.REPLY_TYPE_COMMUNICATION%>">任务交流</option>
<%			
			}
		}
	}else{	  
%>
		<option value="<%=WitkeyReplyDb.REPLY_TYPE_COMMUNICATION%>">任务交流</option>
<%
	}	  
%>
	  </select><input type="hidden" name="pluginCode" value="<%=WitkeyUnit.code%>" />
    </td>
  </tr>
</table>
<table width="98%" id="viewTypeTable">
  <tr>
    <td>选择可见方式：
	  <select name="witkeyViewType">
		<option value="<%=WitkeyReplyDb.SECRET_LEVEL_FORUM_PUBLIC%>" selected>公共可见</option>
		<option value="<%=WitkeyReplyDb.SECRET_LEVEL_MSG_USER%>">本贴内用户可见</option>
		<option value="<%=WitkeyReplyDb.SECRET_LEVEL_MSG_USER_REPLIED%>">被回复者可见</option>
		<option value="<%=WitkeyReplyDb.SECRET_LEVEL_MSG_OWNER%>">楼主可见</option>
		<option value="<%=WitkeyReplyDb.SECRET_LEVEL_MASTER%>">版主可见</option>
	  </select>
    </td>
  </tr>
</table>
<script language="javascript">
if(frmAnnounce.replyType.value == "<%=WitkeyReplyDb.REPLY_TYPE_CONTRIBUTION%>"){
	viewTypeTable.style.display = "";
}else{
	viewTypeTable.style.display = "none";
}
</script>

