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
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<link href="../../<%=skinPath%>/css.css" rel="stylesheet" type="text/css">
<title>威客列表</title>
</head>
<body>
<div id="wrapper">
<%@ include file="../../inc/header.jsp"%>
<div id="main">
<%@ include file="../../inc/position.jsp"%>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
	//安全验证
	String querystring = StrUtil.getNullString(request.getQueryString());
	String privurl=request.getRequestURL()+"?"+StrUtil.UrlEncode(querystring,"utf-8");
	if (!privilege.isUserLogin(request))
	{
		response.sendRedirect("../../../door.jsp");
		return;
	}
	
	String msgId = ParamUtil.get(request, "msgId");
	if (msgId.equals("")) {
		out.print(SkinUtil.makeErrMsg(request, "缺少贴子编号！"));
		return;
	}	
	
	String sql = "select r.msg_root_id from plugin_witkey_reply r left join sq_message m on m.id=r.msg_root_id where m.rootid=" +
                      msgId +
                      " and m.check_status=" + MsgDb.CHECK_STATUS_PASS +
                      " and r.reply_type=" + WitkeyReplyDb.REPLY_TYPE_CONTRIBUTION +
                      " ORDER BY r.msg_root_id asc"; 
	
	WitkeyReplyDb wrd = new WitkeyReplyDb();
	int pagesize = 10;
	Paginator paginator = new Paginator(request);
	int curpage = paginator.getCurPage();
				
	ListResult lr = wrd.listResult(sql, curpage, pagesize);
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
  <div align="center"><font color="#706AD9"><br>
    <strong>威客投稿列表</strong></font><strong><br>
    <br>
    </strong></div> 
<%		
		UserDb ud = new UserDb();
		while (ir.hasNext())
		{
			wrd = (WitkeyReplyDb)ir.next();	
			ud = ud.getUser(wrd.getUserName());
			MsgMgr mm = new MsgMgr();
			MsgDb md = mm.getMsgDb(wrd.getMsgId());
					
%>
  <TABLE class="tableCommon" width="98%" border=0 align=center cellPadding=0 cellSpacing=1>
    <thead>
      <TR> 
        <TD width="25%" align="center">用户名：</TD>
        <TD width="25%" align="center"><%=ud.getNick()%></TD>
        <TD width="25%" align="center">操作：</TD>
        <TD width="25%" align="center">中标</TD>
      </TR>
	</thead>
      <TR> 
        <TD height=23 colspan="4"><%=md.getContent()%></TD>
      </TR>
	</TBODY>
  </TABLE>
  <br>
<%
}
%>
  <table class="per100" align="center"> 
    <tr> 
      <td align="right"><%
				String querystr = "msgId=" + msgId;
				out.print(paginator.getCurPageBlock(request, "contribution_list.jsp?"+querystr));
				%></td>
    </tr>
</table>
<br>
</div>
<%@ include file="../../inc/footer.jsp"%>
</div>
</body>
</html>
