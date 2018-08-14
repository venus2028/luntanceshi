<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.plugin.DefaultRender"%>
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
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
long blogId = ParamUtil.getLong(request, "blogId");
String blogUserDir = ParamUtil.get(request, "blogUserDir");
String skinPath = "skin/default";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML><HEAD><TITLE>歌曲评论</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<%@ include file="../../inc/nocache.jsp"%>
<link href="../../cms/default.css" rel="stylesheet" type="text/css">
<STYLE>
TABLE {
	BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 1px
}
TD {
	BORDER-RIGHT: 0px; BORDER-TOP: 0px
}
.style1 {color: #FFFFFF}
.style3 {color: #FFFFFF; font-weight: bold; }
</STYLE>
<META content="MSHTML 6.00.2600.0" name=GENERATOR></HEAD>
<BODY leftmargin="0" topMargin=0>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head"><lt:Label res="res.label.blog.user.frame" key="all_comment"/></td>
  </tr>
</table>
<iframe width=0 height=0 src="" id="hiddenframe"></iframe>
<jsp:useBean id="Topic" scope="page" class="com.redmoon.forum.MsgMgr" />
<jsp:useBean id="userservice" scope="page" class="com.redmoon.forum.person.userservice" />
<%
		if (!com.redmoon.blog.Privilege.canUserDo(request, blogId, "enter")) {
			out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
			return;
		}

String op = ParamUtil.get(request, "op");				
if (op.equals("del")) {
	boolean canDel = false;
	com.redmoon.blog.Privilege blogPvg = new com.redmoon.blog.Privilege();
	try {
		if (blogPvg.canUserDo(request, blogId,
								com.redmoon.blog.Privilege.PRIV_ALL)) {
			canDel = true;
		}
	} catch (ErrMsgException e) {
		out.print(SkinUtil.makeErrMsg(request, e.getMessage()));
		return;
	}
	if (!canDel) {
		out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, "pvg_invalid")));
		return;
	}
	
	long delId = ParamUtil.getLong(request, "delId");
	MusicCommentDb pcd = new MusicCommentDb();
	pcd = (MusicCommentDb)pcd.getQObjectDb(new Long(delId));
	if (pcd.del()) {
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "music_comment.jsp?blogId=" + blogId));
	}
	else {
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
	}
	return;
}		
		String strcurpage = StrUtil.getNullString(request.getParameter("CPages"));
		if (strcurpage.equals(""))
			strcurpage = "1";
		if (!StrUtil.isNumeric(strcurpage)) {
			out.print(StrUtil.makeErrMsg(SkinUtil.LoadString(request, "err_id")));
			return;
		}
		
		MusicCommentDb mcd = new MusicCommentDb();
		String sql = "select id from " + mcd.getTable().getName() + " where blog_id=" + blogId + " order by add_date desc";

	    int total = 0;
		int pagesize = 20;
		int curpage = Integer.parseInt(strcurpage);
		
		ListResult lr = mcd.listResult(sql, curpage, pagesize);
		total = lr.getTotal();
		
		Paginator paginator = new Paginator(request, total, pagesize);
		// 设置当前页数和总页数
		int totalpages = paginator.getTotalPages();
		if (totalpages==0) {
			curpage = 1;
			totalpages = 1;
		}
		
        Iterator ir = lr.getResult().iterator();
%>
  <table width="98%" border="0" class="p9">
    <tr> 
      <td width="44%" align="left"> 
	  </td>
      <td width="56%" align="right"><%=paginator.getPageStatics(request)%></td>
    </tr>
  </table>
  <%	
UserMgr um = new UserMgr();
MusicDb md2 = new MusicDb();
while (ir.hasNext()) {
	mcd = (MusicCommentDb) ir.next(); 
	String userName = mcd.getString("user_name");
%>
<table bordercolor=#edeced cellspacing=0 cellpadding=5 width="98%" align=center border=0>
    <tbody>
      <tr>
        <td height="24" align=left bgcolor=#f8f8f8 onMouseOver="this.style.backgroundColor='#ffffff'" 
    onMouseOut="this.style.backgroundColor=''">
	<%if (!userName.equals("")) {%>
	<a target=_blank href="../../userinfo.jsp?username=<%=StrUtil.UrlEncode(userName)%>"><%=um.getUser(userName).getNick()%>&nbsp;&nbsp;</a>
	<%}else{%>
	<lt:Label res="res.label.forum.showtopic" key="anonym"/>
	<%}%>
          <%=DateUtil.format(mcd.getDate("add_date"), "yyyy-MM-dd HH:mm:ss")%>
&nbsp;&nbsp;[<a href="#" onClick="if (confirm('<lt:Label key="confirm_del"/>')) window.location.href='music_comment.jsp?op=del&delId=<%=mcd.getLong("id")%>&blogId=<%=blogId%>'"><lt:Label key="op_del"/>
</a>]&nbsp;&nbsp;&nbsp;视频：
<%
long musicId = mcd.getLong("music_id");
MusicDb md = (MusicDb)md2.getQObjectDb(musicId);
%>
<a href="../showmusic.jsp?musicId=<%=musicId%>" target="_blank"><%=StrUtil.toHtml(md.getString("title"))%></a>
</td>
      </tr>
      <tr> 
        <td align=left bgcolor=#f8f8f8 onMouseOver="this.style.backgroundColor='#ffffff'" 
    onMouseOut="this.style.backgroundColor=''">
	<%=mcd.getString("content")%>	</td>
      </tr>
      <tr>
        <td align=left background="../images/comm_dot.gif" height=1></td>
      </tr>
      <tr>
        <td align=left>&nbsp;</td>
      </tr>
    </tbody>
</table>
<%}%>
  <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
    <tr> 
      <td height="23" align="right"> 
          <%
				String querystr = "blogId=" + blogId;
				out.print(paginator.getPageBlock(request,"music_comment.jsp?"+querystr));
				%>
      &nbsp;&nbsp;</td>
    </tr>
</table> 
  </CENTER>
</BODY></HTML>
