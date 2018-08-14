<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.base.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.plugin.reply.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String skincode = UserSet.getSkin(request);
if (skincode.equals(""))
	skincode = UserSet.defaultSkin;
SkinMgr skm = new SkinMgr();
Skin skin = skm.getSkin(skincode);
if (skin==null)
	skin = skm.getSkin(UserSet.defaultSkin);
String skinPath = skin.getPath();

String orderBy = ParamUtil.get(request, "orderBy");
if (orderBy.equals(""))
	orderBy = "reply_ratio";
String sort = ParamUtil.get(request, "sort");
if (sort.equals(""))
	sort = "desc";
	
String op = ParamUtil.get(request, "op");

Calendar cal = Calendar.getInstance();
int curYear = cal.get(Calendar.YEAR);
int curMonth = cal.get(Calendar.MONTH);
int showYear = ParamUtil.getInt(request, "showYear", curYear);
int showMonth = ParamUtil.getInt(request, "showMonth", curMonth);
int viewMonth = showMonth + 1;
cal.set(showYear, showMonth, 1, 0, 0, 0);
java.util.Date d1 = cal.getTime();
cal.set(showYear, 0, 1, 0, 0, 0);
java.util.Date firstDay = cal.getTime();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<link href="../../<%=skinPath%>/skin.css" rel="stylesheet" type="text/css">
<title><%=showYear%>年<%=viewMonth%>月单位回复情况一览表 - <%=Global.AppName%></title>
<style type="text/css">
<!--
body {
	margin-top: 0px;
	margin-left: 0px;
	margin-right: 0px;
}
-->
</style>
<script src="inc/common.js"></script>
<script>
var curOrderBy = "<%=orderBy%>";
var sort = "<%=sort%>";
function doSort(orderBy) {
	if (orderBy==curOrderBy)
		if (sort=="asc")
			sort = "desc";
		else
			sort = "asc";
			
	window.location.href = "reply_stat_list.jsp?op=<%=op%>&showYear=<%=showYear%>&showMonth=<%=showMonth%>&orderBy=" + orderBy + "&sort=" + sort;
}
</script>
</head>
<body>
<%@ include file="../../inc/header.jsp"%>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<div id="newdiv" name="newdiv">
<%
if (!privilege.isUserLogin(request)) {
	// response.sendRedirect("../../../info.jsp?info=" + StrUtil.UrlEncode(SkinUtil.LoadString(request, "pvg_invalid")));
	// return;
}
%>
  <div align="center"><br>
    <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#EDECED">
	<form name="formSearch" action="reply_stat_list.jsp" method="get">	
      <tr>
        <td align="center" bgcolor="#F8F8F8">
		请选择时间
		<select name="showYear">
		<%for (int i=curYear; i>=2009; i--) {%>
		<option value="<%=i%>"><%=i%></option>
		<%}%>
		</select>
		&nbsp;
		<select name="showMonth">
		<%for (int i=0; i<=11; i++) {%>
		<option value="<%=i%>"><%=i+1%></option>
		<%}%>
		</select>
		<script>
		formSearch.showYear.value = "<%=showYear%>";
		formSearch.showMonth.value = "<%=showMonth%>";
		</script>
		&nbsp;
		<input type="submit" value="确定" />
		</td>
        </tr>
  	</form>
    </table>
    <strong><font color="#6666DF"><br>
    <%=showYear%>年<%=viewMonth%>月单位回复情况一览表</font><br>
    </strong></div>
  <%				
  	ReplyStatDb asd = new ReplyStatDb();
	String sql = "select boardcode,mydate from " + asd.getTable().getName() + " where mydate=?";
		
	if (op.equals("search")) {
			
	}
	sql += " ORDER BY " + orderBy + " " + sort;		
	
	int pagesize = 100;
		
	Paginator paginator = new Paginator(request);
	
	int curpage = paginator.getCurPage();
	
	ListResult lr = asd.listResult(sql, new Object[] {d1}, curpage, pagesize );	
	paginator.init(lr.getTotal(), pagesize);
	
	Iterator ir = lr.getResult().iterator();
	
	// 设置当前页数和总页数
	int totalpages = paginator.getTotalPages();
	if (totalpages==0) {
		curpage = 1;
		totalpages = 1;
	}
%>
  <table width="98%" border="0" align="center" class="p9">
    <tr>
      <td width="36%" align="left">&nbsp;</td>
      <td width="64%" align="right"><%=paginator.getPageStatics(request)%></td>
    </tr>
  </table>    
  <TABLE width="98%" border=0 align=center cellPadding=0 cellSpacing=1 bgcolor="#edeced">
    <TBODY>
      <TR align=center bgColor=#f8f8f8> 
        <TD width=10% rowspan="2"><strong>版块</strong></TD>
        <TD width=3% rowspan="2"><strong>
        月份</strong></TD>
        <TD width=6% rowspan="2" style="cursor:hand" onClick="doSort('lastTime')"><strong>需回复
            <span style="cursor:hand">
            <%if (orderBy.equals("lastTime")) {
			if (sort.equals("asc")) 
				out.print("<img src='forum/admin/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='forum/admin/images/arrow_down.gif' width=8px height=7px>");
		}%>
        </span></strong></TD>
        <TD width=7% rowspan="2"><strong>已回复</strong></TD>
        <TD width=12% rowspan="2"><strong>未回复</strong></TD>
        <TD width=7% rowspan="2" style="cursor:hand" onClick="doSort('RegDate')"><strong>
          过时未回复</strong>
		  <%if (orderBy.equals("RegDate")) {
			if (sort.equals("asc")) 
				out.print("<img src='forum/admin/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='forum/admin/images/arrow_down.gif' width=8px height=7px>");
		}%>		</TD>
        <TD width=7% rowspan="2" style="cursor:hand" onClick="doSort('RegDate')"><strong>回复率</strong></TD>
        <TD width=9% rowspan="2" style="cursor:hand" onClick="doSort('RegDate')"><strong>满意度<br>
        （平均得分）</strong></TD>
        <TD height="23" colspan="5" style="cursor:hand" onClick="doSort('RegDate')"><strong>1月份-<%=viewMonth%>月份累计</strong></TD>
      </TR>
      <TR align=center bgColor=#f8f8f8>
        <TD height="23" style="cursor:hand" onClick="doSort('RegDate')"><strong>需回复</strong></TD>
        <TD><strong>已回复</strong></TD>
        <TD><strong>未回复</strong></TD>
        <TD><strong>平均回复率</strong></TD>
        <TD><strong>平均满意度</strong></TD>
      </TR>
      <%		
int i=0;
Directory dir = new Directory();
JdbcTemplate jt = null;
if (lr.getResult().size()>0)
	jt = new JdbcTemplate();
ResultIterator ri;
while (ir.hasNext()) {
 	    asd = (ReplyStatDb)ir.next(); 
	    i++;
		Leaf lf = dir.getLeaf(asd.getString("boardcode"));
		if (lf==null)
			continue;
%>
      <TR align=center onmouseover="this.style.backgroundColor='#f1f8fb'" onmouseout="this.style.backgroundColor='#ffffff'"> 
        <TD height=23 align="left" bgcolor="#FFFFFF"><%=lf.getName()%></TD>
        <TD width=3% height=23 bgcolor="#FFFFFF"><%=viewMonth%></TD>
        <TD width=6% height=23 align="center" bgcolor="#FFFFFF"><%=asd.getInt("msg_count")%></TD>
        <TD width=7% bgcolor="#FFFFFF"><%=asd.getInt("reply_count")%></TD>
        <TD width=12% bgcolor="#FFFFFF"><%=asd.getInt("not_reply_count")%></TD>
        <TD width=7% height=23 bgcolor="#FFFFFF"><%=asd.getInt("expire_count")%></TD>
        <TD width=7% bgcolor="#FFFFFF"><%=NumberUtil.round(asd.getDouble("reply_ratio")*100, 1)%>%</TD>
        <TD width=9% bgcolor="#FFFFFF"><%=asd.getInt("score_average")%></TD>
<%
	int sumMsgCount = 0;
	int sumReplyCount = 0;
	int sumNotReplyCount = 0;
	double replyRatioAverage = 0.0;
	int scoreAverage = 0;
	
	sql = "select sum(msg_count) from " + asd.getTable().getName() + " where boardcode=? and mydate>=? and mydate<=? group by boardcode";
	ri = jt.executeQuery(sql, new Object[]{lf.getCode(), firstDay, d1});
	if (ri.hasNext()) {
		ResultRecord rr = (ResultRecord)ri.next();
		sumMsgCount = (int)rr.getDouble(1);
	}
	sql = "select sum(reply_count) from " + asd.getTable().getName() + " where boardcode=? and mydate>=? and mydate<=? group by boardcode";
	ri = jt.executeQuery(sql, new Object[]{lf.getCode(), firstDay, d1});
	if (ri.hasNext()) {
		ResultRecord rr = (ResultRecord)ri.next();
		sumReplyCount = (int)rr.getDouble(1);
	}
	sumNotReplyCount = sumMsgCount - sumReplyCount;
	if (sumMsgCount>0)
		replyRatioAverage = ((double)sumReplyCount)/sumMsgCount;
	sql = "select sum(score_average) from " + asd.getTable().getName() + " where boardcode=? and mydate>=? and mydate<=? group by boardcode";
	ri = jt.executeQuery(sql, new Object[]{lf.getCode(), firstDay, d1});
	if (ri.hasNext()) {
		ResultRecord rr = (ResultRecord)ri.next();
		scoreAverage = (int)(rr.getDouble(1) / showMonth);
	}	
%>		
		
        <TD width=8% bgcolor="#FFFFFF"><%=sumMsgCount%></TD>
        <TD width=8% bgcolor="#FFFFFF"><%=sumReplyCount%></TD>
        <TD width=8% bgcolor="#FFFFFF"><%=sumNotReplyCount%></TD>
        <TD width=7% bgcolor="#FFFFFF"><%=NumberUtil.round(replyRatioAverage*100, 1)%>%</TD>
        <TD width=8% bgcolor="#FFFFFF"><%=scoreAverage%></TD>
      </TR>
<%}%>
    </TBODY>
  </TABLE>
  <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center">
    <tr> 
      <td height="23" align="right">
    <%
	  String querystr = "op=" + op + "&showYear=" + showYear + "&showMonth=" + showMonth + "&orderBy=" + orderBy + "&sort=" + sort;
 	  out.print(paginator.getCurPageBlock("reply_stat_list.jsp?"+querystr));
	%></td>
    </tr>
  </table>
</div>
<%@ include file="../../inc/footer.jsp"%>
</body>
</html>
