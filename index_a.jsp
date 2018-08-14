<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.cloudwebsoft.framework.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%
if (Global.isSubDomainSupported) {
	if (DomainDispatcher.dispatch(request, response)==1) {
		return;
	}
}
%>
<%@ taglib uri="/WEB-INF/tlds/DirListTag.tld" prefix="dirlist" %>
<%@ taglib uri="/WEB-INF/tlds/DocumentTag.tld" prefix="left_doc" %>
<%@ taglib uri="/WEB-INF/tlds/DocListTag.tld" prefix="dl" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>云网论坛 - Powered by CWBBS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="template/css.css" type="text/css" rel="stylesheet" />
</head>
<body>
<div class="content">
<%@ include file="header.jsp"%>
<div class="notice"><span class="notice_title">网站公告：</span>
<marquee class="notice_content" scrollamount="2" scrolldelay="20">
<script src="forum/js.jsp?var=forum.notice"></script>
</marquee><span class="notice_search">
<form action="search_full_text_do.jsp" method="post">
<input class="notice_search_input" name="queryString" type="text" /> <input type="hidden" name="fieldName" value="content" /> <input type="image" height="19" width="74" src="template/images/btn_search.gif" align="middle" />
</form>
</span></div>
<div class="middle">
<div class="main">
<div class="flash_img">
<script src="js.jsp?var=flashImg&id=23"></script>
</div>
<div class="main_box_top"><span><a href="forum/index.jsp"><img alt="" src="template/images/more1.gif" border="0" /></a></span> 焦点热贴</div>
<div class="main_box_middle">
<script src="forum/js.jsp?var=forum.hot"></script>
</div>
<div class="main_box_bottom"></div>
<div class="left_box_top"><a href="doc_list.jsp?dirCode=first">第一频道</a></div>
<div class="left_box_middle">
<script src="js.jsp?dirCode=first&start=0&end=8"></script>
</div>
<div class="left_box_bottom"></div>
<div class="main_box_top"><span><img alt="" src="template/images/more1.gif" /></span>时事杂谈</div>
<div class="main_box_middle"></div>
<div class="main_box_bottom"></div>
<div class="photo_box_top"><span><img alt="" src="template/images/more2.gif" /></span>精彩图片</div>
<div class="photo_box_middle">
<script src="js.jsp?var=scrollImg"></script>
</div>
<div class="photo_box_bottom"></div>

<%
String dirCode = ParamUtil.get(request, "dirCode");
if (dirCode.equals(""))
	dirCode = Leaf.ROOTCODE;
LeafChildrenCacheMgr lccm = new LeafChildrenCacheMgr(dirCode);
Iterator ir = lccm.getDirList().iterator();
while (ir.hasNext()) {
	Leaf lf = (Leaf)ir.next();
	if (lf.getIsHome()) {
%>
	<div class="main_box2">
	<div class="main_box2_top">
	<span>
	<a href="doc_list.jsp?dirCode=<%=lf.getCode()%>"><img alt="" src="template/images/more2.gif" border="0" /></a>
	</span>
	<a href="doc_list.jsp?dirCode=<%=lf.getCode()%>" title="<%=lf.getName()%>" style="PADDING-LEFT: 5px;PADDING-top: 9px;"><%=lf.getName()%></a>
	</div>
	<div class="main_box2_middle">
	<%
	if (lf.getType()==Leaf.TYPE_LIST) {
		cn.js.fan.module.cms.Config cfg1 = new cn.js.fan.module.cms.Config();
		boolean isHtml = cfg1.getBooleanProperty("cms.html_doc");			
		%>
		<dl:DocListTag action="list" query="" dirCode="<%=dirCode%>" start="0" end="10">
		<dl:DocListItemTag field="title" mode="detail">
		<li>
			<%if (isHtml) {%>
				<a href="$htmlName">$title</a>
			<%}else{%>
				<a href="doc_view.jsp?id=$id">$title</a>
			<%}%>
		</li>
		</dl:DocListItemTag>
		</dl:DocListTag>
	<%}else{
		LeafChildrenCacheMgr lccm2 = new LeafChildrenCacheMgr(lf.getCode());
		Iterator ir2 = lccm2.getDirList().iterator();
		while (ir2.hasNext()) {
			Leaf lf2 = (Leaf)ir2.next();
			if (!lf2.getIsHome())
				continue;
		%>
		<li><a href="doc_list.jsp?dirCode=<%=lf2.getCode()%>"><%=lf2.getName()%></a></li>
		<%
		}	
	}%>
	</div>
	<div class="main_box2_bottom"></div>
	</div>
<%}
}%>

</div>
<div class="right">
	<%@ include file="left.jsp"%>
</div>
</div>
<div class="bottom">
<script src='js.jsp?var=ad&dirCode=root&type=footer'></script><script src='/cwbbs/js.jsp?var=ad&dirCode=root&type=couple'></script> <script src='/cwbbs/js.jsp?var=ad&dirCode=root&type=float'></script>
</div>
</div>
<table width="98%" align="center" border="0">
<tbody>
<tr>
<td valign="bottom"><hr style="height: 1px" color="#cccccc" />
</td>
</tr>
<tr>
<td style="font-size: 11px; line-height: 180%; font-family: Tahoma, Arial" valign="bottom" align="center">Powered by <strong>CWBBS</strong> <strong style="color: #ff9900">2.3RC1</strong>&nbsp; ? 2005-2007&nbsp;<a style="font-size: 11px; font-family: Tahoma, Arial" target="_blank" href="http://www.cloudwebsoft.com">Cloud Web Soft</a>&nbsp;&nbsp;Gzip enabled&nbsp;&nbsp;<a href="/forum/wap/index.jsp">wap2.0</a> <br />
QQ：51066962&nbsp;&nbsp;Email:<a href="mailto:fgf163@pub.zj.jsinfo.net">fgf163@pub.zj.jsinfo.net</a><br />
<a href="http://www.miibeian.gov.cn">苏ICP备55555555</a></td>
</tr>
</tbody>
</table>
</body>
</html>

