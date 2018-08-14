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

	QuestionnaireFormDb qfd = new QuestionnaireFormDb();
	Vector vForm = qfd.list();
	Iterator iForm = vForm.iterator();
	
	String op = ParamUtil.get(request, "op");
	if(op.equals("add")) {
		try {
			QuestionnaireFormMgr qfm = new QuestionnaireFormMgr();
			int flag = qfm.create(request);//返回的form_id
			if(flag != -1) {
				out.print(StrUtil.Alert_Redirect("问卷添加成功","questionnaire_form_add1.jsp"));
				return;
			}
		} catch(ErrMsgException e) {
			out.print(StrUtil.Alert_Back(e.getMessage()));
			return;
		}
	}
	if(op.equals("edit")) {
		try {
			QuestionnaireFormMgr qfm = new QuestionnaireFormMgr();
			boolean re = qfm.save(request);
			if(re) {
				out.print(StrUtil.Alert_Redirect("问卷修改成功","questionnaire_form_add1.jsp"));
				return;
			}
		} catch(ErrMsgException e) {
			out.print(StrUtil.Alert_Back(e.getMessage()));
			return;
		}
	}
	if(op.equals("del")) {
		try {
			QuestionnaireFormMgr qfm = new QuestionnaireFormMgr();
			boolean re = qfm.del(request);
			if(re) {
				out.print(StrUtil.Alert_Redirect("问卷删除成功","questionnaire_form_add1.jsp"));
				return;
			}
		} catch(ErrMsgException e) {
			out.print(StrUtil.Alert_Back(e.getMessage()));
			return;
		}
	}	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>问卷表单生成第一步</title>
<link href="default.css" rel="stylesheet" type="text/css">
<script>
function submitform() {
	form.submit();
}
function editForm(formName,formId,formName,description,isOpen) {
	document.getElementById('form_title').innerText = "修改问卷：“" + formName + "”";
	document.getElementById('add_or_edit').value = "修改问卷";
	document.getElementById('op').value = "edit";
	document.getElementById('form_id').value = formId;
	document.getElementById("form_name").value = formName;
	document.getElementById("description").value = description;
	document.getElementById("isOpen").value = isOpen;
}
function delForm(formId) {
	if(confirm("确定删除该问卷？")) {
		document.getElementById('op').value = "del";
		document.getElementById('form_id').value = formId;
		form.submit();
	}
}
</script>
</head>
<body>
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
  <tr><td align="center"><table width="98%" border="0" cellpadding="6" cellspacing="1" bgcolor="#4B4B4B" style="margin:10px">
    <tr>
      <td colspan="6" bgcolor="#ECE9D8">问卷列表</td>
    </tr>
    <tr>
      <td width="5%" bgcolor="#FFFFEA">编号</td>
      <td width="17%" bgcolor="#FFFFEA">问卷名称</td>
      <td width="33%" bgcolor="#FFFFEA">问卷描述</td>
      <td width="5%" align="center" bgcolor="#FFFFEA">启用</td>
      <td width="10%" bgcolor="#FFFFEA">生成日期</td>
      <td width="30%" bgcolor="#FFFFEA">操作</td>
    </tr>
    <%
	while(iForm.hasNext()) {
		qfd = (QuestionnaireFormDb)iForm.next();
%>
    <tr>
      <td align="left" bgcolor="#F8F8F8"><%=qfd.getFormId()%></td>
      <td align="left" bgcolor="#F8F8F8"><%=qfd.getFormName()%></td>
      <td bgcolor="#F8F8F8" align="left" title="<%=qfd.getDescription()%>"><%=StrUtil.getLeft(qfd.getDescription(),60)%></td>
      <td bgcolor="#F8F8F8" align="center" title="<%=qfd.getDescription()%>"><%=qfd.isOpen()?"是":"否"%></td>
      <td bgcolor="#F8F8F8"><%=StrUtil.FormatDate(qfd.getCreateDate(),"yyyy-MM-dd")%></td>
      <td bgcolor="#F8F8F8"><a href="javascript:editForm('<%=qfd.getFormName()%>',<%=qfd.getFormId()%>,'<%=qfd.getFormName()%>','<%=qfd.getDescription()%>','<%=qfd.isOpen()?1:0%>')">[编辑]</a>&nbsp;<a href="questionnaire_form_add2.jsp?form_id=<%=qfd.getFormId()%>">[项目管理]</a>&nbsp;<a href="javascript:delForm(<%=qfd.getFormId()%>)">[删除]</a><a href="questionnaire_result.jsp?form_id=<%=qfd.getFormId()%>" target="_blank">[调查情况]</a></td>
    </tr>
    <%
	}
%>
  </table></td></tr>
  <tr><td align="center">
  <table border="0" cellpadding="6" cellspacing="1" class="frame_gray" style="margin:10px">
  	  <tr>
	    <td colspan="2" align="left" class="thead" id="form_title">添加新问卷</td>
	  </tr>
	<form id="form" action="questionnaire_form_add1.jsp" method="post">
		<input id="op" name="op" type="hidden" value="add" />
		<input id="form_id" name="form_id" type="hidden" /><!--for save&del-->
	  <tr>
		<td bgcolor="#F8F8F8">问卷名称：</td>
		<td bgcolor="#F8F8F8"><input name="form_name" type="text" style="width:300px" /></td>
	  </tr>
	  <tr>
	    <td bgcolor="#F8F8F8">是否开放：</td>
	    <td align="left" bgcolor="#F8F8F8">
		<select name="isOpen">
		<option value="1" selected>是</option>
		<option value="0">否</option>
		</select>		</td>
	    </tr>
	  <tr>
		<td bgcolor="#F8F8F8">问卷描述：</td>
		<td bgcolor="#F8F8F8"><textarea name="description" style="width:300px;height:100px;"></textarea></td>
	  </tr>
	  <tr>
		<td colspan="2" align="center" bgcolor="#F8F8F8"><input id="add_or_edit" onclick="submitform()" type="button" value="下一步" /></td>
	  </tr>
	</form>
	</table>
  </td></tr>
</table>
</body>
</html>
