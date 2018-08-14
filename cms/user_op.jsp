<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privmgr" scope="page" class="cn.js.fan.module.pvg.PrivMgr"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.cms.user" key="mgr_user"/></title>
<link href="../common.css" rel="stylesheet" type="text/css">
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script src="../inc/common.js"></script>
<script>
function setPerson(userName, nick){
	form1.name.value = nick;
	form1.realname.value = nick;
	form1.isForegroundUser.value = "true";
}
</script>
</head>
<body>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, PrivDb.PRIV_ADMIN)) {
	out.println(SkinUtil.makeErrMsg(request, privilege.MSG_INVALID));
	return;
}

String op = ParamUtil.get(request, "op");
User user = null;
boolean isEdit = false;
if (op.equals("edit")) {
	isEdit = true;
	String name = ParamUtil.get(request, "name");
	if (name.equals("")) {
		out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
		return;
	}
	user = new User(name);
}
else if (op.equals("editdo")) {
	isEdit = true;
	UserMgr usermgr = new UserMgr();
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
else if (op.equals("setuserofgroup")) {
	isEdit = true;
	String name = ParamUtil.get(request, "name");
	if (name.equals("")) {
		StrUtil.Alert_Back(SkinUtil.LoadString(request,"res.label.cms.user","username_can_not_null"));
		return;
	}
	UserMgr usermgr = new UserMgr();
	user = usermgr.getUser(name);
	try {
		if (user.setGroup(request))
			out.print(StrUtil.Alert(SkinUtil.LoadString(request,"info_op_success")));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
}
else if (op.equals("setprivs")) {
	try {
		String username = ParamUtil.get(request, "name");
		user = new User();
		user = user.getUser(username);
		if (user.setPrivs(request))
			out.print(StrUtil.Alert(SkinUtil.LoadString(request,"info_op_success")));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head"><a href="user_m.jsp">
        <lt:Label res="res.label.cms.user" key="mgr_user"/>
      </a></td>
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
	  <%if (user!=null) {%>
	  	  <lt:Label res="res.label.cms.user" key="modify_user"/>
	  	  <%}else{%>
		  <lt:Label res="res.label.cms.user" key="add_user"/>
		  <%}%>
	  </TD>
    </TR>
    <TR class=row style="BACKGROUND-COLOR: #fafafa">
      <TD height="175" align="center" style="PADDING-LEFT: 10px"><table class="frame_gray" width="64%" border="0" cellpadding="0" cellspacing="1">
          <tr>
            <td align="center"><table width="100%" border="0" cellpadding="2" cellspacing="0">
                <form name="form1" method="post" action="<%=user!=null?"user_op.jsp?op=editdo":"user_m.jsp?op=add"%>">
                  <tr>
                    <td width="27%" height="31" align="right"><lt:Label res="res.label.cms.user" key="name"/></td>
                  <td width="73%" align="left"><input name="name" value="<%=user!=null?user.getName():""%>" <%=isEdit?"readonly":""%>></td>
                  </tr>
                  <tr>
                    <td height="32" align="right"><lt:Label res="res.label.cms.user" key="real_name"/></td>
                    <td align="left"><input name="realname" value="<%=user!=null?user.getRealName():""%>" ></td>
                  </tr>
                  <tr>
                    <td height="32" align="right"><lt:Label res="res.label.cms.user" key="desc"/></td>
                    <td align="left"><input name="desc" value="<%=user!=null?user.getDesc():""%>"></td>
                  </tr>
                  <tr>
                    <td height="32" align="right"><lt:Label res="res.label.cms.user" key="pwd"/></td>
                    <td align="left"><input name="pwd" type="password" id="pwd">
                    <%=user!=null?"":"(前台用户无需填写密码)"%></td>
                  </tr>
                  <tr>
                    <td height="32" align="right"><lt:Label res="res.label.cms.user" key="pwd_confirm"/></td>
                    <td align="left"><input name="pwd_confirm" type="password" id="pwd_confirm"></td>
                  </tr>
                  <tr>
                    <td height="32" align="right"><lt:Label res="res.label.cms.user" key="is_foreground_user"/></td>
                    <td align="left">
					<select name="isForegroundUser">
					<option value="true"><lt:Label key="yes"/></option>
					<option value="false"><lt:Label key="no"/></option>
					</select>
					<%if (isEdit) {%>
					<script>
					form1.isForegroundUser.value = "<%=user.isForegroundUser()?"true":"false"%>";
					</script>
					<%}else{%>
					<a href="javascript:openWin('../forum/admin/forum_user_sel.jsp', 640, 420)">选择</a>&nbsp;(前台用户即论坛中的用户)
					<%}%>
					</td>
                  </tr>
                  <tr>
                    <td colspan="2" align="center">                    </td>
                  </tr>
                  <tr>
                    <td height="43" colspan="2" align="center"><input name="Submit" type="submit" class="singleboarder" value="<%=SkinUtil.LoadString(request, "res.label.cms.user","submit")%>">
&nbsp;&nbsp;&nbsp;
                      <input name="Submit" type="reset" class="singleboarder" value="<%=SkinUtil.LoadString(request, "res.label.cms.user","reset")%>"></td>
                  </tr>
                  <tr>
                    <td height="43" colspan="2" align="center">
					<%if (isEdit) {%>
					<lt:Label res="res.label.cms.user" key="op_msg"/>
					<%}%></td>
                  </tr>
                </form>
            </table></td>
          </tr>
      </table><br>
	  <%if (user!=null) {%>
        <table class="" width="72%" border="0" cellpadding="0" cellspacing="1">
          <tr>
            <td align="center"><table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="90%" align="center">
              <form name="form1" method="post" action="?op=setuserofgroup">
                <tbody>
                  <tr>
                    <td class="thead" style="PADDING-LEFT: 10px" noWrap width="15%">&nbsp;</td>
                    <td width="32%" align="left" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
                      <lt:Label res="res.label.cms.user" key="user_group_code"/></td>
                    <td width="53%" align="left" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
                      <lt:Label res="res.label.cms.user" key="user_group_desc"/></td>
                  </tr>
                  <%
UserGroupMgr usergroupmgr = new UserGroupMgr();		  
UserGroup[] ugs = usergroupmgr.getAllUserGroup();
int len = 0;
if (ugs!=null)
	len = ugs.length;
UserGroup[] userofgroups = user.getGroup();
int ulen = 0;
if (userofgroups!=null)
	ulen = userofgroups.length;

String group_code, desc;

for (int i=0; i<len; i++) {
	UserGroup ug = ugs[i];
	group_code = ug.getCode();
	desc = ug.getDesc();
	%>
                  <tr class="row" style="BACKGROUND-COLOR: #ffffff">
                    <td style="PADDING-LEFT: 10px"><%
	  boolean isChecked = false;
	  for (int k=0; k<ulen; k++) {
	  	if (userofgroups[k].getCode().equals(group_code)) {
			isChecked = true;
			break;
		}
	  }
	  if (isChecked)
	  	out.print("<input type=checkbox name=group_code value='" + group_code + "' checked>");
	  else
	  	out.print("<input type=checkbox name=group_code value='" + group_code + "'");
	  %>
                    </td>
                    <td align="left" style="PADDING-LEFT: 10px"><%=group_code%></td>
                    <td align="left"><%=desc%></td>
                  </tr>
                  <%}%>
                  <tr align="center" class="row" style="BACKGROUND-COLOR: #ffffff">
                    <td colspan="3" style="PADDING-LEFT: 10px"><input type=hidden name="name" value="<%=user.getName()%>">
                        <input name="Submit" type="submit" class="singleboarder" value="<%=SkinUtil.LoadString(request, "res.label.cms.user","submit")%>">
&nbsp;&nbsp;&nbsp;
          <input name="Submit" type="reset" class="singleboarder" value="<%=SkinUtil.LoadString(request, "res.label.cms.user","reset")%>"></td>
                  </tr>
                </tbody>
              </form>
            </table></td>
          </tr>
        </table>
		<%}%>
        <%
if (user!=null) {		
%>
        <br>
        <table width="44%"  border="0">
          <tr>
            <td align="center"><strong><lt:Label res="res.label.cms.user" key="priv_setting"/></strong></td>
          </tr>
        </table>
                <table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="64%" align="center">
          <form name="form1" method="post" action="?op=setprivs">
            <tbody>
              <tr>
                <td class="thead" style="PADDING-LEFT: 10px" noWrap width="15%">
				<input type=hidden name="name" value="<%=user.getName()%>">
				</td>
                <td width="29%" align="left" noWrap class="thead" style="PADDING-LEFT: 10px"><span class="thead" style="PADDING-LEFT: 10px"><img src="images/tl.gif" align="absMiddle" width="10" height="15"></span>
                <lt:Label res="res.label.cms.user" key="code"/></td>
                <td width="56%" align="left" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
                <lt:Label res="res.label.cms.user" key="desc"/></td>
              </tr>
<%
String[] userprivs = user.getPrivs();
PrivDb[] privs = privmgr.getAllPriv();
String priv, desc;
			  
int len = 0;
if (privs!=null)
	len = privs.length;
int privlen = 0;
if (userprivs!=null)
	privlen = userprivs.length;
	
for (int i=0; i<len; i++) {
	PrivDb pv = privs[i];
	priv = pv.getPriv();
	desc = pv.getDesc();
	%>
              <tr class="row" style="BACKGROUND-COLOR: #ffffff">
                <td style="PADDING-LEFT: 10px">
				&nbsp;<img src="images/arrow.gif" align="absmiddle">&nbsp;
				<%
	  boolean isChecked = false;
	  for (int k=0; k<privlen; k++) {
	  	if (userprivs[k].equals(priv)) {
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
                <td align="left" style="PADDING-LEFT: 10px"><%=priv%></td>
                <td align="left"><%=desc%></td>
              </tr>
              <%}%>
              <tr align="center" class="row" style="BACKGROUND-COLOR: #ffffff">
                <td colspan="3" style="PADDING-LEFT: 10px"><input type=hidden name=username value="<%=user.getName()%>">
                    <input name="Submit" type="submit" class="singleboarder" value="<%=SkinUtil.LoadString(request, "res.label.cms.user","submit")%>">
&nbsp;&nbsp;&nbsp;
          <input name="Submit" type="reset" class="singleboarder" value="<%=SkinUtil.LoadString(request, "res.label.cms.user","reset")%>"></td>
              </tr>
            </tbody>
          </form>
        </table>
<%}%>		
</TD>
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
</html>