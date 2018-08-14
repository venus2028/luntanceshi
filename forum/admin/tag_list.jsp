<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import = "com.cloudwebsoft.framework.db.*"%>
<%@ page import = "com.cloudwebsoft.framework.base.*"%>
<%@ page import = "cn.js.fan.db.*"%>
<%@ page import = "cn.js.fan.util.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "cn.js.fan.web.*"%>
<%@ page import = "com.redmoon.forum.*"%>
<%@ page import = "com.redmoon.forum.person.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<jsp:useBean id="fchar" scope="page" class="cn.js.fan.util.StrUtil"/>
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
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request)) {
	out.println(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

TagDb td = new TagDb();
		
String op = ParamUtil.get(request, "op");
if (op.equals("add")) {
	QObjectMgr qom = new QObjectMgr();
	try {
		if (qom.create(request, td, "sq_tag_create")) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "tag_list.jsp"));
			return;
		}
		else {
			out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
			return;
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage() + " 请检查标签是否已存在!"));
		return;
	}
}

if (op.equals("edit")) {
	long id = ParamUtil.getLong(request, "id");
	td = (TagDb)td.getQObjectDb(new Long(id));
	QObjectMgr qom = new QObjectMgr();
	try {
		if (qom.save(request, td, "sq_tag_save"))
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "tag_list.jsp"));
		else
			out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));	
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
		
}

if (op.equals("del")) {
	long id = ParamUtil.getLong(request, "id");
	td = (TagDb)td.getQObjectDb(new Long(id));
	boolean re = td.del();
	if (re)
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "tag_list.jsp"));
	else
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
	return;
}

		String sql;
		sql = "select id from " + td.getTable().getName() + " order by is_system desc, count desc";
		int pagesize = 20;
		Paginator paginator = new Paginator(request);
		int curpage = paginator.getCurPage();
		
		ListResult lr = td.listResult(new JdbcTemplate(), sql, curpage, pagesize);
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
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">标签管理</td>
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
      <TD height="175" align="center" style="PADDING-LEFT: 10px">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <form name="formAdd" action="tag_list.jsp?op=add" method="post">
        <tr>
          <td align="center">系统标签
            <input name="name"><input type="submit" value="添加">
            <input name="is_system" value="1" type="hidden">
            <input name="user_name" value="<%=TagDb.USER_NAME_SYSTEM%>" type="hidden"></td>
        </tr></form>
      </table>
      <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td align="right"> 找到符合条件的记录 <b><%=paginator.getTotal() %></b> 条　每页显示 <b><%=paginator.getPageSize() %></b> 条　页次 <b><%=curpage %>/<%=totalpages %> </td>
          </tr>
        </table>
        <table width="98%" border="0" align="center" cellpadding="2" cellspacing="0" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">
          <tr>
            <td width="19%" align="left" class="thead">名称</td>
            <td width="15%" align="left" class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">数量</td>
            <td width="16%" align="left" class="thead">系统标签</td>
            <td width="14%" align="left" class="thead">创建者</td>
            <td width="13%" align="left" class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">创建日期</td>
            <td width="23%" align="left" class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">操 作</td>
          </tr>
        <%
		int k = 0;
		UserMgr um = new UserMgr();
		while (ir.hasNext()) {
			k++;
			td = (TagDb)ir.next();
		%>
		<form name="form<%=k%>" action="tag_list.jsp?op=edit" method="post">
          <tr>
            <td width="19%" height="22" align="left">
			<input name="name" value="<%=td.get("name")%>">
			<input name="id" value="<%=td.getLong("id")%>" type="hidden"></td>
            <td align="left">&nbsp;&nbsp;
            <input name="count" value="<%=td.getInt("count")%>" type="hidden"><%=td.getInt("count")%></td>
            <td align="left">
			<select name="is_system">
			<option value="1">是</option>
			<option value="0">否</option>
			</select>
			<script>
			form<%=k%>.is_system.value="<%=td.getInt("is_system")==1?1:0%>";
			</script>			</td>
            <td align="left">
			<%
			String userName = td.getString("user_name");
			if (!userName.equals(TagDb.USER_NAME_SYSTEM)) {
				UserDb ud = um.getUser(userName);
				out.print("<a target=_blank href='../../userinfo.jsp?username=" + StrUtil.UrlEncode(ud.getName()) + "'>" + ud.getNick() + "</a>");
			}
			else
				out.print("系统");
			%>
			</td>
            <td align="left"><%=DateUtil.format(td.getDate("create_date"), "yyyy-MM-dd")%></td>
            <td width="23%" align="left"><a href="javascript:form<%=k%>.submit()">修改</a>　<a href="javascript:if (confirm('您确定要删除吗？')) window.location.href='tag_list.jsp?op=del&id=<%=td.getLong("id")%>'">删除</a>&nbsp;&nbsp;&nbsp;<a href="../listtag.jsp?tagId=<%=td.getLong("id")%>" target="_blank">查看</a></td>
          </tr></form>
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
