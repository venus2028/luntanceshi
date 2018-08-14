<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="java.awt.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ page import="cn.js.fan.base.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.util.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="org.jfree.chart.*" %>
<%@ page import="org.jfree.chart.axis.*" %>
<%@ page import="org.jfree.chart.labels.*" %>
<%@ page import="org.jfree.chart.plot.*" %>
<%@ page import="org.jfree.chart.renderer.*" %>
<%@ page import="org.jfree.chart.renderer.category.*" %>
<%@ page import="org.jfree.data.category.*" %>
<%@ page import="org.jfree.chart.servlet.ServletUtilities" %>
<%@ page import="org.jfree.ui.TextAnchor" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="pragma" content="no-cache">
<link rel="stylesheet" href="../common.css">
<LINK href="default.css" type=text/css rel=stylesheet>
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Topic Statistic</title>
<script language="javascript" src="../../inc/common.js"></script>
<script type="text/javascript" src="../../util/jscalendar/calendar.js"></script>
<script type="text/javascript" src="../../util/jscalendar/lang/calendar-zh.js"></script>
<script type="text/javascript" src="../../util/jscalendar/calendar-setup.js"></script>
<style type="text/css"> @import url("../../util/jscalendar/calendar-win2k-2.css"); </style>
</head>
<body bgcolor="#FFFFFF" topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String op = ParamUtil.get(request, "op");
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">统计</td>
  </tr>
</table>
<%		
	VisitTopicLogDb bvld = new VisitTopicLogDb();
	String beginDate = ParamUtil.get(request, "beginDate");
	String endDate = ParamUtil.get(request, "endDate");

	if (op.equals("del")) {
		java.util.Date dDate = DateUtil.parse(endDate, "yyyy-MM-dd HH:mm:ss");
		if (dDate==null) {
			out.print(StrUtil.Alert_Back("请填写正确要删除的记录的结束日期！"));
			return;
		}
		String sql = "delete from " + bvld.getTable().getName() + " where is_blog=1 and add_date<=?";
		if (beginDate.equals("")) {
			JdbcTemplate jt = new JdbcTemplate();
			jt.executeUpdate(sql, new Object[] {dDate});
		}
		else {
			sql += " and add_date>=?";
			java.util.Date bDate = DateUtil.parse(beginDate, "yyyy-MM-dd HH:mm:ss");
			if (dDate==null) {
				out.print(StrUtil.Alert_Back("请填写正确要删除的记录的开始日期！"));
				return;
			}
			JdbcTemplate jt = new JdbcTemplate();
			jt.executeUpdate(sql, new Object[] {dDate, bDate});
		}
		out.print(StrUtil.Alert_Redirect("操作成功！", "visit_topic_statistic.jsp"));
		return;
	}	
	if (op.equals("")) {
		if (beginDate.equals("")) {
			Calendar cal = Calendar.getInstance();
			cal.set(Calendar.DAY_OF_MONTH, 1);
			
			beginDate = DateUtil.format(cal, "yyyy-MM-dd 00:00:00");
		}
		if (endDate.equals("")) {
			endDate = DateUtil.format(new java.util.Date(), "yyyy-MM-dd 23:59:59");
		}
	}
	
	String sql = "select count(*) as s, topic_id from " + bvld.getTable().getName() + " where is_blog=1";
	JdbcTemplate jt = new JdbcTemplate();
	ResultIterator ri = null;
	if (!beginDate.equals("")) {
		sql += " and add_date>=?";
	}
	if (!endDate.equals("")) {
		sql += " and add_date<=?";
	}
	sql += " group by topic_id order by s desc";
	// out.print(sql + "---" + beginDate + "---" + endDate);
	int pageSize = ParamUtil.getInt(request, "pageSize", 20);
	if (beginDate.equals("") && endDate.equals(""))
		ri = jt.executeQuery(sql, 1, pageSize);
	else if (beginDate.equals("") && !endDate.equals("")) {
		ri = jt.executeQuery(sql, new Object[] {DateUtil.parse(endDate, "yyyy-MM-dd HH:mm:ss")}, 1, pageSize);
	}
	else if (!beginDate.equals("") && endDate.equals("")) {
		ri = jt.executeQuery(sql, new Object[] {DateUtil.parse(beginDate, "yyyy-MM-dd HH:mm:ss")}, 1, pageSize);
	}
	else {
		ri = jt.executeQuery(sql, new Object[] {DateUtil.parse(beginDate, "yyyy-MM-dd HH:mm:ss"), DateUtil.parse(endDate, "yyyy-MM-dd HH:mm:ss")}, 1, pageSize);
	}
%>
<br>
<table width="98%" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr> 
    <td height=20 align="left" class="thead">文章访问统计</td>
  </tr>
  <tr> 
    <td valign="top"><br>
      <TABLE width="92%" border=0 align=center cellPadding=0 cellSpacing=1>
      <TBODY>
      <form name="fmFilter" action="visit_topic_statistic.jsp?op=search" method="post">
        <TR>
          <TD height=23 colspan="7" align="center">&nbsp;
            <lt:Label res="res.label.forum.score_transfer" key="beginDate"/>
            <input type="text" id="beginDate" name="beginDate" size="20">
            &nbsp;
            <lt:Label res="res.label.forum.score_transfer" key="endDate"/>
            <input type="text" id="endDate" name="endDate" size="20">
            &nbsp;显示前
            <input name="pageSize" value="<%=pageSize%>" size="3">条
            <script type="text/javascript">
    function catcalc(cal) {
        var date = cal.date;
        var time = date.getTime()
        // use the _other_ field
        var field = document.getElementById("endDate");
        time += 31*Date.DAY;
        var date2 = new Date(time);
        field.value = date2.print("%Y-%m-%d %H:%M:00");
    }

    Calendar.setup({
        inputField     :    "beginDate",      // id of the input field
        ifFormat       :    "%Y-%m-%d %H:%M:00",       // format of the input field
        showsTime      :    true,            // will display a time selector
        singleClick    :    false,           // double-click mode
        align          :    "Tl",           // alignment (defaults to "Bl")		
        step           :    1,                // show all years in drop-down boxes (instead of every other year as default)
		onUpdate       :    catcalc
    });

    Calendar.setup({
        inputField     :    "endDate",      // id of the input field
        ifFormat       :    "%Y-%m-%d %H:%M:00",       // format of the input field
        showsTime      :    true,            // will display a time selector
        singleClick    :    false,           // double-click mode
        align          :    "Tl",           // alignment (defaults to "Bl")		
        step           :    1                // show all years in drop-down boxes (instead of every other year as default)
    });
		
	fmFilter.beginDate.value = "<%=beginDate%>";
	fmFilter.endDate.value = "<%=endDate%>";
</script>
            <input name="submit" type="submit" value="<lt:Label key="ok"/>">
&nbsp;
<input name="button" type="button" onClick="del()" value="删除"></TD>
        </TR>
      </form>
  </TBODY>
    </TABLE>
      <br>
      <table width="95%" border="0" align="center">
      <tr>
        <td align="right">&nbsp;</td>
      </tr>
    </table>
      <table width="82%"  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#CCCCCC">
      <tr align="center" bgcolor="#F8F7F9">
        <td width="41%" height="24" bgcolor="#EFEBDE">
          文章        </td>
        <td width="23%" bgcolor="#EFEBDE">作者</td>
        <td width="17%" bgcolor="#EFEBDE">
          访问量        </td>
        <td width="19%" bgcolor="#EFEBDE">日访问量</td>
      </tr>
	<%
	DefaultCategoryDataset dataset = new DefaultCategoryDataset();
	MsgDb md = null;
	MsgMgr mm = new MsgMgr();
	UserMgr um = new UserMgr();	
	String title = "";
	while (ri.hasNext()) {
		ResultRecord rr = (ResultRecord)ri.next();
		// System.out.println(getClass() + " " + rr.getInt(2));
		md = mm.getMsgDb(rr.getLong(2));
		title = md.getTitle();
		dataset.addValue(rr.getInt(1), "贴子", title);		
	%>
      <tr align="center">
        <td height="24" align="left" bgcolor="#FFF7FF">
		<a href="../showblog.jsp?rootid=<%=md.getId()%>" target="_blank"><%=title%></a>		</td>
        <td align="left" bgcolor="#FFF7FF"><a target="_blank" href="../../userinfo.jsp?username=<%=StrUtil.UrlEncode(md.getName())%>"><%=um.getUser(md.getName()).getNick()%></a></td>
        <td align="left" bgcolor="#FFF7FF"><%=rr.getInt(1)%></td>
        <td align="center" bgcolor="#FFF7FF"><a href="visit_topic_statistic_day_detail.jsp?id=<%=md.getId()%>&beginDate=<%=StrUtil.UrlEncode(beginDate)%>&endDate=<%=StrUtil.UrlEncode(endDate)%>">查看</a></td>
      </tr>
	<%}%>
    </table>
      <table width="82%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
        <tr>
          <td height="23" align="right">&nbsp;
 </td>
        </tr>
      </table>
	  
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center"><%
JFreeChart chart = ChartFactory.createBarChart3D("文章访问统计图", 
                  "贴子",
                  "访问量",
                  dataset,
                  PlotOrientation.VERTICAL,
                  false,
                  false,
                  false);
BarRenderer3D renderer = new BarRenderer3D();
// 设置柱的颜色
CategoryPlot plot = chart.getCategoryPlot();
renderer.setSeriesPaint(0, new Color(0xff00));

renderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
renderer.setBaseItemLabelsVisible(true);
renderer.setBasePositiveItemLabelPosition(new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BASELINE_LEFT));
renderer.setItemLabelAnchorOffset(10D);
renderer.setItemMargin(0.1);

plot.setRenderer(renderer);

int w = 600;
if (ri.size()>0) {
	w = 80*ri.size();
}				  
String filename = ServletUtilities.saveChartAsPNG(chart, w, 300, null, session);
String graphURL = request.getContextPath() + "/servlet/DisplayChart?filename=" + filename;
%>
      <img src="<%= graphURL %>" height=300 border=0 usemap="#<%= filename %>"> </td>
  </tr>
</table> 
    <br></td>
  </tr>
</table>
</td> </tr>             
      </table>                                        
       </td>                                        
     </tr>                                        
 </table>                                        
</body>                                        
<script>
function del() {
	if (confirm("您确定要删除吗？")) {
		window.location.href = "visit_topic_statistic.jsp?op=del&beginDate=" + fmFilter.beginDate.value + "&endDate=" + fmFilter.endDate.value;
	}
}
</script>
</html>                            
  