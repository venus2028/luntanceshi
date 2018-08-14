<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*,
				 java.text.*,
				 com.redmoon.blog.*,
				 cn.js.fan.db.*,
				 cn.js.fan.util.*,
				 com.redmoon.forum.person.UserMgr,
				 com.redmoon.forum.person.UserDb,
				 cn.js.fan.web.*,
				 cn.js.fan.module.pvg.*"
%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<HTML><HEAD><TITLE><lt:Label res="res.label.blog.admin.blog" key="title"/></TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8"><LINK 
href="images/default.css" type=text/css rel=stylesheet>
<META content="MSHTML 6.00.3790.259" name=GENERATOR>
<style type="text/css">
<!--
.style1 {
	font-size: 14px;
	font-weight: bold;
}
-->
</style>
<script>
function setBlog(blogId) {
window.opener.setBlog(blogId);
window.close();
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
String op = ParamUtil.get(request, "op");
privurl = ParamUtil.get(request, "privurl");
%>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
  <TR>
    <TD class=head>选择博客</TD>
  </TR></TBODY></TABLE>
<br>
<%
int pagesize = 20;
Paginator paginator = new Paginator(request);

UserConfigDb ucd = new UserConfigDb();
String sql = "select id from " + ucd.getTableName();
String searchType = ParamUtil.get(request, "searchType");
String action = ParamUtil.get(request, "action");
String what = ParamUtil.get(request, "what");
if (action.equals("search")) {
	if (searchType.equals("title")) {
		sql = "select id from " + ucd.getTableName() + " where title like " + StrUtil.sqlstr("%" + what + "%");
	}
	else if (searchType.equals("user")) {
		UserMgr um = new UserMgr();
		UserDb ud = um.getUserDbByNick(what);
		if (ud!=null)
			sql = "select id from " + ucd.getTableName() + " where userName=" + StrUtil.sqlstr(ud.getName());
		else {
			out.println(StrUtil.Alert_Back("用户 " + what + " 不存在！"));
			return;
		}
	}
	else if (searchType.equals("id")) {
		if (!StrUtil.isNumeric(what)) {
			out.println(StrUtil.Alert_Back("ID必须为数字！"));
			return;
		}
		else
			sql = "select id from " + ucd.getTableName() + " where id=" + what;
	}
}

sql += " order by addDate desc";

int total = ucd.getObjectCount(sql);
paginator.init(total, pagesize);
int curpage = paginator.getCurPage();
//设置当前页数和总页数
int totalpages = paginator.getTotalPages();
if (totalpages==0){
	curpage = 1;
	totalpages = 1;
}
%>
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr>
    <td valign="top">
	<table width="44%" border="0" align="center" cellpadding="0" cellspacing="0" class="p9">
      <form name="form1" action="blog_sel.jsp?action=search" method="post">
        <tr>
          <td align="center"><select id="searchType" name="searchType">
        <option value="title" selected="selected">标题</option>
		<option value="user">用户名</option>									  							  								  
		<option value="id">ID</option>									  							  								  
        </select>
        <input id="what" name="what" type="text" />
		<%if (!searchType.equals("")) {%>
		<script>
		form1.searchType.value = "<%=searchType%>";
		form1.what.value = "<%=what%>";
		</script>
		<%}%>&nbsp;
        <input name="Submit" type="submit" value="搜索">
          </td>
        </tr>
      </form>
    </table>
      <br>
        <table width="98%" height="24" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td align="right">
			<%=paginator.getPageStatics(request)%>			</td>
          </tr>
      </table>
      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#CCCCCC">
          <tr align="center" bgcolor="#F1EDF3">
            <td width="13%" height="24"><strong><lt:Label res="res.label.blog.admin.blog" key="username"/></strong></td>
            <td width="35%"><strong>标题</strong></td>
            <td width="12%" height="22"><strong><lt:Label res="res.label.blog.admin.blog" key="penname"/></strong></td>
            <td width="8%"><strong><lt:Label res="res.label.blog.admin.blog" key="type"/></strong></td>
            <td width="19%"><strong>
            <lt:Label res="res.label.blog.admin.blog" key="adddate"/></strong></td>
            <td width="13%"><strong>
            <lt:Label res="res.label.blog.admin.blog" key="operate"/></strong></td>
          </tr>
<%
Vector v = ucd.list(sql, (curpage-1)*pagesize, curpage*pagesize-1);
Iterator ir = v.iterator();
int i = 0;
UserMgr um = new UserMgr();
while (ir.hasNext()) {
	ucd = (UserConfigDb)ir.next();
	i++;
%>
          <form id="form<%=i%>" name="form<%=i%>" action="?op=modify" method="post">
            <tr align="center">
              <td height="22" bgcolor="#FFFFFF">
			  <a target=_blank href="../myblog.jsp?blogId=<%=ucd.getId()%>">
			  <%
			  UserDb ud = um.getUser(ucd.getUserName());
			  out.print(ud.getNick());
			  %>
			  </a></td>
              <td bgcolor="#FFFFFF"><a href="../myblog.jsp?blogId=<%=ucd.getId()%>" target="_blank"><%=StrUtil.toHtml(ucd.getTitle())%></a></td>
              <td height="22" bgcolor="#FFFFFF"><%=StrUtil.toHtml(ucd.getPenName())%></td>
              <td bgcolor="#FFFFFF">
			  <%if (ucd.getType()==UserConfigDb.TYPE_GROUP) {%>
			  <lt:Label res="res.label.blog.admin.blog" key="team"/>
			  <%}else{%>
			  <lt:Label res="res.label.blog.admin.blog" key="personal"/>
			  <%}%>			  </td>
              <td bgcolor="#FFFFFF"><%=DateUtil.format(ucd.getAddDate(), "yy-MM-dd HH:mm:ss")%></td>
              <td height="22" bgcolor="#FFFFFF"><a href="#" onClick="setBlog('<%=ucd.getId()%>')">
                <lt:Label res="res.label.forum.admin.forum_user_sel" key="select"/>
              </a></td>
            </tr>
          </form>
          <%}%>
      </table>
      <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
          <tr>
            <td height="23"><div align="right">
<%
	String querystr = "action=" + action + "&searchType=" + searchType + "&what=" + StrUtil.UrlEncode(what);;
    out.print(paginator.getPageBlock(request, "blog_sel.jsp?"+querystr));
%>
            </div></td>
          </tr>
    </table></td>
  </tr>
</table>
<br>
</BODY></HTML>
