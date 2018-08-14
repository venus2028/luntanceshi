<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ page import="cn.js.fan.module.nav.*" %>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.cms.nav_m" key="nav_mgr"/></title>
<link href="../default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}

#nav {
    height: 30px;
    width: 100%;
}
#nav ul {
    margin: 0 0 0 30px;
    padding: 0px;
    font-size: 12px;
    color: #FFF;
    line-height: 30px;
    white-space: nowrap;
}
#nav li {
    list-style-type: none;
    display: inline;
}
#nav li a {
    text-decoration: none;
    padding: 7px 10px;
}
#nav li a:hover {
    color: #FF6600;
}
-->
</style>
<%@ include file="../../inc/nocache.jsp"%>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="navmgr" scope="page" class="cn.js.fan.module.nav.NavigationMgr"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
String siteCode = ParamUtil.get(request, "type");
SiteDb sd = new SiteDb();
sd = sd.getSiteDb(siteCode);
if (!SitePrivilege.canManage(request, sd)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
String type = siteCode;

String op = StrUtil.getNullString(request.getParameter("op"));
if (op.equals("add")) {
	try {
		if (navmgr.add(request))
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"info_op_success"), "site_nav_m.jsp?type=" + siteCode));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}
else if (op.equals("edit")) {
	try {
		if (navmgr.update(request))
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"info_op_success"), "site_nav_m.jsp?type=" + siteCode));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}
else if (op.equals("move")) {
	try {
		if (navmgr.move(request))
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"info_op_success"), "site_nav_m.jsp?type=" + siteCode));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}
else if (op.equals("del")) {
	if (navmgr.del(request))
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"info_op_success"), "site_nav_m.jsp?type=" + siteCode));
	else
		out.print(StrUtil.Alert(SkinUtil.LoadString(request,"info_op_fail")));
	return;
}
else if (op.equals("generate")) {
	navmgr.createJSFile(request, type);
	out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"info_op_success"), "site_nav_m.jsp?type=" + siteCode));
	return;
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head"><lt:Label res="res.label.cms.nav_m" key="nav_mgr"/></td>
    </tr>
  </tbody>
</table>
<%
String sql = "select name,link,color,target,nav_type,code from cws_cms_nav where nav_type=" + StrUtil.sqlstr(type) + " order by orders";
RMConn rmconn = new RMConn(Global.defaultDB);
ResultIterator ri = rmconn.executeQuery(sql);
ResultRecord rr = null;
String name,code;
String link,color,target;
%>
<br>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="96%" align="center">
  <tbody>
    <tr>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="21%"><lt:Label res="res.label.cms.nav_m" key="name"/></td>
      <td class="thead" noWrap width="17%"><img src="../images/tl.gif" align="absMiddle" width="10" height="15">
      <lt:Label res="res.label.cms.nav_m" key="link"/></td>
      <td class="thead" noWrap width="19%"><lt:Label res="res.label.cms.nav_m" key="color"/></td>
      <td class="thead" noWrap width="14%"><img src="../images/tl.gif" align="absMiddle" width="10" height="15">
      <lt:Label res="res.label.cms.nav_m" key="target"/></td>
      <td width="29%" noWrap class="thead"><img src="../images/tl.gif" align="absMiddle" width="10" height="15">
      <lt:Label res="res.label.cms.nav_m" key="oper"/></td>
    </tr>
<%
int i=100;
boolean isColumnFound = false;
while (ri.hasNext()) {
	i++;
 	rr = (ResultRecord)ri.next();
	name = rr.getString(1);
	link = rr.getString(2);
	color = StrUtil.getNullString(rr.getString(3));
	target = StrUtil.getNullString(rr.getString(4));
	type = rr.getString(5);
	code = rr.getString(6);
	%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
	<form name="form<%=i%>" action="?op=edit" method="post">
      <td style="PADDING-LEFT: 10px">
	  <%if (link.equalsIgnoreCase(Navigation.LINK_COLUMN)) {
	  isColumnFound = true;
	  %>
	  栏目
	  <%}else{%>
	  <input name=newname value="<%=name%>">
	  <%}%>	  </td>
      <td>
  	  <%if (link.equalsIgnoreCase(Navigation.LINK_COLUMN)) {%>
	  栏目导航菜单
	  <%}else{%>
	  <input name=link value="<%=link%>" size="30">
	  <%}%>	  
	  <input name="name" value="<%=name%>" type="hidden">
        <input name="type" value="<%=type%>" type="hidden">
		
		<input name="code" value="<%=code%>" type="hidden"></td>
      <td><span class="stable">
      <select name="color" >
        <option value="" style="COLOR: black" selected><lt:Label res="res.label.cms.nav_m" key="color_no"/></option>
        <option style="BACKGROUND: #000088" value="#000088"></option>
        <option style="BACKGROUND: #F998A4" value="#F998A4"></option>
        <option style="BACKGROUND: #ffffff" value="#ffffff"></option>
        <option style="BACKGROUND: #0000ff" value="#0000ff"></option>
        <option style="BACKGROUND: #B5FADB" value="#B5FADB"></option>
        <option style="BACKGROUND: #F7BEC2" value="#F7BEC2"></option>
        <option style="BACKGROUND: #008800" value="#008800"></option>
        <option style="BACKGROUND: #008888" value="#008888"></option>
        <option style="BACKGROUND: #0088ff" value="#0088ff"></option>
        <option style="BACKGROUND: #00a010" value="#00a010"></option>
        <option style="BACKGROUND: #1100ff" value="#1100ff"></option>
        <option style="BACKGROUND: #111111" value="#111111"></option>
        <option style="BACKGROUND: #333333" value="#333333"></option>
        <option style="BACKGROUND: #50b000" value="#50b000"></option>
        <option style="BACKGROUND: #880000" value="#880000"></option>
        <option style="BACKGROUND: #8800ff" value="#8800ff"></option>
        <option style="BACKGROUND: #888800" value="#888800"></option>
        <option style="BACKGROUND: #888888" value="#888888"></option>
        <option style="BACKGROUND: #8888ff" value="#8888ff"></option>
        <option style="BACKGROUND: #aa00cc" value="#aa00cc"></option>
        <option style="BACKGROUND: #aaaa00" value="#aaaa00"></option>
        <option style="BACKGROUND: #ccaa00" value="#ccaa00"></option>
        <option style="BACKGROUND: #ff0000" value="#ff0000"></option>
        <option style="BACKGROUND: #ff0088" value="#ff0088"></option>
        <option style="BACKGROUND: #ff00ff" value="#ff00ff"></option>
        <option style="BACKGROUND: #ff8800" value="#ff8800"></option>
        <option style="BACKGROUND: #ff0005" value="#ff0005"></option>
        <option style="BACKGROUND: #ff88ff" value="#ff88ff"></option>
        <option style="BACKGROUND: #ee0005" value="#ee0005"></option>
        <option style="BACKGROUND: #ee01ff" value="#ee01ff"></option>
        <option style="BACKGROUND: #3388aa" value="#3388aa"></option>
        <option style="BACKGROUND: #000000" value="#000000"></option>
      </select>
	  <script>
	  form<%=i%>.color.value = "<%=color%>";
	  </script>
</span></td>
      <td><select name="target">
          <option value="_self"><lt:Label res="res.label.cms.nav_m" key="default"/></option>
          <option value="_blank"><lt:Label res="res.label.cms.nav_m" key="new_window"/></option>
          <option value="_parent"><lt:Label res="res.label.cms.nav_m" key="parent_window"/></option>
          <option value="_top"><lt:Label res="res.label.cms.nav_m" key="top_window"/></option>
        </select>
          <script>
	  form<%=i%>.target.value = "<%=target%>";
	    </script>      </td>
      <td>
	  <%if (!link.equalsIgnoreCase(Navigation.LINK_COLUMN)) {%>	  
	  [ <a href="javascript:form<%=i%>.submit()"><%=SkinUtil.LoadString(request,"op_edit")%></a> ]
	  <%}%>
	   [ <a onClick="if (!confirm('<lt:Label res="res.label.cms.nav_m" key="confirm_del"/>')) return false" href="site_nav_m.jsp?op=del&code=<%=StrUtil.UrlEncode(code)%>&type=<%=type%>"><%=SkinUtil.LoadString(request,"op_del")%></a> ] [<a href="site_nav_m.jsp?op=move&direction=up&code=<%=StrUtil.UrlEncode(code)%>&type=<%=type%>"><lt:Label res="res.label.cms.nav_m" key="move_up"/></a>] [<a href="site_nav_m.jsp?op=move&direction=down&code=<%=StrUtil.UrlEncode(code)%>&type=<%=type%>"><lt:Label res="res.label.cms.nav_m" key="move_down"/></a>] </td>
	  </form>
    </tr>
<%}%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
	<form name="addform1" action="?op=add" method="post">
      <td style="PADDING-LEFT: 10px"><input name=name value=""></td>
      <td><input name=link value="" size="30">
        <input name="type" value="<%=type%>" type="hidden"></td>
      <td><span class="stable">
        <SELECT name="color">
          <option value="" STYLE="COLOR: black" selected><lt:Label res="res.label.cms.nav_m" key="color_no"/></option>
          <option style="BACKGROUND: #000088" value="#000088"></option>
          <option style="BACKGROUND: #0000ff" value="#0000ff"></option>
          <option style="BACKGROUND: #008800" value="#008800"></option>
          <option style="BACKGROUND: #008888" value="#008888"></option>
          <option style="BACKGROUND: #0088ff" value="#0088ff"></option>
          <option style="BACKGROUND: #00a010" value="#00a010"></option>
          <option style="BACKGROUND: #1100ff" value="#1100ff"></option>
          <option style="BACKGROUND: #111111" value="#111111"></option>
          <option style="BACKGROUND: #333333" value="#333333"></option>
          <option style="BACKGROUND: #50b000" value="#50b000"></option>
          <option style="BACKGROUND: #880000" value="#880000"></option>
          <option style="BACKGROUND: #8800ff" value="#8800ff"></option>
          <option style="BACKGROUND: #888800" value="#888800"></option>
          <option style="BACKGROUND: #888888" value="#888888"></option>
          <option style="BACKGROUND: #8888ff" value="#8888ff"></option>
          <option style="BACKGROUND: #aa00cc" value="#aa00cc"></option>
          <option style="BACKGROUND: #aaaa00" value="#aaaa00"></option>
          <option style="BACKGROUND: #ccaa00" value="#ccaa00"></option>
          <option style="BACKGROUND: #ff0000" value="#ff0000"></option>
          <option style="BACKGROUND: #ff0088" value="#ff0088"></option>
          <option style="BACKGROUND: #ff00ff" value="#ff00ff"></option>
          <option style="BACKGROUND: #ff8800" value="#ff8800"></option>
          <option style="BACKGROUND: #ff0005" value="#ff0005"></option>
          <option style="BACKGROUND: #ff88ff" value="#ff88ff"></option>
          <option style="BACKGROUND: #ee0005" value="#ee0005"></option>
          <option style="BACKGROUND: #ee01ff" value="#ee01ff"></option>
          <option style="BACKGROUND: #3388aa" value="#3388aa"></option>
          <option style="BACKGROUND: #000000" value="#000000"></option>
        </SELECT>
      </span></td>
      <td><select name="target">
          <option value="_self" selected><lt:Label res="res.label.cms.nav_m" key="default"/></option>
          <option value="_blank"><lt:Label res="res.label.cms.nav_m" key="new_window"/></option>
          <option value="_parent"><lt:Label res="res.label.cms.nav_m" key="parent_window"/></option>
          <option value="_top"><lt:Label res="res.label.cms.nav_m" key="top_window"/></option>
      </select></td>
      <td><INPUT 
onclick="return addform1.submit()" type="button" value="<%=SkinUtil.LoadString(request,"op_add")%>"> </td>
	</form>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td colspan="5" style="PADDING-LEFT: 10px">
	  <%
	  if (!isColumnFound) {
	  %>
	  >>&nbsp;<a href="#" onclick="addform1.name.value='<%=Navigation.LINK_COLUMN%>';addform1.link.value='<%=Navigation.LINK_COLUMN%>';addform1.submit()">将栏目置于导航条</a>
	  <%
	  }
	  %>
	  </td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td colspan="5" style="PADDING-LEFT: 10px">
<style>
ul#navmenu {
 margin: 0;
 border: 0 none;
 padding: 0;
 /*width: 800px; For KHTML*/
 list-style: none;
 height: 24px;
}

ul#navmenu li {
 margin: 0;
 border: 0 none;
 padding: 0;
 float: left; /*For Gecko*/
 display: inline;
 list-style: none;
 position: relative;
 height: 24px;
 padding-right:30px;
}

ul#navmenu ul {
 margin: 0;
 border: 0 none;
 padding: 0;
 width: 120px;
 list-style: none;
 display: none;
 position: absolute;
 top: 24px;
 left: 0;
}

ul#navmenu ul li {
 float: none; /*For Gecko*/
 display: block !important;
 display: inline; /*For IE*/
}

/* Root Menu */
ul#navmenu a {
/*
 border: 1px solid #FFF;
 border-right-color: #CCC;
 border-bottom-color: #CCC;
 background: #EEE;
*/ 
 padding: 0 6px;
 float: none !important; /*For Opera*/
 float: left; /*For IE*/
 display: block;
 color: #666;
 text-decoration: none;
 height: auto !important;
 height: 1%; /*For IE*/
}

/* Root Menu Hover Persistence */
ul#navmenu a:hover,
ul#navmenu li:hover a,
ul#navmenu li.iehover a {
 /*
 background: #CCC;
 */
 color: #ff5555;
 height:22px; 
}

/* 2nd Menu */
ul#navmenu li:hover li a,
ul#navmenu li.iehover li a {
 float: none;
 background: #EEE;
 color: #666;
}

/* 2nd Menu Hover Persistence */
ul#navmenu li:hover li a:hover,
ul#navmenu li:hover li:hover a,
ul#navmenu li.iehover li a:hover,
ul#navmenu li.iehover li.iehover a {
 background: #CCC;
 color: #FFF;
}

/* 3rd Menu */
ul#navmenu li:hover li:hover li a,
ul#navmenu li.iehover li.iehover li a {
 background: #EEE;
 color: #666;
}

/* 3rd Menu Hover Persistence */
ul#navmenu li:hover li:hover li a:hover,
ul#navmenu li:hover li:hover li:hover a,
ul#navmenu li.iehover li.iehover li a:hover,
ul#navmenu li.iehover li.iehover li.iehover a {
 background: #CCC;
 color: #FFF;
}

/* 4th Menu */
ul#navmenu li:hover li:hover li:hover li a,
ul#navmenu li.iehover li.iehover li.iehover li a {
 background: #EEE;
 color: #666;
}

ul#navmenu li ul li a.fly
{background:#eee url(images/arrow.gif) 110px 6px no-repeat;}
ul#navmenu li ul li a.fly:hover
{background:#ccc url(images/arrow.gif) 110px 6px no-repeat; color: #FFF}

/* 4th Menu Hover */
ul#navmenu li:hover li:hover li:hover li a:hover,
ul#navmenu li.iehover li.iehover li.iehover li a:hover {
 background: #CCC;
 color: #FFF;
}

ul#navmenu ul ul,
ul#navmenu ul ul ul {
 display: none;
 position: absolute;
 top: 0;
 left: 120px;
}

/* Do Not Move - Must Come Before display:block for Gecko */
ul#navmenu li:hover ul ul,
ul#navmenu li:hover ul ul ul,
ul#navmenu li.iehover ul ul,
ul#navmenu li.iehover ul ul ul {
 display: none;
}

ul#navmenu li:hover ul,
ul#navmenu ul li:hover ul,
ul#navmenu ul ul li:hover ul,
ul#navmenu li.iehover ul,
ul#navmenu ul li.iehover ul,
ul#navmenu ul ul li.iehover ul {
 display: block;
}

</style>  
	  <div id="nav">
	  预览：
	  <%
	  SiteTemplateImpl sti = new SiteTemplateImpl();
	  out.print(sti.renderNav(request, sd));
	  %>
	  </div>
	  
<script type="text/JavaScript">
navHover = function() {
  var nav = document.getElementById("navmenu");
  if (nav==null)
  	return;
  var lis = nav.getElementsByTagName("LI");
  for (var i=0; i<lis.length; i++) {
    lis[i].onmouseover=function() {
      this.className+=" iehover";
    }
    lis[i].onmouseout=function() {
      this.className=this.className.replace(new RegExp(" iehover\\b"), "");
    }
  }
}
if (window.attachEvent) window.attachEvent("onload", navHover);
</script>
		</td>
    </tr>
<%
cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
boolean isHtml = cfg.getBooleanProperty("cms.html_doc");
if (isHtml) {
%>	
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td colspan="5" align="center" style="PADDING-LEFT: 10px">
	  <input type="button" value="重新生成导航条" onclick="window.location.href='site_nav_m.jsp?type=<%=siteCode%>&op=generate'" />	  </td>
    </tr>
<%}%>	
  </tbody>
</table>
</body>
</html>