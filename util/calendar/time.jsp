<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import = "cn.js.fan.util.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<HTML>
<title> <lt:Label res="res.label.util.time" key="select_time"/> </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script>
function onOk() {
	window.returnValue = "";
}
</script>
<style>
*{
 font:12px;
 letter-spacing:0px;
}
body{
 background-color:#E5E9F2;
 overflow:hidden;
 margin:0;
 border:0px;
}
#titleYear{
 text-align:center;
 padding-top:3px;
 width:120px;
 height:20px;
 border:solid #E5E9F2;
 border-width:0px 1px 1px 0px;
 background-color:#A4B9D7;
 color:#000;
 cursor:default;
}
#weekNameBox{
 width:282px;
 border-bottom:0;
}
.weekName{
 text-align:center;
 padding-top:4px;
 width:40px;
 height:20px;
 border:solid #E5E9F2;
 border-width:0px 1px 1px 0px;
 background-color:#C0D0E8;
 color:#243F65;
 cursor:default;
}
.controlButton{
 font-family: Webdings;
 font:9px;
 text-align:center;
 padding-top:2px;
 width:40px;
 height:20px;
 border:solid #E5E9F2;
 border-width:0px 1px 1px 0px;
 background-color:#A4B9D7;
 color:#243F65;
 cursor:default;
}

.Ctable{
 width:282px;
 margin-bottom:20px;
}
.Ctable span{
 font:9px verdana;
 font-weight:bold;
 color:#243F65;
 text-align:center;
 padding-top:4px;
 width:40px;
 height:26px;
 border:solid #C0D0E8;
 border-width:0px 1px 1px 0px;
 cursor:default;
}
.Cdate{
 background-color:#E5E9F2;
}
.Ctable span.OtherMonthDate{
 color:#999;
 background-color:#f6f6f6;
}

.selectBox{
 cursor:hand;
 font:9px verdana;
 width:80px;
 position:absolute;
 border:1px solid #425E87;
 overflow-y:scroll;
 overflow-x:hidden;
 background-color:#fff;
 FILTER:progid:DXImageTransform.Microsoft.Shadow(Color=#999999,offX=10,offY=10,direction=120,Strength=5);
 SCROLLBAR-FACE-COLOR: #E5E9F2;
 SCROLLBAR-HIGHLIGHT-COLOR: #E5E9F2;
 SCROLLBAR-SHADOW-COLOR: #A4B9D7; 
 SCROLLBAR-3DLIGHT-COLOR: #A4B9D7; 
 SCROLLBAR-ARROW-COLOR:  #000000; 
 SCROLLBAR-TRACK-COLOR: #eeeee6; 
 SCROLLBAR-DARKSHADOW-COLOR: #ffffff;
}
.selectBox nobr{
 padding:0px 0px 2px 5px;
 width:100%;
 color:#000;
 letter-spacing:2px;
 text-decoration:none;
}

.STYLE1 {
	color: #FFFFFF;
	font-weight: bold;
}
</style>
<body onselectstart="return false">
<table width="260" height="105" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td height="24" colspan="3" align="center" bgcolor="#7C93D3"><span class="STYLE1"><lt:Label res="res.label.util.time" key="please_select_time"/></span></td>
  </tr>
  <tr>
    <td width="92" height="30"><lt:Label res="res.label.util.time" key="hour"/>
	<select name=hour>
	<script>
	for (var i=1; i<=24; i++) {
		var h = i;
		if (i<10)
			h = "0" + i;
		document.write("<option value='" + h + "'>" + h + "</option>");
	}
	</script></select>	</td>
    <td width="92"><lt:Label res="res.label.util.time" key="minute"/>
	<select name=minute>
	<script>
	for (var i=0; i<=60; i++) {
		var h = i;
		if (i<10)
			h = "0" + i;
		document.write("<option value='" + h + "'>" + h + "</option>");
	}
	</script></select>	</td>
    <td width="76"><lt:Label res="res.label.util.time" key="second"/>
	<select name=second>
	<script>
	for (var i=0; i<=60; i++) {
		var h = i;
		if (i<10)
			h = "0" + i;
		document.write("<option value='" + h + "'>" + h + "</option>");
	}
	hour.value = "12";
	minute.value = "00";
	second.value = "00"; 
	</script></select>	</td>
  </tr>
  <tr>
    <td height="30" colspan="3" align="center"><input type="button" value=<lt:Label key="ok"/> onClick="window.returnValue=hour.value+':'+minute.value+':' +second.value; window.close()" >
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <input type=button value=<lt:Label key="close"/> onClick="window.close()"></td>
  </tr>
</table>
</body>
</HTML>