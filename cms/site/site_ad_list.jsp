<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*,
				 java.text.*,
				 com.cloudwebsoft.framework.base.*,
				 cn.js.fan.db.*,
				 cn.js.fan.module.cms.site.*,
				 cn.js.fan.module.cms.*,
				 cn.js.fan.util.*,
				 com.redmoon.forum.person.UserMgr,
				 com.redmoon.forum.person.UserDb,
				 cn.js.fan.web.*,
				 cn.js.fan.module.pvg.*"
%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<HTML><HEAD><TITLE>广告管理</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<LINK href="../images/default.css" type=text/css rel=stylesheet>
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
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
String siteCode = ParamUtil.get(request, "siteCode");
SiteDb sd = new SiteDb();
sd = sd.getSiteDb(siteCode);
if (!SitePrivilege.canManage(request, sd)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String op = ParamUtil.get(request, "op");
if (op.equals("del")) {
	int id = ParamUtil.getInt(request, "id");
	SiteAdDb ld = new SiteAdDb();
    ld = (SiteAdDb)ld.getQObjectDb(new Long(id));
    boolean re = ld.del();
	if (re)
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_success"), "site_ad_list.jsp?siteCode=" + siteCode));
	else
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_fail"), "site_ad_list.jsp?siteCode=" + siteCode));
	return;
}

if (op.equals("add")) {
	QObjectMgr qom = new QObjectMgr();
	SiteAdDb sad = new SiteAdDb();
	try {
		if (qom.create(request, sad, "site_ad_create")) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "site_ad_list.jsp?siteCode=" + siteCode));
		}
		else {
			out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}
%>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
  <TR>
    <TD class=head>管理广告</TD>
  </TR></TBODY></TABLE>
<br>
<%
int pagesize = 20;

SiteAdDb pd = new SiteAdDb();

String sql = "select id from " + pd.getTable().getName() + " where site_code=" + StrUtil.sqlstr(siteCode);
String searchType = ParamUtil.get(request, "searchType");
String action = ParamUtil.get(request, "action");
String what = ParamUtil.get(request, "what");
if (action.equals("search")) {
	if (searchType.equals("title")) {
		sql = "select id from " + pd.getTable().getName() + " where site_code=" + StrUtil.sqlstr(siteCode) + " and title like " + StrUtil.sqlstr("%" + what + "%");
	}
	else if (searchType.equals("content")) {
		sql = "select id from " + pd.getTable().getName() + " where site_code=" + StrUtil.sqlstr(siteCode) + " and content like " + StrUtil.sqlstr("%" + what + "%");
	}
}

sql += " order by orders, add_date desc";
%>
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr>
    <td valign="top">
	<table width="44%" border="0" align="center" cellpadding="0" cellspacing="0" class="p9">
      <form name="form1" action="site_ad_list.jsp?action=search" method="post">
        <tr>
          <td align="center">
		<select id="searchType" name="searchType">
        <option value="title" selected="selected">标题</option>
		<option value="content">内容</option>									  							  								  
        </select>
        <input id="what" name="what" type="text" />
		<%if (!searchType.equals("")) {%>
		<script>
		form1.searchType.value = "<%=searchType%>";
		form1.what.value = "<%=what%>";
		</script>
		<%}%>&nbsp;
<input name="Submit" type="submit" value="搜索">&nbsp;
<input name="siteCode" value="<%=siteCode%>" type=hidden></td>
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
            <td width="9%" class="thead">ID</td>
            <td width="49%" height="24" class="thead"><strong>标题</strong></td>
            <td width="14%" class="thead"><strong>站点</strong></td>
            <td width="15%" class="thead"><strong>发布日期</strong></td>
            <td width="13%" class="thead"><strong>
            <lt:Label res="res.label.blog.admin.blog" key="operate"/></strong></td>
          </tr>
<%
Iterator ir = lr.getResult().iterator();
int i = 0;
Directory dir = new Directory();
while (ir.hasNext()) {
	i ++;
	pd = (SiteAdDb) ir.next();
	Leaf lf = dir.getLeaf(pd.getString("site_code"));
	String siteName = "";
	if (lf!=null)
		siteName = lf.getName();
	else
		siteName = "已删除";
%>
          <form id="form<%=i%>" name="form<%=i%>" action="?op=modify" method="post">
            <tr align="center">
              <td align="left" bgcolor="#FFFFFF"><%=pd.getLong("id")%></td>
              <td align="left" bgcolor="#FFFFFF">
				<%=pd.getString("title")%>			  </td>
              <td align="left" bgcolor="#FFFFFF"><%=siteName%></td>
              <td bgcolor="#FFFFFF"><%=DateUtil.format(pd.getDate("add_date"), "yy-MM-dd HH:mm:ss")%></td>
              <td height="22" bgcolor="#FFFFFF">
			  <a href="site_ad_edit.jsp?siteCode=<%=siteCode%>&id=<%=pd.getLong("id")%>">编辑</a>&nbsp;&nbsp;<a href="#" onClick="if (confirm('您确定要删除吗？')) window.location.href='site_ad_list.jsp?op=del&id=<%=pd.getLong("id")%>&siteCode=<%=StrUtil.UrlEncode(siteCode)%>&CPages=<%=curpage%>'">
			  <lt:Label res="res.label.blog.admin.blog" key="del"/></a>			  </td>
            </tr>
          </form>
          <%}%>
      </table>
      <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
          <tr>
            <td height="23"><div align="right">
<%
	String querystr = "action=" + action + "&searchType=" + searchType + "&what=" + StrUtil.UrlEncode(what);
    out.print(paginator.getPageBlock(request, "site_ad_list.jsp?"+querystr));
%>
            </div></td>
          </tr>
    </table>
      <table width="66%" border="0" align="center" cellpadding="3" cellspacing="0" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">
        <form action="?op=add&siteCode=<%=siteCode%>" method="post" name="addform1">
          <tr>
            <td height="24" colspan="4" align="center" class="thead">发布广告</td>
          </tr>
          <tr>
            <td width="8%" height="24">名称</td>
            <td width="22%"><input name=title value=""></td>
            <td width="9%">序号</td>
            <td width="61%"><input name="orders" size="2" value="1">
            <input name="site_code" value="<%=siteCode%>" type=hidden></td>
          </tr>
          <tr>
            <td height="24">内容</td>
            <td colspan="3">
<script type="text/javascript" src="../../FCKeditor/fckeditor.js"></script>
<script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'content' ) ;
oFCKeditor.BasePath = '../../FCKeditor/';
oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_cms.jsp?dir=' + '<%=StrUtil.UrlEncode(siteCode)%>' ;
oFCKeditor.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor.Width = "100%";
oFCKeditor.Height = 150 ;

// 解决自动首尾加<p></p>的问题
oFCKeditor.Config["EnterMode"] = 'br' ;     // p | div | br （回车）
oFCKeditor.Config["ShiftEnterMode"] = 'p' ; // p | div | br（shift+enter)

oFCKeditor.Config["FormatOutput"]=false;
oFCKeditor.Config["FillEmptyBlocks"]=false;
oFCKeditor.Config["FormatIndentator"]=" ";
oFCKeditor.Config["FullPage"]=false;
oFCKeditor.Config["StartupFocus"]=true;
oFCKeditor.Config["EnableXHTML"]=false;
oFCKeditor.Config["FormatSource"]=false;
oFCKeditor.Config["SkinPath"]="skins/office2003/";

oFCKeditor.Create() ;
//-->
</script>			</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="3"><input name="submit" type=submit value="<lt:Label res="res.label.blog.user.photo" key="add"/>" width=80 height=20></td>
          </tr>
        </form>
    </table></td>
  </tr>
</table>
<br>
</BODY></HTML>
