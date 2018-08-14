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

int formId = ParamUtil.getInt(request, "form_id");
int itemId = ParamUtil.getInt(request, "item_id");
String op = ParamUtil.get(request, "op");

QuestionnaireFormDb qfd = new QuestionnaireFormDb();
qfd = qfd.getQuestionnaireFormDb(formId);
QuestionnaireFormItemDb qfid = new QuestionnaireFormItemDb();
qfid = qfid.getQuestionnaireFormItemDb(itemId);
if(op.equals("edit")) {
	try {
		QuestionnaireFormItemMgr qfim = new QuestionnaireFormItemMgr();
		boolean re = qfim.save(request);
		if(re) {
			out.print(StrUtil.Alert_Redirect("问卷项目修改成功","questionnaire_form_edit2.jsp?item_id=" + itemId + "&form_id=" + formId));
			return;
		}
	} catch(ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}

Vector v = qfid.getSubItems();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="default.css" rel="stylesheet" type="text/css">
<title>问卷表单修改</title>
<script>
var count = <%=(v.size()==0?1:v.size())%>;
function checkItemType() {
	if(document.getElementById('item_type').value==2 || document.getElementById('item_type').value==3) {
		for(var i=0; i<=count; i++) {
			var optionId = "option" + i;
			var option = document.getElementById(optionId);
			if(option==null)continue;
			option.disabled = "";
			option.style.backgroundColor = "";
			var aId = "a" + i;
			var a = document.getElementById(aId);
			if(a==null)continue;
			a.disabled = "";
			a.href = "javascript:delOption(" + i + ")";
		}
		var itemAdd = document.getElementById('item_add')
		if (itemAdd!=null)
			itemAdd.disabled = "";
	} else {
		for(var i=0; i<=count; i++) {
			var optionId = "option" + i;
			var option = document.getElementById(optionId);
			if(option==null)continue;
			option.disabled = "disabled";
			option.style.backgroundColor = "#999999";
			var aId = "a" + i;
			var a = document.getElementById(aId);
			if(a==null)continue;
			a.disabled = "disabled";
			a.href = "#";
		}
		document.getElementById('item_add').disabled = "disabled";
	}
}
function addOption() {
	var option = document.createElement("input");
	option.id = "option" + count;
	option.name = "option" + count;
	option.type = "text";
	option.style.width = "200px"
	document.getElementById('options').appendChild(option);
	var a = document.createElement("a");
	a.id = "a" + count;
	a.href = "javascript:delOption(" + count + ")";
	a.innerHTML = "&nbsp;[删除]";
	document.getElementById('options').appendChild(a);
	var br = document.createElement("<br />");
	br.id = "br" + count;
	document.getElementById('options').appendChild(br);
	count++;
}
function delOption(id) {
	var optionId = "option" + id;
	var aId = "a" + id;
	var brId = "br" + id;
	var option = document.getElementById(optionId);
	var a = document.getElementById(aId);
	var br = document.getElementById(brId);
	document.getElementById('options').removeChild(option);
	document.getElementById('options').removeChild(a);
	document.getElementById('options').removeChild(br);
}
function submitAddItemForm() {
	var itemOptions = document.getElementById('item_options');
	for(var i=0; i<=count; i++) {
		var optionId = "option" + i;
		var option = document.getElementById(optionId);
		if(option==null || option.value=="")continue;
		if(itemOptions.value == "") {
			itemOptions.value += option.value;
		} else {
			itemOptions.value += ":,:" + option.value;
		}
	}
	addItemForm.submit();
}
</script>
</head>
<body>
<table cellspacing="0" cellpadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">问卷项目管理&nbsp;-&nbsp;<a href="questionnaire_form_add2.jsp?form_id=<%=qfd.getFormId()%>"><%=qfd.getFormName()%></a></td>
    </tr>
  </tbody>
</table>
<br />
<br>
<form id="addItemForm" name="addItemForm" action="questionnaire_form_edit2.jsp" method="post">
<table width="60%" border="0" align="center" cellpadding="6" cellspacing="1" bgcolor="#4B4B4B" style="margin:10px">
    
    <tr>
      <td id="form_title" colspan="2" align="left" bgcolor="#ECE9D8">编辑项目</td>
    </tr>
    <tr>
      <td align="right" bgcolor="#F8F8F8">名称：</td>
      <td align="left" bgcolor="#F8F8F8"><input name="item_name" style="width:200px" value="<%=qfid.getItemName()%>" />
	<input id="op" name="op" type="hidden" value="edit" />
    <input id="item_id" name="item_id" type="hidden" value="<%=itemId%>" />
    <input name="form_id" type="hidden" value="<%=formId%>" /></td>
    </tr>
    <tr>
      <td align="right" bgcolor="#F8F8F8">类型：</td>
      <td align="left" bgcolor="#F8F8F8"><select id="item_type" name="item_type" onchange="checkItemType()">
        <option value="0">填空</option>
        <option value="1">问答</option>
        <option value="2">单选</option>
        <option value="3">多选</option>
      </select>
      </td>
    </tr>
    <tr>
      <td align="right" bgcolor="#F8F8F8">是否必填项：</td>
      <td align="left" bgcolor="#F8F8F8"><select name="checked_type">
        <option value="0">是</option>
        <option value="1">否</option>
      </select>
	  <script>
	  addItemForm.item_type.value = "<%=qfid.getItemType()%>";
	  addItemForm.checked_type.value = "<%=qfid.getCheckedType()%>";
	  </script>
      </td>
    </tr>
    <tr>
      <td align="right" bgcolor="#F8F8F8">排序号：</td>
      <td align="left" bgcolor="#F8F8F8"><input name="item_index" title="项目在问卷中按索引升序排列" value="<%=qfid.getItemIndex()%>" size="3" /></td>
    </tr>
    <tr>
      <td align="right" bgcolor="#F8F8F8">选项：</td>
      <td align="left" bgcolor="#F8F8F8" id="options">
	  	<input type="hidden" id="item_options" name="item_options" />
	  <%
	  int itemType = qfid.getItemType();
	  String disabled = "disabled";
	  if (itemType==QuestionnaireFormItemDb.ITEM_TYPE_RADIO_GROUP || itemType==QuestionnaireFormItemDb.ITEM_TYPE_CHECKBOX)
	  	disabled = "";
	  if (v.size()==0) {
	  %>
        <input <%=disabled%> id="option0" name="option0" style="width:200px" />	  
	  <%}
	  if (itemType==QuestionnaireFormItemDb.ITEM_TYPE_RADIO_GROUP || itemType==QuestionnaireFormItemDb.ITEM_TYPE_CHECKBOX) {
	  	Iterator ir = v.iterator();
		int k = 0;
		while (ir.hasNext()) {
			QuestionnaireFormSubitemDb qfsd = (QuestionnaireFormSubitemDb)ir.next();
		%>
        <input id="option<%=k%>" name="option<%=k%>" style="width:200px" value="<%=StrUtil.toHtml(qfsd.getName())%>" /><a id="a<%=k%>" href="javascript:delOption(<%=k%>)">&nbsp;[删除]</a><BR id="br<%=k%>" /> 
		<%
			k++;
		}%>
	  <%}%>
      <input name="button2" type="button" <%=disabled%> id="item_add" onclick="addOption()" value="增加选项" />
        <br />
      </td>
    <tr>
      <td colspan="2" align="center" bgcolor="#F8F8F8"><input name="button2" type="button" id="add_or_edit" onclick="submitAddItemForm()" value="确定" /></td>
    </tr>
</table>
</form>
</body>
</html>
