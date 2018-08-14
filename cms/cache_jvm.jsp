<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.util.*,
				 java.text.*"
%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="fchar" scope="page" class="cn.js.fan.util.StrUtil"/>
<%
String priv="class";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../common.css" rel="stylesheet" type="text/css">
<link href="default.css" rel="stylesheet" type="text/css">
<title><lt:Label res="res.label.cms.cache" key="cache_jvm_title"/></title>
</head>
<body style="background-color:#FFFFFF">
<br>
<TABLE 
style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" 
cellSpacing=0 cellPadding=3 width="95%" align=center>
  <!-- Table Head Start-->
  <TBODY>
    <TR>
      <TD width="70%" align="left" noWrap class=thead style="PADDING-LEFT: 10px"><font size="-1"><b><lt:Label res="res.label.cms.cache" key="java_vm"/></b></font> </TD>
    </TR>
    <TR class=row style="BACKGROUND-COLOR: #fafafa">
      <TD height="175" align="center" style="PADDING-LEFT: 10px"><p>
          <p>
            <%!
	static final DecimalFormat mbFormat = new DecimalFormat("#0.00");
	static final DecimalFormat percentFormat = new DecimalFormat("#0.0");
    static final int NUM_BLOCKS = 50;
%>
            <%
	String op = request.getParameter("op");
	if (op==null)
		op = "";
	// The java runtime
	Runtime runtime = Runtime.getRuntime();
	if (op.equals("gc")) {
		runtime.gc();
		String str = SkinUtil.LoadString(request,"res.label.cms.cache","refuse_collected");
		out.println("<p><font size=-1 color=red>&nbsp;&nbsp;&nbsp;" + str + "</font></p>");
	}

    double freeMemory = (double)runtime.freeMemory()/(1024*1024);
	double totalMemory = (double)runtime.totalMemory()/(1024*1024);
	double maxMemory = Runtime.getRuntime().maxMemory()/(1024*1024);
	double usedMemory = totalMemory - freeMemory;
	double percentFree = ((double)freeMemory/(double)totalMemory)*100.0;
    int free = 100-(int)Math.round(percentFree);
%>
        <ul><table width="277" border=0>
            <tr>
              <td width="135"><font size="-1"><lt:Label res="res.label.cms.cache" key="mem_used"/>:</font></td>
              <td width="132"><font size="-1"><%= mbFormat.format(usedMemory) %> MB</font></td>
            </tr>
            <tr>
              <td><font size="-1"><lt:Label res="res.label.cms.cache" key="mem_sum"/>:</font></td>
              <td><font size="-1"><%= mbFormat.format(totalMemory) %> MB</font></td>
            </tr>
            <tr>
              <td><font size="-1">
                <lt:Label res="res.label.cms.cache" key="mem_max"/>                
              </font></td>
              <td><font size="-1"><%= mbFormat.format(maxMemory) %> MB</font></td>
            </tr>
            <tr>
              <td><font size="-1"><lt:Label res="res.label.cms.cache" key="cpu_count"/></font></td>
              <td><font size="-1"><%=runtime.availableProcessors()%> 个</font></td>
            </tr>
            </table>
          <br>
          <table border=0>
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
                <td><font size="-1"> &nbsp;<b><%= percentFormat.format(percentFree) %>% <lt:Label res="res.label.cms.cache" key="mem_free"/></b> </font> </td>
          </table>
          <br>
          <table width="627"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="627" align="center">>>&nbsp;<font size="-1"><a href="cache_jvm.jsp?op=gc">
              <lt:Label res="res.label.cms.cache" key="collect_refuse"/></a></font>&nbsp;&nbsp; <font size="-1"><a href="cache_jvm.jsp"><lt:Label res="res.label.cms.cache" key="refresh"/></a></font>&nbsp;<<</td>
            </tr>
            <tr>
              <td height="48" align="center"><font size="-1"><lt:Label res="res.label.cms.cache" key="notice"/></font></td>
            </tr>
          </table>
        </ul>
          <%	// Destroy the runtime reference
	runtime = null;
%>
</TD>
    </TR>
    <!-- Table Body End -->
    <!-- Table Foot -->
    <TR>
      <TD class=tfoot align=right><DIV align=right> </DIV></TD>
    </TR>
    <!-- Table Foot -->
  </TBODY>
</TABLE>
<p>
</body>
</html>
