<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<HTML><HEAD><TITLE>title</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8"><LINK 
href="images/default.css" type=text/css rel=stylesheet>
<META content="MSHTML 6.00.3790.259" name=GENERATOR></HEAD>
<BODY text=#000000 bgColor=#eeeeee leftMargin=0 topMargin=0><!-- ACP Page Header Start -->
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
  <TR>
    <TD class=head><lt:Label res="res.label.blog.admin.index" key="title_main"/></TD>
  </TR></TBODY></TABLE><BR><!-- ACP Page Header End -->
<STYLE type=text/css>.tab {
	PADDING-RIGHT: 30px; PADDING-LEFT: 10px; FONT-SIZE: 12px; PADDING-BOTTOM: 1px; CURSOR: hand; PADDING-TOP: 5px; LETTER-SPACING: 1px
}
</STYLE>

<SCRIPT language=JavaScript>
function tabClick( idx ) {

  for ( i = 0; i < 2; i++ ) {
    if ( i == idx ) {
      var tabImgLeft = eval("document.all.tabImgLeft__" + idx );
      var tabImgRight = eval("document.all.tabImgRight__" + idx );
      var tabLabel = eval("document.all.tabLabel__" + idx );
      var tabContent = eval("document.all.tabContent__" + idx );

      tabImgLeft.src = "images/tab_active_left.gif";
      tabImgRight.src = "images/tab_active_right.gif";
      tabLabel.background = "images/tab_active_bg.gif";
      tabContent.style.visibility = "visible";
      tabContent.style.display = "block";
      continue;
    }
    var tabImgLeft = eval("document.all.tabImgLeft__" + i );
    var tabImgRight = eval("document.all.tabImgRight__" + i );
    var tabLabel = eval("document.all.tabLabel__" + i );
    var tabContent = eval("document.all.tabContent__" + i );

    tabImgLeft.src = "images/tab_unactive_left.gif";
    tabImgRight.src = "images/tab_unactive_right.gif";
    tabLabel.background = "images/tab_unactive_bg.gif";
    tabContent.style.visibility = "hidden";
    tabContent.style.display = "none";
  }
}
</SCRIPT>

<TABLE cellSpacing=0 cellPadding=0 width="95%" align=center border=0>
  <TBODY>
  <TR>
    <TD style="PADDING-LEFT: 2px; HEIGHT: 22px" 
    background=images/tab_top_bg.gif>
      <TABLE cellSpacing=0 cellPadding=0 border=0>
        <TBODY>
        <TR>
          <TD>
            <TABLE height=22 cellSpacing=0 cellPadding=0 border=0>
              <TBODY>
              <TR>
                <TD width=3><IMG id=tabImgLeft__0 height=22 
                  src="images/tab_active_left.gif" width=3></TD>
                <TD class=tab id=tabLabel__0 onClick="tabClick( 0 )" 
                background=images/tab_active_bg.gif 
                  UNSELECTABLE="on"><lt:Label res="res.label.blog.admin.index" key="system_info"/></TD>
                <TD width=3><IMG id=tabImgRight__0 height=22 
                  src="images/tab_active_right.gif" 
              width=3></TD></TR></TBODY></TABLE></TD>
          <TD>&nbsp;            </TD>
        </TR></TBODY></TABLE></TD></TR>
  <TR>
    <TD bgColor=#ffffff>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD width=1 background=images/tab_bg.gif><IMG height=1 
            src="images/tab_bg.gif" width=1></TD>
          <TD 
          style="PADDING-RIGHT: 15px; PADDING-LEFT: 15px; PADDING-BOTTOM: 15px; PADDING-TOP: 15px; HEIGHT: 350px" 
          vAlign=top>
            <br>
            <DIV id=tabContent__0 style="DISPLAY: block; VISIBILITY: visible"><!-- Main Table Start -->
<TABLE cellSpacing=0 cellPadding=0 width="100%" align=center>
              <!-- Table Head Start-->
              <TBODY>
                <TR>
                  <TD align=middle><iframe src="cache.jsp" width=100% height="320"></iframe>
                  </TD>
                </TR>
                <!-- Table Body End -->
                <!-- Table Foot -->
                <!-- Table Foot -->
              </TBODY>
            </TABLE>
            <br>
            </DIV>
            <DIV id=tabContent__1 style="DISPLAY:none; VISIBILITY:hidden ">
            <TABLE align=center>
              <TBODY>
              <TR>
                <TD vAlign=top><IMG height=60 src="images/us.gif" 
                  width=60></TD>
                <TD>
                  <TABLE>
                    <TBODY>
                    <TR>
                      <TD colSpan=2><STRONG>镇江云网软件技术有限公司 CMS 后台管理系统 </STRONG><BR>
                        <BR>
                        Copyright &copy; 2004 <A 
                        href="http://www.redmoon.net.com/" target=_blank>www.redmoon.net.cn.</A>, All rights reserved.
                        <hr noshade size=1>
</TD>
                    </TR>
                    <TR>
                      <TD colSpan=2>技术支持：<A 
                        href="http://www.redmoon.net.cn/" 
                        target=_blank>http://www.redmoon.net.cn</A></TD>
                    <TR>
                      <TD colSpan=2>授权协议：</TD></TR>
                    <TR>
                      <TD colSpan=2><TEXTAREA rows=12 cols=80>       镇江云网软件技术有限公司 成立于2005年，从事J2EE应用开发，主要开发方向为OA相关软件，可复用的JAVA组件、WEB类应用开发。 目前主要产品有：OA、Office批注签名控件、Web在线编辑控件、Office在线编辑控件、JAVA文件上传组件、CMS系统、论坛、博客等，目标是面向软件开发商提供专业的VC控件和JAVA组件、面向中小型企业提供专业OA解决方案，同时将发布一些JAVA开源作品，与大家一起探讨。

　　工作室将本着诚信负责的精神，竭诚地服务于客户！
　　
　　走IT人的路，让别人去说吧！
</TEXTAREA> 
</TD></TR>
                    <TR>
                      <TD colSpan=2>开发团队</TD></TR>
                    <TR>
                      <TD colSpan=2>
              <MARQUEE scrollAmount=1 direction=up 
                        height=30>项目策划：镇江云网软件技术有限公司</MARQUEE></TD></TR></TBODY></TABLE></TR></TBODY></TABLE></DIV></TD>
          <TD width=1 background=images/tab_bg.gif><IMG height=1 
            src="images/tab_bg.gif" width=1></TD></TR></TBODY></TABLE></TD></TR>
  <TR>
    <TD background=images/tab_bg.gif bgColor=#ffffff><IMG height=1 
      src="images/tab_bg.gif" width=1></TD></TR></TBODY></TABLE><!-- ACP Page Footer -->
<TABLE width="100%">
  <TBODY>
  <TR>
    <TD class=arial 
    style="PADDING-RIGHT: 10px; PADDING-LEFT: 10px; PADDING-BOTTOM: 10px; PADDING-TOP: 10px" 
    align=middle>Copyright &copy; 2004 All rights 
  reserved.</TD>
  </TR></TBODY></TABLE></BODY></HTML>
