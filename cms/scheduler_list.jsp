<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import = "com.cloudwebsoft.framework.db.*"%>
<%@ page import = "cn.js.fan.db.*"%>
<%@ page import = "cn.js.fan.util.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "cn.js.fan.web.*"%>
<%@ page import = "cn.js.fan.module.cms.kernel.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<jsp:useBean id="fchar" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>日程列表</title>
<link href="default.css" rel="stylesheet" type="text/css">
<%@ include file="../inc/nocache.jsp"%>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>
<script language=javascript>
<!--
function openWin(url,width,height)
{
  var newwin=window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,top=50,left=120,width="+width+",height="+height);
}
//-->
</script>
</head>
<body background="" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%
if (!privilege.isUserPrivValid(request, "admin")) {
	out.println(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
		
String op = ParamUtil.get(request, "op");
SchedulerManager sm = SchedulerManager.getInstance();
		
if (op.equals("start")) {
	sm.start();
	out.print(StrUtil.Alert_Redirect("启动调度！", "scheduler_list.jsp"));
	return;
}

if (op.equals("pause")) {
	sm.pause();
	out.print(StrUtil.Alert_Redirect("停止调度！", "scheduler_list.jsp"));
	return;
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">调度中心</td>
    </tr>
  </tbody>
</table>
<br>
<TABLE 
style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" 
cellSpacing=0 cellPadding=3 width="95%" align=center>
  <!-- Table Head Start-->
  <TBODY>
    <TR>
      <TD class=thead style="PADDING-LEFT: 10px" noWrap width="70%">&nbsp;</TD>
    </TR>
    <TR class=row style="BACKGROUND-COLOR: #fafafa">
      <TD height="175" align="center" style="PADDING-LEFT: 10px"><p>
	  状态：<%=sm.isPaused()?"已停止":"已启动"%>&nbsp;&nbsp;
	  	<%if (sm.isPaused()) {%>
			<a href="scheduler_list.jsp?op=start">启动调度</a>
		<%}else{%>
			<a href="scheduler_list.jsp?op=pause">停止调度</a>
		<%}%>
		&nbsp;&nbsp;<a href="scheduler_add.jsp">添加</a><br>
          <%
		JobUnitDb jud = new JobUnitDb();
		if (op.equals("del")) {
			int delid = ParamUtil.getInt(request, "id");
			JobUnitDb ldb = (JobUnitDb)jud.getQObjectDb(new Integer(delid));
			if (ldb.del())
				out.print(StrUtil.Alert("操作成功	"));
			else
				out.print(StrUtil.Alert("操作失败"));
		}
		String sql;
		sql = "select ID from " + jud.getTable().getName() + " order by id asc";
		int pagesize = 10;
		Paginator paginator = new Paginator(request);
		int curpage = paginator.getCurPage();
		
		ListResult lr = jud.listResult(new JdbcTemplate(), sql, curpage, pagesize);
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
</p>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td align="right"> 找到符合条件的记录 <b><%=paginator.getTotal() %></b> 条　每页显示 <b><%=paginator.getPageSize() %></b> 条　页次 <b><%=curpage %>/<%=totalpages %> </td>
          </tr>
        </table>
        <table width="98%" border="0" align="center" cellpadding="2" cellspacing="0" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">
          <tr>
            <td width="28%" align="left" class="thead">名称</td>
            <td width="22%" align="left" class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">调 度</td>
            <td width="19%" align="left" class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">类</td>
            <td width="31%" align="left" class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">操 作</td>
          </tr>
        <%	
		while (ir.hasNext()) {
			jud = (JobUnitDb)ir.next();
		%>
          <tr>
            <td width="28%" height="22" align="left"><%=jud.get("job_name")%></td>
            <td align="left">&nbsp;&nbsp;<%=jud.getString("cron")%></td>
            <td align="left">&nbsp;&nbsp;<%=jud.getString("job_class")%></td>
            <td width="31%" align="left">
			&nbsp;&nbsp;<a href="?op=del&id=<%=jud.get("id")%>">删除</a>
			<%if (jud.getString("job_class").equals("com.redmoon.forum.job.FullTextSearchJob")) {%>
&nbsp;&nbsp;			<a href="scheduler_edit.jsp?id=<%=jud.getInt("id")%>">编辑</a>
			<%}%></td>
          </tr>
        <%}%>
        </table>		
        <br>
        <table width="100%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
          <tr>
            <td height="23" align="right">&nbsp;
                <%
				String querystr = "";
				out.print(paginator.getCurPageBlock("?"+querystr));
				%>
              &nbsp;&nbsp;</td>
          </tr>
        </table>
      <br></TD>
    </TR>
    <!-- Table Body End -->
    <!-- Table Foot -->
    <TR>
      <TD class=tfoot align=right>&nbsp;</TD>
    </TR>
    <!-- Table Foot -->
  </TBODY>
</TABLE>
<br>
</body>
</html>
