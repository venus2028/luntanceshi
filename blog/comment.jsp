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
<HTML><HEAD><TITLE><lt:Label res="res.label.blog.comment" key="title"/></TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<%@ include file="../inc/nocache.jsp"%>
<link href="../cms/default.css" rel="stylesheet" type="text/css">
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
				
		String privurl = StrUtil.getUrl(request);
		
		String strcurpage = StrUtil.getNullString(request.getParameter("CPages"));
		if (strcurpage.equals(""))
			strcurpage = "1";
		if (!StrUtil.isNumeric(strcurpage)) {
			out.print(StrUtil.makeErrMsg(SkinUtil.LoadString(request, "err_id")));
			return;
		}
		
		String sql = SQLBuilder.getListcommentSqlOfBlog(blogId);

		MsgDb msgdb = new MsgDb();
	    int total = 0;
		int pagesize = 20;
		int curpage = Integer.parseInt(strcurpage);
		
		ListResult lr = msgdb.list(sql, curpage, pagesize);
		total = lr.getTotal();
		
		Paginator paginator = new Paginator(request, total, pagesize);
		// 设置当前页数和总页数
		int totalpages = paginator.getTotalPages();
		if (totalpages==0) {
			curpage = 1;
			totalpages = 1;
		}
		
        Iterator irmsg = lr.getResult().iterator();
%>
  <table width="98%" border="0" class="p9">
    <tr> 
      <td width="44%" align="left"> 
	  </td>
      <td width="56%" align="right"><%=paginator.getPageStatics(request)%></td>
    </tr>
  </table>
  <%		
String id="",topic = "",name="",lydate="",rename="",redate="";
int level=0,iselite=0,islocked=0,expression=0;
int i = 0,recount=0,hit=0,type=0;
ForumDb forum = new ForumDb();
UserMgr um = new UserMgr();

while (irmsg.hasNext()) {
	 	  msgdb = (MsgDb) irmsg.next(); 
		  i++;
		  id = ""+msgdb.getId();
		  topic = msgdb.getTitle();
		  name = msgdb.getName();
		  lydate = com.redmoon.forum.ForumSkin.formatDateTime(request, msgdb.getAddDate());
	  %>
<table bordercolor=#edeced cellspacing=0 cellpadding=5 width="98%" align=center border=0>
    <tbody>
      <tr>
        <td height="24" align=left bgcolor=#f8f8f8 onMouseOver="this.style.backgroundColor='#ffffff'" 
    onMouseOut="this.style.backgroundColor=''">
	<%if (!name.equals("")) {%>
	<a target=_blank href="../userinfo.jsp?username=<%=StrUtil.UrlEncode(msgdb.getName())%>"><%=um.getUser(msgdb.getName()).getNick()%>&nbsp;&nbsp;</a>
	<%}else{%>
	<lt:Label res="res.label.forum.showtopic" key="anonym"/>
	<%}%>
          <%if (rename.equals("")) {%>
          <%=lydate%>
          <%}else{
			String str = SkinUtil.LoadString(request,"res.label.blog.comment", "date");
			str = StrUtil.format(str, new Object[] {lydate});
		  %>
          <a href="userinfo.jsp?username=<%=StrUtil.UrlEncode(rename,"utf-8")%>" title="<%=str%>"><%=rename%></a>
          <%=redate%>
          <%}%>
&nbsp;&nbsp;[<a href="#" onClick="if (confirm('<lt:Label key="confirm_del"/>')) window.location.href='../forum/deltopic.jsp?delid=<%=msgdb.getId()%>&privurl=<%=privurl%>'"><lt:Label key="op_del"/></a>]&nbsp;&nbsp;&nbsp;
<lt:Label res="res.label.blog.comment" key="article"/>
<%
long rootid = msgdb.getRootid();
MsgDb rootMsgDb = msgdb.getMsgDb(rootid);
%>
<a href="showblog.jsp?rootid=<%=rootid%>" target="_blank"><%=StrUtil.toHtml(rootMsgDb.getTitle())%></a>
</td>
      </tr>
      <tr> 
        <td align=left bgcolor=#f8f8f8 onMouseOver="this.style.backgroundColor='#ffffff'" 
    onMouseOut="this.style.backgroundColor=''">
	<%
	DefaultRender render = new DefaultRender();
	out.print(render.RenderContent(request, msgdb));
	%>	</td>
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
				out.print(paginator.getPageBlock(request,"comment.jsp?"+querystr));
				%>
      &nbsp;&nbsp;</td>
    </tr>
</table> 
  <TABLE cellSpacing=0 cellPadding=0 width="98%" border=0>
  <TBODY>
  <TR>
    <TD width="70%">&nbsp;</TD>
    <TD width="40%">&nbsp;</TD></TR></TBODY></TABLE></CENTER>
</BODY></HTML>
