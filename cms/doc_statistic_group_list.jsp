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
<link href="../common.css" rel="stylesheet" type="text/css">
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="../util/jscalendar/calendar.js"></script>
<script type="text/javascript" src="../util/jscalendar/lang/calendar-zh.js"></script>
<script type="text/javascript" src="../util/jscalendar/calendar-setup.js"></script>
<style type="text/css"> @import url("../util/jscalendar/calendar-win2k-2.css"); </style>
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
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
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">用户组发布统计</td>
    </tr>
  </tbody>
</table>
<%
	String op = ParamUtil.get(request, "op");

	String name = "",realname = "",strdate = "";
	int CountByYear = 0,CountByMonth = 0,CountByToday = 0,CountByYesterday = 0,CountByBYesterday = 0;
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
    <input type="text" id="date" name="date" size="10" value="<%=DateUtil.format(date, "yyyy-MM-dd")%>" onChange="window.location.href='doc_statistic_group_list.jsp?date='+this.value">
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
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="13%">名称</td>
      <td width="16%" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="images/tl.gif" align="absMiddle" width="10" height="15">总数</td>
      <td width="15%" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="images/tl.gif" align="absMiddle" width="10" height="15">当年发表数</td>
      <td width="15%" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="images/tl.gif" align="absMiddle" width="10" height="15">当月发表数</td>
      <td width="14%" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="images/tl.gif" align="absMiddle" width="10" height="15">前两天发表数</td>
      <td width="13%" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="images/tl.gif" align="absMiddle" width="10" height="15">前一天发表数</td>
      <td width="14%" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="images/tl.gif" align="absMiddle" width="10" height="15">当天发表数</td>
    </tr>
<%
	String sql = "select code,description from user_group order by code";            
	JdbcTemplate rmconn = new JdbcTemplate();
	ResultIterator ri = rmconn.executeQuery(sql);
	ResultRecord rr = null;

	UserMgr um = new UserMgr();
	
	while (ri.hasNext()) {
		rr = (ResultRecord)ri.next();
		String groupCode = rr.getString(1);
		String groupDesc = rr.getString(2);
		
		int groupCountByAll = 0;
		int groupCountByYear = 0;
		int groupCountByMonth = 0;
		int groupCountByBYesterday = 0;
		int groupCountByYesterday = 0;
		int groupCountByToday = 0;
		
		String sql2 = "select user_name from user_of_group where group_code=?";
		ResultIterator ri2 = rmconn.executeQuery(sql2, new Object[]{groupCode});
		while (ri2.hasNext()) {
			ResultRecord rr2 = (ResultRecord)ri2.next();
			name = rr.getString(1);
			realname = rr.getString(2);
			
			User user = um.getUser(name);
			
			if (op.equals("initUser")) {
				String sqlInit = "select count(*) from document where nick=" + StrUtil.sqlstr(name);
				ResultIterator ri_init = rmconn.executeQuery(sqlInit);
				ResultRecord rr_init = null;
				if (ri_init.hasNext()) {
					rr_init = (ResultRecord)ri_init.next();
					user.setDocCount(rr_init.getInt(1));
					user.save();
				}
			}
			
			groupCountByAll += user.getDocCount();
			
			int daysOfYear = DateUtil.getDaysOfYear(y);
			java.util.Date tempd = DateUtil.addDate(year, daysOfYear);
			tempd = DateUtil.addMinuteDate(tempd, -1);
			sqlCountByYear =
					" select count(*) from document where createDate>=? and createDate<=?" + " and nick = " + StrUtil.sqlstr(name);		
			ResultIterator ri_year = rmconn.executeQuery(sqlCountByYear, new Object[]{DateUtil.toLongString(year), DateUtil.toLongString(tempd)});
			ResultRecord rr_year = null;
			if (ri_year.hasNext()) {
				rr_year = (ResultRecord)ri_year.next();
				CountByYear = rr_year.getInt(1);
				groupCountByYear += CountByYear;
			}
			
			int daysOfMonth = DateUtil.getDayCount(y, m-1);
			tempd = DateUtil.addDate(month, daysOfMonth);
			tempd = DateUtil.addMinuteDate(tempd, -1);
			sqlCountByMonth =
					" select count(*) from document where createDate>=? and createDate<=?" + " and nick = " + StrUtil.sqlstr(name);
			ResultIterator ri_month = rmconn.executeQuery(sqlCountByMonth, new Object[] {DateUtil.toLongString(month), DateUtil.toLongString(tempd)});
			ResultRecord rr_month = null;
			if (ri_month.hasNext()) {
				rr_month = (ResultRecord)ri_month.next();
				CountByMonth = rr_month.getInt(1);
				groupCountByMonth += CountByMonth;
			}
			
			tempd = DateUtil.addHourDate(today, 24);
			tempd = DateUtil.addMinuteDate(tempd, -1);
			sqlCountByToday =
					" select count(*) from document where createDate>=? and createDate<=?" + " and nick = " + StrUtil.sqlstr(name);
			ResultIterator ri_today = rmconn.executeQuery(sqlCountByToday, new Object[]{DateUtil.toLongString(today), DateUtil.toLongString(tempd)});
			ResultRecord rr_today = null;
			if (ri_today.hasNext()) {
				rr_today = (ResultRecord)ri_today.next();
				CountByToday = rr_today.getInt(1);
				groupCountByToday += CountByToday;
			}
			
			sqlCountByYesterday= " select count(*) from document where createDate >= " + StrUtil.sqlstr(Long.toString(today.getTime()-24*60*60000)) + " and createDate < " + StrUtil.sqlstr(Long.toString(today.getTime())) + " and nick = " + StrUtil.sqlstr(name);
			ResultIterator ri_yesterday = rmconn.executeQuery(sqlCountByYesterday);
			ResultRecord rr_yesterday = null;
			if (ri_yesterday.hasNext()) {
				rr_yesterday = (ResultRecord)ri_yesterday.next();
				CountByYesterday = rr_yesterday.getInt(1);
				groupCountByYesterday += CountByYesterday;
			}
			
			sqlCountByBYesterday= " select count(*) from document where createDate >= " + StrUtil.sqlstr(Long.toString(today.getTime()-2*24*60*60000)) + " and createDate < " + StrUtil.sqlstr(Long.toString(today.getTime()-24*60*60000)) + " and nick = " + StrUtil.sqlstr(name);
			ResultIterator ri_byesterday = rmconn.executeQuery(sqlCountByBYesterday);
			ResultRecord rr_byesterday = null;
			if (ri_byesterday.hasNext()) {
				rr_byesterday = (ResultRecord)ri_byesterday.next();
				CountByBYesterday = rr_byesterday.getInt(1);
				groupCountByBYesterday += CountByBYesterday;
			}
		}
%>
    <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1">
      <td style="PADDING-LEFT: 10px">&nbsp;<%=groupDesc%></td>
      <td style="PADDING-LEFT: 10px"><%=groupCountByAll%></a></td>
      <td style="PADDING-LEFT: 10px"><%=groupCountByYear%></td>
      <td style="PADDING-LEFT: 10px"><%=groupCountByMonth%></td>
      <td style="PADDING-LEFT: 10px"><%=groupCountByBYesterday%></td>
      <td style="PADDING-LEFT: 10px"><%=groupCountByYesterday%></td>
      <td style="PADDING-LEFT: 10px"><%=groupCountByToday%></td>
    </tr>
<%}%>
<%
Statistic st = new Statistic();
%>	
    <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1">
      <td height="22" bgcolor="#EFF1FE" style="PADDING-LEFT: 10px">&nbsp;合计：</td>
      <td bgcolor="#EFF1FE" style="PADDING-LEFT: 10px"><%=st.getAllDocCount()%></td>
      <td bgcolor="#EFF1FE" style="PADDING-LEFT: 10px"><%=st.getCounts(date)[0]%></td>
      <td bgcolor="#EFF1FE" style="PADDING-LEFT: 10px"><%=st.getCounts(date)[1]%></td>
      <td bgcolor="#EFF1FE" style="PADDING-LEFT: 10px"><%=st.getCounts(date)[4]%></td>
      <td bgcolor="#EFF1FE" style="PADDING-LEFT: 10px"><%=st.getCounts(date)[3]%></td>
      <td bgcolor="#EFF1FE" style="PADDING-LEFT: 10px"><%=st.getCounts(date)[2]%></td>
    </tr>
  </tbody>
</table>
<br>
<div style="text-align:center">
  <input type="button" value="导出至Excel" onclick="window.open('doc_statistic_user_list_excel.jsp?date=<%=strToday%>')" /></div>
</body>
</html>