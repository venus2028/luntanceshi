<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.cloudwebsoft.framework.web.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ page import="cn.js.fan.module.cms.plugin.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Vector"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<HTML><HEAD><TITLE><lt:Label res="res.label.cms.menu" key="title"/></TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<LINK href="../images/default.css" type=text/css rel=stylesheet>
<STYLE type=text/css>.ttl {
	CURSOR: hand; COLOR: #ffffff; PADDING-TOP: 4px
}
</STYLE>
<script language="javascript" src="../inc/common.js"></script>
<SCRIPT language=javascript>
function showHide(obj) {
  var oStyle;
	if (!isIE())
		oStyle = obj.parentNode.parentNode.parentNode.rows[1].style;
	else
		oStyle = obj.parentElement.parentElement.parentElement.rows[1].style;
    oStyle.display == "none" ? oStyle.display = "" : oStyle.display = "none";
}
</SCRIPT>
<META content="MSHTML 6.00.3790.259" name=GENERATOR></HEAD>
<BODY bgColor=#9aadcd leftMargin=0 topMargin=0>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<BR>
<%
if (!privilege.isUserLogin(request)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
String rootpath = request.getContextPath();

// 检查是否为子站点管理员
cn.js.fan.module.pvg.User user = new cn.js.fan.module.pvg.User();
user = user.getUser(privilege.getUser(request));

String siteCode = ParamUtil.get(request, "siteCode");
SiteDb sd = new SiteDb();
sd = sd.getSiteDb(siteCode);
if (!SitePrivilege.canManage(request, sd)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
boolean isCustomize = sd.getInt("is_customize")==1;

Directory dir = new Directory();
Leaf leaf = dir.getLeaf(siteCode);
if (leaf==null)
	return;
%>
<TABLE cellSpacing=0 cellPadding=0 width=159 align=center border=0>
  <TBODY>
    <TR>
      <TD width=23><IMG height=25 src="../images/box_topleft.gif" width=23></TD>
      <TD class=ttl onclick=showHide(this) width=129 background="../images/box_topbg.gif"><%=leaf.getName()%>
      </TD>
      <TD width=7><IMG height=25 src="../images/box_topright.gif" width=7></TD>
    </TR>
    <TR>
      <TD style="PADDING-RIGHT: 3px; PADDING-LEFT: 3px; PADDING-BOTTOM: 3px; PADDING-TOP: 3px" background="../images/box_bg.gif" colSpan=3><TABLE width="100%">
        <TBODY>
		<TR>
		  <TD><IMG height=7 hspace=5 src="../images/arrow.gif" width=5 align=absMiddle>
		  <%if (Global.isSubDomainSupported) {%>
			  <A href="http://<%=leaf.getCode()%>.<%=DomainDispatcher.getBaseDomain(request)%>" target=_blank>查看站点</A>
		  <%}else{%>
			  <A href="../../site.jsp?siteCode=<%=StrUtil.UrlEncode(leaf.getCode())%>" target=_blank>查看站点</A>
		  <%}%>		  </TD>
		  </TR>
		<TR>
		  <TD><IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <A 
            href="doc_add.jsp?siteCode=<%=StrUtil.UrlEncode(leaf.getCode())%>" 
            target=mainFrame>发布文章</A></TD>
		  </TR>
		<TR>
            <TD><IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <A 
            href="../document_list_m.jsp?dir_code=<%=StrUtil.UrlEncode(leaf.getCode())%>" 
            target=mainFrame>文章管理</A></TD>
          </TR>
		<TR>
		  <TD><IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <A 
            href="../dir_frame.jsp?root_code=<%=StrUtil.UrlEncode(leaf.getCode())%>" 
            target=mainFrame>目录管理</A></TD>
		  </TR>
		<%if (!isCustomize) {%>
		<TR>
		  <TD><IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <A 
            href="../img_frame.jsp?dir=<%=StrUtil.UrlEncode(leaf.getCode())%>" 
            target=mainFrame>图片管理</A></TD>
		  </TR>
		<%}%>
		<%if (!isCustomize) {%>		
		<TR>
		  <TD><IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <A 
            href="../flash_frame.jsp?dir=<%=StrUtil.UrlEncode(leaf.getCode())%>" 
            target=mainFrame>Flash管理</A></TD>
		  </TR>
		<TR>
		  <TD><IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <A 
            href="document_batch_m.jsp?siteCode=<%=StrUtil.UrlEncode(leaf.getCode())%>" 
            target=mainFrame>批量管理</A></TD>
		  </TR>
		<%}%>
          <TR>
            <TD><IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <A 
            href="site_nav_m.jsp?type=<%=StrUtil.UrlEncode(leaf.getCode())%>" 
            target=mainFrame><lt:Label res="res.label.cms.menu" key="navigation"/></A></TD>
          </TR>
		  <TR>
            <TD><IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <A 
            href="site_link.jsp?userName=<%=StrUtil.UrlEncode(leaf.getCode())%>" 
            target=mainFrame>友情链接</A></TD>
          </TR>
          <TR>
            <TD><IMG height=7 hspace=5 src="../images/arrow.gif" width=5 align=absMiddle> <a href="site_ad_list.jsp?siteCode=<%=StrUtil.UrlEncode(leaf.getCode())%>" target=mainFrame>广告管理</a></TD>
          </TR>
		<%if (!isCustomize) {%>		  
          <TR>
            <TD><IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <a href="site_flash_image_list.jsp?siteCode=<%=StrUtil.UrlEncode(leaf.getCode())%>" target=mainFrame>Flash图片</a></TD>
          </TR>
          <TR>
            <TD><IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <a href="site_scroll_img_list.jsp?siteCode=<%=StrUtil.UrlEncode(leaf.getCode())%>" target=mainFrame>滚动图片</a></TD>
          </TR>
          <TR>
            <TD><IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <a href="site_css.jsp?siteCode=<%=StrUtil.UrlEncode(leaf.getCode())%>" target=mainFrame>模板/CSS</a></TD>
          </TR>
          <TR>
            <TD><IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <a href="comment_all_m.jsp?siteCode=<%=StrUtil.UrlEncode(leaf.getCode())%>" target=mainFrame>评论管理</a></TD>
          </TR>
          <TR>
            <TD><IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <a href="site_guestbook.jsp?siteCode=<%=StrUtil.UrlEncode(leaf.getCode())%>" target=mainFrame>留言管理</a></TD>
          </TR>
		<%}%>
          <TR>
            <TD><IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <a href="home.jsp?siteCode=<%=StrUtil.UrlEncode(leaf.getCode())%>" target=mainFrame>首页管理</a>
			</TD>
          </TR>
		  <%
		  if (privilege.isUserPrivValid(request, "admin") || com.redmoon.forum.Privilege.getUser(request).equals(sd.getString("owner"))) {
			long blogId = com.redmoon.blog.UserConfigMgr.getOrCreateForUser(sd.getString("owner"), false);
		  %>
          <TR>
            <TD>
			<IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <a href="../../blog/user/music.jsp?blogId=<%=blogId%>" target=mainFrame>歌曲管理</a></TD>
          </TR>
		  <%}%>
          <TR>
            <TD><IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <a href="../counter/showcount_site.jsp?siteCode=<%=StrUtil.UrlEncode(leaf.getCode())%>" target=mainFrame>访问统计</a></TD>
          </TR>
          <TR>
            <TD><IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <a href="doc_statistic_user_list.jsp?siteCode=<%=StrUtil.UrlEncode(leaf.getCode())%>" target=mainFrame>发布统计</a></TD>
          </TR>		  
		  <TR>
            <TD><IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <a href="site.jsp?siteCode=<%=StrUtil.UrlEncode(leaf.getCode())%>" target=mainFrame>站点设置</a></TD>
          </TR>
		  <%if (privilege.isUserPrivValid(request, "admin")) {%>
          <TR>
            <TD><IMG height=7 hspace=5 
            src="../images/arrow.gif" width=5 align=absMiddle> <a href="../frame.jsp" target="_parent">返回CMS</a></TD>
          </TR>
		  <%}%>
        </TBODY>
      </TABLE>
	  </TD>
    </TR>
    </TR>
    <TR>
      <TD colSpan=3><IMG height=10 src="../images/box_bottom.gif" width=159></TD>
    </TR>
  </TBODY>
</TABLE>
</BODY></HTML>
