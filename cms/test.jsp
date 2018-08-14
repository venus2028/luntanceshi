<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="java.util.*,
				 java.text.*,
				 cn.js.fan.kernel.*,
				 cn.js.fan.util.*,
				 cn.js.fan.module.cms.*,
				 cn.js.fan.cache.jcs.*,
				 cn.js.fan.web.*,
				 com.redmoon.forum.*,
				 com.redmoon.forum.ui.*,
				 cn.js.fan.module.pvg.*"
%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="default.css" rel="stylesheet" type="text/css">
<style>
.tabMenuCss{
/*border:1px solid gray;*/
/*border-bottom-width: 0;*/
/*font:normal 12px Verdana;*/
z-index: 100;
margin: 10px;
}

.tabMenuBar {
color: #eeffff;
font-weight: bold;
height: 25px;
width:650px;
}

.tabMenuItemsCss{
padding: 0px 0;
margin-left: 0;
margin-top: 1px;
margin-bottom: 0px;
font: 9pt;
list-style-type: none;
text-align: left; /*set to left, center, or right to align the menu as desired*/
width:650px;
}

.tabMenuItemsCss li{
display: inline;
margin: 0;
}

.tabMenuItemsCss li a{
display:block;
float:left;
height:18px;

text-decoration: none;
text-align:center;
padding: 6px 0px 0px;
width: 97px;
margin: 0px;
margin-right: 3px;
border: 0px solid #778;
color: #2d2b2b;
background: white url(../images/tab_inactive.gif) top left repeat-x;
}

.tabMenuItemsCss li a:visited{
margin-top: 0px;
color: #2d2b2b;
}

.tabMenuItemsCss li a:hover{
text-decoration: underline;
color: #2d2b2b;
}

.tabMenuItemsCss li.selected{
position: relative;
top: 1px;
}

.tabMenuItemsCss li.selected a{ /*selected main tab style */
background-image: url(../images/tab_active.gif);
border-bottom-color: white;
position: relative;
top: 0.02em;
}

.tabMenuItemsCss li.selected a:hover{ /*selected main tab style */
text-decoration: none;
}

.tabContentAreaCss{ /*style of tab content oontainer*/
border: solid #B0BEC7;
border-width: 1px 1px 1px 1px;
background-color: white;
width:650px;
height:220px;
margin-bottom: 1em;
padding: 10px;
/*overflow-x:hidden;*/
/*overflow-y:scroll;*/
}
/*清除float*/
.clear{ clear: both; font-size:1px; visibility: hidden; }
</style>
<script type="text/javascript" src="../inc/ajaxtabs/ajaxtabs.jsp"></script><br>

<div id="tabMenu" class="tabMenuCss">
<div class="tabMenuBar">	
<ul id="tabItems" class="tabMenuItemsCss">
<li class="selected"><a href="#default" rel="contentArea"><lt:Label res="res.label.forum.showtopic" key="emote1"/></a></li>
<li><a href="cache_jvm.jsp" rel="contentArea"><lt:Label res="res.label.forum.showtopic" key="emote2"/></a></li>
<li><a href="inc_emot_default.jsp" rel="contentArea"><lt:Label res="res.label.forum.showtopic" key="emote_default"/></a></li>
</ul>
<div class="clear"></div>
</div>
<div id="contentArea" class="tabContentAreaCss">
sssssssssssssssssssssss
ddddddddddddddddddddddd
eeeeeeeeeeeeeeeeeeeeeeee
ffffffffffffffffffffff
</div>
<script type="text/javascript">
//Start Ajax tabs script for UL with id="tabItems" Separate multiple ids each with a comma.
startajaxtabs("tabItems")
</script>	
</div>
