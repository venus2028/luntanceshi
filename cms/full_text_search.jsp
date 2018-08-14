<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="cn.js.fan.module.cms.search.Indexer"%>
<%@ page import="org.apache.lucene.search.*,org.apache.lucene.document.*" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<link href="default.css" rel="stylesheet" type="text/css">
<LINK href="../common.css" type=text/css rel=stylesheet>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script src="../inc/calendar.js"></script>
<script src="../inc/common.js"></script>
<style type="text/css">
<!--
.style1 {
	color: #FFFFFF;
	font-weight: bold;
}
.style2 {color: #FFFFFF}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="cfg" scope="page" class="cn.js.fan.web.Config"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, PrivDb.PRIV_ADMIN)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String op = ParamUtil.get(request, "op");
if(op.trim().equals("create")){
    String sFromDate = ParamUtil.get(request, "fromDate");
	String sToDate = ParamUtil.get(request, "toDate");
	String sFromTime = ParamUtil.get(request, "fromTime");
	String sToTime = ParamUtil.get(request, "toTime");
	
	cn.js.fan.module.cms.Document document = new cn.js.fan.module.cms.Document();
	Indexer indexer = new Indexer();
	long lBeginDate = 0;
	long lEndDate = 0;
	java.util.Date beginDate = null;
	java.util.Date endDate = null;
	
	if(!sFromDate.equals("") && !sToDate.equals("")){
	    if(!sFromTime.equals("")){
			beginDate = DateUtil.parse(sFromDate + " " + sFromTime, "yyyy-MM-dd HH:mm:ss");
		}else{
			beginDate = DateUtil.parse(sFromDate, "yyyy-MM-dd");
		}
		if(!sToTime.equals("")){
			endDate = DateUtil.parse(sToDate + " " + sToTime, "yyyy-MM-dd HH:mm:ss");
		}else{
			endDate = DateUtil.parse(sToDate, "yyyy-MM-dd");
		}
		lBeginDate = beginDate.getTime();
		lEndDate = endDate.getTime();
	}
	if(!sFromDate.equals("") && sToDate.equals("")){
	    if(!sFromTime.equals("")){
			beginDate = DateUtil.parse(sFromDate + " " + sFromTime, "yyyy-MM-dd HH:mm:ss");
		}else{
			beginDate = DateUtil.parse(sFromDate, "yyyy-MM-dd");
		}
		lBeginDate = beginDate.getTime();
		lEndDate = System.currentTimeMillis();
	}
	if(sFromDate.equals("") && !sToDate.equals("")) {
		if(!sToTime.equals("")){
			endDate = DateUtil.parse(sToDate + " " + sToTime, "yyyy-MM-dd HH:mm:ss");
		}else{
			endDate = DateUtil.parse(sToDate, "yyyy-MM-dd");
		}
		lEndDate = endDate.getTime();
	}
	if (indexer.index(document.list(lBeginDate, lEndDate), true))
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"),"full_text_search.jsp"));
	else
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_fail"),"full_text_search.jsp"));
}

if (op.equals("regenerate")) {
	Indexer indexer = new Indexer();
	cn.js.fan.module.cms.Document document = new cn.js.fan.module.cms.Document();
	if (indexer.index(document.list(0, 0), false))
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"),"full_text_search.jsp"));
	else
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_fail"),"full_text_search.jsp"));
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">生成全文检索索引</td>
    </tr>
  </tbody>
</table>
<br>
<TABLE style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing=0 cellPadding=3 width="95%" align=center>
  <form name="form1" method="post" action="?op=create">
  <TBODY>
    <TR>
      <TD colspan="2" noWrap class=thead style="PADDING-LEFT: 10px">&nbsp;</TD>
    </TR>
    <TR>
      <TD width="32%" align="right">开始时间</TD>
      <TD width="68%">
		<input name="fromDate" size=10>
		&nbsp;<img src="../util/calendar/calendar.gif" align=absMiddle style="cursor:hand" onClick="SelectDate('fromDate','yyyy-mm-dd')"> <input style="WIDTH: 80px" name="fromTime" size="30"> 
		<img style="CURSOR: hand" onClick="SelectDateTime(form1.fromTime)" src="../forum/images/clock.gif" align="absMiddle" width="18" height="18">	  </TD>
      </TR>
    <TR>
      <TD align="right">结束时间</TD>
      <TD><input name="toDate" size=10>
        &nbsp;<img src="../util/calendar/calendar.gif" align=absMiddle style="cursor:hand" onClick="SelectDate('toDate','yyyy-mm-dd')">
        <input style="WIDTH: 80px" name="toTime" size="30">        <img style="CURSOR: hand" onClick="SelectDateTime(form1.toTime)" src="../forum/images/clock.gif" align="absMiddle" width="18" height="18"> </TD>
      </TR>
    <TR>
      <TD align="right">&nbsp;</TD>
      <TD><input name="submit" type=submit value="增量生成">        &nbsp;&nbsp;&nbsp;
        <input name="submit2" type=button value="全部重新生成" onClick="window.location.href='?op=regenerate'">	   </TD>
      </TR>
    <TR>
      <TD align="right">&nbsp;</TD>
      <TD><p>1、选择开始时间和结束时间，根据时间段生成全文检索的索引<br>
      2、点击全部重新生成，将会生成所有的索引<br>
      3、系统在生成索引时，会形成“<a href="config_cms.jsp">全文检索的时间戳</a>”，该时间戳在CMS配置中可以管理</p>
        </TD>
    </TR>	
    <TR>
      <TD colspan="2" align=right class=tfoot></TD>
    </TR>
  </TBODY>
  </form>
</TABLE>
</body>
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

var GetDate=""; 
function SelectDate(ObjName,FormatDate) {
	var PostAtt = new Array;
	PostAtt[0]= FormatDate;
	PostAtt[1]= findObj(ObjName);

	GetDate = showModalDialog("../util/calendar/calendar.htm", PostAtt ,"dialogWidth:286px;dialogHeight:221px;status:no;help:no;");
}

function SetDate() { 
	findObj(ObjName).value = GetDate; 
} 

function SelectDateTime(obj) {
	var dt = showModalDialog("../util/calendar/time.jsp", "" ,"dialogWidth:266px;dialogHeight:125px;status:no;help:no;");
	if (dt!=null)
		obj.value = dt;
}
</script>
</html>