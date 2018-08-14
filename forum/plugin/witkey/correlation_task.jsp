<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.plugin.witkey.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String skinPath = SkinMgr.getSkinPath(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../../<%=skinPath%>/css.css" rel="stylesheet" type="text/css">
<title>相关任务</title>
</head>
<body>
<div id="wrapper">
<%@ include file="../../inc/header.jsp"%>
<div id="main">
<%@ include file="../../inc/position.jsp"%>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
	// 安全验证
	String querystring = StrUtil.getNullString(request.getQueryString());
	String privurl=request.getRequestURL()+"?"+StrUtil.UrlEncode(querystring,"utf-8");
	if (!privilege.isUserLogin(request))
	{
		response.sendRedirect("../../../door.jsp");
		return;
	}
	
	String catalogCode = ParamUtil.get(request, "catalogCode");
	if (catalogCode.equals("")) {
		out.print(SkinUtil.makeErrMsg(request, "缺少类别信息！"));
		return;
	}
		
	String sql = "select msg_root_id from plugin_witkey where catalog_code=" + StrUtil.sqlstr(catalogCode) + " and end_date>" + StrUtil.sqlstr(Long.toString(System.currentTimeMillis() - 24*60*60*1000)) + " order by level desc";
	
	WitkeyDb wd = new WitkeyDb();
	int pagesize = 10;
	Paginator paginator = new Paginator(request);
	int curpage = paginator.getCurPage();
				
	ListResult lr = wd.listResult(sql, curpage, pagesize);
	int total = lr.getTotal();
	Vector v = lr.getResult();
	Iterator ir = null;
	if (v!=null)
		ir = v.iterator();
	paginator.init(total, pagesize);
	// 设置当前页数和总页数
	int totalpages = paginator.getTotalPages();
	if (totalpages==0)
	{
		curpage = 1;
		totalpages = 1;
	}
%>
  <div class="tableTitle">威客相关任务列表</div>    
  <TABLE class="tableCommon" width="80%">
    <thead>
      <TR> 
        <TD width=10% align="center">编号</TD>
        <TD width=36% align="center">任务标题</TD>
        <TD width=9% align="center">报名人数</TD>
        <TD width=10% align="center">交稿个数</TD>
        <TD width=10% align="center">交易种类</TD>
        <TD width=8% align="center">金额</TD>
        <TD width=10% align="center">结束时间</TD>
        <TD width=7% align="center">推荐级别</TD>
      </TR>
	</thead>
<%		
        MsgDb md = new MsgDb();
		ScoreMgr sm = new ScoreMgr();
		while (ir.hasNext())
		{
			wd = (WitkeyDb)ir.next();
			md = md.getMsgDb(wd.getMsgRootId());
			ScoreUnit su = sm.getScoreUnit(wd.getMoneyCode());
			
			Timestamp ts = new Timestamp(Long.parseLong(wd.getEndDate()));
%>
      <TR> 
        <TD height=23><%=wd.getMsgRootId()%></TD>
        <TD height=23><a href="../../showtopic.jsp?rootid=<%=wd.getMsgRootId()%>"><%=StrUtil.toHtml(md.getTitle())%></TD>
        <TD height=23><%=wd.getUserCount()%></TD>
        <TD height=23><%=wd.getContributionCount()%></TD>
        <TD height=23><%=su.getName()%></TD>
        <TD height=23><%=wd.getScore()%></TD>
        <TD height=23><%=DateUtil.format(DateUtil.parse(ts.toString(), "yyyy-MM-dd"), "yyyy-MM-dd")%></TD>
        <TD height=23><%=wd.getLevel()%>级</TD>
      </TR>
<%
		}
%>
    </TBODY>
  </TABLE>
  <table class="per100" width="80%" align="center"> 
    <tr> 
      <td align="right"><%
				String querystr = "";
				out.print(paginator.getCurPageBlock(request, "witkey_correlation_task.jsp?"+querystr));
				%></td>
    </tr>
</table>
</div>
<%@ include file="../../inc/footer.jsp"%>
</div>
</body>
</html>
