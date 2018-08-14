<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
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
<TABLE width="100%" border=0 align=center cellPadding=2 cellSpacing=1 bgcolor="#CCCCCC">
  <TBODY>
	<TR>
		<TD width="20%" align="left" bgcolor="#F9FAF3">项目类别：</TD>
		<TD height=23 align="left" bgcolor="#F9FAF3">
		<select name="catalogCode">
		<%
            com.redmoon.forum.plugin.witkey.Directory dir = new com.redmoon.forum.plugin.witkey.Directory();
            com.redmoon.forum.plugin.witkey.Leaf lf = dir.getLeaf("root");
            com.redmoon.forum.plugin.witkey.DirectoryView dv = new com.redmoon.forum.plugin.witkey.DirectoryView(lf);
            StringBuffer sb = new StringBuffer();
			dv.ShowDirectoryAsOptionsToString(sb, lf, lf.getLayer());
			out.print(sb);
		%>
	    </select><input type="hidden" name="pluginCode" value="<%=WitkeyUnit.code%>" /></TD>
	</TR>	
	<TR>
        <TD width="20%" align="left" bgcolor="#F9FAF3">分值种类：</TD> 
        <TD width="80%" height=23 align="left" bgcolor="#F9FAF3">
	<%	  
			ScoreMgr sm = new ScoreMgr();
			Vector v = sm.getAllScore();
			Iterator ir = v.iterator();
			String str = "";
			while (ir.hasNext()) {
				ScoreUnit su = (ScoreUnit) ir.next();
				if (su.isExchange()) {
	%>
				<input name="moneyCode" type="radio" value="<%=su.getCode()%>">
				<%=su.getName()%>
	<%	  
			  }
		  }
	%></TD>
    </TR>
	<TR>
	  <TD align="left" bgcolor="#F9FAF3">分值：</TD>
	  <TD height=23 align="left" bgcolor="#F9FAF3"><input name="score" size="6" onchange="selMoneyCode()" /></TD>
    </TR>
	<TR>
	  <TD align="left" bgcolor="#F9FAF3"><p>项目所在地：</p>      </TD>
	  <TD height=23 align="left" bgcolor="#F9FAF3">
	    <input type="text" name="city"/>	  </TD>
    </TR>
	<TR>
	  <TD align="left" bgcolor="#F9FAF3">项目结束时间：</TD>
	  <TD height=23 align="left" bgcolor="#F9FAF3"><input readonly="readonly" type="text" id="endDate" name="endDate" size="10"/>
      <img src="<%=request.getContextPath()%>/util/calendar/calendar.gif" align="absmiddle" style="cursor:hand" onclick="SelectDate('endDate','yyyy-mm-dd')" /></TD>
    </TR>
	<TR>
	  <TD align="left" bgcolor="#F9FAF3">联系方式：</TD>
	  <TD height=23 align="left" bgcolor="#F9FAF3"><input type="text" name="contact"/></TD>
	</TR>
  </TBODY>
</TABLE>
