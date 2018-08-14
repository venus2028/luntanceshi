<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="org.jdom.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.jdom.output.*"%>
<%@ page import="org.jdom.input.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.security.*"%>
<%@ page import="com.cloudwebsoft.framework.base.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
String blogUserDir = ParamUtil.get(request, "blogUserDir");
String skinPath = "skin/default";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML><HEAD><TITLE><%=Global.AppName%></TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<%@ include file="../../inc/nocache.jsp"%>
<link href="../../cms/default.css" rel="stylesheet" type="text/css">
<SCRIPT>
function openWin(url,width,height) {
  var newwin = window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,top=50,left=120,width="+width+",height="+height);
}
</SCRIPT>
<META content="MSHTML 6.00.2600.0" name=GENERATOR>
<style type="text/css">
<!--
.STYLE1 {color: #FFFFFF}
-->
</style>
</HEAD>
<BODY leftmargin="0" topMargin=0>
<jsp:useBean id="dir" scope="page" class="com.redmoon.blog.UserDirDb"/>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head"><lt:Label res="res.label.blog.user.frame" key="team_member"/></td>
  </tr>
</table>
<%
if (!privilege.isUserLogin(request)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

long blogId = ParamUtil.getLong(request, "blog_id", UserConfigDb.NO_BLOG);

UserConfigDb ucd = new UserConfigDb();
ucd = ucd.getUserConfigDb(blogId);
if (!ucd.isLoaded()) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request,"res.label.blog.list", "activate_blog_fail")));
	return;
}

String user = privilege.getUser(request);
if (!ucd.getUserName().equals(user)) {
	if (!privilege.isMasterLogin(request)) {
		out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request,"res.label.blog.user.dir", "not_priv")));
		return;
	}
}

BlogGroupUserDb bgu = new BlogGroupUserDb();

String op = ParamUtil.get(request, "op");
if (op.equals("modify")) {
	QObjectMgr qom = new QObjectMgr();
	long blog_id = ParamUtil.getLong(request, "blog_id");
	String userName = ParamUtil.get(request, "user_name");
	bgu = bgu.getBlogGroupUserDb(blog_id, userName);
	try {
		if (qom.save(request, bgu, "blog_group_user_save")) {
			bgu.refreshList();		
			out.print("<BR>");
			out.print("<BR>");
			out.print(StrUtil.waitJump(SkinUtil.LoadString(request, "info_op_success"), 1, "listmember.jsp?blog_id=" + blogId));
			return;
		}
		else {
			out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
			return;
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
}
%>
<table width="100%" border="0">
  <tr>
    <td>
	&nbsp;<a href="listmember.jsp?blog_id=<%=blogId%>">全部用户</a>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listmember.jsp?blog_id=<%=blogId%>&show=checked">已审核通过用户</a>
	&nbsp;&nbsp;&nbsp;&nbsp; <a href="listmember.jsp?blog_id=<%=blogId%>&show=not_checked">未审核用户</a>&nbsp;</td>
  </tr>
  <tr>
    <td height="1" align="center" background="../../images/comm_dot.gif"></td>
  </tr>
</table>
<br>
<TABLE width="98%" 
border=0 align=center cellPadding=1 cellSpacing=1 class="frame_gray">
    <TBODY>
      <TR height=25> 
        <TD height="26" colSpan=3 align=center noWrap class="thead">用户名</TD>
        <TD width="198" align=center noWrap class="thead">加入理由</TD>
        <TD width=69 align=center noWrap class="thead">申请日期</TD>
        <TD width=60 height="26" align=center noWrap class="thead">管理员</TD>
        <TD width=66 align=center noWrap class="thead">管理目录</TD>
        <TD width=50 height="26" align=center noWrap class="thead">管理贴子 </TD>
        <TD width=68 align=center noWrap class="thead">审核通过</TD>
        <TD width=97 align=center noWrap class="thead">操作</TD>
      </TR>
<%
UserMgr um = new UserMgr();
String sql = "select blog_id,user_name from " + bgu.getTable().getName() + " where blog_id=" + blogId;
String show = ParamUtil.get(request, "show");
if (show.equals("checked")) {
	sql = "select blog_id,user_name from " + bgu.getTable().getName() + " where blog_id=" + blogId + " and check_status=" + BlogGroupUserDb.CHECK_STATUS_PASSED;
}
else if (show.equals("not_checked")) {
	sql = "select blog_id,user_name from " + bgu.getTable().getName() + " where blog_id=" + blogId + " and check_status=" + BlogGroupUserDb.CHECK_STATUS_NOT;
}
long count = bgu.getQObjectCount(sql);
QObjectBlockIterator qi = bgu.getQObjects(sql, 0, (int)count);
int i = 0;
while (qi.hasNext()) {
	bgu = (BlogGroupUserDb)qi.next();
	i++;
%>
      <TR height=25>
	  <form name="form<%=i%>" action="?op=modify" method="post">
        <TD height="26" colSpan=3 align=middle noWrap bgcolor="#FFFFFF">
		<a target="_blank" href="../../userinfo.jsp?username=<%=StrUtil.UrlEncode(bgu.getString("user_name"))%>"><%=um.getUser(bgu.getString("user_name")).getNick()%></a>
		<input type="hidden" name="blog_id" value="<%=blogId%>">
		<input type="hidden" name="user_name" value="<%=bgu.getString("user_name")%>">		</TD>
        <TD align=middle noWrap bgcolor="#FFFFFF"><%=bgu.getString("apply_reason")%>&nbsp;</TD>
        <TD align=center noWrap bgcolor="#FFFFFF"><%=ForumSkin.formatDate(request, bgu.getDate("add_date"))%></TD>
        <TD height="26" align=center noWrap bgcolor="#FFFFFF">
		<input name="priv_all" value="1" type="checkbox" <%=bgu.getString("priv_all").equals("1")?"checked":""%>>		</TD>
        <TD align=center noWrap bgcolor="#FFFFFF"><input name="priv_dir" value="1" type="checkbox" <%=bgu.getString("priv_dir").equals("1")?"checked":""%>></TD>
        <TD height="26" align=center noWrap bgcolor="#FFFFFF"><input name="priv_topic" value="1" type="checkbox" <%=bgu.getString("priv_topic").equals("1")?"checked":""%>></TD>
        <TD align=center noWrap bgcolor="#FFFFFF"><input name="check_status" value="1" type="checkbox" <%=bgu.getString("check_status").equals("1")?"checked":""%>></TD>
        <TD align=middle noWrap bgcolor="#FFFFFF"><input name="submit" type=submit value="<lt:Label key="submit"/>"></TD>
	  </form>
      </TR>
<%}%>	  
    </TBODY>
</TABLE>
</BODY></HTML>
