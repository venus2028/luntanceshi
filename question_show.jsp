<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.module.cms.questionnaire.*"%>
<%
	int formId = 0;
	try {
		formId = ParamUtil.getInt(request, "form_id");
	} catch(ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}

	String op = ParamUtil.get(request, "op");
	if(op.equals("add")) {
		QuestionnaireItemMgr qim = new QuestionnaireItemMgr();
		try {
			if(qim.create(request)) {
				out.print(StrUtil.Alert_Redirect("提交成功，感谢您的参与！","question_show.jsp?form_id=" + formId));
				return;
			}
		} catch(ErrMsgException e) {
			out.print(StrUtil.Alert_Back(e.getMessage()));
			return;
		}
	}
	String sItemId = "";
	
	QuestionnaireFormDb qfd = new QuestionnaireFormDb();
	qfd = qfd.getQuestionnaireFormDb(formId);
	
	if (!qfd.isOpen()) {
		out.print(SkinUtil.makeErrMsg(request, "该问卷尚未开放！"));
		return;
	}
	
	String sql = "select item_id from questionnaire_form_item where form_id=" + formId + " order by item_index";
	QuestionnaireFormItemDb qfid = new QuestionnaireFormItemDb();
	Vector vItem = qfid.list(sql);
	Iterator iItem = vItem.iterator();
%>
<%@ taglib uri="/WEB-INF/tlds/DirListTag.tld" prefix="dirlist" %>
<%@ taglib uri="/WEB-INF/tlds/DocumentTag.tld" prefix="left_doc" %>
<%@ taglib uri="/WEB-INF/tlds/DocListTag.tld" prefix="dl" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>问卷：<%=qfd.getFormName()%> - <%=Global.AppName%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="template/css.css" type="text/css" rel="stylesheet" />
</head>
<body>
	<div class="content">
	<%@ include file="header.jsp"%>
<br>
<table width="100%" border="1" cellpadding="5" cellspacing="0" bordercolor="#A4EBFF" bgcolor="#A7EBFA" style="border-collapse:collapse">
<tr><td><%=StrUtil.toHtml(qfd.getDescription())%></td>
</table>
<table width="100%" border="1" cellpadding="5" cellspacing="0" bordercolor="#A4EBFF" bgcolor="#FFFFFF" style="border-collapse:collapse">
  <form action="question_show.jsp?op=add" method="post">
<%
while(iItem.hasNext()) {
		qfid = (QuestionnaireFormItemDb)iItem.next();
		int itemId = qfid.getItemId();
		if(sItemId.equals("")) {
			sItemId = "" + itemId;
		} else {
			sItemId += ":" + itemId;
		}
%>
    <tr>
      <td>
	  <%=qfid.getItemName()%><font color="#FF0000"><%=qfid.getCheckedType()==QuestionnaireFormItemDb.MUST_BE_FILLED ? "*" : ""%></font>
	  </td>
      <td align="left"><%
		int itemType = qfid.getItemType();
		if(itemType == QuestionnaireFormItemDb.ITEM_TYPE_INPUT) {
%>
      <input id="item<%=itemId%>" name="item<%=itemId%>" />
      <%
		} else if(itemType == QuestionnaireFormItemDb.ITEM_TYPE_TEXTAREA) {
%>
      <textarea name="item<%=itemId%>" style="width:360px;height:150px"></textarea>
      <%
		} else if(itemType == QuestionnaireFormItemDb.ITEM_TYPE_RADIO_GROUP) {
			Iterator ir = qfid.getSubItems().iterator();
	  int i=0;
	  while (ir.hasNext()) {
		QuestionnaireFormSubitemDb qfsd = (QuestionnaireFormSubitemDb)ir.next();
%>
        <input type="radio" name="item<%=itemId%>" value="<%=qfsd.getId()%>" />
        <%=qfsd.getName()%>
      <%
	  	i++;
	  }
	}else if (itemType == QuestionnaireFormItemDb.ITEM_TYPE_CHECKBOX) {
			Iterator ir = qfid.getSubItems().iterator();
	  int i=0;
	  while (ir.hasNext()) {
		QuestionnaireFormSubitemDb qfsd = (QuestionnaireFormSubitemDb)ir.next();
%>
        <input type="checkbox" name="item<%=itemId%>" value="<%=qfsd.getId()%>" />
        <%=qfsd.getName()%>
      <%
	  	i++;
	  }
	}
}
%></td>
    </tr>
    <tr>
      <td colspan="2" align="center"><input type="hidden" name="sItemId" value="<%=sItemId%>" />
          <input type="hidden" name="form_id" value="<%=formId%>" />          <input id="submit" type="submit" name="Submit" value="问卷填写完毕，提交" style="background-color:#CCCCCC;margin:0px;padding:0px; height:24px; font-family:'宋体';font-size:12px" /></td>
      </tr>
  </form>
</table>
	<div class="bottom">
	<script src='js.jsp?var=ad&dirCode=root&type=footer'></script><script src='/cwbbs/js.jsp?var=ad&dirCode=root&type=couple'></script> <script src='/cwbbs/js.jsp?var=ad&dirCode=root&type=float'></script>
	</div>
	</div>
</div>
<%@ include file="footer.jsp"%>
</body>
</html>

