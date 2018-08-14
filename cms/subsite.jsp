<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*" %>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ page import="com.cloudwebsoft.framework.web.*" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.cms.doc" key="artical_list"/></title>
<link href="../common.css" rel="stylesheet" type="text/css">
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
<script type="text/javascript" src="../util/jscalendar/calendar.js"></script>
<script type="text/javascript" src="../util/jscalendar/lang/calendar-zh.js"></script>
<script type="text/javascript" src="../util/jscalendar/calendar-setup.js"></script>
<style type="text/css"> @import url("../util/jscalendar/calendar-win2k-2.css"); </style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<jsp:useBean id="dir" scope="page" class="cn.js.fan.module.cms.Directory"/>
<%
String dirCode = ParamUtil.get(request, "dir_code");
Leaf lf = new Leaf();
lf = lf.getLeaf(dirCode);
if (lf==null) {
	out.print(StrUtil.Alert_Back("站点不存在!"));
	return;
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">站点管理</td>
    </tr>
  </tbody>
</table>
<br>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="100%" height="22">&nbsp;&nbsp;<a href="dir_frame.jsp?root_code=<%=StrUtil.UrlEncode(dirCode)%>">管理目录</a>&nbsp;|
      <%if (Global.isSubDomainSupported) {%>
      <a href="http://<%=dirCode%>.<%=DomainDispatcher.getBaseDomain(request)%>" target="_blank">查看站点</a>
      <%}else{%>
      <a href="../site.jsp?siteCode=<%=StrUtil.UrlEncode(dirCode)%>" target="_blank">查看站点</a>
      <%}%>
      <%if (privilege.isUserPrivValid(request, "admin")) {%>
      |
      <a href="site/site.jsp?siteCode=<%=dirCode%>" target="_blank">站点属性</a>
	  <%}%>
	  | <a href="site/frame.jsp?siteCode=<%=dirCode%>" target="_blank">站点管理</a></td>
  </tr>
</table>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellspacing="1" cellpadding="3" width="98%" align="center">
  <tbody>
    <tr>
      <td align="left" nowrap class="thead" style="PADDING-LEFT: 10px"><%=lf.getName()%></td>
    </tr>
    <%
	if (!lf.getParentCode().equals("-1")) {
	%>
    <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1">
      <td align="left">
	<div class="subDir">	  
	  <img src="images/parent.gif" />
        <%
		 Leaf pLeaf = lf.getLeaf(lf.getParentCode());
		 if (pLeaf.getCode().equals(Leaf.ROOTCODE) || pLeaf.getType()==Leaf.TYPE_NONE) {%>
          <a href="dir_common.jsp?dir_code=<%=lf.getParentCode()%>"><%=pLeaf.getName()%></a>
          <%} else if (pLeaf.getType()==Leaf.TYPE_LIST) {%>
          <a href="document_list_m.jsp?dir_code=<%=lf.getParentCode()%>"><%=pLeaf.getName()%></a>
          <%} else if (pLeaf.getType()==Leaf.TYPE_COLUMN) {%>
          <a href="column.jsp?dir_code=<%=lf.getParentCode()%>"><%=pLeaf.getName()%></a>
          <%}%>	
		  </div>
		  </td>
    </tr>
    <%}%>
    <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1">
      <td align="left">
    <%
		String userName = privilege.getUser(request);
		java.util.Iterator irch = lf.getChildren().iterator();
		while (irch.hasNext()) {
			Leaf clf = (Leaf)irch.next();
			LeafPriv lp = new LeafPriv(clf.getCode());
        	if (!lp.canUserSeeWithAncestorNode(userName))
				continue;
	%>
		<div class="subDir">
		<span>
		  <%if (clf.getChildCount()>0) {%>
			  <img src="../images/add.gif" />
          <%}else{%>
			  <img src="../images/minus.gif" />
          <%}%>
          <!--<img src="images/folder_01.gif" />-->
        <%
			String url = "document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(clf.getCode());
			if (clf.getType()==Leaf.TYPE_DOCUMENT) {
				url = "../fckwebedit_new.jsp?op=editarticle&dir_code=" + StrUtil.UrlEncode(clf.getCode());
			}
			else if (clf.getType()==Leaf.TYPE_LINK) {
				url = clf.getDescription();
			}
			String className = "";
			if (clf.getType()==Leaf.TYPE_SUB_SITE)
				className="class='subsite'";			
			%>
        <a href="<%=url%>" title="<%=clf.getName()%>(<%=clf.getTypeDesc(request)%>)" <%=clf.getType()==Leaf.TYPE_LINK?"target=_blank":""%> <%=className%>><%=clf.getName()%></a>		</span>
		<span>
		<%
		if (clf.getType()!=Leaf.TYPE_LINK && clf.getType()!=Leaf.TYPE_SUB_SITE) {
			if (clf.getType()==Leaf.TYPE_LIST) {%>
			<a href="../<%=DocumentMgr.getWebEditPage()%>?op=add&dir_code=<%=StrUtil.UrlEncode(clf.getCode())%>" title="发布文章"><img border="0" src="../images/modify.gif" /></a>
			<%}else{%>
			<a href="document_list_m.jsp?dir_code=<%=StrUtil.UrlEncode(clf.getCode())%>" title="发布文章"><img border="0" src="../images/modify.gif" /></a>
			<%}
		}%>
		</span>		</div>
    <%}%>	</td>
    </tr>
  </tbody>
</table>
</body>
<script>
function doClip(param){
eval(param).focus()
eval(param).document.execCommand("selectAll");
eval(param).document.execCommand('Copy');
}
</script>
</html>