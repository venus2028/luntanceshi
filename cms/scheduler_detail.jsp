<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="java.util.*,
				 java.text.*,
				 cn.js.fan.kernel.*,
				 cn.js.fan.util.*,
				 cn.js.fan.module.cms.*,
				 cn.js.fan.module.cms.kernel.*,
				 cn.js.fan.cache.jcs.*,
				 cn.js.fan.web.*,
				 cn.js.fan.module.pvg.*,
				 com.redmoon.forum.*"
%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="default.css" rel="stylesheet" type="text/css">
<p>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<jsp:useBean id="cfg" scope="page" class="cn.js.fan.web.Config"/>
<%
if (!privilege.isUserPrivValid(request, PrivDb.PRIV_ADMIN))
{
	// out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	// return;
}
%>
</b>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">&nbsp;</td>
    </tr>
  </tbody>
</table>
<br>
<TABLE 
style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" 
cellSpacing=1 cellPadding=3 width="85%" align=center>
  <!-- Table Head Start-->
  <TBODY>
    <TR>
      <TD class=thead style="PADDING-LEFT: 10px" noWrap width="72%">&nbsp;</TD>
      <TD class=thead style="PADDING-LEFT: 10px" noWrap width="28%">&nbsp;</TD>
    </TR>
    <TR class=row style="BACKGROUND-COLOR: #fafafa">
      <TD height="175" align="left" style="PADDING-LEFT: 10px">
	  论坛上次刷新时间：<%=DateUtil.format(DateUtil.parse("" + ForumSchedulerUnit.lastRefreshOnlineIntervalTime), "yyyy-MM-dd HH:mm:ss")%><br>
	  刷新间隔：<%=ForumSchedulerUnit.refreshOnlineInterval/60000%>分钟<br>
	  Scheduler.scheduler=<%=Scheduler.scheduler%><br>
	  <%
      com.redmoon.forum.Config forumcfg = com.redmoon.forum.Config.getInstance();
      int expire = forumcfg.getIntProperty("forum.refreshOnlineExpire");
      long expiremilli = expire * 60000;
      long expiretime = System.currentTimeMillis() - expiremilli;
      String sql = "delete from sq_online where staytime<" + expiretime;
	  out.print("根据配置文件：<BR>&nbsp;&nbsp;&nbsp;&nbsp;刷新 sql=" + sql + "<BR>");
	  out.print("&nbsp;&nbsp;&nbsp;&nbsp;刷新在位时间于" + DateUtil.format(DateUtil.parse("" + expiretime), "yyyy-MM-dd HH:mm:ss") + "之前的用户<BR>");
	  
	  String op = ParamUtil.get(request, "op");
	  if (op.equals("refresh")) {
	  	OnlineUserDb oud = new OnlineUserDb();
	  	oud.refreshOnlineUser();
	  }
	  
	  if (op.equals("stop")) {
	  	Scheduler.getInstance().doExit();
		Scheduler.getInstance().stop();
	  }
	  
	  if (op.equals("start")) {
	  	Scheduler.scheduler = null;
        Scheduler.initInstance(1000); // 单态模式
        // System.out.println("Global.java: initInstance end");

        // 加载调度项
        cfg.initScheduler();
	  }
	  %>
	  <br>
	  <br>
	  <a href="?op=refresh">手工刷新</a>&nbsp;&nbsp;<a href="?op=stop">停止调度</a>&nbsp;&nbsp;<a href="?op=start">重新调度</a></TD>
      <TD align="left" valign="top" style="PADDING-LEFT: 10px; line-height:150%">&nbsp;</TD>
    </TR>
    <!-- Table Body End -->
    <!-- Table Foot -->
    <TR>
      <TD class=tfoot align=right><DIV align=right> </DIV></TD>
      <TD class=tfoot align=right>&nbsp;</TD>
    </TR>
    <!-- Table Foot -->
  </TBODY>
</TABLE>
