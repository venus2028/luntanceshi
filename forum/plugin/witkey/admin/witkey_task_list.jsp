<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.MsgDb"%>
<%@ page import="com.redmoon.forum.MsgMgr"%>
<%@ page import="com.redmoon.forum.plugin.witkey.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%
String orderBy = ParamUtil.get(request, "orderBy");
if (orderBy.equals(""))
	orderBy = "end_date";
String sort = ParamUtil.get(request, "sort");
if (sort.equals(""))
	sort = "desc";
String op = ParamUtil.get(request, "op");
String kind = ParamUtil.get(request, "kind");
String value = ParamUtil.get(request, "value");

String catalogCode = ParamUtil.get(request, "catalogCode");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML><HEAD><TITLE>商店列表</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<link rel="stylesheet" href="../../../common.css">
<LINK href="../../../admin/default.css" type=text/css rel=stylesheet>
<META content="MSHTML 6.00.3790.259" name=GENERATOR>
<style type="text/css">
<!--
.style1 {	font-size: 14px;
	font-weight: bold;
}
-->
</style>
<script>
var curOrderBy = "<%=orderBy%>";
var sort = "<%=sort%>";
function doSort(orderBy) {
	if (orderBy==curOrderBy)
		if (sort=="asc")
			sort = "desc";
		else
			sort = "asc";
			
	window.location.href = "witkey_task_list.jsp?op=<%=op%>&catalogCode=<%=StrUtil.UrlEncode(catalogCode)%>&kind=<%=kind%>&value=<%=StrUtil.UrlEncode(value)%>&orderBy=" + orderBy + "&sort=" + sort;
}
</script>
</HEAD>
<BODY text=#000000 bgColor=#eeeeee leftMargin=0 topMargin=0>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String privurl;

if (op.equals("setLevel")) {
	int level = ParamUtil.getInt(request, "level");
	int msgId = ParamUtil.getInt(request, "msgId");
	WitkeyDb wd = new WitkeyDb();
	wd = wd.getWitkeyDb(msgId);
	wd.setLevel(level);
	if (wd.save())
		out.print(StrUtil.Alert_Redirect("操作成功！", "witkey_task_list.jsp"));
	else
		out.print(StrUtil.Alert_Back("操作失败！"));
	return;
}

privurl = ParamUtil.get(request, "privurl");
%>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
  <TR>
    <TD class=head>威客任务&nbsp;(<a href="manager.jsp">管理</a>)</TD>
  </TR></TBODY></TABLE>
<br>
<%
int pagesize = 10;
Paginator paginator = new Paginator(request);

WitkeyDb wd = new WitkeyDb();
String sql = "select msg_root_id from " + wd.getTableName() + " order by " + orderBy + " " + sort;
if (!catalogCode.equals(""))
	sql  = "select msg_root_id from " + wd.getTableName() + " where catalog_code=" + StrUtil.sqlstr(catalogCode) + " order by " + orderBy + " " + sort;
if (op.equals("search")) {
	if (kind.equals("msgRootId"))
		sql = "select msg_root_id from " + wd.getTableName() + " where msg_root_id=" + value;
	else {
		if (catalogCode.equals(""))
			sql = "select w.msg_root_id from " + wd.getTableName() + " w left join sq_message m on m.id=w.msg_root_id where m.title like " +StrUtil.sqlstr("%" + value + "%") + " order by " + orderBy + " " + sort;
		else {
			sql = "select w.msg_root_id from " + wd.getTableName() + " w left join sq_message m on m.id=w.msg_root_id where w.catalog_code=" + StrUtil.sqlstr(catalogCode) + " and m.title like " +StrUtil.sqlstr("%" + value + "%") + " order by " + orderBy + " " + sort;
		}
	}
}

int total = wd.getObjectCount(sql);
paginator.init(total, pagesize);
int curpage = paginator.getCurPage();
// 设置当前页数和总页数
int totalpages = paginator.getTotalPages();
if (totalpages==0)
{
	curpage = 1;
	totalpages = 1;
}
%>
<table width="98%" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr>
    <td height=20 align="center" class="thead style1">威客任务列表</td>
  </tr>
  <tr>
    <td valign="top"><br>
    <table width="75%" border="0" align="center" cellpadding="0" cellspacing="0">
      <form name=formsearch action="?action=search" method="post">
        <tr>
          <td align="center">
            按
            <select name="kind">
              <option value="title">任务名称</option>
              <option value="msgRootId">任务编号</option>
              </select>
            <input name="value">
            &nbsp;
            <input type="submit" value="搜索任务"></td>
        </tr>
        </form>
      </table>
        <br>
      <table width="96%" height="24" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td align="right"><div>找到符合条件的记录 <b><%=paginator.getTotal() %></b> 条　每页显示 <b><%=paginator.getPageSize() %></b> 条　页次 <b><%=paginator.getCurrentPage() %>/<%=paginator.getTotalPages() %></b></div></td>
        </tr>
      </table>
      <table width="96%"  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#CCCCCC">
          <tr align="center" bgcolor="#F1EDF3">
            <td width="7%" height="24" onClick="doSort('msg_root_id')" style="cursor:hand">编号<span style="cursor:hand">
              <%if (orderBy.equals("msg_root_id")) {
			if (sort.equals("asc")) 
				out.print("<img src='../../../admin/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../../../admin/images/arrow_down.gif' width=8px height=7px>");
		}%>
            </span></td>
            <td width="42%" height="22">任务标题</td>
              <td width="12%">类别</td>
              <td width="10%" height="22">发起人</td>
              <td width="10%">联系方式</td>
              <td width="10%" onClick="doSort('end_date')" style="cursor:hand">结束时间<span style="cursor:hand">
       <%if (orderBy.equals("end_date")) {
			if (sort.equals("asc")) 
				out.print("<img src='../../../admin/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../../../admin/images/arrow_down.gif' width=8px height=7px>");
		}%>
              </span></td>
              <td width="9%" onClick="doSort('level')" style="cursor:hand">推荐级别
              <%if (orderBy.equals("level")) {
			if (sort.equals("asc")) 
				out.print("<img src='../../../admin/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../../../admin/images/arrow_down.gif' width=8px height=7px>");
		}%></td>
        </tr>
  <%
Vector v = wd.list(sql, (curpage-1)*pagesize, curpage*pagesize-1);
Iterator ir = v.iterator();
com.redmoon.forum.person.UserMgr um = new com.redmoon.forum.person.UserMgr();
MsgMgr mm = new MsgMgr();
int i = 0;
Directory dir = new Directory();
while (ir.hasNext()) {
	wd = (WitkeyDb)ir.next();
	MsgDb md = mm.getMsgDb(wd.getMsgRootId());
	Timestamp ts = new Timestamp(Long.parseLong(wd.getEndDate()));
	i++;
%>
          <form id="form<%=i%>" name="form<%=i%>" action="?op=setLevel&msgId=<%=wd.getMsgRootId()%>" method="post">
            <tr align="center">
              <td bgcolor="#FFFFFF"><%=wd.getMsgRootId()%></td>
              <td height="22" align="left" bgcolor="#FFFFFF"><a href="../../../showtopic.jsp?rootid=<%=wd.getMsgRootId()%>" target="_blank"><%=md.getTitle()%></a></td>
              <td bgcolor="#FFFFFF">
			  <%
			  Leaf lf = dir.getLeaf(wd.getCatalogCode());
			  if (lf!=null)
			  	out.print("<a href='witkey_task_list.jsp?catalogCode=" + StrUtil.UrlEncode(lf.getCode()) + "'>" + lf.getName() + "</a>");
			  %>
			  </td>
              <td height="22" bgcolor="#FFFFFF"><a target="_blank" href="../../../../userinfo.jsp?username=<%=wd.getUserName()%>"><%=um.getUser(wd.getUserName()).getNick()%></a></td>
                <td height="22" bgcolor="#FFFFFF"><%=wd.getContact()%></td>
                <td bgcolor="#FFFFFF"><%=DateUtil.format(DateUtil.parse(ts.toString(), "yyyy-MM-dd"), "yyyy-MM-dd")%></td>
                <td height="22" bgcolor="#FFFFFF">
                  <select name="level" onChange="form<%=i%>.submit()">
                    <option value="0">无</option>
                    <option value="1">1级</option>
                    <option value="2">2级</option>
                    <option value="3">3级</option>
                    <option value="4">4级</option>
                    <option value="5">5级</option> 
                  </select>	
                  <script>
			  form<%=i%>.level.value=<%=wd.getLevel()%>
			  </script>			  </td>
            </tr>
        </form>
          <%}%>
      </table>
      <table width="96%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
        <tr>
          <td height="23"><div align="right">
  <%
	String querystr = "op=" + op + "&kind=" + kind + "&value=" + StrUtil.UrlEncode(value);
    out.print(paginator.getCurPageBlock("?"+querystr));
%>
            </div></td>
        </tr>
      </table></td></tr>
</table>
<br>
</BODY>
</HTML>
