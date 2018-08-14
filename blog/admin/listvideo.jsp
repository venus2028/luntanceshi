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
	VideoDb ld = new VideoDb();
    ld = (VideoDb)ld.getQObjectDb(new Long(id));
    boolean re = ld.del();
	if (re)
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_success"), "listvideo.jsp"));
	else
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_fail"), "listvideo.jsp"));
	return;
}

privurl = ParamUtil.get(request, "privurl");
String dir_code = ParamUtil.get(request, "dir_code");
%>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
  <TR>
    <TD class=head>管理视频</TD>
  </TR></TBODY></TABLE>
<br>
<%
int pagesize = 20;

VideoDb pd = new VideoDb();

String sql = "select id from " + pd.getTable().getName();
String searchType = ParamUtil.get(request, "searchType");
String action = ParamUtil.get(request, "action");
String what = ParamUtil.get(request, "what");
if (action.equals("search")) {
	if (searchType.equals("title")) {
		sql = "select id from " + pd.getTable().getName() + " where title like " + StrUtil.sqlstr("%" + what + "%");
	}
	else if (searchType.equals("id")) {
		if (!StrUtil.isNumeric(what)) {
			out.println(StrUtil.Alert_Back("ID必须为数字！"));
			return;
		}
		sql = "select id from " + pd.getTable().getName() + " where id=" + what;
	}
}

sql += " order by add_date desc";
%>
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr>
    <td valign="top">
	<table width="44%" border="0" align="center" cellpadding="0" cellspacing="0" class="p9">
      <form name="form1" action="listvideo.jsp?action=search" method="post">
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
      <table width="98%"  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#CCCCCC"">
          <tr align="center" bgcolor="#F1EDF3">
            <td width="42%" height="24"><strong>标题</strong></td>
            <td width="21%"><strong>博客</strong></td>
            <td width="19%"><strong>发布日期</strong></td>
            <td width="18%"><strong><lt:Label res="res.label.blog.admin.blog" key="operate"/></strong></td>
          </tr>
<%
UserConfigMgr ucm = new UserConfigMgr();		
Iterator ir = lr.getResult().iterator();
int i = 0;
while (ir.hasNext()) {
	i ++;
	pd = (VideoDb) ir.next(); 
	UserConfigDb ucd = ucm.getUserConfigDb(pd.getLong("blog_id"));
%>
          <form id="form<%=i%>" name="form<%=i%>" action="?op=modify" method="post">
            <tr align="center">
              <td align="left" bgcolor="#FFFFFF">
		<a class="tooltips" href="../showvideo.jsp?blogId=<%=pd.getLong("blog_id")%>&id=<%=pd.getLong("id")%>" target=_blank>
		<%=pd.getString("title")%>
		</a>			  </td>
              <td align="left" bgcolor="#FFFFFF"><a target=_blank href="../myblog.jsp?blogId=<%=ucd.getId()%>"><%=StrUtil.toHtml(ucd.getTitle())%></a></td>
              <td bgcolor="#FFFFFF"><%=DateUtil.format(pd.getDate("add_date"), "yy-MM-dd HH:mm:ss")%></td>
              <td height="22" bgcolor="#FFFFFF">
			  &nbsp;&nbsp;<a target=_blank href="<%=pd.getVideoUrl(request)%>">打开</a><a href="listvideo.jsp?op=del&id=<%=pd.getLong("id")%>&CPages=<%=curpage%>">
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
    out.print(paginator.getPageBlock(request, "listvideo.jsp?"+querystr));
%>
            </div></td>
          </tr>
    </table>
	 <table width="98%" border=0 align="center" cellpadding=0 cellspacing=0 id="uploadTable">
        <form name=formSubDir target="leftFileFrame" action="video_left.jsp?op=AddChild" method="post">
          <tr>
            <td align="right" valign=top class=tablebody1><input name="name" size="10">
                <input name="submit2" type=submit value="添子目录">
                <input name="parent_code" type="hidden" value="<%=dir_code%>">
                <input name="code" type="hidden" value="<%=cn.js.fan.util.RandomSecquenceCreator.getId(20)%>">
                <input name="type" type="hidden" value="1">
                <a href="blog_music_dir_modify.jsp?code=<%=StrUtil.UrlEncode(dir_code)%>">修改目录</a>&nbsp;
                <%if (!dir_code.equals("root")) {%>
                <a href="javascript:if (confirm('您确定要删除吗？')) window.location.href='video_list.jsp?op=delDir&dirCode=<%=StrUtil.UrlEncode(dir_code)%>'">删除目录</a>
                <%}%>
			</td>
          </tr>
        </form>
    </table>
	</td>
  </tr>
</table>
<br>
</BODY></HTML>
