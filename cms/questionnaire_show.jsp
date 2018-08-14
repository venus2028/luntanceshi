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
	int questionnaireNum = ParamUtil.getInt(request, "questionnaire_num",-1);
	if(questionnaireNum == -1) {
		out.print(StrUtil.Alert_Redirect("请指定需要查看的问卷编号","questionnaire_form_add1.jsp"));
	}
	String sql = "select id from questionnaire_item where questionnaire_num=" + questionnaireNum;

	QuestionnaireItemDb qid = new QuestionnaireItemDb();
	Vector vItem = qid.list(sql);
	Iterator iItem = vItem.iterator();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="default.css" rel="stylesheet" type="text/css">
<title>问卷查看</title>
<style>
a:link {
text-decoration:none;
color:#4B4B4B;
}
a:visited {
text-decoration:none;
color:#4B4B4B;
}
a:hover {
text-decoration:none;
color:#FF3300;
}
</style>
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
<table width="98%" border="0" align="center" cellpadding="6" cellspacing="1" bgcolor="#4B4B4B">
  <tr>
    <td height=20 align="left" bgcolor="#E0E0E0">问卷详情查看</td>
  </tr>
  <tr><td bgcolor="#EEEEEE" align="center">
	<table width="98%" border="0" cellpadding="6" cellspacing="1" bgcolor="#4B4B4B" style="margin:10px">
	  <tr>
	  	<td colspan="4" align="left" bgcolor="#ECE9D8">问卷&nbsp;<font color="#0000FF">[编号：<%=questionnaireNum%>]</font>&nbsp;的项目填写情况</td>
	  </tr>
	  <tr>
	  	<td width="42%" bgcolor="#FFFFEA">项目名称</td>
		<td width="10%" bgcolor="#FFFFEA">项目类型</td>
		<td width="9%" bgcolor="#FFFFEA">序号</td>
		<td width="39%" bgcolor="#FFFFEA">项目填写情况[用户选择的选项标注为<font color="#FF0000">红色</font>]</td>
	  </tr>
<%
	while(iItem.hasNext()) {
		qid = (QuestionnaireItemDb)iItem.next();
		QuestionnaireFormItemDb qfid = new QuestionnaireFormItemDb();
		qfid = qfid.getQuestionnaireFormItemDb(qid.getItemId());
%>
	  <tr>
	  	<td align="left" bgcolor="#F8F8F8"><%=qfid.getItemName()%></td>
<%
		int itemType = qfid.getItemType();
		String sItemType = "";
		if(itemType==0) {
			sItemType = "填空";
		} else if (itemType==1) {
			sItemType = "问答";
		} else if (itemType==2) {
			sItemType = "单选";
		} else if (itemType==3) {
			sItemType = "多选";
		}
%>
		<td bgcolor="#F8F8F8"><%=sItemType%></td>
		<td bgcolor="#F8F8F8"><%=qfid.getItemIndex()%></td>
		<td align="left" bgcolor="#F8F8F8">
<%
		if(qfid.getItemType()==QuestionnaireFormItemDb.ITEM_TYPE_INPUT || qfid.getItemType()==QuestionnaireFormItemDb.ITEM_TYPE_TEXTAREA) {
%>
		<%=qid.getItemValue()%>
<%
		} else if(qfid.getItemType()==QuestionnaireFormItemDb.ITEM_TYPE_RADIO_GROUP) {
			Vector v = qfid.getSubItems();
			Iterator ir = v.iterator();
			int i=0;
			while (ir.hasNext()) {
				QuestionnaireFormSubitemDb qfsd = (QuestionnaireFormSubitemDb)ir.next();
				if(qfsd.getId() == StrUtil.toInt(qid.getItemValue(), -1)) {
%>
				<font color="#FF0000"><%=i+1%>.&nbsp;<%=qfsd.getName()%></font><br />
<%
				}else{
%>
				<%=i+1%>.&nbsp;<%=qfsd.getName()%><br />
<%
				}
				i++;
			}
		} else if(qfid.getItemType()==QuestionnaireFormItemDb.ITEM_TYPE_CHECKBOX) {
			sql = "select subitem_id from questionnaire_subitem where questionnaire_num=" + questionnaireNum + " and item_id=" + qid.getItemId();
			QuestionnaireSubitemDb qsd = new QuestionnaireSubitemDb();
			Iterator iSubitem = qsd.list(sql).iterator();
			Vector v = qfid.getSubItems();
			Iterator ir = v.iterator();
			int i=0;
			boolean isFirst = true;
			while (ir.hasNext()) {
				QuestionnaireFormSubitemDb qfsd = (QuestionnaireFormSubitemDb)ir.next();
				if(isFirst) {
					if(iSubitem.hasNext()) {
						qsd = (QuestionnaireSubitemDb)iSubitem.next();
					}
					isFirst = false;
				}
				if(qfsd.getId() == qsd.getSubitemValue()) {
%>
					<font color="#FF0000"><%=i+1%>.&nbsp;<%=qfsd.getName()%></font><br />
<%
					if(iSubitem.hasNext()) {
						qsd = (QuestionnaireSubitemDb)iSubitem.next();
					}
				} else {
%>
				<%=i+1%>.&nbsp;<%=qfsd.getName()%><br />
<%
				}
				i++;
			}
		}
%>
		</td>
	  </tr>
<%
	}
%>
      <tr>
  	  	<td colspan="4" align="right" bgcolor="#ECE9D8">用户：<%=StrUtil.getNullString(qid.getUserName())%>&nbsp;&nbsp;&nbsp;&nbsp;填写日期：<%=DateUtil.format(qid.getFillDate(),"yyyy-MM")%></td>
      </tr> 
	</table>
  </td></tr> 
</table>
</body>
</html>
