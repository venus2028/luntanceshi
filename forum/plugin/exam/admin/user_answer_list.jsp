<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../../../inc/inc.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.plugin.exam.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.cloudwebsoft.framework.base.*"%>
<%@ page import="com.redmoon.fetion.exam.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="pragma" content="no-cache">
<link rel="stylesheet" href="../../../common.css">
<LINK href="../../../admin/default.css" type=text/css rel=stylesheet>
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="../../../../util/jscalendar/calendar.js"></script>
<script type="text/javascript" src="../../../../util/jscalendar/lang/calendar-zh.js"></script>
<script type="text/javascript" src="../../../../util/jscalendar/calendar-setup.js"></script>
<style type="text/css"> @import url("../../../../util/jscalendar/calendar-win2k-2.css"); </style>
<script>
function query() {
	form1.op.value = "listQuery";
	form1.submit();
}
</script>
<title>用户答题管理</title>
<body bgcolor="#FFFFFF" topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String dirCode = ParamUtil.get(request, "dirCode");

String op = ParamUtil.get(request, "op");
if (op.equals("del")) {
	long id = ParamUtil.getLong(request, "id");
	UserAnswerDb uad = new UserAnswerDb();
	uad = (UserAnswerDb)uad.getQObjectDb(new Long(id));
	boolean re = false;
	re = uad.del();
	if (re) {
		out.print(StrUtil.Alert_Redirect("操作成功！", "user_answer_list.jsp"));
	}
	else {
		out.print(StrUtil.Alert_Back("操作失败！"));
	}
	return;
}

int pagesize = ParamUtil.getInt(request, "pageSize", 20);

ExamConfig ec = ExamConfig.getInstance();
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">答题情况</td>
  </tr>
</table>
<br>
<table width="98%" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr> 
    <td height=20 align="left" class="thead">查询</td>
  </tr>
  <tr>
    <td valign="top"><table width="86%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td>&nbsp;</td>
      </tr>
	  <form name=form1 action="user_answer_list.jsp" method=post>
      <tr>
        <td align="left">
<%
		String userName = ParamUtil.get(request, "userName");
		String beginDate = ParamUtil.get(request, "beginDate");
		String endDate = ParamUtil.get(request, "endDate");
%>		
		开始时间：
		  <input name="beginDate" value="<%=beginDate%>">
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
		&nbsp;结束时间：
		<input name="endDate" value="<%=endDate%>">
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
每页<input name="pageSize" value=<%=pagesize%> size=5>条记录
<input name="op" value="listOk" type=hidden>
<input type=submit  value="答题正确达<%=ec.getIntProperty("exam.max_count_per_month")%>条者">
<input type=button value="查询" onClick="query()">
</td>
      </tr>
	  </form>
	  <form name=form2 action="user_answer_list.jsp?op=search" method=post>	  
      <tr>
        <td height="27" align="left">用&nbsp;&nbsp;户&nbsp;&nbsp;名：
          <input name="userName" value="<%=userName%>">
          &nbsp;
          <input type=submit value="搜索"></td>
      </tr>
	  </form>
    </table>
<%
		UserAnswerDb mud = new UserAnswerDb();
		
		String strcurpage = StrUtil.getNullString(request.getParameter("CPages"));
		if (strcurpage.equals(""))
			strcurpage = "1";
		if (!StrUtil.isNumeric(strcurpage)) {
			out.print(StrUtil.makeErrMsg(SkinUtil.LoadString(request, "err_id")));
			return;
		}
		
		String sql = "select id from " + mud.getTable().getName() + " order by answer_time desc";

		if (op.equals("listOk")) {
			sql = "select id from " + mud.getTable().getName();
			if (!beginDate.equals(""))
				sql += " where answer_time>=" + StrUtil.sqlstr(beginDate);
			if (!endDate.equals("")) {
				if (beginDate.equals(""))
					sql += " where answer_time<=" + StrUtil.sqlstr(endDate);
				else
					sql += " and answer_time<=" + StrUtil.sqlstr(endDate);
			}
			
        	ExamConfig myconfig = ExamConfig.getInstance();
        	int maxMonth = myconfig.getIntProperty("exam.action_expire_minute");			
			sql += " group by user_name having count(*)>=" + maxMonth;
			sql += " order by answer_time desc";
		}
		else if (op.equals("search")) {
			sql = "select id from " + mud.getTable().getName() + " where user_name like " + StrUtil.sqlstr("%" + userName + "%") + " order by answer_time desc";
		}
		else if (op.equals("listQuery")) {
			sql = "select id from " + mud.getTable().getName();
			if (!beginDate.equals(""))
				sql += " where answer_time>=" + StrUtil.sqlstr(beginDate);
			if (!endDate.equals("")) {
				if (beginDate.equals(""))
					sql += " where answer_time<=" + StrUtil.sqlstr(endDate);
				else
					sql += " and answer_time<=" + StrUtil.sqlstr(endDate);
			}
			sql += " order by answer_time desc";
		}
		
		// out.print(sql);
		
		int curpage = StrUtil.toInt(strcurpage, 1);
		
		long total = 0;
		if (op.equals("listOk")) {
			Conn conn = null;
			try {
				conn = new Conn(Global.defaultDB);
				conn.executeQuery(sql);
				total = conn.getRows();
			}
			catch (Exception e) {
				e.printStackTrace();
			}
			finally {
				conn.close();
			}
		}
		else
	    	total = mud.getQObjectCount(sql);
		QObjectBlockIterator obi = mud.getQObjects(sql, (curpage-1)*pagesize, curpage*pagesize);
		
		Paginator paginator = new Paginator(request, total, pagesize);
		// 设置当前页数和总页数
		int totalpages = paginator.getTotalPages();
		if (totalpages==0) {
			curpage = 1;
			totalpages = 1;
		}
%>	
      <table width="98%" border="0" align="center" class="p9">
        <tr>
          <td align="right"><%=paginator.getPageStatics(request)%></td>
        </tr>
      </table>
      <table width="98%"  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#999999" class="tableframe_gray">
      <tr align="center">
        <td width="11%" height="24" bgcolor="#EFEBDE">用户名</td>
        <td width="15%" bgcolor="#EFEBDE">呢称</td>
        <td width="20%" height="22" bgcolor="#EFEBDE">飞信号</td>
        <td width="18%" bgcolor="#EFEBDE">题号</td>
        <td width="24%" bgcolor="#EFEBDE">答题时间</td>
        <td width="12%" height="22" bgcolor="#EFEBDE">操作</td>
      </tr>
<%
UserMgr um = new UserMgr();
while (obi.hasNext()) {
	UserAnswerDb uad = (UserAnswerDb)obi.next();
	UserDb user = um.getUser(uad.getString("user_name"));
%>
      <tr align="center">
        <td height="22" bgcolor="#FFFBFF"><%=uad.getString("user_name")%></td>
        <td bgcolor="#FFFBFF"><%=user.getNick()%></td>
        <td height="22" align="left" bgcolor="#FFFBFF"><%=user.getFetion()%></td>
        <td align="left" bgcolor="#FFFBFF"><%=uad.getLong("question_id")%></td>
        <td align="left" bgcolor="#FFFBFF"><%=DateUtil.format(uad.getDate("answer_time"), "yyyy-MM-dd HH:mm")%></td>
        <td height="22" bgcolor="#FFFBFF">&nbsp;<a href="#" onClick="if (confirm('您确定要删除吗？')) window.location.href='user_answer_list.jsp?op=del&id=<%=uad.getLong("id")%>'">删除</a></td>
      </tr>
<%}%>
    </table>

      <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
        <tr>
          <td height="23" align="right"><%
				String querystr = "op=" + op + "&userName=" + StrUtil.sqlstr(userName) + "&beginDate=" + beginDate + "&endDate=" + endDate + "&pageSize=" + pagesize;
				out.print(paginator.getPageBlock(request,"user_answer_list.jsp?"+querystr));
				%>
            &nbsp;&nbsp;</td>
        </tr>
      </table>
      <br>
    <br></td>
  </tr>
</table>
</td> </tr>             
      </table>                                        
       </td>                                        
     </tr>                                        
 </table>                                        
                               
</body>         
                               
</html>                            
  