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
/*Tooltips*/
.tooltips{
position:relative; /*这个是关键*/
z-index:2;
}
.tooltips:hover{
z-index:3;
background:none; /*没有这个在IE中不可用*/
}
.tooltips span{
display: none;
}
.tooltips:hover span{ /*span 标签仅在 :hover 状态时显示*/
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
<jsp:useBean id="sm" scope="page" class="com.redmoon.blog.photo.DirMgr"/>
<%
if (!privilege.isMasterLogin(request)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String dirCode = ParamUtil.get(request, "dirCode");
String op = ParamUtil.get(request, "op");
if (op.equals("delDir")) {
	DirDb leaf = sm.getDirDb(dirCode);
	leaf.del();
	
	out.print(SkinUtil.makeInfo(request, "删除成功！"));
%>
<script>
window.parent.leftFileFrame.location.href="photo_left.jsp";
</script>
<%	
	return;
}
%>
<%
if (dirCode.equals(""))
	dirCode = DirDb.ROOTCODE;
DirDb leaf = sm.getDirDb(dirCode);
String dir_name = "";
if (leaf!=null)
	dir_name = leaf.getName();

String privurl;
if (op.equals("del")) {
	int id = ParamUtil.getInt(request, "id");
	PhotoDb ld = new PhotoDb();
    ld = ld.getPhotoDb(id);
    boolean re = ld.del(Global.getRealPath());
	if (re)
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_success"), "photo_list.jsp"));
	else
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_fail"), "photo_list.jsp"));
	return;
}

privurl = ParamUtil.get(request, "privurl");
%>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
  <TR>
    <TD class=head><%=dir_name%></TD>
  </TR></TBODY></TABLE>
<br>
<%
int pagesize = 20;

PhotoDb pd = new PhotoDb();

String sql = "select id from " + pd.getTableName() + " where dir_code=" + StrUtil.sqlstr(dirCode);

String searchType = ParamUtil.get(request, "searchType");
String action = ParamUtil.get(request, "action");
String what = ParamUtil.get(request, "what");
if (action.equals("search")) {
	if (searchType.equals("title")) {
		sql = "select id from " + pd.getTableName() + " where title like " + StrUtil.sqlstr("%" + what + "%");
	}
	else if (searchType.equals("id")) {
		if (!StrUtil.isNumeric(what)) {
			out.println(StrUtil.Alert_Back("ID必须为数字！"));
			return;
		}
		sql = "select id from " + pd.getTableName() + " where id=" + what;
	}
}

sql += " order by addDate desc";
%>
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr>
    <td valign="top"><table width="44%" border="0" align="center" cellpadding="0" cellspacing="0" class="p9">
      <form name="form1" action="photo_list.jsp?action=search" method="post">
        <tr>
          <td align="center">
		<select id="searchType" name="searchType">
        <option value="title" selected="selected">标题</option>
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
            <td width="32%" height="24"><strong>标题</strong></td>
            <td width="25%"><strong>博客</strong></td>
            <td width="10%"><strong>得分</strong></td>
            <td width="19%"><strong>发布日期</strong></td>
            <td width="14%"><strong><lt:Label res="res.label.blog.admin.blog" key="operate"/></strong></td>
          </tr>
<%
com.redmoon.forum.Config cfg = com.redmoon.forum.Config.getInstance();
String attachmentBasePath = request.getContextPath() + "/upfile/" + pd.photoBasePath + "/";
boolean isFtpUsed = cfg.getBooleanProperty("forum.ftpUsed");
if (isFtpUsed) {
	attachmentBasePath = cfg.getProperty("forum.ftpUrl");
	if (attachmentBasePath.lastIndexOf("/")!=attachmentBasePath.length()-1)
		attachmentBasePath += "/";
	attachmentBasePath += pd.photoBasePath + "/";
}

UserConfigMgr ucm = new UserConfigMgr();		
Iterator ir = lr.getResult().iterator();
int i = 0;
while (ir.hasNext()) {
	i ++;
	pd = (PhotoDb) ir.next(); 
	UserConfigDb ucd = ucm.getUserConfigDb(pd.getBlogId());
%>
          <form id="form<%=i%>" name="form<%=i%>" action="?op=modify" method="post">
            <tr align="center">
              <td align="left" bgcolor="#FFFFFF">
		<a class="tooltips" href="../showphoto.jsp?blogId=<%=pd.getBlogId()%>&id=<%=pd.getId()%>" target=_blank>
		<%=pd.getTitle()%>
		<span><img src="<%=attachmentBasePath+pd.getImage()%>"></span></a>			  </td>
              <td align="left" bgcolor="#FFFFFF"><a target=_blank href="../myblog.jsp?blogId=<%=ucd.getId()%>"><%=StrUtil.toHtml(ucd.getTitle())%></a></td>
              <td align="left" bgcolor="#FFFFFF"><%=pd.getScore()%></td>
              <td bgcolor="#FFFFFF"><%=DateUtil.format(pd.getAddDate(), "yy-MM-dd HH:mm:ss")%></td>
              <td height="22" bgcolor="#FFFFFF">
			  <a href="#" onClick="if (confirm('您确定要删除吗？')) window.location.href='photo_list.jsp?op=del&id=<%=pd.getId()%>&CPages=<%=curpage%>'"><lt:Label res="res.label.blog.admin.blog" key="del"/></a>			  </td>
            </tr>
          </form>
          <%}%>
      </table>
      <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
          <tr>
            <td height="23"><div align="right">
<%
	String querystr = "action=" + action + "&searchType=" + searchType + "&what=" + StrUtil.UrlEncode(what);;
    out.print(paginator.getPageBlock(request, "photo_list.jsp?"+querystr));
%>
            </div></td>
          </tr>
    </table>
      <table width="98%" border=0 align="center" cellpadding=0 cellspacing=0 id="uploadTable">
        <form name=formSubDir target="leftFileFrame" action="photo_left.jsp?op=AddChild" method="post">
          <tr>
            <td align="right" valign=top class=tablebody1><input name="name" size="10">
                <input name="submit2" type=submit value="添子目录">
                <input name="parent_code" type="hidden" value="<%=dirCode%>">
                <input name="code" type="hidden" value="<%=cn.js.fan.util.RandomSecquenceCreator.getId(20)%>">
                <input name="type" type="hidden" value="1">
                <a href="blog_photo_dir_modify.jsp?code=<%=StrUtil.UrlEncode(dirCode)%>">修改目录</a>&nbsp;
                <%if (!dirCode.equals("root")) {%>
                <a href="javascript:if (confirm('您确定要删除吗？')) window.location.href='photo_list.jsp?op=delDir&dirCode=<%=StrUtil.UrlEncode(dirCode)%>'">删除目录</a>
                <%}%></td>
          </tr>
        </form>
    </table></td>
  </tr>
</table>
<br>
</BODY></HTML>
