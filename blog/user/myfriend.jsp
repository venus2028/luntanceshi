<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<link href="../../cms/default.css" rel="stylesheet" type="text/css">
<title><lt:Label res="res.label.forum.myfriend" key="myfriend"/> - <%=Global.AppName%></title>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
}
.STYLE1 {color: #FFFFFF}
-->
</style></head>
<body>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head"><lt:Label res="res.label.blog.user.userconfig" key="friends"/></td>
  </tr>
</table>
<%
if (!privilege.isUserLogin(request)) {
	out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, SkinUtil.PVG_INVALID)));
	return;
}

UserFriendDb ufd = new UserFriendDb();

String op = StrUtil.getNullString(request.getParameter("op"));
if (op.equals("del"))
{
	int delid = ParamUtil.getInt(request, "delid");
	ufd = ufd.getUserFriendDb(delid);
	boolean re = ufd.del();
	if (re) {
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "myfriend.jsp"));
	}
	else
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
	return;
}

if (op.equals("add")) {
	boolean re = false;
	userservice us = new userservice();
	try {
		re = us.AddFriend(request);
	}
	catch (ErrMsgException e) {
		out.println(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
	String privurl = ParamUtil.get(request, "privurl");
	if (privurl.equals(""))
		privurl = "myfriend.jsp";	
	if (re)
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), privurl)); // "加为好友成功！";
	else
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail"))); // "加为好友失败！";
	return;
}

		String sql = "select id from sq_friend where name=" + StrUtil.sqlstr(privilege.getUser(request)) + " order by rq desc";
		int pagesize = 10;
		Paginator paginator = new Paginator(request);
		int curpage = paginator.getCurPage();
					
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
%>
<div id="newdiv" name="newdiv">
  <div align="center"><strong><br>
    </strong>
    <table width="98%" border="0" cellspacing="0" cellpadding="0">
      <tr>
	  <form name=form1 action="myfriend.jsp?op=add" method="post">
        <td align="right"><lt:Label res="res.label.forum.myfriend" key="nick"/>
          <input name="friend" size=15><input type="submit" value="<lt:Label res="res.label.forum.myfriend" key="add_friend"/>"><input name="type" value="nick" type=hidden>
		</td>
	  </form>
      </tr>
    </table>
  </div> 
  <TABLE width="98%" 
border=0 align=center cellPadding=0 cellSpacing=0 class="frame_gray">
    <TBODY>
      <TR> 
        <TD width=131 height=23 align="center" class="thead"><lt:Label res="res.label.forum.myfriend" key="user_name"/></TD>
        <TD width=122 height=23 align="center" class="thead">OICQ</TD>
        <TD width=130 height=23 align="center" class="thead"><lt:Label res="res.label.forum.myfriend" key="birthday"/></TD>
        <TD width=161 align="center" class="thead"><lt:Label res="res.label.forum.myfriend" key="address"/></TD>
        <TD width="12%" align="center" class="thead">状态</TD>
        <TD width=109 height=23 align="center" class="thead"><lt:Label res="res.label.forum.myfriend" key="tel"/></TD>
        <TD width=78 align="center" class="thead"><lt:Label key="op"/></TD>
      </TR>
<%		
String name="",OICQ="",birthday="",address="",phone="",myface="";
String RealPic = "";
int i = 1, state = 0;
UserDb ud = new UserDb();
while (ir.hasNext())
{
	i++;
	ufd = (UserFriendDb)ir.next();
	ud = ud.getUser(ufd.getFriend());
	name = ud.getName();
	OICQ = ud.getOicq();
	if (OICQ==null)
		OICQ = "";
	state = ufd.getState();		
	birthday = DateUtil.format(ud.getBirthday(), "yyyy-MM-dd");
	address = ud.getAddress();
	phone = ud.getPhone();
	RealPic = StrUtil.getNullString(ud.getRealPic());
	myface = StrUtil.getNullString(ud.getMyface());
%>
      <TR> 
        <TD width=131 height=23> &nbsp;
		&nbsp;
		<%if (myface.equals("")) {%>
		  <img src="../../forum/images/face/<%=RealPic%>" width=16 height=16> 
		<%}else{%>
		  <img src="<%=ud.getMyfaceUrl(request)%>" width=16 height=16>
		<%}%>
		<a target="_blank" href="../../userinfo.jsp?username=<%=StrUtil.UrlEncode(name)%>"><%=ud.getNick()%></a> </TD>
        <TD width=122 height=23 align="center"><%=state==1?OICQ:"***"%></TD>
        <TD width=130 height=23 align="center"><%=state==1?birthday:"***"%></TD>
        <TD width=161 align="center"><%=state==1?address:"***"%></TD>
        <TD width="12%" align="center"><%
			if(state == 0) {
		%>
            <font color="#FF0000">[申请中]</font>
            <%
			} else {
		%>
          [好友]
  <%
			}
		%>
        </TD>
        <TD width=109 height=23 align="center"><%=phone%></TD>
        <TD width=78 height=23 align="center"><a href="#" onClick="if (confirm('<lt:Label key="confirm_del"/>')) window.location.href='myfriend.jsp?op=del&delid=<%=ufd.getId()%>'"><lt:Label key="op_del"/></a></TD>
      </TR>
<%
}
%>
    </TBODY>
  </TABLE>
  <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center">
    <tr>
      <td height="23" align="right"><%
	  String querystr = "";
 	  out.print(paginator.getCurPageBlock("myfriend.jsp?"+querystr));
	%>
      </td>
    </tr>
  </table>
</div>
</body>
</html>
