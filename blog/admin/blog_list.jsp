<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*,
				 com.redmoon.blog.*,
				 cn.js.fan.db.*,
				 cn.js.fan.util.*,
				 com.redmoon.forum.person.UserMgr,
				 com.redmoon.forum.person.UserDb,
				 cn.js.fan.web.*"
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
</HEAD>
<BODY text=#000000 bgColor=#eeeeee leftMargin=0 topMargin=0>
<%
if (!com.redmoon.forum.Privilege.isMasterLogin(request)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String privurl;
String op = ParamUtil.get(request, "op");
if (op.equals("stop")) {
	privurl = ParamUtil.get(request, "privurl");
	long blogId = ParamUtil.getLong(request, "blogId");
	UserConfigDb uc = new UserConfigDb();
	uc = uc.getUserConfigDb(blogId);
	int isValid = ParamUtil.getInt(request, "isValid");
	uc.setValid(isValid==1?true:false);
	if (uc.save()) {
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_success"), privurl));
	}
	else {
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_fail"), privurl));
	}
	return;
}
else if (op.equals("del")) {
	long blogId = ParamUtil.getLong(request, "blogId");
	UserConfigDb uc = new UserConfigDb();
	uc = uc.getUserConfigDb(blogId);
	if (uc.del())
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_success"), "blog_list.jsp"));
	else
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_fail"), "blog_list.jsp"));
	return;
}

String orderBy = ParamUtil.get(request, "orderBy");
String sort = ParamUtil.get(request, "sort");
if (orderBy.equals(""))
	orderBy = "addDate";
if (sort.equals(""))
	sort = "desc";

privurl = ParamUtil.get(request, "privurl");
%>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
  <TR>
    <TD class=head><lt:Label res="res.label.blog.admin.blog" key="blog_management"/></TD>
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
String type = ParamUtil.get(request, "type");
String kind = ParamUtil.get(request, "kind");
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
	if (!type.equals("")) {
		sql += " and blog_type=" + type;
	}
	if (!kind.equals("")) {
		sql += " and kind=" + StrUtil.sqlstr(kind);
	}
	
}

sql += " order by " + orderBy + " " + sort;

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
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" class="p9">
      <form name="form1" action="blog_list.jsp?action=search" method="post">
        <tr>
          <td align="center"> 类型
            <select name="kind">
			<option value=""><lt:Label key="wu" /></option>
    <%
	com.redmoon.blog.LeafChildrenCacheMgr dlcm = new com.redmoon.blog.LeafChildrenCacheMgr("root");
	java.util.Vector vt = dlcm.getDirList();
	Iterator irv = vt.iterator();
	while (irv.hasNext()) {
		com.redmoon.blog.Leaf leaf = (com.redmoon.blog.Leaf) irv.next();
		String parentCode = leaf.getCode();
	%>
        <option value="<%=leaf.getCode()%>"><%=leaf.getName()%></option>
        <%}%>
      </select>		  
            <lt:Label res="res.label.blog.admin.blog" key="type"/>
            <select name="type">
			<option value=""><lt:Label key="wu" /></option>
			<option value="<%=UserConfigDb.TYPE_GROUP%>"><lt:Label res="res.label.blog.admin.blog" key="team"/></option>
			<option value="<%=UserConfigDb.TYPE_PERSON%>"><lt:Label res="res.label.blog.admin.blog" key="personal"/></option>
			</select>
            <select id="searchType" name="searchType">
              <option value="title" selected="selected">标题</option>
              <option value="user">用户名</option>									  							  								  
              <option value="id">ID</option>									  							  								  
              </select>
            <input id="what" name="what" type="text" />
        <%if (!searchType.equals("")) {%>
        <script>
		form1.searchType.value = "<%=searchType%>";
		form1.what.value = "<%=what%>";
		form1.type.value = "<%=type%>";
		form1.kind.value = "<%=kind%>";
		</script>
            <%}%>&nbsp;
            <input name="Submit" type="submit" value="搜索">
          </td></tr>
      </form>
    </table>
      <br>
        <table width="98%" height="24" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td align="right">
			<%=paginator.getPageStatics(request)%>			</td>
          </tr>
      </table>
      <table width="99%"  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#CCCCCC">
          <tr align="center" bgcolor="#F1EDF3">
            <td width="8%" height="24"><strong><lt:Label res="res.label.blog.admin.blog" key="username"/></strong></td>
            <td width="39%"><strong>标题</strong></td>
            <td width="7%" onClick="doSort('msgCount')" style="cursor:hand"><strong>文章</strong>
              <%if (orderBy.equals("msgCount")) {
			if (sort.equals("asc")) 
				out.print("<img src='../../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../../netdisk/images/arrow_down.gif' width=8px height=7px>");
			}%>
            </td>
            <td width="7%" onClick="doSort('replyCount')" style="cursor:hand"><strong>评论</strong>
              <%if (orderBy.equals("replyCount")) {
			if (sort.equals("asc")) 
				out.print("<img src='../../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../../netdisk/images/arrow_down.gif' width=8px height=7px>");
			}%>
            </td>
            <td width="7%" onClick="doSort('viewcount')" style="cursor:hand"><strong>访问
              <%if (orderBy.equals("viewcount")) {
			if (sort.equals("asc")) 
				out.print("<img src='../../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%>
            </strong></td>
            <td width="7%"><strong><lt:Label res="res.label.blog.admin.blog" key="type"/></strong></td>
            <td width="11%" style="cursor:hand" onClick="doSort('addDate')"><strong><lt:Label res="res.label.blog.admin.blog" key="adddate"/>
			<%if (orderBy.equals("addDate")) {
			if (sort.equals("asc")) 
				out.print("<img src='../../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../../netdisk/images/arrow_down.gif' width=8px height=7px>");
			}%>
			</strong></td>
            <td width="14%"><strong><lt:Label res="res.label.blog.admin.blog" key="operate"/></strong></td>
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
              <td height="20" bgcolor="#FFFFFF">
			  <a target=_blank href="../myblog.jsp?blogId=<%=ucd.getId()%>">
			  <%
			  UserDb ud = um.getUser(ucd.getUserName());
			  out.print(ud.getNick());
			  %>
			  </a></td>
              <td align="left" bgcolor="#FFFFFF"><%=StrUtil.toHtml(ucd.getTitle())%></td>
              <td bgcolor="#FFFFFF"><%=ucd.getMsgCount()%></td>
              <td bgcolor="#FFFFFF"><%=ucd.getReplyCount()%></td>
              <td bgcolor="#FFFFFF"><%=ucd.getViewCount()%></td>
              <td bgcolor="#FFFFFF">
			  <%if (ucd.getType()==UserConfigDb.TYPE_GROUP) {%>
			  <lt:Label res="res.label.blog.admin.blog" key="team"/>
			  <%}else{%>
			  <lt:Label res="res.label.blog.admin.blog" key="personal"/>
			  <%}%>			  </td>
              <td bgcolor="#FFFFFF"><%=DateUtil.format(ucd.getAddDate(), "yy-MM-dd HH:mm:ss")%></td>
              <td height="22" bgcolor="#FFFFFF">
			  <%if (ucd.isValid()) {%>
			  <lt:Label res="res.label.blog.admin.blog" key="used"/>&nbsp;&nbsp;<a title="<lt:Label res="res.label.blog.admin.blog" key="no_use_userblog"/>" href="?op=stop&blogId=<%=ucd.getId()%>&privurl=<%=StrUtil.getUrl(request)%>&isValid=0"><lt:Label res="res.label.blog.admin.blog" key="no_use"/></a>
			  <%}else{%>
			  <lt:Label res="res.label.blog.admin.blog" key="no_used"/>&nbsp;&nbsp;<a title="<lt:Label res="res.label.blog.admin.blog" key="use_userblog"/>" href="?op=stop&blogId=<%=ucd.getId()%>&privurl=<%=StrUtil.getUrl(request)%>&isValid=1"><font color=red><lt:Label res="res.label.blog.admin.blog" key="use"/></font></a>
			  <%}%>
			  &nbsp;<a href="javascript:if (confirm('您确定要删除吗？')) window.location.href='blog_list.jsp?op=del&blogId=<%=ucd.getId()%>'"><lt:Label res="res.label.blog.admin.blog" key="del"/></a>			  </td>
            </tr>
          </form>
          <%}%>
      </table>
      <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
          <tr>
            <td height="23"><div align="right">
<%
	String querystr = "action=" + action + "&searchType=" + searchType + "&what=" + StrUtil.UrlEncode(what) + "&type=" + type + "&orderBy=" + orderBy + "&sort=" + sort + "&kind=" + StrUtil.UrlEncode(kind);
    out.print(paginator.getPageBlock(request, "blog_list.jsp?"+querystr));
%>
            </div></td>
          </tr>
    </table></td>
  </tr>
</table>
<br>
</BODY>
<script>
var curOrderBy = "<%=orderBy%>";
var sort = "<%=sort%>";	
function doSort(orderBy) {
	if (orderBy==curOrderBy)
		if (sort=="asc")
			sort = "desc";
		else
			sort = "asc";
	window.location.href = "blog_list.jsp?action=<%=action%>&op=<%=op%>&orderBy="+orderBy+"&sort="+sort+"&type=<%=type%>&searchType=<%=searchType%>&what=<%=StrUtil.UrlEncode(what)%>";
}
</script>
</HTML>
