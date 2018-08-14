<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.plugin.witkey.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String skinPath = SkinMgr.getSkinPath(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../../<%=skinPath%>/css.css" rel="stylesheet" type="text/css">
<title>威客列表 - <%=Global.AppName%></title>
</head>
<body>
<div id="wrapper">
<%@ include file="../../inc/header.jsp"%>
<div id="main">
<%@ include file="../../inc/position.jsp"%><jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
	String querystring = StrUtil.getNullString(request.getQueryString());
	String privurl=request.getRequestURL()+"?"+StrUtil.UrlEncode(querystring,"utf-8");
	if (!privilege.isUserLogin(request))
	{
		response.sendRedirect("../../../door.jsp");
		return;
	}
	
	long msgId = ParamUtil.getLong(request, "msgId", -1);
	if (msgId==-1) {
		out.print(SkinUtil.makeErrMsg(request, "缺少贴子编号！"));
		return;
	}
	
	MsgDb md = new MsgDb();
	md = md.getMsgDb(msgId);
	
	String sql = "select msg_root_id,user_name from plugin_witkey_user where msg_root_id=" + msgId + " order by add_date desc";
	
	WitkeyUserDb wud = new WitkeyUserDb();
	int pagesize = 10;
	Paginator paginator = new Paginator(request);
	int curpage = paginator.getCurPage();
				
	ListResult lr = wud.listResult(sql, curpage, pagesize);
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
	
	boolean isOwner = privilege.getUser(request).equals(md.getName());
%>
  <div class="tableTitle">报名威客列表&nbsp;-&nbsp;返回任务：<a href="<%=request.getContextPath()%>/forum/showtopic.jsp?rootid=<%=msgId%>"><%=md.getTitle()%></a></div> 
  <TABLE width="98%" class="tableCommon">
    <thead>
      <TR> 
        <TD width=10% align="center">用户名</TD>
        <TD width=10% align="center">真实姓名</TD>
        <TD width=10% align="center">所在城市</TD>
        <TD width=10% align="center">联系电话</TD>
        <TD width=10% align="center">OICQ号码</TD>
        <TD width=23% height=23 align="center">其他联系方式</TD>
        <TD width=15% align="center">报名时间</TD>
        <TD width=12% align="center">投稿情况</TD>
      </TR>
	</thead>
<%		
		UserDb ud = new UserDb();
		String contribution = "";
		while (ir.hasNext())
		{
			wud = (WitkeyUserDb)ir.next();
			ud = ud.getUser(wud.getUserName());
			Timestamp ts = new Timestamp(Long.parseLong(wud.getAddDate()));
			
			if(wud.getContributionCount() > 0)
				contribution = "<a href='../../showtopic.jsp?rootid=" + msgId + "&pluginCode=" + WitkeyUnit.code + "&replytype=" + WitkeyReplyDb.REPLY_TYPE_CONTRIBUTION + "&userName=" + wud.getUserName() + "'>" + "已交稿" + Integer.toString(wud.getContributionCount()) + "次" + "</a>";
			else
				contribution = "还未交稿";
			
%>
      <TR> 
        <TD height=23><a href="../../../userinfo.jsp?username=<%=StrUtil.UrlEncode(wud.getUserName())%>" target="_blank"><%=ud.getNick()%></a></TD>
        <TD height=23><%=isOwner?wud.getRealName():"*****"%></TD>
        <TD height=23><%=wud.getCity()%></TD>
        <TD height=23><%=isOwner?wud.getTel():"******"%></TD>
        <TD height=23><%=isOwner?wud.getOicq():"*****"%></TD>
        <TD height=23><%=isOwner?wud.getOtherContact():"*****"%></TD>
        <TD height=23><%=DateUtil.format(DateUtil.parse(ts.toString(), "yyyy-MM-dd HH:mm:ss"), "yyyy-MM-dd HH:mm:ss")%></TD>
        <TD height=23><%=contribution%></TD>
      </TR>
<%
		}
%>
    </TBODY>
  </TABLE>
  <table class="per100" width="98%" align="center"> 
    <tr> 
      <td align="right"><%
				String querystr = "";
				out.print(paginator.getCurPageBlock(request, "userinfo_list.jsp?"+querystr));
				%></td>
    </tr>
</table>
<br>
</div>
<%@ include file="../../inc/footer.jsp"%>
</div>
</body>
</html>
