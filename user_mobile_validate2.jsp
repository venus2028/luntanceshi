<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.sms.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.person.UserSet"%>
<%
String skinPath = SkinMgr.getSkinPath(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=Global.AppName%> - 验证手机2</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="forum/<%=skinPath%>/css.css" rel="stylesheet" type="text/css">
<script>
function VerifyInput() {
	if (form1.validateCode.value=="") {
		alert("请输入确认码！");
		return false;
	}
}
</script>
</head>
<body>
<div id="wrapper">
<%@ include file="forum/inc/header.jsp"%>
<div id="main">
<jsp:useBean id="randNumUtil" scope="page" class="com.redmoon.forum.sms.RandomNumManager" />
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege" />
<%
if (!privilege.isUserLogin(request)) {
	out.print(StrUtil.Alert_Redirect("请先登录！", "forum/index.jsp"));
	return;
}
%>
<%
String mobile = ParamUtil.get(request, "mobile");
/*
if (!msgUtil.isValidMobile(mobile)) {
	out.print(StrUtil.Alert_Back("手机号非法，请注意只能使用中国移动的手机号，手机号必须为11位数字！"));
	return;
}
*/

String op = ParamUtil.get(request, "op");
if (op.equals("confirm")) {
	String vcode = ParamUtil.get(request, "validateCode");
	String uName = privilege.getUser(request);
	String mvcode = StrUtil.getNullStr((String)session.getAttribute("mobileValidateCode"));
	if (mvcode.equals(vcode)) {
		UserDb user = new UserDb();
		user = user.getUser(privilege.getUser(request));
		user.setMobile(mobile);
		user.setMobileValid(true);
		boolean re = user.save();
		if (re) {
			// System.out.println("user_mobile_validate2.jsp mobile=" + mvcode);
			String smsmsg = "验证通过！";
			out.print(StrUtil.Alert_Redirect(smsmsg, "index.jsp"));
			return;
		}
	}
	else
		out.print(StrUtil.Alert("对不起，您输入的确认码错误！"));
}
else {
	String randStr = "";
	if (randStr.equals("")) {
		randStr = randNumUtil.getRandNumStr(5);
		// 保存确认码，以免多次发送的确认码不一致，引起用户混淆
		session.setAttribute("mobileValidateCode", randStr);
	}
	// 取得用户发送的次数
	Integer countObj = (Integer)session.getAttribute("msgSendCount");
	int count = 0;
	if (countObj!=null)
		count = countObj.intValue();
	if (count>2) {
		out.print(StrUtil.Alert("对不起，您发送的次数太多了，请关闭当前窗口，登录后重新确认手机号码！"));
	}
	else {
		String msgText = Global.AppName + " 确认码：" + randStr;
		boolean re = SMSFactory.getMsgUtil().send(mobile, msgText, "admin");
		if (re) {
			count++;
			session.setAttribute("msgSendCount", new Integer(count));
		}
		else {
			out.print(StrUtil.Alert("确认码发送失败！请重新发送！"));
		}
	}
}
%>
<br>
<br>
<br>
<form method="POST" action="user_mobile_validate2.jsp?op=confirm" id="form1" name="form1" onSubmit="return VerifyInput()">
  <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tableCommon60">
  <thead>
  <tr>
    <td align="center" valign="top">请在此输入收到的确认码</td>
  </tr>
  </thead>
  <tr>
    <td align="center" valign="top">请在此填写您收到的确认码
      <input name="validateCode" type="text" class="singleboarder" size="20" />
      <input type="hidden" name="mobile" value="<%=mobile%>" />
        <font color="#FF0000"> *</font></td>
  </tr>
  <tr>
    <td height="25" align="center" valign="middle"><a href="#" onclick="location.reload()">如果您未收到请点击此处再次发送确认码</a></td>
  </tr>
  <tr>
    <td height="25" align="center" valign="middle"><input name=Write type=submit class="singleboarder" value=" 提交 " />
      &nbsp;&nbsp;&nbsp;&nbsp;
      <input name=reset type=reset class="singleboarder" value="重填" /></td>
  </tr>
</table>
</form>
<br>
<br>
<br>
<br>
<br>
</div>
<%@ include file="forum/inc/footer.jsp"%>
</div>
</body>
</html>