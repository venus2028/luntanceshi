<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../../../inc/inc.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.db.Conn"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.plugin.reply.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.Leaf"%>
<%@ page import="com.redmoon.forum.LeafChildrenCacheMgr"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="pragma" content="no-cache">
<link rel="stylesheet" href="../../../common.css">
<LINK href="../../../admin/default.css" type=text/css rel=stylesheet>
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>分配答复人员</title>
<script src="../../../../inc/common.js"></script>
<script>
function setPerson(userName, userNick){
	form1.name.value = userNick;
}
</script>
<body bgcolor="#FFFFFF" topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
long id = ParamUtil.getLong(request, "id");
MsgDb md = new MsgDb();
md = md.getMsgDb(id);
if (!md.isLoaded()) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, "贴子不存在！"));
	return;
}

// 检查权限是否为总管理员或版主
if (!privilege.isMasterLogin(request)) {
	if (!privilege.isManager(request, md.getboardcode())) {
		out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
		return;
	}
}

String code = ReplyUnit.code;
PluginMgr pm = new PluginMgr();
PluginUnit pu = pm.getPluginUnit(code);

String op = ParamUtil.get(request, "op");
if (op.equals("distribute")) {
	try {
		ReplyMsgAction rma = new ReplyMsgAction();
		if (rma.distribute(request)) {
			// 发短信息		
			out.print(StrUtil.Alert("操作成功！"));
		%>
			<script>
			window.opener.location.reload();
			window.close();
			window.opener.focus();
			</script>
		<%
		}
		else {
			out.print(StrUtil.Alert_Back("操作失败！"));
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}
%>
<form name="form1" method="post" action="?op=distribute">
<table width="100%" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr> 
    <td height=20 align="left" class="thead"><a href="../../../showtopic_tree.jsp?showid=<%=id%>" target="_blank"><%=StrUtil.toHtml(md.getTitle())%></a></td>
  </tr>
  <tr> 
    <td valign="top">&nbsp;&nbsp;选择答复者
	<select name="name">
	<option value="">请选择</option>
<%
String sql = "select name from sq_user";
sql += " where group_code=" + StrUtil.sqlstr("reply");
sql += " order by regdate asc";
UserDb user = new UserDb();
Iterator ir = user.list(sql).iterator();
while (ir.hasNext()) {
	user = (UserDb)ir.next();
%>
<option value="<%=user.getNick()%>"><%=user.getNick()%></option>
<%
}
%>	
	</select>
    <!--
      <input type="text" size=20 name="name" style="border:1pt solid #636563;font-size:9pt">
	<a href="#" onClick="openWin('../../../admin/forum_user_sel.jsp?groupCode=<%=ReplyUnit.code%>', 480, 420)">
    <lt:Label res="res.label.forum.admin.manager_list" key="select"/>
    </a>
	-->
    <input name="id" type="hidden" value="<%=id%>">	</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;
      <input name="isMsg" value="1" type="checkbox" checked>
      内部消息通知	  
      <input name="isSms" value="1" type="checkbox" checked>
      短信通知</td>
  </tr>
  <tr>
    <td align="center" valign="top"><input name="submit" type="submit" value="确定"></td>
  </tr>
  <tr>
    <td align="center" valign="top">&nbsp;</td>
  </tr>
</table>
</form>
</body>                                        
</html>                            
  