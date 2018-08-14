<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
long blogId = ParamUtil.getLong(request, "blogId", UserConfigDb.NO_BLOG);
UserConfigDb ucd = new UserConfigDb();
ucd = ucd.getUserConfigDb(blogId);
if (!ucd.isLoaded()) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "res.label.blog.list", "activate_blog_fail")));
	return;	
}

request.setAttribute("blogId", new Long(blogId));

// 取得显示的年月 
int year, month, day = 1;
try {
	year = ParamUtil.getInt(request, "y");
	month = ParamUtil.getInt(request, "m");
	day = ParamUtil.getInt(request, "d");
}
catch (Exception e) {
    Calendar cal = Calendar.getInstance();
    year = cal.get(cal.YEAR);
    month = cal.get(cal.MONTH) + 1;
}

String skinPath = "skin/" + ucd.getSkin();
request.setAttribute("skinPath", skinPath);
%>
<html>
<head>
<title><%=ucd.getTitle()%> - <%=ucd.getPenName()%> - <%=Global.AppName%></title>
<LINK href="<%=ucd.getCSS(request)%>" type=text/css rel=stylesheet>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<%@ include file="header.jsp"%>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class=blog_table_main>
  <tr>
    <td width="220"><%@ include file="left.jsp"%></td>
    <td valign="top" class="blog_td_main"><table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_main_text">
      <tr>
        <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="3%" class="blog_td_title">&nbsp;</td>
            <td width="97%" class="blog_td_title"></td>
          </tr>
        </table>
          <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td width="29%" align="center" class="listdayblog_td_title"><lt:Label res="res.label.blog.user.userconfig" key="friends"/>
                </td>
              <td width="71%" align="center" class="listdayblog_td_title"><lt:Label res="res.label.blog.list" key="blog"/></td>
            </tr>
          </table>
        <%
		String sql = "select id from sq_friend where name=" + StrUtil.sqlstr(privilege.getUser(request)) + " order by rq desc";
		int pagesize = 10;
		Paginator paginator = new Paginator(request);
		int curpage = paginator.getCurPage();
					
		UserFriendDb ufd = new UserFriendDb();
		ListResult lr = ufd.listResult(sql, curpage, pagesize);
		int total = lr.getTotal();
		Vector v = lr.getResult();
	    Iterator ir = null;
		if (v!=null)
			ir = v.iterator();
		paginator.init(total, pagesize);
		// 设置当前页数和总页数
		int totalpages = paginator.getTotalPages();
		if (totalpages==0)
		{
			curpage = 1;
			totalpages = 1;
		}
		
		String name="",OICQ="",birthday="",address="",phone="",myface="";
		String RealPic = "";
		int i = 1;
		UserDb ud = new UserDb();
		UserConfigDb fucd2 = new UserConfigDb();
		while (ir.hasNext())
		{
			i++;
			ufd = (UserFriendDb)ir.next();
			ud = ud.getUser(ufd.getFriend());
			
			UserConfigDb fucd = fucd2.getUserConfigDbByUserName(ud.getName());
			if (fucd==null)
				continue;						
			
			name = ud.getName();
			OICQ = ud.getOicq();
			if (OICQ==null)
				OICQ = "";
			birthday = DateUtil.format(ud.getBirthday(), "yyyy-MM-dd");
			address = ud.getAddress();
			phone = ud.getPhone();
			RealPic = StrUtil.getNullString(ud.getRealPic());
			myface = StrUtil.getNullString(ud.getMyface());		
		%>
				  <table width="100%" border="0" cellpadding="5" cellspacing="0">
					<tr>
					  <td width="29%">
		<%if (myface.equals("")) {%>
		  <img src="images/face/<%=RealPic%>" width=16 height=16> 
		<%}else{%>
		  <img src="<%=ud.getMyfaceUrl(request)%>" width=16 height=16>
		<%}%>
		<a target="_blank" href="../userinfo.jsp?username=<%=StrUtil.UrlEncode(name)%>"><%=ud.getNick()%></a>
					  </td>
					  <td width="71%" align="center"><a target="_blank" href="myblog.jsp?blogId=<%=fucd.getId()%>"><%=fucd.getTitle()%></a></td>
					</tr>
					<tr>
					  <td colspan="2" class="blog_td_spacer_down"></td>
				    </tr>
				  </table>
		<%}%>
		   <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center">
             <tr>
               <td height="23" align="right"><%
	  String querystr = "blogId=" + blogId;
 	  out.print(paginator.getCurPageBlock("listfriend.jsp?"+querystr));
	%>
               </td>
             </tr>
           </table></td>
      </tr>
    </table></td>
  </tr>
</table>
<%@ include file="footer.jsp"%>
</body>
</html>