<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.web.*"%>
<SCRIPT language=javascript>
//more javascript from http://www.smallrain.net
window.onload = enetgetMsg;
window.onresize = enetresizeDiv;
window.onerror = function(){}
var enetdivTop,enetdivLeft,enetdivWidth,enetdivHeight,enetdocHeight,enetdocWidth,enetobjTimer,i = 0;
function enetgetMsg()
{
	try{
		enetdivTop = parseInt(document.getElementById("enetMeng").style.top,10)
		enetdivLeft = parseInt(document.getElementById("enetMeng").style.left,10)
		enetdivHeight = parseInt(document.getElementById("enetMeng").offsetHeight,10)
		enetdivWidth = parseInt(document.getElementById("enetMeng").offsetWidth,10)
		enetdocWidth = document.body.clientWidth;
		enetdocHeight = document.body.clientHeight;
		document.getElementById("enetMeng").style.top = parseInt(document.body.scrollTop,10) + enetdocHeight + 10;// enetdivHeight
		document.getElementById("enetMeng").style.left = parseInt(document.body.scrollLeft,10) + enetdocWidth - enetdivWidth
		if (isShow()) {
			document.getElementById('enetMeng').style.visibility='visible';
			enetobjTimer = window.setInterval("enetmoveDiv()",10)
		}
		else {
			document.getElementById('enetMeng').style.visibility='hidden';
		}
	}
	catch(e){}
}

// 用于点击天气预报后的显示
function showWeather()
{
	enetcloseDiv();
	
	try{
		enetdivTop = parseInt(document.getElementById("enetMeng").style.top,10)
		enetdivLeft = parseInt(document.getElementById("enetMeng").style.left,10)
		enetdivHeight = parseInt(document.getElementById("enetMeng").offsetHeight,10)
		enetdivWidth = parseInt(document.getElementById("enetMeng").offsetWidth,10)
		enetdocWidth = document.body.clientWidth;
		enetdocHeight = document.body.clientHeight;
		document.getElementById("enetMeng").style.top = parseInt(document.body.scrollTop,10) + enetdocHeight + 10;// enetdivHeight
		document.getElementById("enetMeng").style.left = parseInt(document.body.scrollLeft,10) + enetdocWidth - enetdivWidth
		document.getElementById("enetMeng").style.visibility="visible"
		enetobjTimer = window.setInterval("enetmoveDiv()",10)
	}
	catch(e){}
} 
　
function enetresizeDiv()
{
	i+=1
	if(i>600) enetcloseDiv()
	try{
	enetdivHeight = parseInt(document.getElementById("enetMeng").offsetHeight,10)
	enetdivWidth = parseInt(document.getElementById("enetMeng").offsetWidth,10)
	enetdocWidth = document.body.clientWidth;
	enetdocHeight = document.body.clientHeight;
	document.getElementById("enetMeng").style.top = enetdocHeight - enetdivHeight + parseInt(document.body.scrollTop,10)
	document.getElementById("enetMeng").style.left = enetdocWidth - enetdivWidth + parseInt(document.body.scrollLeft,10)
	}
	catch(e){}
}
function enetmoveDiv()
{
	try
	{
		if(parseInt(document.getElementById("enetMeng").style.top,10) <= (enetdocHeight - enetdivHeight + parseInt(document.body.scrollTop,10)))
		{
			window.clearInterval(enetobjTimer)
			enetobjTimer = window.setInterval("enetresizeDiv()",1)
		}
		enetdivTop = parseInt(document.getElementById("enetMeng").style.top,10)
		document.getElementById("enetMeng").style.top = enetdivTop - 3
	}
	catch(e){}
}

function enetcloseDiv()
{
	i = 0;
	document.getElementById('enetMeng').style.visibility='hidden';
	if(enetobjTimer) window.clearInterval(enetobjTimer)
}

// cookie操作
function getCookieVal(offset)
{
	var endstr=document.cookie.indexOf(";",offset);
	if(endstr==-1)
		endstr=document.cookie.length;
	return unescape(document.cookie.substring(offset,endstr));
}

function GetCookie(name)
{
	var arg=name+"=";
	var alen=arg.length;
	var clen=document.cookie.length;
	var i=0;
	while(i<clen)
	{
		var j=i+alen;
		if(document.cookie.substring(i,j)==arg)
			return getCookieVal(j);
		i=document.cookie.indexOf(" ",i)+1;
		if(i==0) 
			break;
	}
	return null;
}
function SetCookie(name,value)
{	
	var argv=SetCookie.arguments;
	var argc=SetCookie.arguments.length;
	var expires=(2<argc)?argv[2]:null;
	var path=(3<argc)?argv[3]:null;
	var domain=(4<argc)?argv[4]:null;
	var secure=(5<argc)?argv[5]:false;
	document.cookie=name+"="+escape(value)+((expires==null)?"":("; expires="+expires.toGMTString()))+((path==null)?"":("; path="+path))+((domain==null)?"":("; domain="+domain))+((secure==true)?"; secure":"");
}

function setShowTime() {
	var today=new Date();
	var expireDate=new Date();
	// 保存一天
	expireDate.setTime(expireDate.getTime()+1000*60*60*24);	
	SetCookie("weather_time", today.getTime(), expireDate);
}

function getShowTime() {
	var today = new Date();
	var r = 0;

	try{
		r = today.getTime();
		var t = parseInt(GetCookie("weather_time"))
		// 如果cookie不存在
		if (isNaN(t)) {
			setShowTime();
			r = 0;
		}
		else
			r = t;
	}
	catch(e){}
	return r;
}

// 根据cookie中记录的上次显示的时间，如果间隔超过1000*60*30半小时即再次显示预报
function isShow() {
	var today = new Date();
	try {
		var lastTime = getShowTime();
		// alert(today.getTime()-lastTime);
	}
	catch (e) {}
	
	if (today.getTime()-lastTime>1000*60*30) {
		setShowTime();
		return true;
	}
	else
		return false;
}
</SCRIPT><DIV id=enetMeng 
style="BORDER-RIGHT: #455690 1px solid; BORDER-TOP: #a6b4cf 1px solid; Z-INDEX: 99999; LEFT: 0px; VISIBILITY: hidden; BORDER-LEFT: #a6b4cf 1px solid; WIDTH: 241px; BORDER-BOTTOM: #455690 1px solid; POSITION: absolute; TOP: 500px; HEIGHT: 157px">
  <TABLE WIDTH=255 BORDER=0 CELLPADDING=0 CELLSPACING=0 bgcolor="#E3FDEF">
    <TR>
      <TD height="26" align="center" valign="middle" background="skin/default/images/bg1.gif"><span class="text_title"><%=Global.AppName%>&nbsp;-&nbsp;天气预报</span></TD>
      <TD height="26" align="center" valign="middle" background="skin/default/images/bg1.gif"><a href="javascript:enetcloseDiv()">×</a></TD>
    </TR>
    <TR>
      <TD height="122" colspan="2" align="center" valign="middle"><%@ include file="58248.htm"%></TD>
    </TR>
  </TABLE>
</div>

                          
  