<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Vector"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<HTML>
<HEAD>
<TITLE>title</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<LINK href="../admin/default.css" type=text/css rel=stylesheet>
<style>
<!--
*{margin:0;padding:0;border:0;}
body {
 font-family: arial, 宋体, serif;
 font-size:12px;
}
#nav {
 width:120px;
 line-height: 24px; 
 list-style-type: none;
 text-align:left;
}
#nav a {
 width: 120px; 
 display: block;
 padding-left:30px;
}
#nav li {
 background:#CCC;
 border-bottom:#FFF 1px solid;
 float:left;
}
#nav li a:hover{
 background:#698CCD;
}
#nav a:link  {
 color:#666; text-decoration:none;
}
#nav a:visited  {
 color:#666;text-decoration:none;
}
#nav a:hover  {
 color:#FFF;text-decoration:none;font-weight:bold;
}
#nav li ul {
 list-style:none;
 text-align:left;
}
#nav li ul li{ 
 background: #EBEBEB;
}

#nav li ul a{
 padding-left:30px;
 width:120px;
}
#nav li ul a:link  {
 color:#666; text-decoration:none;
}
#nav li ul a:visited  {
 color:#666;text-decoration:none;
}
#nav li ul a:hover {
 color:#F3F3F3;
 text-decoration:none;
 font-weight:normal;
 background: #698CCD url(../../forum/images/readme.gif) 10px 0.5em no-repeat;
}
#nav li:hover ul {
 left: auto;
}
#nav li.sfhover ul {
 left: auto;
}
#content {
 clear: left; 
}
#nav ul.collapsed {
 display: none;
}

#PARENT{
 width:140px;
 padding-left:10px;
}
-->
</style>
<BODY bgColor=#9aadcd leftMargin=0 topMargin=0 onLoad="DoMenu('ChildMenu1')">
<jsp:useBean id="privilege" scope="page" class="com.redmoon.blog.Privilege"/>
<BR>
<%
String rootpath = request.getContextPath();
long blogId = ParamUtil.getLong(request, "blogId");
UserConfigDb ucd = new UserConfigDb();
ucd = ucd.getUserConfigDb(blogId);
%>
<div id="PARENT">
  <ul id="nav">
    <li><a href="#Menu=ChildMenu1"  onclick="DoMenu('ChildMenu1')">博客管理</a>
      <ul id="ChildMenu1" class="collapsed">
        <li><a href="../myblog.jsp?blogId=<%=blogId%>" target="_blank">
          <lt:Label res="res.label.blog.user.frame" key="my_blog"/>
          </a></li>
        <li><a href="../../forum/addtopic_new.jsp?addFlag=blog&boardcode=<%=com.redmoon.forum.Leaf.CODE_BLOG%>&blogId=<%=blogId%>" target="mainFrame">
          <lt:Label res="res.label.blog.user.frame" key="post"/>
          </a></li>
        <li><a href="dir_m.jsp?blogId=<%=blogId%>" target="mainFrame">
          <lt:Label res="res.label.blog.user.frame" key="manage"/>
          </a></li>
        <li><a href="listtopic.jsp?blogId=<%=blogId%>" target="mainFrame">
          <lt:Label res="res.label.blog.user.frame" key="all_article"/>
          </a></li>
        <li><a href="../comment.jsp?blogId=<%=blogId%>" target="mainFrame">
          <lt:Label res="res.label.blog.user.frame" key="all_comment"/>
          </a></li>		  
        <li><a href="photo_catalog_list.jsp?blogId=<%=blogId%>" target="mainFrame">
          相册专辑
          </a></li>
		<li><a href="photo.jsp?blogId=<%=blogId%>" target="mainFrame">
          <lt:Label res="res.label.blog.user.frame" key="album"/>
          </a></li>
		<li><a href="photo_comment.jsp?blogId=<%=blogId%>" target="mainFrame">
          相片评论
          </a></li>		  
        <li><a href="music.jsp?blogId=<%=blogId%>" target="mainFrame">
          <lt:Label res="res.label.blog.user.frame" key="music"/>
          </a></li>
        <li><a href="music_comment.jsp?blogId=<%=blogId%>" target="mainFrame">
          歌曲评论
          </a></li>
		<li><a href="video.jsp?blogId=<%=blogId%>" target="mainFrame">
          <lt:Label res="res.label.blog.user.frame" key="video"/>
          </a></li>
        <li><a href="video_comment.jsp?blogId=<%=blogId%>" target="mainFrame">
          视频评论
          </a></li>		  		  
        <li><a href="link.jsp?blogId=<%=blogId%>" target="mainFrame">
          <lt:Label res="res.label.blog.user.frame" key="link"/>
          </a></li>
        <%if (ucd.getType()==UserConfigDb.TYPE_GROUP) {
	// 检查用户权限
	if (BlogGroupUserDb.canUserDo(request, blogId, Privilege.PRIV_ALL)) {
%>
        <li><a href="listmember.jsp?blog_id=<%=blogId%>" target="mainFrame">
          <lt:Label res="res.label.blog.user.frame" key="team_member"/>
          </a></li>
        <%}
}%>
        <li><a href="myfriend.jsp" target="mainFrame">
          <lt:Label res="res.label.blog.user.frame" key="friends"/>
          </a></li>
      </ul>
    </li>
    <li> <a href="#Menu=ChildMenu2" onClick="DoMenu('ChildMenu2')">博客参数</a>
      <ul id="ChildMenu2" class="collapsed">
        <li>
          <%
	com.redmoon.blog.Config cfg = com.redmoon.blog.Config.getInstance();
	int level = cfg.getIntProperty("modifyTemplateUserLevel");
	UserDb ud = new UserDb();
	ud = ud.getUser(privilege.getUser(request));
	if (ud.getUserLevelDb().getLevel()>=level) {  
%>
          <a href="usercss.jsp?blogId=<%=blogId%>" target="mainFrame">
          <lt:Label res="res.label.blog.user.frame" key="template"/>
          </a>
          <%}%>
        </li>
        <li><a href="myinfo.jsp" target="mainFrame">
          我的信息
          </a></li>		
        <li><a href="userconfig_edit.jsp?blogId=<%=blogId%>" target="mainFrame">
          <lt:Label res="res.label.blog.user.frame" key="config_info"/>
          </a></li>
      </ul>
    </li>
  </ul>
</div>
<script type=text/javascript><!--
var LastLeftID = "";

function menuFix() {
 var obj = document.getElementById("nav").getElementsByTagName("li");
 
 for (var i=0; i<obj.length; i++) {
  obj[i].onmouseover=function() {
   this.className+=(this.className.length>0? " ": "") + "sfhover";
  }
  obj[i].onMouseDown=function() {
   this.className+=(this.className.length>0? " ": "") + "sfhover";
  }
  obj[i].onMouseUp=function() {
   this.className+=(this.className.length>0? " ": "") + "sfhover";
  }
  obj[i].onmouseout=function() {
   this.className=this.className.replace(new RegExp("( ?|^)sfhover\\b"), "");
  }
 }
}

function DoMenu(emid)
{
 var obj = document.getElementById(emid); 
 obj.className = (obj.className.toLowerCase() == "expanded"?"collapsed":"expanded");
 if((LastLeftID!="")&&(emid!=LastLeftID))
 {
  document.getElementById(LastLeftID).className = "collapsed";
 }
 LastLeftID = emid;
}

function GetMenuID()
{

 var MenuID="";
 var _paramStr = new String(window.location.href);

 var _sharpPos = _paramStr.indexOf("#");
 
 if (_sharpPos >= 0 && _sharpPos < _paramStr.length - 1)
 {
  _paramStr = _paramStr.substring(_sharpPos + 1, _paramStr.length);
 }
 else
 {
  _paramStr = "";
 }
 
 if (_paramStr.length > 0)
 {
  var _paramArr = _paramStr.split("&");
  if (_paramArr.length>0)
  {
   var _paramKeyVal = _paramArr[0].split("=");
   if (_paramKeyVal.length>0)
   {
    MenuID = _paramKeyVal[1];
   }
  }
 }
 
 if(MenuID!="")
 {
  DoMenu(MenuID)
 }
}

GetMenuID();
menuFix();
--></script>
</BODY>
</HTML>
