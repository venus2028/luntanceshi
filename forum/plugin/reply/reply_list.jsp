<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="org.jdom.*"%>
<%@ page import="org.jdom.output.*"%>
<%@ page import="org.jdom.input.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.redmoon.forum.OnlineInfo"%>
<%@ page import="com.redmoon.forum.plugin.reply.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.Global"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String skincode = UserSet.getSkin(request);
if (skincode.equals(""))
	skincode = UserSet.defaultSkin;
SkinMgr skm = new SkinMgr();
Skin skin = skm.getSkin(skincode);
if (skin==null)
	skin = skm.getSkin(UserSet.defaultSkin);
String skinPath = skin.getPath();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<title>待答复贴子</title>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<link href="../../admin/default.css" rel="stylesheet" type="text/css">
<STYLE>
TABLE {
	BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 1px
}
TD {
	BORDER-RIGHT: 0px; BORDER-TOP: 0px
}
body {
	margin-top: 0px;
}
</STYLE>
<SCRIPT>
function form1_onsubmit() {
	if (form1.selboard.value=="")
	{
		alert("<lt:Label res="res.label.forum.search" key="alert_board"/>");
		return false;
	}
}
</SCRIPT>
<script src="../../../../inc/common.js"></script>
</HEAD>
<BODY>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<jsp:useBean id="Topic" scope="page" class="com.redmoon.forum.MsgMgr" />
<%
if (!privilege.isMasterLogin(request)) {
	out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, SkinUtil.PVG_INVALID)));
	return;
}

String op = ParamUtil.get(request, "op");

MsgMgr mm = new MsgMgr();

String boardcode = ParamUtil.get(request, "boardcode");
String boardname = ParamUtil.get(request, "boardname");
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">待答复贴子</td>
  </tr>
</table>
<CENTER>
  <br>
  <%
		String myboardname = "", myboardcode = "";

		String sql = "select id from sq_message m, plugin_reply r where r.msg_id=m.id and r.manager=" + StrUtil.sqlstr(privilege.getUser(request)) + " and r.is_replied=0";
		sql += " ORDER BY msg_level desc,lydate desc";
		
		// out.print(sql);

		int pagesize = 10;
		Paginator paginator = new Paginator(request);
		int curpage = paginator.getCurPage();
		PageConn pageconn = new PageConn(Global.defaultDB, curpage, pagesize);
		ResultIterator ri = pageconn.getResultIterator(sql);
		paginator.init(pageconn.getTotal(), pagesize);
		
		ResultRecord rr = null;
		
		//设置当前页数和总页数
		int totalpages = paginator.getTotalPages();
		if (totalpages==0)
		{
			curpage = 1;
			totalpages = 1;
		}
%>
  <TABLE borderColor=#edeced cellSpacing=0 cellPadding=1 width="98%" align=center 
border=1>
  <TBODY>
  <TR height=25 class="td_title">
    <TD height="26" colSpan=4 align=middle noWrap class="thead">主题</TD>
    <TD width=80 height="26" align=middle noWrap class="thead"><lt:Label res="res.label.forum.listtopic" key="author"/></TD>
    <TD width=39 height="26" align=middle noWrap class="thead"><lt:Label res="res.label.forum.listtopic" key="reply"/></TD>
    <TD width=39 height="26" align=middle noWrap class="thead"><lt:Label res="res.label.forum.listtopic" key="hit"/></TD>
    <TD width=70 height="26" align=middle noWrap class="thead"><lt:Label res="res.label.forum.listtopic" key="reply_date"/></TD>
    <TD width=105 height="26" align=middle noWrap class="thead"><lt:Label res="res.label.forum.mytopic" key="board"/></TD>
    <TD width=70 align=middle noWrap class="thead">答复者</TD>
    <TD width=36 align=middle noWrap class="thead">答复</TD>
    <TD width=76 align=middle noWrap class="thead">操作</TD>
  </TR>
  </TBODY>
<%
String topic = "",name="",lydate="";
int expression;
int id = -1;
int i = 0,recount=0,hit=0,type=0;
MsgDb md = new MsgDb();
Leaf myleaf = new Leaf();
Directory dir = new Directory();
com.redmoon.forum.person.UserMgr um = new com.redmoon.forum.person.UserMgr();
ReplyDb rd = new ReplyDb();
while (ri.hasNext()) {
	 	  rr = (ResultRecord)ri.next(); 
		  i++;
		  id = rr.getInt("id");
		  md = md.getMsgDb(id);
		  topic = md.getTitle();
		  name = md.getName();
		  lydate = com.redmoon.forum.ForumSkin.formatDate(request, md.getAddDate());
		  recount = md.getRecount();
		  hit = md.getHit();
		  expression = md.getExpression();
		  type = md.getType();
		  myboardcode = md.getboardcode();
		  myleaf = dir.getLeaf(myboardcode);
		  myboardname = "";
		  if (myleaf!=null)
			  myboardname = myleaf.getName();
	  %>
    <tbody> 
    <tr>
      <td width=36 height="22" align=left noWrap bgcolor=#f8f8f8><%=md.getId()%></td> 
        <td noWrap align=middle width=38 bgcolor=#f8f8f8> 
      <%if (recount>20){ %>
          <img alt="<lt:Label res="res.label.forum.listtopic" key="open_topic_hot"/>" src="<%=request.getContextPath()%>/forum/<%=skinPath%>/images/f_hot.gif"> 
          <%}
	  else if (recount>0) {%>
          <img alt="<lt:Label res="res.label.forum.listtopic" key="open_topic_reply"/>" src="<%=request.getContextPath()%>/forum/<%=skinPath%>/images/f_new.gif"> 
          <%}
	  else {%>
          <img alt="<lt:Label res="res.label.forum.listtopic" key="open_topic_no_reply"/>" src="<%=request.getContextPath()%>/forum/<%=skinPath%>/images/f_norm.gif"> 
          <%}%>	    </td>
        <td align=middle width=35 bgcolor=#ffffff> 
          <% String urlboardname = StrUtil.UrlEncode(myboardname,"utf-8"); %>
		   <a href="../../showtopic_tree.jsp?boardcode=<%=myboardcode%>&hit=<%=(hit+1)%>&rootid=<%=id%>" target=_blank> 
          <% if (type==1) { %>
          	<IMG height=15 alt="" src="<%=request.getContextPath()%>/forum/images/f_poll.gif" width=17 border=0>
		  <%}else {
				if (expression!=MsgDb.EXPRESSION_NONE) {		  
		  %>
		  			<img src="<%=request.getContextPath()%>/forum/images/brow/<%=expression%>.gif" border=0>
		  <%	}
		  		else
					out.print("&nbsp;");
		  }
		  %>
		  </a></td>
        <td width="258" align=left bgcolor=#f8f8f8 onMouseOver="this.style.backgroundColor='#ffffff'" onMouseOut="this.style.backgroundColor=''"> 
        <%
		if (recount==0) {
		%>
          <img id=followImg<%=id%> title="<lt:Label res="res.label.forum.listtopic" key="no_reply"/>" src="<%=request.getContextPath()%>/forum/<%=skinPath%>/images/minus.gif" loaded="no"> 
          <% }else { %>
          <img id=followImg<%=id%> title=<lt:Label res="res.label.forum.listtopic" key="extend_reply"/> style="CURSOR: hand" src="<%=request.getContextPath()%>/forum/<%=skinPath%>/images/plus.gif" loaded="no"> 
          <% } %>
          <a target="_blank" title="<%=StrUtil.toHtml(md.getContent())%>" href="../../showtopic_tree.jsp?boardcode=<%=myboardcode%>&hit=<%=(hit+1)%>&showid=<%=id%>&rootid=<%=md.getRootid()%>"><%=StrUtil.toHtml(topic)%></a>
          <%
		// 计算共有多少页回贴
		int allpages = (int)Math.ceil((double)recount/pagesize);
		if (allpages>1)
		{
		 	out.print("[");
			for (int m=1; m<=allpages; m++)
			{ %>
          <a target="_blank" title="<%=StrUtil.toHtml(md.getContent())%>" href="showtopic.jsp?boardcode=<%=myboardcode%>&hit=<%=(hit+1)%>&boardname=<%=urlboardname%>&rootid=<%=id%>&CPages=<%=m%>"><%=m%></a> 
        <% }
		  	out.print("]");
		 }%></td>
      <td align=middle bgcolor=#ffffff> 
	  	  <% if (privilege.getUser(request).equals(name)) { %>
          <IMG height=14 src="<%=request.getContextPath()%>/forum/<%=skinPath%>/images/my.gif" width=14>
	  <% } %>
	  <%if (name.equals("")) {%>
        <lt:Label res="res.label.forum.showtopic" key="anonym"/>
      <%}else{%>
	  	<a href="../userinfo.jsp?username=<%=name%>"><%=um.getUser(name).getNick()%></a>
	  <%}%>	  </td>
        <td align=middle bgcolor=#f8f8f8><font color=red>[<%=recount%>]</font></td>
        <td align=middle bgcolor=#ffffff><%=hit%></td>
      <td align=left bgcolor=#f8f8f8> 
        <table cellspacing=0 cellpadding=2 width="100%" align=center border=0>
          <tbody> 
          <tr> 
            <td width="10%">&nbsp;</td>
            <td><%=lydate%></td>
          </tr>
          </tbody> 
        </table>      </td>
      <td align=middle bgcolor=#ffffff>&nbsp;&nbsp;
        <%if (!myboardcode.equals(Leaf.CODE_BLOG)) {%>
        <a target=_blank href="../../../listtopic.jsp?boardcode=<%=StrUtil.UrlEncode(myboardcode)%>"><%=myboardname%></a>&nbsp;
        <%}else{%>
        <a target=_blank href="../../../../blog/myblog.jsp?userName=<%=StrUtil.UrlEncode(md.getName())%>"><%=myboardname%></a>
        <%}%>	  </td>
      <td align=middle bgcolor=#ffffff>
	  <%
	  ReplyDb rb = (ReplyDb)rd.getQObjectDb(new Long(id));
	  if (!StrUtil.getNullStr(rb.getString("manager")).equals("")) {
	  	UserDb user = um.getUser(rb.getString("manager"));
	  %>
	  <a href="../../../../userinfo.jsp?username=<%=StrUtil.UrlEncode(user.getName())%>" target="_blank"><%=user.getNick()%></a>
	  <%}
	  %>	  </td>
      <td align=middle bgcolor=#ffffff><%=rb.getInt("is_replied")==1?"是":"否"%></td>
      <td align=middle bgcolor=#ffffff><a href="../../showtopic_tree.jsp?boardcode=<%=myboardcode%>&showid=<%=id%>&rootid=<%=md.getRootid()%>">查看</a></td>
    </tr>
    <tr> 
      <td 
    style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; PADDING-TOP: 0px" 
    colspan=6>      </td>
    </tr>
    </tbody> 
<%}%>
  </table>
<table width="98%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
    <tr> 
      <td height="23" align="right"><%
	  String querystr = "";
 	  out.print(paginator.getCurPageBlock(request, querystr));
	  %></td>
    </tr>
</table>     
<iframe width=0 height=0 src="" id="hiddenframe"></iframe>
</CENTER>
</BODY>
</HTML>
