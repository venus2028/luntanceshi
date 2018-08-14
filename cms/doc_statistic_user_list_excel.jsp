<%@ page contentType="text/html; charset=GB2312"%><%@ page import="java.io.*"%><%@ page import="jxl.*"%><%@ page import="jxl.write.*"%><%@ page import="cn.js.fan.module.cms.util.*"%><%@ page import="com.cloudwebsoft.framework.db.*"%><%@ page import="cn.js.fan.db.*"%><%@ page import="java.util.*"%><%@ page import="cn.js.fan.web.*"%><%@ page import="cn.js.fan.util.*"%><%@ page import="cn.js.fan.security.*"%><%@ page import="jxl.*"%><%@ page import="jxl.write.*"%><%@ page import="cn.js.fan.module.pvg.*"%><jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/><%
String priv="admin";
if (!privilege.isUserPrivValid(request,priv)) {
	out.println(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String op = ParamUtil.get(request, "op");

response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-disposition","attachment; filename="+StrUtil.GBToUnicode("文章发布情况统计"));  

OutputStream os = response.getOutputStream();

try {
	File file = new File(Global.realPath + "cms/doc_statistic_user_list.xls");

	Workbook wb = Workbook.getWorkbook(file);

	// 打开一个文件的副本，并且指定数据写回到原文件
	WritableWorkbook wwb = Workbook.createWorkbook(os, wb);
	WritableSheet ws = wwb.getSheet(0);
		
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

	UserMgr um = new UserMgr();

	int j = 1;
	while (ri.hasNext()) {
		rr = (ResultRecord)ri.next();
		name = rr.getString(1);
		realname = rr.getString(2);
		
		User user = um.getUser(name);		
		
		int daysOfYear = DateUtil.getDaysOfYear(y);
		java.util.Date tempd = DateUtil.addDate(year, daysOfYear);
		tempd = DateUtil.addMinuteDate(tempd, -1);
		sqlCountByYear =
				" select count(*) from document where createDate>=? and createDate<=?" + " and nick = " + StrUtil.sqlstr(name);		
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
				" select count(*) from document where createDate>=? and createDate<=?" + " and nick = " + StrUtil.sqlstr(name);
		ResultIterator ri_month = rmconn.executeQuery(sqlCountByMonth, new Object[] {DateUtil.toLongString(month), DateUtil.toLongString(tempd)});
		ResultRecord rr_month = null;
		if (ri_month.hasNext()) {
			rr_month = (ResultRecord)ri_month.next();
			CountByMonth = rr_month.getString(1);
		}
		
		tempd = DateUtil.addHourDate(today, 24);
		tempd = DateUtil.addMinuteDate(tempd, -1);
		sqlCountByToday =
				" select count(*) from document where createDate>=? and createDate<=?" + " and nick = " + StrUtil.sqlstr(name);
		ResultIterator ri_today = rmconn.executeQuery(sqlCountByToday, new Object[]{DateUtil.toLongString(today), DateUtil.toLongString(tempd)});
		ResultRecord rr_today = null;
		if (ri_today.hasNext()) {
			rr_today = (ResultRecord)ri_today.next();
			CountByToday = rr_today.getString(1);
		}
		
		sqlCountByYesterday = " select count(*) from document where createDate >= " + StrUtil.sqlstr(Long.toString(today.getTime()-24*60*60000)) + " and createDate < " + StrUtil.sqlstr(Long.toString(today.getTime())) + " and nick = " + StrUtil.sqlstr(name);
		ResultIterator ri_yesterday = rmconn.executeQuery(sqlCountByYesterday);
		ResultRecord rr_yesterday = null;
		if (ri_yesterday.hasNext()) {
			rr_yesterday = (ResultRecord)ri_yesterday.next();
			CountByYesterday = rr_yesterday.getString(1);
		}
		
		sqlCountByBYesterday = " select count(*) from document where createDate >= " + StrUtil.sqlstr(Long.toString(today.getTime()-2*24*60*60000)) + " and createDate < " + StrUtil.sqlstr(Long.toString(today.getTime()-24*60*60000)) + " and nick = " + StrUtil.sqlstr(name);
		ResultIterator ri_byesterday = rmconn.executeQuery(sqlCountByBYesterday);
		ResultRecord rr_byesterday = null;
		if (ri_byesterday.hasNext()) {
			rr_byesterday = (ResultRecord)ri_byesterday.next();
			CountByBYesterday = rr_byesterday.getString(1);
		}
		
		Label a0 = new Label(0, j, realname);
		Label a1 = new Label(1, j, ""+user.getDocCount());
		Label a2 = new Label(2, j, ""+CountByYear);
		Label a3 = new Label(3, j, ""+CountByMonth);
		Label a4 = new Label(4, j, ""+CountByBYesterday);
		Label a5 = new Label(5, j, ""+CountByYesterday);
		Label a6 = new Label(6, j, ""+CountByToday);
		ws.addCell(a0);
		ws.addCell(a1);
		ws.addCell(a2);
		ws.addCell(a3);
		ws.addCell(a4);
		ws.addCell(a5);
		ws.addCell(a6);
		j++;
	}

	Statistic st = new Statistic();
	Label a0 = new Label(0, j, "合计：");
	Label a1 = new Label(2, j, ""+st.getCounts(date)[0]);
	Label a2 = new Label(3, j, ""+st.getCounts(date)[1]);
	Label a3 = new Label(4, j, ""+st.getCounts(date)[4]);
	Label a4 = new Label(5, j, ""+st.getCounts(date)[3]);
	Label a5 = new Label(6, j, ""+st.getCounts(date)[2]);
	ws.addCell(a0);
	ws.addCell(a1);
	ws.addCell(a2);
	ws.addCell(a3);
	ws.addCell(a4);
	ws.addCell(a5);
	
	wwb.write();
	wwb.close();
	wb.close();	
}
catch (Exception e) {
	out.println(e.toString());
}
finally {
	os.close();
}
%>