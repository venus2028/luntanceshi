<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*,
				 java.text.*,
				 com.redmoon.blog.*,
				 com.redmoon.blog.ui.*,				 
				 cn.js.fan.db.*,
				 cn.js.fan.util.*,
				 cn.js.fan.web.*"
%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<HTML><HEAD><TITLE>图片管理</TITLE>
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
<style type="text/css">
.tooltips{
position:relative;
z-index:2;
}
.tooltips:hover{
z-index:3;
background:none;
}
.tooltips span{
display: none;
}
.tooltips:hover span{
display:block;
position:absolute;
top:21px;
left:9px;
width:5px;
border:0px solid black;
background-color: #FFFFFF;
padding: 3px;
color:black;
}
</style>
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
if (op.equals("del")) {
	int id = ParamUtil.getInt(request, "id");
	TemplateDb ld = new TemplateDb();
    ld = (TemplateDb)ld.getQObjectDb(new Long(id));
    boolean re = ld.del();
	if (re)
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_success"), "template_list.jsp"));
	else
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_fail"), "template_list.jsp"));
	return;
}

privurl = ParamUtil.get(request, "privurl");
%>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
  <TR>
    <TD class=head>管理模板</TD>
  </TR></TBODY></TABLE>
<br>
<%
int pagesize = 20;

TemplateDb pd = new TemplateDb();

String sql = "select id from " + pd.getTable().getName();
String searchType = ParamUtil.get(request, "searchType");
String action = ParamUtil.get(request, "action");
String what = ParamUtil.get(request, "what");
if (action.equals("search")) {
	if (searchType.equals("name")) {
		sql = "select id from " + pd.getTable().getName() + " where name like " + StrUtil.sqlstr("%" + what + "%");
	}
	else if (searchType.equals("author")) {
		sql = "select id from " + pd.getTable().getName() + " where author=" + StrUtil.sqlstr("%" + what + "%");
	}
}

sql += " order by orders asc, modify_date desc";
%>
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr>
    <td valign="top">
	<table width="52%" border="0" align="center" cellpadding="0" cellspacing="0" class="p9">
      <form name="form1" action="template_list.jsp?action=search" method="post">
        <tr>
          <td align="center">
		<select id="searchType" name="searchType">
        <option value="name" selected>标题</option>
        <option value="author">作者</option>
        </select>
        <input id="what" name="what" type="text" />
		<%if (!searchType.equals("")) {%>
		<script>
		form1.searchType.value = "<%=searchType%>";
		form1.what.value = "<%=what%>";
		</script>
		<%}%>&nbsp;
        <input name="Submit" type="submit" value="搜索">
&nbsp;&nbsp;&nbsp;<a href="template_add.jsp">添加模板</a> </td>
        </tr>
      </form>
    </table>
      <br>
<%
int total = 0;
int curpage = ParamUtil.getInt(request, "CPages", 1);
ListResult lr = pd.listResult(sql, curpage, pagesize);
if (lr!=null)
	total = lr.getTotal();
	
Paginator paginator = new Paginator(request, total, pagesize);
// 设置当前页数和总页数
int totalpages = paginator.getTotalPages();
if (totalpages==0)
{
	curpage = 1;
	totalpages = 1;
}
%>	  
        <table width="98%" height="24" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td align="right">
			<%=paginator.getPageStatics(request)%>			</td>
          </tr>
      </table>
      <table width="98%"  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#CCCCCC">
          <tr align="center" bgcolor="#F1EDF3">
            <td width="7%"><strong>缩略图</strong></td>
            <td width="52%" height="24"><strong>名称</strong></td>
            <td width="14%"><strong>作者</strong></td>
            <td width="16%"><strong>修改日期</strong></td>
            <td width="11%"><strong><lt:Label res="res.label.blog.admin.blog" key="operate"/></strong></td>
          </tr>
<%
Iterator ir = lr.getResult().iterator();
int i = 0;
while (ir.hasNext()) {
	i ++;
	pd = (TemplateDb) ir.next(); 
	String miniature = StrUtil.getNullStr(pd.getString("miniature"));
%>
          <form id="form<%=i%>" name="form<%=i%>" action="?op=modify" method="post">
            <tr align="center">
              <td align="center" bgcolor="#FFFFFF">
	  <a class="tooltips" href="#">
	  <%if (!miniature.equals("")) {%>
		<img src="<%=request.getContextPath()%>/<%=pd.getString("miniature")%>" width=30px height=30px border=0 />
	  <%}%>
		<span><img src="<%=request.getContextPath()%>/<%=pd.getString("miniature")%>" border=0 ></span></a>			  </td>
              <td align="left" bgcolor="#FFFFFF">
		<%=pd.getString("name")%>					  </td>
              <td align="left" bgcolor="#FFFFFF"><a class="tooltips" href="../showmusic.jsp?blogId=&id=<%=pd.getLong("id")%>" target=_blank><%=pd.getString("author")%></a></td>
              <td bgcolor="#FFFFFF"><%=DateUtil.format(pd.getDate("modify_date"), "yy-MM-dd HH:mm:ss")%></td>
              <td height="22" bgcolor="#FFFFFF">
			  <a href="template_edit.jsp?id=<%=pd.getLong("id")%>">编辑</a>&nbsp;&nbsp;<a href="#" onClick="if (confirm('<lt:Label key="confirm_del"/>')) window.location.href='template_list.jsp?op=del&id=<%=pd.getLong("id")%>&CPages=<%=curpage%>'">
			  <lt:Label res="res.label.blog.admin.blog" key="del"/></a>			  </td>
            </tr>
          </form>
          <%}%>
      </table>
      <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
          <tr>
            <td height="23"><div align="right">
<%
	String querystr = "action=" + action + "&searchType=" + searchType + "&what=" + StrUtil.UrlEncode(what);;
    out.print(paginator.getPageBlock(request, "template_list.jsp?"+querystr));
%>
            </div></td>
          </tr>
    </table></td>
  </tr>
</table>
<br>
</BODY></HTML>
