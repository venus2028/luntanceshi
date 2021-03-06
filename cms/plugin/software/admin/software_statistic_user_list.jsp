<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ page import="java.lang.*"%>
<%@ page import="cn.js.fan.module.cms.util.*"%>
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
$("menu3").className="active"; 
</script>
<%
	String sql = "select name,realname from users order by name";            
	JdbcTemplate rmconn = new JdbcTemplate();
	ResultIterator ri = rmconn.executeQuery(sql);
	ResultRecord rr = null;
	String name = "",realname = "",strdate = "";
	String CountByYear = "",CountByMonth = "",CountByToday = "",CountByYesterday = "",CountByBYesterday = "";
	String sqlCountByYear = "",sqlCountByMonth = "",sqlCountByToday = "",sqlCountByYesterday = "",sqlCountByBYesterday = ""; 
	
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
%>
<br>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>选择日期：
    <input type="text" id="date" name="date" size="10" value="<%=DateUtil.format(date, "yyyy-MM-dd")%>" onChange="window.location.href='software_statistic_user_list.jsp?date='+this.value">
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
	</td>
  </tr>
</table>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="95%" align="center">
  <tbody>
    <tr>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="11%">用户名</td>
      <td width="17%" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="../../../images/tl.gif" align="absMiddle" width="10" height="15">当年发表数</td>
      <td width="18%" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="../../../images/tl.gif" align="absMiddle" width="10" height="15">当月发表数</td>
      <td width="19%" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="../../../images/tl.gif" align="absMiddle" width="10" height="15">前两天发表数</td>
      <td width="17%" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="../../../images/tl.gif" align="absMiddle" width="10" height="15">前一天发表数</td>
      <td width="18%" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="../../../images/tl.gif" align="absMiddle" width="10" height="15">当天发表数</td>
    </tr>
<%
	while (ri.hasNext()) {
		rr = (ResultRecord)ri.next();
		name = rr.getString(1);
		realname = rr.getString(2);
		
		int daysOfYear = DateUtil.getDaysOfYear(y);
		java.util.Date tempd = DateUtil.addDate(year, daysOfYear);
		tempd = DateUtil.addMinuteDate(tempd, -1);
		sqlCountByYear =
				" select count(*) from document d, cws_cms_software_doc s where d.id=s.doc_id and createDate>=? and createDate<=?" + " and nick = " + StrUtil.sqlstr(name);		
		ResultIterator ri_year = rmconn.executeQuery(sqlCountByYear, new Object[]{DateUtil.toLongString(year), DateUtil.toLongString(tempd)});
		ResultRecord rr_year = null;
		if (ri_year.hasNext()) {
			rr_year = (ResultRecord)ri_year.next();
			CountByYear = rr_year.getString(1);
		}
		
		int daysOfMonth = DateUtil.getDayCount(y, m-1);
		tempd = DateUtil.addDate(month, daysOfMonth);
		tempd = DateUtil.addMinuteDate(tempd, -1);
		sqlCountByMonth =
				" select count(*) from document d, cws_cms_software_doc s where d.id=s.doc_id and createDate>=? and createDate<=?" + " and nick = " + StrUtil.sqlstr(name);
		ResultIterator ri_month = rmconn.executeQuery(sqlCountByMonth, new Object[] {DateUtil.toLongString(month), DateUtil.toLongString(tempd)});
		ResultRecord rr_month = null;
		if (ri_month.hasNext()) {
			rr_month = (ResultRecord)ri_month.next();
			CountByMonth = rr_month.getString(1);
		}
		
		tempd = DateUtil.addHourDate(today, 24);
		tempd = DateUtil.addMinuteDate(tempd, -1);
		sqlCountByToday =
				" select count(*) from document d, cws_cms_software_doc s where d.id=s.doc_id and createDate>=? and createDate<=?" + " and nick = " + StrUtil.sqlstr(name);
		ResultIterator ri_today = rmconn.executeQuery(sqlCountByToday, new Object[]{DateUtil.toLongString(today), DateUtil.toLongString(tempd)});
		ResultRecord rr_today = null;
		if (ri_today.hasNext()) {
			rr_today = (ResultRecord)ri_today.next();
			CountByToday = rr_today.getString(1);
		}
		
		sqlCountByYesterday= " select count(*) from document d, cws_cms_software_doc s where d.id=s.doc_id and createDate >= " + StrUtil.sqlstr(Long.toString(today.getTime()-24*60*60000)) + " and createDate < " + StrUtil.sqlstr(Long.toString(today.getTime())) + " and nick = " + StrUtil.sqlstr(name);
		ResultIterator ri_yesterday = rmconn.executeQuery(sqlCountByYesterday);
		ResultRecord rr_yesterday = null;
		if (ri_yesterday.hasNext()) {
			rr_yesterday = (ResultRecord)ri_yesterday.next();
			CountByYesterday = rr_yesterday.getString(1);
		}
		
		sqlCountByBYesterday= " select count(*) from document d, cws_cms_software_doc s where d.id=s.doc_id and createDate >= " + StrUtil.sqlstr(Long.toString(today.getTime()-2*24*60*60000)) + " and createDate < " + StrUtil.sqlstr(Long.toString(today.getTime()-24*60*60000)) + " and nick = " + StrUtil.sqlstr(name);
		ResultIterator ri_byesterday = rmconn.executeQuery(sqlCountByBYesterday);
		ResultRecord rr_byesterday = null;
		if (ri_byesterday.hasNext()) {
			rr_byesterday = (ResultRecord)ri_byesterday.next();
			CountByBYesterday = rr_byesterday.getString(1);
		}
%>
    <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1">
      <td style="PADDING-LEFT: 10px">&nbsp;<a href="software_statistic_user.jsp?userName=<%=StrUtil.UrlEncode(name)%>"><%=realname%></a></td>
      <td style="PADDING-LEFT: 10px"><%=CountByYear%></td>
      <td style="PADDING-LEFT: 10px"><%=CountByMonth%></td>
      <td style="PADDING-LEFT: 10px"><%=CountByBYesterday%></td>
      <td style="PADDING-LEFT: 10px"><%=CountByYesterday%></td>
      <td style="PADDING-LEFT: 10px"><%=CountByToday%></td>
    </tr>
<%}%>
<%
Statistic st = new Statistic();
%>	
    <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1">
      <td height="22" bgcolor="#EFF1FE" style="PADDING-LEFT: 10px">合计：</td>
      <td bgcolor="#EFF1FE" style="PADDING-LEFT: 10px"><%=st.getCounts(date)[0]%></td>
      <td bgcolor="#EFF1FE" style="PADDING-LEFT: 10px"><%=st.getCounts(date)[1]%></td>
      <td bgcolor="#EFF1FE" style="PADDING-LEFT: 10px"><%=st.getCounts(date)[4]%></td>
      <td bgcolor="#EFF1FE" style="PADDING-LEFT: 10px"><%=st.getCounts(date)[3]%></td>
      <td bgcolor="#EFF1FE" style="PADDING-LEFT: 10px"><%=st.getCounts(date)[2]%></td>
    </tr>
    <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1">
      <td height="22" bgcolor="#E2DCFC" style="PADDING-LEFT: 10px"><strong>总计：</strong></td>
      <td bgcolor="#E2DCFC" style="PADDING-LEFT: 10px"><%=st.getAllDocCount()%></td>
      <td bgcolor="#E2DCFC" style="PADDING-LEFT: 10px">&nbsp;</td>
      <td bgcolor="#E2DCFC" style="PADDING-LEFT: 10px">&nbsp;</td>
      <td bgcolor="#E2DCFC" style="PADDING-LEFT: 10px">&nbsp;</td>
      <td bgcolor="#E2DCFC" style="PADDING-LEFT: 10px">&nbsp;</td>
    </tr>
  </tbody>
</table>
</body>
</html>