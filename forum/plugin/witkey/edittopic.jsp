<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.setup.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.plugin.witkey.*"%>
<%@ page import="com.redmoon.forum.plugin.score.*"%>
<script src="<%=request.getContextPath()%>/inc/common.js"></script>
<script>
var GetDate=""; 
function SelectDate(ObjName,FormatDate) {
	var PostAtt = new Array;
	PostAtt[0]= FormatDate;
	PostAtt[1]= findObj(ObjName);

	GetDate = showModalDialog("<%=request.getContextPath()%>/util/calendar/calendar.htm", PostAtt ,"dialogWidth:286px;dialogHeight:221px;status:no;help:no;");
}

function SetDate()
{ 
	findObj(ObjName).value = GetDate; 
} 
</script>
<script>
function selMoneyCode() {
   	var ary = new Array();
	ary[0] = getRadioValue("moneyCode");
	ary[1] = frmAnnounce.score.value;
	if (ary[0]==null) {
		alert("请选择一个币种！");
		return;
	}
	else {
		if (!isNumeric(frmAnnounce.score.value)) {
			alert("分值格式错误！");
			return;
		}
	}
}
</script>
<%
long msgId = ParamUtil.getLong(request, "editid");
WitkeyDb wd = new WitkeyDb();
wd = wd.getWitkeyDb(msgId);
if (!wd.isLoaded()) {
	out.print(SkinUtil.makeErrMsg(request, "该贴不是威客贴！"));
}

Timestamp ts = new Timestamp(Long.parseLong(wd.getEndDate()));
%>
<TABLE width="100%" border=0 align=center cellPadding=2 cellSpacing=1 bgcolor="#CCCCCC">
  <TBODY>
	<TR>
	  <TD width="20%" align="left" bgcolor="#F9FAF3">项目结束时间：</TD>
	  <TD width="80%" height=23 align="left" bgcolor="#F9FAF3"><input readonly="readonly" type="text" id="endDate" name="endDate" size="10" value="<%=DateUtil.format(DateUtil.parse(ts.toString(), "yyyy-MM-dd"), "yyyy-MM-dd")%>"/>
        <img src="<%=request.getContextPath()%>/util/calendar/calendar.gif" align="absmiddle" style="cursor:hand" onclick="SelectDate('endDate','yyyy-mm-dd')" />
        <input type="hidden" name="pluginCode" value="<%=WitkeyUnit.code%>" /></TD>
	</TR>
  </TBODY>
</TABLE>
