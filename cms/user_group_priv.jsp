<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<title><lt:Label res="res.label.cms.user" key="mgr_login"/></title>
<link href="../common.css" rel="stylesheet" type="text/css">
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="privmgr" scope="page" class="cn.js.fan.module.pvg.PrivMgr"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, PrivDb.PRIV_ADMIN))
{
	out.println(SkinUtil.makeErrMsg(request, privilege.MSG_INVALID));
	return;
}
%>
<%
String group_code = ParamUtil.get(request, "group_code");
if (group_code.equals("")) {
	out.print(StrUtil.makeErrMsg(SkinUtil.LoadString(request,"res.label.cms.user","code_can_not_null")));
	return;
}

String op = StrUtil.getNullString(request.getParameter("op"));
if (op.equals("setgrouppriv")) {
	cn.js.fan.module.pvg.Privilege privg = new cn.js.fan.module.pvg.Privilege();
	try {
		if (privg.setGroupPriv(request))
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"info_op_success"), "user_group_priv.jsp?group_code=" + StrUtil.UrlEncode(group_code)));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head"><lt:Label res="res.label.cms.user" key="mgr_group_priv"/></td>
    </tr>
  </tbody>
</table>
<%
UserGroup ug = new UserGroup();
String[] grouppriv = ug.getGroupPriv(group_code);

PrivDb[] privs = privmgr.getAllPriv();
String priv, desc;
%>
<br>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="77%" align="center">
   <form name="form1" method="post" action="?op=setgrouppriv">
  <tbody>
    <tr>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="15%">&nbsp;</td>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="32%"><lt:Label res="res.label.cms.user" key="code"/></td>
      <td class="thead" noWrap width="53%"><img src="images/tl.gif" align="absMiddle" width="10" height="15"><lt:Label res="res.label.cms.user" key="desc"/></td>
    </tr>
<%
int len = 0;
if (privs!=null)
	len = privs.length;
int privlen = 0;
if (grouppriv!=null)
	privlen = grouppriv.length;
	
for (int i=0; i<len; i++) {
	PrivDb pv = privs[i];
	priv = pv.getPriv();
	desc = pv.getDesc();
	%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">
	  <%
	  boolean isChecked = false;
	  for (int k=0; k<privlen; k++) {
	  	if (grouppriv[k].equals(priv)) {
			isChecked = true;
			break;
		}
	  }
	  if (isChecked)
	  	out.print("<input type=checkbox name=priv value='" + priv + "' checked>");
	  else
	  	out.print("<input type=checkbox name=priv value='" + priv + "'");
	  %>
	  </td>
      <td style="PADDING-LEFT: 10px">&nbsp;<img src="images/arrow.gif" align="absmiddle">&nbsp;<%=priv%></td>
      <td><%=desc%></td>
    </tr>
<%}%>
    <tr align="center" class="row" style="BACKGROUND-COLOR: #ffffff">
      <td colspan="3" style="PADDING-LEFT: 10px">
	  <input type=hidden name=group_code value="<%=group_code%>">
	  <input name="Submit" type="submit" class="singleboarder" value="<%=SkinUtil.LoadString(request, "res.label.cms.user","submit")%>">
&nbsp;&nbsp;&nbsp;
<input name="Submit" type="reset" class="singleboarder" value="<%=SkinUtil.LoadString(request, "res.label.cms.user","reset")%>"></td>
    </tr>
  </tbody></form>
</table>
<DIV style="WIDTH: 95%" align=right></DIV>
</body>
<script language="javascript">
<!--
function form1_onsubmit()
{
	errmsg = "";
	if (form1.pwd.value!=form1.pwd_confirm.value)
		errmsg += "<lt:Label res="res.label.cms.user" key="mima_check"/>"
	if (errmsg!="")
	{
		alert(errmsg);
		return false;
	}
}
//-->
</script>
</html>