<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="java.awt.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ page import="cn.js.fan.base.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.cms.util.*"%>
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
<title>Doc Statistic</title>
<script language="javascript" src="../inc/common.js"></script>
<script type="text/javascript" src="../util/jscalendar/calendar.js"></script>
<script type="text/javascript" src="../util/jscalendar/lang/calendar-zh.js"></script>
<script type="text/javascript" src="../util/jscalendar/calendar-setup.js"></script>
<style type="text/css"> @import url("../util/jscalendar/calendar-win2k-2.css"); </style>
</head>
<body bgcolor="#FFFFFF" topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<DIV id="tabBar">
  <div class="tabs">
    <ul>
      <li id="menu1"><a href="<%=request.getContextPath()%>/cms/counter/showcount.jsp">首页访问统计</a></li>
      <li id="menu2"><a href="<%=request.getContextPath()%>/cms/visit_column_statistic.jsp">栏目访问统计</a></li>
      <li id="menu3"><a href="<%=request.getContextPath()%>/cms/visit_dir_statistic.jsp">目录访问统计</a></li>
      <li id="menu4"><a href="<%=request.getContextPath()%>/cms/visit_doc_statistic.jsp">文章访问统计</a></li>
      <li id="menu5"><a href="<%=request.getContextPath()%>/cms/visit_ip_statistic.jsp">来访者位置</a></li>
    </ul>
  </div>
</DIV>
<script>
$("menu4").className="active"; 
</script>
<%
if (!privilege.isMasterLogin(request)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String op = ParamUtil.get(request, "op");
%>
<%		
	VisitDocLogDb bvld = new VisitDocLogDb();
	String beginDate = ParamUtil.get(request, "beginDate");
	String endDate = ParamUtil.get(request, "endDate");
	
	if (op.equals("del")) {
		java.util.Date dDate = DateUtil.parse(endDate, "yyyy-MM-dd HH:mm:ss");
		if (dDate==null) {
			out.print(StrUtil.Alert_Back("请填写正确要删除的记录的结束日期！"));
			return;
		}
		String sql = "delete from " + bvld.getTable().getName() + " where add_date<=?";
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
		out.print(StrUtil.Alert_Redirect("操作成功！", "visit_doc_statistic.jsp"));
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
	
	String sql = "select count(*) as s, doc_id from " + bvld.getTable().getName();
	JdbcTemplate jt = new JdbcTemplate();
	ResultIterator ri = null;
	if (!beginDate.equals("")) {
		sql += " where add_date>=?";
	}
	if (!endDate.equals("")) {
		if (!beginDate.equals(""))
			sql += " and add_date<=?";
		else
			sql += " where add_date<=?";
	}
	sql += " group by doc_id order by s desc";
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
<table width="98%" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr> 
    <td height=20 align="left" class="thead">文章访问统计</td>
  </tr>
  <tr> 
    <td valign="top"><br>
      <form name="fmFilter" action="visit_doc_statistic.jsp?op=search" method="post">
      <TABLE width="92%" border=0 align=center cellPadding=0 cellSpacing=1>
      <TBODY>
        <TR>
          <TD height=23 colspan="7" align="center">&nbsp;
            <lt:Label res="res.label.forum.score_transfer" key="beginDate"/>
            <input type="text" id="beginDate" name="beginDate" size="20">
            &nbsp;
            <lt:Label res="res.label.forum.score_transfer" key="endDate"/>
            <input type="text" id="endDate" name="endDate" size="20">
            显示前<input name="pageSize" value="<%=pageSize%>" size="3">条
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
            <input type="button" value="删除" onClick="del()"></TD>
        </TR>
  </TBODY>
    </TABLE></form>
      <br>
      <table width="95%" border="0" align="center">
      <tr>
        <td align="right">&nbsp;</td>
      </tr>
    </table>
      <table width="82%"  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#CCCCCC">
      <tr align="center" bgcolor="#F8F7F9">
        <td width="55%" height="24" bgcolor="#EFEBDE">
          文章        </td>
        <td width="21%" bgcolor="#EFEBDE">发布日期</td>
        <td width="11%" bgcolor="#EFEBDE">
          访问量        </td>
        <td width="13%" bgcolor="#EFEBDE">查看</td>
      </tr>
	<%
	DefaultCategoryDataset dataset = new DefaultCategoryDataset();
	Document doc = null;
	DocumentMgr dm = new DocumentMgr();
	String title = "";
	while (ri.hasNext()) {
		ResultRecord rr = (ResultRecord)ri.next();
		// System.out.println(getClass() + " " + rr.getInt(2));
		doc = dm.getDocument(rr.getInt(2));
		if (doc==null)
			continue;
		title = doc.getTitle();
		dataset.addValue(rr.getInt(1), "文章", title);		
	%>
      <tr align="center">
        <td height="24" align="left" bgcolor="#FFF7FF">
		<a target="_blank" href="../doc_view.jsp?id=<%=doc.getId()%>&beginDate=<%=StrUtil.UrlEncode(beginDate)%>&endDate=<%=StrUtil.UrlEncode(endDate)%>"><%=title%></a>		</td>
        <td align="left" bgcolor="#FFF7FF"><%=DateUtil.format(doc.getCreateDate(), "yyyy-MM-dd")%></td>
        <td align="left" bgcolor="#FFF7FF"><%=rr.getInt(1)%></td>
        <td align="center" bgcolor="#FFF7FF"><a href="visit_doc_statistic_day_detail.jsp?id=<%=doc.getId()%>&beginDate=<%=StrUtil.UrlEncode(beginDate)%>&endDate=<%=StrUtil.UrlEncode(endDate)%>">日访问量</a></td>
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
                  "文章",
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
		window.location.href = "visit_doc_statistic.jsp?op=del&beginDate=" + fmFilter.beginDate.value + "&endDate=" + fmFilter.endDate.value;
	}
}
</script>                      
</html>                            
  