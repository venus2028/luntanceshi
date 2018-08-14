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

function SelectDateTime(obj) {
	var dt = showModalDialog("../util/calendar/time.jsp", "" ,"dialogWidth:266px;dialogHeight:125px;status:no;help:no;");
	if (dt!=null) {
		if (dt.indexOf("24")==0)
			dt = "00" + dt.substring(2);
		obj.value = dt;
	}
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
}

function form2_onsubmit() {
	var t = form2.time.value;
	var ary = t.split(":");
	var weekDay = getCheckboxValue("weekDay");
	var dayOfMonth = form2.month_day.value;
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
	form2.cron.value = cron;
}

function trimOptionText(strValue) {
	// 注意option中有全角的空格，所以不直接用trim
	var r = strValue.replace(/^　*|\s*|\s*$/g,"");
	return r;
}
</script>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request)) {
    out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String op = ParamUtil.get(request, "op");

if (op.equals("add")) {
	QObjectMgr qom = new QObjectMgr();
	JobUnitDb ju = new JobUnitDb();
	try {
	if (qom.create(request, ju, "scheduler_add"))
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "scheduler_list.jsp"));
	else
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">添加调度&nbsp;&nbsp;<span style="PADDING-LEFT: 10px"><a href="scheduler_list.jsp">调度中心</a></span></td>
    </tr>
  </tbody>
</table>
<br>
<TABLE width="95%" height="219" align=center cellPadding=3 
cellSpacing=0 
style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">
  <!-- Table Head Start-->
  <TBODY>
    <TR>
      <TD class=thead style="PADDING-LEFT: 10px" noWrap width="70%">&nbsp;</TD>
    </TR>
    <TR class=row style="BACKGROUND-COLOR: #fafafa">
      <TD height="161" align="center" style="PADDING-LEFT: 10px"><br>
        <table width="94%" border="0">
        <form name="form1" action="?op=add" method="post" onsubmit="return form1_onsubmit()">
          <tr>
            <td align="left"><strong>CMS全文检索</strong></td>
          </tr>
          <tr>
            <td align="left"><input name="job_class" type="hidden" value="cn.js.fan.module.cms.job.FullTextSearchIndexerJob">
              名称：
              <input name="job_name">
              &nbsp;每月：
              <input name="month_day" size="2">
              号
              <input name="user_name" value="<%=privilege.getUser(request)%>" type="hidden"></td>
          </tr>
          <tr>
            <td align="left"> 开始时间
              <input style="WIDTH: 50px" value="12:00:00" name="time" size="20">
              &nbsp;<img style="CURSOR: hand" onclick="SelectDateTime(form1.time)" src="../images/form/clock.gif" align="absMiddle" width="18" height="18"> 在
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
              <input name="cron" type="hidden">
              <jsp:useBean id="cmsCfg" scope="page" class="cn.js.fan.module.cms.Config"/>
              <br>
              时间戳：
              <input name="data_map" value="<%=cmsCfg.getProperty("cms.fullTextSearchTime")%>">
              <input name="submit2" type="submit" value="确定"></td>
          </tr>
        </form>
      </table>
          <br>
        <br>
      <table width="94%" border="0">
        <form name="form2" action="?op=add" method="post" onsubmit="return form2_onsubmit()">
          <tr>
            <td align="left"><strong>论坛全文检索</strong></td>
            </tr>
          <tr>
            <td align="left"><input name="job_class" type="hidden" value="com.redmoon.forum.job.FullTextSearchIndexerJob">
              名称：
              <input name="job_name">
              &nbsp;每月：<input name="month_day" size="2">
              号<input name="user_name" value="<%=privilege.getUser(request)%>" type="hidden"></td>
            </tr>
          <tr>
            <td align="left">
              开始时间
  <input style="WIDTH: 50px" value="12:00:00" name="time" size="20">
  &nbsp;<img style="CURSOR: hand" onclick="SelectDateTime(form2.time)" src="../images/form/clock.gif" align="absMiddle" width="18" height="18"> 
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
  <input name="cron" type="hidden">
  <%
  com.redmoon.forum.Config forumCfg = com.redmoon.forum.Config.getInstance();
  %>
  <br>
              时间戳：
  <input name="data_map" value="<%=forumCfg.getProperty("forum.fullTextSearchTime")%>">
  <input name="submit" type="submit" value="确定"></td>
          </tr></form>
        </table>
      <br></TD>
    </TR>
    <TR>
      <TD class=tfoot align=right>&nbsp;</TD>
    </TR>
  </TBODY>
</TABLE>
