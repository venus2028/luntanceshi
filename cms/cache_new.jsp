<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="java.util.*,
				 java.text.*,
				 cn.js.fan.kernel.*,
				 cn.js.fan.util.*,
				 cn.js.fan.module.cms.*,
				 cn.js.fan.cache.jcs.*,
				 cn.js.fan.web.*,
				 com.redmoon.forum.*,
				 cn.js.fan.module.pvg.*"
%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="default.css" rel="stylesheet" type="text/css">
<%
String priv="class";
String op = ParamUtil.get(request, "op");
RMCache rmcache = RMCache.getInstance();
if (op.equals("startcache")) {
	rmcache.setCanCache(true);
}

if (op.equals("stopcache")) {
	rmcache.setCanCache(false);
}

if (op.equals("clear")) {
	rmcache.clear();
}

if (op.equals("refreshfulltext")) {
	DocCacheMgr dcm = new DocCacheMgr();
	dcm.refreshFulltext();
}

if (op.equals("reloadConfig")) {
	Global.init();
}
%>
<%!	// global variables

	// decimal formatter for cache values
	static final DecimalFormat mbFormat = new DecimalFormat("#0.00");
	static final DecimalFormat percentFormat = new DecimalFormat("#0.0");
    // variable for the VM memory monitor box
    static final int NUM_BLOCKS = 50;
%>
<p>

<font size="-1">
</font><font size="-1"><b>
<jsp:useBean id="backup" scope="page" class="cn.js.fan.util.Backup"/>
<jsp:useBean id="cfg" scope="page" class="cn.js.fan.web.Config"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, PrivDb.PRIV_ADMIN))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
</b></font>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">
        <lt:Label res="res.label.cms.cache" key="sys_info"/>        
 	  </td>
    </tr>
  </tbody>
</table>
<br>
<script type="text/javascript" src="../inc/ajaxtabs/ajaxtabs.jsp"></script><br>

<div id="tabMenu" class="tabMenuCss">
<div class="tabMenuBar">	
<ul id="tabItems" class="tabMenuItemsCss">
<li class="selected"><a href="#default" rel="contentArea">系统状态</a></li>
<li><a href="iframe.jsp?url=cache_jvm.jsp" rel="contentArea">内存管理</a></li>
</ul>
<div class="clear"></div>
</div>
<div id="contentArea" class="tabContentAreaCss"><br>
  <TABLE style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" 
cellSpacing=1 cellPadding=3 width="90%" align=center>
    <!-- Table Head Start-->
    <TBODY>
      <TR>
        <TD class=thead style="PADDING-LEFT: 10px" noWrap width="72%"><lt:Label res="res.label.cms.cache" key="java_vm"/>
        </TD>
        <TD class=thead style="PADDING-LEFT: 10px" noWrap width="28%"><lt:Label res="res.label.cms.cache" key="scheduler"/>
        </TD>
      </TR>
      <TR class=row style="BACKGROUND-COLOR: #fafafa">
        <TD height="175" align="center" style="PADDING-LEFT: 10px"><p>
            <ul>
              <%	// The java runtime
	Runtime runtime = Runtime.getRuntime();

    double freeMemory = (double)runtime.freeMemory()/(1024*1024);
	double totalMemory = (double)runtime.totalMemory()/(1024*1024);
	double usedMemory = totalMemory - freeMemory;
	double percentFree = ((double)freeMemory/(double)totalMemory)*100.0;
    int free = 100-(int)Math.round(percentFree);
%>
              <table border=0>
                <tr>
                  <td><font size="-1">
                    <lt:Label res="res.label.cms.cache" key="mem_used"/>
                  </font></td>
                  <td><font size="-1"><%= mbFormat.format(usedMemory) %> MB</font></td>
                </tr>
                <tr>
                  <td><font size="-1">
                    <lt:Label res="res.label.cms.cache" key="mem_sum"/>
                  </font></td>
                  <td><font size="-1"><%= mbFormat.format(totalMemory) %> MB</font></td>
                </tr>
              </table>
              <br>
              <table height="22" border=0>
                <td><table bgcolor="#000000" cellpadding="1" cellspacing="0" border="0" width="200" align=left>
                  <td><table bgcolor="#000000" cellpadding="1" cellspacing="1" border="0" width="100%">
                    <%    for (int i=0; i<NUM_BLOCKS; i++) {
        if ((i*(100/NUM_BLOCKS)) < free) {
    %>
                    <td bgcolor="#00ff00" width="<%= (100/NUM_BLOCKS) %>%"><img src="images/blank.gif" width="1" height="15" border="0"></td>
                            <%		} else { %>
                            <td bgcolor="#006600" width="<%= (100/NUM_BLOCKS) %>%"><img src="images/blank.gif" width="1" height="15" border="0"></td>
                      <%		}
    }
%>
                    </table></td>
                  </table></td>
                <td><font size="-1"> &nbsp;<b><%= percentFormat.format(percentFree) %>% </b>
                      <lt:Label res="res.label.cms.cache" key="mem_free"/>
                </font> </td>
              </table>
              <br>
              >>&nbsp;<a href="cache_jvm.jsp">
                <lt:Label res="res.label.cms.cache" key="mem_mgr"/>
                </a>
            </ul>
          <%	// Destroy the runtime reference
	runtime = null;
%>
            <%if (rmcache.getCanCache()) {%>
            <lt:Label res="res.label.cms.cache" key="cache_started"/>
          >>&nbsp;<a href="cache_new.jsp?op=stopcache">
            <lt:Label res="res.label.cms.cache" key="cache_stop"/>
            </a>
          <%}else{%>
          <lt:Label res="res.label.cms.cache" key="cache_stoped"/>
          >>&nbsp;<a href="cache_new.jsp?op=startcache">
            <lt:Label res="res.label.cms.cache" key="cache_start"/>
            </a>
          <%}%>
          &nbsp;&nbsp;&nbsp;      &nbsp;<a href="cache_new.jsp?op=clear">
            <lt:Label res="res.label.cms.cache" key="cahce_all_clear"/>
            </a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="cache_new.jsp?op=refreshfulltext">
              <lt:Label res="res.label.cms.cache" key="cache_refresh"/>
              </a><br>
          <br>
          <a href="cache_new.jsp?op=reloadConfig">
            <lt:Label res="res.label.cms.cache" key="cache_refresh_config_file"/>
            </a> (
          <lt:Label res="res.label.cms.cache" key="maxsize"/>
          <%=Global.MaxSize/1024%>K，
          <lt:Label res="res.label.cms.cache" key="filesize"/>
          <%=Global.FileSize%>K)</TD>
        <TD align="left" valign="top" style="PADDING-LEFT: 10px; line-height:150%"><lt:Label res="res.label.cms.cache" key="scheduler_status"/>
            <%if (Scheduler.scheduler.isAlive()) {%>
            <lt:Label res="res.label.cms.cache" key="scheduler_status_run"/>
            <%}else{%>
            <lt:Label res="res.label.cms.cache" key="scheduler_status_stop"/>
            <%}%>
            <br>
            <%
                Iterator ir = Scheduler.getInstance().getUnits().iterator();
                while (ir.hasNext()) {
                    BaseSchedulerUnit isu = (BaseSchedulerUnit) ir.next();
                    out.print("- " + isu.getName() + "<BR> " + ForumSkin.formatDateTime(request, DateUtil.parse("" + isu.lastTime)) + "<BR>");
                }	  
	  %>
        </TD>
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
</div>
<script type="text/javascript">
//Start Ajax tabs script for UL with id="tabItems" Separate multiple ids each with a comma.
startajaxtabs("tabItems")
</script>	
</div>
