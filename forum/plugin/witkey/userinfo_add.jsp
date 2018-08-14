<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.plugin.witkey.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isUserLogin(request)) {
	response.sendRedirect("../../../door.jsp");
	return;
}

String userName = ParamUtil.get(request, "userName");
if (userName.equals("")) {
	out.print(SkinUtil.makeErrMsg(request, "缺少用户名！"));
	return;
}

String msgId = ParamUtil.get(request, "msgId");
if (msgId.equals("")) {
	out.print(SkinUtil.makeErrMsg(request, "缺少文章编号！"));
	return;
}

WitkeyDb wd = new WitkeyDb();

Timestamp ts = new Timestamp(System.currentTimeMillis());
java.util.Date date = DateUtil.parse(ts.toString(), "yyyy-MM-dd");

wd = wd.getWitkeyDb(Long.parseLong(msgId));
if (date.getTime() > Long.parseLong(wd.getEndDate())) {
	out.print(SkinUtil.makeErrMsg(request, "该威客项目已经过期！"));
	return;
}

String boardcode = ParamUtil.get(request, "boardCode");

Leaf curleaf = new Leaf();
curleaf = curleaf.getLeaf(boardcode);

// 取得皮肤路径
String skinPath = SkinMgr.getSkinPath(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<LINK href="../../<%=skinPath%>/css.css" type=text/css rel=stylesheet>
<title>我要报名 - <%=Global.AppName%></title>
</head>
<body>
<div id="wrapper">
<%@ include file="../../inc/header.jsp"%>
<div id="main">
<%@ include file="../../inc/position.jsp"%>
<form action="witkey_do.jsp?op=addUserInfo" method="post">
<table class="tableCommon60">
        <thead>
          <tr>
            <td height="26" colSpan="2" align="center">填写个人资料</td>
          </tr>
		</thead>
          <tr>
            <td width="149" height="30" align="right">真实姓名：</td>
            <td width="545" height="30"><input name="realName" id="realName" size="15"></td>
          </tr>
          <tr>
            <td height="30" align="right">所在城市：</td>
            <td height="30"><input name="city" id="city" size="15"></td>
          </tr>
          <tr>
            <td height="30" align="right">联系电话：</td>
            <td height="30"><input name="tel" id="tel" size="15"></td>
          </tr>
          <tr>
            <td height="30" align="right">OICQ号码：</td>
            <td height="30"><input name="oicq" id="oicq" size="15"></td>
          </tr>
          <tr>
            <td height="98" align="right">其他联系方式：</td>
            <td height="98"><textarea name="otherContact" cols="35" rows="5" id="otherContact"></textarea></td>
          </tr>
          <tr align="center">
            <td height="30" colspan="2"><input type="submit" name="Submit" value=" 提 交 ">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <input type="reset" name="Submit" value=" 重 置 ">
          <input type="hidden" name="msgId" value="<%=msgId%>"></td>
          </tr>
        </tbody>
    </table>
</form>
</div>
<%@ include file="../../inc/footer.jsp"%>
</div>
</body>
</html>
