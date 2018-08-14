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
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
long blogId = ParamUtil.getLong(request, "blogId", UserConfigDb.NO_BLOG);

String blogUserDir = ParamUtil.get(request, "blogUserDir");
String skinPath = "skin/default";

String op = ParamUtil.get(request, "op");
if (op.equals("setLocked")) {
	boolean re = false;
	long id = ParamUtil.getLong(request, "id");
	int value = ParamUtil.getInt(request, "value");
	MsgMgr mm = new MsgMgr();
	try {
		re = mm.setLocked(request, id, value);
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}

	if (re) {
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"info_operate_success"), "listtopic.jsp?blogId=" + blogId + "&blogUserDir=" + blogUserDir));
		return;
	}
	else {
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request,"info_operate_fail")));
		return;
	}
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE><%=Global.AppName%></TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<%@ include file="../../inc/nocache.jsp"%>
<LINK href="../../common.css" type=text/css rel=stylesheet>
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
<SCRIPT>
function openWin(url,width,height) {
  var newwin = window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,top=50,left=120,width="+width+",height="+height);
}

////////////////////展开帖子
function loadThreadFollow(b_id,t_id,getstr){
	var targetImg2 =eval("document.all.followImg" + t_id);
	var targetTR2 =eval("document.all.follow" + t_id);
	if (targetImg2.src.indexOf("nofollow")!=-1){return false;}
	if ("object"==typeof(targetImg2)){
		if (targetTR2.style.display!="")
		{
			targetTR2.style.display="";
			targetImg2.src="../../forum/images/minus.gif";
			if (targetImg2.loaded=="no"){
				document.frames["hiddenframe"].location.replace("listtree.jsp?id="+b_id+getstr);
			}
		}else{
			targetTR2.style.display="none";
			targetImg2.src="../../forum/images/plus.gif";
		}
	}
}
</SCRIPT>
<META content="MSHTML 6.00.2600.0" name=GENERATOR></HEAD>
<BODY leftmargin="0" topMargin=0>
<iframe src="" id="hiddenframe" width="0" height="0"></iframe>
<jsp:useBean id="Topic" scope="page" class="com.redmoon.forum.MsgMgr" />
<jsp:useBean id="userservice" scope="page" class="com.redmoon.forum.person.userservice" />
<%
String querystring = StrUtil.getNullString(request.getQueryString());
String privurl=request.getRequestURL()+"?"+StrUtil.UrlEncode(querystring,"utf-8");
// 检查用户权限
if (!com.redmoon.blog.Privilege.canUserDo(request, blogId, com.redmoon.blog.Privilege.PRIV_ALL)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<table width="100%" border="0">
  <tr>
    <td>
	&nbsp;<a href="listtopic.jsp?blogId=<%=blogId%>"><lt:Label res="res.label.blog.user.listtopic" key="all_article"/></a>
	<%
	UserDirDb udd = new UserDirDb();
	if (!blogUserDir.equals("")) {%>
		 >> 
		<%if (!blogUserDir.equals(UserDirDb.DEFAULT)) {
			udd = udd.getUserDirDb(blogId, blogUserDir);
			out.print(udd.getDirName());
		}
		else
			out.print(udd.getDefaultName());
	}
	%>
	</td>
  </tr>
      <tr>
        <td height="1" align="center" background="../../images/comm_dot.gif"></td>
      </tr>
</table>
<%		
		String sql = SQLBuilder.getListtopicSqlOfBlog(blogId, blogUserDir);

		MsgDb msgdb = new MsgDb();
	    int total = msgdb.getThreadsCount(sql, msgdb.getVirtualBoardcodeOfBlog(blogId, blogUserDir));

		int pagesize = 20;
		
		Paginator paginator = new Paginator(request, total, pagesize);
		int curpage = paginator.getCurPage();

		int totalpages = paginator.getTotalPages();
		if (totalpages==0) {
			curpage = 1;
			totalpages = 1;
		}
		
		long start = (curpage-1)*pagesize;
		long end = curpage*pagesize;
		
        ThreadBlockIterator irmsg = msgdb.getThreads(sql, msgdb.getVirtualBoardcodeOfBlog(blogId, blogUserDir), start, end);
%>
  <table width="98%" border="0" class="p9">
    <tr> 
      <td width="44%" align="left"> 
	  </td>
      <td width="56%" align="right"><%=paginator.getPageStatics(request)%></td>
    </tr>
  </table>
  <TABLE borderColor=#edeced cellSpacing=0 cellPadding=1 width="98%" align=center 
border=1>
    <TBODY>
      <TR height=25> 
        <TD height="26" colSpan=3 align=middle noWrap bgcolor="#ECE9D8"><lt:Label res="res.label.blog.user.listtopic" key="topis_list"/></TD>
        <TD width=55 align=middle noWrap bgcolor="#EFEBDE"><lt:Label res="res.label.blog.user.listtopic" key="list"/></TD>
        <TD width=55 height="26" align=middle noWrap bgcolor="#EFEBDE"><lt:Label res="res.label.forum.listtopic" key="reply"/></TD>
        <TD width=55 height="26" align=middle noWrap bgcolor="#EFEBDE"><lt:Label res="res.label.forum.listtopic" key="hit"/></TD>
        <TD width=80 height="26" align=middle noWrap bgcolor="#EFEBDE"><lt:Label res="res.label.forum.listtopic" key="reply_date"/></TD>
        <TD width=80 align=middle noWrap bgcolor="#EFEBDE" style="padding-left:5px"><lt:Label key="op"/></TD>
      </TR>
    </TBODY>
</TABLE>
<%		
String id="",topic = "",name="",lydate="",rename="",redate="";
int level=0,iselite=0,islocked=0,expression=0;
int i = 0,recount=0,hit=0,type=0;
ForumDb forum = new ForumDb();
UserMgr um = new UserMgr();
%>
<%
while (irmsg.hasNext()) {
	 	  msgdb = (MsgDb) irmsg.next(); 
		  i++;
		  id = ""+msgdb.getId();
		  topic = msgdb.getTitle();
		  name = msgdb.getName();
		  lydate = com.redmoon.forum.ForumSkin.formatDateTime(request, msgdb.getAddDate());
		  recount = msgdb.getRecount();
		  hit = msgdb.getHit();
		  expression = msgdb.getExpression();
		  type = msgdb.getType();
		  iselite = msgdb.getIsElite();
		  islocked = msgdb.getIsLocked();
		  level = msgdb.getLevel();
		  rename = msgdb.getRename();
		  redate = com.redmoon.forum.ForumSkin.formatDateTime(request, msgdb.getRedate());
		  if (redate!=null && redate.length()>=19)
		  	redate = redate.substring(5,16);
	  %>
<table bordercolor=#edeced cellspacing=0 cellpadding=1 width="98%" align=center border=1>
    <tbody>
      <tr> 
        <td noWrap align=middle width=30 bgcolor=#f8f8f8> <% if (level==MsgDb.LEVEL_TOP_BOARD) { %> <IMG alt="" src="../../forum/<%=skinPath%>/images/f_top.gif" border=0> 
          <% } 
		else {
				if (recount>20){ %> <img alt="<lt:Label res="res.label.forum.listtopic" key="open_topic_hot"/>" src="../../forum/<%=skinPath%>/images/f_hot.gif"> <%}
	  			else if (recount>0) {%> <img alt="<lt:Label res="res.label.forum.listtopic" key="open_topic_reply"/>" src="../../forum/<%=skinPath%>/images/f_new.gif"> <%}
	  			else {%> <img alt="<lt:Label res="res.label.forum.listtopic" key="open_topic_no_reply"/>" src="../../forum/<%=skinPath%>/images/f_norm.gif"> <%}
	 	}%>		</td>
        <td width=17 align=middle valign="middle" bgcolor=#ffffff><a href="../showblog.jsp?rootid=<%=id%>" target=_blank> 
          <% 
		  if (islocked==1) { %>
          <IMG height=15 alt="" src="../../forum/<%=skinPath%>/images/f_locked.gif" width=17 border=0> 
          <% }
		  else {
			  if (type==1) { %>
          <IMG height=15 alt="" src="../../forum/<%=skinPath%>/images/f_poll.gif" width=17 border=0> 
          <%}else {
			  if (expression!=MsgDb.EXPRESSION_NONE) {
		  %>
          <img src="../../forum/images/brow/<%=expression%>.gif" border=0> 
          <%	}
		  		else
					out.print("&nbsp;");
		  	}
		  } %>
        </a></td>
        <td onMouseOver="this.style.backgroundColor='#ffffff'" 
    onMouseOut="this.style.backgroundColor=''" align=left bgcolor=#f8f8f8> <%
		if (recount==0) {
		%> <img id=followImg<%=id%> title="<lt:Label res="res.label.forum.listtopic" key="no_reply"/>" src="../../forum/images/minus.gif" loaded="no"> 
          <% }else { %> <img id=followImg<%=id%> title="<lt:Label res="res.label.forum.listtopic" key="extend_reply"/>" style="CURSOR: hand" 
      onClick="loadThreadFollow(<%=id%>,<%=id%>,'&hit=<%=hit+1%>')" src="../../forum/images/plus.gif" loaded="no"> 
          <% } %>
		<a href="../showblog.jsp?rootid=<%=id%>" target=_blank> 
		<%
		String color = StrUtil.getNullString(msgdb.getColor());
		String tp = com.redmoon.forum.plugin.DefaultRender.RenderFullTitle(request, msgdb);
		if (!color.equals(""))
			tp = "<font color='" + color + "'>" + tp + "</font>";
		if (msgdb.isBold())
			tp = "<B>" + tp + "</B>";
		%>
		<%=tp%>		</a>
			<%if (iselite==1) { %>
				<IMG src="../../forum/images/topicgood.gif">
			<%}%>
		  <%
		//计算共有多少页回贴
		int allpages = Math.round((float)recount/10+0.5f);
		if (allpages>1)
		{
		 	out.print("[");
			for (int m=1; m<=allpages; m++)
			{ %> <a href="../showblog.jsp?rootid=<%=id%>&CPages=<%=m%>" target=_blank><%=m%></a> <% }
		  	out.print("]");
		 }%> </td>
        <td align=middle width=55 bgcolor=#f8f8f8>
		<%
		if (msgdb.getBlogUserDir().equals(UserDirDb.DEFAULT)) {%>
			<a href="?blogId=<%=blogId%>&blogUserDir=<%=UserDirDb.DEFAULT%>"><%=UserDirDb.getDefaultName()%></a>
		<%}
		else {
			if (blogUserDir.equals("")) {
				udd = udd.getUserDirDb(blogId, msgdb.getBlogUserDir());%>
			<a href="?blogId=<%=blogId%>&blogUserDir=<%=udd.getCode()%>"><%=udd.getDirName()%></a>
			<%}
			else {%>
			<a href="?blogId=<%=blogId%>&blogUserDir=<%=udd.getCode()%>"><%=udd.getDirName()%></a>
			<%}
		}
		%>
		</td>
        <td align=middle width=55 bgcolor=#f8f8f8><font color=red>[<%=recount%>]</font></td>
        <td align=middle width=55 bgcolor=#ffffff><%=hit%></td>
        <td align=left width=80 bgcolor=#f8f8f8> <table cellspacing=0 cellpadding=2 width="100%" align=center border=0>
            <tbody>
              <tr> 
                <td align="center"> 
                  <%if (rename.equals("")) {%>
				  <%=lydate%>
				  <%}else{%>
				<a href="../../userinfo.jsp?username=<%=StrUtil.UrlEncode(rename,"utf-8")%>" target="_blank" title="<lt:Label res="res.label.forum.listtopic" key="topic_date"/><%=lydate%>"><%=um.getUser(rename).getNick()%></a><br>
				<%=redate%>
				<%}%>
				</td>
              </tr>
            </tbody>
          </table></td>
        <td align=left width=80 bgcolor=#f8f8f8 style="padding-left:5px">
		<%if (msgdb.getIsWebedit()==msgdb.WEBEDIT_REDMOON) {%>
		<a href="../../forum/edittopic_we.jsp?editFlag=blog&boardcode=<%=com.redmoon.forum.Leaf.CODE_BLOG%>&editid=<%=msgdb.getId()%>&privurl=<%=StrUtil.getUrl(request)%>"><lt:Label key="op_edit"/></a>
		<%} else if (msgdb.getIsWebedit()==msgdb.WEBEDIT_UBB) {%>
		<a href="../../forum/edittopic.jsp?editFlag=blog&boardcode=<%=com.redmoon.forum.Leaf.CODE_BLOG%>&editid=<%=msgdb.getId()%>&privurl=<%=StrUtil.getUrl(request)%>"><lt:Label key="op_edit"/></a>
		<%} else {%>
		<a href="../../forum/edittopic_new.jsp?editFlag=blog&boardcode=<%=com.redmoon.forum.Leaf.CODE_BLOG%>&editid=<%=msgdb.getId()%>&privurl=<%=StrUtil.getUrl(request)%>"><lt:Label key="op_edit"/></a>
		<%}%>
		<a href="javascript:if (confirm('<lt:Label key="confirm_del"/>')) window.location.href='../../forum/deltopic.jsp?delid=<%=msgdb.getId()%>'"><lt:Label key="op_del"/></a><BR>
		<%if (msgdb.getIsLocked()==0) {%>
	  		<a href="listtopic.jsp?blogId=<%=blogId%>&blogUserDir=<%=blogUserDir%>&op=setLocked&id=<%=msgdb.getId()%>&value=1"><lt:Label res="res.label.forum.showtopic" key="lock"/></a>
		<%}else{%>
	  		<a href="listtopic.jsp?blogId=<%=blogId%>&blogUserDir=<%=blogUserDir%>&op=setLocked&id=<%=msgdb.getId()%>&value=0"><lt:Label res="res.label.forum.showtopic" key="unlock"/></a>
		<%}%>
		</td>
      </tr>
      <tr id=follow<%=id%> style="DISPLAY: none"> 
        <td noWrap align=middle width=30 bgcolor=#f8f8f8>&nbsp;</td>
        <td align=middle width=17 bgcolor=#ffffff>&nbsp;</td>
        <td onMouseOver="this.style.backgroundColor='#ffffff'" 
    onMouseOut="this.style.backgroundColor=''" align=left bgcolor=#f8f8f8 colspan="6"> 
          <div id=followDIV<%=id%> 
      style="WIDTH: 100%;BACKGROUND-COLOR: lightyellow" 
      onClick=loadThreadFollow(<%=id%>,<%=id%>,"&hit=<%=hit+1%>")><lt:Label res="res.label.forum.listtopic" key="wait"/></div></td>
      </tr>
      <tr> 
        <td 
    style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; PADDING-TOP: 0px" 
    colspan=5> </td>
      </tr>
    </tbody>
</table>
<%}%>
  <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
    <tr> 
      <td height="23" align="right"> 
         
          <%
				String querystr = "op=" + op + "&blogId=" + blogId + "&blogUserDir=" + blogUserDir;
				out.print(paginator.getCurPageBlock("listtopic.jsp?"+querystr));
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
