<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.cloudwebsoft.framework.web.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<HTML><HEAD><TITLE><lt:Label res="res.label.cms.main" key="title"/></TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8"><LINK 
href="images/default.css" type=text/css rel=stylesheet>
<script type="text/javascript" src="../util/jscalendar/calendar.js"></script>
<script type="text/javascript" src="../util/jscalendar/lang/calendar-zh.js"></script>
<script type="text/javascript" src="../util/jscalendar/calendar-setup.js"></script>
<style type="text/css"> @import url("../util/jscalendar/calendar-win2k-2.css"); </style>
</HEAD>
<BODY text=#000000 bgColor=#eeeeee leftMargin=0 topMargin=0>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserLogin(request)) {
	out.println(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

User user = new User();
user = user.getUser(privilege.getUser(request));

// 检查是否为子站点管理员
/*
SiteDb sd = new SiteDb();
cn.js.fan.module.pvg.User user = new cn.js.fan.module.pvg.User();
user = user.getUser(privilege.getUser(request));
Vector vsite = new Vector();
if (user.isForegroundUser()) {
	com.redmoon.forum.person.UserDb ud = new com.redmoon.forum.person.UserDb();
	ud = ud.getUserDbByNick(user.getName());
	vsite = sd.getSubsitesOfUser(ud.getName());
	if (vsite.size()>0) {
		response.sendRedirect("site/site.jsp?siteCode=" + ((SiteDb)vsite.elementAt(0)).getString("code"));
		return;
	}
}
*/

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

name = user.getName();
realname = user.getRealName();

%>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
  <TR>
    <TD class=head><lt:Label res="res.label.cms.main" key="msg"/></TD>
  </TR></TBODY></TABLE><BR><!-- ACP Page Header End -->
<STYLE type=text/css>.tab {
	PADDING-RIGHT: 30px; PADDING-LEFT: 10px; FONT-SIZE: 12px; PADDING-BOTTOM: 1px; CURSOR: hand; PADDING-TOP: 5px; LETTER-SPACING: 1px
}
</STYLE>
<TABLE cellSpacing=0 cellPadding=0 width="95%" align=center border=0>
  <TBODY>
  <TR>
    <TD style="PADDING-LEFT: 2px; HEIGHT: 22px" 
    background=images/tab_top_bg.gif>
      <TABLE cellSpacing=0 cellPadding=0 border=0>
        <TBODY>
        <TR>
          <TD>
            <TABLE height=22 cellSpacing=0 cellPadding=0 border=0>
              <TBODY>
              <TR>
                <TD width=3><IMG id=tabImgLeft__0 height=22 
                  src="images/tab_active_left.gif" width=3></TD>
                <TD class=tab id=tabLabel__0 
                background=images/tab_active_bg.gif 
                  UNSELECTABLE="on">信息</TD>
                <TD width=3><IMG id=tabImgRight__0 height=22 
                  src="images/tab_active_right.gif" 
              width=3></TD></TR></TBODY></TABLE></TD>
          <TD>&nbsp;            </TD>
        </TR></TBODY></TABLE></TD></TR>
  <TR>
    <TD bgColor=#ffffff>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD width=1 background=images/tab_bg.gif><IMG height=1 
            src="images/tab_bg.gif" width=1></TD>
          <TD 
          style="PADDING-RIGHT: 15px; PADDING-LEFT: 15px; PADDING-BOTTOM: 15px; PADDING-TOP: 15px; HEIGHT: 350px" 
          vAlign=top>
            <br>
            <TABLE cellSpacing=0 cellPadding=0 width="98%" align=center>
              <TBODY>
                <TR>
                  <TD align=left><%=user.getRealName()%> ，登录次数：<%=user.getEnterCount()%>，最后登录时间：<%=DateUtil.format(user.getEnterLast(), "yy-MM-dd HH:mm")%> </TD>
                </TR>
              </TBODY>
            </TABLE>
            <br>
            <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr>
                <td>根据日期查看统计数：
                  <input type="text" id="date" name="date" size="10" value="<%=DateUtil.format(date, "yyyy-MM-dd")%>" onChange="window.location.href='main_common.jsp?date='+this.value">
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
 ，<a href="doc_statistic_user.jsp?userName=<%=StrUtil.UrlEncode(name)%>" target="_blank">查看详细</a> </td>
              </tr>
            </table>
            <br>
            <table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="98%" align="center">
              <tbody>
                <tr>
                  <td width="17%" noWrap class="thead" style="PADDING-LEFT: 10px">当年发表数</td>
                  <td width="18%" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="images/tl.gif" align="absMiddle" width="10" height="15">当月发表数</td>
                  <td width="19%" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="images/tl.gif" align="absMiddle" width="10" height="15">前两天发表数</td>
                  <td width="17%" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="images/tl.gif" align="absMiddle" width="10" height="15">前一天发表数</td>
                  <td width="18%" noWrap class="thead" style="PADDING-LEFT: 10px"><img src="images/tl.gif" align="absMiddle" width="10" height="15">当天发表数</td>
                </tr>
                <%					
		
		int daysOfYear = DateUtil.getDaysOfYear(y);
		java.util.Date tempd = DateUtil.addDate(year, daysOfYear);
		tempd = DateUtil.addMinuteDate(tempd, -1);
		
		JdbcTemplate rmconn = new JdbcTemplate();
					
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
		
		sqlCountByYesterday= " select count(*) from document where createDate >= " + StrUtil.sqlstr(Long.toString(today.getTime()-24*60*60000)) + " and createDate < " + StrUtil.sqlstr(Long.toString(today.getTime())) + " and nick = " + StrUtil.sqlstr(name);
		ResultIterator ri_yesterday = rmconn.executeQuery(sqlCountByYesterday);
		ResultRecord rr_yesterday = null;
		if (ri_yesterday.hasNext()) {
			rr_yesterday = (ResultRecord)ri_yesterday.next();
			CountByYesterday = rr_yesterday.getString(1);
		}
		
		sqlCountByBYesterday= " select count(*) from document where createDate >= " + StrUtil.sqlstr(Long.toString(today.getTime()-2*24*60*60000)) + " and createDate < " + StrUtil.sqlstr(Long.toString(today.getTime()-24*60*60000)) + " and nick = " + StrUtil.sqlstr(name);
		ResultIterator ri_byesterday = rmconn.executeQuery(sqlCountByBYesterday);
		ResultRecord rr_byesterday = null;
		if (ri_byesterday.hasNext()) {
			rr_byesterday = (ResultRecord)ri_byesterday.next();
			CountByBYesterday = rr_byesterday.getString(1);
		}
%>
                <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1">
                  <td style="PADDING-LEFT: 10px"><%=CountByYear%></td>
                  <td style="PADDING-LEFT: 10px"><%=CountByMonth%></td>
                  <td style="PADDING-LEFT: 10px"><%=CountByBYesterday%></td>
                  <td style="PADDING-LEFT: 10px"><%=CountByYesterday%></td>
                  <td style="PADDING-LEFT: 10px"><%=CountByToday%></td>
                </tr>
              </tbody>
            </table>
            <br>
            <TABLE cellSpacing=0 cellPadding=0 width="98%" align=center>
              <TBODY>
                <TR>
                  <TD align=left>最近更新的文章：</TD>
                </TR>
              </TBODY>
            </TABLE>
            <br>
            <table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="98%" align="center">
              <tr>
                <td width="9%" align="center" nowrap class="thead" style="PADDING-LEFT: 10px">编号</td>
                <td width="28%" align="left" nowrap class="thead" style="PADDING-LEFT: 10px"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
                  <lt:Label res="res.label.cms.doc" key="title"/></td>
                <td width="14%" align="left" nowrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">目录</td>
                <td width="11%" align="left" nowrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">点击</td>
                <td width="14%" align="left" nowrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">修改日期</td>
                <td width="11%" align="left" nowrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
                  <lt:Label res="res.label.cms.doc" key="check_state"/></td>
                <td width="13%" align="center" nowrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">操作</td>
              </tr>
              <tbody>
			  <%
				String sql = "select id,class1,title,isHome,examine,createDate,color,isbold,expire_date,doc_type,doc_level,hit from document where author=" + StrUtil.sqlstr(privilege.getUser(request)) + " and examine<>" + Document.EXAMINE_DUSTBIN + " order by modifiedDate desc";
			  	Document doc = new Document();
				Directory dir = new Directory();
				Iterator ir = doc.list(sql, 20).iterator();
				while (ir.hasNext()) {
					doc = (Document)ir.next();
			  %>
                <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1">
                  <td style="PADDING-LEFT: 10px"><%=doc.getId()%></td>
                  <td style="PADDING-LEFT: 10px"><a href="../doc_view.jsp?id=<%=doc.getId()%>" target="_blank"><%=doc.getTitle()%></a></td>
                  <td style="PADDING-LEFT: 10px">
				  <%
				  Leaf lf = dir.getLeaf(doc.getDirCode());
				  %>
				  <%=lf.getName()%>				  </td>
                  <td style="PADDING-LEFT: 10px"><%=doc.getHit()%></td>
                  <td style="PADDING-LEFT: 10px"><%=DateUtil.format(doc.getModifiedDate(), "yy-MM-dd HH:mm")%></td>
                  <td align="center" style="PADDING-LEFT: 10px"><%
	  int examine = doc.getExamine();
	  if (examine==0)
	  	out.print("<font color='blue'>" + SkinUtil.LoadString(request, "res.label.cms.doc","no_check") + "</font>");
	  else if (examine==1)
	  	out.print("<font color='red'>" + SkinUtil.LoadString(request, "res.label.cms.doc","no_pass") + "</font>");
	  else if (examine==10)
	  	out.print("<font color='#FFCC00'>" + SkinUtil.LoadString(request, "res.label.webedit","dustbin") + "</font>");
	  else
	  	out.print(SkinUtil.LoadString(request, "res.label.cms.doc","pass"));
	  %></td>
                  <td align="center" style="PADDING-LEFT: 10px">
				  <%
	  LeafPriv lp = new LeafPriv(doc.getDirCode());
	  if (lp.canUserModify(privilege.getUser(request))) {
	  %>
		  <a href="../<%=DocumentMgr.getWebEditPage()%>?op=edit&id=<%=doc.getId()%>&dir_code=<%=StrUtil.UrlEncode(doc.getDirCode())%>">[<lt:Label res="res.label.cms.doc" key="edit"/>]</a> 
	  <%}%>
				  </td>
                </tr>
				<%}%>
              </tbody>
            </table>
            <br></TD>
          <TD width=1 background=images/tab_bg.gif><IMG height=1 
            src="images/tab_bg.gif" width=1></TD></TR></TBODY></TABLE></TD></TR>
  <TR>
    <TD background=images/tab_bg.gif bgColor=#ffffff><IMG height=1 
      src="images/tab_bg.gif" width=1></TD></TR></TBODY></TABLE>
</BODY></HTML>
