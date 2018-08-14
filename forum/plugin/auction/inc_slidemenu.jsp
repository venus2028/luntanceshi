<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<script>
function findObj(theObj, theDoc)
{
  var p, i, foundObj;
  
  if(!theDoc) theDoc = document;
  if( (p = theObj.indexOf("?")) > 0 && parent.frames.length)
  {
    theDoc = parent.frames[theObj.substring(p+1)].document;
    theObj = theObj.substring(0,p);
  }
  if(!(foundObj = theDoc[theObj]) && theDoc.all) foundObj = theDoc.all[theObj];
  for (i=0; !foundObj && i < theDoc.forms.length; i++) 
    foundObj = theDoc.forms[i][theObj];
  for(i=0; !foundObj && theDoc.layers && i < theDoc.layers.length; i++) 
    foundObj = findObj(theObj,theDoc.layers[i].document);
  if(!foundObj && document.getElementById) foundObj = document.getElementById(theObj);
  
  return foundObj;
}

function ShowChild(imgobj, name)
{
	var tableobj = findObj("childof"+name);
	if (tableobj.style.display=="none")
	{
		tableobj.style.display = "";
		if (imgobj.src.indexOf("i_puls-root-1.gif")!=-1)
			imgobj.src = "admin/images/i_puls-root.gif";
		if (imgobj.src.indexOf("i_plus-1-1.gif")!=-1)
			imgobj.src = "admin/images/i_plus2-2.gif";
		if (imgobj.src.indexOf("i_plus-1.gif")!=-1)
			imgobj.src = "admin/images/i_plus2-1.gif";
	}
	else
	{
		tableobj.style.display = "none";
		if (imgobj.src.indexOf("i_puls-root.gif")!=-1)
			imgobj.src = "admin/images/i_puls-root-1.gif";
		if (imgobj.src.indexOf("i_plus2-2.gif")!=-1)
			imgobj.src = "admin/images/i_plus-1-1.gif";
		if (imgobj.src.indexOf("i_plus2-1.gif")!=-1)
			imgobj.src = "admin/images/i_plus-1.gif";
	}
}

// 折叠目录
function shrink() {
   var imgAll = document.getElementById("dirDiv").getElementsByTagName("img");
   for(var i=0; i<imgAll.length; i++) {
		var imgObj = imgAll[i];
		try {
			if (imgObj.attributes['tableRelate']!=null && imgObj.attributes['tableRelate']!="") {
				ShowChild(imgObj, imgObj.attributes['tableRelate'].nodeValue);
			}
		}
		catch (e) {
		}
   }
}
</script>
<div id="dirDiv" style="display:none">
<%
com.redmoon.forum.plugin.auction.Directory dir = new com.redmoon.forum.plugin.auction.Directory();
com.redmoon.forum.plugin.auction.Leaf leaf = dir.getLeaf(com.redmoon.forum.plugin.auction.Leaf.CODE_ROOT);
com.redmoon.forum.plugin.auction.DirectoryView tv = new com.redmoon.forum.plugin.auction.DirectoryView(leaf);
String pageUrl = ParamUtil.get(request, "pageUrl");
if (pageUrl.equals(""))
	tv.ListSimple(request, out, "", request.getContextPath() + "/forum/plugin/auction/search.jsp?pluginCode=" + AuctionUnit.code + "&catalogCode=", "", "" ); // "tbg1", "tbg1sel");
else
	tv.ListSimple(request, out, "", request.getContextPath() + "/" + pageUrl, "", "" ); // "tbg1", "tbg1sel");
%>
</div>
<script>
shrink();
</script>
<SCRIPT language="JavaScript1.2">
NS6 = (document.getElementById&&!document.all)
IE = (document.all)
NS = (navigator.appName=="Netscape" && navigator.appVersion.charAt(0)=="4")
tempBar='';barBuilt=0;ssmItems=new Array();
moving=setTimeout('null',1)
function moveOut() {
if ((NS6||NS)&&parseInt(ssm.left)<0 || IE && ssm.pixelLeft<0) {
clearTimeout(moving);moving = setTimeout('moveOut()', slideSpeed);slideMenu(10)}
else {clearTimeout(moving);moving=setTimeout('null',1)}};
function moveBack() {clearTimeout(moving);moving = setTimeout('moveBack1()', waitTime)}
function moveBack1() {
if ((NS6||NS) && parseInt(ssm.left)>(-menuWidth) || IE && ssm.pixelLeft>(-menuWidth)) {
clearTimeout(moving);moving = setTimeout('moveBack1()', slideSpeed);slideMenu(-10)}
else {clearTimeout(moving);moving=setTimeout('null',1)}}
function slideMenu(num){
if (IE) {ssm.pixelLeft += num;}
if (NS||NS6) {ssm.left = (parseInt(ssm.left)+num)+"px";}
if (NS) {bssm.clip.right+=num;bssm2.clip.right+=num;}}
function makeStatic() {
if (NS||NS6) {winY = window.pageYOffset;}
if (IE) {winY = document.body.scrollTop;}
if (NS6||IE||NS) {
if (winY!=lastY&&winY>Yoffset-staticYOffset) {
smooth = .2 * (winY - lastY - Yoffset + staticYOffset);}
else if (Yoffset-staticYOffset+lastY>Yoffset-staticYOffset) {
smooth = .2 * (winY - lastY - (Yoffset-(Yoffset-winY)));}
else {smooth=0}
if(smooth > 0) smooth = Math.ceil(smooth);
else smooth = Math.floor(smooth);
if (IE) bssm.pixelTop+=smooth;
if (NS6||NS) bssm.top=parseInt(bssm.top)+smooth
lastY = lastY+smooth;
setTimeout('makeStatic()', 1)}}

function initSlide() {
if (NS6){ssm=document.getElementById("thessm").style;bssm=document.getElementById("basessm").style;
ssm.visibility="visible";
ssm.left=(-menuWidth)+"px";
}
else if (IE) {ssm=document.all("thessm").style;bssm=document.all("basessm").style
bssm.visibility = "visible";
ssm.pixelLeft=-menuWidth;
}
else if (NS) {bssm=document.layers["basessm1"];
bssm2=bssm.document.layers["basessm2"];ssm=bssm2.document.layers["thessm"];
bssm2.clip.left=0;ssm.visibility = "show";
}
if (menuIsStatic=="yes") makeStatic();
}

function buildMenu() {
if (IE||NS6) {document.write('<DIV ID="basessm" style="visibility:hidden;Position : Absolute ;Left : '+Xoffset+' ;Top : '+Yoffset+' ;Z-Index : 20;width:'+(menuWidth+barWidth+2)+'"><DIV ID="thessm" style="Position : Absolute ;Left : '+(-menuWidth)+' ;Top : 0 ;Z-Index : 20;" onmouseover="moveOut()" onmouseout="moveBack()">')}
if (NS) {document.write('<LAYER name="basessm1" top="'+Yoffset+'" LEFT='+Xoffset+' visibility="show"><ILAYER name="basessm2"><LAYER visibility="hide" name="thessm" bgcolor="'+menuBGColor+'" left="'+(-menuWidth)+'" onmouseover="moveOut()" onmouseout="moveBack()">')}
if (NS6){document.write('<table border="0" cellpadding="0" cellspacing="0" width="'+(menuWidth+barWidth+2)+'"><TR><TD>')}
document.write('<table border="0" height=200 cellpadding="0" cellspacing="0" width="'+(menuWidth+barWidth+2)+'">');
document.write('<tr><td valign="top" style="padding:3px" bgcolor="'+menuBGColor+'">' + document.getElementById("dirDiv").innerHTML + '</td><td align=center valign=top width=30><div width=30 title="商品目录菜单" style="cursor:hand;filter:Alpha(opacity=80);color:#eeeeee;height:84px;background-image:url(<%=request.getContextPath()%>/forum/plugin/auction/images/menu_bg.gif)"><b>' + barText + '</b></div></td></tr>');
document.getElementById("dirDiv").innerHTML = "";

document.write('</table>')
if (NS6){document.write('</TD></TR></TABLE>')}
if (IE||NS6) {document.write('</DIV></DIV>')}
if (NS) {document.write('</LAYER></ILAYER></LAYER>')}

theleft=-menuWidth;lastY=0;
setTimeout('initSlide();', 1)}
Yoffset=150;
Xoffset=0;
staticYOffset=30;
slideSpeed=20
waitTime=100;

menuBGColor="#EEEAE3";
menuIsStatic="no"; // 是否随滚动条滚动
menuWidth=220;
menuCols=2;
hdrFontFamily="verdana";
hdrFontSize="2";
hdrFontColor="white";
hdrBGColor="#170088";
hdrAlign="left";
hdrVAlign="center";
hdrHeight="15";
linkFontFamily="Verdana";
linkFontSize="2";
linkBGColor="white";
linkOverBGColor="#FFFF99";
linkTarget="_top";
linkAlign="Left";
barBGColor="#444444";
barFontFamily="Verdana";
barFontSize="2";
barFontColor="white";
barVAlign="center";
barWidth=30;
barText="";//"商<BR>品<BR>目<BR>录"; 

buildMenu();
</SCRIPT>                         
  