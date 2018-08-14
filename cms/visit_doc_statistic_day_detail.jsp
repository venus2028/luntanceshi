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
<title>Dir visit day Statistic</title>
<script language="javascript" src="../inc/common.js"></script>
<script type="text/javascript" src="../util/jscalendar/calendar.js"></script>
<script type="text/javascript" src="../util/jscalendar/lang/calendar-zh.js"></script>
<script type="text/javascript" src="../util/jscalendar/calendar-setup.js"></script>
<style type="text/css"> @import url("../util/jscalendar/calendar-win2k-2.css"); </style>
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
	int pagesize = 30;
	Paginator paginator = new Paginator(request);
	int curpage = paginator.getCurPage();	
		
	VisitDocLogDb vdld = new VisitDocLogDb();
	String beginDate = ParamUtil.get(request, "beginDate");
	String endDate = ParamUtil.get(request, "endDate");
	int id = ParamUtil.getInt(request, "id");
	
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
	
	Date d = DateUtil.parse(beginDate, "yyyy-MM-dd 00:00:00");
	Date oldd = d;
	Date ed = DateUtil.parse(endDate, "yyyy-MM-dd HH:mm:ss");
	if (ed==null) {
		out.print(SkinUtil.makeErrMsg(request, "结束日期为：" + endDate + "非法，请选择结束日期"));
		return;
	}	
	
	Document doc = new Document();
	doc = doc.getDocument(id);	
%>
<table width="98%" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr> 
    <td height=20 align="left" class="thead">文章 - <%=doc.getTitle()%> 访问统计</td>
  </tr>
  <tr> 
    <td valign="top"><br>
      <TABLE width="92%" border=0 align=center cellPadding=0 cellSpacing=1>
      <TBODY>
      <form name="fmFilter" action="visit_doc_statistic_day_detail.jsp?op=search&id=<%=id%>" method="post">
        <TR>
          <TD height=23 colspan="7" align="center">&nbsp;
            <lt:Label res="res.label.forum.score_transfer" key="beginDate"/>
            <input type="text" id="beginDate" name="beginDate" size="20">
            <lt:Label res="res.label.forum.score_transfer" key="endDate"/>
            &nbsp;
            <input type="text" id="endDate" name="endDate" size="20">
<script type="text/javascript">
    function catcalc(cal) {
        var date = cal.date;
        var time = date.getTime()
        var field = document.getElementById("endDate");
        time += 31*Date.DAY; // add one week
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
            <input name="submit" type="submit" value="<lt:Label key="ok"/>"></TD>
        </TR>
      </form>
  </TBODY>
    </TABLE>
      <br>
      <%
	DefaultCategoryDataset dataset = new DefaultCategoryDataset();
	ResultIterator ri = null;
	ResultRecord rr = null;
	String sql = "select count(*) from " + vdld.getTable().getName() + " where doc_id=? and add_date>=? and add_date<?";
	int dayCount = 0;
	JdbcTemplate jt = new JdbcTemplate();
	d = DateUtil.addDate(d, 1);
	while (DateUtil.datediffMinute(ed, d)>=-1) {
		ri = jt.executeQuery(sql, new Object[] {new Integer(id), oldd, d});
		if (ri.hasNext()) {
			rr = (ResultRecord)ri.next();
			dataset.addValue(rr.getInt(1), "日期", DateUtil.format(oldd, "MM-dd"));		
		}
		oldd = d;
		d = DateUtil.addDate(d, 1);
		dayCount++;
	}%>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center"><%
JFreeChart chart = ChartFactory.createBarChart3D("文章日访问统计图", 
                  "日期",
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
if (dayCount>0)
	w = 80*dayCount;
			  
String filename = ServletUtilities.saveChartAsPNG(chart, w, 400, null, session);
String graphURL = request.getContextPath() + "/servlet/DisplayChart?filename=" + filename;
%>
      <img src="<%=graphURL%>" height=400 border=0 usemap="#<%= filename %>"> </td>
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
</html>                            
  