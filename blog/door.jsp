<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
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
<html>
<head>
<title><lt:Label res="res.label.door" key="login"/> - <%=Global.AppName%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<LINK href="../forum/<%=skinPath%>/skin.css" type=text/css rel=stylesheet>
<style type="text/css">
<!--
body {
	margin-top: 0px;
	margin-left: 0px;
	margin-right: 0px;
}
.style1 {
	color: #FFFFFF;
	font-weight: bold;
}
.STYLE2 {color: #FFFFFF}
-->
</style></head>
<body bgcolor="#FFFFFF" text="#000000">
<p>&nbsp;</p>
<%
String privurl = "";
String targeturl = StrUtil.getNullString(request.getParameter("targeturl"));
if (!targeturl.equals(""))
	privurl = targeturl;
else
	privurl = StrUtil.getNullString(request.getParameter("privurl"));
privurl = StrUtil.toHtml(privurl);
%>
<table width="46%" height="155"  border="1" align="center" cellpadding="1" cellspacing="0" bordercolor="<%=skin.getTableBorderClr()%>">
  <tr>
    <td height="26" align="center" class="td_title"><lt:Label res="res.label.door" key="user_login"/></td>
  </tr>
  <tr>
    <td><table width="88%" border="0" align="center" cellpadding="1" cellspacing="0" class="p9">
      <form name=form1 action="login.jsp" method="post" onSubmit="return form1_onsubmit()">
        <tr>
          <td width="23%" height="22" align="left"><lt:Label res="res.label.door" key="user_name"/></td>
          <td width="77%" height="22"><input name="name" style="width:120"></td>
        </tr>
        <tr>
          <td height="22" align="left"><lt:Label res="res.label.door" key="pwd"/></td>
          <td height="22"><input name=pwd type=password style="width:120"><input name="privurl" type="hidden" value="<%=privurl%>">          </td>
        </tr>
		<%
        com.redmoon.forum.Config cfg = com.redmoon.forum.Config.getInstance();
        if (cfg.getBooleanProperty("forum.loginUseValidateCode")) {
		%>
        <tr>
          <td height="22" align="left"><lt:Label res="res.label.door" key="validate_code"/></td>
          <td height="22"><input name="validateCode" type="text" size="1">
            <img src='../validatecode.jsp' border=0 align="absmiddle" style="cursor:hand" onClick="this.src='../validatecode.jsp'" alt="<lt:Label res="res.label.forum.index" key="refresh_validatecode"/>"></td>
        </tr>		
		<%}%>		
        <tr>
          <td height="22" align="left"><lt:Label res="res.label.door" key="save"/></td>
          <td height="22"><select name="loginSaveDate">
            <option value="<%=com.redmoon.forum.Privilege.LOGIN_SAVE_NONE%>" selected><lt:Label res="res.label.door" key="not_save"/></option>
            <option value="<%=com.redmoon.forum.Privilege.LOGIN_SAVE_DAY%>"><lt:Label res="res.label.door" key="save_one_day"/></option>
            <option value="<%=com.redmoon.forum.Privilege.LOGIN_SAVE_MONTH%>"><lt:Label res="res.label.door" key="save_one_month"/></option>
            <option value="<%=com.redmoon.forum.Privilege.LOGIN_SAVE_YEAR%>"><lt:Label res="res.label.door" key="save_one_year"/></option>
          </select>
&nbsp; </td>
        </tr>
        <tr>
          <td height="22" align="left"><lt:Label res="res.label.forum.index" key="login_hide"/></td>
          <td height="22"><select name="covered">
            <option value=0 selected type='checkbox' checked><lt:Label res="res.label.forum.index" key="login_not_hide"/></option>
            <option value=1><lt:Label res="res.label.forum.index" key="login_hide"/></option>
          </select></td>
        </tr>
        
        <tr align="center">
          <td height="35" colspan="3"><input type=submit value="<lt:Label res="res.label.forum.index" key="commit"/>">
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input type="button" onClick="window.location.href='regist.jsp'" value="<lt:Label res="res.label.door" key="regist"/>"></td>
        </tr>
      </form>
    </table></td>
  </tr>
</table>
<p>&nbsp;</p>
</body>
<script language="javascript">
<!--
function form1_onsubmit()
{
	errmsg = "";
	if (form1.name.value=="")
		errmsg += "<lt:Label res="res.label.door" key="input_name"/>\n"
	if (form1.pwd.value=="")
		errmsg += "<lt:Label res="res.label.door" key="input_pwd"/>\n"
	if (errmsg!="")
	{
		alert(errmsg);
		return false;
	}
}
//-->
</script>
</html>