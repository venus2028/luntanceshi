<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*,
				 java.text.*,
				 com.redmoon.blog.*,
				 com.redmoon.blog.photo.*,
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
function setPhoto(photoId) {
window.opener.setPhoto(photoId);
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
%>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
  <TR>
    <TD class=head>选择相片</TD>
  </TR></TBODY></TABLE>
<br>
<%
int pagesize = 20;
Paginator paginator = new Paginator(request);

PhotoDb pd = new PhotoDb();
String sql = "select id from blog_photo";
String searchType = ParamUtil.get(request, "searchType");
String action = ParamUtil.get(request, "action");
String what = ParamUtil.get(request, "what");
if (action.equals("search")) {
	if (searchType.equals("title")) {
		sql = sql + " where title like " + StrUtil.sqlstr("%" + what + "%");
	}
	else if (searchType.equals("user")) {
		UserMgr um = new UserMgr();
		UserDb ud = um.getUserDbByNick(what);
		if (ud!=null) {
			UserConfigDb ucd = new UserConfigDb();
			ucd = ucd.getUserConfigDbByUserName(ud.getName());
			if(ucd == null) {
				out.println(StrUtil.Alert_Back("用户 " + what + " 博客尚未开通！"));
			}
			long blogId = ucd.getId();
			sql = sql + " where blog_id=" + blogId;
		} else {
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
			sql = sql + " where blog_id=" + what;
	}
}

sql += " order by addDate desc";

int total = pd.getObjectCount(sql);
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
      <form name="form1" action="photo_sel.jsp?action=search" method="post">
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
            <td width="32%"><strong>标题</strong></td>
            <td width="21%"><strong>博客</strong></td>
            <td width="18%"><strong>发布日期</strong></td>
			<td width="15%" height="24"><strong>得分</strong></td>
            <td width="14%"><strong>操作</strong></td>
          </tr>
<%
Vector v = pd.list(sql, (curpage-1)*pagesize, curpage*pagesize-1);
Iterator ir = v.iterator();
int i = 0;
while (ir.hasNext()) {
	pd = (PhotoDb)ir.next();
	i++;
%>
            <tr align="center">
              <td height="22" bgcolor="#FFFFFF"><a href="../showphoto.jsp?photoId=<%=pd.getId()%>" target="_blank"><%=pd.getTitle()%></a></td>
              <td height="22" bgcolor="#FFFFFF"><%
				  UserConfigDb ucd = new UserConfigDb();
			      ucd = ucd.getUserConfigDb(pd.getBlogId());
			  %>
                <%=ucd.getPenName()%> </td>
              <td bgcolor="#FFFFFF"><%=DateUtil.format(pd.getAddDate(),"yy-MM-dd HH:mm:ss")%></td>
              <td bgcolor="#FFFFFF"><%=pd.getScore()%></td>
              <td height="22" bgcolor="#FFFFFF"><a href="#" onClick="setPhoto('<%=pd.getId()%>')"><lt:Label res="res.label.forum.admin.forum_user_sel" key="select"/></a></td>
            </tr>
          <%}%>
      </table>
      <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
          <tr>
            <td height="23"><div align="right">
<%
	String querystr = "action=" + action + "&searchType=" + searchType + "&what=" + StrUtil.UrlEncode(what);;
    out.print(paginator.getPageBlock(request, "photo_sel.jsp?"+querystr));
%>
            </div></td>
          </tr>
    </table></td>
  </tr>
</table>
<br>
</BODY></HTML>
