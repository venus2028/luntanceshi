<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import = "cn.js.fan.db.*"%>
<%@ page import = "cn.js.fan.util.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "cn.js.fan.web.*"%>
<%@ page import = "cn.js.fan.module.pvg.*"%>
<jsp:useBean id="fchar" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>日志</title>
<link href="default.css" rel="stylesheet" type="text/css">
<%@ include file="../inc/nocache.jsp"%>
<script type="text/javascript" src="../util/jscalendar/calendar.js"></script>
<script type="text/javascript" src="../util/jscalendar/lang/calendar-zh.js"></script>
<script type="text/javascript" src="../util/jscalendar/calendar-setup.js"></script>
<style type="text/css"> @import url("../util/jscalendar/calendar-win2k-2.css"); </style>
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
function openWin(url,width,height){
  var newwin=window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,top=50,left=120,width="+width+",height="+height);
}
function selAllCheckBox(checkboxname){
	var checkboxboxs = document.all.item(checkboxname);
	if (checkboxboxs!=null){
		// 如果只有一个元素
		if (checkboxboxs.length==null) {
			checkboxboxs.checked = true;
		}
		for (i=0; i<checkboxboxs.length; i++)
		{
			checkboxboxs[i].checked = true;
		}
	}
}

function formSearch_onsubmit() {
	formSearch.pageSize.value = form1.pageSize.value;
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
%>
<table width='100%' cellpadding='0' cellspacing='0'>
  <tr>
    <td class="head">日志管理</td>
  </tr>
</table>
<br>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="tableframe">
  <tr> 
    <td width="100%" valign="top"><br>
      <form name="formSearch" action="log_list.jsp" onSubmit="return formSearch_onsubmit()" method="get">	
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="frame_gray">
      <tr>
        <td height="30" align="center">
		用户&nbsp;
		<input name="userName" size="10">
		&nbsp;开始时间
		<input name="beginDate" size="10">
          <script type="text/javascript">
    Calendar.setup({
        inputField     :    "beginDate",      // id of the input field
        ifFormat       :    "%Y-%m-%d",       // format of the input field
        showsTime      :    false,            // will display a time selector
        singleClick    :    false,           // double-click mode
        align          :    "Tl",           // alignment (defaults to "Bl")		
        step           :    1                // show all years in drop-down boxes (instead of every other year as default)
    });
	</script>		
		结束时间
		<input name="endDate" size="10">
          <script type="text/javascript">
    Calendar.setup({
        inputField     :    "endDate",      // id of the input field
        ifFormat       :    "%Y-%m-%d",       // format of the input field
        showsTime      :    false,            // will display a time selector
        singleClick    :    false,           // double-click mode
        align          :    "Tl",           // alignment (defaults to "Bl")		
        step           :    1                // show all years in drop-down boxes (instead of every other year as default)
    });
	</script>
          <input name="pageSize" type="hidden">
          <input name="action" value="search" type="hidden">
          &nbsp;
		<input type="submit" value="搜索">		</td>
      </tr>
    </table>
	</form>
      <br>
      <%
		int pageSize = ParamUtil.getInt(request, "pageSize", 10);
		Paginator paginator = new Paginator(request);
		int curpage = paginator.getCurPage();
		
		LogDb ld = new LogDb();
		String op = ParamUtil.get(request, "op");
		if (op.equals("del")) {
			int delid = ParamUtil.getInt(request, "id");
			LogDb ldb = ld.getLogDb(delid);
			if (ldb.del())
				out.print(StrUtil.Alert_Redirect("操作成功", "log_list.jsp?pageSize=" + pageSize + "&CPages=" + curpage));
			else
				out.print(StrUtil.Alert_Back("操作失败"));
			return;
		}
		else if (op.equals("delBatch")) {
			String[] ids = ParamUtil.getParameters(request, "ids");
			if (ids!=null) {
				int len = ids.length;
				for (int i=0; i<len; i++) {
					LogDb ldb = ld.getLogDb(StrUtil.toInt(ids[i]));
					ldb.del();
				}
				out.print(StrUtil.Alert_Redirect("操作成功", "log_list.jsp?pageSize=" + pageSize + "&CPages=" + curpage));
				return;
			}
		}
		String sql;
		String myname = privilege.getUser(request);
		sql = "select ID from log";
		
		String userName = ParamUtil.get(request, "userName");
		String beginDate = ParamUtil.get(request, "beginDate");
		String endDate = ParamUtil.get(request, "endDate");
		
		String action = ParamUtil.get(request, "action");
		if (action.equals("search")) {
			String cond = "";
			if (!userName.equals("")) {
				if (cond.equals(""))
					cond = "user_name like " + StrUtil.sqlstr("%" + userName + "%");
				else
					cond += " and user_name like " + StrUtil.sqlstr("%" + userName + "%");
			}
			else if (!beginDate.equals("")) {
				if (cond.equals(""))
					cond = "log_date>=" + DateUtil.toLongString(DateUtil.parse(beginDate, "yyyy-MM-dd"));
				else
					cond += " and log_date>=" + DateUtil.toLongString(DateUtil.parse(beginDate, "yyyy-MM-dd"));
			}
			else if (!endDate.equals("")) {
				if (cond.equals(""))
					cond = "log_date<=" + DateUtil.toLongString(DateUtil.parse(endDate, "yyyy-MM-dd"));
				else
					cond += " and log_date<=" + DateUtil.toLongString(DateUtil.parse(endDate, "yyyy-MM-dd"));
			}
			if (!cond.equals(""))
				sql += " where " + cond;	
		}
		
		sql += " order by ID desc";

		ListResult lr = ld.listResult(sql, curpage, pageSize);
		int total = lr.getTotal();
		Vector v = lr.getResult();
	    Iterator ir = null;
		if (v!=null)
		ir = v.iterator();
		paginator.init(total, pageSize);
		// 设置当前页数和总页数
		int totalpages = paginator.getTotalPages();
		if (totalpages==0)
		{
			curpage = 1;
			totalpages = 1;
		}
%>
	  <form name="form1" action="log_list.jsp?op=delBatch" method="post">
      <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="50%" align="left">每页条数：<input name="pageSize" size="3" value="<%=pageSize%>" onChange="setPageSize()"><input type="submit" value="确定"></td>
          <td width="50%" align="right">找到符合条件的记录 <b><%=paginator.getTotal() %></b> 条　每页显示 <b><%=paginator.getPageSize() %></b> 条　页次 <b><%=curpage %>/<%=totalpages %> </b></td>
        </tr>
      </table> 
      <table width="98%" border="0" align="center" cellpadding="2" cellspacing="0" class="frame_gray">
        <tr bgcolor="#C4DAFF">
          <td width="6%" align="center" class="thead">&nbsp;</td>
          <td width="19%" align="center" class="thead">日 期</td> 
          <td width="25%" align="center" class="thead">用户名</td>
          <td width="20%" align="center" class="thead">动 作</td>
          <td width="12%" align="center" class="thead">IP</td>
          <td width="9%" align="center" class="thead">类 型</td>
          <td width="9%" align="center" class="thead">操 作</td>
        </tr>
      <%	
	    UserMgr um = new UserMgr();
		while (ir.hasNext()) {
			ld = (LogDb)ir.next();
			User ud = um.getUser(ld.getUserName());
		%>
        <tr>
          <td width="6%" align="center"><input type="checkbox" name="ids" value="<%=ld.getId()%>"></td>
          <td width="19%" align="center"><%=DateUtil.format(ld.getDate(), "yyyy-MM-dd HH:mm:ss")%></td> 
          <td width="25%" align="center">
		  <%if (ud.isLoaded()) {%>
		  <a href="user_op.jsp?op=edit&name=<%=StrUtil.UrlEncode(ud.getName())%>"><%=ud.getRealName()%></a>
		  <%}else{%>
		  <%=ud.getName()%>
		  <%}%>
		  </td>
          <td width="20%" align="center"><%=ld.getAction()%></td>
          <td width="12%" align="center"><%=ld.getIp()%></td>
          <td width="9%" align="center"><%=LogUtil.getTypeDesc(request, ld.getType())%></td>
          <td width="9%" align="center"><a href="?op=del&id=<%=ld.getId()%>">删除</a></td>
        </tr>
<%}%>
      </table>
      <br>
      <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
        <tr> 
          <td width="50%" height="23" align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" onClick="selAllCheckBox('ids')" value="全选" />&nbsp;&nbsp;&nbsp;&nbsp; <input type="button" onClick="del()" value="删除" /> &nbsp;&nbsp;</td>
          <td width="50%" align="right"><%
				String querystr = "action=" + action + "&pageSize=" + pageSize + "&userName=" + StrUtil.UrlEncode(userName) + "&beginDate=" + beginDate + "&endDate=" + endDate;
				out.print(paginator.getCurPageBlock("?"+querystr));
				%></td>
        </tr>
      </table>
	  <input name="CPages" value="<%=curpage%>" type="hidden">
	  </form>
      <br>    </td>
  </tr>
</table>
</body>
<script>
function del(){
    var checkedboxs = 0;
	var checkboxboxs = document.all.item("ids");
	if (checkboxboxs!=null)
	{
		// 如果只有一个元素
		if (checkboxboxs.length==null) {
			if (checkboxboxs.checked){
			   checkedboxs = 1;
			}
		}
		for (i=0; i<checkboxboxs.length; i++)
		{
			if (checkboxboxs[i].checked){
			   checkedboxs = 1;
			}
		}
	}
	if (checkedboxs==0){
	    alert("请先选择记录！");
		return;
	}
	if (confirm("您确定要删除吗？"))
		form1.submit();
}

function setPageSize() {
	window.location.href="log_list.jsp?action=<%=action%>&userName=<%=StrUtil.UrlEncode(userName)%>&beginDate=<%=beginDate%>&endDate=<%=endDate%>&pageSize=" + form1.pageSize.value + "&CPages=<%=curpage%>";
}
</script>
</html>
