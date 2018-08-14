<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="java.util.*,
				 java.text.*,
				 cn.js.fan.util.*,
				 cn.js.fan.cache.jcs.*,
				 cn.js.fan.web.*,
				 cn.js.fan.module.cms.job.*,
				 cn.js.fan.module.cms.kernel.*,
				 com.cloudwebsoft.framework.base.*"
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="default.css" rel="stylesheet" type="text/css">
<script src="../inc/common.js"></script>
<script>
function findObj(theObj, theDoc)
{
  var p, i, foundObj;
  
  if(!theDoc) theDoc = document;
  if( (p = theObj.indexOf("?")) > 0 && parent.frames.length)
  {
    theDoc = parent.frames[theObj.substring(p+1)].document;
    theObj = theObj.substring(0,p);
  }
  if(!(foundObj = theDoc[theObj]) && theDoc.all) foundObj = theDoc.all[theObj];
  for (i=0; !foundObj && i < theDoc.forms.length; i++) 
    foundObj = theDoc.forms[i][theObj];
  for(i=0; !foundObj && theDoc.layers && i < theDoc.layers.length; i++) 
    foundObj = findObj(theObj,theDoc.layers[i].document);
  if(!foundObj && document.getElementById) foundObj = document.getElementById(theObj);
  
  return foundObj;
}

function SelectDateTime(objName) {
	var dt = showModalDialog("../util/calendar/time.jsp", "" ,"dialogWidth:266px;dialogHeight:125px;status:no;help:no;");
	if (dt!=null)
		findObj(objName).value = dt;
}

function form1_onsubmit() {
	var t = form1.time.value;
	var ary = t.split(":");
	var weekDay = getCheckboxValue("weekDay");
	var dayOfMonth = form1.month_day.value;
	if (weekDay=="" && dayOfMonth=="") {
		alert("请填写每月几号或者星期几！");
		return false;
	}
	if (weekDay=="")
		weekDay = "?";	
	if (ary[2].indexOf("0")==0 && ary[2].length>1)
		ary[2] = ary[2].substring(1, ary[2].length);
	if (ary[1].indexOf("0")==0 && ary[1].length>1)
		ary[1] = ary[1].substring(1, ary[1].length);
	if (ary[0].indexOf("0")==0 && ary[0].length>1)
		ary[0] = ary[0].substring(1, ary[0].length);
	if (dayOfMonth=="")
		dayOfMonth = "?";
	var cron = ary[2] + " " + ary[1] + " " + ary[0] + " " + dayOfMonth + " * " + weekDay;
	form1.cron.value = cron;
	if (form1.flowCode.value=="not") {
		alert("请选择流程！");
		return false;
	}
	form1.data_map.value = form1.flowCode.value;
}

function trimOptionText(strValue) 
{
	// 注意option中有全角的空格，所以不直接用trim
	var r = strValue.replace(/^　*|\s*|\s*$/g,"");
	return r;
}
</script>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
String priv="admin";
if (!privilege.isUserPrivValid(request, priv)) {
    out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String op = ParamUtil.get(request, "op");

int id = ParamUtil.getInt(request, "id");

JobUnitDb ju = new JobUnitDb();
ju = (JobUnitDb)ju.getQObjectDb(new Integer(id));
if (op.equals("edit")) {
	QObjectMgr qom = new QObjectMgr();
	try {
	if (qom.save(request, ju, "scheduler_edit"))
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "scheduler_edit.jsp?id=" + id));
	else
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">编辑调度&nbsp;&nbsp;<a href="scheduler_list.jsp">调度中心</a></td>
    </tr>
  </tbody>
</table>
<br>
<TABLE 
style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" 
cellSpacing=0 cellPadding=3 width="95%" align=center>
  <TBODY>
    <TR>
      <TD class=thead style="PADDING-LEFT: 10px" noWrap width="70%"><strong>调度</strong></TD>
    </TR>
    <TR class=row style="BACKGROUND-COLOR: #fafafa">
      <TD height="143" align="center" style="PADDING-LEFT: 10px"><table width="98%" border="0">
		<form name="form1" action="?op=edit" method="post" onsubmit="return form1_onsubmit()">
          <tr>
            <td align="left">&nbsp;</td>
          </tr>
          <tr>
            <td align="left">
			<input name="job_class" type="hidden" value="<%=ju.getString("job_class")%>">
			<input name="id" type="hidden" value="<%=id%>">
			名称：
			<input name="job_name" value="<%=ju.getString("job_name")%>">
			&nbsp;每月：
			<input name="month_day" size="2" value="<%=ju.getString("month_day")%>">
			号
			<input name="user_name" value="<%=privilege.getUser(request)%>" type="hidden"></td>
          </tr>
          <tr>
            <td align="left">
开始时间：
  <%
String cron = ju.getString("cron");
String[] ary = cron.split(" ");
if (ary[0].length()==1)
	ary[0] = "0" + ary[0];
if (ary[1].length()==1)
	ary[1] = "0" + ary[1];
if (ary[2].length()==1)
	ary[2] = "0" + ary[2];
String t = ary[2] + ":" + ary[1] + ":" + ary[0];
%>
<input style="WIDTH: 50px" name="time" size="20" value="<%=t%>">
&nbsp;<img style="CURSOR: hand" onclick="SelectDateTime('time')" src="../images/form/clock.gif" align="absMiddle" width="18" height="18"> 
在
<input name="weekDay" type="checkbox" value="1">
星期日
<input name="weekDay" type="checkbox" value="2">
星期一
<input name="weekDay" type="checkbox" value="3">
星期二
<input name="weekDay" type="checkbox" value="4">
星期三
<input name="weekDay" type="checkbox" value="5">
星期四
<input name="weekDay" type="checkbox" value="6">
星期五
<input name="weekDay" type="checkbox" value="7">
星期六 
<br>
<input name="data_map" type="hidden" value="<%=ju.getString("data_map")%>">
<input type="submit" value="确定"><input name="cron" type="hidden">
<input name="data_map" type="hidden">
<%
String[] w = ary[5].split(",");
for (int i=0; i<w.length; i++) {
%>
<script>
setCheckboxChecked("weekDay", "<%=w[i]%>");
</script>
<%
}
%></td>
          </tr>
          <tr>
            <td align="left">&nbsp;</td>
          </tr>
		</form>
        </table>
      <br></TD>
    </TR>
    <TR>
      <TD height="29" align=right class=tfoot>&nbsp;</TD>
    </TR>
  </TBODY>
</TABLE>
