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
int itemId = ParamUtil.getInt(request, "item_id",-1);
if(itemId == -1) {
	out.print(StrUtil.Alert_Back("请指定需要查看的问卷项"));
}
QuestionnaireItemDb qid = new QuestionnaireItemDb();
qid = qid.getQuestionnaireItemDb(itemId);

QuestionnaireFormItemDb qfid = new QuestionnaireFormItemDb();
qfid = qfid.getQuestionnaireFormItemDb(itemId);

QuestionnaireFormDb qfd = new QuestionnaireFormDb();
qfd = qfd.getQuestionnaireFormDb(qfid.getFormId());

String sql = "select id from questionnaire_item where item_id=" + itemId + " order by fill_date asc";
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
	  	<td colspan="5" bgcolor="#ECE9D8">问卷&nbsp;<font color="#0000FF"><a href="questionnaire_form_add2.jsp?form_id=<%=qfid.getFormId()%>"><%=qfd.getFormName()%></a></font>&nbsp;-&nbsp;<%=qfid.getItemName()%>的调查情况</td>
	  </tr>
	  <tr>
	  	<td width="10%" bgcolor="#FFFFEA">问卷编号</td>
		<td width="17%" bgcolor="#FFFFEA">参与用户</td>
		<td width="11%" bgcolor="#FFFFEA">填写日期</td>
		<td width="46%" bgcolor="#FFFFEA">调查结果</td>
		<td width="16%" bgcolor="#FFFFEA">操作</td>
	  </tr>
<%
	int currentQuestionnaireNum = -1;
	boolean isFirst = true;
	QuestionnaireFormSubitemDb qfsd = new QuestionnaireFormSubitemDb();
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
		<td bgcolor="#F8F8F8"><%=qid.getUserName()%></td>
		<td bgcolor="#F8F8F8"><%=DateUtil.format(qid.getFillDate(),"yyyy-MM-dd")%></td>
		<td align="left" bgcolor="#F8F8F8">
		<%
		if (qfid.getItemType()==QuestionnaireFormItemDb.ITEM_TYPE_CHECKBOX) {
			QuestionnaireSubitemDb qsd = new QuestionnaireSubitemDb();
			Iterator ir = qsd.getSubitems(questionnaireNum).iterator();
			while (ir.hasNext()) {
				qsd = (QuestionnaireSubitemDb)ir.next();
		%>
				<%=qfsd.getQuestionnaireFormSubitemDb(qsd.getSubitemValue()).getName()%><br>
		<%	
			}
		}else if (qfid.getItemType()==QuestionnaireFormItemDb.ITEM_TYPE_RADIO_GROUP) {
			qfsd = qfsd.getQuestionnaireFormSubitemDb(StrUtil.toInt(qid.getItemValue()));
		%>
			<%=qfsd.getName()%>
		<%}else{%>
		<%=qid.getItemValue()%>
		<%}%>
		</td>
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
