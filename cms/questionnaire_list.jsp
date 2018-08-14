<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.module.cms.questionnaire.*"%>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<%
	int formId = ParamUtil.getInt(request, "form_id",-1);
	if(formId == -1) {
		out.print(StrUtil.Alert_Redirect("请指定需要查看的问卷","questionnaire_form_add1.jsp"));
	}
	
	QuestionnaireFormDb qfd = new QuestionnaireFormDb();
	qfd = qfd.getQuestionnaireFormDb(formId);
	
	String sql = "select id from questionnaire_item where form_id=" + formId;
	QuestionnaireItemDb qid = new QuestionnaireItemDb();
	Vector vQuestionnaire = qid.list(sql);
	Iterator iQuestionnaire = vQuestionnaire.iterator();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="default.css" rel="stylesheet" type="text/css">
<title>问卷列表</title>
</head>
<body style="color:#4B4B4B;font-family:'宋体';font-size:12px">
<table cellspacing="0" cellpadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">问卷调查</td>
    </tr>
  </tbody>
</table>
<br>
<table width="98%" border="0" align="center" cellpadding="6" cellspacing="1" class="frame_gray">
  <tr>
    <td height=20 align="left" class="thead">问卷管理</td>
  </tr>
  <tr><td align="center">
  <table width="98%" border="0" cellpadding="6" cellspacing="1" bgcolor="#4B4B4B" style="margin:10px">
  	  <tr>
	  	<td colspan="4" bgcolor="#ECE9D8">问卷&nbsp;<font color="#0000FF"><a href="questionnaire_form_add2.jsp?form_id=<%=formId%>"><%=qfd.getFormName()%></a></font>&nbsp;的调查情况列表</td>
	  </tr>
	  <tr>
	  	<td width="22%" bgcolor="#FFFFEA">问卷编号</td>
		<td width="27%" bgcolor="#FFFFEA">填写日期</td>
		<td width="29%" bgcolor="#FFFFEA">参与用户</td>
		<td width="22%" bgcolor="#FFFFEA">操作</td>
	  </tr>
<%
	int currentQuestionnaireNum = -1;
	boolean isFirst = true;
	while(iQuestionnaire.hasNext()) {
		qid = (QuestionnaireItemDb)iQuestionnaire.next();
		int questionnaireNum = qid.getQuestionnaireNum();
		if(isFirst) {
			currentQuestionnaireNum = questionnaireNum;
			isFirst = false;
		} else {
			if(currentQuestionnaireNum == questionnaireNum) {
				continue;
			} else {
				currentQuestionnaireNum = questionnaireNum;
			}
		}
%>
	  <tr>
	  	<td bgcolor="#F8F8F8"><%=questionnaireNum%></td>
		<td bgcolor="#F8F8F8"><%=DateUtil.format(qid.getFillDate(),"yyyy-MM-dd")%></td>
		<td bgcolor="#F8F8F8"><%=qid.getUserName()%></td>
		<td bgcolor="#F8F8F8"><a href="questionnaire_show.jsp?questionnaire_num=<%=questionnaireNum%>">[查看问卷详情]</a></td>
	  </tr>
<%
	}
%>
  </table>
  </td></tr>
</table>
</body>
</html>
