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
.anylinkcss{
/*border:1px solid gray;*/
/*border-bottom-width: 0;*/
/*font:normal 12px Verdana;*/
z-index: 100;
background-color: white;
}

.shadetabs_bar {
color: #eeffff;
font-weight: bold;
background-image: url("../forum/skin/bluenew/images/bg1.gif");
height: 22px;
width:530px;
}

.shadetabs{
padding: 0px 0;
margin-left: 0;
margin-top: 1px;
margin-bottom: 0px;
font: 9pt;
list-style-type: none;
text-align: left; /*set to left, center, or right to align the menu as desired*/
width:530px;
}

.shadetabs li{
display: inline;
margin: 0;
}

.shadetabs li a{
display:block;
float:left;


text-decoration: none;
padding: 3px 27px;
width: 97px;
margin: 0px;
border: 0px solid #778;
color: #2d2b2b;
background: white url(../forum/skin/bluenew/images/shade.gif) top left repeat-x;
}

.shadetabs li a:visited{
margin-top: 1px;
color: #2d2b2b;
}

.shadetabs li a:hover{
text-decoration: underline;
color: #2d2b2b;
}

.shadetabs li.selected{
position: relative;
top: 1px;
}

.shadetabs li.selected a{ /*selected main tab style */
background-image: url(../forum/skin/bluenew/images/shadeactive.gif);
border-bottom-color: white;
}

.shadetabs li.selected a:hover{ /*selected main tab style */
text-decoration: none;
}

.tabcontentstyle{ /*style of tab content oontainer*/
/*border: 1px solid gray;*/
/*width:330px;*/
/*height:220px;*/
margin-bottom: 1em;
padding: 10px;
/*overflow-x:hidden;*/
/*overflow-y:scroll;*/
}

.tabcontent{
display:none;
}

@media print {
.tabcontent {
display:block!important;
}
}

/*
A.linkTag {
	color: green;
	text-decoration: none;
	BORDER-BOTTOM: 1px dashed;	
}
A.linkTag:visited
{
	color: green;
	text-decoration: none;
	BORDER-BOTTOM: 1px dashed;	
}
A.linkTag:hover {
	color: green;
	text-decoration: none;
	BORDER-BOTTOM: 2px dashed;
}
*/

/*清除float*/
.clear{ clear: both; font-size:1px; visibility: hidden; }
</style>
<script type="text/javascript" src="../inc/ajaxtabs/ajaxtabs.jsp"></script><br>

<div id="anylinkmenu1" class="anylinkcss">
<div class="shadetabs_bar"">	
<ul id="maintab" class="shadetabs">
<li class="selected"><a href="#default" rel="ajaxcontentarea"><lt:Label res="res.label.forum.showtopic" key="emote1"/></a></li>
<li><a href="cache.jsp" rel="ajaxcontentarea"><lt:Label res="res.label.forum.showtopic" key="emote2"/></a></li>
<li><a href="inc_emot_default.jsp" rel="ajaxcontentarea"><lt:Label res="res.label.forum.showtopic" key="emote_default"/></a></li>
</ul>
<div class="clear"></div>
</div>
<div id="ajaxcontentarea" class="tabcontentstyle">
sssssssssssssssssssssss
ddddddddddddddddddddddd
eeeeeeeeeeeeeeeeeeeeeeee
ffffffffffffffffffffff
</div>
<script type="text/javascript">
//Start Ajax tabs script for UL with id="maintab" Separate multiple ids each with a comma.
startajaxtabs("maintab")
</script>	
</div>
