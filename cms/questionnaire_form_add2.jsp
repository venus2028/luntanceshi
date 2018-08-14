<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.module.cms.questionnaire.*"%>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, "admin")) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

int formId = ParamUtil.getInt(request, "form_id");
String op = ParamUtil.get(request, "op");

QuestionnaireFormDb qfd = new QuestionnaireFormDb();
qfd = qfd.getQuestionnaireFormDb(formId);
QuestionnaireFormItemDb qfid = new QuestionnaireFormItemDb();

if(op.equals("add")) {
	try {
		QuestionnaireFormItemMgr qfim = new QuestionnaireFormItemMgr();
		boolean re = qfim.create(request);//返回的item_id
		if(re) {
			out.print(StrUtil.Alert_Redirect("问卷项目添加成功","questionnaire_form_add2.jsp?form_id=" + formId));
			return;
		}
	} catch(ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}
if(op.equals("edit")) {
	try {
		QuestionnaireFormItemMgr qfim = new QuestionnaireFormItemMgr();
		boolean re = qfim.save(request);
		if(re) {
			out.print(StrUtil.Alert_Redirect("问卷项目修改成功","questionnaire_form_add2.jsp?form_id=" + formId));
			return;
		}
	} catch(ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}
if(op.equals("del")) {
	try {
		QuestionnaireFormItemMgr qfim = new QuestionnaireFormItemMgr();
		boolean re = qfim.del(request);
		if(re) {
			out.print(StrUtil.Alert_Redirect("问卷项目删除成功","questionnaire_form_add2.jsp?form_id=" + formId));
			return;
		}
	} catch(ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="default.css" rel="stylesheet" type="text/css">
<title>问卷表单生成第二步</title>
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
<script>
var count = 1;
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
		document.getElementById('item_add').disabled = "";
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
	a.style.color = "red";
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
function editItem(itemName,itemId) {
	document.getElementById('form_title').innerText = "修改项目：“" + itemName + "”";
	document.getElementById('form_title').style.color = "#FF0000";
	document.getElementById('add_or_edit').value = "修改问卷项目";
	document.getElementById('add_or_edit').style.color = "#0000FF";
	document.getElementById('op').value = "edit";
	document.getElementById('item_id').value = itemId;
}
function delItem(itemId) {
	if(confirm("确定删除该项目？")) {
		document.getElementById('op').value = "del";
		document.getElementById('item_id').value = itemId;
		addItemForm.submit();
	}
}
</script>
</head>
<body>
<table cellspacing="0" cellpadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">问卷项目管理</td>
    </tr>
  </tbody>
</table>
<br />
<table width="98%" border="0" cellpadding="6" cellspacing="1" bgcolor="#4B4B4B" style="margin:10px">
  <tr>
    <td colspan="6" align="left" bgcolor="#ECE9D8"><font color="#0000FF"><%=qfd.getFormName()%></font>&nbsp;[<a href="questionnaire_list.jsp?form_id=<%=formId%>">调查情况</a>]</td>
  </tr>
  <tr>
    <td bgcolor="#FFFFEA">项目名称</td>
    <td bgcolor="#FFFFEA">项目类型</td>
    <td bgcolor="#FFFFEA">是否必须填写</td>
    <td bgcolor="#FFFFEA">序号</td>
    <td bgcolor="#FFFFEA">项目选项/累计选择次数</td>
    <td bgcolor="#FFFFEA">操作</td>
  </tr>
<%
	String sql = "select item_id from questionnaire_form_item where form_id=" + formId + " order by item_index";
	Vector vItem = qfid.list(sql);
	Iterator iItem = vItem.iterator();  
	while(iItem.hasNext()) {
		qfid = (QuestionnaireFormItemDb)iItem.next();
%>
  <tr>
    <td bgcolor="#F8F8F8"><%=qfid.getItemName()%></td>
    <%
		int itemType = qfid.getItemType();
		String sItemType = "";
		if(itemType==0) {
			sItemType = "文本域";
		} else if (itemType==1) {
			sItemType = "文本区域";
		} else if (itemType==2) {
			sItemType = "单选按钮组";
		} else if (itemType==3) {
			sItemType = "复选框";
		}
%>
    <td bgcolor="#F8F8F8"><%=sItemType%></td>
    <td bgcolor="#F8F8F8"><%=qfid.getCheckedType()==0? "是" : "否"%></td>
    <td bgcolor="#F8F8F8"><%=qfid.getItemIndex()%></td>
    <td bgcolor="#F8F8F8"><%
if(qfid.getItemType()==QuestionnaireFormItemDb.ITEM_TYPE_INPUT || qfid.getItemType()==QuestionnaireFormItemDb.ITEM_TYPE_TEXTAREA) {
%>	
<%
} else {
		Vector itemOptions = qfid.getSubItems();
		QuestionnaireStatistics qs = new QuestionnaireStatistics();
		int [] itemValueStatistics = qs.itemValueStatistics(qfid.getItemId());
		for(int i=0;i<itemOptions.size();i++) {
%>
		<%=i+1%>.&nbsp;<%=((QuestionnaireFormSubitemDb)itemOptions.elementAt(i)).getName()%>&nbsp;<font color="#FF0000">[<%=itemValueStatistics[i]%>]</font><br />
<%}%>
    </td>
    <%
	}
%>
    <td bgcolor="#F8F8F8"><a href="questionnaire_form_edit2.jsp?form_id=<%=formId%>&item_id=<%=qfid.getItemId()%>">[修改]</a>&nbsp;<a href="javascript:delItem(<%=qfid.getItemId()%>)">[删除]</a>&nbsp;[<a href="questionnaire_item_answer.jsp?form_id=<%=formId%>&item_id=<%=qfid.getItemId()%>" target="_blank">查看</a>]</td>
  </tr>
  <%
	}
%>
  <tr>
    <td colspan="6" align="center" bgcolor="#ECE9D8">&nbsp;</td>
  </tr>
</table>
<br>
<form id="addItemForm" name="addItemForm" action="questionnaire_form_add2.jsp" method="post">
<table border="0" align="center" cellpadding="6" cellspacing="1" bgcolor="#4B4B4B" style="margin:10px">
    
    <tr>
      <td id="form_title" colspan="2" align="left" bgcolor="#ECE9D8">添加新项目</td>
    </tr>
    <tr>
      <td align="right" bgcolor="#F8F8F8">名称：</td>
      <td align="left" bgcolor="#F8F8F8"><input name="item_name" style="width:200px" />
	<input id="op" name="op" type="hidden" value="add" />
    <input id="item_id" name="item_id" type="hidden" />
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
      </td>
    </tr>
    <tr>
      <td align="right" bgcolor="#F8F8F8">排序号：</td>
      <td align="left" bgcolor="#F8F8F8"><input name="item_index" title="项目在问卷中按索引升序排列" size="3" value="0" /></td>
    </tr>
    <tr>
      <td align="right" bgcolor="#F8F8F8">选项：</td>
      <td align="left" bgcolor="#F8F8F8" id="options"><input type="hidden" id="item_options" name="item_options" />
          <input disabled="disabled" id="option0" name="option0" style="width:200px; background-color:#999999" />
          <input name="button2" type="button" disabled="disabled" id="item_add" style="height:22px;padding-top:1px;color:#4B4B4B;font-family:'宋体';font-size:12px" onclick="addOption()" value="增加选项" />
        <br />
      </td>
    <tr>
      <td colspan="2" align="center" bgcolor="#F8F8F8"><input name="button2" type="button" id="add_or_edit" onclick="submitAddItemForm()" value="确定" /></td>
    </tr>
</table>
</form>
</body>
</html>
