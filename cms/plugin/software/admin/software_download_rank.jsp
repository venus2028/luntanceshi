<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ page import="java.lang.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.cms.util.*"%>
<%@ page import="cn.js.fan.module.cms.plugin.software.*" %>
<html>
<head>
<title>发布文章统计</title>
<link href="../../../../common.css" rel="stylesheet" type="text/css">
<link href="../../../default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="../../../../util/jscalendar/calendar.js"></script>
<script type="text/javascript" src="../../../../util/jscalendar/lang/calendar-zh.js"></script>
<script type="text/javascript" src="../../../../util/jscalendar/calendar-setup.js"></script>
<style type="text/css"> @import url("../../../../util/jscalendar/calendar-win2k-2.css"); </style>
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
<script src="../../../../inc/common.js"></script>
</head>
<body>
<jsp:useBean id="usermgr" scope="page" class="cn.js.fan.module.pvg.UserMgr"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, PrivDb.PRIV_ADMIN)) {
	out.println(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<DIV id="tabBar">
  <div class="tabs">
    <ul>
      <li id="menu1"><a href="manager.jsp">配置</a></li>
      <li id="menu2"><a href="software_list.jsp">软件管理</a></li>
      <li id="menu3"><a href="software_statistic_user_list.jsp">发布统计</a></li>
      <li id="menu4"><a href="software_download_rank.jsp">下载排行</a></li>	  
    </ul>
  </div>
</DIV>
<script>
$("menu4").className="active"; 
</script>
<%
String sDate = ParamUtil.get(request, "date");
java.util.Date date = DateUtil.parse(sDate, "yyyy-MM-dd");
if (date==null)
	date = new java.util.Date();

String strToday = DateUtil.format(date,"yyyy-MM-dd");
java.util.Date today = DateUtil.parse(strToday,"yyyy-MM-dd");

String strMonth = DateUtil.format(date,"yyyy-MM");
java.util.Date month = DateUtil.parse(strMonth,"yyyy-MM");

String strYear = DateUtil.format(date,"yyyy");
java.util.Date year = DateUtil.parse(strYear,"yyyy");

int y = StrUtil.toInt(strYear);
Calendar cal = Calendar.getInstance();
cal.setTime(month);
int m = cal.get(Calendar.MONTH)+1;
cal.setTime(today);
int d = cal.get(Calendar.DAY_OF_MONTH);
	
int row = ParamUtil.getInt(request, "row", 20);
String type = ParamUtil.get(request, "type");
if (type.equals(""))
	type = "year";
%>
<br>
<form name="form1" action="software_download_rank.jsp" method="get">
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>选择日期：
    <input type="text" id="date" name="date" size="10" value="<%=DateUtil.format(date, "yyyy-MM-dd")%>">
<script type="text/javascript">
    Calendar.setup({
        inputField     :    "date", 
        ifFormat       :    "%Y-%m-%d",
        showsTime      :    false,
        singleClick    :    false,
        align          :    "Tl",
        step           :    1
    });
</script>
<select name="type">
<option value="year">当年</option>
<option value="month">当月</option>
<option value="day">当日</option>
<option value="yestoday">昨天</option>
<option value="beforeyestoday">前天</option>
</select>
<script>
form1.type.value = "<%=type%>";
</script>
显示前<input name="row" value="<%=row%>" size="3">
条&nbsp;<input value="确定" type="submit"></td>
  </tr>
</table>
</form>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="95%" align="center">
  <tbody>
    <tr>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="63%">软件</td>
      <td width="18%" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="../../../images/tl.gif" align="absMiddle" width="10" height="15">下载次数</td>
      <td width="19%" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="../../../images/tl.gif" align="absMiddle" width="10" height="15">创建日期</td>
    </tr>
<%
int p = 0;
if (type.equals("year")) {
	p = 0;
} else if (type.equals("month")) {
	p = 1;
} else if (type.equals("day")) {
	p = 2;
} else if (type.equals("yestoday")) {
	p = 3;
} else if (type.equals("beforeyestoday")) {
	p = 4;
}

SoftwareStatistic st = new SoftwareStatistic();
int[][][] r = st.getDownloadRank(date, row);

cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
boolean isHtml = cfg.getBooleanProperty("cms.html_doc");
String pageUrl = "";
int[][] ary = r[p];
DocumentMgr dm = new DocumentMgr();
SoftwareDocumentDb sdd = new SoftwareDocumentDb();
Document doc = null;
for (int i = 0; i < ary.length; i++) {
	int docId = ary[i][0];
	if (docId == 0) // 行数不足row
		break;
	doc = dm.getDocument(docId);
	if (doc==null)
		continue;	
	int count = ary[i][1];
	sdd = sdd.getSoftwareDocumentDb(docId);
	pageUrl = request.getContextPath() + "/doc_view.jsp?id=" +
		   docId;
	if (isHtml) {
		pageUrl = request.getContextPath() + "/" + doc.getDocHtmlName(1);
	}
%>
    <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1">
      <td style="PADDING-LEFT: 10px">&nbsp;<a href="<%=pageUrl%>" target="_blank"><%=doc.getTitle()%></a></td>
      <td style="PADDING-LEFT: 10px"><%=ary[i][1]%></td>
      <td style="PADDING-LEFT: 10px"><%=DateUtil.format(doc.getCreateDate(), "yyyy-MM-dd")%></td>
    </tr>
<%}%>
  </tbody>
</table>
</body>
</html>