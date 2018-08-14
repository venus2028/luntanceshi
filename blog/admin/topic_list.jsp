<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="org.jdom.*"%>
<%@ page import="org.jdom.output.*"%>
<%@ page import="org.jdom.input.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.redmoon.forum.OnlineInfo"%>
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
<title><lt:Label res="res.label.forum.search" key="search_result"/> - <%=Global.AppName%></title>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<link href="../../cms/default.css" rel="stylesheet" type="text/css">
<SCRIPT>
// 展开帖子
function loadThreadFollow(b_id,t_id,getstr){
	var targetImg2 =eval("document.all.followImg" + t_id);
	var targetTR2 =eval("document.all.follow" + t_id);
	if (targetImg2.src.indexOf("nofollow")!=-1){return false;}
	if ("object"==typeof(targetImg2)){
		if (targetTR2.style.display!="") {
			targetTR2.style.display="";
			targetImg2.src="<%=request.getContextPath()%>/forum/images/minus.gif";
			if (targetImg2.loaded=="no"){
				document.frames["hiddenframe"].location.replace("listtree.jsp?id="+b_id+getstr);
			}
		}else{
			targetTR2.style.display="none";
			targetImg2.src="<%=request.getContextPath()%>/forum/images/plus.gif";
		}
	}
}

function form1_onsubmit() {
}
</SCRIPT>
<script src="../../inc/common.js"></script>
<META content="MSHTML 6.00.2600.0" name=GENERATOR></HEAD>
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
String action = ParamUtil.get(request, "action");
String checkStatus = ParamUtil.get(request, "checkStatus");
if (checkStatus.equals(""))
	checkStatus = "" + MsgDb.CHECK_STATUS_PASS;

MsgMgr mm = new MsgMgr();

if (op.equals("check")) {
	String strIds = ParamUtil.get(request, "ids");
	String[] idsary = StrUtil.split(strIds, ",");
	if (idsary!=null) {
		int len = idsary.length;
		for (int i=0; i<len; i++) {
			mm.checkMsg(request, Long.parseLong(idsary[i]), MsgDb.CHECK_STATUS_PASS);
		}
	}
	out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "topic_check.jsp?checkStatus=" + checkStatus));
	return;
}

if (op.equals("del")) {
	String strIds = ParamUtil.get(request, "ids");
	String[] idsary = StrUtil.split(strIds, ",");
	if (idsary!=null) {
		int len = idsary.length;
		for (int i=0; i<len; i++) {
			mm.delTopic(application, request, Long.parseLong(idsary[i]));
		}
	}
	out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "topic_check.jsp?checkStatus=" + checkStatus));
	return;
}

String querystring = StrUtil.getNullString(request.getQueryString());
String privurl = request.getRequestURL()+"?"+StrUtil.UrlEncode(querystring,"utf-8");

String boardcode = ParamUtil.get(request, "boardcode");
String boardname = ParamUtil.get(request, "boardname");
String timelimit = request.getParameter("timelimit");
if (timelimit==null)
	timelimit = "all";

String selboard = ParamUtil.get(request, "selboard");
String searchtype = ParamUtil.get(request, "searchtype");
String searchwhat = ParamUtil.get(request, "searchwhat");
if (selboard.equals(""))
	selboard = "allboard";
String selauthor = ParamUtil.get(request, "selauthor");
String topicScope = ParamUtil.get(request, "scope");
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">博客文章</td>
  </tr>
</table>
<CENTER>
  <br>
  <table width="98%" align="center" cellpadding=0 cellspacing=1 class="frame_gray" id=AutoNumber1 
style="PADDING-RIGHT: 0px; BORDER-TOP: 1px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; BORDER-LEFT: 1px; PADDING-TOP: 0px; BORDER-BOTTOM: 1px; BORDER-COLLAPSE: collapse; BORDER-RIGHT-WIDTH: 1px">
    <form name=form1 action="topic_list.jsp" method=post onSubmit="return form1_onsubmit()">
      <tbody>
        <tr>
          <td height=22 colspan=2 class="thead" ><lt:Label res="res.label.forum.search" key="input_keywards"/>          </td>
        </tr>
        <tr bgcolor=#f5f5f5>
          <td height=24 align="right"><lt:Label res="res.label.forum.search" key="search_content"/>
            &nbsp;</td>
          <td height=24 align="left" valign=top>&nbsp;
              <input size=40 name=searchwhat value="<%=searchwhat%>">
              <input name=boardcode value="<%=boardcode%>" type=hidden>
              <input name=boardname value="<%=boardname%>" type=hidden>
              <input name=action value="<%=action%>" type=hidden></td>
        </tr>
        <tr bgcolor=#f5f5f5>
          <td 
     height=22><p align=right><span style="FONT-SIZE: 9pt">
              <lt:Label res="res.label.forum.search" key="search_keywords"/>
              </span>
                  <input type=radio value=bykey name=searchtype checked>
            &nbsp; </p></td>
          <td height=22 align="left" 
    valign=top 
    >&nbsp;
              <select size=1 name=searchxm2>
                <option value=topic selected>
                <lt:Label res="res.label.forum.search" key="search_topic_keywards"/>
                </option>
              </select>          </td>
        </tr>
        <tr bgcolor=#f5f5f5>
          <td width=210 height=24><p align=right><font style="FONT-SIZE: 9pt">
              <lt:Label res="res.label.forum.search" key="search_author"/>
              </font>
                  <input type=radio value=byauthor name=searchtype <%=searchtype.equals("byauthor")?"checked":""%>>
            &nbsp; </p></td>
          <td height=24 align="left" 
    valign=top 
    >&nbsp;
              <select size=1 name=selauthor>
                <option value=topicname selected>
                <lt:Label res="res.label.forum.search" key="topic_author"/>
                </option>
                <option value=replyname>
                <lt:Label res="res.label.forum.search" key="reply_author"/>
                </option>
              </select>
			  <%if (searchtype.equals("byauthor")) {%>
              <script>
			  form1.selauthor.value = "<%=selauthor%>";
			  </script>
			  <%}%>          </td>
        </tr>
        <tr bgcolor=#f5f5f5>
          <td height=23 align="right">贴子范围&nbsp;</td>
          <td height=23 align="left" valign=top>&nbsp;
            <select size=1 name="scope">
              <option value="" selected>全部</option>
              <option value="topic">主题</option>
              <option value="reply">回复</option>
            </select>
			  <script>
			  form1.scope.value = "<%=topicScope%>";
			  </script>
			</td>
        </tr>
        <tr bgcolor=#f5f5f5>
          <td height=23 align="right">审核通过&nbsp;</td>
          <td height=23 align="left" valign=top>&nbsp;
            <select size=1 name="checkStatus">
            <option value=1 selected>
			是            </option>
            <option value=0>
			否            </option>
          </select>
              <script>
			  form1.checkStatus.value = "<%=checkStatus%>";
			  </script>		  </td>
        </tr>
        <tr bgcolor=#f5f5f5>
          <td height=23 align="right" idth=210>
              <lt:Label res="res.label.forum.search" key="scope_date"/>&nbsp;</td>
          <td height=23 align="left" 
    valign=top 
    >&nbsp;
              <select size=1 name=timelimit>
                <option value="all">
                <lt:Label res="res.label.forum.search" key="all_date"/>
                </option>
                <option value=1>
                <lt:Label res="res.label.forum.search" key="after_yestoday"/>
                </option>
                <option value=5 selected>
                <lt:Label res="res.label.forum.search" key="after_five_today"/>
                </option>
                <option value=10>
                <lt:Label res="res.label.forum.search" key="after_ten_today"/>
                </option>
                <option value=30>
                <lt:Label res="res.label.forum.search" key="after_30_today"/>
                </option>
              </select>
              <script>
			  form1.timelimit.value = "<%=timelimit%>";
			  </script>
              <input name="checkStatus" type="hidden" value="<%=MsgDb.CHECK_STATUS_NOT%>">
              <input type=submit value=<lt:Label res="res.label.forum.search" key="begin_search"/> name=submit1></td>
        </tr>
      </form>
  </table>
  <BR>
  <%
		String sql = "";
		String myboardname = "", myboardcode = "";
		if (searchtype.equals("byauthor"))
		{
			UserDb ud = new UserDb();
			String nicks = ud.getNicksLike(searchwhat);
		
			if ( selauthor.equals("topicname"))
				sql = "select id from sq_message where name in (" + nicks + ") and replyid=-1";
			else if ( selauthor.equals("replyname"))
				sql = "select id from sq_message where id in (select id from sq_message where replyid<>-1 and name in (" + nicks + "))";
			else
				sql = "select id from sq_message where name in (" + nicks + ")";
		}
		else if (searchtype.equals("bykey")) {
			sql = "select id from sq_message where title like " + StrUtil.sqlstr("%"+searchwhat+"%");
		}
		else
			sql = "select id from sq_message";
		String sb="";
		if (searchtype.equals(""))
			sb = " where boardcode=" + StrUtil.sqlstr(Leaf.CODE_BLOG);
		else
			sb += " and boardcode=" + StrUtil.sqlstr(Leaf.CODE_BLOG);
			
		sb += " and check_status=" + checkStatus;
		
		if (topicScope.equals("topic"))
			sb += " and replyid=-1";
		else if (topicScope.equals("reply"))
			sb += " and replyid<>-1";
					
		sql += sb;
		String t1 = "";
		if (!timelimit.equals("all")) {
			// tl = " and TO_DAYS(NOW()) - TO_DAYS(lydate) <=" + timelimit;
			long cur = System.currentTimeMillis();
			long dlt = Integer.parseInt(timelimit)*24*60*60000;
			long afterDay = cur - dlt;
			t1 = " and lydate>" + StrUtil.sqlstr("" + afterDay);
		}
		else
			t1 = "";
		sql += t1;
		String orderby = " ORDER BY lydate desc";
		sql += orderby;
		
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
  <TABLE borderColor=#edeced cellSpacing=1 cellPadding=1 width="98%" align=center border=0>
  <TBODY>
  <TR>
    <TD height="26" colSpan=5 align=middle noWrap class="thead">文章</TD>
    <TD width=91 height="26" align=middle noWrap class="thead"><lt:Label res="res.label.forum.listtopic" key="author"/></TD>
    <TD width=55 height="26" align=middle noWrap class="thead"><lt:Label res="res.label.forum.listtopic" key="reply"/></TD>
    <TD width=55 height="26" align=middle noWrap class="thead"><lt:Label res="res.label.forum.listtopic" key="hit"/></TD>
    <TD width=80 height="26" align=middle noWrap class="thead"><lt:Label res="res.label.forum.listtopic" key="reply_date"/></TD>
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
      <td width=30 height="22" align=middle noWrap bgcolor=#f8f8f8><input name="ids" value="<%=id%>" type="checkbox"></td>
      <td noWrap align=left width=50 bgcolor=#f8f8f8><%=md.getId()%></td> 
        <td noWrap align=middle width=30 bgcolor=#f8f8f8> 
      <%if (recount>20){ %>
          <img alt="<lt:Label res="res.label.forum.listtopic" key="open_topic_hot"/>" src="<%=request.getContextPath()%>/forum/<%=skinPath%>/images/f_hot.gif"> 
          <%}
	  else if (recount>0) {%>
          <img alt="<lt:Label res="res.label.forum.listtopic" key="open_topic_reply"/>" src="<%=request.getContextPath()%>/forum/<%=skinPath%>/images/f_new.gif"> 
          <%}
	  else {%>
          <img alt="<lt:Label res="res.label.forum.listtopic" key="open_topic_no_reply"/>" src="<%=request.getContextPath()%>/forum/<%=skinPath%>/images/f_norm.gif"> 
          <%}%>	    </td>
        <td align=middle width=17 bgcolor=#ffffff> 
          <% String urlboardname = StrUtil.UrlEncode(myboardname,"utf-8"); %>
		   <a href="showtopic_tree.jsp?boardcode=<%=myboardcode%>&hit=<%=(hit+1)%>&rootid=<%=id%>" target=_blank> 
          <% if (type==1) { %>
          	<IMG height=15 alt="" src="../../forum/images/f_poll.gif" width=17 border=0>
		  <%}else {
				if (expression!=MsgDb.EXPRESSION_NONE) {		  
		  %>
		  			<img src="../../forum/images/brow/<%=expression%>.gif" border=0>
		  <%	}
		  		else
					out.print("&nbsp;");
		  }
		  %>
		  </a></td>
        <td onMouseOver="this.style.backgroundColor='#ffffff'" onMouseOut="this.style.backgroundColor=''" align=left bgcolor=#f8f8f8> 
        <%if (md.isRootMsg()) {%>
		<%if (recount==0) {%>
        <img id=followImg<%=id%> title="<lt:Label res="res.label.forum.listtopic" key="no_reply"/>" src="<%=request.getContextPath()%>/forum/<%=skinPath%>/images/minus.gif" loaded="no">
        <%}else{%>
          <img id=followImg<%=id%> title=<lt:Label res="res.label.forum.listtopic" key="extend_reply"/> style="CURSOR: hand" onClick=loadThreadFollow(<%=id%>,<%=id%>,"&boardcode=<%=myboardcode%>&hit=<%=hit+1%>&boardname=<%=urlboardname%>") src="<%=request.getContextPath()%>/forum/<%=skinPath%>/images/plus.gif" loaded="no"> 
        <%}%>
		<%}%>
        <a target="_blank" title="<%=StrUtil.toHtml(md.getContent())%>" href="<%=request.getContextPath()%>/blog/showblog.jsp?rootid=<%=md.getRootid()%>"><%=StrUtil.toHtml(topic)%></a>
        </td>
      <td align=middle width=91 bgcolor=#ffffff> 
	  	  <% if (privilege.getUser(request).equals(name)) { %>
          <IMG height=14 src="<%=request.getContextPath()%>/forum/<%=skinPath%>/images/my.gif" width=14>
	  <% } %>
	  <a href="../../userinfo.jsp?username=<%=StrUtil.UrlEncode(name)%>" target="_blank"><%=um.getUser(name).getNick()%></a>      </td>
        <td align=middle width=55 bgcolor=#f8f8f8><font color=red>[<%=recount%>]</font></td>
        <td align=middle width=55 bgcolor=#ffffff><%=hit%></td>
      <td align=left width=80 bgcolor=#f8f8f8> 
        <table cellspacing=0 cellpadding=2 width="100%" align=center border=0>
          <tbody> 
          <tr> 
            <td width="10%">&nbsp;</td>
            <td><%=lydate%></td>
          </tr>
          </tbody> 
        </table>      </td>
      </tr>
    <tr id=follow<%=id%> style="DISPLAY: none">
      <td noWrap align=middle width=30 bgcolor=#f8f8f8>&nbsp;</td>
      <td noWrap align=middle width=30 bgcolor=#f8f8f8>&nbsp;</td> 
      <td noWrap align=middle width=30 bgcolor=#f8f8f8>&nbsp;</td>
      <td align=middle width=17 bgcolor=#ffffff>&nbsp;</td>
      <td onMouseOver="this.style.backgroundColor='#ffffff'" 
    onMouseOut="this.style.backgroundColor=''" align=left bgcolor=#f8f8f8 colspan="5">
	 <div id=followDIV<%=id%> 
      style="WIDTH: 100%;BACKGROUND-COLOR: lightyellow" 
      onClick=loadThreadFollow(<%=id%>,<%=id%>,"&hit=<%=hit+1%>&boardname=<%=urlboardname%>")><span style="WIDTH: 100%;">
	   <lt:Label res="res.label.forum.listtopic" key="wait"/>
	 </span></div></td>
    </tr>
    <tr> 
      <td 
    style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; PADDING-TOP: 0px" 
    colspan=7>      </td>
    </tr>
    </tbody> 
<%}%>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
    <tr> 
      <td width="51%" height="23" align="left">
	  <input value="<lt:Label res="res.label.forum.topic_m" key="sel_all"/>" type="button" onClick="selAllCheckBox('ids')">&nbsp;&nbsp;
	  <input value="<lt:Label res="res.label.forum.topic_m" key="clear_all"/>" type="button" onClick="clearAllCheckBox('ids')">&nbsp;&nbsp;
	  &nbsp;
	  <input name="button" type="button" onClick="doCheck()" value="<lt:Label res="res.label.forum.topic_m" key="check_pass"/>">
	  &nbsp;
	  <input name="button2" type="button" onClick="doDel()" value="<lt:Label key="op_del"/>"></td>
      <td width="49%" align="right"><%
	  String querystr = "&searchtype="+searchtype+"&searchwhat="+StrUtil.UrlEncode(searchwhat,"utf-8");
	  querystr += "&selboard="+StrUtil.UrlEncode(selboard,"utf-8");
	  querystr += "&selauthor="+StrUtil.UrlEncode(selauthor,"utf-8")+"&timelimit="+timelimit + "&action=" + action;
	  querystr += "&checkStatus=" + checkStatus + "&scope=" + topicScope;
 	  out.print(paginator.getPageBlock(request, "?boardcode=" + boardcode + querystr));
	  %></td>
    </tr>
</table>     
<iframe width=0 height=0 src="" id="hiddenframe"></iframe>
</CENTER>
</BODY>
<script>
function doDel() {
	var ids = getCheckboxValue("ids");
	if (ids=="") {
		alert("<lt:Label res="res.label.forum.topic_m" key="need_id"/>");
		return;
	}
	window.location.href = "topic_check.jsp?op=del&checkStatus=<%=checkStatus%>&ids=" + ids;
}

function doCheck() {
	var ids = getCheckboxValue("ids");
	if (ids=="") {
		alert("<lt:Label res="res.label.forum.topic_m" key="need_id"/>");
		return;
	}
	window.location.href = "topic_check.jsp?op=check&checkStatus=<%=checkStatus%>&ids=" + ids;
}

function sel() {
	var ids = getCheckboxValue("ids");
	window.opener.selTopic(ids);
	window.close();
}

function selAllCheckBox(checkboxname){
	var checkboxboxs = document.all.item(checkboxname);
	if (checkboxboxs!=null)
	{
		// 如果只有一个元素
		if (checkboxboxs.length==null) {
			checkboxboxs.checked = true;
		}
		for (i=0; i<checkboxboxs.length; i++)
		{
			checkboxboxs[i].checked = true;
		}
	}
}

function clearAllCheckBox(checkboxname) {
	var checkboxboxs = document.all.item(checkboxname);
	if (checkboxboxs!=null)
	{
		// 如果只有一个元素
		if (checkboxboxs.length==null) {
			checkboxboxs.checked = false;
		}
		for (i=0; i<checkboxboxs.length; i++)
		{
			checkboxboxs[i].checked = false;
		}
	}
}
</script>
</HTML>
