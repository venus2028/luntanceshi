<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.plugin.witkey.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isUserLogin(request)) {
	response.sendRedirect("../../../door.jsp");
	return;
}

String userName = privilege.getUser(request);

String msgId = ParamUtil.get(request, "msgId");
if (msgId.equals("")) {
	out.print(SkinUtil.makeErrMsg(request, "缺少文章编号！"));
	return;
}

MsgMgr mm = new MsgMgr();
MsgDb md = mm.getMsgDb(Long.parseLong(msgId));

WitkeyDb wd = new WitkeyDb();

Timestamp ts = new Timestamp(System.currentTimeMillis());
java.util.Date date = DateUtil.parse(ts.toString(), "yyyy-MM-dd");

wd = wd.getWitkeyDb(md.getRootid());
if (date.getTime() > Long.parseLong(wd.getEndDate())) {
	out.print(SkinUtil.makeErrMsg(request, "该威客项目已经过期！"));
	return;
}

String boardcode = ParamUtil.get(request, "boardCode");

Leaf curleaf = new Leaf();
curleaf = curleaf.getLeaf(boardcode);

// 取得皮肤路径
String skinPath = SkinMgr.getSkinPath(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<LINK href="../../<%=skinPath%>/css.css" type=text/css rel=stylesheet>
<title><%=Global.AppName%> - 显示用户详细信息</title>
</head>
<body>
<div id="wrapper">
<%@ include file="../../inc/header.jsp"%>
<div id="main">
<%@ include file="../../inc/position.jsp"%>
<table class="tableCommon" width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
	  <a href="../../showtopic_tree.jsp?rootid=<%=md.getRootid()%>&showid=<%=md.getId()%>"><%=md.getTitle()%></a> </td>
  </tr>
</table><br />
<%		
		String sql = "select id from plugin_witkey_evaluation where msg_id=" + msgId + " order by add_date desc";
		
		WitkeyEvaluationDb wed = new WitkeyEvaluationDb();
		int pagesize = 10;
		Paginator paginator = new Paginator(request);
		int curpage = paginator.getCurPage();
					
		ListResult lr = wed.listResult(sql, curpage, pagesize);
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

		UserDb ud = new UserDb();
		while (ir.hasNext())
		{
			wed = (WitkeyEvaluationDb)ir.next();
			ud = ud.getUser(wed.getUserName());
			Timestamp ts1 = new Timestamp(Long.parseLong(wed.getAddDate()));				
%>
<TABLE width="100%" class="tableCommon">
    <thead>
      <TR> 
        <TD width=17% height=23 align="center"><strong>用户名</strong></TD>
        <TD width=23% height="23" align="center"><%=ud.getNick()%></TD>
        <TD width=30% align="center"><strong>评论时间</strong></TD>
        <TD width=30% align="center"><%=DateUtil.format(DateUtil.parse(ts1.toString(), "yyyy-MM-dd HH:mm:ss"), "yyyy-MM-dd HH:mm:ss")%></TD>
      </TR>
	</thead>
      <TR align="center"> 
        <TD><strong>评论内容</strong></TD>
        <TD colspan="3" align="left"><%=StrUtil.toHtml(wed.getContent())%></TD>
      </TR>
	</TBODY>
</TABLE>
<%
		}
%>
  <table class="per100" width="80%" align="center"> 
    <tr> 
      <td align="right"><%
				String querystr = "msgId=" + msgId + "&boardCode=" + boardcode;
				out.print(paginator.getCurPageBlock(request, "evaluation.jsp?"+querystr));
				%></td>
    </tr>
</table>
<br>
<%if (privilege.getUser(request).equals(wd.getUserName())) {%>
<br>
<form action="witkey_do.jsp?op=evaluation" method="post">
<table class="tableCommon60">
        <thead>
          <tr>
            <td colSpan="2" align="center">点评</td>
          </tr>
		</tr>
		</thead>
          <tr>
            <td width="77" height="98" align="right">我要点评：</td>
            <td width="281" height="98"><textarea name="content" cols="35" rows="5" id="content"></textarea></td>
          </tr>
          <tr align="center">
            <td height="30" colspan="2"><input type="submit" name="Submit" value=" 提 交 ">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <input type="reset" name="Submit" value=" 重 置 ">
          <input type="hidden" name="msgId" value="<%=msgId%>">
		  <input type="hidden" name="boardCode" value="<%=boardcode%>"></td>
          </tr>
        </tbody>
</table>
</form>
<%}%>
</div>
<%@ include file="../../inc/footer.jsp"%>
</div>
</body>
</html>
