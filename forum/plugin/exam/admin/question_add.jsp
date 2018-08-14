<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../../../inc/inc.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.plugin.exam.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.cloudwebsoft.framework.base.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="pragma" content="no-cache">
<link rel="stylesheet" href="../../../common.css">
<LINK href="../../../admin/default.css" type=text/css rel=stylesheet>
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>添加题目</title>
<body bgcolor="#FFFFFF" topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String dirCode = ParamUtil.get(request, "dirCode");

String op = ParamUtil.get(request, "op");
if (op.equals("add")) {
	QuestionMgr qm = new QuestionMgr();
	boolean re = false;
	try {
	re = qm.create(request);
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	if (re) {
		out.print(StrUtil.Alert_Redirect("添加成功！", "question_list.jsp?dirCode=" + StrUtil.UrlEncode(dirCode)));
	}
	else {
		out.print(StrUtil.Alert_Back("添加失败！"));
	}
	return;
}
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">管理题目</td>
  </tr>
</table>
<br>
<table width="98%" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr> 
    <td height=20 align="left" class="thead">题目</td>
  </tr>
  <tr>
    <td valign="top"><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0">
	<form name="form1" action="?op=add" method=post>
      <tr>
        <td width="9%" height="22" align="center">题目</td>
        <td width="91%">
		<input name="title" size=80>
		<input name="dirCode" id="dirCode" value="<%=dirCode%>" type="hidden"></td>
      </tr>
      <tr>
        <td height="22" align="center" valign="top">选项</td>
        <td align="left"><input name="opt" id="opt" size=80>
          <input name="button" type=button onClick="addOpt()" value="添加选项">
          <br>
          <input name="opt" id="opt" size=80>
          <br>
          <input name="opt" id="opt" size=80>
          <br>
          <input name="opt" id="opt" size=80>
          <br>
          <input name="opt" id="opt" size=80>
		  <div id="optDiv"></div>		  </td>
      </tr>
      <tr>
        <td height="22" align="center">答案</td>
        <td align="left"><input name="answer" size=15></td>
      </tr>
      <tr>
        <td height="22" align="center">得分</td>
        <td height="26" align="left"><input name="score" id="score" size=15></td>
      </tr>
      <tr>
        <td height="22" align="center">&nbsp;</td>
        <td height="26" align="left"><input type=submit value="确定"></td>
      </tr></form>
    </table>
    </td>
  </tr>
</table>
</td> </tr>             
      </table>                                        
       </td>                                        
     </tr>                                        
 </table>                                        
                               
</body>   
<script>
function addOpt() {
	optDiv.innerHTML += "<input name=\"opt\" id=\"opt\" size=80><BR>";
}
</script>                                     
</html>                            
  