<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %><html>
<jsp:useBean id="privmgr" scope="page" class="cn.js.fan.module.pvg.PrivMgr"/>
<html>
<head>
<title><lt:Label res="res.label.cms.user" key="mgr_user"/></title>
<link href="../common.css" rel="stylesheet" type="text/css">
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserLogin(request))
{
	out.println(SkinUtil.makeErrMsg(request, privilege.MSG_INVALID));
	return;
}

String op = ParamUtil.get(request, "op");
UserMgr usermgr = new UserMgr();
User user = usermgr.getUser(privilege.getUser(request)) ;
boolean isEdit = false;
if (op.equals("edit")) {
	isEdit = true;
	try {
		if (usermgr.update(request))
			out.print(StrUtil.Alert(SkinUtil.LoadString(request,"info_op_success")));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	String name = ParamUtil.get(request, "name");
	if (name.equals("")) {
		StrUtil.Alert_Back(SkinUtil.LoadString(request,"res.label.cms.user","username_can_not_null"));
		return;
	}
	user = usermgr.getUser(name);
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head"><lt:Label res="res.label.cms.user" key="modify_user_info"/></td>
    </tr>
  </tbody>
</table>
<br>
<TABLE 
style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" 
cellSpacing=0 cellPadding=3 width="95%" align=center>
  <!-- Table Head Start-->
  <TBODY>
    <TR>
      <TD class=thead style="PADDING-LEFT: 10px" noWrap width="70%">
  	    <lt:Label res="res.label.cms.user" key="user_info"/></TD>
    </TR>
    <TR class=row style="BACKGROUND-COLOR: #fafafa">
      <TD height="175" align="center" style="PADDING-LEFT: 10px"><br>
        <table class="frame_gray" width="64%" border="0" cellpadding="0" cellspacing="1">
          <tr>
            <td align="center"><table width="71%" border="0" cellpadding="2" cellspacing="0">
                <form name="form1" method="post" action="?op=edit" onsubmit="return form1_onsubmit()">
                  <tr>
                    <td height="31" align="right"><lt:Label res="res.label.cms.user" key="name"/></td>
                  <td align="left"><%=user.getName()%><input name="name" value="<%=user!=null?user.getName():""%>" type="hidden"></td>
                  </tr>
                  <tr>
                    <td height="32" align="right"><lt:Label res="res.label.cms.user" key="real_name"/></td>
                    <td align="left"><input name="realname" value="<%=user!=null?user.getRealName():""%>" ></td>
                  </tr>
                  <tr>
                    <td height="32" align="right"><lt:Label res="res.label.cms.user" key="desc"/></td>
                    <td align="left"><input name="desc" value="<%=user!=null?StrUtil.getNullStr(user.getDesc()):""%>">
					<input name="isForegroundUser" type="hidden" value="<%=user.isForegroundUser()?"true":"false"%>">
					</td>
                  </tr>
                  <tr>
                    <td height="32" align="right"><lt:Label res="res.label.cms.user" key="pwd"/></td>
                    <td align="left"><input name="pwd" type="password" id="pwd"></td>
                  </tr>
                  <tr>
                    <td height="32" align="right"><lt:Label res="res.label.cms.user" key="pwd_confirm"/></td>
                    <td align="left"><input name="pwd_confirm" type="password" id="pwd_confirm"></td>
                  </tr>
                  <tr>
                    <td colspan="2" align="center">                    </td>
                  </tr>
                  <tr>
                    <td height="43" colspan="2" align="center"><input name="Submit" type="submit" class="singleboarder" value="<%=SkinUtil.LoadString(request, "res.label.cms.user","submit")%>">
&nbsp;&nbsp;&nbsp;
                      <input name="Submit" type="reset" class="singleboarder" value="<%=SkinUtil.LoadString(request, "res.label.cms.user","reset")%>"></td>
                  </tr>
                </form>
            </table></td>
          </tr>
      </table>
          <br>
      <br></TD>
    </TR>
    <!-- Table Body End -->
    <!-- Table Foot -->
    <TR>
      <TD class=tfoot align=right><DIV align=right> </DIV></TD>
    </TR>
    <!-- Table Foot -->
  </TBODY>
</TABLE>
<br>
<br>
</body>
<script language="javascript">
<!--
function form1_onsubmit()
{
	if (form1.pwd.value=="") {
		alert("<lt:Label res="res.label.cms.user" key="pwd_can_not_null"/>");
		return false;
	}
	if (form1.pwd.value!=form1.pwd_confirm.value) {
		alert("<lt:Label res="res.label.cms.user" key="pwd_msg"/>");
		return false;
	}
}
//-->
</script>
</html>