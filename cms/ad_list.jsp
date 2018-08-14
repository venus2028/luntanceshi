<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.ad.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="com.cloudwebsoft.framework.base.*" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>AD List</title>
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, "admin")) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head"><lt:Label res="res.label.forum.admin.ad_list" key="ad_mgr"/></td>
    </tr>
  </tbody>
</table>
<%
AdDb ad = new AdDb();
String op = ParamUtil.get(request, "op");
if (op.equals("del")) {
	int id = ParamUtil.getInt(request, "id");
	ad = (AdDb)ad.getQObjectDb(new Integer(id));
	boolean re = ad.del();
	if (re)
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "ad_list.jsp"));
	else
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));	
}

String sql = ad.getTable().getQueryList();

int total = (int)ad.getQObjectCount(sql);

int pagesize = total; 	// 20;

int curpage,totalpages;
Paginator paginator = new Paginator(request, total, pagesize);
// 设置当前页数和总页数
totalpages = paginator.getTotalPages();
curpage	= paginator.getCurrentPage();
if (totalpages==0) {
	curpage = 1;
	totalpages = 1;
}	

QObjectBlockIterator oir = ad.getQObjects(sql, (curpage-1)*pagesize, curpage*pagesize);

String[] types = new String[] {"头部横幅", "底部横幅", "漂浮广告", "门联广告左", "门联广告右", "文章内广告", "文章底部广告"};
%>
<table width="98%" align="center">
  <tr>
    <td align="center" height="5"></td>
  </tr>
  <tr>
    <td align="center">
<%
int typesLen = types.length;
for (int k=0; k<typesLen; k++) {
%>
        <INPUT name="button" type="button" 
onclick="javascript:location.href='ad_add.jsp?ad_type=<%=k%>';" value="<%=types[k]%>">
      &nbsp;
      <%}%>    </td>
  </tr>
</table>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="1" cellPadding="3" width="98%" align="center">
  <tbody>
    <tr>
      <td class="thead" noWrap width="14%"><lt:Label res="res.label.forum.admin.ad_list" key="name"/></td>
      <td class="thead" noWrap width="18%"><img src="images/tl.gif" align="absMiddle" width="10" height="15"><lt:Label res="res.label.forum.admin.ad_list" key="sort"/></td>
      <td class="thead" noWrap width="22%"><img src="images/tl.gif" align="absMiddle" width="10" height="15"><lt:Label res="res.label.forum.admin.ad_list" key="board"/></td>
      <td class="thead" noWrap width="13%">用户名</td>
      <td class="thead" noWrap width="11%"><img src="images/tl.gif" align="absMiddle" width="10" height="15"><lt:Label res="res.label.forum.admin.ad_list" key="begin_date"/></td>
      <td class="thead" noWrap width="9%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
      <lt:Label res="res.label.forum.admin.ad_list" key="end_date"/></td>
      <td width="13%" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
      <lt:Label res="res.label.forum.admin.ad_list" key="oper"/></td>
    </tr>
<%
Directory dir = new Directory();
while (oir.hasNext()) {
 	ad = (AdDb)oir.next();
	%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td><%=ad.getString("title")%></td>
      <td><%=types[ad.getInt("ad_type")]%></td>
      <td>
	  <%
	  String[] boards = StrUtil.split(ad.getString("boardcodes"), ",");
	  String boardNames = "";
	  if (boards!=null) {
	  	int len = boards.length;
		for (int i=0; i<len; i++) {
	  		Leaf lf = dir.getLeaf(boards[i]);
			if (lf!=null) {
				if (boardNames.equals(""))
					boardNames = lf.getName();
				else
					boardNames += "," + lf.getName();
			}
		}
	  }
	  else {
	  	boardNames = "首页";
	  }
	  out.print(boardNames);
	  %>	  </td>
      <td><%=StrUtil.getNullString(ad.getString("nick"))%></td>
      <td><%=DateUtil.format(ad.getDate("begin_date"), "yyyy-MM-dd")%></td>
      <td><%=DateUtil.format(ad.getDate("end_date"), "yyyy-MM-dd")%></td>
      <td>
	  [<a href="ad_edit.jsp?id=<%=ad.getInt("id")%>"><lt:Label res="res.label.cms.dir" key="modify"/></a>]&nbsp;[<a href="ad_list.jsp?op=del&id=<%=ad.getInt("id")%>"><lt:Label res="res.label.cms.dir" key="del"/></a>]&nbsp;</td>
    </tr>
<%}%>
  </tbody>
</table>
<table width="98%" border="0" align="center">
  <tr>
    <td><br>
      帮助：<br>
        1、在模板中提取的方法是：
      {$ad.id(request.id).header}
      <table width="89%" border="0">
        <tr>
          <td width="13%" height="20"><span class="top_ad">header</span></td>
          <td width="87%"><span class="top_ad">头部横幅 </span></td>
        </tr>
        <tr>
          <td height="20"><span class="top_ad">footer</span></td>
          <td><span class="top_ad">底部横幅</span></td>
        </tr>
        <tr>
          <td height="20"><span class="top_ad">float</span></td>
          <td><span class="top_ad">漂浮广告</span></td>
        </tr>
        <tr>
          <td height="20"><span class="top_ad">couple</span></td>
          <td><span class="top_ad">对联广告左</span></td>
        </tr>
        <tr>
          <td height="20"><span class="top_ad">couple_r</span></td>
          <td><span class="top_ad">对联广告右</span></td>
        </tr>
        <tr>
          <td height="20"><span class="top_ad">doc</span></td>
          <td><span class="top_ad">文章内广告</span></td>
        </tr>
        <tr>
          <td height="20"><span class="top_ad">docBottom</span></td>
          <td><span class="top_ad">文章底部广告</span></td>
        </tr>
      </table>
      <br>
    2、<span class="flash_img">用JS提取的方法是：</span>&lt;script src='js.jsp?var=ad&amp;dirCode=root&amp;type=header'&gt;&lt;/script&gt; (dirCode=root表示提取投放范围为全部目录即首页的广告)</td>
  </tr>
</table>
</body>
</html>