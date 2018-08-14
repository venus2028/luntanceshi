<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.MsgDb"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%@ taglib uri="/WEB-INF/tlds/NavBarTag.tld" prefix="rm" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
String title = SkinUtil.LoadString(request,"res.label.blog.list", "listblog_title");
title = StrUtil.format(title, new Object[] {Global.AppName});
%>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/cwbbs/blog/template/css.css" type="text/css" rel="stylesheet" />
</head>
<body>
<%
String searchType = ParamUtil.get(request, "searchType");
String keyword = ParamUtil.get(request, "keyword");
if(searchType.equals("msgBlogUser")){
	response.sendRedirect("listusersearch.jsp?keyword=" + StrUtil.UrlEncode(keyword));
	return;
}

if (!searchType.equals("") || !keyword.equals("")) {
	if (!SQLFilter.isValidSqlParam(keyword)) {
		out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, SkinUtil.ERR_SQL)));
		return;
	}
}

String sql;
if (searchType.equals("msgTitle"))
	sql = "select id from sq_message where isBlog=1 and replyid=-1 and title like '%" + keyword + "%' ORDER BY lydate desc";
else if (searchType.equals("msgContent"))
	sql = "select id from sq_message where isBlog=1 and replyid=-1 and content like '%" + keyword + "%' ORDER BY lydate desc";
else if (searchType.equals("msgAuthor") && !keyword.equals("")){
	UserMgr um = new UserMgr();
	UserDb ud = null;
	ud = um.getUserDbByNick(keyword);
	sql = "select id from sq_message where isBlog=1 and replyid=-1 and name = " + StrUtil.sqlstr(ud.getName()) + " ORDER BY lydate desc";
}else {
	sql = "select id from sq_thread where isBlog=1 ORDER BY lydate desc";
}

int total = 0;
int pagesize = 20;
int curpage = ParamUtil.getInt(request, "CPages", 1);

UserMgr um = new UserMgr();
MsgDb md = new MsgDb();
ListResult lr = md.list(sql, curpage, pagesize);
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
<div class="content">
    <div class="top">
		<div class="top_logo"><img src="/cwbbs/blog/template/images/logo.gif" / ></div>
	</div>
	<div class="middle">
        <div class="middleAd"><img src="/cwbbs/blog/template/images/middleAd.png" /></div>
		<div class="middleMain">
		<div style="padding:5px;" align="right"><%=paginator.getPageStatics(request)%></div>
		<ul style="padding-left:20px; padding-right:20px">
<%
	Iterator ir = lr.getResult().iterator();

	while (ir.hasNext()) {
	  	md = (MsgDb) ir.next(); 
		UserDb ud = null;
		ud = um.getUser(md.getName());
%>
				<li style="height:28px;" >
				  <span style="float:right; padding-right:5px;"><a href="../userinfo.jsp?username=<%=md.getName()%>"><%=ud.getNick()%></a>&nbsp;&nbsp;&nbsp;&nbsp;[<%=DateUtil.format(md.getAddDate(), "yy-MM-dd HH:mm")%>]</span><a href="showblog.jsp?rootid=<%=md.getId()%>"><%=DefaultRender.RenderFullTitle(request, md)%></a>
				  <table border="0" cellpadding="0" cellspacing="0" style="width:100%; height:1px; background-image:url(images/dot.gif)">
					<tr><td></td></tr></table>
				</li>
<%}%>
		</ul>
		<div style="padding:5px;" align="right">
		<%
			String querystr = "searchType=" + searchType + "&keyword=" + StrUtil.UrlEncode(keyword);
			out.print(paginator.getPageBlock(request,"?"+querystr));
		%>
		</div>		  		
		</div>
		<div class="middleSideBar">
			<div class="middleSideBar_outsideBox_styleOne">
			  <iframe width="260" height="232" hspace=0 vspace=0 frameborder=0 marginwidth="0" marginheight="0" scrolling="no" src="iframe_login.jsp"></iframe>
			</div>
			<div class="middleSideBar_outsideBox_styleTwo"></div>
			<div class="middleSideBar_outsideBox_styleThree">
				<div class="middleSideBar_outsideBox_top_styleOne" style="background-image:url(/cwbbs/blog/template/images/top_boyou.png)"></div>
			</div>			
			<div class="middleSideBar_outsideBox_styleThree">
				<div class="middleSideBar_outsideBox_top_styleOne" style="background-image:url(/cwbbs/blog/template/images/top_boxing.png)"></div>
			</div>
			<div class="middleSideBar_outsideBox_styleThree">
				<div class="middleSideBar_outsideBox_top_styleOne" style="background-image:url(/cwbbs/blog/template/images/top_quanzi.png)"></div>
				<div>{$blog.group}</div>
			</div>
			<div class="middleSideBar_outsideBox_styleThree">
				<div class="middleSideBar_outsideBox_top_styleOne" style="background-image:url(/cwbbs/blog/template/images/top_bokemoban.png)"></div>
			</div>
		</div>
	</div>
	<div class="bottom"></div>
</div>
</body>
</html>